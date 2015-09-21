package boss;
import java.util.Random;

public class GetNumRandom {
public static final String allChar = "0123456789";
    public static String generateString(int length)

    {
     StringBuffer sb = new StringBuffer();
     Random random = new Random();
     for (int i = 0; i < length; i++) {
             sb.append(allChar.charAt(random.nextInt(allChar.length())));

     }
      return sb.toString();
     }

	public static void main(String[] args) {
	   System.out.println(generateString(32));
      // System.out.println(System.getProperty("java.version"));
	  // sb.delete(0, sb.length());
	}
}
