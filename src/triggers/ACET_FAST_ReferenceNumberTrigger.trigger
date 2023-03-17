trigger ACET_FAST_ReferenceNumberTrigger on PIR_Resolution_Partners_Reference__c (after update,after insert,after delete) {
    
    if(trigger.isAfter)
    {
        if(trigger.isUpdate)
        {
            ACET_FAST_ReferenceNumberTriggerHelper.updateRPSlaRoutedDate(Trigger.new,Trigger.OldMap);
        }
        else if(trigger.isInsert)
        {
            ACET_FAST_ReferenceNumberTriggerHelper.handleAfterInsert(trigger.new);
        } else if(trigger.isDelete){
            ACET_FAST_ReferenceNumberTriggerHelper.handleAfterDelete(trigger.old);
        }
       
    }
    
}