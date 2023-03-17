trigger ContentVersiontrigger on ContentVersion (After insert) {
    
    if (Trigger.isAfter) {
        if (Trigger.isInsert) {
            // Call class logic here!
            ContentVersionHandler.handleAfterInsert(Trigger.new);
            
        } 
}
}