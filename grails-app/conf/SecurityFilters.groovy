import boss.BoOpLog
import boss.BoOpRelation
import static boss.BoOpRelation.*

class SecurityFilters {
  def filters = {
    loginCheck(controller: '*', action: '*') {
      before = {
        if (controllerName in ['login', 'captcha']) {
          return true
        }
        if (!session.op) {
          redirect(controller: "login", action: "logout")
          return false
        }
      }
    }

    //操作日志记录
    opLog(controller: '*', action: '*') {
      before = {
        //注销日志
        if (session.op && controllerName == 'login' && actionName=='logout') {
          saveLog(session, params, request)
          return true
        }
      }
      after = {
        //println "in log,controllerName:${controllerName},actionName:${actionName}"
        if (session.op && !['captcha'].contains(controllerName)) {
          //println "create log"
          //params.remove('controller')
          //params.remove('action')
          saveLog(session, params, request)
        }
        return true
      }
    }

  }

  def saveLog(session, params, request) {
    BoOpLog log = new BoOpLog()
    log.account = session.op.account
    log.controller = params.controller
    log.action = params.action
    log.ip = request.getHeader('X-Real-IP') ? request.getHeader('X-Real-IP') : request.getRemoteAddr();
    if (params.containsKey('password')) {
      params.password = '******'
    }
    if (params.containsKey('oldPass')) {
      params.oldPass = '******'
    }
    if (params.containsKey('newPass')) {
      params.newPass = '******'
    }
    log.params = params.toString()
    //BoOpRelation opRelation = BoOpRelation.findByActionsAndControllers(actionName,controllerName)

    //if(opRelation==null){
        BoOpRelation opRelation = new BoOpRelation()
        opRelation.controllers=params.controller
        opRelation.actions=params.action
        opRelation.names= params.controller+'.'+ params.action
        opRelation.save()
    //}
    //log.setOpRelation(opRelation)
    log.save()
  }
}