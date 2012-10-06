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
package com.lionart.activeaircord.helpers
{
    import com.lionart.activeaircord.Configuration;
    import com.lionart.activeaircord.ConnectionManager;
    import com.lionart.activeaircord.SQLiteConnection;
    import com.lionart.activeaircord.Table;

    import flexunit.framework.Assert;

    public class DatabaseTest
    {

        protected var conn : SQLiteConnection;
        private var _originalDefaultConnection : String;
        public var connectionName : String;

        [Before]
        public function setUp() : void
        {
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
                Assert.fail("Database connection could not be established.");
            }

            // TODO : add DatabaseLoader to load fixtures
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
