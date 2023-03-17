/************************************************************
Class Name: ACET_DeleteVCCDResponseBatch
Description: This is used for deleteing inactive vccd records
--------------------------------------------------------------
DEVELOPER     DATE             FUNCTIONALITY
---------------------------------------------------------------
Sravan     11/06/2020          Initial Development
***************************************************************/
global class ACET_DeleteVCCDResponseBatch implements Database.Batchable<sObject>{


    //Start Method
    global Database.QueryLocator start(Database.BatchableContext BC){
        String query = 'Select Id,Name,isActive__c from VCCD_Response__c';
        return Database.getQueryLocator(query);
    }
    
    
    //Execute Method
    global void execute(Database.BatchableContext BC, List<sObject> scope){
        if(scope != null && !scope.isEmpty()){
            List<VCCD_Response__c> vccdResponseList = new List<VCCD_Response__c>();
            vccdResponseList  = (List<VCCD_Response__c>)scope;
            if(vccdResponseList != null && !vccdResponseList.isEmpty()){
                delete vccdResponseList;
            }
        }
    }
    
    //Finish Method
    global void finish(Database.BatchableContext BC){
    
    }
}