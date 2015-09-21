package dsf

import ismp.CmCustomer
import org.springframework.orm.hibernate3.HibernateTemplate
import org.hibernate.Session
import org.hibernate.transform.AliasToEntityMapResultTransformer
import com.burtbeckwith.grails.plugin.datasources.DatasourcesUtils
import org.springframework.orm.hibernate3.HibernateCallback
import groovy.sql.Sql

/**
 * Created by IntelliJ IDEA.
 * User: syw
 * Date: 12-7-9
 * Time: 上午10:56
 * To change this template use File | Settings | File Templates.
 */
class TbErrorLogController {
    def agentDownloadForExcelService
    def  dataSource_dsf
    def agentService
    def index = { }
    def showList = {
        params.max = Math.min(params.max ? params.int('max') : 10, 100)
        params.offset = params.offset ? params.int('offset') : 0
        params.sort = params.sort ? params.sort : "DETAIL_ID"
        params.order = params.order ? params.order : "desc"
         def sql = new Sql(dataSource_dsf)
        def queryParam = []

        validDated(params)

        def res = agentService.queryTbErrorLog(params);

        return [tbErrorLogList: res.resList, tbErrorLogTotal: res.totalCount]
    }
    /**
     * 下载异常数据
      */
    def downloadTbErrorLog = {
       try{
            params.max = 50000 //最多5万条
            params.offset = 0
            params.sort = params.sort ? params.sort : "DETAIL_ID"
            params.order = params.order ? params.order : "desc"
           def res = agentService.queryTbErrorLog(params);

           def filename = 'Excel-' + new java.text.SimpleDateFormat("yyyyMMddHHmmss").format(new Date()) + '.xls'
            response.setHeader("Content-disposition", "attachment; filename=" + filename)
            response.contentType = "application/vnd.ms-excel"
            response.setCharacterEncoding("UTF-8")
            def wb = agentDownloadForExcelService.exportTbErrorLog(request,res.resList as List,res.totalCount as Integer)
            wb.write(response.outputStream)
            response.outputStream.close()
        }catch (Throwable e){
            log.error("异常订单信息下载异常",e)
        }
    }

   /**
     * 异常订单下载 CSV
     */
    def downTbErrorLogCSV = {
        try{
            params.max = 50000 //最多5万条
            params.offset = 0
            params.sort = params.sort ? params.sort : "DETAIL_ID"
            params.order = params.order ? params.order : "desc"
            def res = agentService.queryTbErrorLog(params);
            def filename = 'csv-' + new java.text.SimpleDateFormat("yyyyMMddHHmmss").format(new Date()) + '.csv'
            response.contentType = "text/csv"
            response.setCharacterEncoding("GBK")
            response.setHeader("Content-disposition", "attachment; filename=" + filename)
            String tlpt="showList_csv"
            render(template: tlpt, model: [tbErrorLogList:res.resList,totalCount:res.totalCount,totalMoney:res.totalMoney])
        }catch (Throwable e){
            log.error("异常订单下载异常",e)
        }
    }

    def checkErrorLog = {
        String message = "";
        String tbErrorLogId = params.delID;
        params.offset = params.delOffset ? params.int('delOffset') : 0
        try {

            int resCount = TbErrorLog.executeUpdate("update  TbErrorLog set isCheck = '1' where id =" + tbErrorLogId);
            if(resCount>0){
             message = "异常订单处理成功！";
            }else{
                message = "异常订单处理成功失败！";
            }
        } catch (Exception e) {
            log.error(e.message, e);
            message = "异常订单处理成功失败！";
        }
        flash.message = message
        log.info message
        redirect(action: "showList",params:params)
    }


    /**
     * 查看明细
     */
    def showDetail={
       def tbErrorLog = TbErrorLog.findById(params.errorLogId)
        render(contentType: "text/json") {
            errorMsg = tbErrorLog ? tbErrorLog.summary : ""
            errorMsgDetail = tbErrorLog ? tbErrorLog.errorMsgDetail : ""
        }
        }
    /**
 * 验证日期间隔有效性
 *
 * @param params 表单参数
 * @return
 * @author
 *
 */
    def validDated(params) {
        //如果起始日期和截止日期均为空 默认为查询当天到前一个月
        if (params.tradeSubdateS == null && params.tradeSubdateE == null) {
            def gCalendar = new GregorianCalendar()
            params.tradeSubdateE = gCalendar.time.format('yyyy-MM-dd')
            gCalendar.add(GregorianCalendar.MONTH, -1)
            params.tradeSubdateS = gCalendar.time.format('yyyy-MM-dd')
        }
        //如果截止日期为空，默认为查询起始日期当天
        if (params.tradeSubdateS && !params.tradeSubdateE) {
            params.tradeSubdateE = params.tradeSubdateS
        }
        //如果起始日期为空，默认为查询截止日期当天
        if (!params.tradeSubdateS && params.tradeSubdateE) {
            params.tradeSubdateS = params.tradeSubdateE
        }

    }

}
