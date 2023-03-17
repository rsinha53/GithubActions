trigger AssociatedCasesTrigger on Associated_Cases__c (after insert,before delete) {
    if(trigger.isAfter && trigger.isInsert){
        AssociatedCasesTriggerHandler.populateRelatedCases(trigger.newMap,false);
    }

    if(trigger.isBefore && trigger.isDelete){
        AssociatedCasesTriggerHandler.populateRelatedCases(trigger.oldMap,true);
    }
}