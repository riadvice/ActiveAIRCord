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

    public class Column
    {
        private var _name : String;
        private var _inflectedName : String;
        private var _type : String;
        private var _rawType : String;
        private var _length : int;
        private var _nullable : Boolean;
        private var _primaryKey : Boolean;
        private var _default : *;
        private var _autIncrement : Boolean;
        private var _sequence : Boolean;


        public function get name() : String
        {
            return _name;
        }

        public function set name( value : String ) : void
        {
            _name = value;
        }

        public function get inflectedName() : String
        {
            return _inflectedName;
        }

        public function set inflectedName( value : String ) : void
        {
            _inflectedName = value;
        }

        public function get type() : String
        {
            return _type;
        }

        public function set type( value : String ) : void
        {
            _type = value;
        }

        public function get rawType() : String
        {
            return _rawType;
        }

        public function set rawType( value : String ) : void
        {
            _rawType = value;
        }

        public function get length() : int
        {
            return _length;
        }

        public function set length( value : int ) : void
        {
            _length = value;
        }

        public function get nullable() : Boolean
        {
            return _nullable;
        }

        public function set nullable( value : Boolean ) : void
        {
            _nullable = value;
        }

        public function get primaryKey() : Boolean
        {
            return _primaryKey;
        }

        public function set primaryKey( value : Boolean ) : void
        {
            _primaryKey = value;
        }

        public function get defaultValue() : *
        {
            return _default;
        }

        public function set defaultValue( value : * ) : void
        {
            _default = value;
        }

        public function get autIncrement() : Boolean
        {
            return _autIncrement;
        }

        public function set autIncrement( value : Boolean ) : void
        {
            _autIncrement = value;
        }

        public function get sequence() : Boolean
        {
            return _sequence;
        }

        public function set sequence( value : Boolean ) : void
        {
            _sequence = value;
        }

        public function cast( value : *, connection : SQLiteConnection ) : *
        {
            if (!value)
            {
                return null;
            }
            else
            {
                // CAST TYPES USING SWITCH CASE
                return value;
            }
        }

        public function mapRawType() : String
        {
            if (!_type)
            {
                _type = SQLTypes.getSQLType(_rawType);
            }
            return _type;
        }
    }
}
