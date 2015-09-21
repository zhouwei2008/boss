package dsf

import java.text.DecimalFormat
import java.text.SimpleDateFormat
import org.apache.poi.hssf.usermodel.HSSFWorkbook
import javax.servlet.http.HttpServletRequest
import org.apache.poi.poifs.filesystem.POIFSFileSystem
import org.apache.poi.hssf.usermodel.HSSFSheet
import org.apache.poi.hssf.usermodel.HSSFRow
import org.apache.poi.hssf.usermodel.HSSFCell
import org.apache.poi.hssf.usermodel.HSSFCellStyle
import ismp.CmCustomer
import org.apache.poi.hssf.usermodel.HSSFDataFormat

/**
 * Created by IntelliJ IDEA.
 * User: syw
 * Date: 12-5-8
 * Time: 下午4:07
 * To change this template use File | Settings | File Templates.
 */
class AgentDownloadForExcelService {
    static DecimalFormat nf = DecimalFormat.getNumberInstance();
    static {
        nf.setMinimumFractionDigits(2)
        nf.setMaximumFractionDigits(2)
    }
    static SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd")
    static SimpleDateFormat stf = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss")
    HSSFWorkbook exportTrades(HttpServletRequest request,List tbAgentPayInfoList,int totalCount,BigDecimal totalMoney,BigDecimal totalFee,String tradeType){
        POIFSFileSystem template
        String templatePath
        FileInputStream is
        //if(tradeType=='F'){
            templatePath = request.getRealPath("/") + File.separator +
                    "templates-excel" + File.separator+"tbAgentPayInfoTemplate.xls"
            is = new FileInputStream(templatePath)
        /*}else if (tradeType=='S'){
            templatePath = request.getRealPath("/") + File.separator +
                    "templates-excel" + File.separator+"tbAgentPayInfoTemplate.xls"
            is = new FileInputStream(templatePath)
        }*/
        template = new POIFSFileSystem(is)
        HSSFWorkbook wb = new HSSFWorkbook(template)
        HSSFSheet st = wb.getSheetAt(0)
        HSSFRow row
        HSSFCell cell
        /*//日期
        row = st.getRow(0)
        cell = row.getCell(3)
        cell.setCellType(HSSFCell.CELL_TYPE_STRING)
        cell.setCellValue(sdf.format(new Date()))*/
        HSSFCellStyle moneyStyle = wb.createCellStyle()
        //总金额
        row = st.getRow(0)
        cell = row.getCell(3)
        moneyStyle.setDataFormat(HSSFDataFormat.getBuiltinFormat("0.00")); //? 两位小数
        cell.setCellStyle(moneyStyle)
        cell.setCellType(HSSFCell.CELL_TYPE_STRING)
        cell.setCellValue(Double.parseDouble(nf.format(totalMoney==null?0:totalMoney).replaceAll(",","")))
        //总手续费
        row = st.getRow(0)
        cell = row.getCell(6)
        cell.setCellStyle(moneyStyle)  //设置金额 样式
        cell.setCellType(HSSFCell.CELL_TYPE_STRING)
        cell.setCellValue(Double.parseDouble(nf.format(totalFee==null?0:totalFee).replaceAll(",","")))
        //总数
        cell = row.getCell(9)
        cell.setCellType(HSSFCell.CELL_TYPE_STRING)
        cell.setCellValue("${totalCount==null?0:totalCount}")
        if(tbAgentPayInfoList){
            TbAgentpayDetailsInfo tbAgentpayDetailsInfo = null;
            HSSFCellStyle style = wb.createCellStyle()
            style.setBorderTop(HSSFCellStyle.BORDER_THIN)
            style.setBorderBottom(HSSFCellStyle.BORDER_THIN)
            style.setBorderLeft(HSSFCellStyle.BORDER_THIN)
            style.setBorderRight(HSSFCellStyle.BORDER_THIN)
            for(int i=0;i<tbAgentPayInfoList.size();i++){
                tbAgentpayDetailsInfo = (TbAgentpayDetailsInfo)tbAgentPayInfoList.get(i)
                //从第四行开始写数据
                row = st.createRow(i+3)
                createCell(row,0,HSSFCell.CELL_TYPE_STRING,style,tbAgentpayDetailsInfo.batchBizid)//商户编号
                createCell(row,1,HSSFCell.CELL_TYPE_STRING,style,CmCustomer.findByCustomerNo(tbAgentpayDetailsInfo.batchBizid).name) //商户名称
                createCell(row,2,HSSFCell.CELL_TYPE_STRING,style,tbAgentpayDetailsInfo.tradeRemark)//用途
                createCell(row,3,HSSFCell.CELL_TYPE_STRING,style,tbAgentpayDetailsInfo.id)//交易号
                createCell(row,4,HSSFCell.CELL_TYPE_STRING,style,tbAgentpayDetailsInfo.batch.id)//批次号
                createCell(row,5,HSSFCell.CELL_TYPE_STRING,style,tbAgentpayDetailsInfo.tradeTypeMap[tbAgentpayDetailsInfo.tradeType])//交易类型
                createCell(row,6,HSSFCell.CELL_TYPE_STRING,style,tbAgentpayDetailsInfo.tradeCardname)//收款人
                createCell(row,7,HSSFCell.CELL_TYPE_STRING,style,tbAgentpayDetailsInfo.tradeCardnum)//收款账号
                createCell(row,8,HSSFCell.CELL_TYPE_STRING,style,tbAgentpayDetailsInfo.tradeAccountname)//收款银行
                createCell(row,9,HSSFCell.CELL_TYPE_STRING,style,tbAgentpayDetailsInfo.tradeBranchbank)//分行
                createCell(row,10,HSSFCell.CELL_TYPE_STRING,style,tbAgentpayDetailsInfo.tradeSubbranchbank)//支行
                createCell(row,11,HSSFCell.CELL_TYPE_STRING,style, tbAgentpayDetailsInfo.tradeSubdate?stf.format(tbAgentpayDetailsInfo.tradeSubdate):null)//商户申请日期
                createCell(row,12,HSSFCell.CELL_TYPE_STRING,style, tbAgentpayDetailsInfo.tradeCommdate?stf.format(tbAgentpayDetailsInfo.tradeCommdate):null)//商户审核日期
                createCell(row,13,HSSFCell.CELL_TYPE_STRING,style, tbAgentpayDetailsInfo.tradeSyschkdate?stf.format(tbAgentpayDetailsInfo.tradeSyschkdate):null)//审核日期
                createCell(row,14,HSSFCell.CELL_TYPE_STRING,style, tbAgentpayDetailsInfo.tradeDonedate?stf.format(tbAgentpayDetailsInfo.tradeDonedate):null)//对账日期
                createCell(row,15,HSSFCell.CELL_TYPE_STRING,style,tbAgentpayDetailsInfo.accountTypeMap[tbAgentpayDetailsInfo.tradeAccounttype])//账号类型
                if (tbAgentpayDetailsInfo.batchBizid == "100000000001524") {
                    createCell(row,16,HSSFCell.CELL_TYPE_STRING,style,"***")
                } else {
                    createCellForMoney(row,16,HSSFCell.CELL_TYPE_NUMERIC,style,Double.parseDouble(nf.format(tbAgentpayDetailsInfo.tradeAmount==null?0:tbAgentpayDetailsInfo.tradeAmount).replaceAll(",","")))//金额
                }
                createCellForMoney(row,17,HSSFCell.CELL_TYPE_NUMERIC,style,Double.parseDouble(nf.format(tbAgentpayDetailsInfo.tradeFee==null?0:tbAgentpayDetailsInfo.tradeFee).replaceAll(",","")))//手续费
                createCell(row,18,HSSFCell.CELL_TYPE_STRING,style,tbAgentpayDetailsInfo.tradeStatusMap[tbAgentpayDetailsInfo.tradeStatus])//状态
                createCell(row,19,HSSFCell.CELL_TYPE_STRING,style,tbAgentpayDetailsInfo.channelName)//渠道名称
                createCell(row,20,HSSFCell.CELL_TYPE_STRING,style,tbAgentpayDetailsInfo.tradeFeedbackcodeMap[tbAgentpayDetailsInfo.tradeFeedbackcode]) //反馈码
                createCell(row,21,HSSFCell.CELL_TYPE_STRING,style,tbAgentpayDetailsInfo.tradeReason)  //原因

            }
        }
        is.close()
        return wb
    }
    /**
     * 导出代收授权列表
     * @param request
     * @param tbEntrustPermList
     * @param totalCount
     * @return
     */
   HSSFWorkbook exportTbEntrustPerm(HttpServletRequest request,List tbEntrustPermList,int totalCount){
        POIFSFileSystem template
        String templatePath
        FileInputStream is
            templatePath = request.getRealPath("/") + File.separator +
                    "templates-excel" + File.separator+"tbEntrustPermTemplate.xls"
            is = new FileInputStream(templatePath)

        template = new POIFSFileSystem(is)
        HSSFWorkbook wb = new HSSFWorkbook(template)
        HSSFSheet st = wb.getSheetAt(0)
        HSSFRow row
        HSSFCell cell
        //第一行
        row = st.getRow(0)
        //总数
        cell = row.getCell(3)
        cell.setCellType(HSSFCell.CELL_TYPE_STRING)
        cell.setCellValue("${totalCount==null?0:totalCount}")
        if(tbEntrustPermList){
            TbEntrustPerm tbEntrustPerm = null;
            HSSFCellStyle style = wb.createCellStyle()
            style.setBorderTop(HSSFCellStyle.BORDER_THIN)
            style.setBorderBottom(HSSFCellStyle.BORDER_THIN)
            style.setBorderLeft(HSSFCellStyle.BORDER_THIN)
            style.setBorderRight(HSSFCellStyle.BORDER_THIN)
            for(int i=0;i<tbEntrustPermList.size();i++){
                tbEntrustPerm = (TbEntrustPerm)tbEntrustPermList.get(i)
                //从第四行开始写数据
                row = st.createRow(i+3)
                createCell(row,0,HSSFCell.CELL_TYPE_STRING,style,i+1)//开户名
                createCell(row,1,HSSFCell.CELL_TYPE_STRING,style,tbEntrustPerm.cardname)//开户名
                createCell(row,2,HSSFCell.CELL_TYPE_STRING,style,tbEntrustPerm.accountname) //开户银行
                createCell(row,3,HSSFCell.CELL_TYPE_STRING,style,tbEntrustPerm.cardnum.length()>8?(tbEntrustPerm.cardnum.substring(0,8)+"****"+(tbEntrustPerm.cardnum.length()>12?tbEntrustPerm.cardnum.substring(12,tbEntrustPerm.cardnum.length()):"")):tbEntrustPerm.cardnum)//开户账户
                createCell(row,4,HSSFCell.CELL_TYPE_STRING,style,tbEntrustPerm.accounttypeMap[tbEntrustPerm.accounttype])//账户类型
                createCell(row,5,HSSFCell.CELL_TYPE_STRING,style,tbEntrustPerm.entrustStarttime?sdf.format(tbEntrustPerm.entrustStarttime):null)//授权日期
                createCell(row,6,HSSFCell.CELL_TYPE_STRING,style,tbEntrustPerm.entrustEndtime?sdf.format(tbEntrustPerm.entrustEndtime):null)//截止日期
                createCell(row,7,HSSFCell.CELL_TYPE_STRING,style,tbEntrustPerm.entrustUsercode)//代扣协议号
                createCell(row,8,HSSFCell.CELL_TYPE_STRING,style,tbEntrustPerm.certificateTypeMap[tbEntrustPerm.certificateType])//证件类型
                createCell(row,9,HSSFCell.CELL_TYPE_STRING,style,tbEntrustPerm.certificateNum.length()>6?(tbEntrustPerm.certificateNum.substring(0,6)+"****"+(tbEntrustPerm.certificateNum.length()>10?tbEntrustPerm.certificateNum.substring(10,tbEntrustPerm.certificateNum.length()):"")):tbEntrustPerm.certificateNum)//证件号
                createCell(row,10,HSSFCell.CELL_TYPE_STRING,style,tbEntrustPerm.customerNo)//所属商户
                createCell(row,11,HSSFCell.CELL_TYPE_STRING,style,tbEntrustPerm.customerNo?(CmCustomer.findByCustomerNo(tbEntrustPerm.customerNo)?CmCustomer.findByCustomerNo(tbEntrustPerm.customerNo).name:null):null)//客户名称
                createCell(row,12,HSSFCell.CELL_TYPE_STRING,style, tbEntrustPerm.entrustStatusMap[tbEntrustPerm.entrustStatus])//账户状态
                createCell(row,13,HSSFCell.CELL_TYPE_STRING,style, tbEntrustPerm.entrustIsEffectMap[tbEntrustPerm.entrustIsEffect])//是否生效
            }
        }
        is.close()
        return wb
    }
     /**
     * 导出异常订单列表
     * @param request
     * @param tbErrorLogList
     * @param totalCount
     * @return
     */
   HSSFWorkbook exportTbErrorLog(HttpServletRequest request,List tbErrorLogList,int totalCount){
        POIFSFileSystem template
        String templatePath
        FileInputStream is
            templatePath = request.getRealPath("/") + File.separator +
                    "templates-excel" + File.separator+"tbErrorLogTemplate.xls"
            is = new FileInputStream(templatePath)

        template = new POIFSFileSystem(is)
        HSSFWorkbook wb = new HSSFWorkbook(template)
        HSSFSheet st = wb.getSheetAt(0)
        HSSFRow row
        HSSFCell cell
        //第一行
        row = st.getRow(0)
        //总数
        cell = row.getCell(3)
        cell.setCellType(HSSFCell.CELL_TYPE_STRING)
        cell.setCellValue("${totalCount==null?0:totalCount}")
        if(tbErrorLogList){
            def tbErrorLog = null;
            HSSFCellStyle style = wb.createCellStyle()
            style.setBorderTop(HSSFCellStyle.BORDER_THIN)
            style.setBorderBottom(HSSFCellStyle.BORDER_THIN)
            style.setBorderLeft(HSSFCellStyle.BORDER_THIN)
            style.setBorderRight(HSSFCellStyle.BORDER_THIN)
            for(int i=0;i<tbErrorLogList.size();i++){
                tbErrorLog = tbErrorLogList.get(i)
                //从第四行开始写数据
                row = st.createRow(i+3)
                createCell(row,0,HSSFCell.CELL_TYPE_STRING,style,tbErrorLog.BATCH_BIZID)//商户号
                createCell(row,1,HSSFCell.CELL_TYPE_STRING,style,tbErrorLog.DETAIL_ID) //交易号
                createCell(row,2,HSSFCell.CELL_TYPE_STRING,style,tbErrorLog.BATCH_ID)//批次号
                createCell(row,3,HSSFCell.CELL_TYPE_STRING,style,tbErrorLog.customerName)//商户名称
                createCell(row,4,HSSFCell.CELL_TYPE_STRING,style,TbAgentpayDetailsInfo.tradeTypeMap[tbErrorLog.TRADE_TYPE])//交易类型
                createCell(row,5,HSSFCell.CELL_TYPE_STRING,style,tbErrorLog.TRADE_CARDNAME)//收/付款人
                createCell(row,6,HSSFCell.CELL_TYPE_STRING,style,tbErrorLog.TRADE_CARDNUM)//客户账户
                createCell(row,7,HSSFCell.CELL_TYPE_STRING,style,tbErrorLog.TRADE_SUBDATE?sdf.format(tbErrorLog.TRADE_SUBDATE):null)//商户申请日期
                createCell(row,8,HSSFCell.CELL_TYPE_STRING,style,TbAgentpayDetailsInfo.certificateTypeMap[tbErrorLog.CERTIFICATE_TYPE])//证件类型
                createCell(row,9,HSSFCell.CELL_TYPE_STRING,style,tbErrorLog.CERTIFICATE_NUM)//证件号码
                createCell(row,10,HSSFCell.CELL_TYPE_STRING,style,TbAgentpayDetailsInfo.accountTypeMap[tbErrorLog.TRADE_ACCOUNTTYPE])//账号类型
                createCellForMoney(row,11,HSSFCell.CELL_TYPE_NUMERIC,style,Double.parseDouble(nf.format(tbErrorLog.TRADE_AMOUNT==null?0:tbErrorLog.TRADE_AMOUNT).replaceAll(",","")))//金额
            }
        }
        is.close()
        return wb
    }


    private void createCell(HSSFRow row,int columnIndex,int cellType,HSSFCellStyle style,def value){
        HSSFCell cell = row.createCell(columnIndex)
        cell.setCellStyle(style)
        cell.setCellType(cellType)
        cell.setCellValue(value)
    }

     private void createCellForMoney(HSSFRow row,int columnIndex,int cellType,HSSFCellStyle style,def value){
        HSSFCell cell = row.createCell(columnIndex)
        style.setDataFormat(HSSFDataFormat.getBuiltinFormat("0.00")); //? 两位小数
        cell.setCellStyle(style)
        cell.setCellType(cellType)
        cell.setCellValue(value)
    }

    static void main (String [] ars){
        println   new Date()

    }
}
