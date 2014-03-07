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
package com.riadvice.activeaircord
{
    import flash.utils.Dictionary;

    import org.as3commons.lang.DictionaryUtils;
    import org.as3commons.logging.api.ILogger;

    /**
     * Manages configuration options for ActiveRecord.
     */
    public class Configuration
    {
        private static var _defaultConnection : String = "development";

        private static var _connections : Dictionary = new Dictionary(true);

        private static var _logging : Boolean = false;

        private static var _persistencePackage : String;

        private static var _logger : ILogger;

        public static function set connections( connections : Dictionary ) : void
        {
            _connections = connections;
        }

        /**
         * Returns the connection Dictionary.
         */
        public static function get connections() : Dictionary
        {
            return _connections;
        }

        /**
         * Returns an SQLConnection if found otherwise null.
         */
        public static function getConnection( name : String ) : String
        {
            return _connections[name] ? _connections[name] : null;
        }

        public static function get defaulConnectionString() : String
        {
            return DictionaryUtils.containsKey(_connections, _defaultConnection) ? _connections[_defaultConnection] : null;
        }

        public static function get defaultConnection() : String
        {
            return _defaultConnection;
        }

        public static function set defaultConnection( name : String ) : void
        {
            _defaultConnection = name;
        }

        public static function set presistencePackage( packageName : String ) : void
        {
            _persistencePackage = packageName;
        }

        public static function get presistencePackage() : String
        {
            return _persistencePackage;
        }

        public static function set logging( value : Boolean ) : void
        {
            _logging = value;
        }

        public static function get logging() : Boolean
        {
            return _logging;
        }

        public static function set logger( logger : ILogger ) : void
        {
            _logger = logger;
        }

        // TODO : add default date format and cache
    }
}
