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
package com.lionart.activeaircord.validation
{
    import com.lionart.activeaircord.Model;

    import flash.utils.Dictionary;
    import flash.utils.Proxy;
    import flash.utils.flash_proxy;

    use namespace flash_proxy;

    public class ValidationErrors extends Proxy
    {

        private var _model : Model;
        private var _errors : Dictionary;

        public function ValidationErrors( model : Model )
        {
            _model = model;
        }

        public function clearModel() : void
        {

        }

        public function add( attribute : String, msg : String ) : void
        {

        }

        public function addOnEmpty( attribute : String, msg : String ) : void
        {

        }

        override flash_proxy function getProperty( name : * ) : *
        {
            return null;
            //return _item[name];
        }

        public function addOnBlank( attribute : String, msg : String ) : void
        {

        }

        public function isInvalid( attribute : String ) : void
        {

        }

        public function on( attribute : String ) : void
        {

        }

        public function getRawErrors() : void
        {

        }

        public function fullMessages() : void
        {

        }

        public function toArray( closure : Function = null ) : void
        {

        }

        public function toString() : String
        {
            return "";
        }

        public function isEmpty() : void
        {

        }

        public function clear() : void
        {

        }

        public function size() : void
        {

        }
    }
}
