public class ACETAgentWorkTriggerHandler {
    
    //comment
    //comment
    public static void handleAfterUpdate(list<AgentWork> triggerNew, map<id, AgentWork> triggerOldMap){
        set<id> caseIds = new set<id>();
        set<string> statuses = new set<string>();
        statuses.add('Declined');
        statuses.add('DeclinedOnPushTimeout');
        statuses.add('Closed');
        statuses.add('Opened');
        for(AgentWork aw : triggerNew){
          AgentWork oldAw = triggerOldMap.get(aw.id);    
          string WorkItemId = aw.WorkItemId;
          if(WorkItemId.startsWith('500')){
              system.debug('aw status'+aw.status);
              if(!test.isRunningTest() && aw.status != oldAw.Status && statuses.contains(aw.Status)){
                caseIds.add(aw.WorkItemId);
              }else{
                caseIds.add(aw.WorkItemId);  
              }
          }
        }
        if(!caseIds.isEmpty()){
           ECMMilestonePerformance.createOwnerShipChanges(caseIds); 
        }
    }
    
    
}