package ismp
import groovy.sql.Sql
class CmCustomer {

  static mapping = {
    id(generator: 'org.hibernate.id.enhanced.SequenceStyleGenerator', params: [sequence_name: 'seq_cm_customer', initial_value: 1])
    tablePerHierarchy false
  }

  String name
  String customerNo
  String type
  String status = 'init'
  String apiKey
  String accountNo
  Boolean needInvoice= false
  Date dateCreated
  Date lastUpdated
  Double postFee

  //增加到期执照验证字段 update sunweiguo
  //Boolean isViewDate = false

  String customerCategory   //账户类别
  String cmCustInstitutionId
  String custInstitutionId
  String openStatus //开启审核状态
  String closeStatus //关闭审核状态

    static startdate
    static enddate
 public Double getPostFee()
{
     def post_fee_sql="""  select nvl(sum(t.post_fee),0) post_fee from ft_liquidate t
 where t.customer_no = '"""+this.customerNo+"""'
   and t.post_foot_status = 0"""
        if(this.startdate!=null&&this.startdate!=""&&this.enddate!=null&&this.enddate!="")
  post_fee_sql+=""" and t.liq_date >=to_date('"""+this.startdate+"""','yyyy-mm-dd')
   and t.liq_date <=to_date('"""+this.enddate+"""','yyyy-mm-dd')"""
      def sql = new Sql(dataSource_settle)
        def  post_fee= sql.firstRow(post_fee_sql).post_fee
        return post_fee
}

      def dataSource_settle



  static constraints = {
    name(maxSize: 32, blank: false)
    customerNo(maxSize: 24, blank: false)
    type(maxSize: 1, inList: ['P', 'C', 'A', 'S'], blank: false)
    status(maxSize: 16, inList: ['init', 'normal', 'disabled', 'deleted'], blank: false)
    apiKey(maxSize: 64, nullable: true)
    accountNo(maxSize: 24, nullable: true)
    needInvoice(nullable: true)
    customerCategory(nullable: true)
   // isViewDate(nullable:true)
    cmCustInstitutionId(nullable: true)
    custInstitutionId(nullable: true)
    openStatus(nullable: true)
    closeStatus(nullable: true)
  }

  String toString() {
    return "${name}(${id})"
  }

  def static typeMap = ['P': '个人', 'C': '公司', 'A': '代理', 'S': '系统']
  def static statusMap = ['init': '受限', 'normal': '正常', 'disabled': '停用', 'deleted': '删除']
  //def static customerCategoryMap = ['': '无', 'travel': '商旅账户']
  def static customerCategoryMap = ['': '无']
  def static blackMap = ['init': '正常', 'disabled': '停用']

}
