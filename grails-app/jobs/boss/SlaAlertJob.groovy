package boss

import groovy.sql.Sql
import ismp.SlaEvents
import org.codehaus.groovy.grails.commons.ConfigurationHolder

class SlaAlertJob {

  def dataSource_ismp
  def asynchronousMailService

  static triggers = {
    //每小时执行一次
    cron name: 'slaAlertJob', cronExpression: "0 0 * * * ?"
  }

  def execute() {
    def events = SlaEvents.findAllByStatus('0')

    if (events.size() > 0) {
      asynchronousMailService.sendAsynchronousMail {
        to ConfigurationHolder.config.sla.alert.mailto.split(',')
        subject '在线支付风险报告'
        body(view: "/mail/slaEventMail", model: [result: events])
      }
      //update status to 1
      def sql = new Sql(dataSource_ismp)
      sql.executeUpdate('update sla_events set status=\'1\' where status=\'0\'')
      sql.close()
    }
  }
}
