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
    import com.riadvice.activeaircord.exceptions.ActiveRecordException;
    import com.riadvice.activeaircord.helpers.DatabaseTest;
    import com.riadvice.activeaircord.matchers.assertSQLHas;
    import com.riadvice.activeaircord.matchers.assertSameDictionaries;

    import flash.utils.Dictionary;

    import org.flexunit.asserts.assertEquals;
    import org.flexunit.asserts.assertNull;
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

        public function assertConditions( expectedSql : String, values : Array, underscoredString : String, map : Dictionary = null ) : void
        {
            var conditions : Array = SQLBuilder.createConditionsFromUnderscoredString(_table.conn, underscoredString, values, map);
            assertSQLHas(expectedSql, conditions.shift());

            if (values)
            {
                var filteredArray : Array = values.filter(function assertConditionsFilter( element : *, index : int, arr : Array ) : Boolean
                {
                    return element !== null;
                });
                assertThat(conditions, filteredArray);
            }
            else
            {
                assertThat(conditions, array());
            }
        }

        protected function conditionsFromString( name : String, values : Array = null, map : Dictionary = null ) : Array
        {
            return SQLBuilder.createConditionsFromUnderscoredString(_table.conn, name, values, map);
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
            _sql.where(new Hash(true, ["id", "name"], [1, "Tito"]));
            assertSQLHas("SELECT * FROM authors WHERE id=? AND name=?", _sql.toString());
            assertThat(_sql.whereValues, array(1, "Tito"));
        }

        [Test]
        public function testWhereWithHashAndArray() : void
        {
            _sql.where(new Hash(true, ["id", "name"], [1, ["Tito", "Mexican"]]));
            assertSQLHas("SELECT * FROM authors WHERE id=? AND name IN(?,?)", _sql.toString());
            assertThat(_sql.whereValues, array(1, "Tito", "Mexican"));
        }

        [Test]
        public function testWhereWithHashAndNull() : void
        {
            _sql.where(new Hash(true, ["id", "name"], [1, null]));
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
            _sql.where(new Hash(true, ["id"], [1]));
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
            _sql.insert(new Hash(true, ["id", "name"], [1, "Tito"]));
            assertSQLHas("INSERT INTO authors(id,name) VALUES(?,?)", _sql.toString());
        }

        [Test]
        public function testInsertWithNull() : void
        {
            _sql.insert(new Hash(true, ["id", "name"], [1, null]));
            assertSQLHas("INSERT INTO authors(id,name) VALUES(?,?)", _sql.toString());
        }

        [Test]
        public function testUpdateWithHash() : void
        {
            _sql.update(new Hash(true, ["id", "name"], [1, "Tito"])).where("id=1 AND name IN(?)", ["Tito", "Mexican"]);
            assertSQLHas("UPDATE authors SET id=?, name=? WHERE id=1 AND name IN(?,?)", _sql.toString());
            assertThat(_sql.bindValues(), array(1, "Tito", "Tito", "Mexican"));
        }


        [Test]
        public function testUpdateWithLimitAndOrder() : void
        {
            _sql.update(new Hash(true, ["id"], [1])).order("name asc").limit(1);
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
            _sql.update(new Hash(true, ["id", "name"], [1, null])).where("id=1");
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
            _sql.destroy(new Hash(true, ["id", "name"], [1, ["Tito", "Mexican"]]));
            assertSQLHas("DELETE FROM authors WHERE id=? AND name IN(?,?)", _sql.toString());
            assertThat(_sql.whereValues, array(1, "Tito", "Mexican"));
        }

        [Test]
        public function testDeleteWithLimitAndOrder() : void
        {
            _sql.destroy(new Hash(true, ["id"], [1])).order("name asc").limit(1);
            assertSQLHas("DELETE FROM authors WHERE id=? ORDER BY name asc LIMIT 1", _sql.toString());
        }

        [Test]
        public function testReverseOrder() : void
        {
            assertEquals("id ASC, name DESC", SQLBuilder.reverseOrder("id DESC, name ASC"));
            assertEquals("id ASC, name DESC , zzz ASC", SQLBuilder.reverseOrder("id DESC, name ASC , zzz DESC"));
            assertEquals("id DESC, name DESC", SQLBuilder.reverseOrder("id, name"));
            assertEquals("id DESC", SQLBuilder.reverseOrder("id"));
            assertEquals("", SQLBuilder.reverseOrder(""));
            assertEquals(" ", SQLBuilder.reverseOrder(" "));
            assertEquals(null, SQLBuilder.reverseOrder(null));
        }


        [Test]
        public function testCreateConditionsFromUnderscoredString() : void
        {
            assertConditions("id=? AND name=? OR z=?", [1, "Tito", "X"], "id_and_name_or_z");
            assertConditions("id=?", [1], "id");
            assertConditions("id IN(?)", [[1, 2]], "id");
        }


        [Test]
        public function testCreateConditionsFromUnderscoredStringWithNulls() : void
        {
            assertConditions("id=? AND name IS NULL", [1, null], "id_and_name");
        }


        [Test]
        public function testCreateConditionsFromUnderscoredStringWithMissingArgs() : void
        {
            assertConditions("id=? AND name IS NULL OR z IS NULL", [1, null], "id_and_name_or_z");
            assertConditions("id IS NULL", null, "id");
        }

        [Test]
        public function testCreateConditionsFromUnderscoredStringWithBlank() : void
        {
            assertConditions("id=? AND name IS NULL OR z=?", [1, null, ""], "id_and_name_or_z");
        }


        [Test]
        public function testCreateConditionsFromUnderscoredStringInvalid() : void
        {
            assertNull(conditionsFromString(""));
            assertNull(conditionsFromString(null));
        }


        [Test]
        public function testCreateConditionsFromUnderscoredStringWithMappedColumns() : void
        {
            assertConditions("id=? AND name=?", [1, "Tito"], "id_and_my_name", new Hash(true, ["my_name"], ["name"]));
        }

        [Test]
        public function testCreateHashFromUnderscoredString() : void
        {
            var values : Array = [1, "Tito"];
            var hash : Dictionary = SQLBuilder.createHashFromUnderscoredString("id_and_my_name", values);
            var expectedHash : Dictionary = new Dictionary(true);
            expectedHash["id"] = 1;
            expectedHash["my_name"] = "Tito";
            assertSameDictionaries(hash, expectedHash);
        }

        [Test]
        public function testCreateHashFromUnderscoredStringWithMappedColumns() : void
        {
            var values : Array = [1, "Tito"];
            var map : Dictionary = new Hash(true, ["my_name"], ["name"]);
            var hash : Dictionary = SQLBuilder.createHashFromUnderscoredString("id_and_my_name", values, map);
            var expectedHash : Dictionary = new Dictionary(true);
            expectedHash["id"] = 1;
            expectedHash["name"] = "Tito";
            assertSameDictionaries(hash, expectedHash);
        }

        // FIXME
        [Test]
        public function testWhereWithJoinsPrependsTableNameToFields() : void
        {
            var joins : String = "INNER JOIN books ON (books.id = authors.id)";
            // joins needs to be called prior to where
            _sql.joins(joins);
            _sql.where(new Hash(true, ["id", "name"], [1, "Tito"]));
            assertSQLHas("SELECT * FROM authors " + joins + " WHERE authors.id=? AND authors.name=?", _sql.toString());
        }

    }
}
