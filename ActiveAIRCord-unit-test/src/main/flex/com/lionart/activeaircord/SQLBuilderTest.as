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
    import com.lionart.activeaircord.matchers.assertSQLHas;

    import org.flexunit.asserts.assertEquals;
    import org.hamcrest.assertThat;
    import org.hamcrest.collection.array;
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
            assertEquals("SELECT * FROM authors", _sql.toString());
        }

        [Test]
        public function testWhereWithArray() : void
        {
            _sql.where("id=? AND name IN(?)", 1, ["Tito", "Mexican"]);
            assertSQLHas("SELECT * FROM authors WHERE id=? AND name IN(?,?)", _sql.toString());
            assertThat(_sql.whereValues, array(1, "Tito", "Mexican"));
        }

        [Test]
        public function testWhereWithHash() : void
        {
            _sql.where(new AdvancedDictionary(true, ["id", "name"], [1, "Tito"]));
            assertSQLHas("SELECT * FROM authors WHERE id=? AND name=?", _sql.toString());
            assertThat(_sql.whereValues, array(1, "Tito"));
        }

        [Test]
        public function testWhereWithHashAndArray() : void
        {
            _sql.where(new AdvancedDictionary(true, ["id", "name"], [1, ["Tito", "Mexican"]]));
            assertSQLHas("SELECT * FROM authors WHERE id=? AND name IN(?,?)", _sql.toString());
            assertThat(_sql.whereValues, array(1, "Tito", "Mexican"));
        }

        [Test]
        public function testWhereWithHashAndNull() : void
        {
            _sql.where(new AdvancedDictionary(true, ["id", "name"], [1, null]));
            assertSQLHas("SELECT * FROM authors WHERE id=? AND name IS ?", _sql.toString());
            assertThat(_sql.whereValues, array(1, null));
        }

        [Test]
        public function testWhereWithNull() : void
        {
            _sql.where(null);
            assertEquals("SELECT * FROM authors", _sql.toString())
        }

        [Test]
        public function testWhereWithNoArgs() : void
        {
            _sql.where();
            assertEquals("SELECT * FROM authors", _sql.toString());
        }

        [Test]
        public function testOrder() : void
        {
            _sql.order("name");
            assertEquals("SELECT * FROM authors ORDER BY name", _sql.toString());
        }

        [Test]
        public function testLimit() : void
        {
            _sql.limit(10).offset(1);
            assertEquals(conn.limit("SELECT * FROM authors", 1, 10), _sql.toString());
        }

        [Test]
        public function testSelect() : void
        {
            _sql.select("id,name");
            assertEquals("SELECT id,name FROM authors", _sql.toString());
        }

        [Test]
        public function testJoins() : void
        {
            var join : String = "inner join books on(authors.id=books.author_id)";
            _sql.joins(join);
            assertEquals("SELECT * FROM authors " + join, _sql.toString());
        }

        [Test]
        public function testGroup() : void
        {
            _sql.group("name");
            assertEquals("SELECT * FROM authors GROUP BY name", _sql.toString());
        }

        [Test]
        public function testHaving() : void
        {
            _sql.having("created_at > '2009-01-01'");
            assertEquals("SELECT * FROM authors HAVING created_at > '2009-01-01'", _sql.toString());
        }

        [Test]
        public function testAllClausesAfterWhereShouldBeCorrectlyOrdered() : void
        {
            _sql.limit(10).offset(1);
            _sql.having("created_at > '2009-01-01'");
            _sql.order("name");
            _sql.group("name");
            _sql.where(new AdvancedDictionary(true, ["id"], [1]));
            assertSQLHas(conn.limit("SELECT * FROM authors WHERE id=? GROUP BY name HAVING created_at > '2009-01-01' ORDER BY name", 1, 10), _sql.toString());
        }

        [Test]
        public function testInsertRequiresHash() : void
        {
            assertThat(function() : void {_sql.insert([1])}, throws(allOf(instanceOf(ActiveRecordException))));
        }

        [Test]
        public function testInsert() : void
        {
            _sql.insert(new AdvancedDictionary(true, ["id", "name"], [1, "Tito"]));
            assertSQLHas("INSERT INTO authors(id,name) VALUES(?,?)", _sql.toString());
        }

        [Test]
        public function testInsertWithNull() : void
        {
            _sql.insert(new AdvancedDictionary(true, ["id", "name"], [1, null]));
            assertSQLHas("INSERT INTO authors(id,name) VALUES(?,?)", _sql.toString());
        }

        [Test]
        public function testUpdateWithHash() : void
        {
            _sql.update(new AdvancedDictionary(true, ["id", "name"], [1, "Tito"])).where("id=1 AND name IN(?)", ["Tito", "Mexican"]);
            assertSQLHas("UPDATE authors SET id=?, name=? WHERE id=1 AND name IN(?,?)", _sql.toString());
            assertThat(_sql.bindValues(), array(1, "Tito", "Tito", "Mexican"));
        }


        [Test]
        public function testUpdateWithLimitAndOrder() : void
        {
            _sql.update(new AdvancedDictionary(true, ["id"], [1])).order("name asc").limit(1);
            assertSQLHas("UPDATE authors SET id=? ORDER BY name asc LIMIT 1", _sql.toString());
        }

        [Test]
        public function testUpdateWithString() : void
        {
            _sql.update("name='Bob'");
            assertSQLHas("UPDATE authors SET name='Bob'", _sql.toString());
        }

        [Test]
        public function testUpdateWithNull() : void
        {
            _sql.update(new AdvancedDictionary(true, ["id", "name"], [1, null])).where("id=1");
            assertSQLHas("UPDATE authors SET id=?, name=? WHERE id=1", _sql.toString());
        }

        [Test]
        public function testDelete() : void
        {
            _sql.destroy();
            assertSQLHas("DELETE FROM authors", _sql.toString());
        }

        [Test]
        public function testDeleteWithWhere() : void
        {
            _sql.destroy("id=? or name in(?)", 1, ["Tito", "Mexican"]);
            assertEquals("DELETE FROM authors WHERE id=? or name in(?,?)", _sql.toString());
            assertThat(_sql.bindValues(), array(1, "Tito", "Mexican"));
        }

        [Test]
        public function testDeleteWithHash() : void
        {
            _sql.destroy(new AdvancedDictionary(true, ["id", "name"], [1, ["Tito", "Mexican"]]));
            assertSQLHas("DELETE FROM authors WHERE id=? AND name IN(?,?)", _sql.toString());
            assertThat(_sql.whereValues, array(1, "Tito", "Mexican"));
        }

        [Test]
        public function testDeleteWithLimitAndOrder() : void
        {
            _sql.destroy(new AdvancedDictionary(true, ["id"], [1])).order("name asc").limit(1);
            assertSQLHas("DELETE FROM authors WHERE id=? ORDER BY name asc LIMIT 1", _sql.toString());
        }

    }
}
