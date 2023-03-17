trigger ACETAlertTrigger on Alert__c (before insert, before update, after update, after insert, before delete, after delete) {
      
    //	before insert context
    if(Trigger.isInsert && Trigger.isAfter) {
        ACETAlertTriggerHandler.preventDuplicates();
    }
    
    //	before update context
    if(Trigger.isUpdate && Trigger.isAfter) {
        ACETAlertTriggerHandler.preventDuplicates();
    }
}