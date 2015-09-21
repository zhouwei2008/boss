package boss

import groovy.sql.Sql
import ismp.CmCorporationInfo
import ismp.CmCustomerOperator
import ismp.CmPersonalInfo
import org.apache.commons.lang.StringUtils

class PermissionService {
    static transactional = true

    def adminID = "26"
    Map<String,Perm> permMap = [
            admin:null,
            bank:Perm.Bank,
            bankAccout:Perm.Bank_Issu,
            bankCharge:Perm.Bank_Charge,
            bankDraw:Perm.Bank_WithDraw,
            bankTransfer:Perm.Bank_Trans,
            customer:Perm.Cust,
            customerCor:Perm.Cust_Corp,
            customerPer:Perm.Cust_Per,
            settleCash:Perm.WithDraw_Wait,
            settleSearch:Perm.WithDraw_His,
            account:Perm.Account,
            accountSearch:Perm.Account_Acc,
            accountFlush:Perm.Account_Bill,
            gateway:Perm.Gworder,
            gatewaySearch:Perm.Gworder_Qry,
            gatewayPay:Perm.Gworder_Trans,
            transfer:Perm.Trade,
            transferSearch:Perm.Trade_Qry,
            transferRequest:Perm.Trade_RfdWait,
            sysReport:Perm.Report,
            sysReportBank:Perm.Report_BankDaily,
            sysReportCustomer:Perm.Report_CustDaily,
            sysReportFree:Perm.Report_FeeDaily,
            user:Perm.Security,
            userManager:Perm.Security_Op,
            userRole:Perm.Security_Role,
            //userPormission:Perm.,
            settle:Perm.WithDraw,
            accountAdjustApp:Perm.Account_TransChk,
            //transactionList:Perm.AgentPay_Trade,
            accountTreatmentList:Perm.Account_Acc,
            //feeSettList:Perm.AgentPay_Fee,
            accountAdjust:Perm.Account_Trans,
           // skfrtrial:Perm.AgCol_PreChk,
            //skteminal:Perm.AgCol_FinalChk,
            //skitemselect:Perm.AgCol_Trade,
           // skPcManage:Perm.AgCol_Batch,
            srvType:Perm.Settle_SrvType,
            srvTradeType:Perm.Settle_TradeType,
            feeSetting:Perm.Settle_Fee,
            footSetting:Perm.Settle_Cycle,
            preFoot:Perm.Settle_PreManualSettle,
            postFoot:Perm.Settle_PostManualSettle,
            preFootCheck:Perm.Settle_PreSettleChk,
            preFootHis:Perm.Settle_SettleHis,
            postFootCheck:Perm.Settle_PostSettleChk,
            postFootHis:Perm.Settle_PostSettleHis,
            merLogSearch:Perm.SysLog_Merc,
            bankVerify:Perm.Bank_TransChk,
            bankVerifyRecord:Perm.Bank_TransRec,
            settleApp:Perm.WithDraw_Chk,
            gatewayApp:Perm.Gworder_ExcpChk,
            gatewayAppSearch:Perm.Gworder_ExcpQry,
            gatewayUpLoad:Perm.Gworder_Sync,
            transferApp:Perm.Trade_RfdChk,
            transferAppSearch:Perm.Trade_RfdHis,
            slaEvents:Perm.Risk_Event,
            sysReportFault:Perm.Report_FailDaily,
            news:Perm.News,
            //dkteminal:Perm.AgPay_FinalChk,
            //dfpay:Perm.AgPay_PayChannel,
            //dspay:Perm.AgCol_ColChannel,
            //bindBank:Perm.AgCol_BankChannel,
            //checkAmount:Perm.AgPay_Sync,
            //dsCheck:Perm.AgCol_Sync,
            //reFcheck:Perm.AgPay_RfdPreChk,
            //reTcheck:Perm.AgPay_RfdFinalChk,
            //dkPcManage:Perm.AgPay_Batch,
            //dkfrtrial:Perm.AgPay_PreChk,
            //dkitemselect:Perm.AgPay_Trade,
            newsLogSearch:Perm.SysLog_Merc
    ];

    def transport = {
        def adminRole = BossRole.findByRoleName('admin')
        if (!adminRole) {
          adminRole = new BossRole(roleName:'admin')
          adminRole.save(failOnError:true,flush:true)
        }

        def rst = false;

        List<BoRole> oldRoleList = BoRole.list()
        if(oldRoleList == null){
            log.error("无角色数据！")
            return false
        }


        Map<String,BossRole> map = new HashMap<String,BossRole>(oldRoleList.size())
        def adminRoleList = []

        for(BoRole oldRole : oldRoleList){
            BossRole newRole = new BossRole()
            //newRole.dateCreated = new Date()
            newRole.roleName = oldRole.roleName

            def permStr = oldRole.permission_id
            if(StringUtils.isEmpty(permStr)){
            }else{
                if(permStr.split(',').any{it==adminID}){
                  adminRoleList.add(oldRole.roleCode)
                }else{
                    Set<RolePerm> set = new HashSet<RolePerm>()
                    String[] permStrArr = permStr.split(",")
                    for(String permIdStr : permStrArr){
                        BoPromission bp = BoPromission.get(permIdStr as long)
                        def perCode = bp.getPromissionCode()
                        // 特殊情况, 去掉了权限管理，同时再过滤一遍admin
                        if("userPormission" == perCode || "admin" == perCode){
                            continue
                        }
                        Perm perm = permMap.get(perCode)
                        if (!perm) {
                          println "========= perm code not found ${perCode}"

                        }
                        List<Perm> sonList = perm.allChildren
                        set.addAll(sonList)
                        List<Perm> fatherList = perm.allParencts
                        set.addAll(fatherList)
                    }
                    def rolePerms = []
                    set.each {
                       def rolePerm = new RolePerm(perm:it, role:newRole)
                       rolePerms.add(rolePerm)
                    }
                    newRole.rolePerms = rolePerms
                }
            }

            newRole = newRole.save(failOnError:true)
            if(null == newRole){
                log.error("角色保存异常！")
                return false
            }
            map.put(oldRole.roleCode, adminRoleList.contains(oldRole.roleCode) ? adminRole : newRole)
        }

        List<BoOperator> operatorList = BoOperator.list()
        if(operatorList == null){
            log.error("无操作员数据！")
            return false
        }
        for(BoOperator op : operatorList){
            def roleSet = op.getRoleSet()

            def role = map.get(roleSet)
            if(role){
                op.role = role
                if (!op.email) {op.email = 'null@hnair.com'}
                if (!op.lastChangeTime) {op.lastChangeTime = new Date()}
                if (!op.mobile) {op.mobile = 'null'}
                def saveOp = op.save(failOnError:true)
                if(null == saveOp){
                    log.error("${op.account} save role failed!");
                }
            }
        }
        true
    }
}