package boss

import org.codehaus.groovy.grails.commons.ConfigurationHolder

import javax.servlet.http.HttpSession


class LoginController {
    def sendService

    def index = {
        if (session.op) {
            render(view: "/index")
        } else {
            render(view: "/login")
        }
    }

    def login = {
        // verify captcha
       log.info("params.captcha:"+params.captcha+">>>>>>>session.captcha:"+session.captcha)
      // println("params.captcha:"+params.captcha+">>>>>>>session.captcha:"+session.captcha)
       if (!session.captcha?.isCorrect(params.captcha.toUpperCase())) {
            flash.message = "验证码错误！"
            redirect(view: "/login")
            return
       }

        //检查手机校验码
        def query={
            eq('useType','login')
            eq('parameter',params.account as String)
            eq('sendType','mobile')
            eq('isUsed',false)
            ge("timeExpired",new Date())
        }

        def boDynamicKeyList=BoDynamicKey.createCriteria().list([sort:"id",order:'desc'],query)
        def boDynamicKey=(boDynamicKeyList&&boDynamicKeyList.size()>0)?boDynamicKeyList.first():null
        if(grailsApplication.config.verifyCaptcha!='false'&&((!boDynamicKey)||(params.mobile_captcha!=boDynamicKey.verification))){
            flash.message = "手机验证码错误！"
            redirect(view: "/login")
            return
        }

//        def mcrypt_key_1=(String)session.getAttribute("mcrypt_key");
//        params.password=AESWithJCE.getResult(mcrypt_key_1,params.password);
//        session.removeAttribute("mcrypt_key");
        def op = BoOperator.findByAccount(params.account)
        if(!op){
           flash.message = "用户名或者密码错误！"
           log.info flash.message
           redirect(view: "/login")
           return
       }

       if(op.status=="locked"){
           flash.message = "对不起，您的账号已被锁定。"
           log.info flash.message
           redirect(view: "/login")
           return
       }

       if(op.status=="disabled"){
            flash.message = "对不起，您的账号已被停用。"
            log.info flash.message
            redirect(view: "/login")
            return
       }

       if(op.status=="deleted"){
            flash.message = "用户名或者密码错误！"
            log.info flash.message
            redirect(view: "/login")
            return
       }

        if (op && op.password == params.password.encodeAsSHA1()) {

            if(isLogonUser(op.id)){
//                flash.message = "对不起，该操作员已经登陆，不能重复登陆！"
//                log.info flash.message
//                redirect(view: "/login")
//                redirect(action: "compulsoryLogin",params: [op:op])
                render(view: "/compulsoryLogin", model: [op: op])
                return
            }
            request.getSession().setAttribute(LoginSessionListener.SESSION_LOGIN_NAME,op.id);

            session.op = op
            op.loginErrorTime = 0
            op.lastLoginTime = new Date()
            op.loginIp = request.getHeader('X-Real-IP') ? request.getHeader('X-Real-IP') : request.getRemoteAddr();
            op.save(flush: true, failOnError: true)

            def permList = []
            if (op.role && op.role.rolePerms) {
              op.role.rolePerms.each {
                permList.add(it.perm)
             }
            }
            def role = BoRole.findByRoleCode(op.roleSet)
           if (role != null) {
                def pids = role.permission_id
                def status = role.status
                if (pids && status.equals("1")) {
                   pids.split(',').each {
                        def proSts = BoPromission.get(it.toLong())
                       if (proSts?.status.equals("1")) {
                           permList.add(BoPromission.get(it.toLong()))
                       }
                    }
                }
            }
            boDynamicKey.timeUsed=new Date()
            boDynamicKey.isUsed=true
            boDynamicKey.save(flush: true)

            session.permList = permList
            redirect(action: "index")
            return
        } else {
            op.loginErrorTime++
            if(op.loginErrorTime>=5){
                op.status = "locked"
                op.lastLoginTime = new Date();
                op.save(flush: true, failOnError: true)
                flash.message = "对不起，您连续输入错误密码的次数已达到5次，您的账户已被锁定。"
            } else{
                flash.message = "用户名或者密码错误！"
            }
            log.info flash.message
            redirect(view: "/login")
            return
        }
    }

    def logout = {
        println("logout.......")
        session.setAttribute('op', null)
        session.setAttribute('permList', null)
//        session.setAttribute(LoginSessionListener.SESSION_LOGIN_NAME, null)
        session.removeAttribute(LoginSessionListener.SESSION_LOGIN_NAME)
        render(view: "/logout")
    }

    def isLogonUser(Long userId){
        Set<HttpSession> keys = LoginSessionListener.loginUser.keySet();
        for (HttpSession key : keys) {
            if (LoginSessionListener.loginUser.get(key).equals(userId)) {
                HttpSession session = (HttpSession)key
                session.invalidate()
                LoginSessionListener.loginUser.remove(key)
                return true;
            }
        }
        return false;
    }

    def compulsoryLogin = {

        render(view: "/compulsoryLogin",op:params.op)
    }

    def resetLogin = {
        def operatorId = params.id
        BoOperator op = BoOperator.findById(operatorId)

//        Iterator iter = LoginSessionListener.loginUser.entrySet().iterator();
//        while (iter.hasNext()) {
//            Map.Entry entry = (Map.Entry)iter.next();
//            Object key = entry.getKey();
//            Object val = entry.getValue();
//            if(((String)val).equals(Long.toString(op.id)) ){
//                LoginSessionListener.loginUser.remove(key);
//            }
//        }

        request.getSession().setAttribute(LoginSessionListener.SESSION_LOGIN_NAME,op.id);

        session.op = op
        op.loginErrorTime = 0
        op.lastLoginTime = new Date()
        op.loginIp = request.getHeader('X-Real-IP') ? request.getHeader('X-Real-IP') : request.getRemoteAddr();
        op.save(flush: true, failOnError: true)

        def permList = []
        if (op.role && op.role.rolePerms) {
            op.role.rolePerms.each {
                permList.add(it.perm)
            }
        }
        def role = BoRole.findByRoleCode(op.roleSet)
        if (role != null) {
            def pids = role.permission_id
            def status = role.status
            if (pids && status.equals("1")) {
                pids.split(',').each {
                    def proSts = BoPromission.get(it.toLong())
                    if (proSts?.status.equals("1")) {
                        permList.add(BoPromission.get(it.toLong()))
                    }
                }
            }
        }
        session.permList = permList
        redirect(action: "index")
        return
    }

    def sendMobileCaptcha={
        def account = params.account
        println("account:"+account)
        def boOperator = BoOperator.findByAccount(account,null)

        if(boOperator){
            def mobile_captcha=KeyUtils.getRandNumberKey(6)
            def boDynamicKey = new BoDynamicKey()
            boDynamicKey.boOperator = boOperator
            boDynamicKey.sendType='mobile'
            boDynamicKey.sendTo= boOperator.mobile
            boDynamicKey.parameter=account                                                                             //运算参数
            boDynamicKey.key=KeyUtils.getRandKey(8)                                                                      //动态口令
            boDynamicKey.procMethod='none'                                                                              //运算方法
            boDynamicKey.verification=mobile_captcha                                                                    //验证值，等于手机验证码
            boDynamicKey.timeExpired=new Date(System.currentTimeMillis()+180000)                                       //过期时间,设为3分钟后                                                                               //使用时间
            boDynamicKey.isUsed=false                                                                                  //是否使用过
            boDynamicKey.useType= "login"                                                                                //使用类型
            boDynamicKey.save(flush: true,failOnError:true)

            def content ='登陆确认：您本次登陆操作的验证码是'+mobile_captcha+'。【吉高】'
            println("content:"+content)

            def usrID = ConfigurationHolder.config.userId
            def usrPWD = ConfigurationHolder.config.userPwd
            sendService.sendSMS(boOperator.mobile,content,usrID,usrPWD)
            render "ok"
        }
    }
}
