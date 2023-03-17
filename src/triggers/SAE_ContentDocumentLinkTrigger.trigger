trigger SAE_ContentDocumentLinkTrigger on ContentDocumentLink (before insert, after insert, before update, after update,before delete, after delete) {
    
    if (Trigger.isBefore) {
        if (Trigger.isInsert) {
            // Call class logic here!
            SAE_ContentDocumentLinkTriggerHandler contentLinkHandler = new SAE_ContentDocumentLinkTriggerHandler(Trigger.new);
            contentLinkHandler.contentDocumentLinkError();

            // PIR (FAST/PIP) Team Logic
            if(ACET_FAST_CaseDocumentLinkTriggerHandler.isFirstTime){
                ACET_FAST_CaseDocumentLinkTriggerHandler.isFirstTime = false;
                ACET_FAST_CaseDocumentLinkTriggerHandler.caseDocumentLinkValidation(trigger.New);
            }
        } 
        if (Trigger.isUpdate && ACET_FAST_CaseDocumentLinkTriggerHandler.isFirstTime) {
            // Call class logic here!
            // PIR (FAST/PIP) Team Logic
                ACET_FAST_CaseDocumentLinkTriggerHandler.isFirstTime = false;
                ACET_FAST_CaseDocumentLinkTriggerHandler.caseDocumentLinkValidation(trigger.New);
        }
        if (Trigger.isDelete) {
            // Call class logic here!
        }
    }
    
    if (Trigger.isAfter) {
        if (Trigger.isInsert) {
            // Call class logic here!
               ContentDocumentLinkTriggerHandler.handleAfterInsert(Trigger.new,Trigger.newmap);

        } 
        if (Trigger.isUpdate) {
            // Call class logic here!
               ContentDocumentLinkTriggerHandler.handleAfterUpdate(Trigger.new,Trigger.oldmap);
        }
        if (Trigger.isDelete) {
            // Call class logic here!
        }
    }
    
    
}