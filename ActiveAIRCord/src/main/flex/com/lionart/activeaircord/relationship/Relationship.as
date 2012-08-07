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
package com.lionart.activeaircord.relationship
{
    import com.lionart.activeaircord.Model;
    import com.lionart.activeaircord.Table;

    import org.as3commons.lang.ArrayUtils;

    public class Relationship implements IRelationship
    {
        private var _attributeName : String;
        private var _className : String;
        private var _foreignKey : Array = [];
        protected var _options : Array = [];
        protected var _polyRelationship : Boolean = false;
        protected static const _validAssociationOptions : Array = ["class_name", "class", "foreign_key", "conditions", "select", "readonly", "namespace"];

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

        public function Relationship( options : Array )
        {
            _attributeName = options[0];
            options = mergeAssociationOptions(options);
        }

        protected function getTable() : void
        {

        }

        public function isPoly() : void
        {

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

        protected function unsetNonFinderOptions( $options ) : void
        {

        }

        protected function setInferredClassName() : void
        {

        }

        protected function setClassName( className : String ) : void
        {

        }

        protected function createConditionsFromKeys( model : Model, conditionKeys = null, valueKeys = null ) : void
        {

        }

        public function constructInnerJoinSql( from_table : Table, usingThrough : Boolean = false, alias : String = null ) : void
        {

        }

        public function load( model : Model ) : void
        {

        }


    }
}
