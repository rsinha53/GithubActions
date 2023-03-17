/***************************************************************************
 * @@Author: Pavan Kumar Annaldas
 * @@Description: Test class for "ECMRouteLogJob"
 * **************************************************************************/
@isTest
private class ECMRouteLogJobTest {
    
       @testsetup static void createTestQueues(){
          //create Test queue  
          Group  testQueue = new Group(Type = 'Queue' , Name= 'ECMTestQueue');
          insert testQueue ;
      
          QueuesObject q1 = new QueueSObject(QueueID = testQueue.id, SobjectType = 'Case');
          insert q1;           
    	}
    
   
    static void prepareData(){
        List<Case> caseLst = new list<Case>();
        caseLst.addAll(ECMTestDataUtil.createCase('Open',userInfo.getUserId(),5, true));
       
       Id groupId = [Select ID , Name from Group where Name= 'ECMTestQueue' Limit 1].Id;
       Id queueId = [Select Id,queue.id , queueID From QueueSobject where queueID = :groupID limit 1].queue.id;       
        caseLst.addAll(ECMTestDataUtil.createCase('Open',queueId,5, true));
        list<Routing_Configuration__c> configLst = new list<Routing_Configuration__c>();
        
        configLst.addAll(ECMTestDataUtil.createRoutingConfiguration('ECMTestQueue', 2, 15, true));
    }
    
    static testMethod void testSuccessAndFailureLogsCreation(){
		prepareData();
        list<Routing_Configuration__c> configLst = new list<Routing_Configuration__c>([select id from Routing_Configuration__c]);
        List<Case> caseLst = new list<Case>([Select Id, Priority, Subtype__c, Type__c, Priority_Routing__c, 
        Status, Topic__c, OwnerId , ServiceLevel__c from Case]);
        
        map<id,Routing_Configuration__c> successMap = new map<id, Routing_Configuration__c>();
        for(Case c: caseLst){
            for(Routing_Configuration__c r : configLst){
                successMap.put(c.id, r);
            }
        }
        
        test.startTest();
        System.enqueueJob(new ECMRouteLogJob(successMap,caseLst));
        test.stopTest();
    }
    
    
}