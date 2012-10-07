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

    import flash.data.SQLColumnSchema;
    import flash.data.SQLConnection;
    import flash.data.SQLResult;
    import flash.data.SQLStatement;
    import flash.data.SQLTableSchema;
    import flash.filesystem.File;
    import flash.net.Responder;
    import flash.utils.Dictionary;

    import org.as3commons.logging.api.ILogger;
    import org.osmf.utils.URL;

    public class SQLiteConnection extends SQLConnection
    {
        public var _lastQuery : String;

        private var logging : Boolean = false;

        private var logger : ILogger;

        public var _protocol : String;

        public var _connectionString : String;

        public static const QUOTE_CHARACTER : String = "`";

        public function SQLiteConnection( info : Dictionary )
        {
            super();
            var dbFile : File = new File(File.applicationDirectory.nativePath + File.separator + info["host"]);
            // FIXME : if open mode is not create
            /*if (!dbFile.exists)
               {
               throw new ActiveRecordException("Could not find sqlite db: " + info["host"]);
               }*/
            this.open(dbFile);
        }

        public static function instance( connectionStringOrConnectionName : * = null ) : void
        {

        }

        public static function parseConnectionUrl( connectionUrl : String ) : Dictionary
        {
            var url : URL = new URL(connectionUrl);

            if (url.host.length == 0)
            {
                throw new ActiveRecordException("Database host must be specified in the connection string.");
            }
            var info : Dictionary = new Dictionary(true);
            info["protocol"] = url.protocol;
            info["host"] = url.host;
            info["db"] = url.path.length > 0 ? url.path.substr(1) : null;
            info["user"] = url.userInfo.length > 0 ? url.userInfo : null;
            info["pass"] = url.userInfo.length > 0 ? url.userInfo : null;

            if (info["host"] == "unix(")
            {
                var socketDatabase : String = info["host"] + '/' + info["db"];
                var unixRegex : RegExp = /^unix\((.+)\)\/?().*$/;
                var result : Object = unixRegex.exec(socketDatabase);
                if (result)
                {
                    info["host"] = result[1][0];
                    info["dv"] = result[2][0];
                }
            }
            else if (String(info["host"]).substr(0, 8) == "windows(")
            {
                info["host"] = String(info["host"]).substr(8) + "/" + String(info["db"]).substr(0, -1);
                info["db"] = null;
            }

            if (info["db"])
            {
                info["host"] += "/" + info["db"];
            }

            if (url.port.length > 0)
            {
                info["port"] = url.port;
            }

            if (url.query.length > 0)
            {
                var params : Array = url.query.split("&");
                for each (var param : String in params)
                {
                    var keyAndValue : Array = param.split("=");
                    if (keyAndValue[0] == 'charset')
                    {
                        info["charset"] = keyAndValue[1];
                    }
                }
            }
            return info;
        }

        public function columns( table : String ) : Dictionary
        {
            var columns : Dictionary = new Dictionary(true);
            var schema : SQLTableSchema = queryColumnInfo(table);

            for each (var columnSchema : SQLColumnSchema in schema.columns)
            {
                var column : Column = createColumn(columnSchema);
                columns[column.name] = columns;
            }

            return columns;
        }

        public function escape( string : String ) : String
        {
            return "";
        }

        public function insertId( sequenc1e : String = null ) : void
        {

        }

        public function query( sql : String, values : Array = null ) : *
        {
            _lastQuery = sql;
            try
            {
                var statement : SQLStatement = new SQLStatement();
                statement.sqlConnection = this;
                statement.text = sql;
                statement.execute();
                var result : SQLResult = statement.getResult();
            }
            catch ( e : Error )
            {
                new ActiveRecordException(e.message);
            }
            return "";
        }

        public function queryAndFetchOne( sql : String, values : Array = null ) : void
        {

        }

        public function queryAndFetch( sql : String, handler : Function ) : void
        {

        }

        public function tables() : Array
        {
            var dbTables : Array = [];
            var result : Array = [];
            for each (var tableSchema : SQLTableSchema in queryForTables())
            {
                result.push(tableSchema.name);
            }
            return result;
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
            return [sql, SQL.LIMIT, "{", !offset ? "" : parseInt(offset) + ",", "}", parseInt(limit)].join(" ");
        }


        public function queryColumnInfo( table : String ) : SQLTableSchema
        {
            loadSchema(SQLTableSchema, table);
            return getSchemaResult().tables[0];
        }

        public function queryForTables() : Array
        {
            try
            {
                loadSchema();
            }
            catch ( e : Error )
            {
                if (e.errorID == 3115)
                {
                    return [];
                }
                else
                {
                    throw new ActiveRecordException(e.message);
                }
            }
            return getSchemaResult().tables;
        }

        public function setEncoding( charset : String ) : void
        {
            throw new ActiveRecordException("SQLiteConnection does not support encoding.");
        }

        public function nativeDatabaseTypes() : void
        {

        }

        public function createColumn( column : SQLColumnSchema ) : Column
        {
            var c : Column = new Column();
            c.inflectedName = Inflector.variablize(column.name);
            c.name = column.name;
            c.nullable = column.allowNull ? false : true;
            c.primaryKey = column.primaryKey ? true : false;
            c.autIncrement = (["INT", "INTEGER"].indexOf(column.dataType) && c.primaryKey) || column.autoIncrement;

            var type : String = column.dataType.replace(/ +/, " ");
            var matches : Array = String(type).split(" ");

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

            // TODO : c.defaultValue = c.cast(column["dflt_value"], this);
            return c;
        }


        public function acceptsLimitAndOrderForUpdateAndDelete() : Boolean
        {
            return true;
        }
    }
}
