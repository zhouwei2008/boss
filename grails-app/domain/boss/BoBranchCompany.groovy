package boss

class BoBranchCompany {
   static mapping = {
    id generator: 'sequence', params: [sequence: 'seq_branchcompany']
  }
    /*分公司编号*/
  //  String companyNo
    /*分公司名称*/
    String companyName
    /*负责人*/
    String chargeMan
    /*联系电话*/
    String phone
    /*传真*/
    String fax
    /*地址*/
    String address
    /*创建时间*/
    Date dateCreated


    static constraints = {
   //     companyNo(nullable: true)
        companyName(unique:true)
        chargeMan(nullable: true)
        phone(nullable: true)
        fax(nullable: true)
        address(nullable: true)
    }


}
