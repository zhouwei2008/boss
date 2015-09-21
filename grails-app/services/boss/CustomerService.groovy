package boss

import groovy.sql.Sql
import ismp.CmCorporationInfo
import ismp.CmCustomerOperator
import ismp.CmPersonalInfo
import ismp.CmApplicationInfo

class CustomerService {

  static transactional = true

  def accountClientService
  def operatorService

  def dataSource_ismp

  /**
   * 生成客户号，15位，左边1 + 0.... + 序号
   * @return 账号
   */
  def genCustNo() {
    def sql = new Sql(dataSource_ismp)
    def seq = sql.firstRow('select seq_cm_custno.NEXTVAL from DUAL')['NEXTVAL']
    def head = '1'
    def padNum = 15 - head.size()
    def custNo = head + seq.toString().padLeft(padNum, '0')
    //println "seq : ${seq}, dates : ${dates}, padNum : ${padNum}, accNo : ${accNo}"
    return custNo
  }

  def createCorporationInfo(corporationInfo, defaultEmail, appId) throws Exception {
    def opName
    if (corporationInfo instanceof CmCorporationInfo) {
      corporationInfo.type = 'C'
      opName = '管理员'
    } else if (corporationInfo instanceof CmPersonalInfo) {
      corporationInfo.type = 'P'
      opName = corporationInfo.name
    }
    corporationInfo.customerNo = genCustNo()
    corporationInfo.accountNo = 'null'

    if (corporationInfo.save()) {

      //保存管理员信息
      def operator = new CmCustomerOperator()
      operator.defaultEmail = defaultEmail.toLowerCase()
      operator.customer = corporationInfo
      operator.name = opName
      operator.loginFlag='1'
      operatorService.addOperator(corporationInfo, operator)

      //增加帐户信息
      def result = accountClientService.openAcc(corporationInfo.name, 'debit')
      if (result.result == 'true') {
        corporationInfo.accountNo = result.accountNo

          // 在线申请状态更新
          if (corporationInfo.save()) {
              if (appId) {
                  def cmApplicationInfo = CmApplicationInfo.get(appId)
                  cmApplicationInfo.status = '1'
                  cmApplicationInfo.save(flush: true)
              }
          } else {
              throw new RuntimeException("update application faile, error code:${result.errorCode}, ${result.errorMsg}")
          }
      } else {
        throw new RuntimeException("open account faile, error code:${result.errorCode}, ${result.errorMsg}")
      }

    } else {
      throw new RuntimeException("open account faile, field wrong")
    }
  }
}
