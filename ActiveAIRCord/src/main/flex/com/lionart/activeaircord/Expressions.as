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
    import com.lionart.activeaircord.exceptions.ExpressionsException;

    import flash.utils.Dictionary;

    import org.as3commons.lang.DictionaryUtils;

    public class Expressions
    {

        public static const EQUALS : String = "=";
        public static const PARAM : String = "?";

        private var _expressions : Array;
        private var _values : Array = [];
        private var _connection : SQLiteConnection;

        public function Expressions( connection : SQLiteConnection, expressions : * = null )
        {
            var values : Array;
            _connection = connection;

            if (expressions is Array)
            {
                // TODO : to complete
                // var glue : String = 
            }
        }

        public function bind( parameterNumber : int, value : * ) : void
        {
            if (parameterNumber <= 0)
            {
                throw new ExpressionsException("Invalid parameter index: " + parameterNumber);
            }
            value[parameterNumber - 1] = value;
        }

        public function bindValues( values : Array ) : void
        {
            _values = values;
        }

        public function get values() : Array
        {
            return _values;
        }

        public function get connection() : SQLiteConnection
        {
            return _connection;
        }

        public function toString( substitute : Boolean = false, options : Dictionary = null ) : String
        {
            options ||= new Dictionary();

            var values : Array = DictionaryUtils.containsKey(options, "values") ? options["values"] : this.values;

            var result : String = "";
            var replace : Array = [];
            var numValues : int = values.length;
            var length : int = _expressions.length;
            var quotes : int = 0;
            var j : int = 0;

            for (var i : int = 0; i < length; i++)
            {
                var ch : String = _expressions[i];

                if (ch == Expressions.PARAM)
                {
                    if (quotes % 2 == 0)
                    {
                        if (j > numValues - 1)
                        {
                            throw new ExpressionsException("No bound parameter for index " + j);
                        }
                        ch = substituteParameters(values, substitute, i, j++);
                    }
                }
                else if (ch == "\'" && i > 0 && _expressions[i - 1] != "\\")
                {
                    ++quotes;
                }
                result += ch;
            }

            return result;
        }

        private function buildSqlFromHash( hash : Dictionary, glue : String ) : Array
        {
            return null;
        }

        private function substituteParameters( values : Array, substitute : Boolean, pos : int, parameterIndex : int ) : *
        {

        }

        private function stringifyValue( value : * ) : *
        {
            if (!value)
            {
                return " " + SQL.NULL;
            }

            return (value is String) ? quoteString(value) : value;
        }

        private function quoteString( value : String ) : String
        {
            if (_connection)
            {
                return _connection.escape(value);
            }

            return "'" + value.replace("'", "''") + "'";
        }

    }
}
