public class RecursiveTriggerHandler {
    public static Boolean isFirstTime = true;
    //This variable is used to enable name change from the member search level for SNI
    public static Boolean nameChangeEnabled = false;
    
	//Please do not use this static variable any other place as its used in common transaction	
	public static Boolean restrictOwnerChange= true;//Code added - US2556794
    public static Boolean allowSNICase=false;
	public static Boolean sniProfileCheck =null;
   public static Boolean emailcheck =false;
   public static Boolean userEmailCheck =false;
    public static Boolean HSIDAccTrigAftUpdtFlg =false;
    public static Boolean HSIDPlguinFlg =false;
    public static Boolean careTeam_FirstTime =true;//Code Added - US2736623
    public static Boolean isFirstCaseHistory = true;//Code Added - US3153104
}