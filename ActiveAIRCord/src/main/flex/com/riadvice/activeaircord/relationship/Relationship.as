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
    import com.riadvice.activeaircord.SQLBuilder;
    import com.riadvice.activeaircord.Table;
    import com.riadvice.activeaircord.Utils;
    
    import flash.utils.Dictionary;
    
    import avmplus.getQualifiedClassName;
    
    import org.as3commons.lang.ClassUtils;

    public class Relationship implements IRelationship
    {
        private var _attributeName : String;
        private var _className : String;
        private var _foreignKey : Array = [];
        private var _primaryKey : Array = [];
        protected var _options : Array = [];
        protected var _polyRelationship : Boolean = false;
        protected static const _validAssociationOptions : Array = ["class_name", "class", "foreign_key", "conditions", "select", "readonly", "namespace"];

        public function Relationship( options : Array = null )
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

        }

        public function buildAssociation( model : Model, attributes : Array = null ) : void
        {
        }

        public function createAssociation( model : Model, attributes : Array = null ) : void
        {
        }

        protected function appendRecordToAssociate( associate : Model, record : Model ) : void
        {

        }

        protected function mergeAssociationOptions( options : Array ) : Array
        {
            return null;
            //var availableOptions : Array = ArrayUtils.
        }

        protected function unsetNonFinderOptions( options : Dictionary ) : void
        {

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

            return "INNER JOIN " + joinTableName + " " + alias + "ON(" + fromTableName + "." + foreignKey + " = " + aliasedJoinTableName + "." + joinPrimaryKey + ")";
        }

        public function load( model : Model ) : void
        {
            // Override me
        }


    }
}
