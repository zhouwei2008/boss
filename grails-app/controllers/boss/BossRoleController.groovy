package boss

import grails.converters.JSON

class BossRoleController {

  static allowedMethods = [save: "POST", update: "POST"]

  def index = {
    redirect(action: "list", params: params)
  }

  def list = {

     params.max = Math.min(params.max ? params.int('max') : 10, 100)
     [bossRoleInstanceList: BossRole.list(params), bossRoleInstanceTotal: BossRole.count()]

  }

  def create = {
    def bossRoleInstance = new BossRole()
    //bossRoleInstance.properties = params
    List permList = [];
    def jsonTree = getPermTree(Perm.ROOT, permList, false) as JSON
    return [bossRoleInstance: bossRoleInstance, permTree: jsonTree]
  }

  def save = {
    def bossRoleInstance = new BossRole(params)
    if (params.permLs) {
      def permLs = params.permLs.split(',')
      permLs.each {
        bossRoleInstance.addToRolePerms(new RolePerm([perm: Perm.valueOf(it)]))
      }
    }
    if (bossRoleInstance.save(flush: true)) {
      flash.message = "${message(code: 'default.created.message', args: [message(code: 'bossRole.label', default: 'BossRole'), bossRoleInstance.roleName])}"
      redirect(action: "list", id: bossRoleInstance.id)
    }
    else {
      render(view: "create", model: [bossRoleInstance: bossRoleInstance])
    }
  }

  def show = {
    def bossRoleInstance = BossRole.get(params.id)
    if (!bossRoleInstance) {
      flash.message = "${message(code: 'default.not.found.message', args: [message(code: 'bossRole.label', default: 'BossRole'), params.id])}"
      redirect(action: "list")
    }
    else {
      List permList = [];
      if (bossRoleInstance.rolePerms) {
        bossRoleInstance.rolePerms.each {
          permList.add(it.perm)
        }
      }

      def jsonTree = getPermTree(Perm.ROOT, permList, true) as JSON

      return [bossRoleInstance: bossRoleInstance, permTree: jsonTree]
    }
  }

  def edit = {
    def bossRoleInstance = BossRole.get(params.id)
    if (!bossRoleInstance) {
      flash.message = "${message(code: 'default.not.found.message', args: [message(code: 'bossRole.label', default: 'BossRole'), params.id])}"
      redirect(action: "list")
    }
    else {
      List permList = [];
      if (bossRoleInstance.rolePerms) {
        bossRoleInstance.rolePerms.each {
          permList.add(it.perm)
        }
      }

      def jsonTree = getPermTree(Perm.ROOT, permList, false) as JSON
      return [bossRoleInstance: bossRoleInstance, permTree: jsonTree]
    }
  }

  def update = {
    def bossRoleInstance = BossRole.get(params.id)
    if (bossRoleInstance) {
      if (params.version) {
        def version = params.version.toLong()
        if (bossRoleInstance.version > version) {

          bossRoleInstance.errors.rejectValue("version", "default.optimistic.locking.failure", [message(code: 'bossRole.label', default: 'BossRole')] as Object[], "Another user has updated this BossRole while you were editing")
          render(view: "edit", model: [bossRoleInstance: bossRoleInstance])
          return
        }
      }
      bossRoleInstance.properties = params
      def removePerms = []
      bossRoleInstance.rolePerms.each {
        removePerms.add(it)
      }
      removePerms.each {
        bossRoleInstance.removeFromRolePerms(it)
        it.delete()
      }
      if (params.permLs) {
        def permLs = params.permLs.split(',')
        permLs.each {
          bossRoleInstance.addToRolePerms(new RolePerm([perm: Perm.valueOf(it)]))
        }
      }
      if (!bossRoleInstance.hasErrors() && bossRoleInstance.save(flush: true)) {
        flash.message = "${message(code: 'default.updated.message', args: [message(code: 'bossRole.label', default: 'BossRole'), bossRoleInstance.roleName])}"
        redirect(action: "list")
      }
      else {
        render(view: "edit", model: [bossRoleInstance: bossRoleInstance])
      }
    }
    else {
      flash.message = "${message(code: 'default.not.found.message', args: [message(code: 'bossRole.label', default: 'BossRole'), params.id])}"
      redirect(action: "list")
    }
  }

  def delete = {
    def bossRoleInstance = BossRole.get(params.id)
    if (bossRoleInstance) {
      try {
        def boOperator = BoOperator.findByRole(bossRoleInstance)
        if(!boOperator){
            bossRoleInstance.delete(flush: true)
            flash.message = "${message(code: 'default.deleted.message', args: [message(code: 'bossRole.label', default: 'BossRole'), params.id])}"
        }else{
            flash.message = "${message(code: '该角色已有操作员，不能删除！', args: [message(code: 'bossRole.label', default: 'BossRole'), params.id])}"
        }
        redirect(action: "list")
      }
      catch (org.springframework.dao.DataIntegrityViolationException e) {
        flash.message = "${message(code: 'default.not.deleted.message', args: [message(code: 'bossRole.label', default: 'BossRole'), params.id])}"
        redirect(action: "show", id: params.id)
      }
    }
    else {
      flash.message = "${message(code: 'default.not.found.message', args: [message(code: 'bossRole.label', default: 'BossRole'), params.id])}"
      redirect(action: "list")
    }
  }

  /**
   * 生成权限树的JSON数据
   * @param node
   * @param permList 拥有的权限列表
   * @param ro 是否只读
   * @return
   */
  def getPermTree(Perm node, List<Perm> permList, boolean ro) {
    if (ro == true && node != Perm.ROOT && !permList.contains(node)) {
      return [:]
    }
//    def result = """{id : '${node.name()}',
//                    text : '${node.label}',
//                    value : '${node.label}',
//                    showcheck : ${(node == Perm.ROOT || ro == true) ? 'false' : 'true'},
//                    complete : true,
//                    isexpand : ${node.parent == Perm.ROOT ? 'false' : 'true'},
//                    checkstate : ${permList.contains(node) ? '1' : '0'},
//                    """
    def result = [id : node.name(),
                  text : node.label,
                  value : node.label,
                  showcheck : (node == Perm.ROOT || ro == true) ? false : true,
                  complete : true,
                  isexpand : node.parent == Perm.ROOT ? false : true,
                  checkstate : permList.contains(node) ? 1 : 0]

    if (node.children && node.children.size() > 0) {
      result.put('hasChildren', true)
      def childNodes = []
      for (int i = 0; i < node.children.size(); i++) {
        def child = getPermTree(node.children.get(i), permList, ro)
        if (child) {
          childNodes.add(child)
        }
      }
      result.put('ChildNodes', childNodes)
    } else {
      result.put('hasChildren', false)
    }
    return result
  }
}
