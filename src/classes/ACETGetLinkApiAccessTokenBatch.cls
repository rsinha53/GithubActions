/*
    Created By: Chandan Patro
    Created Date: 29th July 2019
    Description: This class is used to refresh the access token for Link Api and send notification if it fails.
*/

public class ACETGetLinkApiAccessTokenBatch implements Database.Batchable<sObject>, Database.AllowsCallouts {
    final String[] toAddresses = new String[]{'test@test.com'}; 
    public List<Token_Generation__c> start(Database.BatchableContext BC){
        List<Token_Generation__c> lstTokenGen = new List<Token_Generation__c>([SELECT Id, Name, Value__c,Token_Name__c
                              FROM Token_Generation__c WHERE Token_Name__c =: 'LinkAPIAccessToken']);


        system.debug(LoggingLevel.INFO, 'lstTokenGen.size: ' + lstTokenGen.size());
        if (lstTokenGen.size() == 0) {
            lstTokenGen = new List<Token_Generation__c>();
            lstTokenGen.add(new Token_Generation__c(Token_Name__c='LinkAPIAccessToken'));
        }
        system.debug(LoggingLevel.INFO, 'lstTokenGen.size: ' + lstTokenGen.size());
        return lstTokenGen;
    }

    public void execute(Database.BatchableContext BC, List<Token_Generation__c> scope) {
        Boolean errorState,ISLConTokenCheck;
        // String formatted = Datetime.now().format();
        String formatted = ACETUtility.format(Datetime.now());  // Gabe Grimley: ICU Date Format Changes US3687557
        errorState= ISLConTokenCheck = False;
        ACETLinkApiOAuthWebservice OAuthWS = new ACETLinkApiOAuthWebservice();
        String OAuthaccesstoken= OAuthWS.getAccessToken();
        List<Token_Generation__c> lstAccessTokenGen = new List<Token_Generation__c>();
        for(Token_Generation__c rec: scope){
            Token_Generation__c tokenObj = rec;
            if(tokenObj.Token_Name__c == 'LinkAPIAccessToken'){
                ISLConTokenCheck= True;
                if(OAuthaccesstoken!= null && OAuthaccesstoken!=''){
                    tokenObj.Value__c = OAuthaccesstoken;
                    lstAccessTokenGen.add(tokenObj);
                } else
                    errorState = True;
            }
        }

        if(lstAccessTokenGen.size()>0){
           Database.UpsertResult[] results= Database.upsert(lstAccessTokenGen);
            if (results != null){
                for (Database.UpsertResult AccessTokenUR: results) {
                    if (!AccessTokenUR.isSuccess()) {
                        for(Database.Error DbError :AccessTokenUR.getErrors()) {
                            system.debug(LoggingLevel.INFO, 'Save Access Token Error. StatusCode: ' + DbError.getStatusCode() + ', Message: ' + DbError.getMessage());
                            errorState = True;
                        }
                    }
                    else {
                        system.debug(LoggingLevel.INFO, 'Access token saved successfully in custom setting');

                    }
              }

           }
         }
           System.debug('errorState='+errorState);

        If(errorState){
          system.debug('errorState...'+errorState);
        	//If Access Token is 'LinkAPIAccessToken' && received as Null/Empty, send a notification with the details.
               if(ISLConTokenCheck){
                   if(OAuthaccesstoken== null)
                       sendmail(toAddresses,'ACET Salesforce Access Token Batch Job Failure-'+formatted+' '+'CST','Token LinkAPIAccessToken is Null due to Webservice Failure at'+' '+formatted+' '+'CST');
                   else if(String.isBlank(OAuthaccesstoken))
                       sendmail(toAddresses,'ACET Salesforce Access Token Batch Job Failure-'+formatted+' '+'CST','Token LinkAPIAccessToken is Blank due to Webservice Failure at'+' '+formatted+' '+'CST');
               }
        }
    }

    public void finish(Database.BatchableContext BC) {
         //String formatted = Datetime.now().format();
         String formatted = ACETUtility.format(Datetime.now()); // Gabe Grimley: ICU Date Format Changes US3687557
        AsyncApexJob mainjob =[Select Id,status,numberoferrors,jobitemsprocessed,totaljobitems from AsyncApexJob WHERE Id =:BC.getJobId()];
        if(mainjob.NumberOfErrors>0)
           sendmail(toAddresses,'ACET Salesforce Access Token Batch Job Failure-'+formatted+' '+'CST','The batch Apex got failed at'+' '+formatted+' '+'CST'+' '+'with'+' '+mainjob.NumberOfErrors+' '+'error(s).');
    }

    /*
     @Author : Avish Pagote
     @Date   : 04/04
     @Purpose: This method is used to send a notification alert in case of webservice/Batch Failure(s).
    */
    public static void sendmail(string[] toAddresses,string subject,string body){
        Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
        mail.setToAddresses(toAddresses);
        mail.setSubject(subject);
        mail.setPlainTextBody(body);
        if(!Test.isRunningTest())
         Messaging.sendEmail(new Messaging.SingleEmailMessage[]{mail});
    }
}