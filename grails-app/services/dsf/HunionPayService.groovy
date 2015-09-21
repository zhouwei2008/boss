package dsf

import org.apache.commons.httpclient.HttpClient;
import org.apache.commons.httpclient.HttpException;
import org.apache.commons.httpclient.HttpStatus;
import org.apache.commons.httpclient.methods.PostMethod;
import org.apache.commons.httpclient.params.HttpMethodParams
import java.util.zip.ZipInputStream
import Constants.FarmConstants
import org.dom4j.Document;
import org.dom4j.DocumentHelper;
import org.dom4j.Element
import org.apache.http.HttpRequest
import org.codehaus.groovy.grails.commons.ConfigurationHolder
import groovyx.net.http.HTTPBuilder
import boss.BoBankDic
import boss.BoAcquirerAccount;
/**
 * Created by IntelliJ IDEA.
 * User: syw
 * Date: 11-11-28
 * Time: 下午4:19
 * To change this template use File | Settings | File Templates.
 */
class HunionPayService {
    static transactional = true
    static Properties p = new Properties();
    def jmsService
    static {
        loadP()
    }

    def static synchronized loadP() {

        p.load(this.classLoader.getResourceAsStream("bank/hChinapayReCode.properties"))
    }

    //def request
    def sendQuery () throws RuntimeException{
        def bankDic = BoBankDic.findByCode('HCHINAPAY')
        def accs = BoAcquirerAccount.findAllByBank(bankDic)
        StringBuffer sb = new StringBuffer()
        for(BoAcquirerAccount acc : accs){
            sb.append("'")
            sb.append(acc.id)
            sb.append("'")
            sb.append(",")
        }
        println 'ids ' + sb.toString().substring(0, sb.length() - 1)
        def sendString
        def tbPcInfos = TbPcInfo.executeQuery("from TbPcInfo where tbDealstyle='autoPay' and tbPcDkStatus='2' and tbPcCheckStatus='1' and tbPcDkChanel in (" + sb.toString().substring(0, sb.length() - 1) + ")")
        println 'tbPcInfos ' + tbPcInfos.size()
        for (int i = 0; i < tbPcInfos.size(); i++) {
            println 'Ready Auto Query Order ' + tbPcInfos.get(i).id
            sendString = combineQuery(tbPcInfos.get(i).id)
            sendQueryReq(true, sendString, tbPcInfos.get(i).tbSfFlag)

        }
    }
    /**
     * 自动补单
     */
    def autoBd () {
        def bankDic = BoBankDic.findByCode('HCHINAPAY')
        def accs = BoAcquirerAccount.findAllByBank(bankDic)
         StringBuffer sb = new StringBuffer()
        for(BoAcquirerAccount acc : accs){
            sb.append("'")
            sb.append(acc.id)
            sb.append("'")
            sb.append(",")
        }
        println 'ids ' + sb.toString().substring(0, sb.length() - 1)
        def tbPcInfos = TbPcInfo.executeQuery("from TbPcInfo where tbDealstyle='autoPay' and tbPcDkStatus='1' and tbPcCheckStatus='1' and tbPcDkChanel in (" + sb.toString().substring(0, sb.length() - 1) + ")")
        for (int i = 0; i < tbPcInfos.size(); i++) {
            println 'Ready Auto ReSend Order ' + tbPcInfos.get(i).id
            TbAgentpayDetailsInfoController tbAgentpayDetailsInfoController = new TbAgentpayDetailsInfoController()
            tbAgentpayDetailsInfoController.autoBd(tbPcInfos.get(i).id)
        }
    }
    /**
     *
     * @param id
     * @return
     */
    def combineQuery(def id) {
        StringBuffer sb = new StringBuffer()
        TbAgentpayDetailsInfoController tbAgentpayDetailsInfoController = new TbAgentpayDetailsInfoController()
        TbPcInfo tbPcInfo = TbPcInfo.get(id)
        sb.append("<?xml version='1.0' encoding='GBK'?>")
        sb.append("<GZELINK>")
        sb.append("<INFO>")
        sb.append("<TRX_CODE>200001</TRX_CODE>")
        sb.append("<VERSION>03</VERSION>")
        sb.append("<DATA_TYPE>2</DATA_TYPE>")
        sb.append("<REQ_SN>").append((tbPcInfo.tbPcDate).format("yyyyMMdd") + "0" + (id as String)).append("</REQ_SN>")
        if (tbPcInfo.tbSfFlag == 'S') {
            sb.append("<USER_NAME>").append(FarmConstants.haoEasyUserNos).append("</USER_NAME>")
            sb.append("<USER_PASS>").append(FarmConstants.haoEasyUserPass).append("</USER_PASS>")
        } else {
            sb.append("<USER_NAME>").append(FarmConstants.haoEasyUserNof).append("</USER_NAME>")
            sb.append("<USER_PASS>").append(FarmConstants.haoEasyUserPass).append("</USER_PASS>")
        }
        sb.append("<SIGNED_MSG></SIGNED_MSG>")
        sb.append("</INFO>")
        sb.append("<BODY>")
        sb.append("<QUERY_TRANS>")
        sb.append("<QUERY_SN>").append((tbPcInfo.tbPcDate).format("yyyyMMdd") + "0" + (id as String)).append("</QUERY_SN>")
        sb.append("<QUERY_REMARK>查询备注</QUERY_REMARK>")
        sb.append("</QUERY_TRANS>")
        sb.append("</BODY>")
        sb.append("</GZELINK>")

        // String strRnt = tbAgentpayDetailsInfoController.signMsg(sb.toString())
        return sb.toString()
    }
    /**
     * 测试请求
     * comment here
     * @since gnete-ora 0.0.0.1
     */
    private void sendQueryReq(boolean bCompress, String strSendData, String flag) throws RuntimeException{
        TbAgentpayDetailsInfoController tbAgentpayDetailsInfoController = new TbAgentpayDetailsInfoController()
        HttpClient httpClient = new HttpClient();
        httpClient.getHttpConnectionManager().getParams().setConnectionTimeout(300*1000);
        httpClient.getHttpConnectionManager().getParams().setSoTimeout(300*1000);
        PostMethod postMethod = null;
        def gateway = ConfigurationHolder.config.gateway.inner.server
        char a = gateway.charAt(gateway.length() - 1);
        if (a == '/') {
            gateway = gateway.substring(0, gateway.length() - 1);
        }
        if (bCompress) {
            postMethod = new PostMethod(gateway + "/ISMSApp/HUnionPayTransfer/sendData");
        }
        httpClient.getParams().setParameter(HttpMethodParams.HTTP_CONTENT_CHARSET, "GBK");

        strSendData = tbAgentpayDetailsInfoController.signMsg(strSendData, flag);
        if (bCompress) {
            strSendData = tbAgentpayDetailsInfoController.compress(strSendData);
        }
        postMethod.setRequestBody(strSendData);
        try {
            long start = System.currentTimeMillis();
            int statusCode = httpClient.executeMethod(postMethod);
            if (statusCode != HttpStatus.SC_OK) {
                byte[] responseBody = postMethod.getResponseBody();
                String strResp = new String(responseBody, "GBK");
                System.out.println(strResp);
            }
            else {
                byte[] responseBody = postMethod.getResponseBody();
                String strResp = new String(responseBody, "GBK");
                System.out.println("查询返回服务器返回:" + strResp);
                if (bCompress) {
                    strResp = decompress(strResp, bCompress);
                    System.out.println(new Date().toLocaleString()+"查询返回还原:" + strResp);
                }
                if (tbAgentpayDetailsInfoController.verifySign(strResp)) {
                    anly(strResp)
                    System.out.println("验签正确，处理服务器返回的报文");
                }
            }
        } catch (HttpException e) {
            //发生致命的异常，可能是协议不对或者返回的内容有问题
            e.printStackTrace();
            throw new RuntimeException("error HttpException")
        } catch (IOException e) {
            //发生网络异常
            e.printStackTrace();
            throw new RuntimeException("error IOException")
        } catch (Exception e) {
            e.printStackTrace();
           throw new RuntimeException("error")
        } finally {
            //释放连接
            postMethod.releaseConnection();
        }

    }
    /**
     * 解压数据
     * comment here
     * @param strData
     * @param bCompress
     * @return
     * @since gnete-pds 0.0.0.1
     */
    private String decompress(String strData, boolean bCompress) {
        String strRnt = strData;
        if (bCompress) {
            try {
                strRnt = this.decompresszip(new sun.misc.BASE64Decoder().decodeBuffer(strData));
            } catch (IOException e) {
                e.printStackTrace();
            }
        }
        return strRnt;
    }
    /**
     * 将压缩后的 byte[] 数据解压缩
     *
     * @param compressed
     *            压缩后的 byte[] 数据
     * @return 解压后的字符串
     */
    private final String decompresszip(byte[] compressed) {
        if (compressed == null)
            return null;

        ByteArrayOutputStream out = null;
        ByteArrayInputStream inpu = null;
        ZipInputStream zin = null;
        String decompressed;
        try {
            out = new ByteArrayOutputStream();
            inpu = new ByteArrayInputStream(compressed);
            zin = new ZipInputStream(inpu);
            java.util.zip.ZipEntry entry = zin.getNextEntry();
            byte[] buffer = new byte[1024];
            int offset = -1;
            while ((offset = zin.read(buffer)) != -1) {
                out.write(buffer, 0, offset);
            }
            decompressed = out.toString("GBK");
        } catch (IOException e) {
            decompressed = null;
        } finally {
            if (zin != null) {
                try {
                    zin.close();
                } catch (IOException e) {
                }
            }
            if (inpu != null) {
                try {
                    inpu.close();
                } catch (IOException e) {
                }
            }
            if (out != null) {
                try {
                    out.close();
                } catch (IOException e) {
                }
            }
        }

        return decompressed;
    }
    /**
     * 对账
     * @param strResp
     * @return
     */
    def checkMoney(String reqSN, String account, String accountName, String amount, String retCode, String reason) throws RuntimeException{
        TbPcInfoController tbPcInfoController = new TbPcInfoController()
        TbAgentpayDetailsInfo tbAgentpayDetailsInfo = new TbAgentpayDetailsInfo()
        tbAgentpayDetailsInfo.dkPcNo = reqSN
        tbAgentpayDetailsInfo.payStatus = '5'//打款完成即已处理的
        tbAgentpayDetailsInfo.tradeCardname = accountName
        tbAgentpayDetailsInfo.tradeCardnum = account
        tbAgentpayDetailsInfo.tradeAmount = Double.valueOf(amount) / 100

        try {
            def tbAgentpayDetailsInfoTemp = TbAgentpayDetailsInfo.find(tbAgentpayDetailsInfo);
            javax.jms.MapMessage message = jmsService.createMapMessage()
            jmsService.send(message)
           // for (int i = 0; i < list.size(); i++) {
                //def object = list.get(0)
                //TbAgentpayDetailsInfo tbAgentpayDetailsInfoTemp = TbAgentpayDetailsInfo.get(object.id)
            if(tbAgentpayDetailsInfoTemp){
                if (retCode == "0000") {
                    if (tbAgentpayDetailsInfoTemp.tradeType == 'F') { //代付
                        tbAgentpayDetailsInfoTemp.payStatus = '6'
                        tbAgentpayDetailsInfoTemp.tradeStatus = '2'
                        tbAgentpayDetailsInfoTemp.tradeFeedbackcode = '成功'
                        tbAgentpayDetailsInfoTemp.save(failOnError: true)
                        tbPcInfoController.sDealAccount(tbAgentpayDetailsInfoTemp)
                    } else {
                        tbAgentpayDetailsInfoTemp.payStatus = '6'
                        tbAgentpayDetailsInfoTemp.tradeStatus = '2'
                        tbAgentpayDetailsInfoTemp.tradeFinishdate = new Date()
                        tbAgentpayDetailsInfoTemp.sendStatus = '1'
                        tbAgentpayDetailsInfoTemp.tradeFeedbackcode = '成功'
                         tbAgentpayDetailsInfoTemp.save(failOnError: true)
                        tbPcInfoController.dsSRemMoney(tbAgentpayDetailsInfoTemp)
                        tbPcInfoController.sendToSettle(tbAgentpayDetailsInfoTemp, true)
                    }
                }
                else {
                    if (tbAgentpayDetailsInfoTemp.tradeType == 'F') { //代付
                        tbAgentpayDetailsInfoTemp.payStatus = '7'//对账失败,待退款
                        tbAgentpayDetailsInfoTemp.tradeFeedbackcode = '失败'
                        tbAgentpayDetailsInfoTemp.tradeReason = reason
                        tbAgentpayDetailsInfoTemp.save(failOnError: true)
                    } else {
                        tbAgentpayDetailsInfoTemp.payStatus = '9'//代收对账失败,应为已退款
                        tbAgentpayDetailsInfoTemp.tradeStatus = '2'
                        tbAgentpayDetailsInfoTemp.tradeFinishdate = new Date()
                        tbAgentpayDetailsInfoTemp.tradeFeedbackcode = '失败'
                        tbAgentpayDetailsInfoTemp.tradeReason = reason
                        tbAgentpayDetailsInfoTemp.save(failOnError: true)
                        tbPcInfoController.sendToSettle(tbAgentpayDetailsInfoTemp, false)
                    }
                }
           // }
                log.debug("对账完毕的交易号为:"+tbAgentpayDetailsInfoTemp.id+"批次号为:"+tbAgentpayDetailsInfoTemp.dkPcNo);

                 def items = TbAgentpayDetailsInfo.executeQuery("select count(*) as items from TbAgentpayDetailsInfo where dkPcNo='" +tbAgentpayDetailsInfo.dkPcNo + "' and tradeFeedbackcode is not null")
                TbPcInfo tbPcInfo = TbPcInfo.get(tbAgentpayDetailsInfo.dkPcNo as Long)
            if (items.size() > 0) {
                if ((items.get(0) == tbPcInfo.tbPcItems)) {

                    tbPcInfo.tbPcCheckStatus = '2'
                    tbPcInfo.save(flush: true, failOnError: true)
                }
            }

         }
        } catch (Exception e) {
            e.printStackTrace()
            throw new RuntimeException("连接账务系统或清结算系统异常!")
        }



    }

    def anly(String strSendData) throws RuntimeException{

        String account = "";
        String accountName = "";
        String amount = "";
        String retCode = ""
        String reason = ""
        Document doc = DocumentHelper.parseText(strSendData);
        Element root = doc.getRootElement();
        List attrList = root.elements();
        Element bo = (Element) attrList.get(1);//body
        Element bo2 = (Element) attrList.get(0);//
        String reqSN = bo2.elementText("REQ_SN").substring(9);
        String mainRetCode = bo2.elementText("RET_CODE");
        System.out.println(reqSN);
        if (mainRetCode != null && mainRetCode.startsWith("0")) { //0开头表示已经是最终结果；1开头表示请求报文有错误或者我司系统解释报文出错（商户系统需要明确处理该）；2开头表示处于中间处理状态。3）3999在新渠道上线时可能出现的比较多，这个会在一段时间内逐步把错误信息归到3001-3058范围内。

            List aList = bo.elements();
            Element bo1 = (Element) aList.get(1);//RET_DETAILS
            for (int i = 0; i < bo1.elements().size(); i++) {

                Element item = (Element) bo1.elements().get(i);//RET_DETAIL
                account = item.elementText("ACCOUNT")
                accountName = item.elementText("ACCOUNT_NAME")
                amount = item.elementText("AMOUNT")
                retCode = item.elementText("RET_CODE")
                if (retCode.startsWith("3")) {
                    String con = p.getProperty(retCode);
                    reason = new String(con.getBytes("ISO-8859-1"), "gbk");
                }


                checkMoney(reqSN, account, accountName, amount, retCode, reason);
            }
        }

    }
}
