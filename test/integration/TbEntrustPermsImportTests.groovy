import org.springframework.web.multipart.MultipartHttpServletRequest
import org.springframework.mock.web.MockMultipartFile
import org.springframework.mock.web.MockMultipartHttpServletRequest
import org.springframework.web.multipart.MultipartFile
import dsf.TbEntrustPermEO
/**
 * Created by IntelliJ IDEA.
 * User: xypeng
 * Date: 12-6-8
 * Time: 上午10:39
 * To change this template use File | Settings | File Templates.
 */
class TbEntrustPermsImportTests extends GroovyTestCase{
    def tbEntrustPermsImportService

    void testCheckFile(){
        File f1 = null
        File f2 = new File("C:\\Users\\xypeng\\Desktop\\xxx\\大于10M.xls")
        File f3 = new File("C:\\Users\\xypeng\\Desktop\\xxx\\请确认文件是否为 xls.sql")
        File f4 = new File("C:\\Users\\xypeng\\Desktop\\xxx\\请确认文件格式是否为 xls.xls")
        //File f5 = new File("C:\\Users\\xypeng\\Desktop\\xxx\\请确认上传文件中格式跟模板一样，并且有相应数据.xls")
        File f6 = new File("C:\\Users\\xypeng\\Desktop\\xxx\\单个文件最多5000笔.xls")
        File f7 = new File("C:\\Users\\xypeng\\Desktop\\xxx\\空文件不能上传.xls")
        File f72 = new File("C:\\Users\\xypeng\\Desktop\\xxx\\空文件不能上传2.xls")
        File f7T = new File("C:\\Users\\xypeng\\Desktop\\xxx\\authorizesImport_T - 副本.xls")
        File f8 = new File("C:\\Users\\xypeng\\Desktop\\xxx\\列头应为.xls")
        File f9 = new File("C:\\Users\\xypeng\\Desktop\\xxx\\第5行序号列为空值.xls")
        File f10 = new File("C:\\Users\\xypeng\\Desktop\\xxx\\第5行序号列为非数值类型.xls")
        File f11 = new File("C:\\Users\\xypeng\\Desktop\\xxx\\序号5重复.xls")
        File f12 = new File("C:\\Users\\xypeng\\Desktop\\xxx\\keysMap&&lastRowNum&&xSheet.xls")

        def res1 = tbEntrustPermsImportService.checkFile(null)
        assertEquals "空路径或空文件不能上传!",res1.errMsg

        MultipartFile mfl2= new MockMultipartFile(f2.name,f2.name,"application/force-download",new FileInputStream(f2))
        def res2 = tbEntrustPermsImportService.checkFile(mfl2)
        assertEquals "上传文件不能大于10M!",res2.errMsg

        MultipartFile mfl3= new MockMultipartFile(f3.name,f3.name,"application/force-download",new FileInputStream(f3))
        def res3 = tbEntrustPermsImportService.checkFile(mfl3)
        assertEquals "请确认文件是否为 xls!",res3.errMsg

        MultipartFile mfl4= new MockMultipartFile(f4.name,f4.name,"application/force-download",new FileInputStream(f4))
        def res4 = tbEntrustPermsImportService.checkFile(mfl4)
        assertEquals "请确认文件格式是否为 xls!",res4.errMsg

//        MultipartFile mfl5= new MockMultipartFile(f5.name,f5.name,"application/force-download",new FileInputStream(f5))
//        def res5 = tbEntrustPermsImportService.checkFile(mfl5)
//        assertEquals "请确认上传文件中格式跟模板一样，并且有相应数据！",res5.errMsg

        MultipartFile mfl6= new MockMultipartFile(f6.name,f6.name,"application/force-download",new FileInputStream(f6))
        def res6 = tbEntrustPermsImportService.checkFile(mfl6)
        assertEquals "单个文件最多5000笔!",res6.errMsg

        MultipartFile mfl7= new MockMultipartFile(f7.name,f7.name,"application/force-download",new FileInputStream(f7))
        def res7 = tbEntrustPermsImportService.checkFile(mfl7)
        assertEquals "空文件不能上传!",res7.errMsg

        MultipartFile mfl72= new MockMultipartFile(f72.name,f72.name,"application/force-download",new FileInputStream(f72))
        def res72 = tbEntrustPermsImportService.checkFile(mfl72)
        assertEquals "空文件不能上传!",res72.errMsg

        MultipartFile mfl7T= new MockMultipartFile(f7T.name,f7T.name,"application/force-download",new FileInputStream(f7T))
        def res7T = tbEntrustPermsImportService.checkFile(mfl7T)
        assertEquals "空文件不能上传!",res7T.errMsg

        MultipartFile mfl8= new MockMultipartFile(f8.name,f8.name,"application/force-download",new FileInputStream(f8))
        def res8 = tbEntrustPermsImportService.checkFile(mfl8)
        assertEquals "模板有误，第3列列头应为“开户银行”!",res8.errMsg

        MultipartFile mfl9= new MockMultipartFile(f9.name,f9.name,"application/force-download",new FileInputStream(f9))
        def res9 = tbEntrustPermsImportService.checkFile(mfl9)
        assertEquals "文件中第5行，序号列为空值!请更正!",res9.errMsg

        MultipartFile mfl10= new MockMultipartFile(f10.name,f10.name,"application/force-download",new FileInputStream(f10))
        def res10 = tbEntrustPermsImportService.checkFile(mfl10)
        assertEquals "文件中第5行，序号列为非数值类型!请更正!",res10.errMsg

        MultipartFile mfl11= new MockMultipartFile(f11.name,f11.name,"application/force-download",new FileInputStream(f11))
        def res11 = tbEntrustPermsImportService.checkFile(mfl11)
        assertEquals "序号5重复!",res11.errMsg

        MultipartFile mfl12= new MockMultipartFile(f12.name,f12.name,"application/force-download",new FileInputStream(f12))
        def res12 = tbEntrustPermsImportService.checkFile(mfl12)
        assertEquals 6,res12.lastRowNum
        assertEquals "3,5,",res12.keysMap.get("开户名19|中国农业银行|1111111-111111129|100000000000595").toString()


    }
    void testCheck(){
        File f = new File("C:\\Users\\xypeng\\Desktop\\xxx\\check单元测试.xls")
        MultipartHttpServletRequest request = new MockMultipartHttpServletRequest()
        MultipartFile mfl= new MockMultipartFile(f.name,f.name,"application/force-download",new FileInputStream(f))
        request.multipartFiles.add("upload",mfl)
        def res = tbEntrustPermsImportService.check(request)
        List<TbEntrustPermEO> tbEntrustPermErrList = res.tbEntrustPermErrList
        assertEquals 39,tbEntrustPermErrList.size()
        assertEquals tbEntrustPermErrList[0].checkMsg,"开户名为必填项!|<br/>"
        assertEquals tbEntrustPermErrList[1].checkMsg,"开户名最长为25个字符!|<br/>"
        assertEquals tbEntrustPermErrList[2].checkMsg,"开户名单元格格式错误，请改为文本格式!|<br/>"
        assertEquals tbEntrustPermErrList[3].checkMsg,"开户银行为必填项!|<br/>"
        assertEquals tbEntrustPermErrList[4].checkMsg,"开户银行最长为25个字符!|<br/>"
        assertEquals tbEntrustPermErrList[5].checkMsg,"开户银行单元格格式错误，请改为文本格式!|<br/>"
        assertEquals tbEntrustPermErrList[6].checkMsg,"请确认开户银行是否为标准银行!|<br/>"
        assertEquals tbEntrustPermErrList[7].checkMsg,"开户账户为必填项!|<br/>"
        assertEquals tbEntrustPermErrList[8].checkMsg,"开户账户长度为9-33个字符!|<br/>"
        assertEquals tbEntrustPermErrList[9].checkMsg,"开户账户应以数字“0-9”以及符号“-”组成!|<br/>"
        assertEquals tbEntrustPermErrList[10].checkMsg,"开户账户单元格格式错误，请改为文本格式!|<br/>"
        assertEquals tbEntrustPermErrList[11].checkMsg,"代扣协议号有全角字符或汉字!|<br/>"
        assertEquals tbEntrustPermErrList[12].checkMsg,"代扣协议号最长为15个字符!|<br/>"
        assertEquals tbEntrustPermErrList[13].checkMsg,"代扣协议号单元格格式错误，请改为文本格式!|<br/>"
        assertEquals tbEntrustPermErrList[14].checkMsg,"授权日期为必填项!|<br/>"
        assertEquals tbEntrustPermErrList[15].checkMsg,"授权日期无效,请修改(格式:yyyy-MM-dd)!|<br/>"
        assertEquals tbEntrustPermErrList[16].checkMsg,"授权日期无效,请修改(格式:yyyy-MM-dd)!|<br/>"
        assertEquals tbEntrustPermErrList[17].checkMsg,"授权日期格式错误，请改为日期(yyyy-MM-dd)格式!|<br/>"
        assertEquals tbEntrustPermErrList[18].checkMsg,"截止日期为必填项!|<br/>"
        assertEquals tbEntrustPermErrList[19].checkMsg,"截止日期无效,请修改(格式:yyyy-MM-dd)!|<br/>"
        assertEquals tbEntrustPermErrList[20].checkMsg,"截止日期无效,请修改(格式:yyyy-MM-dd)!|<br/>"
        assertEquals tbEntrustPermErrList[21].checkMsg,"截止日期格式错误，请改为日期(yyyy-MM-dd)格式!|<br/>"
        assertEquals tbEntrustPermErrList[22].checkMsg,"授权日期必须小于截止日期!|<br/>"
        assertEquals tbEntrustPermErrList[23].checkMsg,"截止日期必须大于等于今天!|<br/>"
        assertEquals tbEntrustPermErrList[24].checkMsg,"账户类型为必填项!|<br/>"
        assertEquals tbEntrustPermErrList[25].checkMsg,"账户类型无效!|<br/>"
        assertEquals tbEntrustPermErrList[26].checkMsg,"账户类型单元格格式错误，请改为文本格式!|<br/>"
        assertEquals tbEntrustPermErrList[27].checkMsg,"证件类型为必填项!|<br/>"
        assertEquals tbEntrustPermErrList[28].checkMsg,"证件类型无效!|<br/>"
        assertEquals tbEntrustPermErrList[29].checkMsg,"证件类型单元格格式错误，请改为文本格式!|<br/>"
        assertEquals tbEntrustPermErrList[30].checkMsg,"证件号为必填项!|<br/>"
        assertEquals tbEntrustPermErrList[31].checkMsg,"证件号有全角字符或汉字!|<br/>"
        assertEquals tbEntrustPermErrList[32].checkMsg,"证件号最长30个字符!|<br/>"
        assertEquals tbEntrustPermErrList[33].checkMsg,"证件号单元格格式错误，请改为文本格式!|<br/>"
        assertEquals tbEntrustPermErrList[34].checkMsg,"所属商户为必填项!|<br/>"
        assertEquals tbEntrustPermErrList[35].checkMsg,"所属商户单元格格式错误，请改为文本格式!|<br/>"
        assertEquals tbEntrustPermErrList[36].checkMsg,"与第38,39笔互为重复数据!|<br/>"
        assertEquals tbEntrustPermErrList[37].checkMsg,"与第37,39笔互为重复数据!|<br/>"
        assertEquals tbEntrustPermErrList[38].checkMsg,"与第37,38笔互为重复数据!|<br/>"
    }

    void testSavePerms(){
        File f = new File("C:\\Users\\xypeng\\Desktop\\xxx\\导入测试数据\\测试数据-正确.xls")
        MultipartHttpServletRequest request = new MockMultipartHttpServletRequest()
        MultipartFile mfl= new MockMultipartFile(f.name,f.name,"application/force-download",new FileInputStream(f))
        request.multipartFiles.add("upload",mfl)
        request.session.op=[name:'test']
        long begin = System.currentTimeMillis()
        def res = tbEntrustPermsImportService.check(request)
        assertTrue tbEntrustPermsImportService.savePerms(res.tbEntrustPermListAdd,res.tbEntrustPermListUpdate)
        System.out.println("========="+ (System.currentTimeMillis()-begin))
    }

    void testUpdateEntrustIsEffect (){
        tbEntrustPermsImportService.updateEntrustIsEffect()
    }

}
