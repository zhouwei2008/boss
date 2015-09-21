package boss

import ismp.TbRiskControl
import ismp.TbRiskList

/**
 * Created by IntelliJ IDEA.
 * User: kevin
 * Date: 13-8-13
 * Time: 下午5:52
 * To change this template use File | Settings | File Templates.
 */
class RiskSynJob {

    def riskSynService

    static triggers = {
       simple name: 'riskSynTrigger', startDelay:1000, repeatInterval:10*1000
    }

     def execute() {
        log.info "auto riskSynTrigger job is running..."
       def rulelist = TbRiskControl.findAllByStatus("1");
            rulelist.each(){ item ->
                    riskSynService.inputdata(item);
           }
    }
}
