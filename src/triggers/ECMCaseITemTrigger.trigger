trigger ECMCaseITemTrigger on Case_Item__c (after delete, after insert, after undelete, after update, before delete, before insert, before update) {
    if(trigger.isBefore){
        if(trigger.isInsert){
            ECMCaseITemTriggerHelper.handleBeforeInsert(trigger.new);
        }
    }
    if(trigger.isAfter && trigger.isUpdate)
    {
        ACET_FAST_CaseItemTriggerHelper.handleAfterUpdate(trigger.new, trigger.oldmap);
    }
     if(trigger.isBefore && trigger.isUpdate){
        ACET_FAST_CaseItemTriggerHelper.handleCaseItemStatusChange(trigger.new, trigger.oldmap);
    }
}