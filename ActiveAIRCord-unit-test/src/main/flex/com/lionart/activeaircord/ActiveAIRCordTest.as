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

    import flash.utils.Dictionary;

    import org.as3commons.lang.DictionaryUtils;
    import org.flexunit.asserts.assertFalse;
    import org.flexunit.asserts.assertTrue;
    import org.hamcrest.assertThat;
    import org.hamcrest.core.allOf;
    import org.hamcrest.core.throws;
    import org.hamcrest.object.instanceOf;

    public class ActiveAIRCordTest extends DatabaseTest
    {

        private var optionsDict : Dictionary;
        private var optionsObj : Object;

        [Before]
        override public function setUp() : void
        {
            super.setUp();
            optionsDict = new Dictionary(true);
            optionsDict["conditions"] = "condition";
            optionsDict["order"] = "desc";

            optionsObj = {"conditions": "condition", "order": "asc"};
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
            assertFalse(Author["isOptionsHash"](null));
            assertFalse(Author["isOptionsHash"](''));
            assertFalse(Author["isOptionsHash"]('tito'));
            assertFalse(Author["isOptionsHash"](new Array()));
            assertFalse(Author["isOptionsHash"]([1, 2, 3]));
        }

        [Test]
        public function testOptionsHashWithUnknownKeys() : void
        {
            assertThat(function() : void {Author["isOptionsHash"]({"conditions": "blah", "sharks": "laserz", "dubya": "bush"})}, throws(allOf(instanceOf(ActiveRecordException))));
        }

        [Test]
        public function testOptionsIsHash() : void
        {
            assertTrue(Author["isOptionsHash"](optionsDict));
            assertTrue(Author["isOptionsHash"](optionsObj));
        }

        [Test]
        public function testExtractAndValidateOptions() : void
        {

        }

        [Test]
        public function testShouldHaveAllColumnAttributesWhenInitializingWithArray() : void
        {
            var author : Author = new Author({name: "Tito"});
            assertTrue(DictionaryUtils.getKeys(author.attributes()).length >= 10)
        }


    }
}
