/*
   Copyright (C) 2012 Ghazi Triki <ghazi.nocturne@gmail.com>

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
package com.lionart.activeaircord
{
    import com.lionart.activeaircord.exceptions.RelationshipException;
    import com.lionart.activeaircord.relationship.IRelationship;

    import flash.utils.Dictionary;

    import mx.collections.ArrayCollection;

    import org.as3commons.lang.ClassUtils;
    import org.as3commons.lang.DictionaryUtils;

    public class Table
    {

        public var clazz : Class;
        public var conn : SQLiteConnection;
        public var pk : String;
        public var lastSql : String;

        public var columns : Array = [];
        public var tableName : String;
        public var dbName : String;
        public var sequence : String;
        public var callback : Callback;
        private var relationships : Dictionary = new Dictionary(true);
        private static var cache : Dictionary = new Dictionary(true);

        public static function load( modelClass : Class )
        {
            if (!cache[modelClass])
            {
                cache[modelClass] = new Table(modelClass);
                Table(cache[modelClass]).setAssociations();
            }
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

        public function Table( modelClass : Class = null )
        {
            clazz = Reflections.getInstance().add(modelClass).getClass(modelClass);
            reestablishConnection(false);
            setTableName();
            getMetaData();
            setPrimaryKey();
            setSequenceName();
            setDelegates();
            setSettersAndGetters();

            callback = new Callback(modelClass);
            callback.register('before_save', function( model : Model ) : void {model.setTimestamps();}, new AdvancedDictionary(true, ['prepend'], [true]));
            callback.register('after_save', function( model : Model ) : void {model.resetDirty();}, new AdvancedDictionary(true, ['prepend'], [true]));
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

            var ret : String, space : String, value : String = '';
            for each (var key : String in joins)
            {
                value = joins[key];
                ret += space;

                var existingTables : Dictionary = new Dictionary(true);
                if (value.indexOf(SQL.JOIN + ' ') == -1)
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
            var table : String = DictionaryUtils.containsKey(options, 'from') ? options['from'] : getFullyQualifiedTableName();
            var sql : SQLBuilder = new SQLBuilder(conn, table);

            if (DictionaryUtils.containsKey(options, 'joins'))
            {
                sql.joins(createJoins(options['join']));

                // by default, an inner join will not fetch the fields from the joined table
                if (!DictionaryUtils.containsKey(options, 'select'))
                {
                    options['select'] = getFullyQualifiedTableName() + '.*';
                }
            }

            if (DictionaryUtils.containsKey(options, 'select'))
            {
                sql.select(options['select']);
            }

            if (DictionaryUtils.containsKey(options, 'conditions'))
            {
                if (!(options['conditions'] is Dictionary))
                {
                    if (options['conditions'] is String)
                    {
                        options['conditions'] = [options['conditions']];
                    }

                        // TODO missing condition handling
                }
                else
                {
                    if (options['mapped_names'])
                    {
                        options['conditions'] = mapNames(options['conditions'], options['mapped_names']);
                    }

                    sql.where(options['conditions']);
                }
            }

            for each (var sqlOption : String in['order', 'limit', 'offset', 'group', 'having'])
            {
                if (DictionaryUtils.containsKey(options, sqlOption))
                {
                    sql[sqlOption](options[sqlOption]);
                }
            }

            return sql;
        }

        public function find( options : Dictionary ) : ArrayCollection
        {
            var sql : SQLBuilder = optionsToSql(options);
            var readOnly : Boolean = DictionaryUtils.containsKey(options, 'readonly') && options['readonly'];
            var eagerLoad : Array = DictionaryUtils.containsKey(options, 'include') ? options['include'] : null;
            return findBySql(sql.toString(), sql.whereValues, readOnly, eagerLoad);
        }

        public function findBySql( sql : String, values : Array = null, readonly : Boolean = false, includes : Array = null ) : ArrayCollection
        {
            return null;
        }

        private function executeEagerLoad( models : Array = null, attrs : Array = null, includes : Array = null )
        {

        }

        public function getColumnByInflected_name( inflectedName : String )
        {

        }

        public function getFullyQualifiedTableName( quoteName : Boolean = true ) : String
        {
            var table : String = '';
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

        public function insert( data : *, pk : String = null, sequenceName : String = null )
        {
            var data : * = processData(data);

            var sql : SQLBuilder = new SQLBuilder(conn, getFullyQualifiedTableName());
            sql.insert(data, pk, sequenceName);

            // FIXME
            var values : Array = data;
            return conn.query(lastSql = sql.toString(), values);
        }

        public function update( data : *, where : String ) : void
        {
            var data : * = processData(data);

            var sql : SQLBuilder = new SQLBuilder(conn, getFullyQualifiedTableName());
            sql.update(data).where(where);

            var values : Array = sql.bindValues();
            return conn.query(lastSql = sql.toString(), values);
        }

        public function destroy( data : * )
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

        private function getMetaData()
        {

        }

        private function mapNames( hash : Dictionary, map : Array ) : void
        {

        }

        private function processData( hash : Dictionary ) : void
        {

        }

        private function setPrimaryKey() : void
        {

        }

        private function setTableName() : void
        {

        }

        private function setSequenceName() : void
        {

        }

        private function setAssociations() : void
        {

        }

        private function setDelegates() : void
        {

        }

        private function setSettersAndGetters() : void
        {

        }

    }
}

