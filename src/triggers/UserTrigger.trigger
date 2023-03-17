trigger UserTrigger on User (after insert,after update,before insert, before update) {
    system.debug('****userTriggerId==>'+userInfo.getuserId());
    ACETUserTriggerHandler acetTriggerHandler = new ACETUserTriggerHandler();
    if(trigger.isAfter){
        string NewString = JSON.serialize(trigger.New);
        if(trigger.isInsert){
             ACETUserTriggerHandler.getEmail(trigger.New, null);
             ACETUserTriggerHandler.addUserToGroup(NewString, null);        

             /*US2732016: Care Team - Display Care Team on Family Page -Populated*/
            
            ACETUserTriggerHandler.memAffShareInsertOperation(trigger.New); 
            ACETUserTriggerHandler.createCareTeam(trigger.New);
            ACETUserTriggerHandler.sendSmsInvitation(trigger.New);
        }
        else if(trigger.isUpdate){
            string OldMapString = JSON.serialize(trigger.oldMap);
            if(RecursiveTriggerHandler.emailcheck != true){ 
            ACETUserTriggerHandler.getEmail(trigger.New, trigger.oldMap);
              ACETUserTriggerHandler.addUserToGroup(NewString, OldMapString);
           }   
        }
    }
    else if(trigger.isBefore){
        if(trigger.isInsert){
            ACETUserTriggerHandler.updateUserDetails(trigger.new);
            ACETUserTriggerHandler.restrictSmsInvitation(Trigger.new);
        }else if(trigger.isUpdate){
            ACETUserTriggerHandler.restrictSmsInvitationOnUpdate(Trigger.new, Trigger.oldMap);
        } 
    }
    
 }