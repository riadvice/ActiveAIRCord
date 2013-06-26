/*
   Copyright (C) 2011-2013 Ghazi Triki <ghazi.nocturne@gmail.com>

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
package
{
    import com.lionart.activeaircord.ActiveAIRCordTest;
    import com.lionart.activeaircord.ColumnTest;
    import com.lionart.activeaircord.ExpressionsTest;
    import com.lionart.activeaircord.InflectorTest;
    import com.lionart.activeaircord.SQLBuilderTest;
    import com.lionart.activeaircord.SQLTypesTest;

    import flash.display.Sprite;

    import Array;

    import flexunit.flexui.FlexUnitTestRunnerUIAS;

    public class FlexUnitApplication extends Sprite
    {
        public function FlexUnitApplication()
        {
            onCreationComplete();
        }

        private function onCreationComplete() : void
        {
            var testRunner : FlexUnitTestRunnerUIAS = new FlexUnitTestRunnerUIAS();
            testRunner.portNumber = 8765;
            this.addChild(testRunner);
            testRunner.runWithFlexUnit4Runner(currentRunTestSuite(), "qurani-unit-test");
        }

        public function currentRunTestSuite() : Array
        {
            var testsToRun : Array = new Array();
            testsToRun.push(com.lionart.activeaircord.ActiveAIRCordTest);
            testsToRun.push(com.lionart.activeaircord.ColumnTest);
            testsToRun.push(com.lionart.activeaircord.ExpressionsTest);
            testsToRun.push(com.lionart.activeaircord.InflectorTest);
            testsToRun.push(com.lionart.activeaircord.SQLBuilderTest);
            testsToRun.push(com.lionart.activeaircord.SQLTypesTest);
            return testsToRun;
        }
    }
}
