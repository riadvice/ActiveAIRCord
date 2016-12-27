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
package com.riadvice.activeaircord
{
    import org.flexunit.asserts.assertEquals;

    public class SQLTypesTest
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
        public function testGetASType() : void
        {
            assertEquals(SQLTypes.getASType(SQLTypes.INTEGER), int);
            assertEquals(SQLTypes.getASType(SQLTypes.STRING), String);
            assertEquals(SQLTypes.getASType(SQLTypes.NUMBER), Number);
            assertEquals(SQLTypes.getASType(SQLTypes.DATE), Date);
            assertEquals(SQLTypes.getASType(SQLTypes.BOOLEAN), Boolean);
            assertEquals(SQLTypes.getASType(SQLTypes["XML"]), XML);
            assertEquals(SQLTypes.getASType(SQLTypes.XMLLIST), XMLList);
            assertEquals(SQLTypes.getASType(SQLTypes.OBJECT), Object);
        }

        [Test]
        public function testGetSQLType() : void
        {
            assertEquals(SQLTypes.getSQLType("int"), SQLTypes.INTEGER);
            assertEquals(SQLTypes.getSQLType("uint"), SQLTypes.INTEGER);
            assertEquals(SQLTypes.getSQLType("String"), SQLTypes.STRING);
            assertEquals(SQLTypes.getSQLType("Number"), SQLTypes.NUMBER);
            assertEquals(SQLTypes.getSQLType("Date"), SQLTypes.DATE);
            assertEquals(SQLTypes.getSQLType("Boolean"), SQLTypes.BOOLEAN);
            assertEquals(SQLTypes.getSQLType("XML"), SQLTypes.XML);
            assertEquals(SQLTypes.getSQLType("XMLList"), SQLTypes.XMLLIST);
            assertEquals(SQLTypes.getSQLType("Array"), SQLTypes.OBJECT);
        }

        [Test]
        public function testSQLTypes() : void
        {
            assertEquals(SQLTypes.BOOLEAN, "BOOLEAN");
            assertEquals(SQLTypes.DATE, "DATE");
            assertEquals(SQLTypes.INTEGER, "INTEGER");
            assertEquals(SQLTypes.NUMBER, "REAL");
            assertEquals(SQLTypes.OBJECT, "OBJECT");
            assertEquals(SQLTypes.STRING, "TEXT");
            assertEquals(SQLTypes.XML, "XML");
            assertEquals(SQLTypes.XMLLIST, "XMLLIST");
        }
    }
}
