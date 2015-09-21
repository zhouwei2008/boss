package dsf

import com.sun.istack.internal.Nullable

/**
 * Created by IntelliJ IDEA.
 * User: syw
 * Date: 11-6-14
 * Time: 上午11:53
 * To change this template use File | Settings | File Templates.
 */
class TbPcInfo {
    static mapping = {
        table 'TB_PC_INFO'
         version false

         id generator: 'sequence', params: [sequence: 'SEQ_PC_INFO'], column:'TB_PC_ID'

  }

             Date tbPcDate
             Integer tbPcItems
             Double tbPcAmount
             Double tbPcFee
            Double tbPcAccamount
            Integer tbPcDkChanel
            String tbPcDkChanelname
            String tbPcDkStatus
            String tbPcCheckStatus
            String tbSfFlag
            String tbDealstyle
  static constraints = {
     // detailId(size:1..17,nullable:false)
      tbPcDate(nullable:true)
      tbPcItems(nullable:true)
      tbPcAmount(nullable:true)
      tbPcFee(nullable:true)
      tbPcAccamount(nullable:true)
      tbPcDkChanel(nullable:true)
      tbPcDkChanelname(nullable:true)
      tbPcDkStatus(nullable:true)
      tbPcCheckStatus(nullable:true)
      tbDealstyle(nullable:true)
  }

    def static dkStatusMap = ['0': '等待打款', '1': '打款完成','2':'已发送到银行']
     def static checkStatusMap = ['0': '不可对账', '1': '未对账','2':'已对账']

}
