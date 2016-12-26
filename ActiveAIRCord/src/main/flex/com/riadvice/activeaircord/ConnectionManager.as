/*
   Copyright (C) 2012-2017 RIADVICE <ghazi.triki@riadvice.tn>

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
    import com.riadvice.activeaircord.exceptions.ActiveRecordException;
    
    import flash.utils.Dictionary;

    public class ConnectionManager
    {
        private static var _connections : Dictionary = new Dictionary(true);

        public static function getConnection( name : String = null ) : SQLiteConnection
        {
            name = name ? name : Configuration.defaultConnection;
            if (!_connections[name])
            {
                _connections[name] = createConnection(Configuration.getConnection(name));
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

        private static function createConnection( nameOrValue : String ) : SQLiteConnection
        {
            var connectionString : String;
            if (nameOrValue.indexOf('://') == -1)
            {
                connectionString = nameOrValue ? Configuration.getConnection(nameOrValue) : Configuration.defaulConnectionString;
            }
            else
            {
                connectionString = nameOrValue;
            }

            if (!connectionString)
            {
                throw new ActiveRecordException("The connection string is empty");
            }

            var info : Dictionary = SQLiteConnection.parseConnectionUrl(connectionString);

            try
            {
				var name : String = Configuration.getConnectionNameFromConnectionString(nameOrValue);
                var connection : SQLiteConnection = new SQLiteConnection(info, name);
                // TODO : add logging
                if (info["charset"])
                {
                    connection.setEncoding(info["charset"]);
                }
            }
            catch ( e : Error )
            {
                throw new ActiveRecordException(e.message);
            }

            return connection;
        }
    }

}
