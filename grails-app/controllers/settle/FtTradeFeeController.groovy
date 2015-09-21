package settle

import ismp.CmCustomer
import java.text.DateFormat
import java.text.SimpleDateFormat
import java.text.DecimalFormat
import groovy.sql.Sql

class FtTradeFeeController {

    static allowedMethods = [save: "POST", update: "POST", delete: "POST"]
    def dataSource_settle
    def FtTradeFeeService

    def index = {
        redirect(action: "list", params: params)
    }

    def list = {

        params.sort = params.sort ? params.sort : "id"
        params.order = params.order ? params.order : "desc"
        params.max = Math.min(params.max ? params.int('max') : 10, 100)
        params.offset = params.offset ? params.int('offset') : 0
        def customerNo = params.customerNo
//      def srvId = params.srvId
        def srvName = params.srvName
        def ftSrvType = FtSrvType.findBySrvName(srvName)
        def ftTradeFee = FtTradeFee.findAllByCustomerNoAndSrv(customerNo, ftSrvType)
        def customerName = params.customerName
//        def srvCode = ftSrvType?.srvCode
//        if (params.srvType != null && params.srvType != '') {
//            srvCode = params.srvType
//        }
        [ftTradeFeeList: ftTradeFee, ftTradeFeeTotal: ftTradeFee.size(), params: params, srvName: srvName, customerName: customerName, customerNo: customerNo, srvId: ftSrvType?.id]
//  def query = """ select t2.srv_code ,
//       t2.srv_name ,
//       t2.trade_name,t2.tradeid,t2.SRVID,
//       decode(t1.fetch_type, 0, '即收', '1', '后返', '未设置') fetch_type_s,
//       t1.fetch_type,
//       decode(t1.fee_type, 0, '按笔收', '1', '按比率收', '未设置') fee_type_s,
//         t1.fee_type,
//       t1.fee_value fee_value,
//       t1.trade_weight
//  from ft_trade_fee t1
// right join (select a1.*,a2.trade_name,a2.id tradeid,a1.id srvid  from   ft_srv_type a1,ft_srv_trade_type a2
//where  1=1 and a1.id=a2.srv_id  ) t2
//on t1.customer_no = '$customerNo' and t1.srv_id=t2.srvid and t1.trade_type_id=t2.tradeid  where 1=1 """
//
//          def query_total = """select count(*) total from ( select t2.srv_code ,
//       t2.srv_name ,
//       t2.trade_name,
//       decode(t1.fetch_type, 0, '即收', '1', '后返', '未设置') fetch_type,
//       decode(t1.fee_type, 0, '按笔收', '1', '按比率收', '未设置') fee_type,
//       t1.fee_value fee_value,
//       t1.trade_weight
//  from ft_trade_fee t1
// right join (select a1.*,a2.trade_name,a2.id tradeid,a1.id srvid from   ft_srv_type a1,ft_srv_trade_type a2
//where  1=1 and a1.id=a2.srv_id  ) t2
//on t1.customer_no = '$customerNo' and t1.srv_id=t2.srvid and t1.trade_type_id=t2.tradeid  where 1=1 """
//        if (params.srvcode != null && params.srvcode != '') {
//            def srvcode=params.srvcode
//            query+=" and t2.srv_code='$srvcode'  "
//            query_total+=" and t2.srv_code='$srvcode') t"
//        }
//        else
//        {
//            query_total+=" ) t "
//        }
//
//        println query
//         def sql = new Sql(dataSource_settle)
//         def total = sql.firstRow(query_total).total
//         HibernateTemplate ht = DatasourcesUtils.newHibernateTemplate('settle')
//      def results = ht.executeFind({ Session session ->
//      def sqlquery = session.createSQLQuery(query.toString())
//      sqlquery.setResultTransformer(AliasToEntityMapResultTransformer.INSTANCE)
//
//      return sqlquery.setFirstResult(params.offset).setMaxResults(params.max).list();
//    } as HibernateCallback)
//
//          def bTypeList = FtSrvType.list()
//          println bTypeList
//    [ftTradeFeeList: results, ftTradeFeeTotal: total, params: params,customerNo:customerNo,customerName:name, bTypeList: bTypeList]
    }

    def create = {
        def ftTradeFeeInstance = new FtTradeFeeStep()
        ftTradeFeeInstance.properties = params
        def srvName = params.srvName
        def customerName = params.customerName
        def customerNo = params.customerNo
        def srvId = params.srvId
        return [ftTradeFeeInstance: ftTradeFeeInstance, srvName: srvName, customerName: customerName, customerNo: customerNo, srvId: srvId]
    }

    def save = {
        def customerNo = params.customerNo
        def customerName = params.customerName
        def srvName = params.srvName
        def srvId = params.srvId
        def ftTradeFee
        def srv = FtSrvType.findBySrvName(srvName)
        def ftTradeFeeInstance = new FtTradeFeeStep(params)
        ftTradeFeeInstance.srv = srv
        def tradeType = FtSrvTradeType.get(params.tradeType1)
        ftTradeFeeInstance.tradeType = tradeType
        //同一客户，同一服务类型、交易类型、费率通道的有效日期不能重叠
        if (params.channelCode != null && params.channelCode != '') {
            ftTradeFee = FtTradeFee.findAllWhere(customerNo: customerNo, srv: srv, tradeType: tradeType, channelCode: params.channelCode)
        } else {
            ftTradeFee = FtTradeFee.findAll("from FtTradeFee where customerNo=:customerNo and srv=:srvId and tradeType=:tradeTypeId and channelCode is null ", [customerNo: customerNo, srvId: srv, tradeTypeId: tradeType])
        }
        DateFormat dateFormat = new SimpleDateFormat('yyyy-MM-dd')
        def dateBegin
        def dateEnd
        def flag = '0'//用于判断有效日期是否连续
        def maxDateEnd
        def maxDateBegin
        if (ftTradeFee.size() > 0) {
            ftTradeFee.each {
                dateBegin = dateFormat.format(it.dateBegin)
                dateEnd = dateFormat.format(it.dateEnd)
                if (params.dateBegin1 >= dateBegin && params.dateBegin1 <= dateEnd) {
                    flash.message = "有效日期区间不能重叠！请重新添加"
                }
                if (params.dateEnd1 >= dateBegin && params.dateEnd1 <= dateEnd) {
                    flash.message = "有效日期区间不能重叠！请重新添加"
                }
                if (params.dateBegin1 <= dateBegin && params.dateEnd1 >= dateEnd) {
                    flash.message = "有效日期区间不能重叠！请重新添加"
                }
                if (dateEnd > maxDateEnd) {
                    maxDateEnd = dateEnd
                    maxDateBegin = dateBegin
                    if (Date.parse('yyyy-MM-dd', maxDateEnd) + 1 == Date.parse('yyyy-MM-dd', params.dateBegin1)) {
                        flag = '1'
                    }
                }
            }
        }
        if (customerNo != null && customerNo != '') {
            ftTradeFeeInstance.customerNo = customerNo
        }
        if (params.feeMax != null && params.feeMax != '') {
            ftTradeFeeInstance.feeMax = params.feeMax as Double
        } else {
            ftTradeFeeInstance.feeMax = 0.0
        }
        if (params.feeMin != null && params.feeMin != '') {
            ftTradeFeeInstance.feeMin = params.feeMin as Double
        } else {
            ftTradeFeeInstance.feeMin = 0.0
        }
        if (params.feeType != null && params.feeType != '') {
            ftTradeFeeInstance.feeType = params.feeType as Integer

        } else {
            ftTradeFeeInstance.feeType = -1
        }
        if (params.feeValue != null && params.feeValue != '') {
            ftTradeFeeInstance.feeValue = params.feeValue as Double
        } else if (params.feeValue12 != null && params.feeValue12 != '') {
            ftTradeFeeInstance.feeValue = params.feeValue12 as Double
        } else if (params.feeValue13 != null && params.feeValue13 != '') {
            ftTradeFeeInstance.feeValue = params.feeValue13 as Double
        } else {
            ftTradeFeeInstance.feeValue = 0.0
        }
        if (params.packLen != null && params.packLen != '') {
            ftTradeFeeInstance.packLen = params.packLen as Integer
        } else if (params.packLen11 != null && params.packLen11 != '') {
            ftTradeFeeInstance.packLen = params.packLen11 as Integer
        } else {
            ftTradeFeeInstance.packLen = 0
        }
        if (params.packType != null && params.packType != '') {
            ftTradeFeeInstance.packType = params.packType as Integer
        } else if (params.packType11 != null && params.packType11 != '') {
            ftTradeFeeInstance.packType = params.packType11 as Integer
        } else {
            ftTradeFeeInstance.packType = -1
        }
        if (params.feeFlow != null && params.feeFlow != '') {
            ftTradeFeeInstance.feeFlow = (params.feeFlow as Double)*10000 as Long
        } else {
            ftTradeFeeInstance.feeFlow = 0.0
        }
        if (params.feePre != null && params.feePre != '') {
            ftTradeFeeInstance.feePre = params.feePre as Double
        } else {
            ftTradeFeeInstance.feePre = 0.0
        }
        if (params.step1FeeValue != null && params.step1FeeValue != '') {
            ftTradeFeeInstance.step1FeeValue = params.step1FeeValue as Double
        } else if (params.step1FeeValue1 != null && params.step1FeeValue1 != '') {
            ftTradeFeeInstance.step1FeeValue = params.step1FeeValue1 as Double
        }
        if (params.step2FeeValue != null && params.step2FeeValue != '') {
            ftTradeFeeInstance.step2FeeValue = params.step2FeeValue as Double
        } else if (params.step2FeeValue1 != null && params.step2FeeValue1 != '') {
            ftTradeFeeInstance.step2FeeValue = params.step2FeeValue1 as Double
        }
        if (params.step3FeeValue != null && params.step3FeeValue != '') {
            ftTradeFeeInstance.step3FeeValue = params.step3FeeValue as Double
        } else if (params.step3FeeValue1 != null && params.step3FeeValue1 != '') {
            ftTradeFeeInstance.step3FeeValue = params.step3FeeValue1 as Double
        }
        if (params.step4FeeValue != null && params.step4FeeValue != '') {
            ftTradeFeeInstance.step4FeeValue = params.step4FeeValue as Double
        } else if (params.step4FeeValue1 != null && params.step4FeeValue1 != '') {
            ftTradeFeeInstance.step4FeeValue = params.step4FeeValue1 as Double
        }
        if (params.step5FeeType == '1') {
            if (params.step5FeeValue != null && params.step5FeeValue != '') {
                ftTradeFeeInstance.step5FeeValue = params.step5FeeValue as Double
            }
        } else if (params.step5FeeValue1 != null && params.step5FeeValue1 != '') {
            ftTradeFeeInstance.step5FeeValue = params.step5FeeValue1 as Double
        }
        if (params.step1To != null && params.step1To != '') {
            ftTradeFeeInstance.step1From = 0
        }
        if (params.step2To != null && params.step2To != '') {
            ftTradeFeeInstance.step2From = params.step1To as Double
        }
        if (params.step3To != null && params.step3To != '') {
            ftTradeFeeInstance.step3From = params.step2To as Double
        }
        if (params.step4To != null && params.step4To != '') {
            ftTradeFeeInstance.step4From = params.step3To as Double
        }
        if (params.step5To != null && params.step5To != '') {
            ftTradeFeeInstance.step5From = params.step5To as Double
        }
        if (params.dateBegin1 != null && params.dateBegin1 != '') {
            ftTradeFeeInstance.dateBegin = Date.parse('yyyy-MM-dd', params.dateBegin1)
        }
        if (params.dateEnd1 != null && params.dateEnd1 != '') {
            ftTradeFeeInstance.dateEnd = Date.parse('yyyy-MM-dd', params.dateEnd1)
        }
        if (params.firstLiqDate2 != null && params.firstLiqDate2 != '') {
            ftTradeFeeInstance.firstLiqDate = Date.parse('yyyy-MM-dd', params.firstLiqDate2)
        }
        if (params.step5To != null && params.step5To != '') {
            ftTradeFeeInstance.step5From = params.step5To as Double
        }
        if (params.feeModel == '0') {
            ftTradeFeeInstance.step1FeeType = -1
            ftTradeFeeInstance.step5FeeType = -1
        }
        if (flash.message == null || flash.message == '') {

            def sql = new Sql(dataSource_settle)
            flash.message = FtTradeFeeService.createTradeFee(sql, ftTradeFeeInstance)
            if (flash.message == null || flash.message == '') {
                if ((maxDateEnd != '' && maxDateEnd != null) && flag == '0') {
                    flash.message = '费率 已创建。该通道前一费率有效期为' + maxDateBegin + '--' + maxDateEnd
                } else {
                    flash.message = "${message(code: 'default.created.message', args: [message(code: 'ftTradeFee.label', default: 'FtTradeFee'), ''])}"
                }
                redirect(action: "list", id: ftTradeFeeInstance.id, params: [srvName: srvName, customerName: customerName, customerNo: customerNo, srvId: srvId])
            }
            else {
                redirect(action: "list", id: ftTradeFeeInstance.id, params: [srvName: srvName, customerName: customerName, customerNo: customerNo, srvId: srvId])
//                render(view: "create", model: [ftTradeFeeInstance: ftTradeFeeInstance, srvName: srvName, customerName: customerName, customerNo: customerNo, srvId: srvId])
            }
        } else {
            redirect(action: "list", id: ftTradeFeeInstance.id, params: [srvName: srvName, customerName: customerName, customerNo: customerNo, srvId: srvId])
//            render(view: "create", model: [ftTradeFeeInstance: ftTradeFeeInstance, srvName: srvName, customerName: customerName, customerNo: customerNo, srvId: srvId])
        }
    }

    def show = {
        def ftTradeFeeInstance = FtTradeFee.get(params.id)
        if (!ftTradeFeeInstance) {
            flash.message = "${message(code: 'default.not.found.message', args: [message(code: 'ftTradeFee.label', default: 'FtTradeFee'), ''])}"
            redirect(action: "list")
        }
        else {
            [ftTradeFeeInstance: ftTradeFeeInstance]
        }
    }

    def edit = {
        def ftTradeFeeInstance = FtTradeFeeStep.get(params.id)
        def srvName = params.srvName
        def customerNo = params.customerNo
        def srvId = params.srvId
        def feeType = ftTradeFeeInstance.feeType
        def step1FeeValue
        def step2FeeValue
        def step3FeeValue
        def step4FeeValue
        def step5FeeValue
        def step1To
        def step2From
        def step2To
        def step3From
        def step3To
        def step4From
        def step4To
        def step5To
        def flag = params.flag
        def view  //跳转页面
        if (!ftTradeFeeInstance) {
            flash.message = "${message(code: 'default.not.found.message', args: [message(code: 'ftTradeFee.label', default: 'FtTradeFee'), ''])}"
            redirect(action: "list", params: ['srvName': srvName])
        }
        else {
            def beginDate = ftTradeFeeInstance.dateBegin.toString().substring(0, 10)
            def endDate = ftTradeFeeInstance.dateEnd.toString().substring(0, 10)
            def firstDate
            if (ftTradeFeeInstance.firstLiqDate != null && ftTradeFeeInstance.firstLiqDate != '') {
                firstDate = ftTradeFeeInstance.firstLiqDate.toString().substring(0, 10)
            }
            def nowDate = new Date()
            if (feeType == 2) {
                if (flag == '3'|| ftTradeFeeInstance.dateEnd < nowDate) {
                    render(view: "dateEdit", model: [ftTradeFeeInstance: ftTradeFeeInstance, srvName: srvName, beginDate: beginDate, endDate: endDate, firstDate: firstDate, sign: '3'])
                    return
                } else {
                    def ftFoot = FtFoot.findByFootNo(ftTradeFeeInstance.footNo)
                    if (ftFoot && ftFoot.checkStatus == 0) {
                        params.sort = params.sort ? params.sort : "id"
                        params.order = params.order ? params.order : "desc"
                        params.max = Math.min(params.max ? params.int('max') : 10, 100)
                        params.offset = params.offset ? params.int('offset') : 0
                        def srvType = FtSrvType.get(ftTradeFeeInstance.srv.id)?.srvCode
                        def custoemrName = CmCustomer.findByCustomerNo(customerNo)?.name
                        flash.message = '该费率中预付手续费未经过结算审核，无法修改。'
                        redirect(action: "list", params: ['srvType': srvType, 'srvId': srvId, 'customerNo': customerNo, 'customerName': custoemrName, 'srvName': params.srvName])
                    } else {
                          if(flag == 'check' && ftTradeFeeInstance.isverify == '0'){
                              return [ftTradeFeeInstance: ftTradeFeeInstance, srvName: srvName, beginDate: beginDate, endDate: endDate, firstDate: firstDate, step1FeeValue: step1FeeValue, step2FeeValue: step2FeeValue, step3FeeValue: step3FeeValue, step4FeeValue: step4FeeValue, step5FeeValue: step5FeeValue, step1To: step1To, step2From: step2From, step2To: step2To, step3From: step3From, step3To: step3To, step4From: step4From, step4To: step4To, step5To: step5To,flag:"check"]
                          }
                        render(view: "dateEdit", model: [ftTradeFeeInstance: ftTradeFeeInstance, srvName: srvName, beginDate: beginDate, endDate: endDate, firstDate: firstDate, flag: '0'])
                        return
                    }
                }
            } else {
                DecimalFormat df = new DecimalFormat("###0.00");
                if (ftTradeFeeInstance.step1FeeValue) {
                    step1FeeValue = df.format(ftTradeFeeInstance.step1FeeValue as Double).toString()
                }
                if (ftTradeFeeInstance.step2FeeValue) {
                    step2FeeValue = df.format(ftTradeFeeInstance.step2FeeValue as Double).toString()
                }
                if (ftTradeFeeInstance.step3FeeValue) {
                    step3FeeValue = df.format(ftTradeFeeInstance.step3FeeValue as Double).toString()
                }
                if (ftTradeFeeInstance.step4FeeValue) {
                    step4FeeValue = df.format(ftTradeFeeInstance.step4FeeValue as Double).toString()
                }
                if (ftTradeFeeInstance.step5FeeValue) {
                    step5FeeValue = df.format(ftTradeFeeInstance.step5FeeValue as Double).toString()
                }
                if (ftTradeFeeInstance.step1To) {
                    step1To = df.format(ftTradeFeeInstance.step1To as Double).toString()
                }
                if (ftTradeFeeInstance.step2To) {
                    step2To = df.format(ftTradeFeeInstance.step2To as Double).toString()
                    step2From = df.format(ftTradeFeeInstance.step2From as Double).toString()
                }
                if (ftTradeFeeInstance.step3To) {
                    step3To = df.format(ftTradeFeeInstance.step3To as Double).toString()
                    step3From = df.format(ftTradeFeeInstance.step3From as Double).toString()
                }
                if (ftTradeFeeInstance.step4To) {
                    step4To = df.format(ftTradeFeeInstance.step4To as Double).toString()
                    step4From = df.format(ftTradeFeeInstance.step4From as Double).toString()
                }
                if (ftTradeFeeInstance.step5To) {
                    step5To = df.format(ftTradeFeeInstance.step5To as Double).toString()
                }

                //增加标识位 当view视图传过来不等于3时 按照正常逻辑，等于3时 只是显示 as sunweiguo 2012-08-13
                if (flag != '3') {
                    if (nowDate >= ftTradeFeeInstance.dateBegin && nowDate <= ftTradeFeeInstance.dateEnd) {
                        if(flag == 'check' && ftTradeFeeInstance.isverify == '0'){
                        return [ftTradeFeeInstance: ftTradeFeeInstance, srvName: srvName, beginDate: beginDate, endDate: endDate, firstDate: firstDate, step1FeeValue: step1FeeValue, step2FeeValue: step2FeeValue, step3FeeValue: step3FeeValue, step4FeeValue: step4FeeValue, step5FeeValue: step5FeeValue, step1To: step1To, step2From: step2From, step2To: step2To, step3From: step3From, step3To: step3To, step4From: step4From, step4To: step4To, step5To: step5To,flag:"check"]
                        }
                        render(view: "dateEdit", model: [ftTradeFeeInstance: ftTradeFeeInstance, srvName: srvName, beginDate: beginDate, endDate: endDate, firstDate: firstDate, flag: '0'])
                        return
                    } else if (ftTradeFeeInstance.dateEnd < nowDate) {
                        if(flag == 'check' && ftTradeFeeInstance.isverify == '0'){
                         return [ftTradeFeeInstance: ftTradeFeeInstance, srvName: srvName, beginDate: beginDate, endDate: endDate, firstDate: firstDate, step1FeeValue: step1FeeValue, step2FeeValue: step2FeeValue, step3FeeValue: step3FeeValue, step4FeeValue: step4FeeValue, step5FeeValue: step5FeeValue, step1To: step1To, step2From: step2From, step2To: step2To, step3From: step3From, step3To: step3To, step4From: step4From, step4To: step4To, step5To: step5To,flag:"check"]
                        }
                        render(view: "dateEdit", model: [ftTradeFeeInstance: ftTradeFeeInstance, srvName: srvName, beginDate: beginDate, endDate: endDate, firstDate: firstDate, flag: '1'])
                        return
                    } else {
                        return [ftTradeFeeInstance: ftTradeFeeInstance, srvName: srvName, beginDate: beginDate, endDate: endDate, firstDate: firstDate, step1FeeValue: step1FeeValue, step2FeeValue: step2FeeValue, step3FeeValue: step3FeeValue, step4FeeValue: step4FeeValue, step5FeeValue: step5FeeValue, step1To: step1To, step2From: step2From, step2To: step2To, step3From: step3From, step3To: step3To, step4From: step4From, step4To: step4To, step5To: step5To,flag:"check"]
                    }
                } else {
                    render(view: "dateEdit", model: [ftTradeFeeInstance: ftTradeFeeInstance, srvName: srvName, beginDate: beginDate, endDate: endDate, firstDate: firstDate, sign: '3'])
                    return
                }
            }

        }
    }

    def update = {
        def ftTradeFeeInstance = FtTradeFeeStep.get(params.id)
        def feeType = ftTradeFeeInstance.feeType
        def srvType = FtSrvType.get(ftTradeFeeInstance.srv.id)?.srvCode
        def srvId = ftTradeFeeInstance?.srv?.id
        def customerNo = ftTradeFeeInstance?.customerNo
        def custoemrName = CmCustomer.findByCustomerNo(customerNo)?.name
        def editFlag = '0'
        def ftTradeFee
        def nowDate = new Date()
        def check = params.check //判断费率是否审核
        if (nowDate >= ftTradeFeeInstance.dateBegin && nowDate <= ftTradeFeeInstance.dateEnd) {
            editFlag = '1'
        }
        if (ftTradeFeeInstance) {
            if (params.version) {
                def version = params.version.toLong()
                if (ftTradeFeeInstance.version > version) {

                    ftTradeFeeInstance.errors.rejectValue("version", "default.optimistic.locking.failure", [message(code: 'ftTradeFee.label', default: 'FtTradeFee')] as Object[], "Another user has updated this FtTradeFee while you were editing")
                    render(view: "edit", model: [ftTradeFeeInstance: ftTradeFeeInstance])
                    return
                }
            }
            if(check == 'check'){
                ftTradeFeeInstance.isverify = '1'
            }

            if (feeType == 2) {

                ftTradeFeeInstance.feeFlow = (new BigDecimal(String.valueOf(ftTradeFeeInstance.feeFlow))).add((new BigDecimal(String.valueOf(params.feeFlow))).multiply(10000)).doubleValue()
                ftTradeFeeInstance.feePre = (new BigDecimal(String.valueOf(ftTradeFeeInstance.feePre))).add(new BigDecimal(String.valueOf(params.feePre))).doubleValue()
                ftTradeFeeInstance.isViewDate = params.isViewDate
                ftTradeFeeInstance.isViewOver = params.isViewOver
                ftTradeFeeInstance.isViewPer = params.isViewPer
                if (Double.valueOf(params.feeFlow) > 0) {
                    ftTradeFeeInstance.isViewPerMail = false
                    ftTradeFeeInstance.isViewOverMail = false
                }

                def sql = new Sql(dataSource_settle)
                flash.message = FtTradeFeeService.createTradeFee(sql, ftTradeFeeInstance)
                if (flash.message == null || flash.message == '') {
                    flash.message = '费率 已更新。'
                    redirect(action: "list", params: ['srvType': srvType, 'srvId': srvId, 'customerNo': customerNo, 'customerName': custoemrName, 'srvName': params.srvName])
                }

            } else {
                def tradeType1 = FtSrvTradeType.get(params.tradeType1)
//            ftTradeFee = FtTradeFeeStep.findAllWhere(customerNo: customerNo, srv: ftTradeFeeInstance.srv, tradeType: tradeType1, channelCode: params.channelCode)
                //同一客户，同一服务类型、交易类型、费率通道的有效日期不能重叠
                if (params.channelCode != null && params.channelCode != '') {
                    ftTradeFee = FtTradeFee.findAllWhere(customerNo: customerNo, srv: ftTradeFeeInstance.srv, tradeType: tradeType1, channelCode: params.channelCode)
                } else {
                    ftTradeFee = FtTradeFee.findAll("from FtTradeFee where customerNo=:customerNo and srv=:srvId and tradeType=:tradeTypeId and channelCode is null ", [customerNo: customerNo, srvId: ftTradeFeeInstance.srv, tradeTypeId: tradeType1])
                }
                DateFormat dateFormat = new SimpleDateFormat('yyyy-MM-dd')
                def dateBegin
                def dateEnd
                def flag = '0'//用于判断有效日期是否连续
                def maxDateEnd
                def maxDateBegin
                def beginDate = ftTradeFeeInstance.dateBegin.toString().substring(0, 10)
                def endDate = ftTradeFeeInstance.dateEnd.toString().substring(0, 10)
                def firstDate
                if (ftTradeFeeInstance.firstLiqDate != null && ftTradeFeeInstance.firstLiqDate != '') {
                    firstDate = ftTradeFeeInstance.firstLiqDate.toString().substring(0, 10)
                }
                if (ftTradeFee.size() > 0) {
                    ftTradeFee.each {
                        dateBegin = dateFormat.format(it.dateBegin)
                        dateEnd = dateFormat.format(it.dateEnd)
                        if (!params.id.equals(it.id.toString())) {
                            if (params.dateBegin1 >= dateBegin && params.dateBegin1 <= dateEnd) {
                                flash.message = "有效日期区间不能重叠！"
                                render(view: "edit", model: [ftTradeFeeInstance: ftTradeFeeInstance, srvType: srvType])
                                return
                            }
                            if (params.dateEnd1 >= dateBegin && params.dateEnd1 <= dateEnd) {
                                flash.message = "有效日期区间不能重叠！"
                                render(view: "edit", model: [ftTradeFeeInstance: ftTradeFeeInstance, srvType: srvType])
                                return
                            }
                            if (params.dateBegin1 <= dateBegin && params.dateEnd1 >= dateEnd) {
                                flash.message = "有效日期区间不能重叠！"
                                render(view: "edit", model: [ftTradeFeeInstance: ftTradeFeeInstance, srvType: srvType])
                                return
                            }
                            if (dateEnd > maxDateEnd) {
                                maxDateEnd = dateEnd
                                maxDateBegin = dateBegin
                                if (Date.parse('yyyy-MM-dd', maxDateEnd) + 1 == Date.parse('yyyy-MM-dd', params.dateBegin1)) {
                                    flag = '1'
                                }
                            }
                        }
                    }
                }
                if (flash.message == null) {
                    ftTradeFeeInstance.properties = params
                    if (editFlag == '1') {
                        ftTradeFeeInstance.dateEnd = Date.parse('yyyy-MM-dd', params.dateEnd1)
                    }
                    if (editFlag == '0') {
                        if (params.tradeType1 != null && params.tradeType1 != '') {
                            def tradeType = FtSrvTradeType.get(params.tradeType1)
                            ftTradeFeeInstance.tradeType = tradeType
                        }
                        if (params.feeMax != null && params.feeMax != '') {
                            ftTradeFeeInstance.feeMax = params.feeMax as Double
                        } else {
                            ftTradeFeeInstance.feeMax = 0.0
                        }
                        if (params.feeMin != null && params.feeMin != '') {
                            ftTradeFeeInstance.feeMin = params.feeMin as Double
                        } else {
                            ftTradeFeeInstance.feeMin = 0.0
                        }
                        if (params.feeType != null && params.feeType != '') {
                            ftTradeFeeInstance.feeType = params.feeType as Integer
                        } else {
                            ftTradeFeeInstance.feeType = -1
                        }
                        if (params.feeModel == '1') {
                            if (params.feeValue13 != null && params.feeValue13 != '') {
                                ftTradeFeeInstance.feeValue = params.feeValue13 as Double
                            }
                        } else if (params.feeValue != null && params.feeValue != '' && params.feeModel == '0') {
                            if (params.feeType == '0') {
                                ftTradeFeeInstance.feeValue = params.feeValue12 as Double
                            } else if (params.feeType == '1') {
                                ftTradeFeeInstance.feeValue = params.feeValue as Double
                            }
                        } else {
                            ftTradeFeeInstance.feeValue = 0.0
                        }
                        if (params.feeModel == '1') {
                            if (params.packLen != null && params.packLen != '') {
                                ftTradeFeeInstance.packLen = params.packLen as Integer
                            }
                            if (params.packType != null && params.packType != '') {
                                ftTradeFeeInstance.packType = params.packType as Integer
                            }
                        } else if (params.feeModel == '2') {
                            if (params.packLen11 != null && params.packLen11 != '') {
                                ftTradeFeeInstance.packLen = params.packLen11 as Integer
                            }
                            if (params.packType11 != null && params.packType11 != '') {
                                ftTradeFeeInstance.packType = params.packType11 as Double
                            }
                        } else {
                            ftTradeFeeInstance.packLen = 0
                            ftTradeFeeInstance.packType = 0.0
                        }
                        if (params.step1FeeType != null && params.step1FeeType != '' && params.step1FeeType == '1') {
                            if (params.step1FeeValue != null && params.step1FeeValue != '') {
                                ftTradeFeeInstance.step1FeeValue = params.step1FeeValue as Double
                            }
                        } else if (params.step1FeeValue1 != null && params.step1FeeValue1 != '') {
                            ftTradeFeeInstance.step1FeeValue = params.step1FeeValue1 as Double
                        }
                        if (params.step2FeeType != null && params.step2FeeType != '' && params.step2FeeType == '1') {
                            if (params.step2FeeValue != null && params.step2FeeValue != '') {
                                ftTradeFeeInstance.step2FeeValue = params.step2FeeValue as Double
                            }
                        } else if (params.step2FeeValue1 != null && params.step2FeeValue1 != '') {
                            ftTradeFeeInstance.step2FeeValue = params.step2FeeValue1 as Double
                        }
                        if (params.step3FeeType != null && params.step3FeeType != '' && params.step3FeeType == '1') {
                            if (params.step3FeeValue != null && params.step3FeeValue != '') {
                                ftTradeFeeInstance.step3FeeValue = params.step3FeeValue as Double
                            }
                        } else if (params.step3FeeValue1 != null && params.step3FeeValue1 != '') {
                            ftTradeFeeInstance.step3FeeValue = params.step3FeeValue1 as Double
                        }
                        if (params.step4FeeType != null && params.step4FeeType != '' && params.step4FeeType == '1') {
                            if (params.step4FeeValue != null && params.step4FeeValue != '') {
                                ftTradeFeeInstance.step4FeeValue = params.step4FeeValue as Double
                            }
                        } else if (params.step4FeeValue1 != null && params.step4FeeValue1 != '') {
                            ftTradeFeeInstance.step4FeeValue = params.step4FeeValue1 as Double
                        }
                        if (params.step5FeeType != null && params.step5FeeType != '' && params.step5FeeType == '1') {
                            if (params.step5FeeValue != null && params.step5FeeValue != '') {
                                ftTradeFeeInstance.step5FeeValue = params.step5FeeValue as Double
                            }
                        } else if (params.step5FeeValue1 != null && params.step5FeeValue1 != '') {
                            ftTradeFeeInstance.step5FeeValue = params.step5FeeValue1 as Double
                        }
                        if (params.dateBegin1 != null && params.dateBegin1 != '') {
                            ftTradeFeeInstance.dateBegin = Date.parse('yyyy-MM-dd', params.dateBegin1)
                        }
                        if (params.dateEnd1 != null && params.dateEnd1 != '') {
                            ftTradeFeeInstance.dateEnd = Date.parse('yyyy-MM-dd', params.dateEnd1)
                        }
                        if (params.firstLiqDate2 != null && params.firstLiqDate2 != '') {
                            ftTradeFeeInstance.firstLiqDate = Date.parse('yyyy-MM-dd', params.firstLiqDate2)
                        }
                        if (params.step5To != null && params.step5To != '') {
                            ftTradeFeeInstance.step5From = params.step5To as Double
                        }
                        if (params.step1To == null || params.step1To == '' || params.step1To.equals('0.0')) {
                            ftTradeFeeInstance.step1To = 0
                            ftTradeFeeInstance.step1From = 0
                            ftTradeFeeInstance.step1FeeType = -1
                            ftTradeFeeInstance.step1FeeValue = 0
                            ftTradeFeeInstance.step1FeeMin = 0.0
                            ftTradeFeeInstance.step1FeeMax = 0.0
                            ftTradeFeeInstance.step1FeeValue = 0
                        }
                        if (params.step2To == null) {
                            ftTradeFeeInstance.step2To = 0
                            ftTradeFeeInstance.step2From = 0
                            ftTradeFeeInstance.step2FeeType = -1
                            ftTradeFeeInstance.step2FeeValue = 0
                            ftTradeFeeInstance.step2FeeMin = 0.0
                            ftTradeFeeInstance.step2FeeMax = 0.0
                            ftTradeFeeInstance.step2FeeValue = 0
                        }
                        if (params.step3To == null) {
                            ftTradeFeeInstance.step3To = 0
                            ftTradeFeeInstance.step3From = 0
                            ftTradeFeeInstance.step3FeeType = -1
                            ftTradeFeeInstance.step3FeeValue = 0
                            ftTradeFeeInstance.step3FeeMin = 0.0
                            ftTradeFeeInstance.step3FeeMax = 0.0
                            ftTradeFeeInstance.step3FeeValue = 0
                        }
                        if (params.step4To == null) {
                            ftTradeFeeInstance.step4To = 0
                            ftTradeFeeInstance.step4From = 0
                            ftTradeFeeInstance.step4FeeType = -1
                            ftTradeFeeInstance.step4FeeValue = 0
                            ftTradeFeeInstance.step4FeeMin = 0.0
                            ftTradeFeeInstance.step4FeeMax = 0.0
                            ftTradeFeeInstance.step4FeeValue = 0
                        }
                        if (params.step5To == null || params.step5To == '' || params.step5To.equals('0.0')) {
                            ftTradeFeeInstance.step5To = 0
                            ftTradeFeeInstance.step5From = 0
                            ftTradeFeeInstance.step5FeeType = -1
                            ftTradeFeeInstance.step5FeeValue = 0
                            ftTradeFeeInstance.step5FeeMin = 0.0
                            ftTradeFeeInstance.step5FeeMax = 0.0
                            ftTradeFeeInstance.step5FeeValue = 0
                        }
                    }
                    if (!ftTradeFeeInstance.hasErrors() && ftTradeFeeInstance.save(flush: true, failOnError: true)) {

                        if ((maxDateEnd != '' && maxDateEnd != null) && flag == '0') {
                            flash.message = '费率 已更新。该通道前一费率有效期为' + maxDateBegin + '--' + maxDateEnd
                        } else {
                            flash.message = "${message(code: 'default.updated.message', args: [message(code: 'ftTradeFee.label', default: 'FtTradeFee'), ''])}"
                        }
                        redirect(action: "list", params: ['srvType': srvType, 'srvId': srvId, 'customerNo': customerNo, 'customerName': custoemrName, 'srvName': params.srvName])
                    } else {
                        if (nowDate >= ftTradeFeeInstance.dateBegin && nowDate <= ftTradeFeeInstance.dateEnd) {
                            render(view: "dateEdit", model: [ftTradeFeeInstance: ftTradeFeeInstance, srvType: srvType, srvName: params.srvName, beginDate: beginDate, endDate: endDate, firstDate: firstDate])
                        } else {
                            render(view: "edit", model: [ftTradeFeeInstance: ftTradeFeeInstance, srvType: srvType, srvName: params.srvName, beginDate: beginDate, endDate: endDate, firstDate: firstDate])
                        }
                    }
                } else {
                    if (nowDate >= ftTradeFeeInstance.dateBegin && nowDate <= ftTradeFeeInstance.dateEnd) {
                        render(view: "dateEdit", model: [ftTradeFeeInstance: ftTradeFeeInstance, srvType: srvType, srvName: params.srvName, beginDate: beginDate, endDate: endDate, firstDate: firstDate])
                    } else {
                        render(view: "edit", model: [ftTradeFeeInstance: ftTradeFeeInstance, srvType: srvType, srvName: params.srvName, beginDate: beginDate, endDate: endDate, firstDate: firstDate])
                    }
                }
            }
        } else {
            flash.message = "${message(code: 'default.not.found.message', args: [message(code: 'ftTradeFee.label', default: 'FtTradeFee'), ''])}"
            redirect(action: "list", params: ['srvType': srvType, 'srvId': srvId, 'customerNo': customerNo, 'customerName': custoemrName, 'srvName': params.srvName])
        }
    }

    def delete = {
        def ftTradeFeeInstance = FtTradeFee.get(params.id)
        if (ftTradeFeeInstance) {
            try {
                ftTradeFeeInstance.delete(flush: true)
                flash.message = "${message(code: 'default.deleted.message', args: [message(code: 'ftTradeFee.label', default: 'FtTradeFee'), ''])}"
                redirect(action: "list")
            }
            catch (org.springframework.dao.DataIntegrityViolationException e) {
                flash.message = "${message(code: 'default.not.deleted.message', args: [message(code: 'ftTradeFee.label', default: 'FtTradeFee'), ''])}"
                redirect(action: "show", id: params.id)
            }
        }
        else {
            flash.message = "${message(code: 'default.not.found.message', args: [message(code: 'ftTradeFee.label', default: 'FtTradeFee'), ''])}"
            redirect(action: "list")
        }
    }
}
