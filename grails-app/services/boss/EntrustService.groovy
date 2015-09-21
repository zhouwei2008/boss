package boss
import groovyx.net.http.HTTPBuilder
import org.codehaus.groovy.grails.commons.ConfigurationHolder
import static groovyx.net.http.ContentType.JSON
import static groovyx.net.http.Method.POST
class EntrustService {
   static transactional = true

  def http = new HTTPBuilder(ConfigurationHolder.config.entrust.serverUrl)

    /**
   * 委托结算BOSS审核订单接口调用
   * @param orders 订单号集合,必须参数
   * @param srvType 待审核业务类型，S 代收 F代付  必须参数
   * @param procCmd 审核命令：pass 通过 refuse 拒绝  必须参数 auditor
   * @param auditor 审核人  必须参数
   * @return {result: 'true or false', errorMsg: ''}
   * result: true为成功， false 为失败,
   * errorMsg: 当result为false时，返回误原因,
   * @throws Exception
   */
  def opensysverify(orders,srvType,procCmd,auditor) throws Exception {
    http.request(POST, JSON) { req ->
      uri.path = 'enTrust/sysverify'
      body = [orders:orders,srvType:srvType,procCmd:procCmd,auditor:auditor]
      response.success = { resp, json ->
        return json
      }
      response.failure = { resp ->
        throw new Exception('连接不到委托结算系统')
      }
    }
  }

  /**
   * 委托结算BOSS退款终审接口调用
   * @param orders 订单号集合,必须参数
   * @param auditor 审核人  必须参数
   * @return {result: 'true or false', errorMsg: ''}
   * result: true为成功， false 为失败,
   * errorMsg: 当result为false时，返回误原因,
   * @throws Exception
   */
  def refuseCheckForEntrust(orders,auditor) throws Exception {
    http.request(POST, JSON) { req ->
      uri.path = 'enTrust/refuseCheck'
      body = [orders:orders,auditor:auditor]
      response.success = { resp, json ->
        return json
      }
      response.failure = { resp ->
        throw new Exception('连接不到委托结算系统')
      }
    }
  }
}
