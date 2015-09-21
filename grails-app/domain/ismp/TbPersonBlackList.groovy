package ismp


class TbPersonBlackList {
    static mapping = {
        id generator: 'sequence', params: [sequence: 'seq_tb_person_black_list']
    }
    String name //姓名

    String identityType  //证件类型

    String identityNo   //证件号码

    String bankAccount  //银行账号

    String  source //来源

    Date  createDate //创建时间

    String nationality //国籍
    String gender //性别
    String occupation //职业
    String address //住址
    String contactWay //联系方式
    Date validTime  //有效期限


    static constraints = {

        name(maxSize: 32, blank: false)
        identityType(maxSize: 8, blank: false)
        identityNo(maxSize: 20, blank: false)
        bankAccount(maxSize: 32,nullable: true)
        source(maxSize: 10,inList: ['PBOC','MPS'])
        createDate(nullable:true)
        nationality(maxSize: 8, blank: true)
        gender(maxSize: 8, blank: true)
        occupation(maxSize: 8, blank: true)
        address(nullable: true)
        contactWay(nullable: true)
        validTime(nullable: true)
    }

    def static identityTypeMap = ['id': '身份证', 'arm': '军官证', 'passp': '护照']
    def static sourceMap = ['PBOC': '人民银行', 'MPS': '公安部']
    def static nationalityMap = ['China':'中国']
    def static genderMap = ['M':'男','F':'女']
    def static occupationMap = ['1':'国家机关、党群组织、企业、事业单位负责人','2':'专业技术人员','3':'办事人员和有关人员','4':'商业、服务业人员','5':'农、林、牧、渔、水利业生产人员','6':'生产、运输设备操作人员及有关人员','7':'军人','8':'不便分类的其他从业人员']
}
