package dsf

import java.text.SimpleDateFormat
import dsf.TbEntrustPerm
import dsf.TbEntrustPermSingleController
import org.springframework.mock.web.MockHttpSession
import grails.test.GrailsUnitTestCase
import grails.test.ControllerUnitTestCase
/**
 * Created by IntelliJ IDEA.
 * User: syw
 * Date: 12-6-19
 * Time: 下午2:27
 * To change this template use File | Settings | File Templates.
 */
class AgentServiceTests extends GroovyTestCase   {
         def    agentService

      void testBankListNew(){
        def bankList =    agentService.bankListNew();
          assertEquals 10,   bankList.size()
      }


}
