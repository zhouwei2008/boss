package dsf

import javax.servlet.http.HttpServletRequest

/**
 * Created by IntelliJ IDEA.
 * User: syw
 * Date: 12-7-9
 * Time: 下午2:20
 * To change this template use File | Settings | File Templates.
 */
class AgentDownloadForCSVService {

    OutputStream exportTradesForCSV(HttpServletRequest request,List tbAgentPayInfoList,int totalCount,BigDecimal totalMoney,BigDecimal totalFee,String tradeType){
          String templatePath
        FileInputStream is

            templatePath = request.getRealPath("/") + File.separator +
                    "templates-excel" + File.separator+"tbAgentPayInfoTemplate.xls"
            is = new FileInputStream(templatePath)
    }

}
