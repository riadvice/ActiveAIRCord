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
    import com.lionart.activeaircord.exceptions.AdvancedDictionaryException;

    import flash.utils.Dictionary;

    public dynamic class AdvancedDictionary extends Dictionary
    {
        public function AdvancedDictionary( weakKeys : Boolean = false, keys : Array = null, values : Array = null )
        {
            super(weakKeys);
            if (keys && values && keys.length != values.length)
            {
                throw new AdvancedDictionaryException("keys and values for AdvancedDictionary must have the same length");
            }
            for (var i : int = 0; i < keys.length; i++)
            {
                this[keys[i]] = values[i];
            }
        }
    }
}
