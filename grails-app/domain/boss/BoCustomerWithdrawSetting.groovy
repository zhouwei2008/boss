package boss

class BoCustomerWithdrawSetting {
    static mapping = {
        id generator: 'sequence', params: [sequence: 'seq_bo_customer_withdraw_setting']
    }

    String customerNo
    BigDecimal minAmount
    BigDecimal withdrawLimit
    BigDecimal dayLimit
    Integer feeType
    BigDecimal minFee
    BigDecimal maxFee
    BigDecimal fee
    Integer feeFrom
    Integer feeReturn
    BigDecimal dayWithdrawSum

    static constraints = {
        customerNo(size:1..20,blank: false)
        minAmount()
        withdrawLimit()
        dayLimit()
        feeType()
        minFee()
        maxFee()
        fee()
        feeFrom()
        feeReturn()
        dayWithdrawSum()
    }
}
