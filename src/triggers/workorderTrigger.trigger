trigger workorderTrigger on WorkOrder (before insert, after insert, 
before update, after update, 
before delete, after delete) {

if (Trigger.isBefore) {
    if (Trigger.isInsert) {
    // Call class logic here!
    ACETWorkorderTriggerHandler woHandler = 
            new ACETWorkorderTriggerHandler(Trigger.oldMap, Trigger.newMap);
            woHandler.insertWorkOrderSpecialStatus();
    } 
    if (Trigger.isUpdate) {
    // Call class logic here!
            ACETWorkorderTriggerHandler woHandler = new ACETWorkorderTriggerHandler(Trigger.oldMap, Trigger.newMap);
            //woHandler.updateWorkOrderSpecialStatus();
            woHandler.updateViolationField();  
    }
    if (Trigger.isDelete) {
    // Call class logic here!
    }
}

if (Trigger.isAfter) {
if (Trigger.isInsert) {
// Call class logic here!
} 
if (Trigger.isUpdate) {
ACETWorkorderTriggerHandler woHandler = 
        new ACETWorkorderTriggerHandler(Trigger.oldMap, Trigger.newMap);
        woHandler.checkWorkorderClosed();
      
// Call class logic here!
}
if (Trigger.isDelete) {
// Call class logic here!
}
}


}