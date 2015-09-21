package boss

class BoBalanceAccountDateRule {

      //开户银行
    BoBankDic bank

      //日结时间
    Date settleDayTime
    //对帐日起始时间
    Date acquireSynDayBeginTime
    //对帐日终止时间
    Date acquireSynDayEndTime


    static constraints = {
    }

   static mapping = {
    id generator: 'sequence', params: [sequence: 'seq_bo_ba_acc_rule']
  }
}
