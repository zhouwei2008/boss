package dsf

/**
 * Created by IntelliJ IDEA.
 * User: syw
 * Date: 11-6-14
 * Time: 上午11:53
 * To change this template use File | Settings | File Templates.
 */
class TbBindBank {
    static mapping = {
        table 'TB_BIND_BANK'
         version false

         id generator: 'sequence', params: [sequence: 'SEQ_BIND_BANK'], column:'ID'

  }
             //String detailId
             String dsfFlag
             String bankAccountno
             String notes



  static constraints = {

     dsfFlag(size:1..2,nullable:false)
     bankAccountno(size:1..32,nullable:false)
     notes(size:1..100,nullable:true)
  }

     def static ServerTypeMap = ['S':'代收','F': '代付']
}
