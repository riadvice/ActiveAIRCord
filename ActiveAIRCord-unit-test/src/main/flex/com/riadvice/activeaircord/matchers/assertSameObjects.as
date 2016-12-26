/*
   Copyright (C) 2012-2017 RIADVICE <ghazi.triki@riadvice.tn>

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
package com.riadvice.activeaircord.matchers
{
    import org.as3commons.lang.ObjectUtils;
    import org.flexunit.assertThat;
    import org.flexunit.asserts.assertTrue;
    import org.hamcrest.object.hasPropertyWithValue;

    public function assertSameObjects( value : Object, compared : Object ) : void
    {
        var valueKeys : Array = ObjectUtils.getKeys(value);
        var comparedKeys : Array = ObjectUtils.getKeys(compared);
        assertTrue(value is Object, compared is Object);
        assertTrue(valueKeys.length == comparedKeys.length);
        for (var i : int = 0; i < valueKeys.length; i++)
        {
            assertThat(compared, hasPropertyWithValue(valueKeys[i], value[valueKeys[i]]));
        }
    }
}
