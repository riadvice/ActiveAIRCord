/*
   Copyright (C) 2012-2014 RIADVICE <ghazi.triki@riadvice.tn>

   This program is free software: you can redistribute it and/or modify
   it under the terms of the GNU General Public License as published by
   the Free Software Foundation, either version 3 of the License, or
   (at your option) any later version.

   This program is distributed in the hope that it will be useful,
   but WITHOUT ANY WARRANTY; without even the implied warranty of
   MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
   GNU General Public License for more details.

   You should have received a copy of the GNU General Public License
   along with this program. If not, see <http://www.gnu.org/licenses/>.
 */
package com.riadvice.activeaircord
{
    import com.riadvice.activeaircord.exceptions.RelationshipException;
    import com.riadvice.activeaircord.relationship.BelongsTo;
    import com.riadvice.activeaircord.relationship.HasAndBelongsToMany;
    import com.riadvice.activeaircord.relationship.HasMany;
    import com.riadvice.activeaircord.relationship.HasOne;
    import com.riadvice.activeaircord.relationship.IRelationship;

    import flash.data.SQLResult;
    import flash.utils.Dictionary;

    import org.as3commons.lang.ArrayUtils;
    import org.as3commons.lang.ClassUtils;
    import org.as3commons.lang.DictionaryUtils;
    import org.as3commons.lang.ObjectUtils;

    public class Table
    {

        public var clazz : *;
        public var conn : SQLiteConnection;
        public var pk : Array;
        public var lastSql : String;

        public var columns : Dictionary = new Dictionary(true);
        public var tableName : String;
        public var dbName : String;
        public var sequence : String;
        public var callback : Callback;
        private var relationships : Dictionary = new Dictionary(true);
        private static var cache : Dictionary = new Dictionary(true);

        public static function load( className : String ) : Table
        {
            if (!cache[className])
            {
                cache[className] = new Table(className);
                Table(cache[className]).setAssociations();
            }
            return cache[className];
        }

        public static function clearCache( modelClass : Class = null ) : void
        {
            if (modelClass && DictionaryUtils.containsKey(cache, modelClass))
            {
                delete cache[modelClass];
            }
            else
            {
                cache = new Dictionary();
            }
        }

        public function Table( className : String = null )
        {
            clazz = Reflections.getInstance().add(className).getClass(className);
            reestablishConnection(false);
            setTableName();
            getMetaData();
            setPrimaryKey();
            setDelegates();

            callback = new Callback(className);
            callback.register("before_save", function( model : Model ) : void {model.setTimestamps();}, new Hash(true, ["prepend"], [true]));
            callback.register("after_save", function( model : Model ) : void {model.resetDirty();}, new Hash(true, ["prepend"], [true]));
        }

        public function reestablishConnection( close : Boolean = true ) : *
        {
            var connection : String = ClassUtils.getProperties(clazz, true)['connection'];
            if (close)
            {
                ConnectionManager.dropConnection(connection);
                clearCache();
            }
            return (conn = ConnectionManager.getConnection(connection));
        }

        public function createJoins( joins : Dictionary ) : *
        {
            if (!(joins is Dictionary))
            {
                return joins;
            }

            var ret : String, space : String, value : String = "";
            for each (var key : String in joins)
            {
                value = joins[key];
                ret += space;

                var existingTables : Dictionary = new Dictionary(true);
                if (value.indexOf(SQL.JOIN + " ") == -1)
                {
                    if (DictionaryUtils.containsKey(relationships, value))
                    {
                        var rel : IRelationship = getRelationship(value);
                        var alias : String;
                        if (DictionaryUtils.containsKey(existingTables, rel.className))
                        {
                            alias = value;
                            existingTables[rel.className]++;
                        }
                        else
                        {
                            existingTables[rel.className] = true;
                            alias = null;
                        }

                        ret += rel.constructInnerJoinSql(this, false, alias);
                    }
                    else
                    {
                        throw new RelationshipException("Relationship named " + value + " has not been declared for class: {" + this.clazz + "}");
                    }
                }
                else
                {
                    ret += value;
                }
            }
            return ret;
        }

        public function optionsToSql( options : Dictionary ) : SQLBuilder
        {
            var table : String = DictionaryUtils.containsKey(options, "from") ? options["from"] : getFullyQualifiedTableName();
            var sql : SQLBuilder = new SQLBuilder(conn, table);

            if (DictionaryUtils.containsKey(options, "joins"))
            {
                sql.joins(createJoins(options["join"]));

                // by default, an inner join will not fetch the fields from the joined table
                if (!DictionaryUtils.containsKey(options, "select"))
                {
                    options["select"] = getFullyQualifiedTableName() + ".*";
                }
            }

            if (DictionaryUtils.containsKey(options, "select"))
            {
                sql.select(options["select"]);
            }

            if (DictionaryUtils.containsKey(options, "conditions"))
            {
                if (!(options["conditions"] is Dictionary))
                {
                    if (options["conditions"] is String)
                    {
                        options["conditions"] = [options["conditions"]];
                    }

                        // TODO missing condition handling
                }
                else
                {
                    if (options["mapped_names"])
                    {
                        options["conditions"] = mapNames(options["conditions"], options["mapped_names"]);
                    }

                    sql.where(options["conditions"]);
                }
            }

            for each (var sqlOption : String in["order", "limit", "offset", "group", "having"])
            {
                if (DictionaryUtils.containsKey(options, sqlOption))
                {
                    sql[sqlOption](options[sqlOption]);
                }
            }

            return sql;
        }

        public function find( options : Dictionary ) : Array
        {
            var sql : SQLBuilder = optionsToSql(options);
            var readOnly : Boolean = DictionaryUtils.containsKey(options, "readonly") && options["readonly"];
            var eagerLoad : Array = DictionaryUtils.containsKey(options, "include") ? options["include"] : null;
            return findBySql(sql.toString(), sql.whereValues, readOnly, eagerLoad);
        }

        public function findBySql( sql : String, values : Array = null, readonly : Boolean = false, includes : Array = null ) : Array
        {
            lastSql = sql;
            var collectAttrsForIncludes : Boolean = (includes == null) ? false : true;
            var list : Array = [];
            var attrs : Array = [];

            var result : SQLResult = conn.query(sql, processData(values));
            for each (var row : Object in result.data)
            {
                var model : Model = ClassUtils.newInstance(clazz, [row, false, true, false]);
                if (readonly)
                {
                    model.readonly();
                }
                if (collectAttrsForIncludes)
                {
                    attrs.push(model.attributes());
                }
                list.push(model);
            }

            if (collectAttrsForIncludes && !ArrayUtils.isEmpty(list))
            {
                executeEagerLoad(list, attrs, includes);
            }

            return list;
        }

        private function executeEagerLoad( models : Array = null, attrs : Array = null, includes : Array = null ) : void
        {
        }

        public function getColumnByInflectedName( inflectedName : String ) : Column
        {
            for each (var column : Column in columns)
            {
                if (column.inflectedName == inflectedName)
                {
                    return column;
                }
            }
            return null;
        }

        public function getFullyQualifiedTableName( quoteName : Boolean = true ) : String
        {
            var table : String = "";
            if (quoteName)
            {
                table = conn.quoteName(tableName);
            }
            else
            {
                table = tableName;
            }
            if (dbName)
            {
                table = conn.quoteName(dbName) + "." + table;
            }
            return table;
        }

        public function getRelationship( name : String, strict : Boolean = false ) : IRelationship
        {
            if (hasRelationship(name))
            {
                return relationships[name];
            }
            else
            {
                throw new RelationshipException("Relationship named " + name + " has not been declared for class: {" + this.clazz + "}");
            }
        }

        public function hasRelationship( name : String ) : Boolean
        {
            return DictionaryUtils.containsKey(relationships, name);
        }

        public function insert( data : *, pk : String = null, sequenceName : String = null ) : *
        {
            var data : * = processData(data);

            var sql : SQLBuilder = new SQLBuilder(conn, getFullyQualifiedTableName());
            sql.insert(data, pk, sequenceName);

            // FIXME
            var values : Array = data;
            return conn.query(lastSql = sql.toString(), values);
        }

        public function update( data : *, where : Dictionary ) : *
        {
            var data : * = processData(data);

            var sql : SQLBuilder = new SQLBuilder(conn, getFullyQualifiedTableName());
            sql.update(data).where(where);

            var values : Array = sql.bindValues();
            return conn.query(lastSql = sql.toString(), values);
        }

        public function destroy( data : * ) : String
        {
            var data : * = processData(data);
            var sql : SQLBuilder = new SQLBuilder(conn, getFullyQualifiedTableName());
            sql.destroy(data);

            var values : Array = sql.bindValues();
            return conn.query(lastSql = sql.toString(), values);
        }

        private function addRelationship( relationship : IRelationship ) : void
        {
            relationships[relationship.attributeName] = relationship;
        }

        private function getMetaData() : void
        {
            columns = conn.columns(tableName);
        }

        private function mapNames( hash : Dictionary, map : Array ) : void
        {
        }

        private function processData( hash : * ) : *
        {
            // TODO
            if (!hash)
            {
                return hash;
            }
            return hash;
        }

        private function setPrimaryKey() : void
        {
            var primaryKey : * = clazz["pk"] || clazz["primary_key"];
            if (primaryKey)
            {
                pk = (primaryKey is Array) ? primaryKey : [primaryKey];
            }
            else
            {
                pk = [];

                for each (var column : Column in columns)
                {
                    if (column.primaryKey)
                    {
                        pk.push(column.inflectedName);
                    }
                }
            }
        }

        private function setTableName() : void
        {
            var table : String = clazz["table"] || clazz["tableName"];
            if (table)
            {
                tableName = table;
            }
            else
            {
                tableName = Inflector.tableize(ClassUtils.getName(clazz));
            }

            var db : String = clazz["db"] || clazz["dbName"];
            if (db)
            {
                dbName = db;
            }
        }

        private function setAssociations() : void
        {
            var staticProperties : Array = ObjectUtils.getKeys(ClassUtils.getProperties(clazz, true));
            for each (var propertyName : String in staticProperties)
            {
                var definitions : * = clazz[propertyName];
                if (!definitions)
                {
                    continue;
                }
                var relationship : IRelationship;
                var definition : Dictionary = new Dictionary();
                switch (propertyName)
                {
                    case "has_many":
                        relationship = new HasMany(definition);
                        break;

                    case "has_one":
                        relationship = new HasOne(definition);
                        break;

                    case "belongs_to":
                        relationship = new BelongsTo(definition);
                        break;

                    case "has_and_belongs_to_many":
                        relationship = new HasAndBelongsToMany(definition);
                        break;
                }

                if (relationship)
                {
                    addRelationship(relationship);
                }
            }
        }

        private function setDelegates() : void
        {
            var delegates : Array = clazz["delegate"];
            var arr : Array = [];
            if (delegates)
            {
                // TODO
            }
        }

    }
}

