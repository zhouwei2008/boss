package pay

import groovy.sql.Sql
import org.apache.poi.hssf.usermodel.HSSFCellStyle
import org.apache.poi.hssf.usermodel.HSSFRichTextString
import org.apache.poi.hssf.usermodel.HSSFWorkbook
import org.apache.poi.hssf.util.HSSFColor
import org.apache.poi.hssf.util.Region
import org.apache.poi.ss.util.CellRangeAddress
import org.codehaus.groovy.grails.commons.ConfigurationHolder
import groovyx.net.http.HTTPBuilder
import groovyx.net.http.Method
import groovyx.net.http.ContentType
import org.springframework.web.multipart.commons.CommonsMultipartFile
import org.apache.http.entity.mime.MultipartEntity
import org.apache.http.entity.mime.content.InputStreamBody
import org.apache.http.entity.mime.content.StringBody
import org.apache.http.entity.mime.HttpMultipartMode
import org.apache.commons.httpclient.params.HttpMethodParams
import java.nio.charset.Charset
import org.springframework.web.multipart.MultipartHttpServletRequest

import java.text.SimpleDateFormat

class IpayService {
    def dataSource_ismp;

    final static String httpPayUrl = ConfigurationHolder.config.pay.serverUrl
    /**
     * 取渠道配置参数
     * @param merchantId
     * @param tradeType
     * @return
     */
    def getChanelParams(def merchantId,def tradeType){

        (new HTTPBuilder(httpPayUrl)).request(Method.POST, ContentType.JSON) { req ->
            uri.path = 'payInterface/getChanelParams'
            body = [merchantId: merchantId,tradeType:tradeType]
            response.success = { resp, json ->
                if(json.error){
                    throw new Exception(json.error)
                }
                return json
            }
            response.failure = { resp ->
                throw new Exception(resp.statusLine)
            }
        }
    }

    /**
     * 取下载信息
     * @param batchId
     * @return
     */
    def getDownLoadInfo(def batchId){
        (new HTTPBuilder(httpPayUrl)).request(Method.POST, ContentType.JSON) { req ->
            uri.path = 'payInterface/getDownLoadInfo'
            body = [batchId: batchId]
            response.success = { resp, json ->
                if(json.error){
                    throw new Exception(json.error)
                }
                return json
            }
            response.failure = { resp ->
                throw new Exception(resp.statusLine)
            }
        }
    }

    /**
     * 上传对账
     * @param merchantId
     * @param tradeType
     * @param batchId
     * @param request
     * @return
     */
    def uploadAndCheck(def merchantId,def tradeType,def batchId,MultipartHttpServletRequest request){
        CommonsMultipartFile tempFile = null;
        tempFile = request.getFile("upload")

        (new HTTPBuilder(httpPayUrl)).request(Method.POST) { req ->
            uri.path = 'payInterface/uploadAndCheck'
            MultipartEntity mpe = new MultipartEntity(HttpMultipartMode.BROWSER_COMPATIBLE);
            mpe.addPart('file', new InputStreamBody(tempFile.inputStream, tempFile.contentType,tempFile.originalFilename))
            mpe.addPart('fileName', new StringBody(tempFile.originalFilename,Charset.forName("UTF-8")))
            mpe.addPart('merchantId', new StringBody(merchantId))
            mpe.addPart('tradeType', new StringBody(tradeType))
            mpe.addPart('batchId', new StringBody(batchId))
            req.entity = mpe
            req.getParams().setParameter("http.connection.timeout", 300*1000)
            req.getParams().setParameter("http.socket.timeout", 300*1000)
            req.getParams().setParameter(HttpMethodParams.HTTP_CONTENT_CHARSET, "UTF-8");
            response.success = { resp, json ->
                if(json.error){
                    throw new Exception(json.error)
                }
                return json
            }
            response.failure = { resp ->
                throw new Exception(resp.statusLine)
            }
        }

    }

    /**
     *  重发对账结果
     * @param tradeId
     * @return
     */
    def reSendCheckMsg(def tradeId){
        PtbPayTrade trade = PtbPayTrade.get(tradeId as Long)
        PtbPayBatch batch = PtbPayBatch.get(trade.batchId as Long)
        (new HTTPBuilder(httpPayUrl)).request(Method.POST, ContentType.JSON) { req ->
            uri.path = 'payInterface/sendCheckMsg'
            body = [srvCode: trade.tradeCode,outOrder:trade.outTradeorder,
                   feedback:PtbPayTrade.TradeCheckResultMap[trade.tradeStatus],chanelId:batch.batchChanel,reason:trade.tradeReason]
            response.success = { resp, json ->
                if(json.error){
                    throw new Exception(json.error)
                }
                return json
            }
            response.failure = { resp ->
                throw new Exception(resp.statusLine)
            }
        }
    }

    /**
     *  批量重发对账结果
     * @param batchId
     * @return
     */
    def reSendCheckMsgByBatch(def batchId){
        (new HTTPBuilder(httpPayUrl)).request(Method.POST, ContentType.JSON) { req ->
            uri.path = 'payInterface/reSendCheckMsgByBatch'
            body = [batchId: batchId]
            response.success = { resp, json ->
                if(json.error){
                    throw new Exception(json.error)
                }
                return json
            }
            response.failure = { resp ->
                throw new Exception(resp.statusLine)
            }
        }
    }

    /**
     * 重发对账结果
     * @param tradeId
     * @param feedback
     * @param tradeReason
     * @return
     */
    def reSendCheckMsg(String tradeId,String feedback, String tradeReason){
        PtbPayTrade trade = PtbPayTrade.get(tradeId as Long)
        PtbPayBatch batch = PtbPayBatch.get(trade.batchId as Long)
        (new HTTPBuilder(httpPayUrl)).request(Method.POST, ContentType.JSON) { req ->
            uri.path = 'payInterface/sendCheckMsg'
            body = [srvCode: trade.tradeCode,outOrder:trade.outTradeorder,
                   feedback:feedback,chanelId:batch.batchChanel,reason:tradeReason]
            response.success = { resp, json ->
                if(json.error){
                    throw new Exception(json.error)
                }
                return json
            }
            response.failure = { resp ->
                throw new Exception(resp.statusLine)
            }
        }
    }


    def  buildExcel(List list,PtbPayBatch ptbPayBatch){
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
            cell.setCellValue(""+formatDateBak(new Date()))

            cell = row.createCell((short) (1));
            cell.setCellStyle(style)
            cell.setCellValue(createNumNo())

            cell = row.createCell((short) (2));
            cell.setCellStyle(style)
            cell.setCellValue(ptbPayBatch.batchCount)

            cell = row.createCell((short) (3));
            cell.setCellStyle(style)
            cell.setCellValue(ptbPayBatch.batchAmount)

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
            def dateArr = list
            PtbPayTrade payTrade = null
        for (int j = 0;j<dateArr.size();j++){
            payTrade = (PtbPayTrade) dateArr.get(j)

            row = sheet.createRow((short) 9+j)
            cell = row.createCell((short)0);
            cell.setCellStyle(style);
            cell.setCellValue((j+1));

            cell = row.createCell((short)1);
            cell.setCellStyle(style);
            cell.setCellValue("");

            cell = row.createCell((short)2);
            cell.setCellStyle(style);
            cell.setCellValue(payTrade.tradeNote2);

            cell = row.createCell((short)3);
            cell.setCellStyle(style);
            cell.setCellValue(payTrade.tradeCardnum);

            cell = row.createCell((short)4);
            cell.setCellStyle(style);
            cell.setCellValue(payTrade.tradeCardname);

            cell = row.createCell((short)5);
            cell.setCellStyle(style);
            cell.setCellValue(payTrade.tradeAmount);

            cell = row.createCell((short)6);
            cell.setCellStyle(style);
            cell.setCellValue(payTrade.id);

            cell = row.createCell((short)7);
            cell.setCellStyle(style);
            cell.setCellValue(payTrade.tradeNote);

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

    def formatDateBak(Date date){//传出数据
        SimpleDateFormat sdfd = new SimpleDateFormat("yyyyMMdd");
        return sdfd.format(date);
    }

    def createNumNo() {
        def sql = new Sql(dataSource_ismp)
        def seq = sql.firstRow('SELECT LPAD(SEQ_JINLIAN_WANJIA.NEXTVAL,6,\'0\') AS ID FROM DUAL')['ID']
        return seq
    }


    def  build19PayExcel(List list,PtbPayBatch ptbPayBatch){

        def wb = new HSSFWorkbook();
        try {
            def sheet = wb.createSheet("new sheet");
            def row
            def cell
            def style = wb.createCellStyle()//模板列表样式
            def style1 = wb.createCellStyle()//模板头样式
            def style2 = wb.createCellStyle()//模板说明样式

            def font   =   wb.createFont()
            font.setFontHeightInPoints((short)10)
            font.setFontName("宋体")

            def font1 = wb.createFont()
            font1.setFontHeightInPoints((short)9)
            font1.setFontName("微软雅黑")
            font1.setColor(HSSFColor.SKY_BLUE.index)

            def font2 = wb.createFont()
            font2.setFontHeightInPoints((short)9)
            font2.setFontName("微软雅黑")
            font2.setColor(HSSFColor.RED.index)

            style.setFont(font)
            style.setAlignment(HSSFCellStyle.ALIGN_CENTER)
            style1.setVerticalAlignment(HSSFCellStyle.VERTICAL_CENTER);//垂直
//          style.setFillBackgroundColor(HSSFColor.ORANGE.index)
            style.setWrapText(true);// 自动换行

            style1.setVerticalAlignment(HSSFCellStyle.VERTICAL_CENTER);//垂直
            style1.setWrapText(true);// 自动换行
            style1.setFont(font)

            style2.setVerticalAlignment(HSSFCellStyle.VERTICAL_CENTER);//垂直
            style2.setWrapText(true);// 自动换行
            style2.setFont(font1)


            row = sheet.createRow((short) 0);

            sheet.setColumnWidth(0, 4800);
            cell = row.createCell((short) 0);
            cell.setCellStyle(style1)
            cell.setCellValue("请在下方填写批次号：（可空，若填写必须为10位数字）")

            sheet.setColumnWidth(1, 4200);

            sheet.setColumnWidth(2, 6000);
            cell = row.createCell((short) 2);
            cell.setCellStyle(style)
            cell.setCellValue("请在下方填写申请人\n(可空)")

            String[] explainArr = [
                "说明：\n",
                "1.请确保您的数据完整且真实，否则数据均视为无效。\n",
                "2.批次号：可空，若空则系统自动生成，若填写，则提交的批次号须为10位数字，且不可重复。\n",
                "3.序号：此批次内订单的序号，可手动修改，但序号不可重复。\n" ,
                "4.开户银行 ：选择 用户银行账号的开户银行，若清除格式后填写，填写名称必须存在于提供的银行名称表中，且完全相同。\n" ,
                "5.金额：填写付款的金额，单位为元，货币为人民币，付款精度支持到分。例如填写15.23，即为付款15元2角3分。\n" ,
                "6.商户业务描述：支持中英文，长度不超过32个字。\n" ,
                "7.账户类型：默认个人账户。（如需变动请手动修改个人账户或企业账户）\n" ,
                "8.支付方式：默认实时支付。（如需变动请手动修改实时支付、快速支付或普通支付）\n" ,
                "9.联行号：可空，若填写须为准确联行号。（是否需填写根据银行能力进行调整，详见页面提示信息）\n" ,
                "10.单模板限制条数10000条。"
            ]

            String explain = explainArr[0]+explainArr[1]+explainArr[2]+explainArr[3]+explainArr[4]+explainArr[5]+explainArr[6]+explainArr[7]+explainArr[8]+explainArr[9]+explainArr[10]

            HSSFRichTextString ts= new HSSFRichTextString(explain)
            //==================================说明 第1行==============================
            ts.applyFont(
                    explain.indexOf(explainArr[0]),
                    explain.indexOf(explainArr[0]) + explainArr[0].length(),
                    font2
            );
            //==================================说明 第2行==============================
            ts.applyFont(
                    explain.indexOf(explainArr[1]),
                    explain.indexOf(explainArr[1]) + 9,
                    font1
            );

            ts.applyFont(
                    explain.indexOf(explainArr[1]) + 9,
                    explain.indexOf(explainArr[1]) + 9 + 5,
                    font2
            );

            ts.applyFont(
                    explain.indexOf(explainArr[1]) + 9 + 5,
                    explain.indexOf(explainArr[1])+explainArr[1].length(),
                    font1
            );

            //==================================说明 第3行==============================
            ts.applyFont(
                    explain.indexOf(explainArr[2]),
                    explain.indexOf(explainArr[2]) + 6,
                    font1
            );

            ts.applyFont(
                    explain.indexOf(explainArr[2]) + 6,
                    explain.indexOf(explainArr[2]) + 6 + 2,
                    font2
            );

            ts.applyFont(
                    explain.indexOf(explainArr[2]) + 6 + 2,
                    explain.indexOf(explainArr[2]) + 6 + 2 +24 ,
                    font1
            );

            ts.applyFont(
                    explain.indexOf(explainArr[2]) + 6 + 2 + 24,
                    explain.indexOf(explainArr[2]) + 6 + 2 + 24 + 5,
                    font2
            );

            ts.applyFont(
                    explain.indexOf(explainArr[2]) + 6 + 2 + 24 + 5,
                    explain.indexOf(explainArr[2]) + explainArr[2].length(),
                    font1
            );



            //==================================说明 第4行==============================
            ts.applyFont(
                    explain.indexOf(explainArr[3]),
                    explain.indexOf(explainArr[3]) + 24,
                    font1
            );

            ts.applyFont(
                    explain.indexOf(explainArr[3]) + 24,
                    explain.indexOf(explainArr[3]) + 24+ 4,
                    font2
            );

            ts.applyFont(
                    explain.indexOf(explainArr[3]) + 24 +4,
                    explain.indexOf(explainArr[3]) + explainArr[3].length(),
                    font1
            );



            //==================================说明 第5行==============================
            ts.applyFont(
                    explain.indexOf(explainArr[4]),
                    explain.indexOf(explainArr[4]) + 52,
                    font1
            );

            ts.applyFont(
                    explain.indexOf(explainArr[4]) + 52,
                    explain.indexOf(explainArr[4]) + 52 + 4,
                    font2
            );

            ts.applyFont(
                    explain.indexOf(explainArr[4]) + 52 + 4,
                    explain.indexOf(explainArr[4]) + explainArr[4].length(),
                    font1
            );
            //==================================说明 第6行==============================
            ts.applyFont(
                    explain.indexOf(explainArr[5]),
                    explain.indexOf(explainArr[5]) + 16,
                    font1
            );

            ts.applyFont(
                    explain.indexOf(explainArr[5]) + 16,
                    explain.indexOf(explainArr[5]) + 16 + 1,
                    font2
            );

            ts.applyFont(
                    explain.indexOf(explainArr[5]) + 16 + 1,
                    explain.indexOf(explainArr[5]) + 16 + 1 + 4,
                    font1
            );


            ts.applyFont(
                    explain.indexOf(explainArr[5]) + 16 + 1 + 4,
                    explain.indexOf(explainArr[5]) + 16 + 1 + 4 + 3,
                    font2
            );

            ts.applyFont(
                    explain.indexOf(explainArr[5]) + 16 + 1 + 4 + 3,
                    explain.indexOf(explainArr[5]) + explainArr[5].length(),
                    font1
            );
            //==================================说明 第7行==============================
            ts.applyFont(
                    explain.indexOf(explainArr[6]),
                    explain.indexOf(explainArr[6]) + 20,
                    font1
            );
            ts.applyFont(
                    explain.indexOf(explainArr[6]) + 20,
                    explain.indexOf(explainArr[6]) + 20 + 2,
                    font2
            );

            ts.applyFont(
                    explain.indexOf(explainArr[6]) + 20 + 2,
                    explain.indexOf(explainArr[6]) + explainArr[6].length(),
                    font1
            );


           //==================================说明 第8行==============================
            ts.applyFont(
                    explain.indexOf(explainArr[7]),
                    explain.indexOf(explainArr[7]) + explainArr[7].length(),
                    font1
            );
            //==================================说明 第9行==============================
            ts.applyFont(
                    explain.indexOf(explainArr[8]),
                    explain.indexOf(explainArr[8]) + explainArr[8].length(),
                    font1
            );
            //==================================说明 第10行==============================
            ts.applyFont(
                    explain.indexOf(explainArr[9]),
                    explain.indexOf(explainArr[9]) + 14,
                    font1
            );

            ts.applyFont(
                    explain.indexOf(explainArr[9]) + 14,
                    explain.indexOf(explainArr[9]) + 14 + 2,
                    font2
            );

            ts.applyFont(
                    explain.indexOf(explainArr[9]) + 14 + 2,
                    explain.indexOf(explainArr[9]) + explainArr[9].length(),
                    font1
            );

            //==================================说明 第11行==============================
            ts.applyFont(
                    explain.indexOf(explainArr[10]),
                    explain.indexOf(explainArr[10]) + 10,
                    font1
            );
            ts.applyFont(
                    explain.indexOf(explainArr[10]) + 10,
                    explain.indexOf(explainArr[10]) + 10 + 5,
                    font2
            );
            ts.applyFont(
                    explain.indexOf(explainArr[10]) + 10 + 5,
                    explain.indexOf(explainArr[10]) + explainArr[10].length(),
                    font1
            );


            cell = row.createCell((short) 3);
            cell.setCellStyle(style2)
            cell.setCellValue(ts)

            sheet.setColumnWidth(3, 6000);
            sheet.setColumnWidth(4, 4200);
            sheet.setColumnWidth(5, 4200);
            sheet.setColumnWidth(6, 4200);
            sheet.setColumnWidth(7, 5000);
            sheet.setColumnWidth(8, 3500);

            sheet.addMergedRegion(new CellRangeAddress(0, 1, 3, 8));

            row = sheet.createRow((short) 1)
            row.setHeight((short) 2400);

            row = sheet.createRow((short) 2)
            def titleArr = ['序号','收款人姓名','银行账号','开户银行','金额','账户类型（可空）','支付方式（可空）','商户业务描述(可空)','联行号（可空）']
            for (int i = 0; i < titleArr.size(); i++){
                cell = row.createCell((short)i);
                cell.setCellStyle(style);
                cell.setCellValue(titleArr[i]);
            }
            def dateArr = list
            PtbPayTrade payTrade = null
            for (int j = 0;j<dateArr.size();j++){
                payTrade = (PtbPayTrade) dateArr.get(j)

                row = sheet.createRow((short)3+j)
                cell = row.createCell((short)0);
                cell.setCellStyle(style);
                cell.setCellValue((j+1));

                cell = row.createCell((short)1);
                cell.setCellStyle(style);
                cell.setCellValue(payTrade.tradeCardname);

                cell = row.createCell((short)2);
                cell.setCellStyle(style);
                cell.setCellValue(payTrade.tradeCardnum);

                cell = row.createCell((short)3);
                cell.setCellStyle(style);
                cell.setCellValue(payTrade.tradeBank);

                cell = row.createCell((short)4);
                cell.setCellStyle(style);
                cell.setCellValue(payTrade.tradeAmount);

                cell = row.createCell((short)5);
                cell.setCellStyle(style);
                cell.setCellValue(payTrade.tradeAcctype);

                cell = row.createCell((short)6);
                cell.setCellStyle(style);
                cell.setCellValue("实时支付");

                cell = row.createCell((short)7);
                cell.setCellStyle(style);
                cell.setCellValue(payTrade?.tradeNote);

                cell = row.createCell((short)8);
                cell.setCellStyle(style);
                cell.setCellValue("");
            }
        }catch (Exception e){
            e.printStackTrace()
        }
        return wb
    }
}
