package com.lionart.activeaircord
{
    import org.flexunit.asserts.assertEquals;
    import org.hamcrest.assertThat;
    import org.hamcrest.collection.array;

    public class ExpressionsTest
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
        public function testValues() : void
        {
            var e : Expressions = new Expressions(null, "a=? and b=?", 1, 2);
            assertThat(e.values, array(1, 2));
        }

        [Test]
        public function testOneVariable() : void
        {
            var e : Expressions = new Expressions(null, "name=?", "Tito");
            assertEquals("name=?", e.toString());
            assertEquals(e.values, array("Tito"));
        }


    }
}
