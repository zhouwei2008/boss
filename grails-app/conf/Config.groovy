// locations to search for config files that get merged into the main config
// config files can either be Java properties files or ConfigSlurper scripts

// grails.config.locations = [ "classpath:${appName}-config.properties",
//                             "classpath:${appName}-config.groovy",
//                             "file:${userHome}/.grails/${appName}-config.properties",
//                             "file:${userHome}/.grails/${appName}-config.groovy"]
def configFilePath = System.getenv('BOSS_CONFIG_LOCATION')?:"classpath:app-config.properties"
grails.config.locations = [ configFilePath] //属性（properties）文件的位置或者Grails将同主配置合并的额外配置文件
// if(System.properties["${appName}.config.location"]) {
//    grails.config.locations << "file:" + System.properties["${appName}.config.location"]
// }

grails.project.groupId = appName // change this to alter the default package name and Maven publishing destination
grails.mime.file.extensions = true // enables the parsing of file extensions from URLs into the request format
grails.mime.use.accept.header = false
grails.mime.types = [html: ['text/html', 'application/xhtml+xml'],
        xml: ['text/xml', 'application/xml'],
        text: 'text/plain',
        js: 'text/javascript',
        rss: 'application/rss+xml',
        atom: 'application/atom+xml',
        css: 'text/css',
        csv: 'text/csv',
        all: '*/*',
        json: ['application/json', 'text/json'],
        form: 'application/x-www-form-urlencoded',
        multipartForm: 'multipart/form-data'
]

// URL Mapping Cache Max Size, defaults to 5000
//grails.urlmapping.cache.maxsize = 1000

// The default codec used to encode data with ${}
grails.views.default.codec = "none" // none, html, base64
grails.views.gsp.encoding = "UTF-8"
grails.converters.encoding = "UTF-8"
// enable Sitemesh preprocessing of GSP pages
grails.views.gsp.sitemesh.preprocess = true
// scaffolding templates configuration
grails.scaffolding.templates.domainSuffix = 'Instance'

// Set to false to use the new Grails 1.2 JSONBuilder in the render method
grails.json.legacy.builder = false
// enabled native2ascii conversion of i18n properties files
grails.enable.native2ascii = true
// whether to install the java.util.logging bridge for sl4j. Disable for AppEngine!
grails.logging.jul.usebridge = true
// packages to include in Spring bean scanning
grails.spring.bean.packages = []

// request parameters to mask when logging exceptions
grails.exceptionresolver.params.exclude = ['password']

// set per-environment serverURL stem for creating absolute links
environments {
  production {
  }
  development {
  }
  test {
  }

}

// log4j configuration
log4j = {
  // Example of changing the log pattern for the default console
  // appender:
  //
  appenders {
    console name: 'stdout', layout: pattern(conversionPattern: '%c{2} %m%n')
  }

  appenders {
    appender new org.apache.log4j.DailyRollingFileAppender(name:"bossPayLog",layout:pattern(conversionPattern: '%d{yyyy-MM-dd HH:mm:ss,SSS} [%p] - %m%n'),
            fileName:"../logs/bossPayLogs/bossPayLog.log",datePattern:"'.'yyyy-MM-dd")
  }

  debug stdout: ['account', 'boss', 'gateway', 'ismp']

  error 'org.codehaus.groovy.grails.web.servlet',  //  controllers
          'org.codehaus.groovy.grails.web.pages', //  GSP
          'org.codehaus.groovy.grails.web.sitemesh', //  layouts
          'org.codehaus.groovy.grails.web.mapping.filter', // URL mapping
          'org.codehaus.groovy.grails.web.mapping', // URL mapping
          'org.codehaus.groovy.grails.commons', // core / classloading
          'org.codehaus.groovy.grails.plugins', // plugins
          'org.codehaus.groovy.grails.orm.hibernate', // hibernate integration
          'org.springframework',
          'org.hibernate',
          'net.sf.ehcache.hibernate'

  warn 'org.mortbay.log'

  root {
    info 'stdout'
    error 'bossPayLog'
    additivity = true
  }
}


grails {
  mail {
    props = ["mail.smtp.auth": "true",
            "mail.smtp.socketFactory.fallback": "false",
            "mail.smtp.starttls.enable": "false",
            "mail.debug": "true"]
  }
}
