package ismp

import ismp.ChannelRouteByAmount

class ChannelRouteByAmountController {

    static allowedMethods = [save: "POST", update: "POST", delete: "POST"]
    def dataSource_ismp

    def index = {
        redirect(action: "list", params: params)
    }

    def list = {

        def dbismp =  new groovy.sql.Sql(dataSource_ismp)

                     def b2clistSql = """select t.id as key,
                                     t.acquire_indexc ,
                                     t.bankid,
                                     t.acquire_indexc　|| case
                                       when t.channel_type = '2' and t.PAYMENT_MODE = '1' then
                                        '--B2B贷记'
                                       when t.channel_type = '2' and t.PAYMENT_MODE = '0' then
                                        '--B2B借记'
                                       when t.channel_type = '2' and t.PAYMENT_MODE = '2' then
                                        '--B2B全通道'
                                       when t.channel_type = '1' and t.PAYMENT_MODE = '0' then
                                        '--B2C借记'
                                       when t.channel_type = '1' and t.PAYMENT_MODE = '1' then
                                        '--B2C贷记'
                                       when t.channel_type = '1' and t.PAYMENT_MODE = '2' then
                                        '--B2C全通道'
                                     END value
                                from gwchannel t
                               where t.acquire_indexc not like '%-%'
                                    --and t.channel_type = '2'
                                 and t.bank_type = '1'
                                 and t.channel_sts = 0
                                 and t.channel_type in ('2', '1')
                              """;
                 def b2cchannellist =  dbismp.rows(b2clistSql)


        params.max = Math.min(params.max ? params.int('max') : 10, 100)
        def count=1;
        [count:count,channelRouteByAmountInstanceList: ChannelRouteByAmount.listOrderByCreateTime(params), channelRouteByAmountInstanceTotal: ChannelRouteByAmount.count(),b2cchannellist:b2cchannellist]
    }

    def create = {
        def channelRouteByAmountInstance = new ChannelRouteByAmount()
        channelRouteByAmountInstance.properties = params

        def dbismp =  new groovy.sql.Sql(dataSource_ismp)

               def b2clistSql = """select t.id as key,
                               t.acquire_indexc ,
                               t.bankid,
                               t.acquire_indexc　|| case
                                 when t.channel_type = '2' and t.PAYMENT_MODE = '1' then
                                  '--B2B贷记'
                                 when t.channel_type = '2' and t.PAYMENT_MODE = '0' then
                                  '--B2B借记'
                                 when t.channel_type = '2' and t.PAYMENT_MODE = '2' then
                                  '--B2B全通道'
                                 when t.channel_type = '1' and t.PAYMENT_MODE = '0' then
                                  '--B2C借记'
                                 when t.channel_type = '1' and t.PAYMENT_MODE = '1' then
                                  '--B2C贷记'
                                 when t.channel_type = '1' and t.PAYMENT_MODE = '2' then
                                  '--B2C全通道'
                               END value
                          from gwchannel t
                         where t.acquire_indexc not like '%-%'
                              --and t.channel_type = '2'
                           and t.bank_type = '1'
                           and t.channel_sts = 0
                           and t.channel_type in ('2', '1')
                        """;
           def b2cchannellist =  dbismp.rows(b2clistSql)

        return [channelRouteByAmountInstance: channelRouteByAmountInstance,b2cchannellist:b2cchannellist]
    }

    def save = {
        def channelRouteByAmountInstance = new ChannelRouteByAmount(params)
        channelRouteByAmountInstance.setCreateTime new Date()
        channelRouteByAmountInstance.setUpdateTime  new Date()
        channelRouteByAmountInstance.setOpName   session.op.name
//               channelRouteByAmountInstance.setOpName  'admin'
        if (channelRouteByAmountInstance.save(flush: true)) {
            flash.message = "${message(code: 'default.created.message', args: [message(code: 'channelRouteByAmount.label', default: 'ChannelRouteByAmount'), channelRouteByAmountInstance.id])}"
            redirect(action: "list", id: channelRouteByAmountInstance.id)
        }
        else {
            render(view: "create", model: [channelRouteByAmountInstance: channelRouteByAmountInstance])
        }
    }

    def show = {
        def channelRouteByAmountInstance = ChannelRouteByAmount.get(params.id)
        if (!channelRouteByAmountInstance) {
            flash.message = "${message(code: 'default.not.found.message', args: [message(code: 'channelRouteByAmount.label', default: 'ChannelRouteByAmount'), params.id])}"
            redirect(action: "list")
        }
        else {


              def dbismp =  new groovy.sql.Sql(dataSource_ismp)

               def b2clistSql = """select t.id as key,
                               t.acquire_indexc ,
                               t.bankid,
                               t.acquire_indexc　|| case
                                 when t.channel_type = '2' and t.PAYMENT_MODE = '1' then
                                  '--B2B贷记'
                                 when t.channel_type = '2' and t.PAYMENT_MODE = '0' then
                                  '--B2B借记'
                                 when t.channel_type = '2' and t.PAYMENT_MODE = '2' then
                                  '--B2B全通道'
                                 when t.channel_type = '1' and t.PAYMENT_MODE = '0' then
                                  '--B2C借记'
                                 when t.channel_type = '1' and t.PAYMENT_MODE = '1' then
                                  '--B2C贷记'
                                 when t.channel_type = '1' and t.PAYMENT_MODE = '2' then
                                  '--B2C全通道'
                               END value
                          from gwchannel t
                         where t.acquire_indexc not like '%-%'
                              --and t.channel_type = '2'
                           and t.bank_type = '1'
                           and t.channel_sts = 0
                           and t.channel_type in ('2', '1')
                        """;
           def b2cchannellist =  dbismp.rows(b2clistSql)

            [channelRouteByAmountInstance: channelRouteByAmountInstance,b2cchannellist:b2cchannellist]
        }
    }

    def edit = {
        def channelRouteByAmountInstance = ChannelRouteByAmount.get(params.id)

        if (!channelRouteByAmountInstance) {
            flash.message = "${message(code: 'default.not.found.message', args: [message(code: 'channelRouteByAmount.label', default: 'ChannelRouteByAmount'), params.id])}"
            redirect(action: "list")
        }
        else {

                  def dbismp =  new groovy.sql.Sql(dataSource_ismp)

               def b2clistSql = """select t.id as key,
                               t.acquire_indexc ,
                               t.bankid,
                               t.acquire_indexc　|| case
                                 when t.channel_type = '2' and t.PAYMENT_MODE = '1' then
                                  '--B2B贷记'
                                 when t.channel_type = '2' and t.PAYMENT_MODE = '0' then
                                  '--B2B借记'
                                 when t.channel_type = '2' and t.PAYMENT_MODE = '2' then
                                  '--B2B全通道'
                                 when t.channel_type = '1' and t.PAYMENT_MODE = '0' then
                                  '--B2C借记'
                                 when t.channel_type = '1' and t.PAYMENT_MODE = '1' then
                                  '--B2C贷记'
                                 when t.channel_type = '1' and t.PAYMENT_MODE = '2' then
                                  '--B2C全通道'
                               END value
                          from gwchannel t
                         where t.acquire_indexc not like '%-%'
                              --and t.channel_type = '2'
                           and t.bank_type = '1'
                           and t.channel_sts = 0
                           and t.channel_type in ('2', '1')
                        """;
           def b2cchannellist =  dbismp.rows(b2clistSql)
            return [channelRouteByAmountInstance: channelRouteByAmountInstance,b2cchannellist:b2cchannellist]
        }
    }

    def update = {
        def channelRouteByAmountInstance = ChannelRouteByAmount.get(params.id)
                 channelRouteByAmountInstance.setUpdateTime new Date()
        channelRouteByAmountInstance.setOpName  session.op.name
//             channelRouteByAmountInstance.setOpName  'admin'
        if (channelRouteByAmountInstance) {
            if (params.version) {
                def version = params.version.toLong()
                if (channelRouteByAmountInstance.version > version) {
                    
                    channelRouteByAmountInstance.errors.rejectValue("version", "default.optimistic.locking.failure", [message(code: 'channelRouteByAmount.label', default: 'ChannelRouteByAmount')] as Object[], "Another user has updated this ChannelRouteByAmount while you were editing")
                    render(view: "edit", model: [channelRouteByAmountInstance: channelRouteByAmountInstance])
                    return
                }
            }
            channelRouteByAmountInstance.properties = params
            if (!channelRouteByAmountInstance.hasErrors() && channelRouteByAmountInstance.save(flush: true)) {
                flash.message = "${message(code: 'default.updated.message', args: [message(code: 'channelRouteByAmount.label', default: 'ChannelRouteByAmount'), channelRouteByAmountInstance.id])}"
                redirect(action: "list")
            }
            else {
                render(view: "edit", model: [channelRouteByAmountInstance: channelRouteByAmountInstance])
            }
        }
        else {
            flash.message = "${message(code: 'default.not.found.message', args: [message(code: 'channelRouteByAmount.label', default: 'ChannelRouteByAmount'), params.id])}"
            redirect(action: "list")
        }
    }

    def delete = {
        def channelRouteByAmountInstance = ChannelRouteByAmount.get(params.id)
        if (channelRouteByAmountInstance) {
            try {
                channelRouteByAmountInstance.delete(flush: true)
                flash.message = "${message(code: 'default.deleted.message', args: [message(code: 'channelRouteByAmount.label', default: 'ChannelRouteByAmount'), params.id])}"
                redirect(action: "list")
            }
            catch (org.springframework.dao.DataIntegrityViolationException e) {
                flash.message = "${message(code: 'default.not.deleted.message', args: [message(code: 'channelRouteByAmount.label', default: 'ChannelRouteByAmount'), params.id])}"
                redirect(action: "show", id: params.id)
            }
        }
        else {
            flash.message = "${message(code: 'default.not.found.message', args: [message(code: 'channelRouteByAmount.label', default: 'ChannelRouteByAmount'), params.id])}"
            redirect(action: "list")
        }
    }
}
