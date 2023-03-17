/*
Created By: Avish Pagote
Created Date: 5th April 2019
Description: This class is used to refresh the access token and send notification if it fails.
*/

public class SAEGetAccessTokenBatch implements Database.Batchable<sObject>, Database.AllowsCallouts {
    final String[] toAddresses = new String[]{'sudarshan_pagote@optum.com','ramadevi_pesala@optum.com'};
        public List<Token_Generation__c> start(Database.BatchableContext BC){
            List<Token_Generation__c> tokenGenList = new List<Token_Generation__c>();
            List<Token_Generation__c> lstTokenGen = new List<Token_Generation__c>([SELECT Id, Name, Value__c,Token_Name__c  
                                                                                   FROM Token_Generation__c WHERE Token_Name__c =: 'ISLConAccessToken']);
            //lstTokenGen = new List<Token_Generation__c>();
            if (lstTokenGen.size() == 0) {
                tokenGenList.add(new Token_Generation__c(Token_Name__c='ISLConAccessToken'));            
            }else{
                tokenGenList.addAll(lstTokenGen);
            }
            /*List<Token_Generation__c> stageGateRecord = new List<Token_Generation__c>([SELECT Id, Name, Value__c,Token_Name__c  
                                                                                   FROM Token_Generation__c WHERE Token_Name__c =: 'StageGate']);
            if (stageGateRecord.size() == 0) {
                tokenGenList.add(new Token_Generation__c(Token_Name__c='StageGate'));            
            } else {
                tokenGenList.addAll(stageGateRecord);
            }*/
            return tokenGenList;  
        }
    
    public void execute(Database.BatchableContext BC, List<Token_Generation__c> scope) {
        Boolean errorState,ISLConTokenCheck; 
        String formatted = Datetime.now().format();
        errorState = ISLConTokenCheck = false;
        //stageGateErrorState = stageGateTokenCheck = false;
        SAEOAuthWebservice OAuthWS = new SAEOAuthWebservice();
        //String OAuthaccesstoken = OAuthWS.GetAccessToken('sae-link-nprod', '50f766e3-c685-4e7d-a7d6-423c76b24cd5', 'https://api-gateway-stage.linkhealth.com/oauth/token');
        //String oAuthAccessTokenStageGate = OAuthWS.GetAccessToken('RMjuYtTSdYUVuTl5TN5rO93WJYy8C38K', 'HOt08KbsGwIXiS6uD65hjG8wU83v12RX', 'https://gateway-stage.optum.com/auth/oauth2/token');
        Map<String, ACETOrgInstanceURLToOrgNameMap__c> OrgInstance2OrgNameMap = ACETOrgInstanceURLToOrgNameMap__c.getAll();
        String orgName = Test.isRunningTest() ? 'dev' : ACETUtility.GetOrgName(OrgInstance2OrgNameMap);
        Map<String, ISL_Webservice_Config__c> islWebserviceData = ISL_Webservice_Config__c.getAll();
        String OAuthaccesstoken = OAuthWS.GetAccessToken(islWebserviceData.get(orgName + '_LINKOAuthClientId').Value__c, islWebserviceData.get(orgName + '_LINKOAuthClientSecret').Value__c, islWebserviceData.get(orgName + '_LINKApiEndpoint').Value__c);
        //String oAuthAccessTokenStageGate = OAuthWS.GetAccessToken(islWebserviceData.get(orgName + '_StargateOAuthClientId').Value__c, islWebserviceData.get(orgName + '_StargateOAuthClientSecret').Value__c, islWebserviceData.get(orgName + '_SNIApiEndpoint').Value__c);
        List<Token_Generation__c> lstAccessTokenGen = new List<Token_Generation__c>();
        for(Token_Generation__c rec: scope){
            Token_Generation__c tokenObj = rec;
            if(tokenObj.Token_Name__c == 'ISLConAccessToken'){
                ISLConTokenCheck = True;  
                if(OAuthaccesstoken!= null && OAuthaccesstoken!=''){         
                    tokenObj.Value__c = OAuthaccesstoken;
                    lstAccessTokenGen.add(tokenObj);
                } else {
                    errorState = True;
                }
            } /*else if(tokenObj.Token_Name__c == 'StageGate'){
                stageGateTokenCheck = True;  
                if(oAuthAccessTokenStageGate!= null && oAuthAccessTokenStageGate!=''){         
                    tokenObj.Value__c = oAuthAccessTokenStageGate;
                    lstAccessTokenGen.add(tokenObj);
                } else {
                    stageGateErrorState = True;
                }
            }*/
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
        
        if(errorState){
            //If Access Token is 'ISLConAccessToken' && received as Null/Empty, send a notification with the details.
            if(ISLConTokenCheck){   
                if(OAuthaccesstoken== null) {
                    sendmail(toAddresses,'ACET Salesforce Access Token Batch Job Failure-'+formatted+' '+'CST','Token ISLConAccessToken is Null due to Webservice Failure at'+' '+formatted+' '+'CST');                     
                }
                else {                
                    sendmail(toAddresses,'ACET Salesforce Access Token Batch Job Failure-'+formatted+' '+'CST','Token ISLConAccessToken is Blank due to Webservice Failure at'+' '+formatted+' '+'CST');                     
                }
            }
        }
    }
    
    public void finish(Database.BatchableContext BC) {
        String formatted = Datetime.now().format();
        AsyncApexJob mainjob =[Select Id,status,numberoferrors,jobitemsprocessed,totaljobitems from AsyncApexJob WHERE Id =:BC.getJobId()];              
        if(mainjob.NumberOfErrors > 0)
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
        Messaging.sendEmail(new Messaging.SingleEmailMessage[]{mail});
    }
}