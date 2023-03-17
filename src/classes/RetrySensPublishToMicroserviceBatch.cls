/*------------------------------------------------------------
Author:        Manmeet Kaur
Description:   To republish the failed sens publish records
			   to microservice/topic
               
Test Class:    RetrySensPublishToMicroserviceBatchTest
History
Date            Author              Comments
-------------------------------------------------------------
09-15-2022      Manmeet Kaur        Created
------------------------------------------------------------*/
global class RetrySensPublishToMicroserviceBatch implements Database.Batchable<sObject>,Schedulable {   
    public Database.QueryLocator start(Database.BatchableContext BC){
        String query = 'SELECT Id,Retry_Flag__c FROM Sens_Publish__c WHERE Is_Data_Published_in_Topic__c = False';
        return Database.getQueryLocator(query); 
    }
    
    public void execute(Database.BatchableContext BC, List<Sens_Publish__c> sensPublishLst){
        try{
    		List<Application_Error_Log__c> appErrorLogLst = new List<Application_Error_Log__c>();
            for(Sens_Publish__c sp : sensPublishLst){
                //Updating the flag so that it can fire the auto-launched flow
                sp.Retry_Flag__c  = true;
            }
			Database.SaveResult[] srList = Database.update(sensPublishLst, false);
            for (Database.SaveResult sr : srList) {
               if (sr.isSuccess()) {
                  System.debug('Successfully published the record' + sr.getId());
               } else {
                  for(Database.Error objErr : sr.getErrors()) {
                     System.debug('The following error has occurred.' + objErr.getMessage());
                     Application_Error_Log__c appErrorLog = ACETUtility.CreateApplicationErrorLog('Retry Failed SENS PUBLISH Records', 'RetrySensPublishToMicroserviceBatch', '-', '', 400);
                     appErrorLog.Error_Cause__c = objErr.getMessage();
                     appErrorLogLst.add(appErrorLog);
                  }
               }
            }
            if(appErrorLogLst.size()>0){
                insert appErrorLogLst;
            }
        }catch(exception ex){
            system.debug('Exception occured::' + + ex.getMessage());
        }
    }
    public void finish(Database.BatchableContext BC){

    }
 	global void execute(SchedulableContext scon) {
      Database.executeBatch(new RetrySensPublishToMicroserviceBatch(),200);
   }
}