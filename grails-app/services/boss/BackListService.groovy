package boss

import org.apache.log4j.Logger
import org.springframework.web.multipart.MultipartFile

import java.text.SimpleDateFormat

/**
 * Created with IntelliJ IDEA.
 * User: admin
 * Date: 13-12-9
 * Time: 上午11:09
 * To change this template use File | Settings | File Templates.
 */
class BackListService {
    static transactional = true
    private Logger logger = Logger.getLogger(BackListService.class);
    def RESP_RESULT_SUCC = 'true' //成功
    def RESP_RESULT_FAIL = 'false' //失败
//    def UPLOAD_URL = 'E:\\workspace\\paywing\\boss\\web-app\\Uploadfile'
    def  UPLOAD_URL = '/home/production/uploads/boss/web-app/Uploadfile'

    def  processData(String fname, MultipartFile mfile,String type){
        //保存XLS文件
        final String mname=fname;//文件名
        String dirPath = UPLOAD_URL; //保存全路径
        if(!new File(dirPath).exists()){
            new File(dirPath).mkdirs(); //创建文件路径
        }
        if(fname.indexOf(".")==-1 || !fname.substring(fname.lastIndexOf(".")+1).toUpperCase().equals("XLS")){
            return respXml(RESP_RESULT_FAIL,"上传文件类型错误,请重新上传!","");
        }
        if(mfile.getOriginalFilename().indexOf(",")!= -1 || mfile.getOriginalFilename().indexOf("-")!= -1 || fname.substring(0,fname.lastIndexOf(".")).indexOf(".")!=-1){

            return respXml(RESP_RESULT_FAIL,"上传文件名格式不正确，包含',- .'等非法字符。","");
        }

        String tarFile =fname.substring(0,fname.indexOf(".")+1)+fname.substring(fname.indexOf(".")+1).toUpperCase();
        String filePath = dirPath + File.separator;
        def sdf = new SimpleDateFormat("yyyyMMddHHmmss")//格式化时间输出
        def rname = sdf.format(new Date())
        if(type.equals('C')){
            filePath += 'C'+rname+tarFile
        }else if(type.equals('P')){
            filePath += 'P'+rname+tarFile
        }
        File file = new File(filePath);  //建立新文件
        try{
            mfile.transferTo(file);     //保存文件
        }catch (Exception e){
            logger.error("保存文件" + filePath + "时出现异常。");
            return respXml(RESP_RESULT_FAIL,"报错上传文件出现异常。","");
        }
        System.out.println("XLS ======================================== " + filePath);
        return respXml(RESP_RESULT_SUCC,"",filePath);
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
