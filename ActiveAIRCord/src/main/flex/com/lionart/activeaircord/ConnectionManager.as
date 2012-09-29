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
    import flash.data.SQLConnection;
    import flash.utils.Dictionary;

    public class ConnectionManager
    {
        private static var _connections : Dictionary;

        public static function getConnection( name : String = null ) : SQLiteConnection
        {
            name = name ? name : Configuration.defaultConnection;
            if (!_connections[name])
            {
                _connections[name] = Configuration.getConnection(name);
            }
            return _connections[name];
        }

        /**
         * Drops the connection from the connection manager.
         */
        public static function dropConnection( name : String = null ) : void
        {
            if (_connections[name])
            {
                // TODO : close the connection when deleted
                delete _connections[name];
            }
        }
    }

}
