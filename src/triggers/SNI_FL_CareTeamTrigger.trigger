trigger SNI_FL_CareTeamTrigger on SNI_FL_Care_Team_Member__c (after update) {
    
  if(Trigger.isAfter){
    if(Trigger.isUpdate){
        if(RecursiveTriggerHandler.careTeam_FirstTime){
            RecursiveTriggerHandler.careTeam_FirstTime=false;
            SNI_FL_CareTeamTriggerHandler.updateCareTeam(Trigger.newmap,Trigger.oldmap);  
        }  
      }
  }
}