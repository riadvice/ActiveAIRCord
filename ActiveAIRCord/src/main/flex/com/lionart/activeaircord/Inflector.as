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
    import mx.utils.StringUtil;

    import org.as3commons.lang.StringUtils;

    public final class Inflector
    {

        private static var plural : Array = [
            [/(quiz)$/i, '$1zes'],
            [/^(ox)$/i, '$1en'],
            [/^(m|l)ouse$/i, '$1ice'],
            [/(matr|vert|ind)(?:ix|ex)$/i, '$1ices'],
            [/(x|ch|ss|sh)$/i, '$1es'],
            [/([^aeiouy]|qu)y$/i, '$1ies'],
            [/(hive)$/i, '$1s'],
            [/(?:([^f])fe|([lr])f)$/i, '$1$2ves'],
            [/(shea|lea|loa|thie)f$/i, '$1ves'],
            [/sis$/i, 'ses'],
            [/([ti])um$/i, '$1a'],
            [/(bu)s$/i, '$1ses'],
            [/(octop|vir)us$/i, '$1i'],
            [/(octop|vir)i$/i, '$1i'],
            [/(alias|status)$/i, '$1es'],
            [/(buffal|tomat)o$/i, '$1oes'],
            [/([ti])a$/i, '$1a'],
            [/^(m|l)ice$/i, '$1ice'],
            [/^(oxen)$/i, '$1'],
            [/^(ax|test)is$/i, '$1es'],
            [/(us)$/i, '$1es'],
            [/s$/i, 's'],
            [/$/, 's']
            ];


        private static var singular : Array = [
            [/^(a)x[ie]s$/i, '$1xis'],
            [/(database)s$/i, '$1'],
            [/(quiz)zes$/i, '$1'],
            [/(matr)ices$/i, '$1ix'],
            [/(vert|ind)ices$/i, '$1ex'],
            [/^(ox)en/i, '$1'],
            [/(alias|status)(es)?$/i, '$1'],
            [/(octop|vir)(us|i)$/i, '$1us'],
            [/(cris|test)(is|es)$/i, '$1is'],
            [/(shoe)s$/i, '$1'],
            [/(o)es$/i, '$1'],
            [/(bus)(es)?$/i, '$1'],
            [/^(m|l)ice$/i, '$1ouse'],
            [/(x|ch|ss|sh)es$/i, '$1'],
            [/(m)ovies$/i, '$1ovie'],
            [/(s)eries$/i, '$1eries'],
            [/([^aeiouy]|qu)ies$/i, '$1y'],
            [/([lr])ves$/i, '$1f'],
            [/(tive)s$/i, '$1'],
            [/(hive)s$/i, '$1'],
            [/(shea|loa|lea|thie)ves$/i, '$1f'],
            [/(^analy)(sis|ses)$/i, '$1sis'],
            [/((a)naly|(b)a|(d)iagno|(p)arenthe|(p)rogno|(s)ynop|(t)he)(sis|ses)$/i, '$1sis'],
            [/([ti])a$/i, '$1um'],
            [/(n)ews$/i, '$1ews'],
            [/([^f])ves$/i, '$1fe'],
            [/(ss)$/i, '$1'],
            [/s$/i, '']
            ];

        private static var irregular : Array = [
            ["person", "people"],
            ["man", "men"],
            ["child", "children"],
            ["box", "boxes"],
            ["sex", "sexes"],
            ["move", "moves"],
            ["foot", "feet"],
            ["goose", "geese"],
            ["tooth", "teeth"],
            ["cow", "kine"],
            ["zombie", "zombies"]
            ];

        private static var uncountable : Array = [
            "equipment",
            "information",
            "rice",
            "money",
            "species",
            "series",
            "fish",
            "sheep",
            "deer",
            "jeans",
            "means",
            "offspring",
            "moose",
            "bison",
            "salmon",
            "pike",
            "trout",
            "swine",
            "aircraft",
            "scissors",
            "you",
            "pants",
            "shorts",
            "eyeglasses",
            "shrimp",
            "premises",
            "kudos",
            "corps",
            "elk",
            "police"
            ];

        public static function pluralize( string : String ) : String
        {
            var pattern : RegExp;

            // save some time in the case that singular and plural are the same
            // or the string is a sentence
            if (uncountable.indexOf(string.toLowerCase()) != -1 || StringUtils.countMatches(string, " ") > 0)
            {
                return string;
            }

            // check for irregular singular forms
            var item : Array;
            for each (item in irregular)
            {
                pattern = new RegExp(item[0] + "$", "i");

                if (pattern.test(string))
                {
                    return string.replace(pattern, item[1]);
                }
            }

            // check for matches using regular expressions
            for each (item in plural)
            {
                if (item[0].test(string))
                {
                    return string.replace(item[0], item[1]);
                }
            }

            return string;
        }

        public static function pluralizeIf( count : int, string : String ) : void
        {

        }

        public static function squeeze( char : String, string : String ) : void
        {

        }

        public static function singularize( string : String ) : String
        {
            var pattern : RegExp;

            // save some time in the case that singular and plural are the same
            // or the string is a sentence
            if (uncountable.indexOf(string.toLowerCase()) != -1 || StringUtils.countMatches(string, " ") > 0)
            {
                return string;
            }

            // check for irregular singular forms
            var item : Array;
            for each (item in irregular)
            {
                pattern = new RegExp(item[1] + "$", "i");

                if (pattern.test(string))
                {
                    return string.replace(pattern, item[0]);
                }
            }

            // check for matches using regular expressions
            for each (item in singular)
            {
                if (item[0].test(string))
                {
                    return string.replace(item[0], item[1]);
                }
            }

            return string;

        }

        public static function camelize( string : String ) : String
        {
            var pattern : RegExp = new RegExp("[_-]+");

            if (pattern.test(string))
            {
                string = StringUtils.trim(string).replace(pattern, "_");
            }
            string.replace(" ", "_");

            var camelized : String = "";
            for (var i : int = 0; i < string.length; i++)
            {
                if (string.charAt(i) == '_' && i + 1 < string.length)
                {
                    camelized += string.charAt(++i).toUpperCase();
                }
                else
                {
                    camelized += string.charAt(i);
                }
            }
            camelized = camelized.replace("_", "");
            if (camelized.length > 0)
            {
                camelized = camelized.charAt(0).toLowerCase() + camelized.substr(1);
            }
            return camelized;
        }

        public static function uncamelize( string : String ) : String
        {
            var normalized : String = "";
            for (var i : int = 0; i < string.length; i++)
            {
                if (StringUtils.isAlpha(string.charAt(i)) && isUpper(string.charAt(i)))
                {
                    normalized += "_" + string.charAt(i).toLowerCase();
                }
                else
                {
                    normalized += string.charAt(i);
                }
            }
            return normalized;
        }

        public static function isUpper( string : String ) : Boolean
        {
            return (string.toUpperCase() === string);
        }

        public static function isLower( string : String ) : Boolean
        {
            return (string.toLowerCase() === string);
        }

        public static function underscorify( string : String ) : String
        {
            var pattern : RegExp = new RegExp("([a-z])([A-Z])", "g");
            return string.replace(/[_\- ]+/g, "_").replace(pattern, '$1_$2');
        }

        public static function tableize( string : String ) : String
        {
            return pluralize(underscorify(string).toLowerCase());
        }

        public static function variablize( string : String ) : String
        {
            return StringUtils.replace(' ', '_', StringUtils.replace('-', '_', StringUtils.trim(string.toLowerCase())));
        }

        public static function keyify( string : String ) : String
        {
            return underscorify(string).toLowerCase() + "_id";

        }


    }
}
