/********************************************************************************* 
Class Name     : accountTeamMemberTrigger.apxt
Description    : accountTeamMemberTrigger to automate backend data
Created By     : Srilakshmi Rayala
Created Date   : 12/09/2020

Modification Log:

*********************************************************************************/

trigger accountTeamMemberTrigger on AccountTeamMember (before insert, after insert,before update, after update,before delete, after delete) {
    if(Trigger.isBefore && Trigger.isInsert){
        AccountTeamTriggerHandler.validationTeamRole(trigger.new); 
    }
    if (Trigger.isAfter) { 
        if (Trigger.isInsert) {
            AccountTeamTriggerHandler memAffHandler = new AccountTeamTriggerHandler();
            memAffHandler.MapAccountTeams(trigger.new);
        }
        if (Trigger.isUpdate) {
            
        }
        if (Trigger.isDelete) {
            AccountTeamTriggerHandler memAffHandler = new AccountTeamTriggerHandler();
            memAffHandler.RemoveAccountTeams(trigger.old);
            System.Debug('TestDelete' + trigger.old);
        }
    }
}