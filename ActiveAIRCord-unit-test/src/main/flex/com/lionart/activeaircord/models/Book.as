/*
   Copyright (C) 2012-2013 Ghazi Triki <ghazi.nocturne@gmail.com>

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
package com.lionart.activeaircord.models
{
    import com.lionart.activeaircord.Model;

    public class Book extends Model
    {
        public static const belongsTo : Array = ["author"];
        public static const hasOne : Array = [];
        public static const useCustomGetNameGetter : Boolean = false;

        staticInitializer(prototype.constructor);

        public function Book( attributes : Object = null, guardAttributes : Boolean = true, instantiatingViaFind : Boolean = false, newRecord : Boolean = true )
        {
            super(attributes, guardAttributes, instantiatingViaFind, newRecord);
        }

        public function upperName() : String
        {
            return String(name).toUpperCase();
        }

        public function name() : String
        {
            return String(name).toLowerCase();
        }

        public function getName() : String
        {
            if (useCustomGetNameGetter)
            {
                return String(readAttribute("name")).toUpperCase();
            }
            else
            {
                return readAttribute("name") as String;
            }
        }

        public function getUpperName() : String
        {
            return String(name).toUpperCase();
        }

        public function getLowerName() : String
        {
            return String(name).toLowerCase();
        }
    }
}
