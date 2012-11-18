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
    import com.lionart.activeaircord.exceptions.UndefinedPropertyException;
    import com.lionart.activeaircord.helpers.DatabaseTest;
    import com.lionart.activeaircord.models.Author;
    import com.lionart.activeaircord.models.Book;

    import flash.utils.Dictionary;

    import org.as3commons.lang.DictionaryUtils;
    import org.flexunit.asserts.assertEquals;
    import org.flexunit.asserts.assertFalse;
    import org.flexunit.asserts.assertTrue;
    import org.hamcrest.assertThat;
    import org.hamcrest.collection.array;
    import org.hamcrest.core.allOf;
    import org.hamcrest.core.throws;
    import org.hamcrest.object.hasProperty;
    import org.hamcrest.object.instanceOf;
    import org.hamcrest.text.containsString;

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
            var arguments : Array = ["first", optionsDict];
            assertEquals(optionsDict, Author["extractAndValidateOptions"](arguments));
            assertThat(arguments, array("first"));
            // TODO : test with simple object
        }

        [Test]
        public function testExtractAndValidateOptionsWithArrayInArgs() : void
        {
            var arguments : Array = ["first", [1, 2], optionsDict];
            assertEquals(optionsDict, Author["extractAndValidateOptions"](arguments))
        }

        [Test]
        public function testExtractAndValidateOptionsRemovesOptionsHash() : void
        {
            var arguments : Array = ["first", optionsDict];
            Author["extractAndValidateOptions"](arguments);
            assertThat(arguments, array("first"));
        }

        [Test]
        public function testExtractAndValidateOptionsNope() : void
        {
            var arguments : Array = ["first"];
            assertThat(new Dictionary(), Author["extractAndValidateOptions"](arguments));
            assertThat(arguments, array("first"));
        }

        [Test]
        public function testExtractAndValidateOptionsNopeBecauseWasntAtEnd() : void
        {
            var args : Array = ["first", optionsDict, [1, 2]];
            assertEquals(DictionaryUtils.getKeys(Author["extractAndValidateOptions"](args)).length, 0);
        }

        [Test]
        public function testInvalidAttribute() : void
        {
            var options : Dictionary = new Dictionary();
            options["conditions"] = "author_id=1";
            var author : Author = Author["find"]("first", options);
            assertThat(function() : void {author.invalidField}, throws(allOf(instanceOf(UndefinedPropertyException))));
        }

        //[Test]
        public function testInvalidAttributes() : void
        {
            var book : Book = Book["find"](1);
            var attributes : Dictionary = new Dictionary(true);
            attributes["name"] = "new name";
            attributes["invalid_attribute"] = true;
            attributes["another_invalid_attribute"] = "new something";
            try
            {
                book.updateAttributes(attributes);
            }
            catch ( e : UndefinedPropertyException )
            {
                var exceptions : Array = String(e.message).split("\r\n");
            }

            // TODO
            //assertEquals(1, String(exceptions[0]).match(new RegExp("invalid_attribute", "g")).length);
            assertEquals(1, String(exceptions[0]).match(new RegExp("another_invalid_attribute", "g")).length);
        }

        [Test]
        public function testGetterUndefinedPropertyExceptionIncludesModelName() : void
        {
            var author : Author = new Author();
            assertThat(function() : void {author.this_better_not_exist}, throws(allOf(instanceOf(UndefinedPropertyException), hasProperty("message", containsString("Author.this_better_not_exist")))));
        }

        [Test]
        public function testMassAssignmentUndefinedPropertyExceptionIncludesModelName() : void
        {
            assertThat(function() : void {new Author({"this_better_not_exist": "hi"})}, throws(allOf(instanceOf(UndefinedPropertyException) /*, hasProperty("message", containsString("Author.this_better_not_exist"))*/)));
        }

        [Test]
        public function testSetterUndefinedPropertyExceptionIncludesModelName() : void
        {
            var author : Author = new Author();
            assertThat(function() : void {author.this_better_not_exist = "hi"}, throws(allOf(instanceOf(UndefinedPropertyException), hasProperty("message", containsString("Author.this_better_not_exist")))));
        }

        [Test]
        public function testShouldHaveAllColumnAttributesWhenInitializingWithArray() : void
        {
            var author : Author = new Author({name: "Tito"});
            assertTrue(DictionaryUtils.getKeys(author.attributes()).length >= 10)
        }

    }
}
