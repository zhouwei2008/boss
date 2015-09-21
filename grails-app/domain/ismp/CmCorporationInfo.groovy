package ismp

import org.springframework.orm.hibernate3.HibernateTemplate
import org.hibernate.Session
import com.burtbeckwith.grails.plugin.datasources.DatasourcesUtils
import org.hibernate.transform.AliasToEntityMapResultTransformer
import org.springframework.orm.hibernate3.HibernateCallback

class CmCorporationInfo extends CmCustomer {

    static mapping = {
    }

    String  registrationName
    String businessLicenseCode
    String organizationCode
    String taxRegistrationNo
    Date registrationDate
    Date licenseExpires
    String businessScope
    Double registeredFunds
    String registeredPlace
    String numberOfStaff
    Double expectedTurnoverOfYear
    String checkStatus              //审核状态（未审核/审核中/审核通过/审核拒绝）
    Long checkOperatorId
    Date checkDate
    String corporate
    String companyPhone
    String officeLocation
    String contact
    String contactPhone
    String zipCode
    String note
    String belongToArea        //商户所在地区
    String belongToSale        //所属销售
    String belongToBusiness   //所属行业
    String branchCompany      //所属分公司
    String grade               //商户等级(分ABCD四个等级)
    String accessMode         //接入方式（协议/自助）
    String bizMan              //业务联系人
    String bizMPhone          //业务联系人手机
    String bizPhone           //业务联系人座机
    String bizEmail           //业务联系人邮箱
    String techMan            //技术联系人
    String techMPhone        //技术联系人手机
    String techPhone         //技术联系人座机
    String techEmail         //技术联系人邮箱
    String financeMan        //财务联系人
    String financeMPhone    //财务联系人手机
    String financePhone     //财务联系人座机
    String financeEmail     //财务联系人邮箱
    String companyWebsite   //公司接入网址
    String fraud_check       //是否校验公司接入网址（0，否；1，是）
    Boolean isViewDate = false
     //每日限额
    Double dayQutor
    //单笔限额
    Double qutor
    //每月交易
    Double monthQutor
    //交易笔数
    String qutorNum
    //每日限额累计
    Double dayQutorCount = 0
    //单笔限额
    Double qutorCount = 0
    //每月交易累计
    Double monthQutorCount = 0
    //交易笔数累计
    Long qutorNumCount= 0

    String controlling    //控股股东

    String  legal //法定代表人

    String identityType //证件类型

    String identityNo   //证件号码

    Date validTime  //有效期限

    String idPositivePhoto //身份证正面照

    String idPositiveReview //身份证正面审核

    String idOppositePhoto //身份证反面照

    String idOppositeReview //身份证反面照审核

    String businessLicensePhoto//营业执照

    String businessLicenseReview//营业执照审核

    String taxRegistrationPhoto//税务登记照

    String taxRegistrationReview//营业执照审核

    static constraints = {
        registrationName(maxSize: 64,blank: false)
        businessLicenseCode(maxSize:20,blank:false)
        organizationCode(maxSize:20,blank:false)
        taxRegistrationNo(maxSize:20,blank:false)
        businessScope(maxSize:500,blank:false)
        registeredFunds(nullable:true)
        registeredPlace(maxSize:200,nullable:true)
        numberOfStaff(maxSize: 20,nullable: true)
        expectedTurnoverOfYear(maxSize: 20,nullable:true)
        checkStatus(maxSize:16,inList: ['waiting','processing','successed','refuse'],nullable:true)
        checkOperatorId(nullable:true)
        checkDate(nullable:true)
        corporate(maxSize:32,nullable:true)
        companyPhone(maxSize:20,nullable:true)
        officeLocation(maxSize:200,nullable:true)
        contact(maxSize:32,nullable:true)
        contactPhone(maxSize:20,nullable:true)
        zipCode(maxSize:10,nullable:true)
        note(maxSize:128,nullable:true)
        belongToBusiness(size: 1..20, blank: false)
        belongToSale(size: 1..20, blank: false)
        belongToArea(maxSize:200, blank: false)
        branchCompany(maxSize:200, blank: false)
        grade(maxSize: 16,inList: ['a','b','c','d','z'])
        accessMode(maxSize: 16,inList: ['protocol','self'],nullable:true)
        bizMan(maxSize:50,nullable:true)              //业务联系人
        bizMPhone(maxSize:20,nullable:true)          //业务联系人手机
        bizPhone(maxSize:20,nullable:true)           //业务联系人座机
        bizEmail(maxSize:200,nullable:true)           //业务联系人邮箱
        techMan(maxSize:50,nullable:true)            //技术联系人
        techMPhone(maxSize:20,nullable:true)        //技术联系人手机
        techPhone(maxSize:20,nullable:true)         //技术联系人座机
        techEmail(maxSize:200,nullable:true)         //技术联系人邮箱
        financeMan(maxSize:50,nullable:true)        //财务联系人
        financeMPhone(maxSize:20,nullable:true)    //财务联系人手机
        financePhone(maxSize:20,nullable:true)     //财务联系人座机
        financeEmail(maxSize:200,nullable:true)     //财务联系人邮箱
        companyWebsite(maxSize:200,nullable:true)   //公司接入网址
        fraud_check(maxSize:1,nullable:true)   //是否校验公司接入网址
        isViewDate(nullable:true)
        dayQutor(nullable:true)
        qutor(nullable:true)
        monthQutor(nullable:true)
        qutorNum(nullable:true)
        dayQutorCount(nullable:true)
        qutorCount(nullable:true)
        monthQutorCount(nullable:true)
        qutorNumCount(nullable:true)
        controlling(nullable:true)
        legal(nullable:true)
        identityType(maxSize: 8, blank: false)
        identityNo(nullable:true)
        validTime(nullable:true)
        idPositivePhoto(nullable:true)
        idPositiveReview(nullable:true)
        idOppositePhoto(nullable:true)
        idOppositeReview(nullable:true)
        businessLicensePhoto(nullable:true)
        businessLicenseReview(nullable:true)
        taxRegistrationPhoto(nullable:true)
        taxRegistrationReview(nullable:true)
    }
    // def static gradeMap = ['a': 'A级', 'b': 'B级','c': 'C级', 'd': 'D级', 'z': '无等级']
    def static gradeMap = ['a': '高风险', 'b': '中风险','c': '低风险']
    def static checkStatusMap = ['waiting': '未审核', 'processing': '审核中','successed': '审核通过', 'refuse': '审核拒绝']
    def static accessModeMap = ['protocol': '协议', 'self': '自助']
    def static fraudcheckMap = ['0': '否', '1': '是']
    def static identityTypeMap = ['id': '身份证', 'arm': '军官证', 'passp': '护照']
    def static expireMap = ['10':'10天','30':'30天','60':'60天','90':'90天']
    def static belongToBusinessMap  =['A':'农、林、牧、渔业','B':'采矿业','C':'制造业','D':'电力、热力、燃气及水的生产和供应业',
            'E':'建筑业','F':'批发和零售业','G':'交通运输、仓储业和邮政业','H':'住宿、餐饮业','I':'信息传输、软件和信息技术服务业',
            'J':'金融、保险业','K':'房地产业','L':'租赁和商务服务业','M':'科学研究、技术服务和地质勘查业',
            'N':'水利、环境和公共设施管理业','O':'居民服务、修理和其他服务业','P':'教育','Q':'卫生和社会工作',
            'R':'文化、体育和娱乐业','S':'公共管理、社会保障和社会组织','T':'国际组织','U':'其他']

    def static reviewMap = ['wait':'待审核','pass':'通过','refuse':'拒绝']
}
