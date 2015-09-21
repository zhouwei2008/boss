package HunionPay;

/**
 * Created by IntelliJ IDEA.
 * User: syw
 * Date: 11-12-2
 * Time: 下午2:24
 * To change this template use File | Settings | File Templates.
 */

    import java.io.ByteArrayOutputStream;
import java.io.FileInputStream;
import java.io.FileNotFoundException;
import java.io.IOException;
import java.io.InputStream;
import java.io.PrintWriter;
import java.io.UnsupportedEncodingException;
import java.math.BigInteger;
import java.net.HttpURLConnection;
import java.net.URL;
import java.nio.ByteBuffer;
import java.nio.CharBuffer;
import java.nio.charset.CharacterCodingException;
import java.nio.charset.Charset;
import java.nio.charset.CharsetDecoder;
import java.security.Key;
import java.security.KeyStore;
import java.security.SecureRandom;
import java.security.Security;
import java.security.Signature;
import java.security.UnrecoverableKeyException;
import java.security.cert.CertificateException;
import java.security.cert.CertificateFactory;
import java.security.cert.X509Certificate;
import java.security.interfaces.RSAPrivateCrtKey;
import java.security.interfaces.RSAPublicKey;
import java.util.Enumeration;
import java.util.ResourceBundle;
import javax.crypto.Cipher;
import javax.crypto.KeyGenerator;
import javax.crypto.SecretKey;
import javax.crypto.spec.IvParameterSpec;
import org.bouncycastle.jce.provider.BouncyCastleProvider;
    import org.jpos.iso.ISOUtil;

public class Crypt
{
  private FileInputStream certfile;
  private boolean isConvertEncode = true;
  protected String lastResult;
  private String sessionMsg;
  protected String lastErrMsg;
  protected String lastSignMsg;
  private boolean isTestServer = true;

  public Crypt()
  {
    Security.addProvider(new BouncyCastleProvider());
  }

  public boolean EncryptMsg(String TobeEncrypted, String CertFile)
  {
    boolean result = false;
    FileInputStream certfile = null;
    try {
      certfile = new FileInputStream(CertFile);

      CertificateFactory cf = CertificateFactory.getInstance("X.509");

      X509Certificate x509cert = (X509Certificate)cf
        .generateCertificate(certfile);
      RSAPublicKey pubkey = (RSAPublicKey)x509cert.getPublicKey();
      BigInteger mod = pubkey.getModulus();

      int keylen = mod.bitLength() / 8;
      if (TobeEncrypted.length() > keylen - 11)
      {
        Cipher pub = Cipher.getInstance("RSA/NONE/PKCS1Padding", "BC");
        pub.init(3, pubkey);

        KeyGenerator kp = KeyGenerator.getInstance("DESEDE");
        kp.init(new SecureRandom());
        SecretKey sk = kp.generateKey();

        byte[] wrappedKey = pub.wrap(sk);

        pub = Cipher.getInstance("DESEDE/OFB/NoPadding");
        pub.init(1, sk);

        byte[] encrypted = pub.doFinal(TobeEncrypted.getBytes());
        byte[] iv = pub.getIV();
        byte[] enc_ascii = new byte[encrypted.length * 2];
        byte[] iv_asc = new byte[iv.length * 2];
        byte[] prikey_asc = new byte[wrappedKey.length * 2];
        Hex2Ascii(encrypted.length, encrypted, enc_ascii);
        Hex2Ascii(iv.length, iv, iv_asc);
        Hex2Ascii(wrappedKey.length, wrappedKey, prikey_asc);
        this.lastResult =
          (new String(iv_asc) + new String(prikey_asc) +
          new String(enc_ascii));
      } else {
        Cipher pub = Cipher.getInstance("RSA/NONE/PKCS1Padding", "BC");
        pub.init(1, pubkey);
        byte[] encrypted = pub.doFinal(TobeEncrypted.getBytes());
        byte[] enc_ascii = new byte[encrypted.length * 2];
        Hex2Ascii(encrypted.length, encrypted, enc_ascii);
        this.lastResult = new String(enc_ascii);
      }

      result = true;
    } catch (CertificateException e) {
      e.printStackTrace();
      this.lastErrMsg = "Error Number:-10016, Error Description: ER_CERT_PARSE_ERROR（证书解析错误）";
      result = false;
    } catch (FileNotFoundException e) {
      e.printStackTrace();
      this.lastErrMsg = "Error Number:-10005, Error Description: ER_FIND_CERT_FAILED（找不到证书）";
      result = false;
    } catch (Exception e) {
      e.printStackTrace();
      this.lastErrMsg =
        ("Error Number:-10022, Error Description: ER_ENCRYPT_ERROR（加密失败）" +
        e.toString());
      result = false;
    } finally {
      try {
        if (!certfile.equals(null))
          certfile.close();
      }
      catch (IOException e) {
        e.printStackTrace();
        this.lastErrMsg = "Error Number:-10030, Error Description: ER_CLOSEFILE_ERROR（证书文件关闭失败）";
        result = false;
      }
    }

    return result;
  }

  public boolean DecryptMsg(String TobeDecrypted, String KeyFile, String PassWord)
  {
    boolean result = false;
    FileInputStream fiKeyFile = null;
    try {
      KeyStore ks = KeyStore.getInstance("PKCS12");

      fiKeyFile = new FileInputStream(KeyFile);
      ks.load(fiKeyFile, PassWord.toCharArray());
      Enumeration myEnum = ks.aliases();
      String keyAlias = null;
      RSAPrivateCrtKey prikey = null;

      while (myEnum.hasMoreElements()) {
        keyAlias = (String)myEnum.nextElement();

        if (ks.isKeyEntry(keyAlias)) {
          prikey = (RSAPrivateCrtKey)ks.getKey(keyAlias,
            PassWord.toCharArray());
          break;
        }
      }
      if (prikey == null) {
        this.lastErrMsg = "Error Number:-10015, Error Description: ER_PRIKEY_CANNOT_FOUND（没有找到匹配私钥）";
        result = false;
      }
      else
      {
        BigInteger mod = prikey.getModulus();
        int keylen = mod.bitLength() / 8;
        if (TobeDecrypted.length() > keylen * 2) {
          byte[] iv_asc = TobeDecrypted.substring(0, 16).getBytes();
          byte[] prikey_asc = TobeDecrypted.substring(iv_asc.length,
            iv_asc.length + keylen * 2).getBytes();
          byte[] enc_ascii = TobeDecrypted.substring(
            iv_asc.length + keylen * 2).getBytes();

          byte[] iv = new byte[8];
          byte[] unwrappedkey = new byte[prikey_asc.length / 2];
          byte[] decrypted = new byte[enc_ascii.length / 2];

          Ascii2Hex(iv_asc.length, iv_asc, iv);
          Ascii2Hex(prikey_asc.length, prikey_asc, unwrappedkey);
          Ascii2Hex(enc_ascii.length, enc_ascii, decrypted);

          Cipher pri = Cipher.getInstance("RSA/NONE/PKCS1Padding", "BC");
          pri.init(4, prikey);
          Key unwrappedKey = pri.unwrap(unwrappedkey, "DESEDE",
            3);

          IvParameterSpec ivspec = new IvParameterSpec(iv);
          pri = Cipher.getInstance("DESEDE/OFB/NoPadding");
          pri.init(2, unwrappedKey, ivspec);

          this.lastResult = new String(pri.doFinal(decrypted));
        }
        else {
          Cipher pri = Cipher.getInstance("RSA/NONE/PKCS1Padding", "BC");
          pri.init(2, prikey);
          byte[] enc_ascii = TobeDecrypted.getBytes();
          byte[] decrypted = new byte[enc_ascii.length / 2];
          Ascii2Hex(enc_ascii.length, enc_ascii, decrypted);
          byte[] decryptout = pri.doFinal(decrypted);

          this.lastResult = new String(decryptout);
        }

        result = true;
      }
    }
    catch (FileNotFoundException e) {
      e.printStackTrace();
      this.lastErrMsg = "Error Number:-10005, Error Description: ER_FIND_CERT_FAILED（找不到证书）";
      result = false;
    } catch (UnrecoverableKeyException e) {
      e.printStackTrace();
      this.lastErrMsg = "Error Number:-10015, Error Description: ER_PRIKEY_CANNOT_FOUND（没有找到匹配私钥）";
      result = false;
    } catch (IOException e) {
      e.printStackTrace();
      this.lastErrMsg = "Error Number:-10015, Error Description: ER_PRIKEY_CANNOT_FOUND（没有找到匹配私钥）";
      result = false;
    } catch (Exception e) {
      e.printStackTrace();
      this.lastErrMsg = "Error Number:-10023, Error Description: ER_DECRYPT_ERROR（解密失败）";
      result = false;
    }
    finally {
      try {
        if (!fiKeyFile.equals(null))
          fiKeyFile.close();
      }
      catch (Exception e) {
        e.printStackTrace();
        this.lastErrMsg = "Error Number:-10030, Error Description: ER_CLOSEFILE_ERROR（证书文件关闭失败）";
        result = false;
      }
    }
    return result;
  }

  public boolean SignMsg(String TobeSigned, String KeyFile, String PassWord)
  {
    boolean result = false;
    FileInputStream fiKeyFile = null;
    try {
      this.lastSignMsg = "";
      KeyStore ks = KeyStore.getInstance("PKCS12");

      fiKeyFile = new FileInputStream(KeyFile);
      ks.load(fiKeyFile, PassWord.toCharArray());
      Enumeration myEnum = ks.aliases();
      String keyAlias = null;
      RSAPrivateCrtKey prikey = null;

      while (myEnum.hasMoreElements()) {
        keyAlias = (String)myEnum.nextElement();

        if (ks.isKeyEntry(keyAlias)) {
          prikey = (RSAPrivateCrtKey)ks.getKey(keyAlias,
            PassWord.toCharArray());
          break;
        }
      }
      if (prikey == null) {
        this.lastErrMsg = "Error Number:-10015, Error Description: ER_PRIKEY_CANNOT_FOUND（没有找到匹配私钥）";
        result = false;
      }
      else
      {
        Signature sign = Signature.getInstance("SHA1withRSA");
        sign.initSign(prikey);
       //TobeSigned= ISOUtil.hexString(TobeSigned.getBytes("GBK"));  //进行处理
        sign.update(TobeSigned.getBytes("GBK"));
        byte[] signed = sign.sign();
        byte[] sign_asc = new byte[signed.length * 2];
        Hex2Ascii(signed.length, signed, sign_asc);
        this.lastResult = new String(sign_asc);
        this.lastSignMsg = this.lastResult;
        result = true;
      }
    }
    catch (FileNotFoundException e) {
      e.printStackTrace();
      this.lastErrMsg = "Error Number:-10005, Error Description: ER_FIND_CERT_FAILED（找不到证书）";
      result = false;
    } catch (UnrecoverableKeyException e) {
      e.printStackTrace();
      this.lastErrMsg =
        ("Error Number:-10015, Error Description: ER_PRIKEY_CANNOT_FOUND（没有找到匹配私钥） | Exception:" +
        e.getMessage());
      result = false;
    } catch (IOException e) {
      e.printStackTrace();
      this.lastErrMsg =
        ("Error Number:-10015, Error Description: ER_PRIKEY_CANNOT_FOUND（没有找到匹配私钥） | Exception:" +
        e.getMessage());
      result = false;
    } catch (Exception e) {
      e.printStackTrace();
      this.lastErrMsg =
        ("Error Number:-10020, Error Description: ER_SIGN_ERROR（签名失败）" +
        e.toString() + "| Exception:" + e.getMessage());
      result = false;
    } finally {
      try {
        if (!fiKeyFile.equals(null))
          fiKeyFile.close();
      }
      catch (Exception e) {
        e.printStackTrace();
        this.lastErrMsg = "Error Number:-10030, Error Description: ER_CLOSEFILE_ERROR（证书文件关闭失败）";
        result = false;
      }
    }
    return result;
  }

  public boolean VerifyMsg(String TobeVerified, String PlainText, String CertFile)
  {
    boolean result = false;
    FileInputStream certfile = null;
    try {
      certfile = new FileInputStream(CertFile);
      CertificateFactory cf = CertificateFactory.getInstance("X.509");
      X509Certificate x509cert = (X509Certificate)cf
        .generateCertificate(certfile);
      RSAPublicKey pubkey = (RSAPublicKey)x509cert.getPublicKey();
      Signature verify = Signature.getInstance("SHA1withRSA");
      verify.initVerify(pubkey);
      byte[] signeddata = new byte[TobeVerified.length() / 2];
      Ascii2Hex(TobeVerified.length(), TobeVerified.getBytes(),
        signeddata);
      verify.update(PlainText.getBytes("GBK"));
      if (verify.verify(signeddata)) {
        result = true;
      } else {
        this.lastErrMsg = "Error Number:-10021, Error Description:ER_VERIFY_ERROR（验签失败）";
        result = false;
      }
    }
    catch (CertificateException e) {
      e.printStackTrace();
      this.lastErrMsg = "Error Number:-10016, Error Description: ER_CERT_PARSE_ERROR（证书解析错误）";
      result = false;
    } catch (Exception e) {
      e.printStackTrace();
      this.lastErrMsg = "Error Number:-10021, Error Description: ER_VERIFY_ERROR（验签失败）";
      result = false;
    } finally {
      try {
        if (!certfile.equals(null))
          certfile.close();
      }
      catch (IOException e) {
        e.printStackTrace();
        this.lastErrMsg = "Error Number:-10021, Error Description: ER_VERIFY_ERROR（验签失败）";
        result = false;
      }
    }

    return result;
  }

  /** @deprecated */
  public String LastResult()
  {
    return this.lastResult;
  }

  public String getLastResult()
  {
    return this.lastResult;
  }

  /** @deprecated */
  public String LastErrMsg()
  {
    return this.lastErrMsg;
  }

  public String getLastErrMsg()
  {
    return this.lastErrMsg;
  }

  public String getLastSignMsg()
  {
    return this.lastSignMsg;
  }

  private static void Hex2Ascii(int len, byte[] data_in, byte[] data_out)
  {
    byte[] temp1 = new byte[1];
    byte[] temp2 = new byte[1];
    int i = 0; for (int j = 0; i < len; ++i) {
      temp1[0] = data_in[i];
      temp1[0] = (byte)(temp1[0] >>> 4);
      temp1[0] = (byte)(temp1[0] & 0xF);
      temp2[0] = data_in[i];
      temp2[0] = (byte)(temp2[0] & 0xF);
      if ((temp1[0] >= 0) && (temp1[0] <= 9))
        data_out[j] = (byte)(temp1[0] + 48);
      else if ((temp1[0] >= 10) && (temp1[0] <= 15)) {
        data_out[j] = (byte)(temp1[0] + 87);
      }

      if ((temp2[0] >= 0) && (temp2[0] <= 9))
        data_out[(j + 1)] = (byte)(temp2[0] + 48);
      else if ((temp2[0] >= 10) && (temp2[0] <= 15)) {
        data_out[(j + 1)] = (byte)(temp2[0] + 87);
      }
      j += 2;
    }
  }

  private static void Ascii2Hex(int len, byte[] data_in, byte[] data_out)
  {
    byte[] temp1 = new byte[1];
    byte[] temp2 = new byte[1];
    int i = 0; for (int j = 0; i < len; ++j) {
      temp1[0] = data_in[i];
      temp2[0] = data_in[(i + 1)];
      if ((temp1[0] >= 48) && (temp1[0] <= 57))
      {
        int tmp53_52 = 0;
        byte[] tmp53_51 = temp1; tmp53_51[tmp53_52] = (byte)(tmp53_51[tmp53_52] - 48);
        temp1[0] = (byte)(temp1[0] << 4);

        temp1[0] = (byte)(temp1[0] & 0xF0);
      }
      else if ((temp1[0] >= 97) && (temp1[0] <= 102))
      {
        int tmp101_100 = 0;
        byte[] tmp101_99 = temp1; tmp101_99[tmp101_100] = (byte)(tmp101_99[tmp101_100] - 87);
        temp1[0] = (byte)(temp1[0] << 4);
        temp1[0] = (byte)(temp1[0] & 0xF0);
      }

      if ((temp2[0] >= 48) && (temp2[0] <= 57))
      {
        int tmp149_148 = 0;
        byte[] tmp149_146 = temp2; tmp149_146[tmp149_148] = (byte)(tmp149_146[tmp149_148] - 48);

        temp2[0] = (byte)(temp2[0] & 0xF);
      }
      else if ((temp2[0] >= 97) && (temp2[0] <= 102))
      {
        int tmp192_191 = 0;
        byte[] tmp192_189 = temp2; tmp192_189[tmp192_191] = (byte)(tmp192_189[tmp192_191] - 87);

        temp2[0] = (byte)(temp2[0] & 0xF);
      }
      data_out[j] = (byte)(temp1[0] | temp2[0]);

      i += 2;
    }
  }

  protected String replaceAll(String strURL, String strAugs)
  {
    int start = 0;
    int end = 0;
    String temp = new String();
    while (start < strURL.length()) {
      end = strURL.indexOf(" ", start);
      if (end != -1) {
        temp = temp.concat(strURL.substring(start, end).concat("%20"));
        if ((start = end + 1) >= strURL.length()) {
          strURL = temp;
          break;
        }
      }
      else if (end == -1) {
        if (start == 0)
          break;
        if (start < strURL.length()) {
          temp = temp
            .concat(strURL.substring(start, strURL.length()));
          strURL = temp;
          break;
        }
      }

    }

    temp = "";
    start = end = 0;

    while (start < strAugs.length()) {
      end = strAugs.indexOf(" ", start);
      if (end != -1) {
        temp = temp.concat(strAugs.substring(start, end).concat("%20"));
        if ((start = end + 1) >= strAugs.length()) {
          strAugs = temp;
          break;
        }
      }
      else if (end == -1) {
        if (start == 0)
          break;
        if (start < strAugs.length()) {
          temp = temp.concat(strAugs
            .substring(start,
            strAugs.length()));
          strAugs = temp;
          break;
        }

      }

    }

    return strAugs;
  }

  protected boolean GetURL(String strURL, String strAugs)
  {
    return sendUrl(strURL, strAugs, null);
  }

  public boolean sendUrl(String strUrl, String augs, String strSession)
  {
    String new_strAugs = replaceAll(strUrl, augs);
    try
    {
      URL url = new URL(strUrl);
      HttpURLConnection XMLHTTP = (HttpURLConnection)url
        .openConnection();
      if (strSession != null) {
        XMLHTTP.setRequestProperty("Cookie", strSession);
      }
      XMLHTTP.setRequestMethod("POST");
      XMLHTTP.setDoOutput(true);
      PrintWriter pw = new PrintWriter(XMLHTTP.getOutputStream());
      pw.println(new_strAugs);
      pw.close();

      if (XMLHTTP.getResponseCode() != 200) {
        this.lastErrMsg =
          ("Error Number:-00006, Error Description: GET_RESULT_ERROR（获取结果失败:" +
          changeEncode2UTF8("GBK",
          XMLHTTP.getResponseMessage()) + "）");
        this.lastErrMsg =
          (this.lastErrMsg + "<br>\nsend param is:" + strUrl + "?" +
          new_strAugs);
        XMLHTTP.disconnect();
        return false;
      }

      String strCookie = XMLHTTP.getHeaderField("Set-Cookie");
      if (strCookie != null) {
        int n = strCookie.indexOf(';');
        this.sessionMsg = strCookie.substring(0, n);
      }

      int ContentLen = XMLHTTP.getContentLength();

      if (ContentLen > 0) {
        ByteArrayOutputStream o1 = new ByteArrayOutputStream(ContentLen);
        InputStream in = XMLHTTP.getInputStream();

        int totalreadCount = 0;
        while (totalreadCount < ContentLen) {
          int avaliable = in.available();
          byte[] bytes = new byte[avaliable];
          int readCount = 0;
          while (readCount < avaliable)
          {
            readCount = readCount + in
              .read(bytes, readCount, avaliable -
              readCount);
          }

          o1.write(bytes);
          totalreadCount += readCount;
        }

        XMLHTTP.disconnect();
        if (this.isConvertEncode)
        {
          this.lastResult =
            changeEncode2UTF8("GBK",
            o1.toByteArray());
        }
        else
          this.lastResult = new String(o1.toByteArray());
        o1.close();

        return true;
      }
      this.lastErrMsg = "Error Number:-00001, Error Description: RETURN_BLANK（远程服务器返回空页面）";
      this.lastErrMsg =
        (this.lastErrMsg + "<br>\nsend param is:" + strUrl + "?" +
        new_strAugs);
      XMLHTTP.disconnect();
      return false;
    }
    catch (Exception e) {
      e.printStackTrace();
      this.lastErrMsg =
        ("Error Number:-00009, Error Description: NETWORK_ERROR（网络故障:" +
        e.getMessage() + "）");
      this.lastErrMsg =
        (this.lastErrMsg + "<br>\nsend param is:" + strUrl + "?" +
        new_strAugs);
    }return false;
  }

  public String getSessionMsg()
  {
    return this.sessionMsg;
  }

  public void setSessionMsg(String sessionMsg)
  {
    this.sessionMsg = sessionMsg;
  }

  private String changeEncode2UTF8(String originEncode, String originMsg)
    throws CharacterCodingException, UnsupportedEncodingException
  {
    Charset gbkCharset = Charset.forName(originEncode);
    CharsetDecoder decoder = gbkCharset.newDecoder();
    ByteBuffer byteBuf = ByteBuffer.wrap(originMsg.getBytes("GBK"));
    CharBuffer charBuf = decoder.decode(byteBuf);
    if (charBuf.array().length == 0) {
      return originMsg;
    }

    return new String(charBuf.array());
  }

  private String changeEncode2UTF8(String originEncode, byte[] info) throws CharacterCodingException, UnsupportedEncodingException
  {
    Charset gbkCharset = Charset.forName(originEncode);
    CharsetDecoder decoder = gbkCharset.newDecoder();
    ByteBuffer byteBuf = ByteBuffer.wrap(info);
    CharBuffer charBuf = decoder.decode(byteBuf);
    if (charBuf.array().length == 0) {
      return new String(info);
    }
    return new String(charBuf.array());
  }

  protected String getProperties(String key, String propFile)
  {
    ResourceBundle rb = null;
    if (this.isTestServer)
      rb = ResourceBundle.getBundle(propFile + "Test");
    else {
      rb = ResourceBundle.getBundle(propFile);
    }
    return rb.getString(key);
  }

  public boolean isTestServer()
  {
    return this.isTestServer;
  }

  public void setTestServer(boolean isTestServer)
  {
    this.isTestServer = isTestServer;
  }

  public boolean isConvertEncode()
  {
    return this.isConvertEncode;
  }

  public void setConvertEncode(boolean isConvertEncode)
  {
    this.isConvertEncode = isConvertEncode;
  }
}

