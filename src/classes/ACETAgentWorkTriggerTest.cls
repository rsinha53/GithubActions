@isTest(seeAllData=true)
private class ACETAgentWorkTriggerTest {
//test
	private static testMethod void testAfterUpdate() {
        try{
            
            try{
                Case cs = new Case();
                insert cs;
                AgentWork aw = new AgentWork();
                aw.WorkItemId = cs.Id;
                ACETAgentWorkTriggerHandler.handleAfterUpdate(new List<AgentWork>{aw},new Map<Id,AgentWork>{null=>aw});
            }catch(exception e){
                
            }
            
        }catch(exception ex){
            
        }
	}

}