package refund

import ismp.TradeBase
import ismp.TradeRefund

class AlipayService {

    static transactional = true
    def dataSource_ismp
    def partner = "2088402108162679"
    def key = "sowfs0am2six6bc2lo7b08fexsz8oxna"
    def sellerEmail = "wangxiao@trustair.com.cn"
    def serviceVal = "refund_fastpay_by_platform_pwd"
    def urlStr = org.codehaus.groovy.grails.commons.ConfigurationHolder.config.alipay.gateway
    def notifyUrl = org.codehaus.groovy.grails.commons.ConfigurationHolder.config.grails.mapiURL

    def alipayRefund(id){
          def ids = id.split(",")
          String retStr = "";
          String result = "";
          String acquirerSeq = "";
          String detailsData = "";
          String count = String.valueOf(ids.size());
          String batch_no = com.alipay.util.UtilDate.getOrderNum();
          for(int i=0; i<ids.size(); i++){
              def tradeRefundInstance = TradeBase.get(ids[i])
              def gwtrxs = searchGwtrxs(TradeBase.findByRootIdAndTradeType(tradeRefundInstance.rootId,"payment").tradeNo)
              if(gwtrxs.size()>0) acquirerSeq = gwtrxs.get(0).get("acquirer_seq");
              detailsData = detailsData + acquirerSeq+"^"+String.valueOf(tradeRefundInstance.amount/100)+"^协商退款#";

              def tradeRefund = TradeRefund.get(ids[i])
              tradeRefund.handleBatch=batch_no;
              tradeRefund.acquirerSeq = gwtrxs.get(0).get("acquirer_seq");
              println "======================="+batch_no
              tradeRefund.save(failOnError:true);
          }

          // notify_url 后台接收支付宝返回结果通知的 url
          String formValue = BuildForm(partner, sellerEmail,String.valueOf(notifyUrl).trim()+"bankRefund/refund/processRespResult",com.alipay.util.UtilDate.getDateFormatter(),batch_no,count,detailsData.substring(0,detailsData.length()-1),"utf-8",key,"MD5",String.valueOf(urlStr),serviceVal);

          println "alipay send content is "+ formValue
          return formValue;
    }

    /**
	 * 功能：构造表单提交HTML
	 * @param partner 合作身份者ID
	 * @param seller_email 签约支付宝账号或卖家支付宝帐户
	 * @param notify_url 交易过程中服务器通知的页面 要用 以http开格式的完整路径，不允许加?id=123这类自定义参数
	 * @param refund_date 退款当天日期，获取当天日期，格式：年[4位]-月[2位]-日[2位] 小时[2位 24小时制]:分[2位]:秒[2位]，如：2007-10-01 13:13:13
	 * @param batch_no 商家网站里的批次号，保证其唯一性，格式：当天日期[8位]+序列号[3至24位]，如：201008010000001
	 * @param batch_num 退款笔数，即参数detail_data的值中，“#”字符出现的数量加1，最大支持1000笔（即“#”字符出现的数量999个）
	 * @param detail_data 退款详细数据
	 * @param input_charset 字符编码格式 目前支持 GBK 或 utf-8
	 * @param key 安全校验码
	 * @param sign_type 签名方式 不需修改
	 * @return 表单提交HTML文本
	 */
    public String BuildForm(String partner,
			String seller_email,
			String notify_url,
			String refund_date,
			String batch_no,
			String batch_num,
			String detail_data,
            String input_charset,
            String key,
            String sign_type,
            String url,
            String service){
		Map sPara = new HashMap();
		sPara.put("_input_charset", input_charset);
		sPara.put("batch_no", batch_no);
		sPara.put("batch_num", batch_num);
		sPara.put("detail_data", detail_data);
		sPara.put("seller_email", seller_email);
		sPara.put("notify_url", notify_url);
		sPara.put("partner", partner);
		sPara.put("refund_date", refund_date);
		sPara.put("service",service);

		Map sParaNew = com.alipay.util.AlipayFunction.ParaFilter(sPara); //除去数组中的空值和签名参数
		String mysign = com.alipay.util.AlipayFunction.BuildMysign(sParaNew, key);//生成签名结果

		StringBuffer sbHtml = new StringBuffer();
		List keys = new ArrayList(sParaNew.keySet());
		String gateway = url;

		//GET方式传递
		sbHtml.append("<form id=\"alipaysubmit\" name=\"alipaysubmit\" action=\""+gateway.trim()+"?_input_charset=" + input_charset + "\" method=\"get\">");
		//POST方式传递（GET与POST二必选一）
		//sbHtml.append("<form id=\"alipaysubmit\" name=\"alipaysubmit\" action=\"" + gateway + "_input_charset=" + input_charset + "\" method=\"post\">");
		for (int i = 0; i < keys.size(); i++) {
			String name = (String) keys.get(i);
			String value = (String) sParaNew.get(name);
			sbHtml.append("<input type=\"hidden\" name=\"" + name + "\" value=\"" + value + "\"/>");
		}
        sbHtml.append("<input type=\"hidden\" name=\"sign\" value=\"" + mysign + "\"/>");
        sbHtml.append("<input type=\"hidden\" name=\"sign_type\" value=\"" + sign_type + "\"/>");

        //submit按钮控件请不要含有name属性
        sbHtml.append("<input type=\"submit\" value=\"支付宝确认付款\"></form>");
        sbHtml.append("<script>document.forms['alipaysubmit'].submit();</script>");
		return sbHtml.toString();
	}

    def searchGwtrxs(String id)
    {
        def dbIsmp =  new groovy.sql.Sql(dataSource_ismp)
        def trxsSql = """select t.id,
                            t.gworders_id,
                            t.trxnum,
                            t.trxtype,
                            t.channel,
                            t.payment_type,
                            t.paymode,
                            decode(t.amount, null, 0, t.amount) as amount,
                            t.currency,
                            t.servicecode,
                            t.acquirer_id,
                            t.acquirer_code,
                            t.acquirer_name,
                            t.acquirer_merchant,
                            t.acquirer_seq,
                            t.acquirer_date,
                            t.acquirer_msg,
                            t.submitdates,
                            t.payer_ip,
                            t.refnum,
                            t.authcode,
                            t.fromacctid,
                            t.fromacctnum,
                            t.buyer_id,
                            t.buyer_name,
                            t.payinfo,
                            t.createdate,
                            t.closedate,
                            t.trxsts,
                            t.opers,
                            t.operdate,
                            t.version,
                            t.trxdesc
                       from gwtrxs t
                       where t.gworders_id = '""" + id + """'"""

        def trxsList = dbIsmp.rows(trxsSql)
        return trxsList
    }
}
