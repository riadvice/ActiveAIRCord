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
    import flash.utils.Dictionary;
    import flash.utils.Proxy;
    import flash.utils.flash_proxy;
    
    import org.as3commons.lang.DictionaryUtils;

    public dynamic class Model extends Proxy
    {

        private var _item : Array;
        private var _errors : Array;
        private var _attributes : Dictionary = new Dictionary(true);
        private var _dirty : Array;
        private var _readOnly : Boolean = false;
        private var _relationShips : Dictionary = new Dictionary(true);
        private var _newRecord : Boolean = true;
        public static var connection : SQLiteConnection;
        public static var db : String;
        public static var tableName : String;
        public static var primaryKey : String;
        public static var sequence : String;
        public static var aliasAttribute : Dictionary = new Dictionary(true);

        public static const VALID_OPTIONS : Array = ["conditions", "limit", "offset", "order", "select", "joins", "include", "readonly", "group", "from", "having"];


        public function Model( attributes : Object = null, guardAttributes : Boolean = true, instantiatingViaFind : Boolean = false, newRecord : Boolean = true )
        {
            super();
            _newRecord = newRecord;
            if (!instantiatingViaFind)
            {
                for each (var column : Column in Table.forClass(this).columns)
                {
                    attributes[column.inflectedName] = column.defaultValue;
                }
            }

            setAttributesViaMassAssignment(attributes, guardAttributes);

            if (instantiatingViaFind)
            {
                _dirty = [];
            }

            invokeCallback("after_consruct", false);
        }

        public function get errors() : Array
        {
            return _errors;
        }

        public function set errors( value : Array ) : void
        {
            _errors = value;
        }

        override flash_proxy function callProperty( methodName : *, ... parameters ) : *
        {
            var res : *;
            switch (methodName.toString())
            {
                /*case "clear":
                   _item = new Array();
                   break;
                   case "sum":
                   var sum:Number = 0;
                   for each (var i:* in _item) {
                   // ignore non-numeric values
                   if (!isNaN(i)) {
                   sum += i;
                   }
                   }
                   res = sum;
                   break;*/
                default:
                    res = _item[methodName].apply(_item, parameters);
                    break;
            }
            return res;
        }

        override flash_proxy function getProperty( name : * ) : *
        {
            // TODO : must look in attributes dictionary
            if (hasOwnProperty(name))
            {
                return _item[name];
            }
            return readAttribute(name);
        }

        override flash_proxy function setProperty( name : *, value : * ) : void
        {
            _item[name] = value;
        }

        override flash_proxy function hasProperty( name : * ) : Boolean
        {
            return DictionaryUtils.containsKey(_attributes, name) || DictionaryUtils.containsKey(aliasAttribute, name);
        }

        public function assignAttribute( name : String, value : * ) : *
        {
            var table : Table = Table.forClass(this);
            if (!(value is Object))
            {
                if (DictionaryUtils.containsKey(table.columns, name))
                {
                    value = Column(table.columns[name]).cast(value, this['connection']);
                }
                else
                {
                    var col : Column = table.getColumnByInflectedName(name);
                    if (col != null)
                    {
                        value = col.cast(value, this['connection']);
                    }
                }
            }

            attributes()[name] = value;
            flagDirty(name);
            return value;
        }

        public function readAttribute( name : String ) : void
        {
        }

        public function flagDirty( name : String ) : void
        {

        }

        public function dirtyAttributes() : void
        {

        }

        public function attributeIsDirty( attribute : String ) : void
        {

        }

        public function attributes() : Dictionary
        {
            return _attributes;
        }

        public function getPrimaryKey( first : Boolean = false ) : String
        {
            return null; //table().primaryKey;
        }

        public function getRealAttributeName( name : String ) : void
        {

        }

        public function getValidationRules() : void
        {

        }

        public function getValuesFor( attributes : Array ) : void
        {

        }

        public static function getTableName() : void
        {

        }

        private function isDelegated( name : String, delegate : Array ) : void
        {

        }

        public function isReadonly() : void
        {

        }

        public function isNewRecord() : void
        {

        }

        private function verifyNotReadonly( methodName : String ) : void
        {

        }

        public function readonly( readonly : Boolean = true ) : void
        {

        }

        public static function getConnection() : void
        {

        }

        public static function reestablishConnection() : void
        {

        }

        private static function internalTable() : void
        {

        }

        public static function create( attributes : Array, validate : Boolean = true ) : void
        {

        }

        public function save( validate : Boolean = true ) : void
        {

        }

        private function insert( validate : Boolean = true ) : void
        {

        }

        private function update( validate : Boolean = true ) : void
        {

        }

        public static function deleteAll( options : Array = null ) : void
        {

        }

        public static function updateAll( options : Array = null ) : void
        {

        }

        public function destroy() : void
        {

        }

        public function valuesForPk() : void
        {

        }

        public function valuesFor( attributeNames : Array ) : void
        {

        }

        private function validate() : void
        {

        }

        public function isDirty() : Boolean
        {
            return _dirty.length > 0;
        }

        public function isValid() : void
        {

        }

        public function isInvalid() : void
        {

        }

        public function setTimestamps() : void
        {

        }

        public function updateAttributes( attributes : Array ) : void
        {

        }

        public function updateAttribute( name : String, value : * ) : void
        {

        }

        public function setAttributes( attributes : Dictionary ) : void
        {

        }

        private function setAttributesViaMassAssignment( attributes : Object, guardAttributes : Boolean ) : void
        {
            var table : Table = Table.forClass(this);
            var exceptions : Array = [];
            var useAttrAccessible : Boolean = this['attr_accessible'];
            var useAttrProtected : Boolean = this['attr_protected'];
            var conn : SQLiteConnection = this['connection'];
            for each (var attribute : String in attributes)
            {
                var value : String;
                var name : String;
                if (DictionaryUtils.containsKey(table.columns, attributes))
                {
                    value = Column(table.columns[attribute]).cast(attributes[attribute], conn);
                    name = Column(table.columns[attribute]).inflectedName;
                }
                if (guardAttributes)
                {
                    if (useAttrAccessible && !DictionaryUtils.containsKey(this['attr_accessible'], name))
                    {
                        continue;
                    }
                    if (useAttrProtected && !DictionaryUtils.containsKey(this['attr_protected'], name))
                    {
                        continue;
                    }
                    try
                    {
                        this['name'] = value;
                    }
                    catch ( e : Error )
                    {
                        exceptions.push(e.message);
                    }
                }
                else
                {
                    assignAttribute(name, value);
                }
            }
        }

        public function setRelationshipFromEagerLoad( name : String, model : Model = null ) : void
        {

        }

        public function reload() : void
        {

        }

        public function clone() : void
        {

        }

        public function resetDirty() : void
        {

        }

        public static function all() : void
        {

        }

        public static function count() : void
        {

        }

        public static function exists() : void
        {

        }

        public static function first() : void
        {

        }

        public static function last() : void
        {

        }

        public static function find() : void
        {

        }

        public static function findByPk( values : Array, options : Array ) : void
        {

        }

        public static function findBySql( sql : String, values : Array = null ) : void
        {

        }

        public static function query( sql : String, values : Array = null ) : void
        {

        }

        public static function isOptionsHash( array : Array, throws : Boolean = true ) : void
        {

        }

        public static function pkConditions( args : Array ) : void
        {

        }

        public static function extractAndValidateOptions( array : Array ) : void
        {

        }

        public function toJson( options : Array = null ) : void
        {

        }

        public function toXml( options : Array = null ) : void
        {

        }

        public function toCsv( options : Array = null ) : void
        {

        }

        public function toArray( options : Array = null ) : void
        {

        }

        private function serialize( type : String, options : Array ) : void
        {

        }

        private function invokeCallback( methodName : String, mustExist : Boolean = true ) : void
        {

        }

        public static function transaction( closure : Function ) : void
        {

        }

    }
}
