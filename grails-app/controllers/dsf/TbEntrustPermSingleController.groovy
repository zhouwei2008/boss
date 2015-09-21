package dsf

import ismp.CmCustomer
import java.text.SimpleDateFormat

class TbEntrustPermSingleController {
    def agentService;
    def agentDownloadForExcelService;
    def index = { }

    def create = {
        def  bankNameList =  agentService.bankListNew();
        [tbEntrustPermInstance: new TbEntrustPerm(), bankNameList: bankNameList]
    }
    def showList = {
        params.max = Math.min(params.max ? params.int('max') : 50, 100)
        params.offset = params.offset ? params.int('offset') : 0
        params.sort = params.sort ? params.sort : "id"
        params.order = params.order ? params.order : "desc"

        def query =
        {
            //def cmCustomer

            //guonan update 2011-12-29
            validDated(params)
            //开户名
            if (params.cardname) {
                like("cardname", "%" + params.cardname + "%")
            }
            //开户银行
            if (params.accountname != null && params.accountname != "") {
                //拼接字符串
                // BoBankDic bankDic= BoBankDic.get(params.tradeAccountname as long)
                //eq("tradeAccountname",bankDic.name)
                // def  tradeAccountnameStr = TbAdjustBankCard.executeQuery();
                def bankNames = agentService.findTradeAccountnames(params.accountname);
                //println  bankNames;
                'in'("accountname", bankNames);
            }

            //开户账户
            if (params.cardnum) {
                eq("cardnum", params.cardnum)
            }
            //账户状态
            if (params.entrustStatus && params.entrustStatus != "-1") {
                eq("entrustStatus", params.entrustStatus)
            }

            //授权日期
            if (params.entrustStarttimeS) {
                ge("entrustStarttime", Date.parse("yyyy-MM-dd", params.entrustStarttimeS))
            }
            if (params.entrustStarttimeE) {
                lt("entrustStarttime", Date.parse("yyyy-MM-dd", params.entrustStarttimeE) + 1)
            }
            //账户类型
            if (params.accounttype && params.accounttype != "-1") {
                eq("accounttype", params.accounttype)
            }
            //是否生效 默认为是
            //if (params.entrustIsEffect) {
                eq("entrustIsEffect", params.entrustIsEffect==null||params.entrustIsEffect==''?'0':params.entrustIsEffect)
            //}

            //截止日期
            if (params.entrustEndtimeS) {
                ge("entrustEndtime", Date.parse("yyyy-MM-dd", params.entrustEndtimeS))
            }
            if (params.entrustEndtimeE) {
                lt("entrustEndtime", Date.parse("yyyy-MM-dd", params.entrustEndtimeE) + 1)
            }

            //所属商户编号，先以商户编号为准
            if (params.customerNo) {
                eq("customerNo", params.customerNo)
            } else {
                //如果没有输入商户编号，而输入的是商户名称
                if (params.customerName) {
                    def customerNos = CmCustomer.executeQuery("select customerNo from CmCustomer where name like '%"+params.customerName+"%'")
                    if (customerNos) {
                        'in'("customerNo", customerNos)
                    }else{
                        //如果没有此商户
                    eq("customerNo",params.customerName)

                    }
                } else {
                    //如果刚进入页面指定假的查询条件，快速反应页面
                    //eq("batchBizid","100000000000469")
                }
            }

        }

        def results = TbEntrustPerm.createCriteria().list(params, query)

        def summary = TbEntrustPerm.createCriteria().get {
            and query
//            eq('tradeType', 'payment')
            projections {
                rowCount()
            }
        }


        return [params:params,tbEntrustPermList: results, tbEntrustPermTotal: summary, bankNameList: agentService.bankListNew()]
        //redirect(action: "create", params: params)
    }
    /**
     * 保存代收商户授权信息
     */
    def save = {
        String message = "";
        String operatorName = session.op.name
        SimpleDateFormat dateFormat = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
        def tbEntrustPerm = new TbEntrustPerm()
        Date entrustStarttime = dateFormat.parse(params.entrustStarttime + " 00:00:00");
        Date entrustEndtime = dateFormat.parse(params.entrustEndtime + " 00:00:00");
        params.entrustStarttime = entrustStarttime
        params.entrustEndtime = entrustEndtime

//        tbEntrustPerm.entrustStarttime = dateFormat.parse(params.entrustStarttime+" 00:00:00");
//        tbEntrustPerm.entrustEndtime = dateFormat.parse(params.entrustEndtime+" 00:00:00");

        try {
            def results = TbEntrustPerm.findAllWhere(cardname: params.cardname, accountname: params.accountname, cardnum: params.cardnum, customerNo: params.customerNo);
            if (results) {
                tbEntrustPerm = results.get(0);

            }
            tbEntrustPerm.properties = params;
            tbEntrustPerm.operator = operatorName;
            tbEntrustPerm.createtime = new Date();
            tbEntrustPerm.save(flush: true, failOnError: true);
            message = "商户【" + params.customerName + "，编号：" + params.customerNo + "】代收授权账户保存成功！"
        } catch (Exception e) {
            log.error(e.message, e);
            message = "商户【" + params.customerName + "，编号：" + params.customerNo + "】代收授权账户保存失败！"
        }
        flash.message = message
        log.info message + "-商户编号：" + params.customerNo
        redirect(action: "create")
    }
    /**
     * 修改代收商户授权信息
     */
    def updateItem = {
        String tbEntrustPermId = params.tbEntrustPermId;
        def tbEntrustPerm = TbEntrustPerm.get(tbEntrustPermId as long );
         def  bankNameList =  agentService.bankListNew();
        return [tbEntrustPermInstance: tbEntrustPerm, bankNameList: bankNameList]
    }
    /**
     * 删除代收商户授权信息
     */
    def deleteItem = {
        String message = "";
        String customerNo = params.delCustomerNo;
        String tbEntrustPermId = params.delID;
        params.offset = params.delOffset ? params.int('delOffset') : 0
        try {

          int resCount =   TbEntrustPerm.executeUpdate("delete from TbEntrustPerm where id =" + tbEntrustPermId);
           if(resCount>0){
                 message = "商户" + customerNo + "代收授权删除成功！";
           }else{
                 message = "商户" + customerNo + "代收授权删除失败！";
           }
        } catch (Exception e) {
            log.error(e.message, e);
            message = "商户" + customerNo + "代收授权删除失败！";
        }
        flash.message = message
        log.info message
        redirect(action: "showList",params:params)
    }

    def edit = {
        withForm {
        String message = "";
        String operatorName = session.op.name
        SimpleDateFormat dateFormat = new SimpleDateFormat("yyyy-MM-dd");
        def tbEntrustPerm = TbEntrustPerm.get(params.id);
        Date entrustStarttime = dateFormat.parse(params.entrustStarttime);
        Date entrustEndtime = dateFormat.parse(params.entrustEndtime);
        params.entrustStarttime = entrustStarttime
        params.entrustEndtime = entrustEndtime

        try {
            //是否应当修改为别的记录
            def results = TbEntrustPerm.findAllWhere(cardname: params.cardname, accountname: params.accountname, cardnum: params.cardnum, customerNo: params.customerNo);
            if (results) {
                def tbEntrustPermHavent = results.get(0);
                //要修改的信息如果在库中已经存在
                if (tbEntrustPermHavent.id != tbEntrustPerm.id) {
                    flash.message = "商户【" + params.customerName + "，编号：" + params.customerNo + "】在系统中银行账号：" + params.cardnum + "已经授权，请确认！";
                    log.info "商户【" + params.customerName + "，编号：" + params.customerNo + "】在系统中银行账号：" + params.cardnum + "已经授权，请确认！";
                    render(view: "updateItem", model: [tbEntrustPermInstance: tbEntrustPerm, bankNameList: agentService.bankListNew()])
                    return
                }

            }
            tbEntrustPerm.properties = params;
            tbEntrustPerm.save(flush: true, failOnError: true);
            message = "代收授权账户修改成功！";
        } catch (Exception e) {
            log.error(e.message, e)
            message = "代收授权账户修改失败！";
        }
        flash.message = message
        log.info message + "-商户编号：" + params.customerNo
        render(view: "updateItem", model: [tbEntrustPermInstance: tbEntrustPerm, bankNameList: agentService.bankListNew()])
        return
        }.invalidToken {
        // bad request
        }


    }


     /**
     * 代收授权信息下载下载
     */
    def downloadTbEntrustPerm = {
        try{
            params.max = 50000 //最多5万条
            params.offset = 0
            params.sort = params.sort ? params.sort : "id"
            params.order = params.order ? params.order : "desc"
            //initParams(params)
            def res = agentService.queryTbEntrustPerm(params)
            def filename = 'Excel-' + new java.text.SimpleDateFormat("yyyyMMddHHmmss").format(new Date()) + '.xls'
            response.setHeader("Content-disposition", "attachment; filename=" + filename)
            response.contentType = "application/vnd.ms-excel"
            response.setCharacterEncoding("UTF-8")
            def wb = agentDownloadForExcelService.exportTbEntrustPerm(request,res.resList as List,Integer.parseInt(res.totalCount.toString()))
            wb.write(response.outputStream)
            response.outputStream.close()
        }catch (Throwable e){
            log.error("代收授权信息下载异常",e)
        }
    }

    /**
     * 异步获取商户信息
     */
    def getCustomerInfo = {
        def customer = CmCustomer.findByCustomerNo(params.customerNo)
        render(contentType: "text/json") {
            customerName = customer ? customer.name : ""
        }
    }

    /**
     * 验证日期间隔有效性
     *
     * @param params 表单参数
     * @return
     * @author guonan  2011-12-29
     *
     */
    def validDated(params) {
        //如果授权起始日期和截止日期均为空 默认为查询当天到前一个月
        if (params.entrustStarttimeS == null && params.entrustStarttimeE == null) {
            def gCalendar = new GregorianCalendar()
            params.entrustStarttimeE = gCalendar.time.format('yyyy-MM-dd')
            gCalendar.add(GregorianCalendar.MONTH, -1)
            params.entrustStarttimeS = gCalendar.time.format('yyyy-MM-dd')
        }
        //如果截止日期为空，默认为查询起始日期当天
        if (params.entrustStarttimeS && !params.entrustStarttimeE) {
            params.entrustStarttimeE = params.entrustStarttimeS
        }
        //如果起始日期为空，默认为查询截止日期当天
        if (!params.entrustStarttimeS && params.entrustStarttimeE) {
            params.entrustStarttimeS = params.entrustStarttimeE
        }
        /* //-----------验证截止时间 start----------
       //如果起始日期和截止日期均为空 默认为查询当天到前一个月
       if (params.entrustEndtimeS == null && params.entrustEndtimeE == null) {
           def gCalendar = new GregorianCalendar()
           params.entrustEndtimeE = gCalendar.time.format('yyyy-MM-dd')
           gCalendar.add(GregorianCalendar.MONTH, -1)
           params.entrustEndtimeS = gCalendar.time.format('yyyy-MM-dd')
       }
       //如果截止日期为空，默认为查询起始日期当天
       if (params.entrustEndtimeS && !params.entrustEndtimeE) {
           params.entrustEndtimeE = params.entrustEndtimeS
       }
       //如果起始日期为空，默认为查询截止日期当天
       if (!params.entrustEndtimeS && params.entrustEndtimeE) {
           params.entrustEndtimeS = params.entrustEndtimeE
       }
       //-----------验证截止时间 end----------*/

    }


}
