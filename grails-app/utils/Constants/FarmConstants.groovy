package Constants
/**
 * Created by IntelliJ IDEA.
 * User: syw
 * Date: 11-5-30
 * Time: 下午2:43
 * To change this template use File | Settings | File Templates.
 */
class FarmConstants {

     static String ICBCcompactNo="BDP300076342"    // 打款平台工行协议编号

    static String ICBCUnionBankNo="40202"//付款行联行号
    static String CBBbatchCode="120000000"//天津建行一级分行号
    static String CBBdfCode="1100"
    static String MQ_ADDRESS="tcp://10.71.76.218:61616?wireFormat.maxInactivityDuration=0" //MQ链接地址
    // static String MQ_ADDRESS="tcp://10.68.76.61:61616?wireFormat.maxInactivityDuration=0" //TEST
//    static String merchartNo="606060081188240" //银联代付测试商户号
//    static String dsMerchartNo="808080081188240"
     static String merchartNo="606060560200198" //银联代付 正式商户号
    static String dsMerchartNo="808080560206045" //银联代收 正式商户号
   // static String haoEasyChinaPayMerNo ="000000000000351" //好易联测试商户号
    static String haoEasyChinaPayMerNof = "000191400101075"//好易联生产代付商户号
    static String haoEasyChinaPayMerNos = "000191400101076"//好易联生产代收商户号
    static String haoEasyUserNof = "DSF02400"
    static String haoEasyUserNos = "DSF02402"
    static String haoEasyUserPass = "123qwe"
    	//测试机公网地址 压缩
	private static final String SERVER_URL_COM = "http://10.71.76.218:18185/ISMSApp/HUnionPayTransfer/sendData"
   // private static final String SERVER_URL_COM = "http://59.41.103.98:222/PDS/ProcessServletCom" //好易联测试系统


	//不压缩
	private static final String SERVER_URL = "http://59.41.103.98:222/PDS/ProcessServlet"
    static String keysPath ="/home/test/payment/apps/BOSS/security/"
    // static String keysPath ="d://keys//"
}
