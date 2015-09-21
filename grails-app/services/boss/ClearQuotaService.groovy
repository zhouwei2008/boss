package boss

import groovy.sql.Sql
import ismp.CmCorporationInfo

/**
 * 商户每日交易累计笔数、每日交易金额、每月累计交易金额清零
 * User: zhenghf
 * Date: 13-8-16
 * Time: 上午9:41
 * To change this template use File | Settings | File Templates.
 */
class ClearQuotaService {

    def sql = ''
    static transactional = true
    def dataSource_ismp;
    def db;
    /**
     * 每日交易笔数累计清零
     */
    def clearQutorNumCount(){

        try {
            println("每日交易笔数累计清零 start")

            sql = """ update cm_corporation_info t set t.qutor_num_count='0' """
            db = new Sql(dataSource_ismp);
            db.execute(sql)

            println("每日交易金额累计清零 end")
        }catch (Exception e){
            log.warn("ClearQuotaService.clearQutorNumCount",e.printStackTrace())
            e.printStackTrace()
        }

    }

    /**
     * 每日交易金额累计清零
     * @return
     */
    def clearDayQutorCount(){
        try {
            println("每日交易金额累计清零 start")

            sql = """ update cm_corporation_info t set t.day_qutor_count='0' """
            db = new Sql(dataSource_ismp);
            db.execute(sql)

        }catch (Exception e){
            log.warn("ClearQuotaService.clearDayQutorCount",e.printStackTrace())
            e.printStackTrace()
        }

    }

    /**
     * 每月交易金额累计清零
     * @return
     */
    def clearMonthQutorCount(){
        try {
            println("每月交易金额累计清零")

            sql = """ update cm_corporation_info t set t.month_qutor_count='0' """
            db = new Sql(dataSource_ismp);
            db.execute(sql)

        }catch (Exception e){
            log.warn("ClearQuotaService.clearMonthQutorCount",e.printStackTrace())
            e.printStackTrace()
        }
    }
}
