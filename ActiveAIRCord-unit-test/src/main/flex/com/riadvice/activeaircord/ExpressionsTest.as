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
package com.riadvice.activeaircord
{
    import com.riadvice.activeaircord.exceptions.DatabaseException;
    import com.riadvice.activeaircord.exceptions.ExpressionsException;

    import flash.utils.Dictionary;

    import org.flexunit.asserts.assertEquals;
    import org.flexunit.asserts.fail;
    import org.hamcrest.assertThat;
    import org.hamcrest.collection.array;
    import org.hamcrest.core.allOf;
    import org.hamcrest.core.throws;
    import org.hamcrest.object.instanceOf;

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

        [Test]
        public function testArrayVariable() : void
        {
            var e : Expressions = new Expressions(null, "name IN(?) and id=?", ["Tito", "George"], 1);
            assertThat(e.values, array(array("Tito", "George"), 1));
        }

        [Test]
        public function testMultipleVariables() : void
        {
            var e : Expressions = new Expressions(null, "name=? and book=?", "Tito", "Sharks");
            assertEquals(e.toString(), "name=? and book=?");
            assertThat(e.values, array("Tito", "Sharks"));
        }

        [Test]
        public function testToString() : void
        {
            var e : Expressions = new Expressions(null, "name=? and book=?", "Tito", "Sharks");
            assertEquals(e.toString(), "name=? and book=?");
        }

        [Test]
        public function testToStringWithArrayVariable() : void
        {
            var e : Expressions = new Expressions(null, "name IN(?) and id=?", ["Tito", "George"], 1);
            assertEquals(e.toString(), "name IN(?,?) and id=?");
        }

        [Test]
        public function testToStringWithNullOptions() : void
        {
            var e : Expressions = new Expressions(null, "name=? and book=?", "Tito", "Sharks");
            var value : * = null;
            assertEquals(e.toString(false, value), "name=? and book=?");
        }

        [Test]
        public function testInsufficientVariables() : void
        {
            var e : Expressions = new Expressions(null, "name=? and id=?", "Tito");
            assertThat(function() : void {e.toString()}, throws(allOf(instanceOf(ExpressionsException))));
        }

        [Test]
        public function testNoValues() : void
        {
            var e : Expressions = new Expressions(null, "name='Tito");
            assertEquals(e.toString(), "name='Tito");
            assertEquals(e.values.length, 0);
        }

        [Test]
        public function testNullVariable() : void
        {
            var e : Expressions = new Expressions(null, "name=?", null);
            assertEquals(e.toString(), "name=?");
            assertThat(e.values, array(null));
        }

        [Test]
        public function testZeroVariable() : void
        {
            var e : Expressions = new Expressions(null, "name=?", 0);
            assertEquals(e.toString(), "name=?");
            assertThat(e.values, array(0));
        }

        [Test]
        public function testIgnoreInvalidParameterMarker() : void
        {
            var e : Expressions = new Expressions(null, "question='Do you love backslashes?' and id in(?)", [1, 2]);
            assertEquals(e.toString(), "question='Do you love backslashes?' and id in(?,?)");
        }

        [Test]
        public function testIgnoreParameterMarkerWithEscapedQuote() : void
        {
            var e : Expressions = new Expressions(null, "question='Do you love''s backslashes?' and id in(?)", [1, 2]);
            assertEquals(e.toString(), "question='Do you love''s backslashes?' and id in(?,?)");
        }

        [Test]
        public function testIgnoreParameterMarkerWithBackspaceEscapedQuote() : void
        {
            var e : Expressions = new Expressions(null, "question='Do you love\\'s backslashes?' and id in(?)", [1, 2]);
            assertEquals(e.toString(), "question='Do you love\\'s backslashes?' and id in(?,?)");
        }

        [Test]
        public function testSubstitute() : void
        {
            var e : Expressions = new Expressions(null, "name=? and id=?", "Tito", 1);
            assertEquals(e.toString(true), "name='Tito' and id=1");
        }

        [Test]
        public function testSubstituteQuotesScalarsButNot_others() : void
        {
            var e : Expressions = new Expressions(null, "id in(?)", [1, "2", 3.5]);
            assertEquals(e.toString(true), "id in(1,'2',3.5)");
        }

        [Test]
        public function testSubstituteWhereValueHasQuestionMark() : void
        {
            var e : Expressions = new Expressions(null, "name=? and id=?", "??????", 1);
            assertEquals(e.toString(true), "name='??????' and id=1");
        }

        [Test]
        public function testSubstituteArrayValue() : void
        {
            var e : Expressions = new Expressions(null, "id in(?)", [1, 2]);
            assertEquals(e.toString(true), "id in(1,2)");
        }

        [Test]
        public function testSubstituteEscapesQuotes() : void
        {
            var e : Expressions = new Expressions(null, "name=? or name in(?)", "Tito's Guild", [1, "Tito's Guild"]);
            assertEquals(e.toString(true), "name='Tito''s Guild' or name in(1,'Tito''s Guild')");
        }

        [Test]
        public function testSubstituteEscapeQuotesWithConnectionsEscapeMethod() : void
        {
            var conn : SQLiteConnection;
            try
            {
                conn = ConnectionManager.getConnection();
            }
            catch ( e : DatabaseException )
            {
                fail("failed to connect. " + e.message)
            }
            var e : Expressions = new Expressions(null, "name=?", "Tito's Guild");
            e.connection = conn;
            var escaped : String = conn.escape("Tito's Guild");
            assertEquals(e.toString(true), "name=" + escaped);
        }

        [Test]
        public function testBind() : void
        {
            var e : Expressions = new Expressions(null, "name=? and id=?", "Tito");
            e.bind(2, 1);
            assertThat(e.values, array("Tito", 1));
        }

        [Test]
        public function testBindOverwriteExisting() : void
        {
            var e : Expressions = new Expressions(null, "name=? and id=?", "Tito", 1);
            e.bind(2, 99);
            assertThat(e.values, array("Tito", 99));
        }

        [Test]
        public function testBindInvalidParameterNumber() : void
        {
            var e : Expressions = new Expressions(null, "name=?");
            assertThat(function() : void {e.bind(0, 99)}, throws(allOf(instanceOf(ExpressionsException))));
        }

        [Test]
        public function testSubsituteUsingAlternateValues() : void
        {
            var e : Expressions = new Expressions(null, "name=?", "Tito");
            assertEquals("name='Tito'", e.toString(true));
            var params : Dictionary = new Dictionary(true);
            params["values"] = ["Hocus"];
            assertEquals(e.toString(true, params), "name='Hocus'");
        }

        [Test]
        public function testNullValue() : void
        {
            var e : Expressions = new Expressions(null, "name=?", null);
            assertEquals(e.toString(true), "name=NULL");
        }

        [Test]
        public function testHashWithDefaultGlue() : void
        {
			// FIXME
            var params : Dictionary = new Dictionary(true);
            params["id"] = 1;
            params["name"] = "Tito";
            var e : Expressions = new Expressions(null, params);
            assertEquals("id=? AND name=?", e.toString());
        }

        [Test]
        public function testHashWithGlue() : void
        {
            var params : Dictionary = new Dictionary(true);
            params["id"] = 1;
            params["name"] = "Tito";
            var e : Expressions = new Expressions(null, params, ', ');
            assertEquals(e.toString(), "id=?, name=?");
        }

        [Test]
        public function testHashWithArray() : void
        {
			// FIXME
            var params : Dictionary = new Dictionary(true);
            params["id"] = 1;
            params["name"] = new Dictionary(true);
            params["name"] = ["Tito", "Mexican"];
            var e : Expressions = new Expressions(null, params);
            assertEquals("id=? AND name IN(?,?)", e.toString());
        }

    }
}
