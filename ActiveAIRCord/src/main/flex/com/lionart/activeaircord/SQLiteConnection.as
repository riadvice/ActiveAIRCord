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
    import com.lionart.activeaircord.exceptions.ActiveRecordException;

    import flash.data.SQLConnection;
    import flash.net.Responder;
    import flash.utils.Dictionary;

    import org.as3commons.collections.utils.ArrayUtils;
    import org.as3commons.logging.api.ILogger;

    public class SQLiteConnection extends SQLConnection
    {

        public var _lastQuery : String;

        private var logging : Boolean = false;

        private var logger : ILogger;

        public var _protocol : String;

        public static const QUOTE_CHARACTER : String = '`';

        public static function instance( connectionStringOrConnectionName : * = null ) : void
        {

        }

        public static function parseConnectionUrl( connectionUrl : String ) : void
        {

        }

        public function SQLiteConnection()
        {
            super();
        }

        public function columns( table : String ) : void
        {

        }

        public function escape( string : String ) : String
        {
            return "";
        }

        public function insertId( sequenc1e : String = null ) : void
        {

        }

        public function query( sql : String, values : Array = null ) : String
        {
            return '';
        }

        public function queryAndFetchOne( sql : String, values : Array = null ) : void
        {

        }

        public function queryAndFetch( sql : String, handler : Function ) : void
        {

        }

        public function tables() : void
        {

        }

        public function transaction() : void
        {
            super.begin();
        }

        override public function commit( responder : Responder = null ) : void
        {
            super.commit();
        }

        override public function rollback( responder : Responder = null ) : void
        {
            super.rollback();
        }

        public function getSequenceName( table : String, columnName : String ) : void
        {

        }

        public function nextSequenceValue( sequenceName : String ) : void
        {

        }

        public function quoteName( string : String ) : String
        {
            return string.charAt(0) === QUOTE_CHARACTER || string.charAt(string.length - 1) === QUOTE_CHARACTER ?
                string : QUOTE_CHARACTER + string + QUOTE_CHARACTER;
        }


        public function limit( sql : String, offset : String, limit : String ) : String
        {
            return [sql, SQL.LIMIT, '{', !offset ? '' : parseInt(offset) + ',', '}', parseInt(limit)].join(' ');
        }


        public function queryColumnInfo( table : String ) : String
        {
            // TODO : implement with SQLite supported syntax
            return '';
        }

        public function queryForTables() : String
        {
            return query([SQL.SELECT, 'name', SQL.FROM, 'slite_master'].join(' '));
        }

        public function setEncoding( charset : String ) : void
        {
            throw new ActiveRecordException("SQLiteConnection does not support encoding.");
        }

        public function nativeDatabaseTypes() : void
        {

        }

        public function createColumn( column : Dictionary ) : Column
        {
            var c : Column = new Column();
            c.inflectedName = Inflector.variablize(column['name']);
            c.name = column['name'];
            c.nullable = column['notnull'] ? false : true;
            c.primaryKey = column['pk'] ? true : false;
            c.autIncrement = ['INT', 'INTEGER'].indexOf(column['type']) && c.primaryKey;

            column['type'] = String(column['type']).replace(/ +/, ' ');
            var matches : Array = String(column['type']).split(' ');

            if (matches && matches.length > 0)
            {
                c.rawType = String(matches[0]).toLowerCase();
                if (matches.length > 1)
                {
                    c.length = parseInt(matches[1]);
                }
            }

            c.mapRawType();

            // FIXME : remove beceause useless
            if (c.type == SQLTypes.DATE)
            {
                c.length = 19;
            }

            // From SQLite3 docs: The value is a signed integer, stored in 1, 2, 3, 4, 6,
            // or 8 bytes depending on the magnitude of the value.
            // so is it ok to assume it's possible an int can always go up to 8 bytes?
            if (c.type == SQLTypes.INTEGER && !c.length)
            {
                c.length = 8;
            }

            c.defaultValue = c.cast(column['dflt_value'], this);
            return c;

        }


        public function acceptsLimitAndOrderForUpdateAndDelete() : Boolean
        {
            return true;
        }
    }
}
