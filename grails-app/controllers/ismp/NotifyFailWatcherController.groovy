package ismp

class NotifyFailWatcherController {

    static allowedMethods = [save: "POST", update: "POST", delete: "POST"]

    def index = {
        redirect(action: "list", params: params)
    }

    def list = {
        params.max = Math.min(params.max ? params.int('max') : 10, 100)
        [notifyFailWatcherInstanceList: NotifyFailWatcher.list(params), notifyFailWatcherInstanceTotal: NotifyFailWatcher.count()]
    }

    def create = {
        def notifyFailWatcherInstance = new NotifyFailWatcher()
        notifyFailWatcherInstance.properties = params
        return [notifyFailWatcherInstance: notifyFailWatcherInstance]
    }

    def save = {
        def notifyFailWatcherInstance = new NotifyFailWatcher(params)
        if (notifyFailWatcherInstance.save(flush: true)) {
            flash.message = "通知名单 ${notifyFailWatcherInstance.name} 已创建"
            redirect(action: "list", id: notifyFailWatcherInstance.id)
        }
        else {
            render(view: "create", model: [notifyFailWatcherInstance: notifyFailWatcherInstance])
        }
    }

    def show = {
        def notifyFailWatcherInstance = NotifyFailWatcher.get(params.id)
        if (!notifyFailWatcherInstance) {
            flash.message = "${message(code: 'default.not.found.message', args: [message(code: 'notifyFailWatcher.label', default: '通知名单'), params.id])}"
            redirect(action: "list")
        }
        else {
            [notifyFailWatcherInstance: notifyFailWatcherInstance]
        }
    }

    def edit = {
        def notifyFailWatcherInstance = NotifyFailWatcher.get(params.id)
        if (!notifyFailWatcherInstance) {
            flash.message = "${message(code: 'default.not.found.message', args: [message(code: 'notifyFailWatcher.label', default: '通知名单'), params.id])}"
            redirect(action: "list")
        }
        else {
            return [notifyFailWatcherInstance: notifyFailWatcherInstance]
        }
    }

    def update = {
        def notifyFailWatcherInstance = NotifyFailWatcher.get(params.id)
        if (notifyFailWatcherInstance) {
            if (params.version) {
                def version = params.version.toLong()
                if (notifyFailWatcherInstance.version > version) {
                    
                    notifyFailWatcherInstance.errors.rejectValue("version", "default.optimistic.locking.failure", [message(code: 'notifyFailWatcher.label', default: '通知名单')] as Object[], "Another user has updated this NotifyFailWatcher while you were editing")
                    render(view: "edit", model: [notifyFailWatcherInstance: notifyFailWatcherInstance])
                    return
                }
            }
            notifyFailWatcherInstance.properties = params
            if (!notifyFailWatcherInstance.hasErrors() && notifyFailWatcherInstance.save(flush: true)) {
                flash.message = "${message(code: 'default.updated.message', args: [message(code: 'notifyFailWatcher.label', default: '通知名单'), notifyFailWatcherInstance.name])}"
                redirect(action: "list")
            }
            else {
                render(view: "edit", model: [notifyFailWatcherInstance: notifyFailWatcherInstance])
            }
        }
        else {
            flash.message = "${message(code: 'default.not.found.message', args: ["通知名单", params.id])}"
            redirect(action: "list")
        }
    }

    def delete = {
        def notifyFailWatcherInstance = NotifyFailWatcher.get(params.id)
        if (notifyFailWatcherInstance) {
            try {
                notifyFailWatcherInstance.delete(flush: true)
                flash.message = "${message(code: 'default.deleted.message', args: [message(code: 'notifyFailWatcher.label', default: '通知名单'), params.id])}"
                redirect(action: "list")
            }
            catch (org.springframework.dao.DataIntegrityViolationException e) {
                flash.message = "${message(code: 'default.not.deleted.message', args: [message(code: 'notifyFailWatcher.label', default: '通知名单'), params.id])}"
                redirect(action: "show", id: params.id)
            }
        }
        else {
            flash.message = "${message(code: 'default.not.found.message', args: ["通知名单", params.id])}"
            redirect(action: "list")
        }
    }
}
