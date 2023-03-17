trigger ContentDocumentTrigger on ContentDocument (before delete,after insert, after update) {
    if(trigger.isbefore){
        if(trigger.isDelete){
           //To capture the delete of documents in familylink dashboard
            ContentDocumentHelper.trackDeleteRecords(trigger.oldMap);
        }
    }
     if (Trigger.isAfter) {
        if (Trigger.isInsert) {
            // Call class logic here!
            //  ContentDocumentHelper.handleAfterInsert(Trigger.new);
        } 
        if (Trigger.isUpdate) {
            // Call class logic here!
               ContentDocumentHelper.handleAfterUpdate(Trigger.new,Trigger.newmap,Trigger.oldmap);
        }
       
    }


}