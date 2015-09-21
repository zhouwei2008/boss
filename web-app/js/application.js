$.datepicker.regional['zh_CN'] = {
  clearText: '\u6e05\u9664',
  clearStatus: '\u6e05\u9664\u5df2\u9009\u65e5\u671f',
  closeText: '\u5173\u95ed',
  closeStatus: '\u4e0d\u6539\u53d8\u5f53\u524d\u9009\u62e9',
  prevText: '<\u4e0a\u6708',
  prevStatus: '\u663e\u793a\u4e0a\u6708',
  prevBigText: '<<',
  prevBigStatus: '\u663e\u793a\u4e0a\u4e00\u5e74',
  nextText: '\u4e0b\u6708>',
  nextStatus: '\u663e\u793a\u4e0b\u6708',
  nextBigText: '>>',
  nextBigStatus: '\u663e\u793a\u4e0b\u4e00\u5e74',
  currentText: '\u4eca\u5929',
  currentStatus: '\u663e\u793a\u672c\u6708',
  monthNames: ['\u4e00\u6708','\u4e8c\u6708','\u4e09\u6708','\u56db\u6708','\u4e94\u6708','\u516d\u6708', '\u4e03\u6708','\u516b\u6708','\u4e5d\u6708','\u5341\u6708','\u5341\u4e00\u6708','\u5341\u4e8c\u6708'],
  monthNamesShort: ['\u4e00','\u4e8c','\u4e09','\u56db','\u4e94','\u516d', '\u4e03','\u516b','\u4e5d','\u5341','\u5341\u4e00','\u5341\u4e8c'],
  monthStatus: '\u9009\u62e9\u6708\u4efd',
  yearStatus: '\u9009\u62e9\u5e74\u4efd',
  weekHeader: '\u5468',
  weekStatus: '\u5e74\u5185\u5468\u6b21',
  dayNames: ['\u661f\u671f\u65e5','\u661f\u671f\u4e00','\u661f\u671f\u4e8c','\u661f\u671f\u4e09','\u661f\u671f\u56db','\u661f\u671f\u4e94','\u661f\u671f\u516d'],
  dayNamesShort: ['\u5468\u65e5','\u5468\u4e00','\u5468\u4e8c','\u5468\u4e09','\u5468\u56db','\u5468\u4e94','\u5468\u516d'],
  dayNamesMin: ['\u65e5','\u4e00','\u4e8c','\u4e09','\u56db','\u4e94','\u516d'],
  dayStatus: '\u8bbe\u7f6e DD \u4e3a\u4e00\u5468\u8d77\u59cb',
  dateStatus: '\u9009\u62e9 m\u6708 d\u65e5, DD',
  dateFormat: 'yy-mm-dd',
  firstDay: 1,
  initStatus: '\u8bf7\u9009\u62e9\u65e5\u671f',
  isRTL: false
};
$.datepicker.setDefaults($.datepicker.regional['zh_CN']);

jQuery.extend(jQuery.validator.messages, {
  required: "必选字段",
  remote: "请修正该字段",
  email: "请输入正确格式的电子邮件",
  url: "请输入合法的网址",
  date: "请输入合法的日期",
  dateISO: "请输入合法的日期 (ISO).",
  number: "请输入合法的数字",
  digits: "只能输入整数",
  creditcard: "请输入合法的信用卡号",
  equalTo: "请再次输入相同的值",
  accept: "请输入拥有合法后缀名的字符串",
  maxlength: jQuery.validator.format("请输入一个长度最多是 {0} 的字符串"),
  minlength: jQuery.validator.format("请输入一个长度最少是 {0} 的字符串"),
  rangelength: jQuery.validator.format("请输入一个长度介于 {0} 和 {1} 之间的字符串"),
  range: jQuery.validator.format("请输入一个介于 {0} 和 {1} 之间的值"),
  max: jQuery.validator.format("请输入一个最大为 {0} 的值"),
  min: jQuery.validator.format("请输入一个最小为 {0} 的值")
});
//validate大于
jQuery.validator.addMethod("gt", function(value, element, params) {
 return this.optional(element) || Number(value) > params ;
}, jQuery.format("输入的值必须大于 {0}"));
//vlidate小于
jQuery.validator.addMethod("lt", function(value, element, params) {
 return this.optional(element) || Number(value) < params ;
}, jQuery.format("输入的值必须小于 {0}"));
//validate不大于某个field
jQuery.validator.addMethod("maxFd", function(value, element, params) {
 return this.optional(element) || Number(value) <= Number($(params).val()) ;
}, jQuery.format("输入的值不能大于 {0}"));
//validate不小于某个field
jQuery.validator.addMethod("minFd", function(value, element, params) {
 return this.optional(element) || Number(value) >= Number($(params).val()) ;
}, jQuery.format("输入的值不能小于 {0}"));
//validate不等于某个field
jQuery.validator.addMethod("neFd", function(value, element, params) {
 return this.optional(element) || value != $(params).val() ;
}, jQuery.format("输入的值不能等于 {0}"));

function myUpdate(url1, parameters1, max) {
    var selectValue = document.getElementById("page").value;
    var offset = max * (selectValue - 1);
    var newParams = "?offset=" + offset + parameters1;
    window.location.href =url1+newParams;

}