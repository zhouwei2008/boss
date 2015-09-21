package dsf

import org.apache.poi.hssf.usermodel.HSSFWorkbook
import org.apache.poi.poifs.filesystem.POIFSFileSystem

class TbEntrustPermsImportController {
    def tbEntrustPermsImportService
    /**
     * 代收授权账户批量导入模板下载
     */
    def downloadTemplate = {
        def filename = 'authorizesImport_T.xls'
        response.setHeader("Content-disposition", "attachment; filename=" + filename)
        response.contentType = "application/vnd.ms-excel"
        response.setCharacterEncoding("UTF-8")
        FileInputStream is
        String templatePath = request.getRealPath("/") + File.separator +
                    "templates-excel" + File.separator+"authorizesImport_T.xls"
        is = new FileInputStream(templatePath)
        POIFSFileSystem template
        template = new POIFSFileSystem(is)
        HSSFWorkbook wb = new HSSFWorkbook(template)
        wb.write(response.outputStream)
        response.outputStream.close()
    }

    def tbEntrustPermsImport = {

    }
    /**
     * 导入
     */
    def permsImport = {
        def res
        String result = "导入成功"
        String errMsg
        String filename
        int totalNum
        int addNum
        int updateNum
        int errNum
        def tbEntrustPermErrList
        try {
            //long begin = System.currentTimeMillis()
            res = tbEntrustPermsImportService.check(request)
            //System.out.println("========="+ (System.currentTimeMillis()-begin))
            if(res.tbEntrustPermErrList){
                result = "导入失败"
            }else if(!res.tbEntrustPermListAdd&&!res.tbEntrustPermListUpdate){
                result = "导入失败"
            }else{
                //long begin2 = System.currentTimeMillis()
                tbEntrustPermsImportService.savePerms(res.tbEntrustPermListAdd,res.tbEntrustPermListUpdate)
                //System.out.println("========="+ (System.currentTimeMillis()-begin2))
            }
            errMsg = res.errMsg
            filename = request.getFile("upload").getOriginalFilename()
            totalNum = res.totalNum
            errNum = res.tbEntrustPermErrList?.size()
            tbEntrustPermErrList = res.tbEntrustPermErrList
            if(errNum==null||errNum==0){
                addNum = res.tbEntrustPermListAdd?.size()
                updateNum = res.tbEntrustPermListUpdate?.size()
            }
        }catch (Throwable e){
            log.error("代收授权账户批量导入异常",e)
            errMsg = "未知原因，请重试"
            result = "导入失败"
        }
        [result:result,errMsg:errMsg,filename:filename,
                totalNum:totalNum,errNum:errNum,addNum:addNum,updateNum:updateNum,
                tbEntrustPermErrList:tbEntrustPermErrList]
    }
}
