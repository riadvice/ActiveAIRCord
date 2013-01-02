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
package com.lionart.activeaircord
{
    import flash.utils.Dictionary;

    public class SingletonManager
    {
        private static var _instance : SingletonManager;

        private var singletons : Dictionary = new Dictionary();

        /**
         * @param enforcer
         */
        public function SingletonManager( enforcer : SingletonEnforcer )
        {
            if (enforcer == null)
            {
                throw new Error("Error: Instantiation failed: Use SingletonManager.instance instead.");
            }
        }

        public static function getClassReference( classReference : Class ) : *
        {
            return instance.getClassReference(classReference);
        }

        public function getClassReference( classReference : Class ) : *
        {
            var singleton : * = singletons[classReference];

            if (!singleton)
            {
                singleton = new classReference();
                singletons[classReference] = singleton;
            }

            return singleton;
        }

        /**
         * @return
         */
        private static function get instance() : SingletonManager
        {
            if (!_instance)
            {
                _instance = new SingletonManager(new SingletonEnforcer());
            }

            return _instance;
        }
    }
}

internal class SingletonEnforcer
{
}
