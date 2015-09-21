package ismp

import grails.test.*

class AcquireAccountTradeTests extends GrailsUnitTestCase {
    protected void setUp() {
        super.setUp()
    }

    protected void tearDown() {
        super.tearDown()
    }

    void testSomething() {
        def allBanks = boss.BoBankDic.list()
        println("00000008-----"+allBanks.size())
        def xkl
        allBanks.each{
           xkl = new String((it.name).getBytes("utf-8"),"gbk")
        }

    }
}
