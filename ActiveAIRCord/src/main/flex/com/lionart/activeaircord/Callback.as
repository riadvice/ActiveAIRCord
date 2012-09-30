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
    import flash.utils.Dictionary;

    public class Callback
    {
        protected static const VALID_CALLBACKS : Array = ["after_construct",
            "before_save",
            "after_save",
            "before_create",
            "after_create",
            "before_update",
            "after_update",
            "before_validation",
            "after_validation",
            "before_validation_on_create",
            "after_validation_on_create",
            "before_validation_on_update",
            "after_validation_on_update",
            "before_destroy",
            "after_destroy"];

        private var _klass : Class;

        private var _publicMethods : Array;

        private var _registry : Array = [];

        public function Callback( modelClass : Class )
        {
        }

        public function getCallbacks() : void
        {

        }

        public function invoke( model : String, name : String, mustExist : Boolean = true ) : void
        {

        }

        public function register( name : String, closureOrMethodName : * = null, options : Dictionary = null ) : void
        {

        }
    }
}
