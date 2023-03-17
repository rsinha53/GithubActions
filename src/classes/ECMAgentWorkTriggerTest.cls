@isTest(seeAllData=true)
private class ECMAgentWorkTriggerTest {

	private static testMethod void testAfterUpdate() {
        try{
            AgentWork aw = [select id from AgentWork ORDER BY lastModifiedDate limit 1];
           // AgentWork aw = [select id from AgentWork ORDER BY lastModifiedDate limit ];
            update aw;
           
        }catch(exception ex){
            
        }
       
	}
	
	
/*	private static testMethod void testAfterInsert() {
            set<id> serviceChannelds = new set<id>();
            for(ServiceChannel sc :[select id from ServiceChannel] ){
                serviceChannelds.add(sc.id);
            }
            
            set<id> QueueRoutingConfigIDs = new set<id>();
            for(QueueRoutingConfig qr :[select id from QueueRoutingConfig] ){
                QueueRoutingConfigIDs.add(qr.id);
            }
            
            list<Group> gr = new list<Group>([select id,QueueRoutingConfigId from Group where Group.type='Queue' and QueueRoutingConfigID in:QueueRoutingConfigIDs limit 1]);
            
            if(gr.size() > 0){
                Case cas = TestDataFactory.createCases(1)[0];
                cas.Topic__c = 'View Authorizations';
                cas.Type__c = 'eviCore Issues';
                cas.ownerID = gr[0].id;
                insert cas;
                list<AgentWork> awLst = new list<AgentWork>();
                for(id sc : serviceChannelds){
                    AgentWork aw = new AgentWork(ServiceChannelid=sc,WorkItemId= cas.id);
                    awLst.add(aw);
                }
                //database.insert(awLst,false);
                insert awLst;
                
            }
	}*/

}