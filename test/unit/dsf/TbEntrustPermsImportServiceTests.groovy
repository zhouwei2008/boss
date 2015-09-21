package dsf

import grails.test.*
import java.text.SimpleDateFormat
import java.util.regex.Pattern
import java.util.regex.Matcher

class TbEntrustPermsImportServiceTests extends GrailsUnitTestCase {
    protected void setUp() {
        super.setUp()
    }

    protected void tearDown() {
        super.tearDown()
    }

//    void testSomething() {
//        SimpleDateFormat sf = new SimpleDateFormat("yyyy-MM-dd");
//        String s = "2012-06-11"
//        println TbEntrustPermsImportService.validDate2(s)
//        String e = "2012-06-11"
//        Date sd = sf.parse(s)
//        Date ed = sf.parse(e)
//        Date td = sf.parse(sf.format(new Date()))
//        boolean res = (td>=sd && td<=ed)
//        assertTrue("11",res)
//    }

    void testDoubleByte(){
        String input = "中国"
        println input
        println input.toString().bytes.length
        println input.toString().length()

        String datePattern = "[\u4E00-\u9FA5]";
        Pattern pattern = Pattern.compile(datePattern);
        Matcher match = pattern.matcher(input);
        println match.matches()

        String aa = "中国China人";
        for (int i = 0; i < aa.length(); i++) {
            String bb = aa.substring(i, i+1);
            //生成一个Pattern,同时编译一个正则表达式.
        boolean cc = java.util.regex.Pattern.matches("[\u4E00-\u9FA5]", bb);
            System.out.println(bb+" is chinese?-> "+cc);
        }
    }

    void testZHZ(){
        def p =/^[a-zA-Z0-9_\u4e00-\u9fa5]+$/
        println "中硫酸铝困工椅_苯縯ssssss"==~p
        println p


    }

}
