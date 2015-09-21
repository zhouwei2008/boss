package pay

import org.springframework.orm.hibernate3.HibernateTemplate
import com.burtbeckwith.grails.plugin.datasources.DatasourcesUtils
import org.hibernate.Session
import org.springframework.orm.hibernate3.HibernateCallback

class PtbLog {
    static mapping = {
        table 'TB_LOG'
        version false
        id generator: 'sequence', params: [sequence: 'SEQ_TB_LOG'], column:'ID'
    }

    String name
    String type
    String keyValue
    String jsonStr
    Date createTime
    String summary

    static constraints = {
    }

    static info(
            String name,
            String type,
            String keyValue,
            String jsonStr,
            String summary){
        PtbLog log = new PtbLog()
        log.name = name
        log.type = type
        log.keyValue = keyValue
        log.jsonStr = jsonStr
        log.createTime = new Date()
        log.summary = summary
        try {
            PtbLog.withTransaction {status ->
                try {
                    HibernateTemplate ht = DatasourcesUtils.newHibernateTemplate('pay')
                    ht.execute({ Session session ->
                      session.save(log)
                      session.flush()
                    } as HibernateCallback)
                } catch (Throwable e) {
                    return
                }
            }
        }catch(Throwable e){
            e.printStackTrace()
        }
    }
}
