@isTest
private class ECMCaseAssignmentHelperTest {
    
         @testsetup static void createTestQueues(){
          //create Test queue  
          Group  testQueue = new Group(Type = 'Queue' , Name= 'ECMTestQueue');
          insert testQueue ;
      
          QueuesObject q1 = new QueueSObject(QueueID = testQueue.id, SobjectType = 'Case');
          insert q1; 
          
       
    	}
    
       
    
    
    private static testMethod void testECMCaseAssignmentHelper(){
        Test.startTest(); 
        list<Routing_Configuration__c> configLst = new list<Routing_Configuration__c>();
        //configLst.addAll(ECMTestDataUtil.createRoutingConfiguration('ACCUM- Standard', 2, 10, true)); 
        configLst.addAll(ECMTestDataUtil.createRoutingConfiguration('ECMTestQueue', 2, 10, true)); 
        
        ECMCaseAssignmentHelper obj = new ECMCaseAssignmentHelper();
        SObject sobj = (sobject)new Routing_Configuration__c();
        string constirantValue = ECMCaseAssignmentHelper.getConstirantValue(sobj);
        SObject sobj1 = (sobject)new Account();
        ECMCaseAssignmentHelper.IsFieldAvliable(sobj1,'Name');
        
        Test.stopTest();
    }
}