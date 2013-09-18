/*
   Copyright (C) 2012-2013 RIADVICE <ghazi.triki@riadvice.tn>

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
    import com.riadvice.activeaircord.exceptions.ExpressionsException;

    import flash.utils.Dictionary;

    import org.as3commons.lang.DictionaryUtils;
    import org.as3commons.lang.StringUtils;

    public class Expressions
    {

        private var _expressions : String;
        private var _values : Array = [];
        private var _connection : SQLiteConnection;

        public function Expressions( connection : SQLiteConnection, expressions : * = null, ... rest )
        {
            var params : Array;
            _connection = connection;

            if (expressions is Dictionary)
            {
                var glue : String = rest.length > 0 ? rest[0] : " " + SQL.AND + " ";
                var builtSQL : Array = buildSqlFromHash(expressions, glue);
                expressions = builtSQL[0];
                params = builtSQL[1];
            }

            if (!StringUtils.isEmpty(expressions))
            {
                if (!params)
                {
                    params = rest;
                }
                _values = params;
                _expressions = expressions;
            }
        }

        public function bind( parameterNumber : int, value : * ) : void
        {
            if (parameterNumber <= 0)
            {
                throw new ExpressionsException("Invalid parameter index: " + parameterNumber);
            }
            values[parameterNumber - 1] = value;
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

        public function set connection( value : SQLiteConnection ) : void
        {
            _connection = value;
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
                var ch : String = _expressions.charAt(i);

                if (ch == SQL.PARAM)
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
                else if (ch == "\'" && i > 0 && _expressions.charAt(i - 1) != "\\")
                {
                    ++quotes;
                }
                result += ch;
            }

            return result;
        }

        private function buildSqlFromHash( hash : Dictionary, glue : String ) : Array
        {
            var sql : String = "";
            var g : String = "";
            for each (var key : String in DictionaryUtils.getKeys(hash))
            {
                var cleanKey : String = key;
                if (_connection)
                {
                    key = _connection.quoteName(key);
                }
                if (hash[cleanKey] is Array)
                {
                    sql += [g, key, " ", SQL.IN, "(", SQL.PARAM, ")"].join("");
                }
                else if (hash[cleanKey] == null)
                {
                    sql += [g, key, " ", SQL.IS, " ", SQL.PARAM].join("");
                }
                else
                {
                    sql += [g, key, "=", SQL.PARAM].join("");
                }
                g = glue;
            }

            return [sql, Utils.getDictionaryValues(hash)];
        }

        private function substituteParameters( values : Array, substitute : Boolean, pos : int, parameterIndex : int ) : *
        {
            var value : * = values[parameterIndex];

            if (value is Array)
            {
                if (substitute)
                {
                    var result : String = '';

                    for (var i : int = 0; i < value.length; ++i)
                    {
                        result += (i > 0 ? ',' : '') + stringifyValue(value[i]);
                    }

                    return result;
                }
                return Utils.arrayFill(value.length, SQL.PARAM).join(',');
            }

            if (substitute)
            {
                return stringifyValue(value);
            }

            return _expressions.charAt(pos);
        }

        private function stringifyValue( value : * ) : String
        {
            if (!value)
            {
                return SQL.NULL;
            }

            return (value is String) ? quoteString(value) : value;
        }

        private function quoteString( value : String ) : String
        {
            if (_connection)
            {
                return _connection.escape(value);
            }

            return "'" + StringUtils.replace(value, "'", "''") + "'";
        }

    }
}
