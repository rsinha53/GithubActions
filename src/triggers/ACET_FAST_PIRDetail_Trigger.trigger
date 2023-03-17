trigger ACET_FAST_PIRDetail_Trigger on PIR_Detail__c (before update,after update) {
    
    if(Trigger.isBefore && Trigger.isUpdate){
        ACET_FAST_PIRDetail_TriggerHandler.handleBeforeInsertOrUpdate(Trigger.new);
    }

    if(Trigger.isAfter && Trigger.isUpdate){
        ACET_FAST_PIRDetail_TriggerHandler.handleAfterInsert(Trigger.new,Trigger.OldMap);
    }
}