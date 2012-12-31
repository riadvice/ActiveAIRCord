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
package com.lionart.activeaircord.matchers
{
    import flash.utils.Dictionary;

    import org.as3commons.lang.DictionaryUtils;
    import org.flexunit.assertThat;
    import org.flexunit.asserts.assertTrue;
    import org.hamcrest.object.hasPropertyWithValue;

    public function assertSameDictionaries( value : Dictionary, compared : Dictionary ) : void
    {
        var valueKeys : Array = DictionaryUtils.getKeys(value);
        var comparedKeys : Array = DictionaryUtils.getKeys(compared);
        assertTrue(value is Dictionary, compared is Dictionary);
        assertTrue(valueKeys.length == comparedKeys.length);
        for (var i : int = 0; i < valueKeys.length; i++)
        {
            assertThat(compared, hasPropertyWithValue(valueKeys[i], value[valueKeys[i]]));
        }
    }
}
