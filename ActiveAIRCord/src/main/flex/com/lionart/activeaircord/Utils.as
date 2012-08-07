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

    public final class Utils
    {
        public static function classify( className : String ) : String
        {
            return null;
        }

        public static function flatternArray( array : Array ) : Array
        {
            var result : Array = [];
            var i : int = 0;

            while (i < array.length)
            {
                if (array[i] is Array)
                {
                    result.push((array[i] as Array).splice());
                }
                else
                {
                    ++i;
                }
            }
            return result;
        }

        public static function denamespace( className : String ) : void
        {

        }

        public static function hasNamespace( className : String ) : void
        {

        }

        public static function getNamespaces( className : String ) : void
        {

        }

        public static function all( needle : String, haystack : Array ) : void
        {

        }

        public static function collect( enumerable : Array, nameOrClosure : * ) : void
        {

        }

        public static function wrapStringsInArrays( strings : * ) : Array
        {
            var result : Array;
            if (!(strings is Array))
            {
                result = new Array(new Array(strings));
            }
            else
            {
                for each (var string : * in strings)
                {
                    if (!(string is Array))
                    {
                        result.push(new Array(string));
                    }
                    else
                    {
                        result.push(string);
                    }
                }
            }
            return result;
        }

        public static function extractOptions( options : Array ) : void
        {

        }

        public static function addCondition( condition : String, conditions = null, conjuction : String = SQL.AND ) : void
        {

        }

        public static function humanAttribute( attr : String ) : void
        {

        }

        public static function isOdd( number : Number ) : Boolean
        {
            return number & 1;
        }

        public static function isA( type : Class, variable : * ) : void
        {

        }

        public static function isBlank( variable : String ) : void
        {

        }

    }
}
