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

    import org.flexunit.assertThat;
    import org.flexunit.asserts.assertEquals;
    import org.hamcrest.core.allOf;
    import org.hamcrest.core.throws;
    import org.hamcrest.object.hasPropertyWithValue;
    import org.hamcrest.object.instanceOf;

    public class SQLBuilderTest extends DatabaseTest
    {

        private var _tableName : String = "authors";
        private var _className : String = "Author";
        private var _table : Table;
        private var _sql : SQLBuilder;

        [Before]
        override public function setUp() : void
        {
            super.setUp();
            _sql = new SQLBuilder(conn, _tableName);
            _table = Table.load(_className);
        }

        [After]
        override public function tearDown() : void
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
        public function testNoConnection() : void
        {
            assertThat(function() : void {new SQLBuilder(null, "authors")}, throws(allOf(instanceOf(ActiveRecordException), hasPropertyWithValue("message", "A valid database connection is required."))));
        }

        [Test]
        public function testNothing() : void
        {
            assertEquals("SELECT ALL FROM authors", _sql.toString());
        }

        [Test]
        public function testWhereWithArray() : void
        {
            _sql.where("id=? AND name IN(?)", 1, ['Tito', 'Mexican']);
            //assert_sql_has("SELECT ALL FROM authors WHERE id=? AND name IN(?,?)",_sql.toString());
            assertThat([1, "Tito", "Mexican"], _sql.whereValues);
        }


    }
}
