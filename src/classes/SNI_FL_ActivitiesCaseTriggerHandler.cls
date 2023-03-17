public class SNI_FL_ActivitiesCaseTriggerHandler {
    
    /* handle after insert logic */
    public static void handleAfterInsert(List<case> triggerNew ){
        
        List<SNI_FL_Activity_History__c> activityHistoryLst = new List<SNI_FL_Activity_History__c>();
        Id ecmRecordTypeID = Schema.SObjectType.Case.getRecordTypeInfosByName().get('ECM').getRecordTypeId();
        Id closeRecordTypeID = Schema.SObjectType.Case.getRecordTypeInfosByName().get('Case Close').getRecordTypeId();
        for(case cse : triggerNew){
            
            if(cse.RecordTypeId == ecmRecordTypeID || cse.RecordTypeId == closeRecordTypeID){
               
                if((cse.status != '') && ((cse.Case_Type__c == '') || (cse.Case_Type__c == 'Opportunity') || (cse.Case_Type__c == null))){
                    
                    SNI_FL_Activity_History__c actvtyHstry = new SNI_FL_Activity_History__c();
                    actvtyHstry.Name = cse.id;
                    actvtyHstry.New_Value__c = cse.status;
                    actvtyHstry.ParentID__c = cse.id;
                    activityHistoryLst.add(actvtyHstry);       
                } 
            }
        }        
        if(activityHistoryLst.size()>0){
            insert activityHistoryLst;
        }
    }
    
    /* handle after update logic */
    public static void handleAfterUpdate(List<Case> triggerNew , map<id, Case> triggerOldMap){
       
        List<SNI_FL_Activity_History__c> activityHistoryLst = new List<SNI_FL_Activity_History__c>();
        Id ecmRecordTypeID = Schema.SObjectType.Case.getRecordTypeInfosByName().get('ECM').getRecordTypeId();
        Id closeRecordTypeID = Schema.SObjectType.Case.getRecordTypeInfosByName().get('Case Close').getRecordTypeId();
        
        for(case cse : triggerNew){
            if(cse.RecordTypeId == ecmRecordTypeID || cse.RecordTypeId == closeRecordTypeID){
                if((cse.Status != triggerOldMap.get(cse.id).Status && cse.Status != 'Waiting') && 
                   ((cse.Case_Type__c == '') || (cse.Case_Type__c == 'Opportunity') || (cse.Case_Type__c == null))){
                    SNI_FL_Activity_History__c actvtyHstry = new SNI_FL_Activity_History__c();
                    actvtyHstry.Name = cse.id;
                    actvtyHstry.New_Value__c = cse.Status;
                    actvtyHstry.Old_Value__c = triggerOldMap.get(cse.id).Status;
                    actvtyHstry.ParentID__c = cse.id;
                    activityHistoryLst.add(actvtyHstry);
                } 
            }
            
        }
        
        if(activityHistoryLst.size()>0){
            insert activityHistoryLst;
        }
    }
    
}