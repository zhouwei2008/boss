package ismp

import gateway.GwOrder

class MapiAsyncNotify {
    GwOrder record
    Date dateCreated
    Date lastUpdated
    Integer customerId
    String recordTable
//    Integer recordId
    String notifyMethod
    String notifyAddress
    String notifyContents
    String signType
    Date notifyTime
    String notifyId
    Date nextAttemptTime
    String status
    Integer attemptsCount
    Date timeExpired
    Boolean isVerify
    String outputCharset
    String response
    static constraints = {
        dateCreated(nullable: true)
        lastUpdated(nullable: true)
        recordTable(nullable: true)
        signType(nullable: true)
        notifyTime(nullable: true)
        notifyId(nullable: true)
        nextAttemptTime(nullable: true)
        status(maxSize: 16, blank: false, inList: ['success', 'fail','processing'])
        attemptsCount(nullable: true)
        timeExpired(nullable: true)
        isVerify(nullable: true)
        outputCharset(nullable: true)
        response(nullable: true, maxSize: 256)
    }
    static mapping = {
        id generator: 'sequence', params: [sequence: 'seq_mapi_async_notify']
        version false

    }


    static statusMap = ['success': '已成功', 'fail': '未成功','processing':'处理中']
    static notifyMethodMap = ['http': '网页', 'email': '电子邮件', 'mobile': '电话']
}
