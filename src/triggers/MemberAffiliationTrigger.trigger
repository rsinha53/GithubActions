trigger MemberAffiliationTrigger on Member_Affiliation__c (before insert, after insert,before update, after update,before delete, after delete) {

if (Trigger.isAfter) { 
  if (Trigger.isInsert) {
   MemberAffiliationTriggerHandler memAffHandler = new MemberAffiliationTriggerHandler();
    memAffHandler.Memberrecordsharing(trigger.new,null);
   }
  if (Trigger.isUpdate) {
    MemberAffiliationTriggerHandler memAffHandler = new MemberAffiliationTriggerHandler();
    memAffHandler.Memberrecordsharing(trigger.new,trigger.oldMap);
   }
}

}