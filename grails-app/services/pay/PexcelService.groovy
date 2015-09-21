package pay

import org.apache.poi.poifs.filesystem.POIFSFileSystem
import javax.servlet.http.HttpServletRequest
import org.apache.poi.hssf.usermodel.HSSFWorkbook
import org.apache.poi.hssf.usermodel.HSSFSheet
import org.apache.poi.hssf.usermodel.HSSFRow
import org.apache.poi.hssf.usermodel.HSSFCell
import java.text.DecimalFormat
import org.apache.poi.hssf.usermodel.HSSFCellStyle
import java.text.SimpleDateFormat
import org.apache.poi.hssf.usermodel.HSSFDataFormat

class PexcelService {
    static DecimalFormat nf = DecimalFormat.getNumberInstance();
    static {
        nf.setMinimumFractionDigits(2)
        nf.setMaximumFractionDigits(2)
    }
    static SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd")
    static SimpleDateFormat stf = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss")
    HSSFWorkbook exportTrades(HttpServletRequest request,List ptbPayTradeList,int totalCount,BigDecimal totalMoney,String tradeType){
        POIFSFileSystem template
        String templatePath
        FileInputStream is
        if(tradeType=='F'){
            templatePath = request.getRealPath("/") + File.separator +
                    "templates-excel" + File.separator+"tradesTemplateF.xls"
            is = new FileInputStream(templatePath)
        }else if (tradeType=='S'){
            templatePath = request.getRealPath("/") + File.separator +
                    "templates-excel" + File.separator+"tradesTemplateS.xls"
            is = new FileInputStream(templatePath)
        }
        template = new POIFSFileSystem(is)
        HSSFWorkbook wb = new HSSFWorkbook(template)
        HSSFSheet st = wb.getSheetAt(0)
        HSSFRow row
        HSSFCell cell
        //日期
        row = st.getRow(0)
        cell = row.getCell(3)
        cell.setCellType(HSSFCell.CELL_TYPE_STRING)
        cell.setCellValue(sdf.format(new Date()))
        //总金额
        row = st.getRow(2)
        cell = row.getCell(3)
        cell.cellStyle.setDataFormat(HSSFDataFormat.getBuiltinFormat("0.00")); //? 两位小数
        cell.setCellType(HSSFCell.CELL_TYPE_NUMERIC)
        cell.setCellValue(Double.parseDouble(nf.format(totalMoney==null?0:totalMoney).replaceAll(",","")))
        //总数
        cell = row.getCell(6)
        cell.setCellType(HSSFCell.CELL_TYPE_STRING)
        cell.setCellValue("${totalCount==null?0:totalCount}")
        if(ptbPayTradeList){
            def ptbPayTrade
            HSSFCellStyle style = wb.createCellStyle()
            style.setBorderTop(HSSFCellStyle.BORDER_THIN)
            style.setBorderBottom(HSSFCellStyle.BORDER_THIN)
            style.setBorderLeft(HSSFCellStyle.BORDER_THIN)
            style.setBorderRight(HSSFCellStyle.BORDER_THIN)
            for(int i=0;i<ptbPayTradeList.size();i++){
                ptbPayTrade = ptbPayTradeList.get(i)
                row = st.createRow(i+5)
                createCell(row,0,HSSFCell.CELL_TYPE_STRING,style,ptbPayTrade.TRADE_ID)
                createCell(row,1,HSSFCell.CELL_TYPE_STRING,style,ptbPayTrade.OUT_TRADEORDER)
                createCell(row,2,HSSFCell.CELL_TYPE_STRING,style,ptbPayTrade.BATCH_ID)
//                createCell(row,3,HSSFCell.CELL_TYPE_STRING,style,ptbPayTrade.TRADE_BATCHSEQNO)
                createCell(row,3,HSSFCell.CELL_TYPE_STRING,style,PtbPayTrade.TradeTypeMap[ptbPayTrade.TRADE_TYPE])
                createCell(row,4,HSSFCell.CELL_TYPE_STRING,style,ptbPayTrade.TRADE_NAME)
                createCell(row,5,HSSFCell.CELL_TYPE_STRING,style,ptbPayTrade.TRADE_CARDNAME)
                createCell(row,6,HSSFCell.CELL_TYPE_STRING,style,ptbPayTrade.TRADE_CARDNUM)
                createCell(row,7,HSSFCell.CELL_TYPE_STRING,style,ptbPayTrade.TRADE_BANK)
                createCell(row,8,HSSFCell.CELL_TYPE_STRING,style,
                        ptbPayTrade.TRADE_SUBDATE?stf.format(ptbPayTrade.TRADE_SUBDATE):null)
                createCell(row,9,HSSFCell.CELL_TYPE_STRING,style,
                        ptbPayTrade.BATCH_DATE?stf.format(ptbPayTrade.BATCH_DATE):null)
                createCell(row,10,HSSFCell.CELL_TYPE_STRING,style,PtbPayTrade.TradeAccTypeMap[ptbPayTrade.TRADE_ACCTYPE])
                createCell(row,11,HSSFCell.CELL_TYPE_STRING,style,ptbPayTrade.TRADE_BRANCHBANK)
                createCell(row,12,HSSFCell.CELL_TYPE_STRING,style,ptbPayTrade.TRADE_SUBBANK)
                createCellForMoney(row,13,HSSFCell.CELL_TYPE_NUMERIC,style,Double.parseDouble(nf.format(ptbPayTrade.TRADE_AMOUNT==null?0:ptbPayTrade.TRADE_AMOUNT).replaceAll(",","")))
                createCell(row,14,HSSFCell.CELL_TYPE_STRING,style,ptbPayTrade.BATCH_CHANELNAME)
                createCell(row,15,HSSFCell.CELL_TYPE_STRING,style,PtbPayBatch.BatchStyleMap[ptbPayTrade.BATCH_STYLE])
                createCell(row,16,HSSFCell.CELL_TYPE_STRING,style,PtbPayTrade.TradeStatusMap[ptbPayTrade.TRADE_STATUS])
                createCell(row,17,HSSFCell.CELL_TYPE_STRING,style,ptbPayTrade.TRADE_REASON)
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
