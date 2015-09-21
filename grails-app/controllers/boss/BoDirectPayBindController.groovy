package boss

import ismp.CmCorporationInfo
import org.springframework.orm.hibernate3.HibernateTemplate
import org.hibernate.Session
import org.hibernate.transform.AliasToEntityMapResultTransformer
import org.springframework.orm.hibernate3.HibernateCallback
import com.burtbeckwith.grails.plugin.datasources.DatasourcesUtils
import groovy.sql.Sql

class BoDirectPayBindController {

    static allowedMethods = [save: "POST", update: "POST", delete: "POST"]
    def dataSource_ismp
    def index = {
        redirect(action: "list", params: params)
    }

    def list = {
        String accountNo = ''
        String customerNo = ''
        params.max = Math.min(params.max ? params.int('max') : 10, 100)
        params.offset = params.offset ? params.int('offset') : 0
        if(params.customerNo)
           customerNo = params.customerNo
        if(params.accountNo)
           accountNo = params.accountNo
        def query = {
           eq("payCustomerNo",customerNo)
        }
        def total = BoDirectPayBind.createCriteria().count(query)
        def results = BoDirectPayBind.createCriteria().list(params, query)
        [boDirectPayBindInstanceList: results, boDirectPayBindInstanceTotal: total, customerNo: customerNo, accountNo: accountNo]
    }

    def create = {
        String pAccountNo = ''
        String pCustomerNo = ''
        def boDirectPayBindInstance = new BoDirectPayBind()
        boDirectPayBindInstance.properties = params
        if(params.pCustomerNo)
           pCustomerNo = params.pCustomerNo
        if(params.pAccountNo)
           pAccountNo = params.pAccountNo
        return [boDirectPayBindInstance: boDirectPayBindInstance, pCustomerNo: pCustomerNo, pAccountNo: pAccountNo]
    }

    def save = {
        String accountNo = ''
        String customerNo = ''
        def boDirectPayBindInstance = new BoDirectPayBind(params)
        accountNo = params.pAccountNo
        customerNo = params.pCustomerNo
        boDirectPayBindInstance.accountNo = params.pAccountNo
        boDirectPayBindInstance.payCustomerNo = params.pCustomerNo
        boDirectPayBindInstance.customerNo = params.customerNo
        //boDirectPayBindInstance.limiteAmount = Double.parseDouble(params.limiteAmount)

        if (boDirectPayBindInstance.save(flush: true)) {
            flash.message = "${message(code: 'default.created.message', args: [message(code: 'boDirectPayBind.label', default: 'BoDirectPayBind'), boDirectPayBindInstance.id])}"
            redirect(action: "list", id: boDirectPayBindInstance.id, params:[customerNo: customerNo, accountNo: accountNo])
        }
        else {
            render(view: "create", model: [boDirectPayBindInstance: boDirectPayBindInstance, customerNo: customerNo, accountNo: accountNo])
        }
    }

    def show = {
        def boDirectPayBindInstance = BoDirectPayBind.get(params.id)
        if (!boDirectPayBindInstance) {
            flash.message = "${message(code: 'default.not.found.message', args: [message(code: 'boDirectPayBind.label', default: 'BoDirectPayBind'), params.id])}"
            redirect(action: "list")
        }
        else {
            [boDirectPayBindInstance: boDirectPayBindInstance]
        }
    }

    def edit = {
        def boDirectPayBindInstance = BoDirectPayBind.get(params.id)
        if (!boDirectPayBindInstance) {
            flash.message = "${message(code: 'default.not.found.message', args: [message(code: 'boDirectPayBind.label', default: 'BoDirectPayBind'), params.id])}"
            redirect(action: "list",params:[customerNo: boDirectPayBindInstance?.payCustomerNo, accountNo:boDirectPayBindInstance?.accountNo])
        }
        else {
            return [boDirectPayBindInstance: boDirectPayBindInstance]
        }
    }

    def update = {
        def boDirectPayBindInstance = BoDirectPayBind.get(params.id)
        if (boDirectPayBindInstance) {
            if (params.version) {
                def version = params.version.toLong()
                if (boDirectPayBindInstance.version > version) {
                    
                    boDirectPayBindInstance.errors.rejectValue("version", "default.optimistic.locking.failure", [message(code: 'boDirectPayBind.label', default: 'BoDirectPayBind')] as Object[], "Another user has updated this BoDirectPayBind while you were editing")
                    render(view: "edit", model: [boDirectPayBindInstance: boDirectPayBindInstance])
                    return
                }
            }
            boDirectPayBindInstance.properties = params
            if (!boDirectPayBindInstance.hasErrors() && boDirectPayBindInstance.save(flush: true)) {
                flash.message = "${message(code: 'default.updated.message', args: [message(code: 'boDirectPayBind.label', default: 'BoDirectPayBind'), boDirectPayBindInstance.id])}"
                redirect(action: "list",params:[customerNo: boDirectPayBindInstance?.payCustomerNo, accountNo:boDirectPayBindInstance?.accountNo])
            }
            else {
                render(view: "edit", model: [boDirectPayBindInstance: boDirectPayBindInstance])
            }
        }
        else {
            flash.message = "${message(code: 'default.not.found.message', args: [message(code: 'boDirectPayBind.label', default: 'BoDirectPayBind'), params.id])}"
            redirect(action: "list",params:[customerNo: boDirectPayBindInstance?.payCustomerNo,accountNo:boDirectPayBindInstance?.accountNo])
        }
    }

    def delete = {
        def boDirectPayBindInstance = BoDirectPayBind.get(params.id)
        if (boDirectPayBindInstance) {
            try {
                boDirectPayBindInstance.delete(flush: true)
                flash.message = "${message(code: 'default.deleted.message', args: [message(code: 'boDirectPayBind.label', default: 'BoDirectPayBind'), params.id])}"
                redirect(action: "list")
            }
            catch (org.springframework.dao.DataIntegrityViolationException e) {
                flash.message = "${message(code: 'default.not.deleted.message', args: [message(code: 'boDirectPayBind.label', default: 'BoDirectPayBind'), params.id])}"
                redirect(action: "show", id: params.id)
            }
        }
        else {
            flash.message = "${message(code: 'default.not.found.message', args: [message(code: 'boDirectPayBind.label', default: 'BoDirectPayBind'), params.id])}"
            redirect(action: "list")
        }
    }

    def popCustomer = {
        def pCustomerNo = params.pCustomerNo
        params.max = Math.min(params.max ? params.int('max') : 10, 100)
        params.offset = params.offset ? params.int('offset') : 0
        def customerNo = params.customerNo
        def name = params.name
        def sql = new Sql(dataSource_ismp)
        def queryWhere = ""
        if (customerNo) {
            queryWhere = " and cm.customer_no like '%"+customerNo+"%'"
        }
        if (name) {
            queryWhere = " and cm.name like '%"+name+"%'"
        }
        def queryParam = []
        def query = """ select cm.customer_no as customer_no, cm.name as name from ismp.cm_customer cm where
            cm.type='C' and cm.status='normal' and cm.account_no is not null and cm.account_no!='null' and not exists
            (select t.customer_no from boss.BO_DIRECT_PAY_BIND t  where t.pay_customer_no ='"""+pCustomerNo+"""'
            and cm.customer_no = t.customer_no )  and cm.customer_no !='"""+pCustomerNo+"""'"""+queryWhere

        def count = sql.firstRow("select count(*) total from (${query})", queryParam)
        HibernateTemplate ht = DatasourcesUtils.newHibernateTemplate('ismp')
        def result = ht.executeFind({ Session session ->
              def sqlquery = session.createSQLQuery(query.toString())
              sqlquery.setResultTransformer(AliasToEntityMapResultTransformer.INSTANCE)
              for (def i = 0;i < queryParam.size(); i++) {
                 sqlquery.setParameter(i, queryParam.get(i))
              }
              return sqlquery.setFirstResult(params.offset).setMaxResults(params.max).list();
        } as HibernateCallback)
        [cmCustomerInstanceList: result, cmCustomerInstanceTotal: count.total, pCustomerNo: pCustomerNo]
    }
}
