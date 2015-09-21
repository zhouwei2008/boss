package boss

import com.opensymphony.module.sitemesh.RequestConstants
import org.springframework.web.servlet.support.RequestContextUtils as RCU

class RendTagLib implements RequestConstants {
    def paginat = { attrs ->
        def writer = out
        if (attrs.total == null) {
            throwTagError("Tag [paginate] is missing required attribute [total]")
        }

        def messageSource = grailsAttributes.messageSource
        def locale = RCU.getLocale(request)
        def total = attrs.int('total') ?: 0
        def action = (attrs.action ? attrs.action : (params.action ? params.action : "list"))
        def offset = params.int('offset') ?: 0
        def max = params.int('max')
        def maxsteps = (attrs.int('maxsteps') ?: 10)

        if (!offset) offset = (attrs.int('offset') ?: 0)
        if (!max) max = (attrs.int('max') ?: 10)

        def linkParams = [:]
        if (attrs.params) linkParams.putAll(attrs.params)
        linkParams.offset = offset - max
        linkParams.max = max
        if (params.sort)
            linkParams.sort = params.sort
        else
            linkParams.sort = "id"
        if (params.order)
            linkParams.order = params.order
        else
            linkParams.order = "desc"

        def linkTagAttrs = [action: action]
        if (attrs.controller) {
            linkTagAttrs.controller = attrs.controller
        }
        if (attrs.id != null) {
            linkTagAttrs.id = attrs.id
        }
        if (attrs.fragment != null) {
            linkTagAttrs.fragment = attrs.fragment
        }
        linkTagAttrs.params = linkParams

        // determine paging variables
        def steps = maxsteps > 0
        int currentstep = (offset / max) + 1
        int firststep = 1
        int laststep = Math.round(Math.ceil(total / max))

        writer << "<span class=\"currentstep\">${currentstep}/${laststep}&nbsp;&nbsp;&nbsp;&nbsp;</span>"
        // display  firststep
        if (currentstep > firststep) {
            linkTagAttrs.class = 'firstLink'
            linkParams.offset = 0
            writer << link(linkTagAttrs.clone()) {
                (attrs.first ? attrs.first : messageSource.getMessage('paginate.first', null, messageSource.getMessage('default.paginate.first', null, 'First', locale), locale))
            }
        }
        // display previous link when not on firststep
        if (currentstep > firststep) {
            linkTagAttrs.class = 'prevLink'
            linkParams.offset = offset - max
            writer << link(linkTagAttrs.clone()) {
                (attrs.prev ?: messageSource.getMessage('paginate.prev', null, messageSource.getMessage('default.paginate.prev', null, 'Previous', locale), locale))
            }
        }

        // display steps when steps are enabled and laststep is not firststep
        if (steps && laststep > firststep) {
            linkTagAttrs.class = 'step'

            // determine begin and endstep paging variables
            int beginstep = currentstep - Math.round(maxsteps / 2) + (maxsteps % 2)
            int endstep = currentstep + Math.round(maxsteps / 2) - 1

            if (beginstep < firststep) {
                beginstep = firststep
                endstep = maxsteps
            }
            if (endstep > laststep) {
                beginstep = laststep - maxsteps + 1
                if (beginstep < firststep) {
                    beginstep = firststep
                }
                endstep = laststep
            }

            // display firststep link when beginstep is not firststep
            if (beginstep > firststep) {
                linkParams.offset = 0
                writer << link(linkTagAttrs.clone()) {firststep.toString()}
                writer << '<span class="step">..</span>'
            }

            // display paginate steps
            (beginstep..endstep).each { i ->
                if (currentstep == i) {
                    writer << "<span class=\"currentStep\">${i}</span>"
                }
                else {
                    linkParams.offset = (i - 1) * max
                    writer << link(linkTagAttrs.clone()) {i.toString()}
                }
            }

            // display laststep link when endstep is not laststep
            if (endstep < laststep) {
                writer << '<span class="step">..</span>'
                linkParams.offset = (laststep - 1) * max
                writer << link(linkTagAttrs.clone()) { laststep.toString() }
            }
        }

        // display next link when not on laststep
        if (currentstep < laststep) {
            linkTagAttrs.class = 'nextLink'
            linkParams.offset = offset + max
            writer << link(linkTagAttrs.clone()) {
                (attrs.next ? attrs.next : messageSource.getMessage('paginate.next', null, messageSource.getMessage('default.paginate.next', null, 'Next', locale), locale))
            }
        }
        //endstep
        if (currentstep < laststep) {
            linkTagAttrs.class = 'endLink'
            linkParams.offset = (laststep - 1) * max
            writer << link(linkTagAttrs.clone()) {
                (attrs.end ? attrs.end : messageSource.getMessage('paginate.end', null, messageSource.getMessage('default.paginate.end', null, 'End', locale), locale))
            }
        }
        //跳转到指定页
        def selectUrl=""
//        println params

        if(params.size()>0){
            params.each {
                if(it.value!=null && it.key!='offset'){
                    selectUrl+="&${it.key}=${it.value}"
                }

            }
        }
        if(laststep > 1){
            writer << """
                <input type="hidden" name="offset" id="offset" value="">
                <input type="hidden" name="max" id="max" value="${max}">
                <span class=\"currentStep\">跳转到第
                <select id="page" name="page" onchange="myUpdate('${request.getContextPath()}/${params.controller}/${params.action}','${selectUrl}','${max}')">"""

            for(int i=1;i<=laststep;i++)
            {
                if (currentstep == i) {
                    writer <<"<option value='${i}' selected>${i}</option>\n"
                }
                else {
                    writer << "<option value='${i}'>${i}</option>\n"
                }
            }
            writer <<"</select>页</span>"
        }
    }
}
