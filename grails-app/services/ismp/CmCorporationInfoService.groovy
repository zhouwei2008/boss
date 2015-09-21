package ismp

import org.apache.log4j.Logger
import org.codehaus.groovy.grails.commons.ConfigurationHolder
import org.springframework.web.multipart.MultipartFile

import java.text.SimpleDateFormat

class CmCorporationInfoService {

    static transactional = true

    private Logger logger = Logger.getLogger(CmCorporationInfoService.class);
    def RESP_RESULT_SUCC = 'true' //成功
    def RESP_RESULT_FAIL = 'false' //失败
//  def UPLOAD_URL = 'E:/haihui/boss/web-app/Uploadfile'
    def UPLOAD_URL = ConfigurationHolder.config.verified.photoUrl


    def  processData(String fname, MultipartFile mfile,String customerNo,String folder){
        //保存XLS文件
        final String mname=fname;//文件名
        String dirPath = UPLOAD_URL+"/"+folder; //保存全路径
        if(!new File(dirPath).exists()){
            new File(dirPath).mkdirs(); //创建文件路径
        }
        String endStr = fname.substring(fname.lastIndexOf(".")+1).toUpperCase();
        if(fname.indexOf(".")==-1 && !endStr.equals("IMG") && !endStr.equals("JPG") && !endStr.equals("PNG") && !endStr.equals("JPEG") && !endStr.equals("BMP")){
            return respXml(RESP_RESULT_FAIL,"上传文件类型错误,请重新上传!","");
        }
        if(mfile.getOriginalFilename().indexOf(",")!= -1 || mfile.getOriginalFilename().indexOf("-")!= -1 || fname.substring(0,fname.lastIndexOf(".")).indexOf(".")!=-1){
            return respXml(RESP_RESULT_FAIL,"上传文件名格式不正确，包含',- .'等非法字符。","");
        }

        String tarFile =fname.substring(0,fname.indexOf(".")+1)+fname.substring(fname.indexOf(".")+1).toUpperCase();
        String filePath = dirPath + "/";
        def sdf = new SimpleDateFormat("yyyyMMddHHmmss")//格式化时间输出
        def rname = customerNo +"_"+sdf.format(new Date()) + tarFile
        filePath += rname

        File file = new File(filePath);  //建立新文件
        try{
            mfile.transferTo(file);     //保存文件
        }catch (Exception e){
            logger.error("保存文件" + filePath + "时出现异常。");
            return respXml(RESP_RESULT_FAIL,"报错上传文件出现异常。","");
        }
        println("filePath[图片保存路径]=============="+filePath)
        return respXml(RESP_RESULT_SUCC,"",rname);
    }





    /**
     * 响应
     * @param result 响应结果 成功/失败
     * @param errMsg 原因
     * @return
     */
    def respXml(String res, String msg,String path){
        String[] r=new String[3];
        r[0]=res;
        r[1]=msg;
        r[2]=path;
        return r;
    }
}
