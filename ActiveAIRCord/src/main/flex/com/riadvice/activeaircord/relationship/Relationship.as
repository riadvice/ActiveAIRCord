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
package com.riadvice.activeaircord.relationship
{
    import com.riadvice.activeaircord.Inflector;
    import com.riadvice.activeaircord.Model;
    import com.riadvice.activeaircord.SQL;
    import com.riadvice.activeaircord.SQLBuilder;
    import com.riadvice.activeaircord.Table;
    import com.riadvice.activeaircord.Utils;

    import flash.utils.Dictionary;

    import avmplus.getQualifiedClassName;

    import org.as3commons.lang.ArrayUtils;
    import org.as3commons.lang.ClassUtils;
    import org.as3commons.lang.DictionaryUtils;

    public class Relationship implements IRelationship
    {
        private var _attributeName : String;
        private var _className : String;
        private var _foreignKey : Array = [];
        private var _primaryKey : Array = [];
        protected var _options : Dictionary = new Dictionary(true);
        protected var _polyRelationship : Boolean = false;
        protected static const _validAssociationOptions : Array = ["class_name", "class", "foreign_key", "conditions", "select", "readonly", "namespace"];

        public function Relationship( options : Dictionary = null )
        {
            attributeName = options[0];
            _options = mergeAssociationOptions(options);

            // FIXME : must extract the correct class name depending on relationship
            var relationship : String = getQualifiedClassName(this).toLowerCase();

            if (relationship === "hasmany" || relationship === "hasandbelongstomany")
            {
                _polyRelationship = true;
            }

            if (_options["conditions"] && !(_options["conditions"] is Array))
            {
                _options["conditions"] = [_options["conditions"]];
            }

            if (_options["class"])
            {
                setClassName(_options["class"]);
            }
            else if (_options["class_name"])
            {
                setClassName(_options["class_name"]);
            }

            attributeName = Inflector.variablize(attributeName).toLowerCase();

            if (!foreignKey && _options["foreign_key"])
            {
                foreignKey = (_options["foreign_key"] is Array) ? _options["foreign_key"] : [_options["foreign_key"]]
            }
        }

        public function get attributeName() : String
        {
            return _attributeName;
        }

        public function set attributeName( value : String ) : void
        {
            _attributeName = value;
        }

        public function get className() : String
        {
            return _className;
        }

        public function set className( value : String ) : void
        {
            _className = value;
        }

        public function get foreignKey() : Array
        {
            return _foreignKey;
        }

        public function set foreignKey( value : Array ) : void
        {
            _foreignKey = value;
        }

        public function get primaryKey() : Array
        {
            return _primaryKey;
        }

        public function set primaryKey( value : Array ) : void
        {
            _primaryKey = value;
        }

        protected function getTable() : Table
        {
            return Table.load(className);
        }

        public function get isPoly() : Boolean
        {
            return _polyRelationship;
        }

        protected function setKeys( modelClassName : String, override : Boolean = false ) : void
        {
            //infer from class_name
            if (!this.foreignKey || override)
            {
                this.foreignKey = [Inflector.keyify(modelClassName)];
            }

            if (!this.primaryKey || override)
            {
                this.primaryKey = Table.load(modelClassName).pk;
            }
        }


        protected function queryAndAttachRelatedModelsEagerly( table : Table, models : Array, attributes : Array, includes : Array = null, queryKeys : Array = null, modelValuesKeys : Array = null ) : void
        {
            var values : Array = new Array();
            var options : Dictionary = this._options;
            var queryKey : String = queryKeys[0];
            var modelValuesKey = modelValuesKeys[0];

            for each (var value in attributes)
            {
                values.push(value[Inflector.variablize(modelValuesKey)]);
            }

            values = [values];
            var conditions : Array = SQLBuilder.createConditionsFromUnderscoredString(table.conn, queryKey, values);

            if ((options["conditions"] != undefined) && (options["conditions"][0].length > 1))
            {
                Utils.addCondition(options["conditions"], conditions);
            }
            else
            {
                options["conditions"] = conditions;
            }

            if (!ArrayUtils.isEmpty(includes))
            {
                options["include"] = includes;
            }

            if (options["through"] != undefined)
            {
                // save old keys as we will be reseting them below for inner join convenience
                var pk : Array = this.primaryKey;
                var fk : Array = this.foreignKey;

                this.setKeys(ClassUtils.getName(getTable().clazz), true)

                if (options["class_name"] != undefined)
                {
                    var clazz = Utils.classify(options["through"], true);

                    var throughTable : Table = clazz["table"]();
                }
                else
                {
                    clazz = options["class_name"];
                    var relation : IRelationship = Table(clazz["table"]()).getRelationship(options["through"]);
                    var throughTable : Table = Relationship(relation).getTable();
                }
                options["joins"] = this.constructInnerJoinSql(throughTable, true);

                var queryKey : String = this._primaryKey[0];

                // reset keys
                this._primaryKey = pk;
                this._foreignKey = fk;
            }

            options = unsetNonFinderOptions(options);

            var clazz : String = this.className;

            var relateModels = ClassUtils.forName(clazz)["find"]("all", options);
            var usedModels = new Array();
            modelValuesKey = Inflector.variablize(modelValuesKey);
            queryKey = Inflector.variablize(queryKey);

            for each (var model : Model in models)
            {
                var matches : int = 0;
                var keyToMatch : String = model[modelValuesKey];

                for each (var related : Model in relateModels)
                {
                    if (related[queryKey] == keyToMatch)
                    {
                        /*
                           $hash = spl_object_hash($related);

                           if (in_array($hash, $used_models))
                           $model->set_relationship_from_eager_load(clone($related), $this->attribute_name);
                           else
                           $model->set_relationship_from_eager_load($related, $this->attribute_name);

                           $used_models[] = $hash;
                         */
                        matches++;
                    }
                }

                if (0 === matches)
                {
                    model.setRelationshipFromEagerLoad(this._attributeName);
                }
            }
        }

        public function buildAssociation( model : Model, attributes : Array = null, guardAttributes : Boolean = true ) : *
        {
            var clazz : Class = ClassUtils.forName(this.className);
            return ClassUtils.newInstance(clazz, [attributes, guardAttributes]);
        }

        public function createAssociation( model : Model, attributes : Array = null, guardAttributes : Boolean = true ) : Model
        {
            var clazz : Class = ClassUtils.forName(this.className);
            var newRecord : Model = clazz["create"](attributes, true, guardAttributes);
            return this.appendRecordToAssociate(model, newRecord);
        }

        protected function appendRecordToAssociate( associate : Model, record : Model ) : Model
        {
            var association : * = associate[this.attributeName];

            if (this._polyRelationship)
            {
                association = [record];
            }
            else
            {
                association = record;
            }

            return record;
        }

        protected function mergeAssociationOptions( options : Dictionary ) : Dictionary
        {
            return null;
        }

        protected function unsetNonFinderOptions( options : Dictionary ) : Dictionary
        {
            for each (var key : String in DictionaryUtils.getKeys(options))
            {
                if (Model.VALID_OPTIONS.indexOf(key) > 0)
                {
                    delete options[key];
                }
            }
            return options;
        }

        protected function setInferredClassName() : void
        {
            var singularize : Boolean = this is HasMany ? true : false;
            setClassName(Utils.classify(this.attributeName, singularize));
        }

        protected function setClassName( className : String ) : void
        {

        }

        protected function createConditionsFromKeys( model : Model, conditionKeys : Array = null, valueKeys : Dictionary = null ) : Dictionary
        {
            var conditionString : String = conditionKeys.join('_and_');
            var conditionValues : Array = Utils.getDictionaryValues(model.getValuesFor(valueKeys));

            // return null if all the foreign key values are null so that we don't try to do a query like "id is null"
            if (Utils.all(null, conditionValues))
            {
                return null;
            }

            var conditions : Array = SQLBuilder.createConditionsFromUnderscoredString(Table.load(ClassUtils.getName(ClassUtils.forInstance(model))).conn, conditionString, conditionValues);

            // DO NOT CHANGE THE NEXT TWO LINES. add_condition operates on a reference and will screw options array up
            var optionsConditions : Array;
            if (_options['conditions'] != undefined)
            {
                optionsConditions = _options['conditions'];
            }
            else
            {
                optionsConditions = new Array();
            }

            return Utils.addCondition(optionsConditions, conditions);
        }

        public function constructInnerJoinSql( fromTable : Table, usingThrough : Boolean = false, alias : String = null ) : String
        {
            var joinTable : Table;
            var joinTableName : String;
            var fromTableName : String;

            var foreignKey : String;
            var joinPrimaryKey : String;

            if (usingThrough)
            {
                joinTable = fromTable;
                joinTableName = fromTable.getFullyQualifiedTableName();
                fromTableName = Table.load(this.className).getFullyQualifiedTableName();
            }
            else
            {
                joinTable = Table.load(this.className);
                joinTableName = joinTable.getFullyQualifiedTableName();
                fromTableName = fromTable.getFullyQualifiedTableName();
            }

            // need to flip the logic when the key is on the other table
            if (this is HasMany || this is HasOne)
            {
                setKeys(ClassUtils.getName(fromTable.clazz));

                if (usingThrough)
                {
                    foreignKey = this.primaryKey[0];
                    joinPrimaryKey = this.foreignKey[0];
                }
                else
                {
                    joinPrimaryKey = this.foreignKey[0];
                    foreignKey = this.primaryKey[0];
                }
            }
            else
            {
                foreignKey = this.foreignKey[0];
                joinPrimaryKey = this.primaryKey[0];
            }

            var aliasedJoinTableName : String;
            if (alias != null)
            {
                aliasedJoinTableName = alias = this.getTable().conn.quoteName(alias);
                alias += ' ';
            }
            else
            {
                aliasedJoinTableName = joinTableName;
            }

            return [SQL.INNER, SQL.JOIN, joinTableName, alias, SQL.ON, "(", fromTableName, ".", foreignKey, SQL.EQUALS, aliasedJoinTableName, ".", joinPrimaryKey, ")"].join(" ");
        }

        public function load( model : Model ) : void
        {
            // Override me
        }


    }
}
