package boss

class BoSecurityEvents {

    String boSort   //事件类别
    String sketch    //事件简述
    String  expatiate //事件详述
    Date  startDateCreated//发生时间
    Date  endDateCreated    //解决时间
    String boStatus   //事件状态

    static constraints = {
         boSort( inList:['a','b','c','d'])
         sketch (maxSize: 64,blank: false)
         expatiate (maxSize: 128,blank: false)
         startDateCreated(blank: false)
         endDateCreated(blank: false)
         boStatus (inList:['0','1'])
    }

    def static  boSortMap=['a':'入侵记录','b':'备份失败','c':'内存溢出','d':'其他']
    def static  boStatusMap=['0':'已解决','1':'待解决']
}
