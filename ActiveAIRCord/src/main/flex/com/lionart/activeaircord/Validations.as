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
    import com.lionart.activeaircord.validation.ValidationErrors;

    import flash.utils.Dictionary;

    import org.as3commons.lang.ClassUtils;
    import org.as3commons.reflect.Field;

    public class Validations
    {
        private var _model : Model;
        private var _options : Dictionary = new Dictionary(true);
        private var _validators : Dictionary = new Dictionary(true);
        private var _record : ValidationErrors;
        private var _clazz : Class;

        private static const VALIDATION_FUNCTIONS : Array = ["validates_presence_of",
            "validates_size_of",
            "validates_length_of",
            "validates_inclusion_of",
            "validates_exclusion_of",
            "validates_format_of",
            "validates_numericality_of",
            "validates_uniqueness_of"];

        private static const DEFAULT_VALIDATION_OPTIONS : AdvancedDictionary = new AdvancedDictionary(true,
            ["on", "allow_null", "allow_blank", "message"],
            ["save", false, false, null]);

        private static const ALL_RANGE_OPTIONS : AdvancedDictionary = new AdvancedDictionary(true,
            ["is", "within", "in", "minimum", "maximum"],
            [null, null, null, null, null]);

        private static const ALL_NUMERICALITY_CHECKS : AdvancedDictionary = new AdvancedDictionary(true,
            ["greater_than", "greater_than_or_equal_to", "equal_to", "less_than", "less_than_or_equal_to", "odd", "even"],
            [null, null, null, null, null, null, null]);

        public function Validations( model : Model )
        {
            _model = model;
            _record = new ValidationErrors(_model);
            //_clazz = Reflections.getInstance().getClass(Class(model)) as Class;

            var properties : Object = ClassUtils.getProperties(_clazz);
            for each (var property : Field in properties)
            {
                if (property.isStatic && VALIDATION_FUNCTIONS.indexOf(property.name) > -1)
                {
                    _validators[property.name] = property.getValue();
                }
            }
        }

        public function get record() : ValidationErrors
        {
            return _record;
        }

        public function rules() : Dictionary
        {
            var data : Dictionary = new Dictionary(true);
            for each (var validator : String in _validators)
            {
                var attributes : * = _validators[validator];
                for each (var attribute : * in Utils.wrapStringsInArrays(attributes))
                {
                    var field : String = attribute[0];
                    if (!data[field] || !(data[field] is Array))
                    {
                        data[field] = [];
                    }

                    attribute["validator"] = validator;
                    (data[field] as Array).push(attribute);
                }
            }
            return data;
        }

        public function validate() : ValidationErrors
        {
            for each (var validator : String in _validators)
            {
                var definition : String = _validators[validator];
            }
            return _record;
        }

        public function validatesPresenceOf( attrs : Array ) : void
        {

        }

        public function validatesInclusionOf( attrs : Array ) : void
        {

        }

        public function validatesExclusionOf( attrs : Array ) : void
        {

        }

        public function validatesInclusionOrExclusionOf( type : String, attrs : Array ) : void
        {

        }

        public function validatesNumericalityOf( attrs : Array ) : void
        {

        }

        public function validatesSizeOf( attrs : Array ) : void
        {

        }

        public function validatesFormatOf( attrs : Array ) : void
        {

        }

        public function validatesLengthOf( attrs : Array ) : void
        {

        }

        public function validatesUniquenessOf( attrs : Array ) : void
        {

        }

        private function isNullWithOption( variable : String, options : Array ) : void
        {

        }

        private function isBlankWithOption( variable : String, options : Array ) : void
        {

        }

    }
}
