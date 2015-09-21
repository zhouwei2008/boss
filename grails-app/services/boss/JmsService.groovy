package boss

import org.apache.activemq.ActiveMQConnectionFactory
import javax.jms.Connection
import org.apache.activemq.ActiveMQConnection
import org.codehaus.groovy.grails.commons.ConfigurationHolder
import javax.jms.Session
import javax.jms.Queue
import javax.jms.DeliveryMode
import javax.jms.QueueRequestor
import javax.jms.MapMessage

class JmsService {

  static transactional = true

  static ActiveMQConnectionFactory connectionFactory = null
  static Connection connection = null
  static Session session = null;
  static Queue queue = null;

  static {
//    restartconn()
  }


  def static synchronized restartconn() {
    def flag = "s"
    try {
      connectionFactory = new ActiveMQConnectionFactory(ActiveMQConnection.DEFAULT_USER, ActiveMQConnection.DEFAULT_PASSWORD, ConfigurationHolder.config.jms.url.toString())
      connection = connectionFactory.createConnection()
      connection.start()
      session = connection.createSession(false, Session.AUTO_ACKNOWLEDGE)
      queue = session.createQueue('settle')
    } catch (Exception e) {
      e.printStackTrace()
      flag = "f"
    }
    return flag
  }

  def synchronized send(msg) {
    if (connection == null) {
      def flag = restartconn()
      if (flag == "f") {
        log.warn "结算系统暂连接不上!"
        throw new Exception("结算系统暂连接不上!")
      }
    }
    try {
      javax.jms.MessageProducer producer = session.createProducer(queue)
      producer.setDeliveryMode(DeliveryMode.PERSISTENT)
      producer.send(msg)
    } catch (Exception e) {
      connection.stop();
      connection = null;
      log.warn("send jms msg error.", e)
    }
  }

  def createMapMessage() {
    if (connection == null) {
      def flag = restartconn()
      if (flag == "f") {
        log.warn "结算系统暂连接不上!"
        throw new Exception("结算系统暂连接不上!")
      }
    }
    return session.createMapMessage()
  }
}
