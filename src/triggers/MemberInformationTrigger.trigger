trigger MemberInformationTrigger on Member_Information__c (before update,after insert, after update) {
    
	if(Trigger.isbefore){
        if (Trigger.isUpdate) {
           MemberInformationHandler.handleBeforeUpdate(Trigger.new,Trigger.NewMap,Trigger.OldMap);
        }
    }
    if (Trigger.isAfter) {
        if (Trigger.isInsert) {
            MemberInformationHandler.handleAfterInsert(Trigger.new,Trigger.NewMap);
        } 
        
        if (Trigger.isUpdate) {
            MemberInformationHandler.handleAfterUpdate(Trigger.Old,Trigger.NewMap,Trigger.OldMap);

        }
    }
}