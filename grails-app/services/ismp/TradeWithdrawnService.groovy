package ismp

import boss.BoBankDic
import groovy.sql.Sql
import org.apache.poi.hssf.usermodel.HSSFCellStyle
import org.apache.poi.hssf.usermodel.HSSFRichTextString
import org.apache.poi.hssf.usermodel.HSSFWorkbook
import org.apache.poi.hssf.util.HSSFColor
import org.apache.poi.hssf.util.Region
import java.text.SimpleDateFormat

class TradeWithdrawnService {

    static transactional = true

    def dataSource_ismp;


    def  buildJinLianWanJiaExcel(def result,def totalAmount,def totalCount){
        def wb = new HSSFWorkbook();
        try {
            def sheet = wb.createSheet("new sheet");
            def row
            def cell
            def style = wb.createCellStyle()
            def font   =   wb.createFont()
            font.setFontHeightInPoints((short)12)
            font.setFontName("宋体")

            def font1 = wb.createFont()
            font1.setFontHeightInPoints((short)12)
            font1.setFontName("宋体")
            font1.setColor(HSSFColor.RED.index)

            style.setFont(font)
            style.setAlignment(HSSFCellStyle.ALIGN_CENTER)
            style.setFillBackgroundColor(HSSFColor.ORANGE.index)
            row = sheet.createRow((short) 0);
            cell = row.createCell((short) 0);
            cell.setCellStyle(style)

            String title1 = "代付模板（*为必填项）"
            HSSFRichTextString ts1= new HSSFRichTextString(title1)
            ts1.applyFont(0,title1.indexOf("（"),font)
            ts1.applyFont(title1.indexOf("（"),title1.size(),font1)

            cell.setCellValue(ts1)
            sheet.addMergedRegion(new Region((short)0, (short)0, (short)0, (short)8));


            row = sheet.createRow((short) 1);
            cell = row.createCell((short) (0));
            cell.setCellStyle(style)
            cell.setCellValue("模板ID号")

            String title2 = "业务类型*"
            HSSFRichTextString ts2= new HSSFRichTextString(title2)
            ts2.applyFont(0,title2.indexOf("*"),font)
            ts2.applyFont(title2.indexOf("*"),title2.size(),font1)

            cell = row.createCell((short) (1));
            cell.setCellStyle(style)
            cell.setCellValue(ts2)

            cell = row.createCell((short) (2));
            cell.setCellStyle(style)
            cell.setCellValue("协议号")

            row = sheet.createRow((short) 2);
            cell = row.createCell((short) (0));
            cell.setCellStyle(style)
            cell.setCellValue("CACP-CM01")

            cell = row.createCell((short) (1));
            cell.setCellStyle(style)
            cell.setCellValue("40501")

            cell = row.createCell((short) (2));
            cell.setCellStyle(style)
            cell.setCellValue("00000000")

            String title3 = "企业编码*"
            HSSFRichTextString ts3= new HSSFRichTextString(title3)
            ts3.applyFont(0,title3.indexOf("*"),font)
            ts3.applyFont(title3.indexOf("*"),title3.size(),font1)

            row = sheet.createRow((short) 3);
            cell = row.createCell((short) (0));
            cell.setCellStyle(style)
            cell.setCellValue(ts3)

            String title4 = "业务种类*"
            HSSFRichTextString ts4= new HSSFRichTextString(title4)
            ts4.applyFont(0,title4.indexOf("*"),font)
            ts4.applyFont(title4.indexOf("*"),title4.size(),font1)

            cell = row.createCell((short) (1));
            cell.setCellStyle(style)
            cell.setCellValue(ts4)

            String title5 = "付款人开户行行号*"
            HSSFRichTextString ts5= new HSSFRichTextString(title5)
            ts5.applyFont(0,title5.indexOf("*"),font)
            ts5.applyFont(title5.indexOf("*"),title5.size(),font1)

            cell = row.createCell((short) (2));
            cell.setCellStyle(style)
            cell.setCellValue(ts5)

            String title6 = "付款人银行账号*"
            HSSFRichTextString ts6= new HSSFRichTextString(title6)
            ts6.applyFont(0,title6.indexOf("*"),font)
            ts6.applyFont(title6.indexOf("*"),title6.size(),font1)

            cell = row.createCell((short) (3));
            cell.setCellStyle(style)
            cell.setCellValue(ts6)

            row = sheet.createRow((short) 4);
            cell = row.createCell((short) (0));
            cell.setCellStyle(style)
            cell.setCellValue("11001305")

            cell = row.createCell((short) (1));
            cell.setCellStyle(style)
            cell.setCellValue("04900")

            cell = row.createCell((short) (2));
            cell.setCellStyle(style)
            cell.setCellValue("104110050005")

            cell = row.createCell((short) (3));
            cell.setCellStyle(style)
            cell.setCellValue("270075936146")

            row = sheet.createRow((short) 5);
            cell = row.createCell((short) (0));
            cell.setCellStyle(style)
            cell.setCellValue("日期")

            cell = row.createCell((short) (1));
            cell.setCellStyle(style)
            cell.setCellValue("序号")

            String title7 = "明细数目*"
            HSSFRichTextString ts7= new HSSFRichTextString(title7)
            ts7.applyFont(0,title7.indexOf("*"),font)
            ts7.applyFont(title7.indexOf("*"),title7.size(),font1)

            cell = row.createCell((short) (2));
            cell.setCellStyle(style)
            cell.setCellValue(ts7)

            String title8 = "金额(单位:元)*"
            HSSFRichTextString ts8= new HSSFRichTextString(title8)
            ts8.applyFont(0,title8.indexOf("*"),font)
            ts8.applyFont(title8.indexOf("*"),title8.size(),font1)

            cell = row.createCell((short) (3));
            cell.setCellStyle(style)
            cell.setCellValue(ts8)

            row = sheet.createRow((short) 6);
            cell = row.createCell((short) (0));
            cell.setCellStyle(style)
            cell.setCellValue(formatDateBak("yyyyMMdd"))

            cell = row.createCell((short) (1));
            cell.setCellStyle(style)
            cell.setCellValue(createNumNo())

            cell = row.createCell((short) (2));
            cell.setCellStyle(style)
            cell.setCellValue(totalCount)

            cell = row.createCell((short) (3));
            cell.setCellStyle(style)
            cell.setCellValue(formatAmount(totalAmount))

            row = sheet.createRow((short) 7);
            cell = row.createCell((short) 0);
            cell.setCellStyle(style)
            cell.setCellValue("明细信息")
            sheet.addMergedRegion(new Region((short)7, (short)0, (short)7, (short)8));

            row = sheet.createRow((short) 8)
            def titleArr = ['明细序号','收款人开户行行号','收款人开户行名称*','收款人银行账号*','户名*','金额(单位:元)*','企业流水号','备注','手机号（如需短信通知，请填写手机号）']
            for (int i = 0; i < titleArr.size(); i++)
            {
                cell = row.createCell((short)i);
                cell.setCellStyle(style);
                if(titleArr[i].indexOf("*")!=-1){
                    HSSFRichTextString ts= new HSSFRichTextString(titleArr[i])
                    ts.applyFont(0,titleArr[i].indexOf("*"),font)
                    ts.applyFont(titleArr[i].indexOf("*"),titleArr[i].size(),font1)
                    cell = row.createCell((short)i);
                    cell.setCellValue(ts);
                }else{
                    cell.setCellValue(titleArr[i]);
                }

            }

            TradeWithdrawn tradeWithdrawn = null
            for (int j = 0;j<result.size();j++){
                tradeWithdrawn = (TradeWithdrawn) result.get(j)

                row = sheet.createRow((short) 9+j)
                cell = row.createCell((short)0);
                cell.setCellStyle(style);
                cell.setCellValue((j+1));

                cell = row.createCell((short)1);
                cell.setCellStyle(style);
                cell.setCellValue("");

                cell = row.createCell((short)2);
                cell.setCellStyle(style);
                cell.setCellValue(BoBankDic.findByCode(tradeWithdrawn?.customerBankCode)?.name+ismp.CmCustomerBankAccount.findByBankAccountNoAndBankNo(tradeWithdrawn?.customerBankAccountNo,tradeWithdrawn?.customerBankNo)?.branch+ismp.CmCustomerBankAccount.findByBankAccountNoAndBankNo(tradeWithdrawn?.customerBankAccountNo,tradeWithdrawn?.customerBankNo)?.subbranch);

                cell = row.createCell((short)3);
                cell.setCellStyle(style);
                cell.setCellValue(tradeWithdrawn?.customerBankAccountNo);

                cell = row.createCell((short)4);
                cell.setCellStyle(style);
                cell.setCellValue(tradeWithdrawn?.customerBankAccountName);

                cell = row.createCell((short)5);
                cell.setCellStyle(style);
                cell.setCellValue(tradeWithdrawn.amount?formatAmount(tradeWithdrawn.amount):0);

                cell = row.createCell((short)6);
                cell.setCellStyle(style);
                cell.setCellValue("");

                cell = row.createCell((short)7);
                cell.setCellStyle(style);
                cell.setCellValue(tradeWithdrawn?.note);

                cell = row.createCell((short)8);
                cell.setCellStyle(style);
                cell.setCellValue("");
            }

            for (int k = 0;k<9;k++){
                sheet.autoSizeColumn((short)k); //调整第K列宽度
            }

        }catch (Exception e){
            e.printStackTrace()
        }
        return wb
    }

    def formatDateBak(String str){//传出数据
        SimpleDateFormat sdfd = new SimpleDateFormat(str);
        return sdfd.format(new Date());
    }

    def createNumNo() {
        def sql = new Sql(dataSource_ismp)
        def seq = sql.firstRow('SELECT LPAD(SEQ_JINLIAN_WANJIA.NEXTVAL,6,\'0\') AS ID FROM DUAL')['ID']
        return seq
    }

    def formatAmount(def amount){
        BigDecimal b1 = new BigDecimal(Double.toString(amount));
        return b1.divide(100,2,BigDecimal.ROUND_HALF_UP).doubleValue();
    }

}
