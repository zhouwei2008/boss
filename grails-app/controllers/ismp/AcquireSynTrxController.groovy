package ismp

import groovyx.net.http.HTTPBuilder
import groovyx.net.http.EncoderRegistry
import groovyx.net.http.ContentType
import org.codehaus.groovy.grails.commons.ConfigurationHolder
import ebank.tools.StringUtil
import groovyx.net.http.Method
import org.springframework.web.multipart.MultipartHttpServletRequest
import org.springframework.web.multipart.commons.CommonsMultipartFile

class AcquireSynTrxController {

    static allowedMethods = [save: "POST", update: "POST", delete: "POST"]

    def index = {
        redirect(action: "list", params: params)
    }

    def list = {
        params.max = Math.min(params.max ? params.int('max') : 10, 100)
        def summ = AcquireSynTrx.createCriteria().get {
            projections {
                sum('amount')
            }
        }
        [acquireSynTrxInstanceList: AcquireSynTrx.list(params), acquireSynTrxInstanceTotal: AcquireSynTrx.count(),totalAmount:summ]
    }

    def create = {
        def acquireSynTrxInstance = new AcquireSynTrx()
        acquireSynTrxInstance.properties = params
        return [acquireSynTrxInstance: acquireSynTrxInstance]
    }

    def save = {
        def acquireSynTrxInstance = new AcquireSynTrx(params)
        if (acquireSynTrxInstance.save(flush: true)) {
            flash.message = "${message(code: 'default.created.message', args: [message(code: 'acquireSynTrx.label', default: 'AcquireSynTrx'), acquireSynTrxInstance.id])}"
            redirect(action: "list", id: acquireSynTrxInstance.id)
        }
        else {
            render(view: "create", model: [acquireSynTrxInstance: acquireSynTrxInstance])
        }
    }

    def show = {
        def acquireSynTrxInstance = AcquireSynTrx.get(params.id)
        if (!acquireSynTrxInstance) {
            flash.message = "${message(code: 'default.not.found.message', args: [message(code: 'acquireSynTrx.label', default: 'AcquireSynTrx'), params.id])}"
            redirect(action: "list")
        }
        else {
            [acquireSynTrxInstance: acquireSynTrxInstance]
        }
    }

    def edit = {
        def acquireSynTrxInstance = AcquireSynTrx.get(params.id)
        if (!acquireSynTrxInstance) {
            flash.message = "${message(code: 'default.not.found.message', args: [message(code: 'acquireSynTrx.label', default: 'AcquireSynTrx'), params.id])}"
            redirect(action: "list")
        }
        else {
            return [acquireSynTrxInstance: acquireSynTrxInstance]
        }
    }

    def upLoad = {
        // 银行名称
        def bankName = params.bankName
        if (request instanceof MultipartHttpServletRequest) {
            InputStream is = null
            def resultmsg
            MultipartHttpServletRequest multiRequest = (MultipartHttpServletRequest) request
            CommonsMultipartFile orginalFile = (CommonsMultipartFile) multiRequest.getFile("myFile")
            List list = new ArrayList();
            // 判断是否上传文件
            if (orginalFile != null && !orginalFile.isEmpty()) {
                is = orginalFile.getInputStream()
                //判断当前文件的版本xls,xlxs
                String originalFilename = orginalFile.getOriginalFilename()
                //上传文件
                def extension = originalFilename.substring(originalFilename.indexOf(".") + 1)
                java.text.SimpleDateFormat sdf = new java.text.SimpleDateFormat("yyyyMMddHHmmssssss")
                java.text.SimpleDateFormat df = new java.text.SimpleDateFormat("yyyyMMdd")
                String name = bankName + "-" + sdf.format(new Date()) + "." + extension
                def filepath = request.getRealPath("/") + "/Uploadfile/"
                def filename = filepath + name
                def fileName = "BOSS/web-app/Uploadfile/" + name
                // 获取上传文件扩展名
                //处理excel为xls版本的数据
//                if (extension.equals("xls")) {
//                    list = this.getXls(is)
//                } else if (extension.equals("xlxs")) {
//                    list = this.getXlxs(is)
//                }
                orginalFile.transferTo(new File(filename))
                def args = ['uri': fileName]
                def result = invokeAcquireSynTrxApi('ISMSApp/procBatchTrx/parse', args)
//                def result = invokeAcquireSynTrxApi('/procBatchTrx/parse?uri=' + filename)
                if (result instanceof Map) {
                    if ("0".equals(result.response)) {
                        def args1 = ['authsts': 'N', 'batchnum': result.batchnum]
                        def res = invokeAcquireSynTrxApi('ISMSApp/procBatchTrx/syntrx', args1)
//                    def res = invokeAcquireSynTrxApi('ISMSApp/procBatchTrx/syntrx?authsts=N&batchnum=' + result.batchnum)
                        if (res instanceof Map) {
                            if ("0".equals(res.response)) {
                                flash.message = "上传操作成功！"
                                showList(bankName, df.format(new Date()))
                            } else {
                                flash.message = "上传失败${res.resmsg}"
                                showList(bankName, df.format(new Date()))
                            }
                        } else {
                            flash.message = "上传失败${res.resmsg}"
                            showList(bankName, df.format(new Date()))
                        }
                    } else {
                        flash.message = "上传失败${result.resmsg}"
                        showList(bankName, df.format(new Date()))
                    }
                } else {
                    flash.message = "上传操作失败！${result}"
                    showList(bankName, df.format(new Date()))
                }
            } else {
                redirect(action: "list")
                flash.message = "上传失败，请确认上传文件中格式跟模板一样，并且有相因数据！"
            }
        }
    }

    def showList(String bankName, String upDate) {
        params.sort = params.sort ? params.sort : "createDate"
        params.order = params.order ? params.order : "desc"
        params.max = Math.min(params.max ? params.int('max') : 10, 100)
        params.offset = params.offset ? params.int('offset') : 0
        def query = {
            ge('createDate', Date.parse('yyyyMMdd', upDate))
            le('createDate', Date.parse('yyyyMMdd', upDate) + 1)
            eq('acquireCode', bankName)
        }
        def total = AcquireSynTrx.createCriteria().count(query)
        def results = AcquireSynTrx.createCriteria().list(params, query)
        render(view: "list", model: [acquireSynTrxInstanceList: results, acquireSynTrxInstanceTotal: total])
    }
    //文件下载查看
    def showUpLoad = {
        params.sort = params.sort ? params.sort : "createDate"
        params.order = params.order ? params.order : "desc"
        params.max = Math.min(params.max ? params.int('max') : 10, 100)
        params.offset = params.offset ? params.int('offset') : 0
        def query = {
            if (params.upLoadDate != null && params.upLoadDate != '') {
                ge('createDate', Date.parse('yyyyMMdd', params.upLoadDate))
                le('createDate', Date.parse('yyyyMMdd', params.upLoadDate) + 1)
            }
            if (params.bankName != null && params.bankName != '') {
                eq('acquireCode', params.bankName)
            }
        }
        def total = AcquireSynTrx.createCriteria().count(query)
        def results = AcquireSynTrx.createCriteria().list(params, query)
        render(view: "list", model: [acquireSynTrxInstanceList: results, acquireSynTrxInstanceTotal: total])
    }

    def downloadList = {
        params.sort = params.sort ? params.sort : "createDate"
        params.order = params.order ? params.order : "desc"
        params.max =50000
        def query = {
            if (params.upLoadDate != null && params.upLoadDate != '') {
                ge('createDate', Date.parse('yyyyMMdd', params.upLoadDate))
                le('createDate', Date.parse('yyyyMMdd', params.upLoadDate) + 1)
            }
            if (params.bankName != null && params.bankName != '') {
                eq('acquireCode', params.bankName)
            }
        }
        def total = AcquireSynTrx.createCriteria().count(query)
        def results = AcquireSynTrx.createCriteria().list(params, query)
        def filename = 'Excel-' + new java.text.SimpleDateFormat("yyyyMMddHHmmss").format(new Date()) + '.xls'
        response.setHeader("Content-disposition", "attachment; filename=" + filename)
        response.contentType = "application/x-rarx-rar-compressed"
        response.setCharacterEncoding("UTF-8")
        render(template: "tradeList", model: [acquireSynTrxInstanceList: results])
//        render(view: "list", model: [acquireSynTrxInstanceList: results, acquireSynTrxInstanceTotal: total])
    }

    //银行查看
    def showGetBank = {
        params.sort = params.sort ? params.sort : "createDate"
        params.order = params.order ? params.order : "desc"
        params.max = Math.min(params.max ? params.int('max') : 10, 100)
        params.offset = params.offset ? params.int('offset') : 0
        def upLoadDate = params.upLoadDate
        def bankName = params.bankName
        def args = ['acqcode': bankName, 'acqdate': upLoadDate]
        def result = invokeAcquireSynTrxApi('ISMSApp/downAcqTrx/download', args)
//        def result = invokeAcquireSynTrxApi('ISMSApp/downAcqTrx/download?acqcode=' + bankName + '&acqdate=' + upLoadDate)
        if (result instanceof Map) {
            if ("0".equals(result.response)) {
                def args1 = ['authsts': 'N', 'batchnum': result.batchnum]
                def res = invokeAcquireSynTrxApi('ISMSApp/procBatchTrx/syntrx', args1)
                //def res = invokeAcquireSynTrxApi('ISMSApp/procBatchTrx/syntrx?authsts=N&batchnum=' + result.batchnum)
                if (res instanceof Map) {
                    if ("0".equals(res.response)) {
                        flash.message = "银行信息返回成功！"
                        showList(bankName, upLoadDate)
                    } else {
                        flash.message = "银行信息返回失败${res.resmsg}"
                        showList(bankName, upLoadDate)
                    }
                }
            } else {
                flash.message = "银行信息返回失败${result.resmsg}"
                showList(bankName, upLoadDate)
            }
        } else {
            flash.message = "银行信息返回失败！"
            showList(bankName, upLoadDate)
        }
    }

    def update = {
        def acquireSynTrxInstance = AcquireSynTrx.get(params.id)
        if (acquireSynTrxInstance) {
            if (params.version) {
                def version = params.version.toLong()
                if (acquireSynTrxInstance.version > version) {

                    acquireSynTrxInstance.errors.rejectValue("version", "default.optimistic.locking.failure", [message(code: 'acquireSynTrx.label', default: 'AcquireSynTrx')] as Object[], "Another user has updated this AcquireSynTrx while you were editing")
                    render(view: "edit", model: [acquireSynTrxInstance: acquireSynTrxInstance])
                    return
                }
            }
            acquireSynTrxInstance.properties = params
            if (!acquireSynTrxInstance.hasErrors() && acquireSynTrxInstance.save(flush: true)) {
                flash.message = "${message(code: 'default.updated.message', args: [message(code: 'acquireSynTrx.label', default: 'AcquireSynTrx'), acquireSynTrxInstance.id])}"
                redirect(action: "list")
            }
            else {
                render(view: "edit", model: [acquireSynTrxInstance: acquireSynTrxInstance])
            }
        }
        else {
            flash.message = "${message(code: 'default.not.found.message', args: [message(code: 'acquireSynTrx.label', default: 'AcquireSynTrx'), params.id])}"
            redirect(action: "list")
        }
    }

    def delete = {
        def acquireSynTrxInstance = AcquireSynTrx.get(params.id)
        if (acquireSynTrxInstance) {
            try {
                acquireSynTrxInstance.delete(flush: true)
                flash.message = "${message(code: 'default.deleted.message', args: [message(code: 'acquireSynTrx.label', default: 'AcquireSynTrx'), params.id])}"
                redirect(action: "list")
            }
            catch (org.springframework.dao.DataIntegrityViolationException e) {
                flash.message = "${message(code: 'default.not.deleted.message', args: [message(code: 'acquireSynTrx.label', default: 'AcquireSynTrx'), params.id])}"
                redirect(action: "show", id: params.id)
            }
        }
        else {
            flash.message = "${message(code: 'default.not.found.message', args: [message(code: 'acquireSynTrx.label', default: 'AcquireSynTrx'), params.id])}"
            redirect(action: "list")
        }
    }

    private invokeAcquireSynTrxApi(String _uri, Map _args) {
        log.info "invoke Acquire Syn Trx api: $_uri \n args:$_args"
        def result = ''
        println ContentType.JSON
        try {
            def http = new HTTPBuilder(ConfigurationHolder.config.gateway.inner.server)
            http.request(Method.POST, ContentType.JSON) { req ->
                uri.path = _uri
                send ContentType.URLENC, _args

                response.success = { resp, json ->
                    log.debug "response status: ${resp.statusLine}"
                    result = json
                }
            }
        } catch (e) {
            log.error e, e
            result = e.getMessage()
        }
        log.info "resp: $result"
        result
    }
}
