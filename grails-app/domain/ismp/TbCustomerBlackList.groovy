package ismp


class TbCustomerBlackList {

    static mapping = {
        id generator: 'sequence', params: [sequence: 'seq_tb_customer_black_list']
    }

    String nickname //别称

    String name    //客户名称

    String businessLicenseCode //营业执照代码

    String organizationCode //组织机构代码

    String  source //来源

    Date  createDate //创建时间

    String address //地址

    String businessScope //经营范围

    Date businessValidity //营业执照有效期

    String legalPerson //法定代表人

    String identityType //证件类型

    String identityNo //证件号码

    Date identityValidity //证件有效期

    static constraints = {

        nickname(maxSize: 64,blank: false)
        name(maxSize: 64, blank: false)
        businessLicenseCode(maxSize:20,blank:false)
        organizationCode(maxSize:20,blank:false)
        source(maxSize: 10,inList: ['PBOC','MPS'])
        createDate(nullable:true)
        address(nullable:true)
        businessScope(nullable:true)
        businessValidity(nullable:true)
        legalPerson(nullable:true)
        identityType(nullable:true)
        identityNo(maxSize:20,blank:false)
        identityValidity(nullable:true)
    }

    def static sourceMap = ['PBOC': '人民银行', 'MPS': '公安部']
    def static identityTypeMap = ['id': '身份证', 'arm': '军官证', 'passp': '护照']
}
