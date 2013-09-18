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

    import com.riadvice.activeaircord.helpers.Config;

    import org.flexunit.asserts.assertEquals;

    public class InflectorTest
    {

        private static var singularToPlural : Array;
        private static var toUnderscore : Array;
        private static var toTabelize : Array;
        private static var toKeyify : Array;

        [Before]
        public function setUp() : void
        {
            Config.initConfig();
        }

        [After]
        public function tearDown() : void
        {
        }

        [BeforeClass]
        public static function setUpBeforeClass() : void
        {
            singularToPlural = [
                ["search", "searches"],
                ["switch", "switches"],
                ["fix", "fixes"],
                ["box", "boxes"],
                ["process", "processes"],
                ["address", "addresses"],
                ["case", "cases"],
                ["stack", "stacks"],
                ["wish", "wishes"],
                ["fish", "fish"],
                ["jeans", "jeans"],
                ["funky jeans", "funky jeans"],
                ["my money", "my money"],

                ["category", "categories"],
                ["query", "queries"],
                ["ability", "abilities"],
                ["agency", "agencies"],
                ["movie", "movies"],

                ["archive", "archives"],

                ["index", "indices"],

                ["wife", "wives"],
                ["safe", "saves"],
                ["half", "halves"],

                ["move", "moves"],

                ["salesperson", "salespeople"],
                ["person", "people"],

                ["spokesman", "spokesmen"],
                ["man", "men"],
                ["woman", "women"],

                ["basis", "bases"],
                ["diagnosis", "diagnoses"],
                ["diagnosis_a", "diagnosis_as"],

                ["datum", "data"],
                ["medium", "media"],
                ["stadium", "stadia"],
                ["analysis", "analyses"],
                ["my_analysis", "my_analyses"],

                ["node_child", "node_children"],
                ["child", "children"],

                ["experience", "experiences"],
                ["day", "days"],

                ["comment", "comments"],
                ["foobar", "foobars"],
                ["newsletter", "newsletters"],

                ["old_news", "old_news"],
                ["news", "news"],

                ["series", "series"],
                ["species", "species"],

                ["quiz", "quizzes"],

                ["perspective", "perspectives"],

                ["ox", "oxen"],
                ["photo", "photos"],
                ["buffalo", "buffaloes"],
                ["tomato", "tomatoes"],
                ["dwarf", "dwarves"],
                ["elf", "elves"],
                ["information", "information"],
                ["equipment", "equipment"],
                ["bus", "buses"],
                ["status", "statuses"],
                ["status_code", "status_codes"],
                ["mouse", "mice"],

                ["louse", "lice"],
                ["house", "houses"],
                ["octopus", "octopi"],
                ["virus", "viri"],
                ["alias", "aliases"],
                ["portfolio", "portfolios"],

                ["vertex", "vertices"],
                ["matrix", "matrices"],
                ["matrix_fu", "matrix_fus"],

                ["axis", "axes"],
                ["taxi", "taxis"], // prevents regression
                ["testis", "testes"],
                ["crisis", "crises"],

                ["rice", "rice"],
                ["shoe", "shoes"],

                ["horse", "horses"],
                ["prize", "prizes"],
                ["edge", "edges"],

                ["cow", "kine"],
                ["database", "databases"],

                //regression tests against improper inflection regexes
                ["|ice", "|ices"],
                ["|ouse", "|ouses"],
                ["slice", "slices"],
                ["police", "police"]

                ];

            toUnderscore = [
                ["OneTwoThree", "One_Two_Three"],
                ["banana", "banana"]
                ];

            toTabelize = [
                ["AngryPerson", "angry_people"],
                ["MySQL", "my_sqls"]
                ];

            toKeyify = [
                ["BuildingType", "building_type_id"]
                ];
        }

        [AfterClass]
        public static function tearDownAfterClass() : void
        {
        }

        [Test]
        public function testCamelize() : void
        {
            assertEquals(Inflector.camelize("One_Two_Three"), "oneTwoThree");
        }

        [Test]
        public function testPluralize() : void
        {
            for each (var couple : Array in singularToPlural)
            {
                assertEquals(Inflector.pluralize(couple[0]), couple[1]);
            }
        }

        [Test]
        public function testSingularize() : void
        {
            for each (var couple : Array in singularToPlural)
            {
                assertEquals(Inflector.singularize(couple[1]), couple[0]);
            }
        }

        [Test]
        public function testUnderscorify() : void
        {
            for each (var couple : Array in toUnderscore)
            {
                assertEquals(Inflector.underscorify(couple[0]), couple[1]);
            }
        }

        [Test]
        public function testTabelize() : void
        {
            for each (var couple : Array in toTabelize)
            {
                assertEquals(Inflector.tableize(couple[0]), couple[1]);
            }
        }

        [Test]
        public function testKeyify() : void
        {
            for each (var couple : Array in toKeyify)
            {
                assertEquals(Inflector.keyify(couple[0]), couple[1]);
            }
        }
    }
}
