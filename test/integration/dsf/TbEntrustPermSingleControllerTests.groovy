package dsf

import grails.test.ControllerUnitTestCase
import ismp.CmCustomer

/**
 * Created by IntelliJ IDEA.
 * User: syw
 * Date: 12-6-20
 * Time: 下午2:58
 * To change this template use File | Settings | File Templates.
 */
class TbEntrustPermSingleControllerTests extends ControllerUnitTestCase{
          def agentService

    void testCreate(){

    }
    void testSave(){
         mockDomain(TbEntrustPerm)
        controller.session.op = [name:"管理员"];
        controller.params.entrustStarttime = "2012-06-18"
        controller.params.entrustEndtime = "2012-06-25"
        controller.params.cardname =  "杜宏升22";
        controller.params.accountname =  "中国农业银行";
        controller.params.cardnum =  "22222222222-22222222";
        controller.params.customerNo =  "100000000000080";
        controller.params.customerName =  "代收服务";
        controller.params.entrustStatus =  "0";
        controller.params.entrustIsEffect =  "0";
        controller.params.accounttype =  "0";
        controller.params.certificateType =  "0";
        controller.params.certificateNum =  "0";
        //controller.params.operator="管理员"
        //controller.params.createtime = new Date();
        def returnMap = controller.save()
        assertTrue controller.flash.message.indexOf('代收授权账户保存成功')>-1;


    }

    /*void testUpdateItem(){
        mockDomain(TbEntrustPerm)

       // mockLogging(AgentService)
          controller.params.tbEntrustPermId = "105861";
        controller.agentService = new AgentService() ;
         mockDomain(TbAdjustBankCard)
        def returnMap = controller.updateItem();
        assertEquals "100000000000080", returnMap.tbEntrustPermInstance.customerNo
        assertEquals "杜宏升", returnMap.tbEntrustPermInstance.cardname

    }*/

     void testDeleteItem(){
         mockForConstraintsTests(TbEntrustPerm)

         mockDomain(TbEntrustPerm);
         controller.params.tbEntrustPermId = "105861";
        controller.params.customerNo = "100000000000080";
         mockDomain(TbEntrustPerm);
         //mockCommandObject(TbEntrustPerm);
        def result = controller.deleteItem();
        assertTrue controller.flash.message.indexOf('代收授权删除成功！')>-1;
     }

    void testEdit(){
           mockDomain(TbEntrustPerm)
        controller.session.op = [name:"管理员"];
        controller.params.entrustStarttime = "2012-06-18"
        controller.params.entrustEndtime = "2012-06-25"
        controller.params.cardname =  "杜宏升22";
        controller.params.accountname =  "中国农业银行";
        controller.params.cardnum =  "22222222222-22222222";
        controller.params.customerNo =  "100000000000080";
        controller.params.customerName =  "代收服务";
        controller.params.entrustStatus =  "0";
        controller.params.entrustIsEffect =  "0";
        controller.params.accounttype =  "0";
        controller.params.certificateType =  "0";
        controller.params.certificateNum =  "0";

        controller.agentService = new AgentService();
        def returnMap = controller.edit()
        assertTrue controller.flash.message.indexOf('代收授权账户保存成功')>-1;
    }

    void testDownloadTbEntrustPerm(){
          mockDomain(TbEntrustPerm)
         controller.params.customerNo =  "100000000000080";
        controller.agentService = agentService ;
        controller.downloadTbEntrustPerm();
    }
   /* void testGetCustomerInfo(){

        //mockDomain(TbEntrustPerm)
        CmCustomer cm = new CmCustomer( name :"代收服务",customerNo : "100000000000080",
   type:"P",
status : 'init',
   needInvoice: false);
        mockDomain(CmCustomer,[cm])
        controller.params.customerNo =  "100000000000080";
         controller.getCustomerInfo();
        def json = controller.response.contentAsString
        println     json
        assertEquals "代收服务"    ,controller.redirectArgs["customerName"]

    }*/
}
