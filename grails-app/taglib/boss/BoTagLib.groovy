package boss

import java.text.DateFormatSymbols
import java.text.DateFormat

class BoTagLib {
  static namespace = 'bo'
  def hasPerm = {attrs, body ->
    //管理员拥有所有的权限
    def hasPerm = session.op?.role?.roleName == 'admin'
    if (!hasPerm) {
      def chkPerm = attrs.perm
      hasPerm = session.permList.any {
        it == chkPerm
      }
    }
    if (hasPerm) {
      out << body()
    }
  }

  def regionSelect = {attrs ->
    //regoin name
    def rname = attrs.rname
    //city name
    def cname = attrs.cname
    //default region value
    def rvalue = attrs.rvalue
    //default city value
    def cvalue = attrs.cvalue
    out << '<select   id="' + rname + '" name="' + rname + '"></select>\n'
    out << '<select  style="width:100px;"  id="' + cname + '" name="' + cname + '"></select>'
    out << '<script type="text/javascript">\r\
                  gen_region_' + rname + '("' + rvalue + '");\r\
                  gen_city_' + cname + '("' + cvalue + '");\r\
                  $("#' + rname + '").bind("change", function(){gen_city_' + cname + '("");})\r\
                  function gen_region_' + rname + '(defVal){\r\
                      var regionSelects = $("#' + rname + '")[0]\r\
                      regionSelects.options.length = 0\r\
                      regionSelects.options[regionSelects.options.length]=new Option("\u8bf7\u9009\u62e9","")\r\
                      var regionLs = getRegionLs()\r\
                      $.each(regionLs, function(index, item) {\r\
                          var opt = new Option(item,item);\r\
                          regionSelects.options[regionSelects.options.length]=opt\r\
                          if (item == defVal) {\r\
                              opt.selected=true;\r\
                          }\r\
                      });\r\
                  }\r\
                  function gen_city_' + cname + '(defVal){\r\
                      var citySelects = $("#' + cname + '")[0]\r\
                      citySelects.options.length = 0\r\
                      citySelects.options[citySelects.options.length]=new Option("\u8bf7\u9009\u62e9","")\r\
                      var cityLs = getCityLs($("#' + rname + '").val())\r\
                      if (!cityLs) {return}\r\
                      $.each(cityLs, function(index, item) {\r\
                          var opt = new Option(item,item);\r\
                          citySelects.options[citySelects.options.length]=opt\r\
                          if (item == defVal) {\r\
                              opt.selected=true;\r\
                          }\r\
                      });\r\
                  }\r\
                  </script>';
  }


  def datePicker = {attrs ->

    def out = out // let x = x ?
    def xdefault = attrs['default']
    if (xdefault == null) {
      xdefault = new Date()
    }
    else if (xdefault.toString() != 'none') {
      if (xdefault instanceof String) {
        xdefault = DateFormat.getInstance().parse(xdefault)
      }
      else if (!(xdefault instanceof Date)) {
        throwTagError("Tag [datePicker] requires the default date to be a parseable String or a Date")
      }
    }
    else {
      xdefault = null
    }
    def value = attrs.value
    if (value.toString() == 'none') {
      value = null
    }
    else if (!value) {
      value = xdefault
    }
    def name = attrs.name
    def id = attrs.id ?: name

    def noSelection = attrs.noSelection
    if (noSelection != null) {
      noSelection = noSelection.entrySet().iterator().next()
    }

    def years = attrs.years

    final PRECISION_RANKINGS = ["year": 0, "month": 10, "day": 20, "hour": 30, "minute": 40]
    def precision = (attrs.precision ? PRECISION_RANKINGS[attrs.precision] :
      (grailsApplication.config.grails.tags.datePicker.default.precision ?
        PRECISION_RANKINGS["${grailsApplication.config.grails.tags.datePicker.default.precision}"] :
        PRECISION_RANKINGS["minute"]))

    def day
    def month
    def year
    def hour
    def minute

    def c = null
    if (value instanceof Calendar) {
      c = value
    }
    else if (value != null) {
      c = new GregorianCalendar()
      c.setTime(value)
    }

    if (c != null) {
      day = c.get(GregorianCalendar.DAY_OF_MONTH)
      month = c.get(GregorianCalendar.MONTH)
      year = c.get(GregorianCalendar.YEAR)
      hour = c.get(GregorianCalendar.HOUR_OF_DAY)
      minute = c.get(GregorianCalendar.MINUTE)
    }

    if (years == null) {
      def tempyear
      if (year == null) {
        // If no year, we need to get current year to setup a default range鈥?ugly
        def tempc = new GregorianCalendar()
        tempc.setTime(new Date())
        tempyear = tempc.get(GregorianCalendar.YEAR)
      }
      else {
        tempyear = year
      }
      years = (tempyear - 100)..(tempyear + 100)
    }

    out.println "<input type=\"hidden\" name=\"${name}\" value=\"date.struct\" />"

    // create year select
    if (precision >= PRECISION_RANKINGS["year"]) {
      out.println "<select name=\"${name}_year\" id=\"${id}_year\">"

      if (noSelection) {
        renderNoSelectionOptionImpl(out, noSelection.key, noSelection.value, '')
        out.println()
      }

      for (i in years) {
        out.println "<option value=\"${i}\"${i == year ? ' selected="selected"' : ''}>${i}</option>"
      }
      out.println '</select>'
    }

    // create month select
    if (precision >= PRECISION_RANKINGS["month"]) {
      out.println "<select name=\"${name}_month\" id=\"${id}_month\">"

      if (noSelection) {
        renderNoSelectionOptionImpl(out, noSelection.key, noSelection.value, '')
        out.println()
      }

      ['01', '02', '03', '04', '05', '06', '07', '08', '09', '10', '11', '12'].eachWithIndex {m, i ->
        if (m) {
          def monthIndex = i + 1
          out.println "<option value=\"${monthIndex}\"${i == month ? ' selected="selected"' : ''}>$m</option>"
        }
      }
      out.println '</select>'
    }

    // create day select
    if (precision >= PRECISION_RANKINGS["day"]) {
      out.println "<select name=\"${name}_day\" id=\"${id}_day\">"

      if (noSelection) {
        renderNoSelectionOptionImpl(out, noSelection.key, noSelection.value, '')
        out.println()
      }

      for (i in 1..31) {
        out.println "<option value=\"${i}\"${i == day ? ' selected="selected"' : ''}>${i}</option>"
      }
      out.println '</select>'
    }

    // do hour select
    if (precision >= PRECISION_RANKINGS["hour"]) {
      out.println "<select name=\"${name}_hour\" id=\"${id}_hour\">"

      if (noSelection) {
        renderNoSelectionOptionImpl(out, noSelection.key, noSelection.value, '')
        out.println()
      }

      for (i in 0..23) {
        def h = '' + i
        if (i < 10) h = '0' + h
        out.println "<option value=\"${h}\"${i == hour ? ' selected="selected"' : ''}>$h</option>"
      }
      out.println '</select> :'

      // If we're rendering the hour, but not the minutes, then display the minutes as 00 in read-only format
      if (precision < PRECISION_RANKINGS["minute"]) {
        out.println '00'
      }
    }

    // do minute select
    if (precision >= PRECISION_RANKINGS["minute"]) {
      out.println "<select name=\"${name}_minute\" id=\"${id}_minute\">"

      if (noSelection) {
        renderNoSelectionOptionImpl(out, noSelection.key, noSelection.value, '')
        out.println()
      }

      for (i in 0..59) {
        def m = '' + i
        if (i < 10) m = '0' + m
        out.println "<option value=\"${m}\"${i == minute ? ' selected="selected"' : ''}>$m</option>"
      }
      out.println '</select>'
    }

  }
}
