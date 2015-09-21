package account

import java.applet.AppletContext
import org.apache.tomcat.util.net.SecureNioChannel.ApplicationBufferHandler
import org.codehaus.groovy.grails.commons.ConfigurationHolder
import org.springframework.context.ApplicationContext
import org.springframework.context.support.FileSystemXmlApplicationContext
/**
 * Created by IntelliJ IDEA.
 * User: zhwe2008
 * Date: 12-3-21
 * Time: 上午10:52
 * To change this template use File | Settings | File Templates.
 */
class groovyTest {
    public static void main(def args) {
        println "Hello World!"
        def var = 'Hello World'
        println var
        println var.class
        def s = """Hello
        World
        EveryOne
        """
        def st = "hello" + 'world' + "groovy"
        for (int i = 0; i < 5; i++) {
            println st
        }
        for (int i in 0..5) {
            println "this is ${i}:${st}"
        }
        def collect = ['a', 'b', 'c']
        collect.add('d')
        collect << 'come on'
        collect[1] = 100.0
        println collect[4]
        println collect[1]
        println collect[collect.size() - 1]
        println collect[-1]

        def msg = 'zhouwei'
        println msg.metaClass
        msg.metaClass.up = {delegate.toUpperCase()}
        println msg.up()
        msg.metaClass.methods.each {
            println '11111111' + it.name
        }
        msg.metaClass.properties.each {
            println '2222222222222' + it.name
        }
       def ctx= ApplicationContext.getResource('app-config.properties')
       File file=ctx.getFile()


        println 'ssssssssssssss' + ctx

    }

}
