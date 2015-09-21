import org.codehaus.groovy.grails.commons.ConfigurationHolder
import boss.ReportAgentpayDailyService

datasources = {
  datasource(name: 'ismp') {
    domainClasses([
        gateway.GwOrder,
        gateway.GwSubOrders,
        gateway.Gwgoods,
        gateway.Gwlgoptions,
        gateway.Gwlogistic,
        gateway.GwTransaction,
        ismp.CmCorporationInfo,
        ismp.CmCustomer,
        ismp.CmCustomer4Query,
        ismp.CmCustomerBankAccount,
        ismp.CmCustomerOperator,
        ismp.CmLoginCertificate,
        ismp.CmLoginLog,
        ismp.CmPersonalInfo,
        ismp.CmDynamicKey,
        ismp.CmSeqCustno,
        ismp.CmOpRelation,
        ismp.CmOpLog,
        ismp.CmCustomerAccountMapping,
        ismp.TradeBase,
        ismp.TradeBase4Query,
        ismp.TradeRefund,
        ismp.TradeWithdrawn,
        ismp.TradeCharge,
        ismp.TradeFrozen,
        ismp.TradePayment,
        ismp.TradeTransfer,
        ismp.TradeUnfrozen,
        ismp.TradeAccountCommandSaf,
        ismp.SlaEvents,
        ismp.SlaEventtype,
        ismp.AcquireFaultTrx,
        ismp.MapiAsyncNotify,
        ismp.AcquireSynTrx,
        ismp.AcquireSynResult,
        ismp.AcquireSynResult ,
        ismp.RefundDetail,
        ismp.RefundBatch,
        ismp.RefundAuth,
        ismp.TradeRefundBatch,
        ismp.NotifyFailWatcher,
        ismp.WithdrawnBatch,
        ismp.TradeWithdrawnFailDetail,
        ismp.CmCustomerChannel,
        ismp.CmApplicationInfo,
        ismp.TbRiskControl,
        ismp.TbRiskList,
        ismp.TbRiskNotifier,
        ismp.TbCustomerBlackList,
        ismp.TbPersonBlackList,
        ismp.MobileOrder
    ])
    driverClassName('oracle.jdbc.OracleDriver')
    url(ConfigurationHolder.config.dataSource.ismp.url)
    username(ConfigurationHolder.config.dataSource.ismp.username)
    password(DESCodec.decode(ConfigurationHolder.config.dataSource.ismp.password))
    println "ismp:"+DESCodec.decode(ConfigurationHolder.config.dataSource.ismp.password)
    dbCreate(ConfigurationHolder.config.dataSource.ismp.dbCreate)
    pooled(true)
    logSql(false)
    dialect(org.hibernate.dialect.Oracle10gDialect)
    hibernate {
      cache {
        use_second_level_cache(false)
        use_query_cache(false)
        provider_class('net.sf.ehcache.hibernate.EhCacheProvider')
      }
    }
  }

  datasource(name: 'account') {
    domainClasses([account.AcAccount,
        account.AcDailReport,
        account.AcSequential,
        account.AcTransaction
    ])
    driverClassName('oracle.jdbc.OracleDriver')
    url(ConfigurationHolder.config.dataSource.account.url)
    username(ConfigurationHolder.config.dataSource.account.username)
    password(DESCodec.decode(ConfigurationHolder.config.dataSource.account.password))
      println "account:"+DESCodec.decode(ConfigurationHolder.config.dataSource.account.password)
    dbCreate(ConfigurationHolder.config.dataSource.account.dbCreate)
    pooled(true)
    logSql(false)
    dialect(org.hibernate.dialect.Oracle10gDialect)
    hibernate {
      cache {
        use_second_level_cache(false)
        use_query_cache(false)
        provider_class('net.sf.ehcache.hibernate.EhCacheProvider')
      }
    }
  }

  datasource(name: 'boss') {
    domainClasses([
        boss.BoBankDic,
        boss.BoAcquirerAccount,
        boss.BoMerchant,
        boss.BoInnerAccount,
        boss.BoOperator,
        boss.BoCustomerService,
        boss.BoAgentPayServiceParams,
        boss.BoRole,
        boss.BoPromission,
        boss.BoNews,
        boss.BoPaySrvBank,
        boss.BoVerify,
        boss.AppNote,
        boss.BoAccountAdjustInfo,
        boss.BoRefundModel,
        boss.BoOpLog,
        boss.BossRole,
        boss.RolePerm,
        boss.BoOpRelation,
        boss.BoBalanceAccountDateRule,
        boss.BoCustomerWithdrawCycle,
        boss.BoCustomerWithdrawSetting,
        boss.BoAdjustType,
        boss.BoChannelRate,
        boss.BoRechargeTime,
        boss.BoOfflineCharge,
        boss.BoBranchCompany,
        boss.BoDirectPayBind,
        boss.ReportAgentpayDaily,
        boss.ReportAllServicesDaily,
        boss.ReportOnlinePayDaily,
        boss.ReportRoyaltyDaily,
        boss.BoBranchCompany,
        boss.ReportPortalDaily,
        boss.ReportOtherBizDaily,
        boss.ReportAdjustDaily,
        boss.BoSecurityEvents,
        boss.BoAssets,
        boss.BoDynamicKey,
        boss.BossLoginLog
    ])
    driverClassName('oracle.jdbc.OracleDriver')
    url(ConfigurationHolder.config.dataSource.boss.url)
    username(ConfigurationHolder.config.dataSource.boss.username)
    password(DESCodec.decode(ConfigurationHolder.config.dataSource.boss.password))
    println "boss:"+DESCodec.decode(ConfigurationHolder.config.dataSource.boss.password)
    dbCreate(ConfigurationHolder.config.dataSource.boss.dbCreate)
    pooled(true)
    logSql(false)
    dialect(org.hibernate.dialect.Oracle10gDialect)
    hibernate {
      cache {
        use_second_level_cache(false)
        use_query_cache(false)
        provider_class('net.sf.ehcache.hibernate.EhCacheProvider')
      }
    }
  }

  datasource(name: 'dsf') {
    domainClasses([
        dsf.TbAgentpayDetailsInfo,
        dsf.TbBindBank,
        dsf.TbPcInfo,
        dsf.TbAgentpayInfo,
        dsf.TbAdjustBank,
        dsf.TbDetailIds,
        dsf.TbAdjustBankCard,
        dsf.TbEntrustPerm,
        dsf.TbErrorLog
    ])
    driverClassName('oracle.jdbc.OracleDriver')
    url(ConfigurationHolder.config.dataSource.dsf.url)
    username(ConfigurationHolder.config.dataSource.dsf.username)
    password(DESCodec.decode(ConfigurationHolder.config.dataSource.dsf.password))
    println "dsf:"+DESCodec.decode(ConfigurationHolder.config.dataSource.dsf.password)
    dbCreate(ConfigurationHolder.config.dataSource.dsf.dbCreate)
    pooled(true)
    logSql(false)
    dialect(org.hibernate.dialect.Oracle10gDialect)
    hibernate {
      cache {
        use_second_level_cache(false)
        use_query_cache(false)
        provider_class('net.sf.ehcache.hibernate.EhCacheProvider')
      }
    }
  }


  datasource(name: 'pay') {
    domainClasses([
        pay.PtbBindBank,
        pay.PtbPayTradeType,
        pay.PtbPayTrade,
        pay.PtbPayBatch,
        pay.PtbAdjustBank,
        pay.PtbLog
    ])
    driverClassName('oracle.jdbc.OracleDriver')
    url(ConfigurationHolder.config.dataSource.pay.url)
    username(ConfigurationHolder.config.dataSource.pay.username)
    password(DESCodec.decode(ConfigurationHolder.config.dataSource.pay.password))
    println "pay:"+DESCodec.decode(ConfigurationHolder.config.dataSource.pay.password)
    dbCreate(ConfigurationHolder.config.dataSource.pay.dbCreate)
    pooled(true)
    logSql(false)
    dialect(org.hibernate.dialect.Oracle10gDialect)
    hibernate {
      cache {
        use_second_level_cache(false)
        use_query_cache(false)
        provider_class('net.sf.ehcache.hibernate.EhCacheProvider')
      }
    }
  }

  datasource(name: 'settle') {
    domainClasses([
        settle.FtFoot,
        settle.FtLiquidate,
        settle.FtSrvFootSetting,
        settle.FtSrvTradeType,
        settle.FtSrvType,
        settle.FtTrade,
        settle.FtTradeFee,
        settle.FtFeeChannel,
        settle.FtTradeFeeStep
    ])
    driverClassName('oracle.jdbc.OracleDriver')
    url(ConfigurationHolder.config.dataSource.settle.url)
    username(ConfigurationHolder.config.dataSource.settle.username)
    password(DESCodec.decode(ConfigurationHolder.config.dataSource.settle.password))
    println "settle:"+DESCodec.decode(ConfigurationHolder.config.dataSource.settle.password)
    dbCreate(ConfigurationHolder.config.dataSource.settle.dbCreate)
    pooled(true)
    logSql(false)
    dialect(org.hibernate.dialect.Oracle10gDialect)
    hibernate {
      cache {
        use_second_level_cache(false)
        use_query_cache(false)
        provider_class('net.sf.ehcache.hibernate.EhCacheProvider')
      }
    }
  }

}
