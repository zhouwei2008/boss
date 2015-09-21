package boss

import grails.test.*

class BoOpRelationTests extends GrailsUnitTestCase {
    protected void setUp() {
        super.setUp()
    }

    protected void tearDown() {
        super.tearDown()
    }

    void testSomething() {
         def gCalendar= new GregorianCalendar()
            gCalendar.add(GregorianCalendar.MONTH,-1)
          println gCalendar.time
    }
}
