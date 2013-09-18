/*
   Copyright (C) 2012-2013 RIADVICE <ghazi.triki@riadvice.tn>

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
    import avmplus.getQualifiedClassName;

    import com.riadvice.activeaircord.Inflector;
    import com.riadvice.activeaircord.Model;
    import com.riadvice.activeaircord.Table;

    import flash.utils.Dictionary;

    public class Relationship implements IRelationship
    {
        private var _attributeName : String;
        private var _className : String;
        private var _foreignKey : Array = [];
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

        protected function getTable() : void
        {
            Table.load(className);
        }

        public function isPoly() : Boolean
        {
            return _polyRelationship;
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

        }

        protected function setClassName( className : String ) : void
        {

        }

        protected function createConditionsFromKeys( model : Model, conditionKeys : Array = null, valueKeys : Array = null ) : void
        {

        }

        public function constructInnerJoinSql( table : Table, usingThrough : Boolean = false, alias : String = null ) : String
        {
            return null;
        }

        public function load( model : Model ) : void
        {

        }


    }
}
