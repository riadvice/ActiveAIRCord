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

    import flash.utils.Dictionary;

    import org.as3commons.lang.ClassUtils;

    public class Reflections
    {
        private static var _instance : Reflections;

        private static var _reflections : Dictionary = new Dictionary(true);

        private static var allowInstanciation : Boolean = false;

        public function Reflections()
        {
            if (!allowInstanciation)
            {
                throw new Error("Reflections is a singleton class. Use getInstance() method.");
            }
        }

        public static function getInstance() : Reflections
        {
            if (!_instance)
            {
                allowInstanciation = true;
                _instance = new Reflections();
                allowInstanciation = false;
            }
            return _instance;
        }

        public function add( className : String = null ) : Reflections
        {
            if (!_reflections[className])
            {
                _reflections[className] = ClassUtils.forName(Configuration.presistencePackage + "." + className);
            }
            return _instance;
        }

        public function destroy( clazz : Class ) : void
        {
            if (!_reflections[clazz])
            {
                delete _reflections[clazz];
            }
        }

        public function getClass( className : String ) : *
        {
            if (_reflections[className])
            {
                return _reflections[className];
            }
            else
            {
                throw ActiveRecordException("Class not found: " + className);
            }
            return null;
        }

    }
}
