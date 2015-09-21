package boss

class BoAssets {
    String asId    //资产编号
    String name   //资产名称
    String brand   //品牌
    String model    //规格型号

    Integer  num  //数量
    Date   startDate  //启用时间
    String status   //状态
    String    remark  //备注

    static constraints = {

        asId (maxSize: 64,blank: false)
        name(maxSize: 64,blank: false)
        brand(maxSize: 64,blank: false)
        model(maxSize: 64,blank: false)
        num (maxSize: 64,blank: false)
         status (maxSize: 64,inList:['a','b','c'])
         startDate (maxSize: 64,blank: false)
    }
       def static statusMap=['a': '在用', 'b':'闲置','c':'报废']
}
