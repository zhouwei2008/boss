package ismp

class SlaEvents {

  Date createdate
  String createor
  Integer meslever
  SlaEventtype eventtype
  String mescontent
  String status
  Date updated
  String descs
  String prdsrc
  String features

  static constraints = {
  }

  static mapping = {
    eventtype(column: 'mescid', fetch: 'join')
    version false
  }

  def static statusMap = ['0': '初始', '1': '已通知']


}
