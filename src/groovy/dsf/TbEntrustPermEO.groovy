package dsf

/**
 * Created by IntelliJ IDEA.
 * User: xypeng
 * Date: 12-6-8
 * Time: 下午4:07
 * To change this template use File | Settings | File Templates.
 */
class TbEntrustPermEO {
    String seqNo //序号
    String cardname //开户名
    String accountname //开户银行
    String cardnum //开户账户
    String entrustUsercode //代扣协议号
    String entrustStarttime //授权日期
    String entrustEndtime //截止日期
    String accounttype //账户类型  0：个人、1：企业  默认为个人
    String certificateType //证件类型 '0':'身份证','1':'户口簿','2':'护照','3':'军官证','4':'士兵证','5':'台胞证'
    String certificateNum //证件号
    String customerNo //商户编号
    String checkMsg //校验结果
}
