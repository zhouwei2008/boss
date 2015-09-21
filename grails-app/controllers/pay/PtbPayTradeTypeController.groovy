package pay

class PtbPayTradeTypeController {
    static allowedMethods = [save: "POST", update: "POST", delete: "POST"]
    def pdbService
    def pdklist = {
         params.max = Math.min(params.max ? params.int('max') : 20, 100)
        def query = {
            eq('payType', 'F')
        }
        [ptbPayTradeTypeList: PtbPayTradeType.createCriteria().list(params, query), ptbPayTradeTypeTotal: PtbPayTradeType.createCriteria().count(query)]
    }
    def pdkcreate = {
    }

    def psklist = {
         params.max = Math.min(params.max ? params.int('max') : 20, 100)
        def query = {
            eq('payType', 'S')
        }
        [ptbPayTradeTypeList: PtbPayTradeType.createCriteria().list(params, query), ptbPayTradeTypeTotal: PtbPayTradeType.createCriteria().count(query)]
    }
    def pskcreate = {
    }

    def save = {
        def result = pdbService.savePtbPayTradeType(params)
        flash.message = "${message(code: result.msg, args: [message(code: result.msg, default: result.msg), result.savePtbPayTradeType?.payCode])}"
        if (params.payType == 'F') {
            redirect(action: "pdklist")
        } else {
            redirect(action: "psklist")
        }
    }
    def updateItem = {
        [ptbPayTradeType:PtbPayTradeType.get(params.payId)]
    }

    def update = {
        PtbPayTradeType ptbPayTradeType = PtbPayTradeType.get(params.payId)
        ptbPayTradeType.payName = params.payName
        ptbPayTradeType.note = params.note
        ptbPayTradeType.save()
        flash.message = "${ptbPayTradeType.payCode} 修改成功！"
        if (ptbPayTradeType.payType == 'F') {
            redirect(action: "pdklist")
        } else {
            redirect(action: "psklist")
        }
    }

    def deleteItem = {
        PtbPayTradeType ptbPayTradeType = PtbPayTradeType.get(params.payId)
        if(PtbPayTrade.countByTradeCode(ptbPayTradeType.payCode)>0){
            flash.message = "交易类型 ${ptbPayTradeType.payCode} 已被使用,不能删除！"
        }else{
            ptbPayTradeType.delete()
            flash.message = "${ptbPayTradeType.payCode} 删除成功！"
        }
        if (ptbPayTradeType.payType == 'F') {
            redirect(action: "pdklist")
        } else {
            redirect(action: "psklist")
        }
    }

}
