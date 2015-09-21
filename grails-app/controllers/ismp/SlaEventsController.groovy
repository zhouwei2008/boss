package ismp

class SlaEventsController {

  def list = {
    params.sort = params.sort ? params.sort : "createdate"
    params.order = params.order ? params.order : "desc"
    params.max = Math.min(params.max ? params.int('max') : 10, 100)
    [result: SlaEvents.list(params), total: SlaEvents.count()]
  }

}