package dsf

class TbEntrustPerm {
    static mapping = {
        table 'TB_ENTRUST_PERM'
        version false
        id generator: 'sequence', params: [sequence: 'seq_tb_entrust_perm'], column: 'ID'
    }
    String customerNo;//商户编号
    String cardname;//开户名
    String accountname;//开户银行
    String cardnum;//开户账户
    String entrustUsercode;//代扣协议号
    Date entrustStarttime;//授权日期
    Date entrustEndtime;//截止日期
    String entrustStatus;//账户状态 0正常（在有效期内且未被关闭）、1关闭（在有效期内但是已经被关闭）；默认为“正常“状态，必选
    String entrustIsEffect;//是否生效 0：是，1：否 默认为是，根据上面录入的时间段和状态进行判断，如果时间段包括当前日期，并且状态为“正常‘，则默认显示为“是“；如果时间段包括当前日期，状态为”关闭“，则默认显示为”否“；如果时间段不包括当前日期并且状态为“正常”，则默认显示为“否“；如果时间段不包括当前日期并且状态为“关闭”，则默认显示为“否”；只读，不可修改。
    String accounttype;//账户类型  0：个人、1：企业  默认为个人
    String certificateType;//证件类型 '0':'身份证','1':'户口簿','2':'护照','3':'军官证','4':'士兵证','5':'台胞证'
    String certificateNum;//证件号
    String operator;//经办人
    Date createtime;//经办日期

    static constraints = {
        customerNo(nullable: false)
        cardname(nullable: false)
        accountname(nullable: false)
        cardnum(nullable: false)
        entrustUsercode(nullable: true)
        entrustStarttime(nullable: false)
        entrustEndtime(nullable: false)
        entrustStatus(nullable: false)
        entrustIsEffect(nullable: false)
        certificateType(nullable: false)
        certificateNum(nullable: false)
        operator(nullable: false)
        createtime(nullable: false)
    }
    def static entrustStatusMap = ['0': '正常', '1': '关闭']
    def static entrustIsEffectMap = ['0': '是', '1': '否']
    def static accounttypeMap = ['0': '个人', '1': '企业']
    def static accounttypeMapR = ['个人':'0', '企业':'1']
    def static certificateTypeMap = ['0': '身份证', '1': '户口簿', '2': '护照', '3': '军官证', '4': '士兵证', '5': '台胞证']
    def static certificateTypeMapR = [ '身份证':'0', '户口簿':'1', '护照':'2', '军官证':'3', '士兵证':'4', '台胞证':'5']


}
