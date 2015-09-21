package dsf

import org.springframework.web.multipart.MultipartHttpServletRequest
import java.text.SimpleDateFormat
import java.util.regex.Pattern
import java.util.regex.Matcher
import org.apache.poi.hssf.usermodel.HSSFWorkbook
import org.apache.poi.hssf.usermodel.HSSFSheet
import org.apache.poi.hssf.usermodel.HSSFRow
import org.apache.poi.hssf.usermodel.HSSFCell
import ismp.CmCustomer
import org.springframework.orm.hibernate3.HibernateTemplate
import org.hibernate.Session
import org.springframework.orm.hibernate3.HibernateCallback
import com.burtbeckwith.grails.plugin.datasources.DatasourcesUtils
import java.sql.Connection
import java.sql.PreparedStatement
import groovy.sql.Sql
import org.apache.poi.hssf.usermodel.HSSFDateUtil


class TbEntrustPermsImportService {
    def dataSource_dsf
    private String[] titel = ["序号","开户名","开户银行","开户账户","代扣协议号","授权日期",
                            "截止日期",	"账户类型","证件类型",	"证件号","所属商户"]
    private String formatErrVal = "格式错误<br/>无法解析"
    /**
     * 0.校验文件类型
     * 1.校验模板列头
     * 2.校验是否有重复序号
     * 3.逐条校验
     *  3.1 逐个字段校验
     * @param request
     * @return
     */
    def check(MultipartHttpServletRequest request){
        /**
         * 0.校验文件类型
         * 1.校验模板列头
         * 2.校验是否有重复序号
         **/
        def fileRes = checkFile(request.getFile("upload"))
        if(fileRes.errMsg){
            return [errMsg:fileRes.errMsg]
        }else{
            List<TbEntrustPerm> tbEntrustPermListAdd = new ArrayList<TbEntrustPerm>()
            List<TbEntrustPerm> tbEntrustPermListUpdate = new ArrayList<TbEntrustPerm>()
            List<TbEntrustPermEO> tbEntrustPermErrList = new ArrayList<TbEntrustPermEO>()
            TbEntrustPermEO tbEntrustPermEO
            String errMsg = ""
            /** *
             * 3.逐条校验
             *  3.1 逐个字段校验
             */
            int lastRowNum = fileRes.lastRowNum
            HSSFSheet xSheet = fileRes.xSheet
            def checkRes
            boolean b1
            boolean b2
            String tempErrMsg = ""
            for(int i=1;i<=fileRes.lastRowNum;i++){
                tempErrMsg = ""
                tbEntrustPermEO = new TbEntrustPermEO()
                tbEntrustPermEO.seqNo = xSheet.getRow(i).getCell(0).getNumericCellValue().intValue().toString()

                checkRes = checkCardname(xSheet.getRow(i).getCell(1))
                tempErrMsg = tempErrMsg + checkRes.errMsg
                tbEntrustPermEO.cardname = checkRes.checkVal

                checkRes = checkAccountname(xSheet.getRow(i).getCell(2))
                tempErrMsg = tempErrMsg + checkRes.errMsg
                tbEntrustPermEO.accountname = checkRes.checkVal

                checkRes = checkCardnum(xSheet.getRow(i).getCell(3))
                tempErrMsg = tempErrMsg + checkRes.errMsg
                tbEntrustPermEO.cardnum = checkRes.checkVal

                checkRes = checkEntrustUsercode(xSheet.getRow(i).getCell(4))
                tempErrMsg = tempErrMsg + checkRes.errMsg
                tbEntrustPermEO.entrustUsercode = checkRes.checkVal


                checkRes = checkEntrustStarttime(xSheet.getRow(i).getCell(5))
                b1 = (!checkRes.errMsg)
                tempErrMsg = tempErrMsg + checkRes.errMsg
                tbEntrustPermEO.entrustStarttime = checkRes.checkVal

                checkRes = checkEntrustEndtime(xSheet.getRow(i).getCell(6))
                b2 = (!checkRes.errMsg)
                tempErrMsg = tempErrMsg + checkRes.errMsg
                tbEntrustPermEO.entrustEndtime = checkRes.checkVal

                if(b1&&b2){
                    tempErrMsg = tempErrMsg + checkStartAndEndTime(tbEntrustPermEO.entrustStarttime,tbEntrustPermEO.entrustEndtime)
                }

                checkRes = checkAccounttype(xSheet.getRow(i).getCell(7))
                tempErrMsg = tempErrMsg + checkRes.errMsg
                tbEntrustPermEO.accounttype = checkRes.checkVal

                checkRes = checkCertificateType(xSheet.getRow(i).getCell(8))
                tempErrMsg = tempErrMsg + checkRes.errMsg
                tbEntrustPermEO.certificateType = checkRes.checkVal

                checkRes = checkCertificateNum(xSheet.getRow(i).getCell(9))
                tempErrMsg = tempErrMsg + checkRes.errMsg
                tbEntrustPermEO.certificateNum = checkRes.checkVal

                checkRes = checkCustomerNo(xSheet.getRow(i).getCell(10))
                tempErrMsg = tempErrMsg + checkRes.errMsg
                tbEntrustPermEO.customerNo = checkRes.checkVal

                //检验excel里是否重复
                tempErrMsg = tempErrMsg + checkIsDuplicate(fileRes.keysMap,tbEntrustPermEO.seqNo,
                        xSheet.getRow(i).getCell(1)?.toString(),xSheet.getRow(i).getCell(2)?.toString(),
                        xSheet.getRow(i).getCell(3)?.toString(),xSheet.getRow(i).getCell(10)?.toString())

                if(tempErrMsg){
                    tbEntrustPermEO.checkMsg = tempErrMsg
                    tbEntrustPermErrList.add(tbEntrustPermEO)
                }else if(checkIsExist(tbEntrustPermEO.cardname,tbEntrustPermEO.accountname,
                        tbEntrustPermEO.cardnum,tbEntrustPermEO.customerNo)){//库中已存在
                    tbEntrustPermListUpdate.add(changeToTbEntrustPerm(tbEntrustPermEO,request.session.op.name))
                }else{
                    tbEntrustPermListAdd.add(changeToTbEntrustPerm(tbEntrustPermEO,request.session.op.name))
                }
            }
            [errMsg:errMsg,tbEntrustPermErrList:tbEntrustPermErrList,tbEntrustPermListAdd:tbEntrustPermListAdd,
                    tbEntrustPermListUpdate:tbEntrustPermListUpdate,totalNum:fileRes.lastRowNum]
        }
    }

    /**
     * 入库
     * @param tbEntrustPermListAdd,tbEntrustPermListUpdate
     * @return
     */
    def savePerms(List<TbEntrustPerm> tbEntrustPermListAdd,List<TbEntrustPerm> tbEntrustPermListUpdate){
        if(!tbEntrustPermListAdd&&!tbEntrustPermListUpdate){
            return false
        }

        TbEntrustPerm.withTransaction {status ->
            HibernateTemplate ht = DatasourcesUtils.newHibernateTemplate('dsf')
            if(tbEntrustPermListAdd){
                ht.execute({ Session session ->
                    int count = 100
                    Connection conn = session.connection();
                    PreparedStatement pst = null;
                    String sql = """insert into tb_entrust_perm
                    (ID, CUSTOMER_NO, CARDNAME, ACCOUNTNAME,
                    CARDNUM, ENTRUST_USERCODE, ENTRUST_STARTTIME,
                    ENTRUST_ENDTIME, ENTRUST_STATUS, ENTRUST_IS_EFFECT,
                    ACCOUNTTYPE, CERTIFICATE_TYPE, CERTIFICATE_NUM,
                    OPERATOR, CREATETIME)
                    values (SEQ_TB_ENTRUST_PERM.nextval,?,?,?,
                     ?,?,to_date(?,'yyyy-MM-dd'),
                     to_date(?,'yyyy-MM-dd'),?,?,
                     ?,?,?,
                     ?,sysdate)
                     """
                    pst=conn.prepareStatement(sql);
                    int num = tbEntrustPermListAdd.size();
                    TbEntrustPerm tbEntrustPerm = null
                    for(int i=0;i<num;i++){
                        tbEntrustPerm = tbEntrustPermListAdd[i]
                        pst.setString(1, tbEntrustPerm.customerNo);
                        pst.setString(2, tbEntrustPerm.cardname);
                        pst.setString(3, tbEntrustPerm.accountname);
                        pst.setString(4, tbEntrustPerm.cardnum);
                        pst.setString(5, tbEntrustPerm.entrustUsercode);
                        pst.setString(6, sf.format(tbEntrustPerm.entrustStarttime));
                        pst.setString(7, sf.format(tbEntrustPerm.entrustEndtime));
                        pst.setString(8, tbEntrustPerm.entrustStatus);
                        pst.setString(9, tbEntrustPerm.entrustIsEffect);
                        pst.setString(10, tbEntrustPerm.accounttype);
                        pst.setString(11, tbEntrustPerm.certificateType);
                        pst.setString(12, tbEntrustPerm.certificateNum);
                        pst.setString(13, tbEntrustPerm.operator);
                        pst.addBatch();
                        if((i+1)%count==0){
                            pst.executeBatch();
                            session.flush();
                        }
                    }
                    pst.executeBatch();
                    session.flush();
                    session.clear();
                } as HibernateCallback)
            }

            if(tbEntrustPermListUpdate){
                HibernateTemplate ht2 = DatasourcesUtils.newHibernateTemplate('dsf')
                ht2.execute({ Session session ->
                    int count = 100
                    Connection conn = session.connection();
                    PreparedStatement pst = null;
                    String sql = """update tb_entrust_perm set
                    ENTRUST_USERCODE=?, ENTRUST_STARTTIME=to_date(?,'yyyy-MM-dd'),
                    ENTRUST_ENDTIME=to_date(?,'yyyy-MM-dd'), ENTRUST_STATUS=?,
                    ENTRUST_IS_EFFECT=?,
                    ACCOUNTTYPE=?, CERTIFICATE_TYPE=?, CERTIFICATE_NUM=?,
                    OPERATOR=?, CREATETIME=sysdate
                    where CARDNAME=? and ACCOUNTNAME=?
                    and CARDNUM=? and CUSTOMER_NO=?
                     """
                    pst=conn.prepareStatement(sql);
                    int num = tbEntrustPermListUpdate.size();
                    TbEntrustPerm tbEntrustPerm = null
                    for(int i=0;i<num;i++){
                        tbEntrustPerm = tbEntrustPermListUpdate[i]
                        pst.setString(1, tbEntrustPerm.entrustUsercode);
                        pst.setString(2, sf.format(tbEntrustPerm.entrustStarttime));
                        pst.setString(3, sf.format(tbEntrustPerm.entrustEndtime));
                        pst.setString(4, tbEntrustPerm.entrustStatus);
                        pst.setString(5, tbEntrustPerm.entrustIsEffect);
                        pst.setString(6, tbEntrustPerm.accounttype);
                        pst.setString(7, tbEntrustPerm.certificateType);
                        pst.setString(8, tbEntrustPerm.certificateNum);
                        pst.setString(9, tbEntrustPerm.operator);
                        pst.setString(10, tbEntrustPerm.cardname);
                        pst.setString(11, tbEntrustPerm.accountname);
                        pst.setString(12, tbEntrustPerm.cardnum);
                        pst.setString(13, tbEntrustPerm.customerNo);
                        pst.addBatch();
                        if((i+1)%count==0){
                            pst.executeBatch();
                            session.flush();
                        }
                    }
                    pst.executeBatch();
                    session.flush();
                    session.clear();
                } as HibernateCallback)
            }
        }
        return true
    }

    static SimpleDateFormat sf = new SimpleDateFormat("yyyy-MM-dd");
    private TbEntrustPerm changeToTbEntrustPerm(TbEntrustPermEO tbEntrustPermEO,String operator){
        TbEntrustPerm tbEntrustPerm =  new TbEntrustPerm()
        tbEntrustPerm.customerNo = tbEntrustPermEO.customerNo
        tbEntrustPerm.cardname = tbEntrustPermEO.cardname
        tbEntrustPerm.accountname = tbEntrustPermEO.accountname
        tbEntrustPerm.cardnum = tbEntrustPermEO.cardnum
        tbEntrustPerm.entrustUsercode = tbEntrustPermEO.entrustUsercode
        tbEntrustPerm.entrustStarttime = sf.parse(tbEntrustPermEO.entrustStarttime)
        tbEntrustPerm.entrustEndtime = sf.parse(tbEntrustPermEO.entrustEndtime)
        tbEntrustPerm.entrustStatus = "0"
        Date td = sf.parse(sf.format(new Date()))
        boolean isEffect = (td >= tbEntrustPerm.entrustStarttime && td <= tbEntrustPerm.entrustEndtime)
        tbEntrustPerm.entrustIsEffect = isEffect?"0":"1"
        tbEntrustPerm.accounttype = TbEntrustPerm.accounttypeMapR[tbEntrustPermEO.accounttype]
        tbEntrustPerm.certificateType = TbEntrustPerm.certificateTypeMapR[tbEntrustPermEO.certificateType]
        tbEntrustPerm.certificateNum = tbEntrustPermEO.certificateNum
        tbEntrustPerm.operator = operator //session.op.name
        return tbEntrustPerm
    }



    /**
     * 0.校验文件类型
     * 1.校验笔数 >0  and <5000
     * 2.校验模板列头
     * 3.校验是否有重复序号
     * @param f
     * @return
     */
    def checkFile(def f){
        String errMsg = ""
        def maxFileSize = 10485760
        //判空
        if(!f||f.isEmpty()){
            errMsg = "空路径或空文件不能上传"
            return [errMsg:errMsg]
        }
        //限制文件大小
        if (f.getSize() > maxFileSize) {
            errMsg = "上传文件不能大于10M"
            return [errMsg:errMsg]
        }
        //校验文件类型
        def fileName = f.getOriginalFilename()
        HSSFWorkbook workbook = null
        HSSFSheet xSheet = null
        try {
            def extension = fileName.substring(fileName.lastIndexOf(".") + 1)
            if(!extension||!extension.toUpperCase().equals("XLS")){
                errMsg = "请确认文件是否为 xls"
                return [errMsg:errMsg]
            }
            InputStream is = f.getInputStream()
            workbook = new HSSFWorkbook(is)
            xSheet = workbook.getSheetAt(0)
        }catch(Throwable e){
            errMsg = "请确认文件格式是否为 xls"
            return [errMsg:errMsg]
        }
        //校验笔数 >0  and <5000
        def maxRowNums = 5000
        if (xSheet == null) {
            errMsg = "请确认上传文件中格式跟模板一样，并且有相应数据！"
            return [errMsg:errMsg]
        }
        int rowNums = xSheet.lastRowNum + 1
        int lastRowNum = 0
        if(rowNums>(maxRowNums+1)){
            for(int rNum=xSheet.lastRowNum;rNum>(maxRowNums+1);rNum--){
                if(checkIsNullLine(xSheet.getRow(rNum))){
                    continue
                }else{
                    errMsg = "单个文件最多5000笔"
                    return [errMsg:errMsg]
                }
            }
        }else if(rowNums<2){
            errMsg = "空文件不能上传"
            return [errMsg:errMsg]
        }else if(rowNums>1&&rowNums<=(maxRowNums+1)){
            for(int rNum=(rowNums-1);rNum>0;rNum--){
                if(!checkIsNullLine(xSheet.getRow(rNum))){
                    lastRowNum = rNum
                    break
                }else if(rNum==1){
                    errMsg = "空文件不能上传"
                    return [errMsg:errMsg]
                }
            }
        }
        //校验模板列头
        HSSFRow titelRow = xSheet.getRow(0)

        for(int i=0;i<titel.length;i++){
            if(titelRow.getCell(i)?.toString()!=titel[i]){
                errMsg = "模板有误，第${i+1}列列头应为“${titel[i]}”"
                return [errMsg:errMsg]
            }
        }
        //校验是否有重复序号
        Map seqNoMap = new HashMap()
        Integer seqNo = 0
        for(int rNum=1;rNum<=lastRowNum;rNum++){
            try{
                if(!(xSheet.getRow(rNum)?.getCell(0)?.toString()?.trim())){
                    errMsg = "文件中第${rNum+1}行，序号列为空值,请更正"
                    return [errMsg:errMsg]
                }
                seqNo = xSheet.getRow(rNum).getCell(0).getNumericCellValue()
            }catch(Throwable e){
                errMsg = "文件中第${rNum+1}行，序号列为非数值类型,请更正"
                return [errMsg:errMsg]
            }


            if(seqNo>0){
                if(seqNoMap.keySet().contains(seqNo)){
                    errMsg = "序号${seqNo}重复"
                    return [errMsg:errMsg]
                }else{
                    seqNoMap.put(seqNo,"1")
                }
            }
        }

        //构造键值对
        HSSFRow row = null
        Map keysMap = new HashMap()
        String keyStr = ""
        for(int rNum=1;rNum<=lastRowNum;rNum++){
            row = xSheet.getRow(rNum)
            if(row){
                keyStr=""
                keyStr = keyStr.concat("${row.getCell(1)?.toString()}|")
                keyStr = keyStr.concat("${row.getCell(2)?.toString()}|")
                keyStr = keyStr.concat("${row.getCell(3)?.toString()}|")
                keyStr = keyStr.concat("${row.getCell(10)?.toString()}")
                if(keysMap.keySet().contains(keyStr)){
                    keysMap.put(keyStr,keysMap.get(keyStr)+row.getCell(0).getNumericCellValue().intValue().toString()+",")
                }else{
                    keysMap.put(keyStr,row.getCell(0).getNumericCellValue().intValue().toString()+",")
                }
            }
        }

        [xSheet:xSheet,lastRowNum:lastRowNum,keysMap:keysMap]
    }

    private String getCellStringVal(HSSFCell cell){
        return cell?.getStringCellValue()?.
                    replaceAll("\r","")?.
                    replaceAll("\n","")?.
                    replaceAll(" ","")
    }

    /**
     * 验证字符串中是否有全角字符或汉字
     * @param input
     * @return
     */
    private boolean hasDoubleByte(String input){
		return (input.length()<input.bytes.length)
    }

    /**
     * 最长25个字符,必填
     * @param cell
     * @return
     */
    private def checkCardname(HSSFCell cell){
        String cardname = ""
        String errMsg = ""
        try{
            cardname = getCellStringVal(cell)
            if(!cardname){
                errMsg = "开户名为必填项|<br/>"
                return [errMsg:errMsg,checkVal:cardname]
            }else if(cardname.length()>25){
                errMsg = "开户名最长为25个字符|<br/>"
                return [errMsg:errMsg,checkVal:cardname]
            }
        }catch (Throwable e){
            errMsg = "开户名单元格格式错误，请改为文本格式|<br/>"
            return [errMsg:errMsg,checkVal:formatErrVal]
        }
        [errMsg:errMsg,checkVal:cardname]
    }
    /**
     *  25个字符,必填,标准银行
     * @param cell
     * @return
     */
    private def checkAccountname(HSSFCell cell){
        String accountname = ""
        String errMsg = ""
        try{
            accountname = getCellStringVal(cell)
            if(!accountname){
                errMsg = "开户银行为必填项|<br/>"
                return [errMsg:errMsg,checkVal:accountname]
            }else if(accountname.length()>25){
                errMsg = "开户银行最长为25个字符|<br/>"
                return [errMsg:errMsg,checkVal:accountname]
            }
        }catch (Throwable e){
            errMsg = "开户银行单元格格式错误，请改为文本格式|<br/>"
            return [errMsg:errMsg,checkVal:formatErrVal]
        }
        if(TbAdjustBankCard.countByNote(accountname)==0){
            errMsg = "请确认开户银行是否为标准银行|<br/>"
        }
        [errMsg:errMsg,checkVal:accountname]
    }
    /**
     * 9-33位数字以及符号“-”，必填
     * @param cell
     * @return
     */
    private def checkCardnum(HSSFCell cell){
        String cardnum = ""
        String errMsg = ""
        try{
            cardnum = getCellStringVal(cell)
            if(!cardnum){
                errMsg = "开户账户为必填项|<br/>"
                return [errMsg:errMsg,checkVal:cardnum]
            }else if(cardnum.length()<9||cardnum.length()>33){
                errMsg = "开户账户长度为9-33个字符|<br/>"
                return [errMsg:errMsg,checkVal:cardnum]
            }else{
                Map c = ['0':'y','1':'y','2':'y','3':'y','4':'y','5':'y',
                        '6':'y','7':'y','8':'y','9':'y','-':'y']
                for(int i=0;i<cardnum.length();i++){
                    if(!c.get(cardnum.charAt(i).toString())){
                        errMsg = "开户账户应以数字“0-9”以及符号“-”组成|<br/>"
                        return [errMsg:errMsg,checkVal:cardnum]
                    }
                }
            }
        }catch (Throwable e){
            errMsg = "开户账户单元格格式错误，请改为文本格式|<br/>"
            return [errMsg:errMsg,checkVal:formatErrVal]
        }
        [errMsg:errMsg,checkVal:cardnum]

    }
    /**
     * 最长15个字节，非必填
     * @param cell
     * @return
     */
    private def checkEntrustUsercode(HSSFCell cell){
        String entrustUsercode = ""
        String errMsg = ""
        try{
            entrustUsercode = getCellStringVal(cell)
            if(!entrustUsercode){
                return [errMsg:errMsg,checkVal:entrustUsercode]
            }else if(hasDoubleByte(entrustUsercode)){
                errMsg = "代扣协议号有全角字符或汉字|<br/>"
                return [errMsg:errMsg,checkVal:entrustUsercode]
            }else if(entrustUsercode.length()>15){
                errMsg = "代扣协议号最长为15个字符|<br/>"
                return [errMsg:errMsg,checkVal:entrustUsercode]
            }
        }catch (Throwable e){
            errMsg = "代扣协议号单元格格式错误，请改为文本格式|<br/>"
            return [errMsg:errMsg,checkVal:formatErrVal]
        }
        [errMsg:errMsg,checkVal:entrustUsercode]

    }
    /**
     * 校验日期格式,必填
     * @param cell
     * @return
     */
    private def checkEntrustStarttime(HSSFCell cell){
        String entrustStarttime = ""
        String errMsg = ""
        try{
            try {
                entrustStarttime = cell?.getDateCellValue()?.format("yyyy-MM-dd")
                if(!entrustStarttime){
                    errMsg = "授权日期为必填项|<br/>"
                    return [errMsg:errMsg,checkVal:entrustStarttime]
                }
                if(!HSSFDateUtil.isCellDateFormatted(cell)){
                    throw new Exception("格式错误")
                }
            }catch (Throwable e0){
                entrustStarttime = cell.getStringCellValue().trim()
            }

            if(!validDate2(entrustStarttime)){
                errMsg = "授权日期无效,请修改(格式:yyyy-MM-dd)|<br/>"
                return [errMsg:errMsg,checkVal:entrustStarttime]
            }
        }catch (Throwable e){
            errMsg = "授权日期格式错误，请改为日期(yyyy-MM-dd)格式|<br/>"
            return [errMsg:errMsg,checkVal:formatErrVal]
        }
        [errMsg:errMsg,checkVal:entrustStarttime]
    }
    /**
     * 校验日期格式,必填,截止日期必须大于等于当天
     * @param cell
     * @return
     */
    private def checkEntrustEndtime(HSSFCell cell){
        String entrustEndtime = ""
        String errMsg = ""
        try{

            try {
                entrustEndtime = cell?.getDateCellValue()?.format("yyyy-MM-dd")
                if(!entrustEndtime){
                    errMsg = "截止日期为必填项|<br/>"
                    return [errMsg:errMsg,checkVal:entrustEndtime]
                }
                if(!HSSFDateUtil.isCellDateFormatted(cell)){
                    throw new Exception("格式错误")
                }
            }catch (Throwable e0){
                entrustEndtime = cell.getStringCellValue().trim()
            }
            if(!validDate2(entrustEndtime)){
                errMsg = "截止日期无效,请修改(格式:yyyy-MM-dd)|<br/>"
                return [errMsg:errMsg,checkVal:entrustEndtime]
            }
        }catch (Throwable e){
            errMsg = "截止日期格式错误，请改为日期(yyyy-MM-dd)格式|<br/>"
            return [errMsg:errMsg,checkVal:formatErrVal]
        }
        [errMsg:errMsg,checkVal:entrustEndtime]

    }
    /**
     * 授权日期必须小于截止日期
     * @param entrustStarttime
     * @param entrustEndtime
     * @return
     */
    private String checkStartAndEndTime(String entrustStarttime,String entrustEndtime){
        String errMsg = ""
        Date td = sf.parse(sf.format(new Date()))
        Date sd = sf.parse(entrustStarttime)
        Date ed = sf.parse(entrustEndtime)
        if(sd>=ed){
            errMsg = "授权日期必须小于截止日期|<br/>"
        }else if(ed<td){
            errMsg = "截止日期必须大于等于今天|<br/>"
        }
        return errMsg
    }
    /**
     * 企业、个人 必填
     * @param cell
     * @return
     */
    private def checkAccounttype(HSSFCell cell){
        String accounttype = ""
        String errMsg = ""
         try{
            accounttype = getCellStringVal(cell)
            if(!accounttype){
                errMsg = "账户类型为必填项|<br/>"
                return [errMsg:errMsg,checkVal:accounttype]
            }else if(!TbEntrustPerm.accounttypeMapR[accounttype]){
                errMsg = "账户类型无效|<br/>"
                return [errMsg:errMsg,checkVal:accounttype]
            }
        }catch (Throwable e){
            errMsg = "账户类型单元格格式错误，请改为文本格式|<br/>"
            return [errMsg:errMsg,checkVal:formatErrVal]
        }
        [errMsg:errMsg,checkVal:accounttype]

    }
    /**
     * 身份证,户口簿,军官证,士兵证,护照，台胞证  必填
     * @param cell
     * @return
     */
    private def checkCertificateType(HSSFCell cell){
        String certificateType = ""
        String errMsg = ""
         try{
            certificateType = getCellStringVal(cell)
            if(!certificateType){
                errMsg = "证件类型为必填项|<br/>"
                return [errMsg:errMsg,checkVal:certificateType]
            }else if(!TbEntrustPerm.certificateTypeMapR[certificateType]){
                errMsg = "证件类型无效|<br/>"
                return [errMsg:errMsg,checkVal:certificateType]
            }
        }catch (Throwable e){
            errMsg = "证件类型单元格格式错误，请改为文本格式|<br/>"
            return [errMsg:errMsg,checkVal:formatErrVal]
        }
        [errMsg:errMsg,checkVal:certificateType]

    }
    /**
     * 最长30 必填
     * @param cell
     * @return
     */
    private def checkCertificateNum(HSSFCell cell){
        String certificateNum = ""
        String errMsg = ""
        try{
            certificateNum = getCellStringVal(cell)
            if(!certificateNum){
                errMsg = "证件号为必填项|<br/>"
                return [errMsg:errMsg,checkVal:certificateNum]
            }else if(hasDoubleByte(certificateNum)){
                errMsg = "证件号有全角字符或汉字|<br/>"
                return [errMsg:errMsg,checkVal:certificateNum]
            }else if(certificateNum.length()>30){
                errMsg = "证件号最长30个字符|<br/>"
                return [errMsg:errMsg,checkVal:certificateNum]
            }
        }catch (Throwable e){
            errMsg = "证件号单元格格式错误，请改为文本格式|<br/>"
            return [errMsg:errMsg,checkVal:formatErrVal]
        }
        [errMsg:errMsg,checkVal:certificateNum]

    }
    /**
     * 商户号  必填 且 必须 存在
     * @param cell
     * @return
     */
    private def checkCustomerNo(HSSFCell cell){
        String customerNo = ""
        String errMsg = ""
        try{
            customerNo = getCellStringVal(cell)
            if(!customerNo){
                errMsg = "所属商户为必填项|<br/>"
                return [errMsg:errMsg,checkVal:customerNo]
            }
        }catch (Throwable e){
            errMsg = "所属商户单元格格式错误，请改为文本格式|<br/>"
            return [errMsg:errMsg,checkVal:formatErrVal]
        }
        if(CmCustomer.countByCustomerNo(customerNo)==0){
            errMsg = "所属商户不存在|<br/>"
        }
        [errMsg:errMsg,checkVal:customerNo]

    }
    /**
     * 验证库中是否已存在
     * @param cardname
     * @param accountname
     * @param cardnum
     * @param customerNo
     * @return
     */
    private boolean checkIsExist(String cardname,String accountname,String cardnum,String customerNo){
        String queryCount = """select count(1) as COUNT from tb_entrust_perm
        where CARDNAME='${cardname}' and ACCOUNTNAME='${accountname}'
        and CARDNUM='${cardnum}' and CUSTOMER_NO='${customerNo}'
        """
        def sql = new Sql(dataSource_dsf)
        if(sql.firstRow(queryCount,[]).COUNT>0){
            return true
        }
        return false
    }
    /**
     * 验证excel里是否有重复数据
     * @param tbEntrustPermEOList
     * @param seqNo
     * @param cardname
     * @param accountname
     * @param cardnum
     * @param customerNo
     * @return
     */
    private String checkIsDuplicate(Map keysMap,String seqNo,
                         String cardname,String accountname,String cardnum,String customerNo){

        String errMsg = ""
        String keyStr=""
        keyStr = keyStr.concat("${cardname}|")
        keyStr = keyStr.concat("${accountname}|")
        keyStr = keyStr.concat("${cardnum}|")
        keyStr = keyStr.concat("${customerNo}")

        String [] seqNos = keysMap.get(keyStr).toString().split(",")
        if(seqNos.length>1){
            errMsg = "与第"
            for(int i=0;i<seqNos.length;i++){
                if(seqNo!=seqNos[i]){
                    errMsg = errMsg.concat("${seqNos[i]},")
                }

            }
            errMsg = errMsg.subSequence(0,errMsg.length()-1)
            errMsg = errMsg.concat("笔互为重复数据|<br/>")
        }
        return  errMsg
    }

    /**
     * 是否为空行
     * @param row
     * @return
     */
    private boolean checkIsNullLine(HSSFRow row){
        boolean res = true
        if(!row){
            return res
        }
        for(int i=0;i<titel.length;i++){
            res=(res&&!(row.getCell(i)?.toString()?.trim()))
        }
        return res
    }

    /**
     * 用SimpleDateFormat验证日期有效性 yyyy-MM-dd
     * @param sDate
     * @return
     */
    private  boolean validDate2(String sDate) {
        SimpleDateFormat format = new SimpleDateFormat("yyyy-MM-dd");
        try{
            Date temp = format.parse(sDate);
            String str = format.format(temp);
            //success
            if (str.equals(sDate))
                return true;
            else
                return false;
        } catch (Exception e){
            return false;
        }
	}
    /**
     *  用正则验证日期有效性 yyyy-MM-dd
     * @param sDate
     * @return
     */
    private  boolean validDate(String sDate) {
		String datePattern1 = "\\d{4}-\\d{2}-\\d{2}";
		String datePattern2 = "^((\\d{2}(([02468][048])|([13579][26]))[\\-\\/\\s]?((((0?[13578])|(1[02]))[\\-\\/\\s]?((0?[1-9])|([1-2][0-9])|(3[01])))|(((0?[469])|(11))[\\-\\/\\s]?((0?[1-9])|([1-2][0-9])|(30)))|(0?2[\\-\\/\\s]?((0?[1-9])|([1-2][0-9])))))|(\\d{2}(([02468][1235679])|([13579][01345789]))[\\-\\/\\s]?((((0?[13578])|(1[02]))[\\-\\/\\s]?((0?[1-9])|([1-2][0-9])|(3[01])))|(((0?[469])|(11))[\\-\\/\\s]?((0?[1-9])|([1-2][0-9])|(30)))|(0?2[\\-\\/\\s]?((0?[1-9])|(1[0-9])|(2[0-8]))))))"
		if ((sDate != null)) {
			Pattern pattern = Pattern.compile(datePattern1);
			Matcher match = pattern.matcher(sDate);
			if (match.matches()) {
				pattern = Pattern.compile(datePattern2);
				match = pattern.matcher(sDate);
				return match.matches();
			} else {
				return false;
			}
		}
		return false;
	}

    /**
     * 定时更新授权是否有效的状态
     * @return
     */
    def updateEntrustIsEffect(){
        String td = sf.format(new Date())
        //置有效
        String sql1 = """
                update tb_entrust_perm t set t.entrust_is_effect='0' where
        (to_date('${td}','yyyy-MM-dd')>=t.entrust_starttime and to_date('${td}','yyyy-MM-dd')<=t.entrust_endtime
        and t.entrust_status='0')
        and t.entrust_is_effect='1'
        """
        //置无效
        String sql2 = """
                update tb_entrust_perm t set t.entrust_is_effect='1' where
        (to_date('${td}','yyyy-MM-dd')<t.entrust_starttime or to_date('${td}','yyyy-MM-dd')>t.entrust_endtime
        or t.entrust_status='1')
        and t.entrust_is_effect='0'
        """
        TbEntrustPerm.withTransaction {status ->
            HibernateTemplate ht = DatasourcesUtils.newHibernateTemplate('dsf')
            ht.execute({ Session session ->
                session.createSQLQuery(sql1).executeUpdate()
                session.createSQLQuery(sql2).executeUpdate()
                session.flush()
                session.clear()
            } as HibernateCallback)
        }
    }
}
