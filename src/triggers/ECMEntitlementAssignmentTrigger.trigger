trigger ECMEntitlementAssignmentTrigger on EntitlementAssignment__c (before insert, before update) {
    ECMEntitlementAssignmentUtility.validateData(trigger.new);
}