// Place your Spring DSL code here
import org.apache.commons.dbcp.BasicDataSource
import org.codehaus.groovy.grails.commons.ConfigurationHolder

beans = {
    dataSource_ismp(BasicDataSource) { bean ->
        bean.destroyMethod = 'close'
        url=ConfigurationHolder.config.dataSource.ismp.url
        username=ConfigurationHolder.config.dataSource.ismp.username
        password=DESCodec.decode(ConfigurationHolder.config.dataSource.ismp.password)

        maxActive =ConfigurationHolder.config.dataSource.dbcp.maxActive
        maxIdle =ConfigurationHolder.config.dataSource.dbcp.maxIdle
        minIdle =ConfigurationHolder.config.dataSource.dbcp.minIdle
        initialSize =ConfigurationHolder.config.dataSource.dbcp.initialSize
        minEvictableIdleTimeMillis =ConfigurationHolder.config.dataSource.dbcp.minEvictableIdleTimeMillis
        timeBetweenEvictionRunsMillis =ConfigurationHolder.config.dataSource.dbcp.timeBetweenEvictionRunsMillis
        numTestsPerEvictionRun =ConfigurationHolder.config.dataSource.dbcp.numTestsPerEvictionRun
        testOnBorrow =true
        testWhileIdle =true
        testOnReturn =true
        validationQuery =ConfigurationHolder.config.dataSource.dbcp.validationQuery
        maxWait =ConfigurationHolder.config.dataSource.dbcp.maxWait
    }

    dataSource_account(BasicDataSource) { bean ->
        bean.destroyMethod = 'close'
        url=ConfigurationHolder.config.dataSource.account.url
        username=ConfigurationHolder.config.dataSource.account.username
        password=DESCodec.decode(ConfigurationHolder.config.dataSource.account.password)

        maxActive =ConfigurationHolder.config.dataSource.dbcp.maxActive
        maxIdle =ConfigurationHolder.config.dataSource.dbcp.maxIdle
        minIdle =ConfigurationHolder.config.dataSource.dbcp.minIdle
        initialSize =ConfigurationHolder.config.dataSource.dbcp.initialSize
        minEvictableIdleTimeMillis =ConfigurationHolder.config.dataSource.dbcp.minEvictableIdleTimeMillis
        timeBetweenEvictionRunsMillis =ConfigurationHolder.config.dataSource.dbcp.timeBetweenEvictionRunsMillis
        numTestsPerEvictionRun =ConfigurationHolder.config.dataSource.dbcp.numTestsPerEvictionRun
        testOnBorrow =true
        testWhileIdle =true
        testOnReturn =true
        validationQuery =ConfigurationHolder.config.dataSource.dbcp.validationQuery
        maxWait =ConfigurationHolder.config.dataSource.dbcp.maxWait
    }

    dataSource_boss(BasicDataSource) { bean ->
        bean.destroyMethod = 'close'
        url=ConfigurationHolder.config.dataSource.boss.url
        username=ConfigurationHolder.config.dataSource.boss.username
        password=DESCodec.decode(ConfigurationHolder.config.dataSource.boss.password)

        maxActive =ConfigurationHolder.config.dataSource.dbcp.maxActive
        maxIdle =ConfigurationHolder.config.dataSource.dbcp.maxIdle
        minIdle =ConfigurationHolder.config.dataSource.dbcp.minIdle
        initialSize =ConfigurationHolder.config.dataSource.dbcp.initialSize
        minEvictableIdleTimeMillis =ConfigurationHolder.config.dataSource.dbcp.minEvictableIdleTimeMillis
        timeBetweenEvictionRunsMillis =ConfigurationHolder.config.dataSource.dbcp.timeBetweenEvictionRunsMillis
        numTestsPerEvictionRun =ConfigurationHolder.config.dataSource.dbcp.numTestsPerEvictionRun
        testOnBorrow =true
        testWhileIdle =true
        testOnReturn =true
        validationQuery =ConfigurationHolder.config.dataSource.dbcp.validationQuery
        maxWait =ConfigurationHolder.config.dataSource.dbcp.maxWait
    }

    dataSource_dsf(BasicDataSource) { bean ->
        bean.destroyMethod = 'close'
        url=ConfigurationHolder.config.dataSource.dsf.url
        username=ConfigurationHolder.config.dataSource.dsf.username
        password=DESCodec.decode(ConfigurationHolder.config.dataSource.dsf.password)

        maxActive =ConfigurationHolder.config.dataSource.dbcp.maxActive
        maxIdle =ConfigurationHolder.config.dataSource.dbcp.maxIdle
        minIdle =ConfigurationHolder.config.dataSource.dbcp.minIdle
        initialSize =ConfigurationHolder.config.dataSource.dbcp.initialSize
        minEvictableIdleTimeMillis =ConfigurationHolder.config.dataSource.dbcp.minEvictableIdleTimeMillis
        timeBetweenEvictionRunsMillis =ConfigurationHolder.config.dataSource.dbcp.timeBetweenEvictionRunsMillis
        numTestsPerEvictionRun =ConfigurationHolder.config.dataSource.dbcp.numTestsPerEvictionRun
        testOnBorrow =true
        testWhileIdle =true
        testOnReturn =true
        validationQuery =ConfigurationHolder.config.dataSource.dbcp.validationQuery
        maxWait =ConfigurationHolder.config.dataSource.dbcp.maxWait
    }

     dataSource_pay(BasicDataSource) { bean ->
        bean.destroyMethod = 'close'
        url=ConfigurationHolder.config.dataSource.pay.url
        username=ConfigurationHolder.config.dataSource.pay.username
        password=DESCodec.decode(ConfigurationHolder.config.dataSource.pay.password)

        maxActive =ConfigurationHolder.config.dataSource.dbcp.maxActive
        maxIdle =ConfigurationHolder.config.dataSource.dbcp.maxIdle
        minIdle =ConfigurationHolder.config.dataSource.dbcp.minIdle
        initialSize =ConfigurationHolder.config.dataSource.dbcp.initialSize
        minEvictableIdleTimeMillis =ConfigurationHolder.config.dataSource.dbcp.minEvictableIdleTimeMillis
        timeBetweenEvictionRunsMillis =ConfigurationHolder.config.dataSource.dbcp.timeBetweenEvictionRunsMillis
        numTestsPerEvictionRun =ConfigurationHolder.config.dataSource.dbcp.numTestsPerEvictionRun
        testOnBorrow =true
        testWhileIdle =true
        testOnReturn =true
        validationQuery =ConfigurationHolder.config.dataSource.dbcp.validationQuery
        maxWait =ConfigurationHolder.config.dataSource.dbcp.maxWait
    }

     dataSource_settle(BasicDataSource) { bean ->
        bean.destroyMethod = 'close'
        url=ConfigurationHolder.config.dataSource.settle.url
        username=ConfigurationHolder.config.dataSource.settle.username
        password=DESCodec.decode(ConfigurationHolder.config.dataSource.settle.password)

        maxActive =ConfigurationHolder.config.dataSource.dbcp.maxActive
        maxIdle =ConfigurationHolder.config.dataSource.dbcp.maxIdle
        minIdle =ConfigurationHolder.config.dataSource.dbcp.minIdle
        initialSize =ConfigurationHolder.config.dataSource.dbcp.initialSize
        minEvictableIdleTimeMillis =ConfigurationHolder.config.dataSource.dbcp.minEvictableIdleTimeMillis
        timeBetweenEvictionRunsMillis =ConfigurationHolder.config.dataSource.dbcp.timeBetweenEvictionRunsMillis
        numTestsPerEvictionRun =ConfigurationHolder.config.dataSource.dbcp.numTestsPerEvictionRun
        testOnBorrow =true
        testWhileIdle =true
        testOnReturn =true
        validationQuery =ConfigurationHolder.config.dataSource.dbcp.validationQuery
        maxWait =ConfigurationHolder.config.dataSource.dbcp.maxWait
    }
}
