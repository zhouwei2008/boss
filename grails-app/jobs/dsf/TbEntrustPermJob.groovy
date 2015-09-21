package dsf

/**
 * Created by IntelliJ IDEA.
 * User: xypeng
 * Date: 12-6-18
 * Time: 上午9:40
 * To change this template use File | Settings | File Templates.
 */
class TbEntrustPermJob {
    def tbEntrustPermsImportService
    static triggers = {
        cron name: 'tbEntrustPermJob', cronExpression: "0 10/5 0 * * ?"
    }

    def execute() {
        log.error("tbEntrustPermJob start -- ${new Date()}")
        try {
            tbEntrustPermsImportService.updateEntrustIsEffect()
        }catch (Throwable e){
            log.error("",e)
        }
        log.error("tbEntrustPermJob end -- ${new Date()}")
    }
}
