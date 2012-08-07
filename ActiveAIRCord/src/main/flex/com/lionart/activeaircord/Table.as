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
    import com.lionart.activeaircord.relationship.IRelationship;
    import com.lionart.activeaircord.relationship.Relationship;

    import flash.utils.Dictionary;

    public class Table
    {

        public var clazz : Class;
        public var conn;
        public var pk : String;
        public var lastSql : String;

        public var columns : Array = [];
        public var table : Table;
        public var dbName : String;
        public var sequence : String;
        public var callback : Function;
        private var relationships : Array = [];

        public static function load( $model_class_name )
        {

        }

        public static function clearCache( modelClassName : String = null )
        {

        }

        public function Table()
        {
        }

        public function reestablishConnection( close : Boolean = true )
        {

        }

        public function createJoins( joins : Dictionary )
        {

        }

        public function optionsToSql( options : Array )
        {

        }

        public function find( options : Array )
        {

        }

        public function findBySql( sql : String, values : Array = null, readonly : Boolean = false, includes : Array = null )
        {

        }

        private function executeEagerLoad( models : Array = null, attrs : Array = null, includes : Array = null )
        {

        }

        public function getColumnByInflected_name( inflectedName : String )
        {

        }

        public function getFullyQualifiedTableName( quoteName : Boolean = true )
        {

        }

        public function getRelationship( name : String, strict : Boolean = false )
        {

        }

        public function hasRelationship( name : String )
        {

        }

        public function insert( data : *, pk : String = null, sequenceName : String = null )
        {

        }

        public function update( data : *, where : String ) : void
        {

        }

        public function destroy( data : * )
        {

        }

        private function addRelationship( relationship : IRelationship )
        {

        }

        private function getMetaData()
        {

        }

        private function mapNames( hash : Dictionary, map : Array )
        {

        }

        private function processData( hash : Dictionary )
        {

        }

        private function setPrimaryKey()
        {

        }

        private function setTableName()
        {

        }

        private function setSequenceName()
        {

        }

        private function setAssociations()
        {

        }

        private function set_delegates()
        {

        }

        private function setSettersAndGetters()
        {

        }

    }
}

