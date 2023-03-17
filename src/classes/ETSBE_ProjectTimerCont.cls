public class ETSBE_ProjectTimerCont {

  @AuraEnabled 
  public static void updatecaserec(string caseid,string stoptime, string isprojend){
      Case updcas = [select id,Project_Time__c,Is_Project_Time_End__c from case where id=:caseid];
      updcas.Project_Time__c=stoptime;
      if(isprojend=='true'){
      	updcas.Is_Project_Time_End__c=true;
      }
      update updcas;
  }
  @AuraEnabled 
  public static Case getcaserec(string caseid){
      Case cas = [select id,Project_Time__c,Is_Project_Time_End__c from case where id=:caseid];
      return cas;
	}   
}