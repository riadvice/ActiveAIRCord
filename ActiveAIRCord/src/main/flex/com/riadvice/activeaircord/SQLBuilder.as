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
    import com.riadvice.activeaircord.exceptions.ActiveRecordException;

    import org.as3commons.lang.ObjectUtils;
    import org.as3commons.lang.StringUtils;

    public class SQLBuilder
    {
        private var _connection : SQLiteConnection;
        private var _operation : String = SQL.SELECT;
        private var _table : String;
        private var _select : String = SQL.ASTERISK;
        private var _joins : String;
        private var _order : String;
        private var _limit : int;
        private var _offset : int;
        private var _group : String;
        private var _having : String;
        private var _update : String;

        // For WHERE
        private var _where : String;
        private var _whereValues : Array = [];

        // For insert/update
        private var _data : *;
        private var _sequence : Array;

        public function SQLBuilder( connection : SQLiteConnection, table : String )
        {
            if (!connection)
            {
                throw new ActiveRecordException("A valid database connection is required.");
            }
            _connection = connection;
            _table = table;
        }

        public function toString() : String
        {
            var methodName : String = "build" + StringUtils.capitalize(_operation.toLowerCase());
            return this[methodName]();
        }

        public function get whereValues() : Array
        {
            return _whereValues;
        }

        public function bindValues() : Array
        {
            var result : Array = [];
            if (_data)
            {
                result = Utils.getObjectValues(_data);
            }
            if (whereValues)
            {
                result = result.concat(whereValues);
            }
            return Utils.flattenArray(result);
        }

        public function where( ... args ) : SQLBuilder
        {
            applyWhereConditions.apply(this, args);
            return this;
        }

        public function order( order : String ) : SQLBuilder
        {
            _order = order;
            return this;
        }

        public function group( group : String ) : SQLBuilder
        {
            _group = group;
            return this;
        }

        public function having( having : String ) : SQLBuilder
        {
            _having = having;
            return this;
        }

        public function limit( limit : int ) : SQLBuilder
        {
            _limit = limit;
            return this;
        }

        public function offset( offset : int ) : SQLBuilder
        {
            _offset = offset;
            return this;
        }

        public function select( select : String ) : SQLBuilder
        {
            _operation = SQL.SELECT;
            _select = select;
            return this;
        }

        public function joins( joins : String ) : SQLBuilder
        {
            _joins = joins;
            return this;
        }

        public function insert( hash : *, pk : String = null, sequenceName : String = null ) : SQLBuilder
        {
            if (!Utils.isHash(hash))
            {
                throw new ActiveRecordException("Inserting requires a hash.");
            }
            _operation = SQL.INSERT;
            _data = hash;
            if (pk && sequenceName)
            {
                _sequence = [pk, sequenceName];
            }
            return this;
        }

        public function update( hash : * ) : SQLBuilder
        {
            _operation = SQL.UPDATE;
            if (ObjectUtils.isExplicitInstanceOf(hash, Object))
            {
                _data = hash;
            }
            else if (hash is String)
            {
                _update = hash;
            }
            else
            {
                throw new ActiveRecordException("Updating requires a hash or string.");
            }

            return this;
        }

        public function destroy( ... args ) : SQLBuilder
        {
            _operation = SQL.DELETE;
            applyWhereConditions.apply(this, args);
            return this;
        }

        /**
         * Reverses an order clause.
         */
        public static function reverseOrder( order : String ) : String
        {
            if (!StringUtils.trim(order))
            {
                return order;
            }

            var parts : Array = order.split(",");

            for (var i : int = 0; i < parts.length; i++)
            {
                var value : String = String(parts[i]).toLowerCase();

                if (value.search(SQL.ASC.toLowerCase()) > 0)
                {
                    parts[i] = String(parts[i]).replace(/asc/i, SQL.DESC);
                }
                else if (value.search(SQL.DESC.toLowerCase()) > 0)
                {
                    parts[i] = String(parts[i]).replace(/desc/i, SQL.ASC);
                }
                else
                {
                    parts[i] += " " + SQL.DESC;
                }
            }
            return parts.join(",");
        }

        public static function createConditionsFromUnderscoredString( connection : SQLiteConnection, name : String, values : Array, map : Object = null ) : Array
        {
            if (!name)
            {
                return null;
            }

            var parts : Array = name.split(/(_and_|_or_)/i);
            var numValues : int = values ? values.length : 0;
            var conditions : Array = [''];

            var bind : String;
            var j : int = 0;
            for (var i : int = 0; i < parts.length; i += 2)
            {
                if (i >= 2)
                {
                    conditions[0] = String(conditions[0]) + String(parts[i - 1]).replace(/_and_/i, " " + SQL.AND + " ").replace(/_or_/i, " " + SQL.OR + " ");
                }
                if (j < numValues)
                {
                    if (values[j] != null)
                    {
                        bind = (values[j] is Array) ? (" " + SQL.IN + SQL.PARAM) : (SQL.EQUALS + SQL.PARAM);
                        conditions.push(values[j]);
                    }
                    else
                    {
                        bind = " " + [SQL.IS, SQL.NULL].join(" ");
                    }
                }
                else
                {
                    bind = " " + [SQL.IS, SQL.NULL].join(" ");
                }

                // map to correct name if map was supplied
                name = map && (map[parts[i]]) ? map[parts[i]] : parts[i];

                conditions[0] = String(conditions[0]) + connection.quoteName(name) + bind;

                ++j;
            }

            return conditions;
        }

        public static function createObjectFromUnderscoredString( name : String, values : Array = null, map : Object = null ) : Object
        {
            var parts : Array = name.split(/(_and_|_or_)/i);
            parts = parts.filter(function removeSplitters( element : *, index : int, arr : Array ) : Boolean
            {
                return element !== "_and_" && element !== "_or_";
            });
            var obj : Object = new Object();

            for (var i : int = 0; i < parts.length; ++i)
            {
                name = map && map[parts[i]] ? map[parts[i]] : parts[i];
                obj[name] = values[i];
            }

            return obj;
        }

        private function prependTableNameToFields( hash : Object ) : Object
        {
            var result : Object = new Object();
            var table : String = _connection.quoteName(_table);

            for (var key : String in hash)
            {
                var keyname : String = _connection.quoteName(key);
                result[[table, keyname].join(".")] = hash[key];
            }

            return result;
        }

        private function applyWhereConditions( ... args ) : void
        {
            args = args[0] is Array ? args[0] : args;
            var numArgs : int = args.length;

            if (numArgs == 1 && args[0] && ObjectUtils.isExplicitInstanceOf(args[0], Object))
            {
                var hash : Object = !_joins ? args[0] : prependTableNameToFields(args[0]);
                var exp : Expressions = new Expressions(_connection, hash);
                _where = exp.toString();
                _whereValues = Utils.flattenArray(exp.values);
            }
            else if (numArgs > 0)
            {
                var values : Array = args.slice(1);

                for each (var param : * in values)
                {
                    if (param is Array)
                    {
                        var expression : Expressions = new Expressions(_connection, args[0]);
                        expression.bindValues(values);
                        _where = expression.toString();
                        _whereValues = Utils.flattenArray(expression.values);
                        return;
                    }
                }
                _where = args[0];
                _whereValues = values;
            }
        }

        private function buildDelete() : String
        {
            var sql : String = [SQL.DELETE, SQL.FROM, _table].join(" ");
            if (_where)
            {
                sql = [sql, SQL.WHERE, _where].join(" ");
            }

            if (_connection.acceptsLimitAndOrderForUpdateAndDelete())
            {
                if (_order)
                {
                    sql = [sql, SQL.ORDER, SQL.BY, _order].join(" ");
                }

                if (_limit)
                {
                    sql = _connection.limit(sql, -1, _limit);
                }
            }
            return sql;
        }

        private function buildInsert() : String
        {
            var keys : String = quotedKeyNames().join(",");
            var sql : String;

            if (_sequence)
            {
                sql = [SQL.INSERT, SQL.INTO, [_table, "(", keys, _connection.quoteName(_sequence[0]), ")"].join(""), [SQL.VALUES, "(?", _connection.nextSequenceValue(_sequence[1]), ")"].join("")].joins(" ");
            }
            else
            {
                sql = [SQL.INSERT, SQL.INTO, [_table, "(", keys, ")"].join(""), [SQL.VALUES, "(", SQL.PARAM, ")"].join("")].join(" ");
            }

            var e : Expressions = new Expressions(_connection, sql, Utils.getObjectValues(_data));
            return e.toString();
        }

        private function buildSelect() : String
        {
            var sql : String = [SQL.SELECT, _select, SQL.FROM, _table].join(" ");

            if (_joins)
            {
                sql = [sql, _joins].join(" ");
            }

            if (_where)
            {
                sql = [sql, SQL.WHERE, _where].join(" ");
            }

            if (_group)
            {
                sql = [sql, SQL.GROUP, SQL.BY, _group].join(" ");
            }

            if (_having)
            {
                sql = [sql, SQL.HAVING, _having].join(" ");
            }

            if (_order)
            {
                sql = [sql, SQL.ORDER, SQL.BY, _order].join(" ");
            }

            if (_limit || _offset)
            {
                sql = _connection.limit(sql, _offset, _limit);
            }

            return sql;
        }

        private function buildUpdate() : String
        {
            var sql : String;
            var sets : String;
            if (_update && _update.length > 0)
            {
                sets = _update;
            }
            else
            {
                sets = [quotedKeyNames().join("=?, "), "=?"].join("");
            }

            sql = [SQL.UPDATE, _table, SQL.SET, sets].join(" ");

            if (_where)
            {
                sql = [sql, SQL.WHERE, _where].join(" ");
            }

            if (_connection.acceptsLimitAndOrderForUpdateAndDelete())
            {
                if (_order)
                {
                    sql = [sql, SQL.ORDER, SQL.BY, _order].join(" ");
                }
                if (_limit)
                {
                    sql = _connection.limit(sql, -1, _limit);
                }
            }

            return sql;
        }

        private function quotedKeyNames() : Array
        {
            var keys : Array = [];
            for (var key : String in _data)
            {
                keys.push(_connection.quoteName(key));
            }
            return keys;
        }
    }
}
