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
    import com.lionart.activeaircord.helpers.DatabaseTest;
    import com.lionart.activeaircord.models.Author;

    import flexunit.framework.Assert;

    import org.as3commons.lang.DictionaryUtils;
    import org.hamcrest.assertThat;
    import org.hamcrest.core.allOf;
    import org.hamcrest.core.throws;
    import org.hamcrest.object.instanceOf;

    public class ActiveAIRCordTest extends DatabaseTest
    {

        [Before]
        override public function setUp() : void
        {
            super.setUp();
        }

        [After]
        override public function tearDown() : void
        {
            super.tearDown();
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
        public function testOptionsIsNot() : void
        {
            Assert.assertFalse(Author["isOptionsHash"](null));
            Assert.assertFalse(Author["isOptionsHash"](''));
            Assert.assertFalse(Author["isOptionsHash"]('tito'));
            Assert.assertFalse(Author["isOptionsHash"](new Array()));
            Assert.assertFalse(Author["isOptionsHash"]([1, 2, 3]));
        }

        [Test]
        public function testOptionsHashWithUnknownKeys() : void
        {
            assertThat(function() : void {Author["isOptionsHash"]({"conditions": "blah", "sharks": "laserz", "dubya": "bush"})}, throws(allOf(instanceOf(ActiveRecordException))));
        }

        [Test]
        public function testShouldHaveAllColumnAttributesWhenInitializingWithArray() : void
        {
            var author : Author = new Author({name: "Tito"});
            Assert.assertTrue(DictionaryUtils.getKeys(author.attributes()).length >= 10)
        }


    }
}
