package boss

import account.AccountClientService
import org.apache.commons.lang.StringUtils
import autowithdraw.GenerateNextTime

class BoCustomerWithdrawCycleController {
    AccountClientService accountClientService

    def index = {
        redirect(action: "list", params: params)
    }

    def list = {
        println "#method list#"
        //params.max = Math.min(params.max ? params.int('max') : 10, 100)
        //[boCustomerWithdrawCycleInstanceList: BoCustomerWithdrawCycle.list(params), boCustomerWithdrawCycleInstanceTotal: BoCustomerWithdrawCycle.count()]

        params.max = Math.min(params.max ? params.int('max') : 10, 100)
        params.offset = params.offset ? params.int('offset') : 0

        def query = {
            if (params.customerNo != null && params.customerNo != '') {
                like("customerNo", "%" + params.customerNo + "%")
            }
            if (params.name != null && params.name != '') {
                like("registrationName", "%" + params.name.trim() + "%")
            }
        }

        def total = ismp.CmCorporationInfo.createCriteria().count(query)
        def results = ismp.CmCorporationInfo.createCriteria().list(params, query)

        [list: results, total: total, params: params]
    }

    def show = {
        println "#method show#"

        def cno = params.customerNo
        if(StringUtils.isEmpty(cno)){
            flash.message = "${message(code: 'boCustomerWithdrawCycle.none.customerno.label')}"
            redirect(action: "list")
            return
        }

        def instance = BoCustomerWithdrawCycle.findByCustomerNo(cno)
        println "#instance#${instance}"
        if(!instance){
            instance = new BoCustomerWithdrawCycle()
            instance.customerNo=cno
            instance.withdrawType=0
            instance.withdrawAmount=0
            instance.cycleType=1 // 默认为1
            instance.cycleTimes=0
            instance.cycleExpr=''
            instance.holidayWithdraw=0
            instance.amountType=0
            instance.keepAmount=0
        }

        /*if(list == null || list.size() == 0){
            instance = new BoCustomerWithdrawCycle()
            instance.customerNo=cno
            instance.withdrawType=0
            instance.withdrawAmount=0
            instance.cycleType=1 // 默认为1
            instance.cycleTimes=0
            instance.cycleExpr=''
            instance.holidayWithdraw=0
            instance.amountType=0
            instance.keepAmount=0
        }else if(list.size() > 1){
            flash.message = "${message(code: 'boCustomerWithdrawCycle.repeat.customerno.label')}"
            redirect(action: "list")
            return
        }else{
            instance = list.get(0)
        }*/

        [boCustomerWithdrawCycleInstance: instance]
    }

    def edit = {
        println "#method edit#"

        def cno = params.customerNo
        if(StringUtils.isEmpty(cno)){
            flash.message = "${message(code: 'boCustomerWithdrawCycle.none.customerno.label')}"
            redirect(action: "list")
            return
        }

        def instance = BoCustomerWithdrawCycle.findByCustomerNo(cno)
        println "#instance#${instance}"
        if(!instance){
            instance = new BoCustomerWithdrawCycle()
            instance.customerNo=cno
            instance.withdrawType=0
            instance.withdrawAmount=0
            instance.cycleType=1 // 默认为1
            instance.cycleTimes=0
            instance.cycleExpr=''
            instance.holidayWithdraw=0
            instance.amountType=0
            instance.keepAmount=0
        }

        /*if(list == null || list.size() == 0){
            instance = new BoCustomerWithdrawCycle()
            instance.customerNo=cno
            instance.withdrawType=0
            instance.withdrawAmount=0
            instance.cycleType=1 // 默认为1
            instance.cycleTimes=0
            instance.cycleExpr=''
            instance.holidayWithdraw=0
            instance.amountType=0
            instance.keepAmount=0
        }else if(list.size() > 1){
            flash.message = "${message(code: 'boCustomerWithdrawCycle.repeat.customerno.label')}"
            redirect(action: "list")
            return
        }else{
            instance = list.get(0)
        }*/

        [boCustomerWithdrawCycleInstance: instance]
    }

    def update = {
        println "#method update#"

        def cno = params.customerNo
        println "#cno#${cno}"
        if(StringUtils.isEmpty(cno)){
            flash.message = "${message(code: 'boCustomerWithdrawCycle.none.customerno.label')}"
            redirect(action: "list")
            return
        }

        if(params.withdrawType && params.withdrawType == '0' && params.cycleType && params.cycleTimes && (params.cycleTimes as int) > 0){
            println "#params.cycleTimes#${params.cycleTimes}"
            def type = params.cycleType as int
            def num = params.cycleTimes as int
            def time_expr = "["
            switch(type){
                case 1:
                    //for(def i=0;i<num;i++){ 存在bug
                    for(def i=0;i<1;i++){
                        if(request.getParameter("select_cycleExpr_hour_${i+1}")){
                            time_expr += request.getParameter("select_cycleExpr_hour_${i+1}") + ","
                        }
                    }
                    break;
                case 2:
                    //for(def i=0;i<num;i++){ 存在bug
                    for(def i=0;i<7;i++){
                        println "#out#${request.getParameter("select_cycleExpr_week_${i+1}")}#${request.getParameter("select_cycleExpr_hour_${i+1}")}"
                        if(request.getParameter("select_cycleExpr_week_${i+1}") && request.getParameter("select_cycleExpr_hour_${i+1}")){
                            println "#in#${request.getParameter("select_cycleExpr_week_${i+1}")}#${request.getParameter("select_cycleExpr_hour_${i+1}")}"
                            time_expr += request.getParameter("select_cycleExpr_week_${i+1}") + "#" + request.getParameter("select_cycleExpr_hour_${i+1}") + ","
                        }
                    }
                    break;
                case 3:
                    //for(def i=0;i<num;i++){ 存在bug
                    for(def i=0;i<31;i++){
                        if(request.getParameter("select_cycleExpr_month_${i+1}") && request.getParameter("select_cycleExpr_hour_${i+1}")){
                            time_expr += request.getParameter("select_cycleExpr_month_${i+1}") + "#" + request.getParameter("select_cycleExpr_hour_${i+1}") + ","
                        }
                    }
                    break;
            }
            if(time_expr.length() > 1){
               time_expr = time_expr.subSequence(0,time_expr.length()-1)
            }
            time_expr += "]"
            println "#time_expr#${time_expr}"
            params.cycleExpr = time_expr
        }

        def instance = BoCustomerWithdrawCycle.findByCustomerNo(cno)
        println "#instance#${instance}"
        if(instance){
            println "#params.version#${params.version}"
            if (params.version) {
                def version = params.version.toLong()
                if (instance.version > version) {
                    println "#instance.version > version#"
                    instance.errors.rejectValue("version", "default.optimistic.locking.failure", [message(code: 'boCustomerWithdrawCycle.label', default: 'BoCustomerWithdrawCycle')] as Object[], "Another user has updated this BoCustomerWithdrawCycle while you were editing")
                    render(view: "edit", model: [boCustomerWithdrawCycleInstance: instance])
                    return
                }
            }

            //instance.properties = params
            println "#params#${params}"
            if(params.withdrawType == '0'){
                instance.withdrawType = params.withdrawType as int
                instance.cycleType = params.cycleType as int
                instance.cycleTimes = params.cycleTimes as int
                instance.cycleExpr = params.cycleExpr
                instance.holidayWithdraw = params.holidayWithdraw as int
                instance.amountType = params.amountType as int
                instance.nextFootDate = GenerateNextTime.get(params.cycleExpr ? params.cycleExpr :"", new Date(), instance.holidayWithdraw, instance.cycleType)
                if(params.amountType == '1'){
                    instance.keepAmount = new BigDecimal(params.keepAmount.replaceAll(",","")).setScale(2,0)
                }
            }else if(params.withdrawType == '1'){
                instance.withdrawType = params.withdrawType as int
                instance.withdrawAmount = new BigDecimal(params.withdrawAmount.replaceAll(",","")).setScale(2,0)
                instance.amountType = params.amountType as int
                if(params.amountType == '1'){
                    instance.keepAmount = new BigDecimal(params.keepAmount.replaceAll(",","")).setScale(2,0)
                }
            }else{
                println "******params error"
                flash.message = "${message(code: 'boCustomerWithdrawCycle.updated.failed')}"
                render(view: "edit", model: [boCustomerWithdrawCycleInstance: instance])
                return
            }

            if (!instance.hasErrors() && instance.save([flush: true, failOnError:true])) {
                println "******no error"
                flash.message = "商户 ${instance.customerNo} 自动提现周期已更新"
                //redirect(action: "list")
                redirect(action: "show",params:[customerNo:cno])
                return
            } else {
                println "******with error"
                flash.message = "${message(code: 'boCustomerWithdrawCycle.updated.failed')}"
                render(view: "edit", model: [boCustomerWithdrawCycleInstance: instance])
                return
            }
        }else{
            instance = new BoCustomerWithdrawCycle(params)

            if(params.withdrawType == '0'){
                instance.withdrawType = params.withdrawType as int
                instance.cycleType = params.cycleType as int
                instance.cycleTimes = params.cycleTimes as int
                instance.cycleExpr = params.cycleExpr
                instance.holidayWithdraw = params.holidayWithdraw as int
                instance.amountType = params.amountType as int
                instance.nextFootDate = GenerateNextTime.get(params.cycleExpr ? params.cycleExpr :"", new Date(), instance.holidayWithdraw, instance.cycleType)
                if(params.amountType == '1'){
                    instance.keepAmount = new BigDecimal(params.keepAmount.replaceAll(",","")).setScale(2,0)
                }
            }else if(params.withdrawType == '1'){
                instance.withdrawType = params.withdrawType as int
                instance.withdrawAmount = new BigDecimal(params.withdrawAmount.replaceAll(",","")).setScale(2,0)
                instance.amountType = params.amountType as int
                if(params.amountType == '1'){
                    instance.keepAmount = new BigDecimal(params.keepAmount.replaceAll(",","")).setScale(2,0)
                }
            }else{
                println "******params error"
                flash.message = "${message(code: 'boCustomerWithdrawCycle.updated.failed')}"
                render(view: "edit", model: [boCustomerWithdrawCycleInstance: instance])
                return
            }

            if (instance.save([flush: true, failOnError:true])) {
                //flash.message = "${message(code: 'default.updated.message', args: [message(code: 'boCustomerWithdrawCycle.label', default: 'BoCustomerWithdrawCycle'), instance.customerNo])}"
                flash.message = "商户 ${instance.customerNo} 自动提现周期已更新"
                //redirect(action: "list")
                redirect(action: "show",params:[customerNo:cno])
            }else {
                flash.message = "${message(code: 'boCustomerWithdrawCycle.updated.failed')}"
                render(view: "edit", model: [boCustomerWithdrawCycleInstance: instance])
            }
        }
    }
}