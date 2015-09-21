package boss

import java.text.SimpleDateFormat
import java.text.DateFormat

class ReChargeEndTimeController {

   static allowedMethods = [save: "POST", update: "POST", delete: "POST"]




    def index = {
        redirect(action: "list", params: params)
    }

    def list = {
        params.max = Math.min(params.max ? params.int('max') : 10, 100)
        def list =  BoRechargeTime.list(params);
        [boRechargeTimeInstanceList:list ,boRechargeTimeInstanceTotal: BoRechargeTime.count()]
    }

     def create = {
        def boRechargeTime = new BoRechargeTime()
        boRechargeTime.properties = params
        return [boRechargeTime: boRechargeTime]
    }

    def save = {
        def op = session.getValue("op")
        def boRechargeTime1 = new BoRechargeTime(params)
        def boRechargeTime2 = new BoRechargeTime(params)
        def boBranchCom = BoBranchCompany.get(session.op.branchCompany)
        if(boBranchCom!=null){
            boRechargeTime1.branchCode = boBranchCom.id
            boRechargeTime1.branchName = boBranchCom.companyName
            boRechargeTime2.branchCode = boBranchCom.id
            boRechargeTime2.branchName = boBranchCom.companyName
        }
        def str = generateOrderID();//标志位，表示开始时间跟结束时间是一对
         boRechargeTime1.allowdate =str
         boRechargeTime1.allowHour=   params.startHour
         boRechargeTime1.allowMits=   params.startMin
         boRechargeTime1.dateCode='startTime'
         boRechargeTime2.allowdate =str
         boRechargeTime2.allowHour=    params.endHour
         boRechargeTime2.allowMits=   params.endMin
         boRechargeTime2.dateCode = 'endTime'
        boolean  flag=false
        if (boRechargeTime1.save(flush: true)) {
            flag = true
        }
         if (boRechargeTime2.save(flush: true)) {
             flag = true
        }
        if(flag){
            flash.message = "${message(code: 'default.created.message', args: [message(code: 'boRechargeTime.label', default: 'BoRechargeTime'), boRechargeTime1.id])}"
            redirect(action: "list", id: boRechargeTime1.id)
        } else{
            render(view: "create", model: [boRechargeTime: boRechargeTime1])
        }
    }

    def edit = {
        def boRechargeTime = BoRechargeTime.get(params.id)
        if (!boRechargeTime) {
            flash.message = "${message(code: 'default.not.found.message', args: [message(code: 'boRechargeTime.label', default: 'BoRechargeTime'), params.id])}"
            redirect(action: "list")
        }
        else {
            def boRechargeTimeForEnd
            def allowdate = boRechargeTime.allowdate;
            def datecode
              if(boRechargeTime.dateCode.equals("startTime")){
                   datecode='endTime'
              }else{
                   datecode='startTime'
              }
              def boRechargeTimeForEndlist = BoRechargeTime.findAllByAllowdateAndDateCode(allowdate,datecode);
            if(boRechargeTimeForEndlist!=null){
              boRechargeTimeForEnd = boRechargeTimeForEndlist[0];
            }
            [boRechargeTime: boRechargeTime,boRechargeTimeForEnd:boRechargeTimeForEnd]
        }
    }

    def editSave = {
        def boRechargeTime = BoRechargeTime.get(params.id);
        def boRechargeTimeInstance = BoRechargeTime.get(params.endID);
         boRechargeTime.allowHour=   params.allowHour
         boRechargeTime.allowMits=   params.allowMits

        boRechargeTimeInstance.status=  Integer.valueOf(params.status.toString()).toInteger();
        boRechargeTime.status=Integer.valueOf(params.status.toString()).toInteger();
        boRechargeTimeInstance.save(flush: true);
        if (boRechargeTime.save(flush: true)) {
           flash.message = "${message(code: 'default.created.message', args: [message(code: 'boOffineCharge.label', default: 'BoRechargeTime'), boRechargeTime.id])}"
            redirect(action: "list", id: boRechargeTime.id)
        } else{
            render(view: "create", model: [boRechargeTime: boRechargeTime])
        }
    }

     def  generateOrderID={
		String str="";
		Random rd=new Random();
        java.text.SimpleDateFormat sdf=new java.text.SimpleDateFormat("yyyyMMdd");
        Date date = new Date();
		for(int i=0;i<3;i++) str+=rd.nextInt(10);
		rd=null;
		return sdf.format(date)+str;
	}

}
