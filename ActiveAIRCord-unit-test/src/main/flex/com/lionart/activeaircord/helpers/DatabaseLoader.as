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
    import com.lionart.activeaircord.SQL;
    import com.lionart.activeaircord.SQLiteConnection;

    import flash.filesystem.File;

    public class DatabaseLoader
    {
        private var _connection : SQLiteConnection;

        public function DatabaseLoader( connection : SQLiteConnection )
        {
            _connection = connection;
            dropTables();
            executeSQLScript(_connection);
        }

        public function executeSQLScript( connection : SQLiteConnection ) : void
        {

        }

        public function dropTables() : void
        {
            var tables : Array = _connection.tables();

            for each (var table : String in getFixtureTable())
            {
                if (tables.indexOf(table) != -1)
                {
                    _connection.query([SQL.DROP, SQL.TABLE, _connection.quoteName(table)].join(" "));
                }
            }
        }

        public function resetTableData() : void
        {

        }

        public function getFixtureTable() : Array
        {
            var tables : Array = [];
            var fixturesDirectory : File = new File(File.applicationDirectory.nativePath + File.separator + "fixtures");
            if (!fixturesDirectory.exists)
            {
                throw new Error("Fixtures directory does not exist");
            }
            for each (var file : File in fixturesDirectory.getDirectoryListing())
            {
                if (file.type == ".csv")
                {
                    tables.push(file.name.replace(file.type, ""));
                }
            }
            return tables;
        }
    }
}
