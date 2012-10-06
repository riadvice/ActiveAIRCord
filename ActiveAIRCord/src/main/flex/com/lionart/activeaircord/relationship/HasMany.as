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
package com.lionart.activeaircord.relationship
{
    import com.lionart.activeaircord.Model;
    import com.lionart.activeaircord.Table;

    public class HasMany extends Relationship
    {
        protected static var validAssociationOptions : Array = ["primary_key", "order", "group", "having", "limit", "offset", "through", "source"];

        protected var primaryKey : String;

        private var hasOne : Boolean = false;
        private var through : String;

        public function HasMany( options : Array )
        {
            super(options);
        }

        protected function setKeys( modelClassName : String, override : Boolean = false ) : void
        {

        }

        override public function load( model : Model ) : void
        {

        }

        private function injectForeignKeyForNewAssociation( model : Model, attributes : Array ) : void
        {

        }

        public function build_association( model : Model, attributes : Array = null ) : void
        {

        }

        public function create_association( model : Model, attributes : Array = null ) : void
        {

        }

        public function load_eagerly( table : Table, includes : Array, model : Array = null, attributes : Array = null ) : void
        {

        }
    }
}
