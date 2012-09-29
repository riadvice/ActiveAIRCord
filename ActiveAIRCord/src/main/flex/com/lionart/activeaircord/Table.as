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

    import flash.utils.Dictionary;

    import org.as3commons.lang.ClassUtils;
    import org.as3commons.lang.DictionaryUtils;

    public class Table
    {

        public var clazz : Class;
        public var conn : *;
        public var pk : String;
        public var lastSql : String;

        public var columns : Array = [];
        public var table : Table;
        public var dbName : String;
        public var sequence : String;
        public var callback : Function;
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

        public static function clearCache( modelClass : Class = null )
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

        public function createJoins( joins : Dictionary )
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

                if (value.indexOf(SQL.JOIN + ' ') == -1)
                {
                    if (DictionaryUtils.containsKey(relationships, value))
                    {
                        var rel : IRelationship = getRelationship(value);
                            //if ( DictionaryUtils.containsKey(rel )
                    }
                }
            }
            return ret;
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

        public function getRelationship( name : String, strict : Boolean = false ) : IRelationship
        {
            return null;
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

        private function addRelationship( relationship : IRelationship ) : void
        {

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

