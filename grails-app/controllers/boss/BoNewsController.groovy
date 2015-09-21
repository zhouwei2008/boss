package boss

class BoNewsController {

  static allowedMethods = [save: "POST", update: "POST", delete: "POST"]

  def index = {
    redirect(action: "list", params: params)
  }

  def list = {

    params.sort = params.sort ? params.sort : "dateCreated"
    params.order = params.order ? params.order : "desc"
    params.max = Math.min(params.max ? params.int('max') : 10, 100)
    params.offset = params.offset ? params.int('offset') : 0

    def query = {
      if (params['msgColumn'] != null) {
        eq('msgColumn', params.msgColumn)
      }
    }
    def total = BoNews.createCriteria().count(query)
    def results = BoNews.createCriteria().list(params, query)
    [boNewsInstanceList: results, boNewsInstanceTotal: total]
  }

  def create = {
    def boNewsInstance = new BoNews()
    boNewsInstance.properties = params
    return [boNewsInstance: boNewsInstance]
  }

  def save = {
    def boNewsInstance = new BoNews(params)
    boNewsInstance.publisher = session.op
    if (boNewsInstance.save(flush: true)) {
      flash.message = "${message(code: 'default.created.message', args: [message(code: 'boNews.label', default: 'BoNews'), boNewsInstance.id])}"
      redirect(action: "list", id: boNewsInstance.id)
    }
    else {
      render(view: "create", model: [boNewsInstance: boNewsInstance])
    }
  }

  def show = {
    def boNewsInstance = BoNews.get(params.id)
    if (!boNewsInstance) {
      flash.message = "${message(code: 'default.not.found.message', args: [message(code: 'boNews.label', default: 'BoNews'), params.id])}"
      redirect(action: "list")
    }
    else {
      [boNewsInstance: boNewsInstance]
    }
  }

  def edit = {
    def boNewsInstance = BoNews.get(params.id)
    if (!boNewsInstance) {
      flash.message = "${message(code: 'default.not.found.message', args: [message(code: 'boNews.label', default: 'BoNews'), params.id])}"
      redirect(action: "list")
    }
    else {
      return [boNewsInstance: boNewsInstance]
    }
  }

  def update = {
    def boNewsInstance = BoNews.get(params.id)
    if (boNewsInstance) {
      if (params.version) {
        def version = params.version.toLong()
        if (boNewsInstance.version > version) {

          boNewsInstance.errors.rejectValue("version", "default.optimistic.locking.failure", [message(code: 'boNews.label', default: 'BoNews')] as Object[], "Another user has updated this BoNews while you were editing")
          render(view: "edit", model: [boNewsInstance: boNewsInstance])
          return
        }
      }
      boNewsInstance.properties = params
      boNewsInstance.publisher = session.op
      if (!boNewsInstance.hasErrors() && boNewsInstance.save(flush: true)) {
        flash.message = "${message(code: 'default.updated.message', args: [message(code: 'boNews.label', default: 'BoNews'), boNewsInstance.id])}"
        redirect(action: "list")
      }
      else {
        render(view: "edit", model: [boNewsInstance: boNewsInstance])
      }
    }
    else {
      flash.message = "${message(code: 'default.not.found.message', args: [message(code: 'boNews.label', default: 'BoNews'), params.id])}"
      redirect(action: "list")
    }
  }

  def delete = {
    def boNewsInstance = BoNews.get(params.id)
    if (boNewsInstance) {
      try {
        boNewsInstance.delete(flush: true)
        flash.message = "${message(code: 'default.deleted.message', args: [message(code: 'boNews.label', default: 'BoNews'), params.id])}"
        redirect(action: "list")
      }
      catch (org.springframework.dao.DataIntegrityViolationException e) {
        flash.message = "${message(code: 'default.not.deleted.message', args: [message(code: 'boNews.label', default: 'BoNews'), params.id])}"
        redirect(action: "show", id: params.id)
      }
    }
    else {
      flash.message = "${message(code: 'default.not.found.message', args: [message(code: 'boNews.label', default: 'BoNews'), params.id])}"
      redirect(action: "list")
    }
  }
}
