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
    import flash.net.getClassByAlias;

    public class SQLTypes
    {
        public static const BOOLEAN : String = "BOOLEAN";
        public static const DATE : String = "DATE";
        public static const INTEGER : String = "INTEGER";
        public static const NUMBER : String = "REAL";
        public static const OBJECT : String = "OBJECT";
        public static const STRING : String = "TEXT";
        public static const Xml : String = "XML";
        public static const XMLLIST : String = "XMLLIST";

        /**
         * Returns the corresponding SQL type to the ActionScript type
         */
        public static function getSQLType( asType : String ) : String
        {
            switch (asType)
            {
                case "int":
                    return INTEGER;
                    break;
                case "uint":
                    return INTEGER;
                    break;
                case "String":
                    return STRING;
                    break;
                case "Number":
                    return NUMBER;
                    break;
                case "Date":
                    return DATE;
                    break;
                case "Boolean":
                    return BOOLEAN;
                    break;
                case "XML":
                    return Xml;
                    break;
                case "XMLList":
                    return XMLLIST;
                    break;
                default:
                    return OBJECT;
            }
        }

        public static function getASType( sqlType : String ) : *
        {
            switch (sqlType)
            {
                case INTEGER:
                    return int;
                case STRING:
                    return String;
                case NUMBER:
                    return Number;
                case DATE:
                    return Date;
                case BOOLEAN:
                    return Boolean;
                case Xml:
                    return XML;
                case XMLLIST:
                    return XMLList;
                default:
                    return Object;
            }
        }

    }
}
