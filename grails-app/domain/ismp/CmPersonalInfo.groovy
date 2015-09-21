package ismp

class CmPersonalInfo extends CmCustomer {

  static mapping = {
  }

  String identityType
  String identityNo
  Date dateCertification
  Boolean isCertification
  String nationality //国籍
  String gender //性别
  String occupation //职业
  String address //住址
  String contactWay //联系方式
  Date validTime  //有效期限
  String grade

    //每日交易金额限额
    Double totalAmountlimitPerDay
    //每日累计交易笔数限额
    Double trxsCountNumPerDay
    //单笔限额
    Double limitPerTrx
//
//    //每月交易金额限额
    Double totalAmountLimitPermonth
//    //每月交易笔数限额
//    String monthTrxsSumNum
//
//    //每日交易笔数累计
    Double tradeCountCurrentDay = 0
//    //每日交易金额累计
    Double tradeAmountCurrentDay = 0
//    //每月交易笔数累计
//    Double trxsNumPerMonth = 0.
    //每月交易金额累计
    Double monthQutorCount   = 0
//
    Date lastTrxsUpdateDate=new Date()



    static constraints = {
    identityType(maxSize: 8, blank: false)
    identityNo(maxSize: 32, blank: false)
    dateCertification(nullable: true)
    isCertification(nullable: true)
    nationality(maxSize: 8, blank: true)
    gender(maxSize: 8, blank: true)
    occupation(maxSize: 8, blank: true)
    address(nullable: true)
    contactWay(nullable: true)
    validTime(nullable: true)
    grade(maxSize: 16,inList: ['a','b','c'])

        totalAmountlimitPerDay(nullable: true)
        trxsCountNumPerDay(nullable: true)
        limitPerTrx(nullable: true)
        totalAmountLimitPermonth(nullable: true)
        tradeCountCurrentDay(nullable: true)
        tradeAmountCurrentDay(nullable: true)
        monthQutorCount(nullable: true)
        lastTrxsUpdateDate(nullable: true)


    }

  def static identityTypeMap = ['id': '身份证', 'arm': '军官证', 'passp': '护照']
  def static nationalityMap = ['China':'中国','America':'美国']
  def static genderMap = ['M':'男','F':'女']
  def static occupationMap = ['1':'国家机关、党群组织、企业、事业单位负责人','2':'专业技术人员','3':'办事人员和有关人员','4':'商业、服务业人员','5':'农、林、牧、渔、水利业生产人员','6':'生产、运输设备操作人员及有关人员','7':'军人','8':'不便分类的其他从业人员']
  def static gradeMap = ['a': '高风险', 'b': '中风险','c': '低风险']
}
