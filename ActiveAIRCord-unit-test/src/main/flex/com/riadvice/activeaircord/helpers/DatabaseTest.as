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
package com.riadvice.activeaircord.helpers
{
    import com.riadvice.activeaircord.Configuration;
    import com.riadvice.activeaircord.ConnectionManager;
    import com.riadvice.activeaircord.SQLiteConnection;
    import com.riadvice.activeaircord.Table;
    import com.riadvice.activeaircord.models.Author;

    import org.flexunit.asserts.fail;

    public class DatabaseTest
    {

        protected var conn : SQLiteConnection;
        private var _originalDefaultConnection : String;
        public var connectionName : String;

        [Before]
        public function setUp() : void
        {
            var clazz : Class = Author;
            connectionName = 'sqlite';
            Table.clearCache();
            _originalDefaultConnection = Configuration.defaultConnection;
            if (connectionName)
            {
                Configuration.defaultConnection = connectionName;
            }
            try
            {
                conn = ConnectionManager.getConnection(connectionName);
            }
            catch ( e : Error )
            {
                fail("Database connection could not be established.");
            }

            var loader : DatabaseLoader = new DatabaseLoader(conn);
            loader.resetTableData();
        }

        [After]
        public function tearDown() : void
        {
            if (_originalDefaultConnection)
            {
                Configuration.defaultConnection = _originalDefaultConnection;
            }
        }

        [BeforeClass]
        public static function setUpBeforeClass() : void
        {
        }

        [AfterClass]
        public static function tearDownAfterClass() : void
        {
        }
    }
}
