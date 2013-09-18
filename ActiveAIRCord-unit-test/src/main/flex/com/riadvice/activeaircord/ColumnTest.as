/*
   Copyright (C) 2012-2013 RIADVICE <ghazi.triki@riadvice.tn>

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

    import org.flexunit.asserts.assertEquals;
    import org.flexunit.asserts.fail;
    import org.hamcrest.assertThat;
    import org.hamcrest.core.isA;

    public class ColumnTest
    {
        private var column : Column;
        private var conn : SQLiteConnection;

        [Before]
        public function setUp() : void
        {
            column = new Column();
            try
            {
                conn = ConnectionManager.getConnection(Configuration.defaultConnection);
            }
            catch ( e : DatabaseException )
            {
                fail("failed to connect using default connection. " + e.message);
            }
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

        public function assertMappedType( type : String, rawType : * ) : void
        {
            column.rawType = rawType;
            assertEquals(type, column.mapRawType())
        }

        public function assertCast( type : String, castedValue : *, originalValue : * ) : void
        {
            column.type = type;
            var value : * = column.cast(originalValue, conn);

            if (originalValue != null && type == SQLTypes.DATE)
            {
                assertThat(value, isA(Date))
            }
            else
            {
                assertThat(castedValue, value);
            }
        }

        [Test]
        public function testMapRawTypeDates() : void
        {
            // assertMappedType(SQLTypes.BOOLEAN, "Boolean");
            assertMappedType(SQLTypes.DATE, "Date");
            // assertMappedType(SQLTypes.INTEGER, "int");
            // assertMappedType(SQLTypes.NUMBER, "Number");
            //assertMappedType(SQLTypes.OBJECT, "Object");
            // assertMappedType(SQLTypes.STRING, "String");
            // assertMappedType(SQLTypes.Xml, "XML");
            // assertMappedType(SQLTypes.XMLLIST, "XMLList");
        }

    }
}
