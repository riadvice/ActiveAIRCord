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
    import org.flexunit.asserts.assertEquals;
    import org.hamcrest.assertThat;
    import org.hamcrest.collection.array;

    public class ExpressionsTest
    {

        [Before]
        public function setUp() : void
        {
        }

        [After]
        public function tearDown() : void
        {
        }

        [BeforeClass]
        public static function setUpBeforeClass() : void
        {
        }

        [AfterClass]
        public static function tearDownAfterClass() : void
        {
        }

        [Test]
        public function testValues() : void
        {
            var e : Expressions = new Expressions(null, "a=? and b=?", 1, 2);
            assertThat(e.values, array(1, 2));
        }

        [Test]
        public function testOneVariable() : void
        {
            var e : Expressions = new Expressions(null, "name=?", "Tito");
            assertEquals("name=?", e.toString());
            assertThat(e.values, array("Tito"));
        }


    }
}
