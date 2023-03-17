/*------------------------------------------------------------
Author:        Harshini Thotakura
Description:   This class is used to clean up the the older unnecessary log records (older than 90 days) 

Date            Author                      Comments
-------------------------------------------------------------
15-12-2022      Harshini Thotakura      	Created
------------------------------------------------------------*/
global class SNI_FL_DeleteLogDataRecordsBatch implements Database.Batchable<sObject>,Schedulable {
    //Start Method
    global Database.QueryLocator start(Database.BatchableContext BC)
    {
        Integer numOfDays = Integer.valueOf(System.Label.DeleteApplicationLogDaysFilter);
        String query = 'Select id from Application_Error_Log__c where CreatedDate != LAST_N_DAYS:'+numOfDays;
        return Database.getQueryLocator(query);
    }
    //Execute Method
    global void execute(Database.BatchableContext context, List<sObject> scope)
    {     if(scope != null && !scope.isEmpty()){
            List<Application_Error_Log__c> logDataList = new List<Application_Error_Log__c>();
            logDataList  = (List<Application_Error_Log__c>)scope;
            if(logDataList != null && !logDataList.isEmpty()){
                delete logDataList;
            }
          }
    }
    //Finish Method
    global void finish(Database.BatchableContext BC){
    }
    
    
    global void execute(SchedulableContext SC) {
        //Calling the SNI_FL_DeleteLogDataRecordsBatch 
        Database.executebatch(new SNI_FL_DeleteLogDataRecordsBatch(),100);
    }
    
}