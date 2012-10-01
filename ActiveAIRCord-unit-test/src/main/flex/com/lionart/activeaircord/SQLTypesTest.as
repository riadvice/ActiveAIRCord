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
    import flexunit.framework.Assert;

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
            Assert.assertEquals(SQLTypes.getASType(SQLTypes.INTEGER), int);
            Assert.assertEquals(SQLTypes.getASType(SQLTypes.STRING), String);
            Assert.assertEquals(SQLTypes.getASType(SQLTypes.NUMBER), Number);
            Assert.assertEquals(SQLTypes.getASType(SQLTypes.DATE), Date);
            Assert.assertEquals(SQLTypes.getASType(SQLTypes.BOOLEAN), Boolean);
            Assert.assertEquals(SQLTypes.getASType(SQLTypes.Xml), XML);
            Assert.assertEquals(SQLTypes.getASType(SQLTypes.XMLLIST), XMLList);
            Assert.assertEquals(SQLTypes.getASType(SQLTypes.OBJECT), Object);
        }

        [Test]
        public function testGetSQLType() : void
        {
            Assert.assertEquals(SQLTypes.getSQLType('int'), SQLTypes.INTEGER);
            Assert.assertEquals(SQLTypes.getSQLType('uint'), SQLTypes.INTEGER);
            Assert.assertEquals(SQLTypes.getSQLType('String'), SQLTypes.STRING);
            Assert.assertEquals(SQLTypes.getSQLType('Number'), SQLTypes.NUMBER);
            Assert.assertEquals(SQLTypes.getSQLType('Date'), SQLTypes.DATE);
            Assert.assertEquals(SQLTypes.getSQLType('Boolean'), SQLTypes.BOOLEAN);
            Assert.assertEquals(SQLTypes.getSQLType('XML'), SQLTypes.Xml);
            Assert.assertEquals(SQLTypes.getSQLType('XMLList'), SQLTypes.XMLLIST);
            Assert.assertEquals(SQLTypes.getSQLType('Array'), SQLTypes.OBJECT);
        }

        [Test]
        public function testSQLTypes() : void
        {
            Assert.assertEquals(SQLTypes.BOOLEAN, "BOOLEAN");
            Assert.assertEquals(SQLTypes.DATE, "DATE");
            Assert.assertEquals(SQLTypes.INTEGER, "INTEGER");
            Assert.assertEquals(SQLTypes.NUMBER, "REAL");
            Assert.assertEquals(SQLTypes.OBJECT, "OBJECT");
            Assert.assertEquals(SQLTypes.STRING, "TEXT");
            Assert.assertEquals(SQLTypes.Xml, "XML");
            Assert.assertEquals(SQLTypes.XMLLIST, "XMLLIST");
        }
    }
}
