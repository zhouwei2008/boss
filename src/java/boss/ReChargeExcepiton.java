/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */

package boss;

/**
 *
 * @author kevin
 */
public class ReChargeExcepiton extends RuntimeException{

    private String resultmsg="TRADE_SUCCESS";



    public ReChargeExcepiton(){
        super();
    }

    public ReChargeExcepiton(String resultmsg){
       this.resultmsg=resultmsg;
    }
    public ReChargeExcepiton(String resultmsg,String message){
        super(message);
        this.resultmsg=resultmsg;
    }

    public String getResultmsg() {
        return resultmsg;
    } 
}
