trigger CaseCommentTrigger on Case_Comment_Clone__c (before insert, after insert, before update, after update, before delete, after delete) {
    if (Trigger.isBefore) {
        if (Trigger.isInsert) {
            
        } 
        if (Trigger.isUpdate) {
            
        }
        if (Trigger.isDelete) {
            
        }
    }
    
    if (Trigger.isAfter) {
        if (Trigger.isInsert) {
            CaseCommentCloneTriggerHandler.handleAfterInsert(Trigger.Old,Trigger.NewMap);
        } 
        if (Trigger.isUpdate) {
            
        }
        if (Trigger.isDelete) {
            
        }
    }
}