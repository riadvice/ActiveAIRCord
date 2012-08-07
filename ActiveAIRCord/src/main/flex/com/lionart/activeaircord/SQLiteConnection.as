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

        public function query( sql : String, values : Array = null ) : void
        {

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

        }

        override public function commit( responder : Responder = null ) : void
        {
            super.commit();
        }

        override public function rollback( responder : Responder = null ) : void
        {
            super.rollback();
        }

        public function supportsSequences() : void
        {

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


        public function limit( sql : String, offset : String, limit : String ) : void
        {
        /*offset = !offset ? '' : parseInt( offset );
           limit = parseInt( limit );
           return "TODO";*/
        }


        public function queryColumnInfo( table : String ) : void
        {

        }

        public function queryForTables() : String
        {
            return "TODO";
        }

        public function setEncoding( charset : String ) : void
        {
            throw new ActiveRecordException("SQLiteConnection does not support encoding.");
        }

        public function nativeDatabaseTypes() : void
        {

        }

        public function createColumn( column : Column ) : Column
        {
            var c : Column = new Column();
            return c;

        }


        public function acceptsLimitAndOrderForUpdateAndDelete() : Boolean
        {
            return true;
        }
    }
}
