/****************************************************************
Class Name: SNI_FL_DeleteNPSDataRecordsBatch
Description: This is used for deleting last weeks NPS data records
-----------------------------------------------------------------
DEVELOPER     DATE             FUNCTIONALITY 
-----------------------------------------------------------------
Bindu     11/03/2021          Initial Development
*****************************************************************/
global class SNI_FL_DeleteNPSDataRecordsBatch implements Database.Batchable<sObject> {
    //Start Method
    global Database.QueryLocator start(Database.BatchableContext BC)
    {
        String query = 'Select id from NPS_Data__c where CreatedDate = LAST_N_DAYS:7';
        return Database.getQueryLocator(query);
    }
    //Execute Method
    global void execute(Database.BatchableContext context, List<sObject> scope)
    {     if(scope != null && !scope.isEmpty()){
            List<NPS_Data__c> npsDataList = new List<NPS_Data__c>();
            npsDataList  = (List<NPS_Data__c>)scope;
            if(npsDataList != null && !npsDataList.isEmpty()){
                delete npsDataList;
            }
        }
    }
    //Finish Method
    global void finish(Database.BatchableContext BC){
    }
    
}