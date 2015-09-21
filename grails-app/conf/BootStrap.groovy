import ismp.CmCustomer
import boss.*
import ismp.CmCustomerOperator
import account.AcAccount
import settle.FtTradeFee
import settle.FtSrvType
import settle.FtTrade
import settle.FtSrvTradeType
import settle.FtSrvFootSetting
import org.codehaus.groovy.grails.commons.ConfigurationHolder
import groovy.sql.Sql
import ismp.CmCorporationInfo

class BootStrap {

    /*def permissionService
  def accountClientService
    def reportAgentpayDailyService
    def reportOnlinePayService
    def reportRoyaltyService
    def reportAdjustService
    def reportOtherBizService
    def reportPortalService
    def reportAllServicesDailyService

    def dataSource_boss*/

    def init = { servletContext ->

        //删除无效的权限设置
        println "deleting unused rows from role_perm"
       /* def sql = new Sql(dataSource_boss)
        sql.eachRow('select distinct perm from role_perm') { row ->
          try {
            Perm.valueOf(row.PERM)
          } catch (IllegalArgumentException ie) {
            //delete row from db
            println "delete row from role_perm, perm=${row.PERM}"
            sql.executeUpdate("delete from role_perm where perm=${row.PERM}")
          } catch (Exception e) {
            //do nothing
          }
        }

        println 'start boot, upgrade = ' + ConfigurationHolder.config.sys.upgrade
*/
        //系统升级数据更新
       /* if (ConfigurationHolder.config.sys.upgrade == 'true') {
            println 'start upgrade'

//            println ConfigurationHolder.config.report.job.cron
            if (ConfigurationHolder.config.customer.update.flag == 'true') {
                           def sales = CmCorporationInfo.createCriteria().list{
                                isNotNull("belongToSale")
                            }
                            sales.each {sale->

                                if(sale.belongToSale==~/[0-9]+/){
                                    def operator =  BoOperator.get(sale.belongToSale as Long)
                                    if(operator&&operator?.name){
                                        sale.belongToSale = operator.name
                                    }
                                    if(!sale.save(flush:true,failOnError:true)){
                                     sale.errors.each {
                                         print it
                                     }
                                }
                             }
                           }
            }

            if (ConfigurationHolder.config.report.update.flag == 'true') {
                Thread.startDaemon {
                    def reportStartDateStr = ConfigurationHolder.config.report.update.startDate
                    def reportEndDateStr = ConfigurationHolder.config.report.update.endDate
                    def reportStartDate = reportStartDateStr ? Date.parse('yyyy-MM-dd', reportStartDateStr) : new Date() - 1
                    def  reportEndDate = reportEndDateStr ? Date.parse('yyyy-MM-dd', reportEndDateStr) : Date.parse('yyyy-MM-dd', "2011-01-01")
                    def  updateTables = ConfigurationHolder.config.report.update.table
                    println reportStartDate
                    println reportEndDate
                    println updateTables

                    while (reportStartDate >= reportEndDate) {
                        println "update report date = " + reportStartDate
                        def day = reportStartDate
                        if(updateTables){
                            updateTables.split(",").collect {
                                println it
                                switch (it.toString().toLowerCase()) {
                                    case ['agentpay']:
                                        println 'start reportAgentpayDailyService'
                                        reportAgentpayDailyService.integrate(day)
                                        println 'end reportAgentpayDailyService'
                                        break;
                                    case ['online']:
                                        println 'start reportOnlinePayService'
                                        reportOnlinePayService.report(day)
                                        println 'end reportOnlinePayService'
                                        break;
                                    case ['royalty']:
                                        println 'start reportRoyaltyService'
                                        reportRoyaltyService.report(day)
                                        println 'end reportRoyaltyService'
                                        break;
                                    case ['adjust']:
                                        println 'start reportAdjustService'
                                        reportAdjustService.getAdjustDailyReport(day)
                                        println 'end reportAdjustService'
                                        break;
                                    case ['otherbiz']:
                                        println 'start reportOtherBizService'
                                        reportOtherBizService.getOtherBizReport(day)
                                        println 'end reportOtherBizService'
                                        break;
                                    case ['portal']:
                                        println 'start reportPortalService'
                                        reportPortalService.getPortalDailyReport(day)
                                        println 'end reportPortalService'
                                        break;
                                }
                            }
                        }else{
                            println "all"
                            println 'start reportAgentpayDailyService'
                            reportAgentpayDailyService.integrate(day)
                            println 'end reportAgentpayDailyService'

                            println 'start reportOnlinePayService'
                            reportOnlinePayService.report(day)
                            println 'end reportOnlinePayService'

                            println 'start reportRoyaltyService'
                            reportRoyaltyService.report(day)
                            println 'end reportRoyaltyService'

                            println 'start reportAdjustService'
                            reportAdjustService.getAdjustDailyReport(day)
                            println 'end reportAdjustService'

                            println 'start reportOtherBizService'
                            reportOtherBizService.getOtherBizReport(day)
                            println 'end reportOtherBizService'

                            println 'start reportPortalService'
                            reportPortalService.getPortalDailyReport(day)
                            println 'end reportPortalService'
                        }
                        println 'start reportAllServicesDailyService'
                      reportAllServicesDailyService.integrate(day)
                        println 'end reportAllServicesDailyService'

                        reportStartDate--
                        Thread.sleep(1000)
                    }
                }
            }

            //更新服务和系统账户为可透支
            //      BoCustomerService.list().each {
            //        def srvAccNo = it.srvAccNo
            //        def feeAccNo = it.feeAccNo
            //
            //        def srvAcc = AcAccount.findByAccountNo(srvAccNo)
            //        def feeAcc = AcAccount.findByAccountNo(feeAccNo)
            //        println "srvAcc:${srvAcc},feeAcc:${feeAcc}"
            //        if (srvAcc) {
            //          srvAcc.overdraft = true
            //          srvAcc.save(failOnError: true)
            //        }
            //        if (feeAcc) {
            //          feeAcc.overdraft = true
            //          feeAcc.save(failOnError: true)
            //        }
            //
            //      }
            //
            //      BoInnerAccount.list().each {
            //        def acc = AcAccount.findByAccountNo(it.accountNo)
            //        if (acc) {
            //          acc.overdraft = true
            //          acc.save(failOnError: true)
            //        }
            //      }
            //      //更新原服务的手续费
            //      def srvLs = BoCustomerService.findAllByServiceCodeInList(['online', 'agentcoll'])
            //
            //      def srvOnline = FtSrvType.findBySrvCode('online')
            //      def tradePay = FtSrvTradeType.findBySrvAndTradeCode(srvOnline, 'payment')
            //      def tradeRefund = FtSrvTradeType.findBySrvAndTradeCode(srvOnline, 'refund')
            //
            //      def srvAgentColl = FtSrvType.findBySrvCode('agentcoll')
            //      def tradeCSucc = FtSrvTradeType.findBySrvAndTradeCode(srvAgentColl, 'coll_c_succ')
            //      def tradeCFail = FtSrvTradeType.findBySrvAndTradeCode(srvAgentColl, 'coll_c_fail')
            //      def tradeBSucc = FtSrvTradeType.findBySrvAndTradeCode(srvAgentColl, 'coll_b_succ')
            //      def tradeBFail = FtSrvTradeType.findBySrvAndTradeCode(srvAgentColl, 'coll_b_fail')
            //
            //      srvLs.each { srv ->
            //        if (srv.serviceCode == 'online') {
            //          def customer = CmCustomer.get(srv.customerId)
            //          def payFee = FtTradeFee.findWhere([customerNo: customer.customerNo, srv: srvOnline, tradeType: tradePay])
            //          def refFee = FtTradeFee.findWhere([customerNo: customer.customerNo, srv: srvOnline, tradeType: tradeRefund])
            //          if (!payFee) {
            //            payFee = new FtTradeFee(customerNo: customer.customerNo, srv: srvOnline, tradeType: tradePay, tradeWeight: 1, fetchType: 0, feeType: 1, feeValue: srv.feeParams.trim().toDouble())
            //            payFee.save(flush: true, failOnError: true)
            //          }
            //          if (!refFee) {
            //            refFee = new FtTradeFee(customerNo: customer.customerNo, srv: srvOnline, tradeType: tradeRefund, tradeWeight: 0, fetchType: 0, feeType: 1, feeValue: srv.feeParams.trim().toDouble())
            //            refFee.save(flush: true, failOnError: true)
            //          }
            //          def payFoot = FtSrvFootSetting.findWhere([customerNo: customer.customerNo, srv: srvOnline, tradeType: tradePay])
            //          def refFoot = FtSrvFootSetting.findWhere([customerNo: customer.customerNo, srv: srvOnline, tradeType: tradeRefund])
            //          if (!payFoot) {
            //            payFoot = new FtSrvFootSetting(customerNo: customer.customerNo, srv: srvOnline, tradeType: tradePay, footType: 0, mortDay: 0, footTimes: 0, footExpr: '1', footAmount: 0)
            //            payFoot.save(flush: true, failOnError: true)
            //          }
            //          if (!refFoot) {
            //            refFoot = new FtSrvFootSetting(customerNo: customer.customerNo, srv: srvOnline, tradeType: tradeRefund, footType: 0, mortDay: 0, footTimes: 0, footExpr: '1', footAmount: 0)
            //            refFoot.save(flush: true, failOnError: true)
            //          }
            //        } else if (srv.serviceCode == 'agentcoll') {
            //          def customer = CmCustomer.get(srv.customerId)
            //          def cSuccFee = FtTradeFee.findWhere([customerNo: customer.customerNo, srv: srvAgentColl, tradeType: tradeCSucc])
            //          def cFailFee = FtTradeFee.findWhere([customerNo: customer.customerNo, srv: srvAgentColl, tradeType: tradeCFail])
            //          def bSuccFee = FtTradeFee.findWhere([customerNo: customer.customerNo, srv: srvAgentColl, tradeType: tradeBSucc])
            //          def bFailFee = FtTradeFee.findWhere([customerNo: customer.customerNo, srv: srvAgentColl, tradeType: tradeBFail])
            //          if (!cSuccFee) {
            //            cSuccFee = new FtTradeFee(customerNo: customer.customerNo, srv: srvAgentColl, tradeType: tradeCSucc, tradeWeight: 1, fetchType: srv.settWay.toInteger(), feeType: 0, feeValue: srv.perprocedureFee)
            //            cSuccFee.save(flush: true, failOnError: true)
            //          }
            //          if (!cFailFee) {
            //            cFailFee = new FtTradeFee(customerNo: customer.customerNo, srv: srvAgentColl, tradeType: tradeCFail, tradeWeight: srv.backFee.toInteger(), fetchType: srv.settWay.toInteger(), feeType: 0, feeValue: srv.perprocedureFee)
            //            cFailFee.save(flush: true, failOnError: true)
            //          }
            //          if (!bSuccFee) {
            //            bSuccFee = new FtTradeFee(customerNo: customer.customerNo, srv: srvAgentColl, tradeType: tradeBSucc, tradeWeight: 1, fetchType: srv.settWay.toInteger(), feeType: 0, feeValue: srv.procedureFee)
            //            bSuccFee.save(flush: true, failOnError: true)
            //          }
            //          if (!bFailFee) {
            //            bFailFee = new FtTradeFee(customerNo: customer.customerNo, srv: srvAgentColl, tradeType: tradeBFail, tradeWeight: srv.backFee.toInteger(), fetchType: srv.settWay.toInteger(), feeType: 0, feeValue: srv.procedureFee)
            //            bFailFee.save(flush: true, failOnError: true)
            //          }
            //          def cSuccFoot = FtSrvFootSetting.findWhere([customerNo: customer.customerNo, srv: srvAgentColl, tradeType: tradeCSucc])
            //          def cFailFoot = FtSrvFootSetting.findWhere([customerNo: customer.customerNo, srv: srvAgentColl, tradeType: tradeCFail])
            //          def bSuccFoot = FtSrvFootSetting.findWhere([customerNo: customer.customerNo, srv: srvAgentColl, tradeType: tradeBSucc])
            //          def bFailFoot = FtSrvFootSetting.findWhere([customerNo: customer.customerNo, srv: srvAgentColl, tradeType: tradeBFail])
            //          if (!cSuccFoot) {
            //            cSuccFoot = new FtSrvFootSetting(customerNo: customer.customerNo, srv: srvAgentColl, tradeType: tradeCSucc, footType: 0, mortDay: 0, footTimes: 0, footExpr: '1', footAmount: 0)
            //            cSuccFoot.save(flush: true, failOnError: true)
            //          }
            //          if (!cFailFoot) {
            //            cFailFoot = new FtSrvFootSetting(customerNo: customer.customerNo, srv: srvAgentColl, tradeType: tradeCFail, footType: 0, mortDay: 0, footTimes: 0, footExpr: '1', footAmount: 0)
            //            cFailFoot.save(flush: true, failOnError: true)
            //          }
            //          if (!bSuccFoot) {
            //            bSuccFoot = new FtSrvFootSetting(customerNo: customer.customerNo, srv: srvAgentColl, tradeType: tradeBSucc, footType: 0, mortDay: 0, footTimes: 0, footExpr: '1', footAmount: 0)
            //            bSuccFoot.save(flush: true, failOnError: true)
            //          }
            //          if (!bFailFoot) {
            //            bFailFoot = new FtSrvFootSetting(customerNo: customer.customerNo, srv: srvAgentColl, tradeType: tradeBFail, footType: 0, mortDay: 0, footTimes: 0, footExpr: '1', footAmount: 0)
            //            bFailFoot.save(flush: true, failOnError: true)
            //          }
            //        }
            //      }


        }*/

//    BoCustomerService.list().each {
        //      if (!it.srvAccNo) {
        //        println "try to open account for ${it.contractNo}"
        //        try {
        //          def result = accountClientService.openAcc("客户${CmCustomer.get(it.customerId)?.name} ${BoCustomerService.serviceMap[it.serviceCode]}服务帐户".toString(), 'debit')
        //          if (result.result == 'true') {
        //            //更新帐户号
        //            it.srvAccNo = result.accountNo
        //            it.save()
        //          } else {
        //            println("开设服务帐户失败，error code:${result.errorCode}, ${result.errorMsg}")
        //          }
        //        } catch (Exception e) {
        //          e.printStackTrace()
        //          return
        //        }
        //      }
        //    }
        //     BoCustomerService.list().each {
        //       println "service ${it.feeAccNo}"
        //      if (!it.feeAccNo) {
        //        println "try to open account for ${it.contractNo}"
        //        try {
        //          def result = accountClientService.openAcc("客户${CmCustomer.get(it.customerId)?.name} ${BoCustomerService.serviceMap[it.serviceCode]}服务手续费帐户".toString(), 'credit')
        //          if (result.result == 'true') {
        //              //更新帐户号
        //              it.feeAccNo = result.accountNo
        //              it.save(failOnError:true)
        //          } else {
        //           throw new Exception("开设服务手续费帐户失败，error code:${result.errorCode}, ${result.errorMsg}")
        //          }
        //        } catch (Exception e) {
        //          e.printStackTrace()
        //          return
        //        }
        //      }
        //    }
        //      CmCustomerOperator.list().each {
        //        it.loginPassword = (it.id.toString() + '111111').encodeAsSHA1()
        //        println it.loginPassword
        //        try {
        //          it.roleSet='1'
        //          it.loginFlag = '0'
        //          it.save(failOnError:true,flush:true)
        //        } catch (Exception e) {
        //          e.printStackTrace()
        //        }
        //      }

        //    def x = 1
        //    def y = 1
        //    ThreadPoolExecutor threadPool = new ThreadPoolExecutor(5, 5, 300,
        //        TimeUnit.MILLISECONDS, new ArrayBlockingQueue<Runnable>(3),
        //        new ThreadPoolExecutor.CallerRunsPolicy());
        //    for (int i = 5; i < 23; i++) {
        //      x++
        //      y++
        //      def custNo = '1000000000000' + i.toString().padLeft(2, '0')
        //      println custNo
        //      def cu = CmCustomer.findByCustomerNo(custNo)
        //      def accNo = cu.accountNo
        //      def bankAcc = '4550000000000038'
        //      println "${accNo},${bankAcc}"
        //      for (int j = 0; j < 12000; j++) {
        //
        //        threadPool.execute({
        //
        //          def cmdls = accountClientService.buildTransfer(null, bankAcc, accNo, 1, 'charge', "${x.toString().padLeft(10, '0')}".toString(), "${y.toString().padLeft(12, '0')}".toString(), '')
        //          accountClientService.batchCommand(UUID.randomUUID().toString().replaceAll('-', ''), cmdls)
        //
        //        } as Runnable)
        //
        //      }
        //    }

        //initial banks
     /*   if (BoBankDic.count() == 0) {
            new BoBankDic(code: 'boc', name: '中国银行').save()
            new BoBankDic(code: 'icbc', name: '中国工商银行').save()
            new BoBankDic(code: 'cmb', name: '招商银行').save()
            new BoBankDic(code: 'ccb', name: '中国建设银行').save()
            new BoBankDic(code: 'abc', name: '中国农业银行').save()
            new BoBankDic(code: 'unionpay', name: '中国银联').save()
            new BoBankDic(code: 'CEB', name: '中国光大银行').save()
        }*/
//    if (!BoRole.findByRoleCode('admin')) {
        //      if (!BoPromission.findByPromissionCode('admin')) {
        //        new BoPromission(promissionName: 'admin', promissionCode: 'admin', status: '1').save(flush: true, failOnError: true)
        //      }
        //      new BoRole(roleName: '管理员', roleCode: 'admin', status: 1, permission_id: BoPromission.findByPromissionCode('admin').id.toString()).save(failOnError: true)
        //    }
        //    if (BoInnerAccount.count() == 0) {
        //      def acc1 = accountClientService.openAcc('支出中间账户', 'debit')
        //      if (acc1.result == 'true') {
        //        new BoInnerAccount(key: 'middleAcc', accountNo: acc1.accountNo, note: '支出中间账户').save()
        //      } else {
        //        throw new Exception("add middle middleAc faile, error code : ${acc1.errorCode}, errorMsg : ${acc1.errorMsg}")
        //      }
        //      def acc2 = accountClientService.openAcc('平台收费账户', 'debit')
        //      if (acc2.result == 'true') {
        //        new BoInnerAccount(key: 'feeAcc', accountNo: acc2.accountNo, note: '平台收费账户').save()
        //      } else {
        //        throw new Exception("add middle feeAcc faile, error code : ${acc2.errorCode}, errorMsg : ${acc2.errorMsg}")
        //      }
        //      def acc3 = accountClientService.openAcc('访客公用账户', 'debit')
        //      if (acc3.result == 'true') {
        //        new BoInnerAccount(key: 'guestAcc', accountNo: acc3.accountNo, note: '访客公用账户').save()
        //      } else {
        //        throw new Exception("add middle guestAcc faile, error code : ${acc3.errorCode}, errorMsg : ${acc3.errorMsg}")
        //      }
        //    }
        //    if (BoInnerAccount.countByKey('adjBalCharge') == 0) {
        //      def acc = accountClientService.openAcc('银行调帐充值账户', 'debit')
        //      if (acc.result == 'true') {
        //        new BoInnerAccount(key: 'adjBalCharge', accountNo: acc.accountNo, note: '银行调帐充值账户').save()
        //      } else {
        //        throw new Exception("add middle adjBalCharge faile, error code : ${acc.errorCode}, errorMsg : ${acc.errorMsg}")
        //      }
        //    }
        //    if (BoInnerAccount.countByKey('adjBalWithDraw') == 0) {
        //      def acc = accountClientService.openAcc('银行调帐提款账户', 'credit')
        //      if (acc.result == 'true') {
        //        new BoInnerAccount(key: 'adjBalWithDraw', accountNo: acc.accountNo, note: '银行调帐提款账户').save()
        //      } else {
        //        throw new Exception("add middle adjBalWithDraw faile, error code : ${acc.errorCode}, errorMsg : ${acc.errorMsg}")
        //      }
        //    }
        //    if (BoInnerAccount.countByKey('feeInAdvance') == 0) {
        //      def acc = accountClientService.openAcc('系统应收手续费账户', 'debit')
        //      if (acc.result == 'true') {
        //        new BoInnerAccount(key: 'feeInAdvance', accountNo: acc.accountNo, note: '系统应收手续费账户').save()
        //      } else {
        //        throw new Exception("add middle feeInAdvance faile, error code : ${acc.errorCode}, errorMsg : ${acc.errorMsg}")
        //      }
        //    }
        //

        /*  if (BoInnerAccount.countByKey('chargefeeAcc') == 0) {
              def acc = accountClientService.openAcc('个人手续费账户', 'debit')
              if (acc.result == 'true') {
                new BoInnerAccount(key: 'chargefeeAcc', accountNo: acc.accountNo, note: '个人手续费账户').save()
              } else {
                throw new Exception("add middle feeInAdvance faile, error code : ${acc.errorCode}, errorMsg : ${acc.errorMsg}")
              }
            }

        if (BossRole.count() == 0) {
            println 'upgrade roles'
            permissionService.transport()
        }

        if (!BossRole.findByRoleName('admin')) {
            new BossRole(roleName: 'admin').save(failOnError: true, flush: true)
        }
        if (!BoOperator.findByAccount('admin')) {
            new BoOperator(account: 'admin', password: 'admin'.encodeAsSHA1(), name: '管理员', roleSet: 'admin', role: BossRole.findByRoleName('admin')).save(failOnError: true)
        }*/
//    if (BoOperator.count() == 0) {
        //      new BoOperator(account: 'admin', password: 'admin'.encodeAsSHA1(), name: '管理员', roleSet: 'admin').save(failOnError: true)
        //      if (BoRole.count() == 0) {
        //        def adminPerm = BoPromission.findByPromissionCode('admin')
        //        if (!adminPerm) {
        //          adminPerm = new BoPromission(promissionName: 'admin', promissionCode: 'admin', status: '1')
        //          adminPerm.save(failOnError: true)
        //        }
        //        new BoRole(roleName: 'admin', roleCode: 'admin', status: 1, permission_id: adminPerm.id.toString()).save(failOnError: true)
        //      }
        //    }
        //
    }

    def destroy = {
    }
}
