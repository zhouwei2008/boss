package boss

import groovyx.net.http.ContentType
import groovyx.net.http.HTTPBuilder
import org.codehaus.groovy.grails.commons.ConfigurationHolder
import static groovyx.net.http.ContentType.JSON
import static groovyx.net.http.Method.POST
import ebank.tools.MD5Tool
import ru.perm.kefir.asynchronousmail.AsynchronousMailJob
import org.springframework.validation.ObjectError
import grails.plugin.mail.MailMessageContentRenderer
import ru.perm.kefir.asynchronousmail.AsynchronousMailMessageBuilder
import ru.perm.kefir.asynchronousmail.AsynchronousMailMessage



class IsViewDateService {


    static transactional = true
    def grailsTemplateEngineService
    def serviceMethod() {

    }

    def sendEmail(String mailtemplate, String mailTitle, String target, model) throws Exception {
        def http = new HTTPBuilder(ConfigurationHolder.config.emis.serverUrl)

        String txt = grailsTemplateEngineService.renderView(mailtemplate, model)

        mailTitle = URLEncoder.encode(mailTitle, 'GBK')
        def args = [to: target, subject: mailTitle, body: URLEncoder.encode(txt, 'GBK'), charset: 'GBK']
        log.info args
        http.request(POST, JSON) {req ->
            requestContentType = ContentType.URLENC
            uri.path = "inAccess/email"
            body = args
            req.getParams().setParameter("http.connection.timeout", new Integer(60000));
            req.getParams().setParameter("http.socket.timeout", new Integer(60000));
            response.success = { resp, reader ->

                return reader
            }
            response.failure = { resp ->
                log.error resp.statusLine

                throw new Exception('request error')
            }
        }
    }


}
