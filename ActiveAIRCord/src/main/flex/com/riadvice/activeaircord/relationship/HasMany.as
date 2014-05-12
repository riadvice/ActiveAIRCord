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
package com.riadvice.activeaircord.relationship
{
    import com.riadvice.activeaircord.Inflector;
    import com.riadvice.activeaircord.Model;
    import com.riadvice.activeaircord.Table;
    import com.riadvice.activeaircord.Utils;

    import flash.utils.Dictionary;

    import org.as3commons.lang.ClassUtils;
    import org.as3commons.lang.DictionaryUtils;

    public class HasMany extends Relationship
    {
        protected static var validAssociationOptions : Array = ["primary_key", "order", "group", "having", "limit", "offset", "through", "source"];

        private var hasOne : Boolean = false;
        private var through : String;

        public function HasMany( options : Dictionary )
        {
            super(options);
        }

        override protected function setKeys( modelClassName : String, override : Boolean = false ) : void
        {
            if (this._options['through'] != undefined)
            {
                this.through = this._options['through'];

                if (this._options['source'] != undefined)
                {
                    setClassName(this._options['source']);
                }
            }

            if (!this.primaryKey && this._options['primary_key'] != undefined)
            {
                this.primaryKey = this._options['primary_key'] is Array ? this._options['primary_key'] : [this._options['primary_key']];
            }

            if (!this.className)
            {
                setInferredClassName();
            }
        }

        override public function load( model : Model ) : void
        {

        }

        private function getForeignkeyForNewAssociation( model : Model ) : Dictionary
        {
            this.setKeys(ClassUtils.getName(ClassUtils.forInstance(model)));
            var primaryKey : String = Inflector.variablize(this.foreignKey[0]);

            var result : Dictionary = new Dictionary(true);

            result[primaryKey] = model["id"];
            return result;
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
