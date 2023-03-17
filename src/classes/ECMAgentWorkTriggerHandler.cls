public without sharing class ECMAgentWorkTriggerHandler { 
    
    
    public static void handleAfterUpdate(list<AgentWork> triggerNew, map<id, AgentWork> triggerOldMap){
        set<id> caseIds = new set<id>();
        for(AgentWork newAw : triggerNew){            
            AgentWork oldAw = triggerOldMap.get(newAw.id);
            string workItemID = (string)newAw.workItemID;
            
            if(!test.isRunningTest()){
                if(workItemID.startsWith('500') && newAw.status != oldAw.Status && newAw.status == 'Opened'){
                    caseIds.add(workItemID);
                }
            }else{
                caseIds.add(workItemID);
            }
            
            
        }
        if(!caseIds.isEmpty()){
            updateCaseStatus(caseIds);
            ECMMilestonePerformance.createOwnerShipChanges( caseIds);  
            map<id, Case> caseMap = new map<id,Case>([select id, OwnerId from Case where id in:caseIds]);
            ECMCaseTriggerHelper.changeOpenActivityOwner(caseIds, caseMap);
        }
        
    }
      public static void updateCaseStatus(Set<id> caseIds){
        List<case> statusCaseList = new List<case>();
        //Lahiru 6/11/21: Removing below RESCU references as it's no longer there 
        //Id rescuRecTypeId = Schema.SObjectType.Case.getRecordTypeInfosByName().get('RESCU').getRecordTypeId();
        for(case ca:[select id,RecordTypeId, Case_Items_Unresolved__c,status from case where id in :caseIds AND RecordType.DeveloperName != 'Motion']){
		/*
        if (rescuRecTypeId == ca.RecordTypeId) {
            continue;
        }
		*/
            if(ca.Case_Items_Unresolved__c != null && ca.status != 'Reopen'){
                if(ca.Case_Items_Unresolved__c == 0 ){
                    ca.status = 'Follow Up';
                }else {
                    ca.status = 'Assigned';
                }
                statusCaseList.add(ca);
            }
        }  
        
        if(statusCaseList.size() > 0 ){
            update statusCaseList;
        }
    }
    
}