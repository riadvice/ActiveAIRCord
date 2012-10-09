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
    import com.lionart.activeaircord.exceptions.ActiveRecordException;

    import flash.utils.Dictionary;

    import org.as3commons.lang.ArrayUtils;

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

        public function Callback( modelClass : String )
        {
            _klass = Reflections.getInstance().getClass(modelClass);

            for each (var name : String in VALID_CALLBACKS)
            {
                var definition : * = _klass[name];
                if (!(definition is Array))
                {
                    definition = [definition];
                }
                for each (var method : String in definition)
                {
                    register(name, method);
                }
            }
        }

        public function getCallbacks() : void
        {

        }

        public function invoke( model : String, name : String, mustExist : Boolean = true ) : void
        {

        }

        public function register( name : String, functionOrMethodName : * = null, options : Dictionary = null ) : void
        {
            options ||= new Dictionary();
            options["prepend"] = false;
            if (!functionOrMethodName)
            {
                functionOrMethodName = name;
            }
            if (!ArrayUtils.contains(VALID_CALLBACKS, name))
            {
                throw new ActiveRecordException("Invalid callback: " + name);
            }
            if (!(functionOrMethodName is Function))
            {
                // TODO
            }
            if (!_registry[name])
            {
                _registry[name] = [];
            }
            // TODO
        }
    }
}
