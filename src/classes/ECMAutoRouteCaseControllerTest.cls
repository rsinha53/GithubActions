@isTest
private class ECMAutoRouteCaseControllerTest {

     @testsetup static void createTestQueues(){
          //create Test queue  
          Group  testQueue = new Group(Type = 'Queue' , Name= 'ECMTestQueue');
          insert testQueue ;
      
          QueuesObject q1 = new QueueSObject(QueueID = testQueue.id, SobjectType = 'Case');
          insert q1; 

       }
    
    @isTest static void test_method_Constructor() {
        Case cas = TestDataFactory.createCases(1)[0];
        cas.Topic__c = 'Other Inquiry';
        insert cas;
        Routing_Configuration__c routinConfig = new Routing_Configuration__c(Queue_Name__c = 'ECMTestQueue' ,  Topic1__c='Other Inquiry', SortOrder__c=0);
        insert routinConfig;
        ECMAutoRouteCaseController con = constructECMAutoRouteCaseController(cas);
        //System.assertEquals(cas.Topic__c,con.topic);
    }
    
    @isTest static void test_method_InvokeRoute_caseOwnerQueue() {
        Id queueId = [Select Id,queue.id  From QueueSobject where SobjectType = 'Case'  and queue.Name ='ECMTestQueue' limit 1].queue.id;
        Case cas = TestDataFactory.createCases(1)[0];
        cas.Topic__c = 'Other Inquiry';
        cas.ownerID= queueId;
        insert cas;
        Routing_Configuration__c routinConfig = new Routing_Configuration__c(Queue_Name__c = 'ECMTestQueue' ,  Topic1__c='Other Inquiry', SortOrder__c=0);
        insert routinConfig;
        ECMAutoRouteCaseController con = constructECMAutoRouteCaseController(cas);
        con.invokeRoute();
        cas = [select owner.name from case];
        //System.assertEquals(routinConfig.Queue_Name__c,cas.owner.name);
    }
    
   /* @isTest static void test_method_InvokeRoute() {
        Case cas = TestDataFactory.createCases(1)[0];
        cas.Topic__c = 'View Authorizations';
        cas.Priority_routing__c = 'No';
        insert cas;
        Routing_Configuration__c routinConfig = new Routing_Configuration__c(Queue_Name__c = 'ECMTestQueue' ,  Topic1__c='View Authorizations', SortOrder__c=0,Priority_routing__c = 'No');
        insert routinConfig;
        ECMAutoRouteCaseController con = constructECMAutoRouteCaseController(cas);
        con.invokeRoute();
        cas = [select owner.name from case];
        //System.assertEquals(routinConfig.Queue_Name__c,cas.owner.name);
    }*/
    
    @isTest static void test_method_Validation() {
        Case cas = TestDataFactory.createCases(1)[0];
        cas.Topic__c = 'View Authorizations';
        insert cas;
        Routing_Configuration__c routinConfig = new Routing_Configuration__c(Queue_Name__c = 'ECMTestQueue' ,  Topic1__c='Other Inquiry', SortOrder__c=0);
        insert routinConfig;
        ECMAutoRouteCaseController con = constructECMAutoRouteCaseController(cas);
        //System.assertEquals(false,con.isSucess);
    }
    @isTest static void test_method_Validation1() {
        Case cas = TestDataFactory.createCases(1)[0];
        cas.Topic__c = 'View Authorizations';
        insert cas;
        
        Routing_Configuration__c routinConfig = new Routing_Configuration__c(Queue_Name__c = 'ECMTestQueue' ,  Topic1__c='View Authorizations', SortOrder__c=0);
        insert routinConfig;
        ECMAutoRouteCaseController con = constructECMAutoRouteCaseController(cas);
        //System.assertEquals(false,con.isSucess);
        try{
            cas.Priority_routing__c = 'Yes';
            cas.OwnerId = UserInfo.getUserId();
            con.cas = cas;
            con.invokeRoute();
        }catch(exception e){
            
        }
        
    }
    
    @isTest static void test_method_Validation2() {
        Case cas = TestDataFactory.createCases(1)[0];
        cas.Topic__c = 'View Authorizations';
        insert cas;
        UserRole ur = [select id, Name from UserRole limit 1];
        Routing_Configuration__c routinConfig = new Routing_Configuration__c(Queue_Name__c = 'ECMTestQueue' ,RoleName__c=ur.NAme,  Topic1__c='View Authorizations', SortOrder__c=0);
        insert routinConfig;
        ECMAutoRouteCaseController con = constructECMAutoRouteCaseController(cas);
        //System.assertEquals(false,con.isSucess);
        try{
            cas.Priority_routing__c = 'Yes';
            cas.OwnerId = UserInfo.getUserId();
            con.cas = cas;
            con.invokeRoute();
        }catch(exception e){
            
        }
        
    }
    @isTest static void test_method_ValidationSupportCase() {
        
        Profile p = [SELECT Id FROM Profile WHERE Name='Center for Health Navigation']; 
        User u = new User(Alias = 'standt', Email='fec@testorg.com', 
            EmailEncodingKey='UTF-8', LastName='Testing', LanguageLocaleKey='en_US', 
            LocaleSidKey='en_US', ProfileId = p.Id, 
            TimeZoneSidKey='America/Los_Angeles', UserName='fec@acettest.com');

        System.runAs(u) {
        RecordType newRecord = [SELECT Id FROM RecordType WHERE Name = 'Individual' and SObjectType = 'Account'];
    	
        Account accountTest1 = new Account();
        accountTest1.FirstName = 'TestFirst';
        accountTest1.LastName = 'TestLast';
        accountTest1.EID__c = '12345';
        accountTest1.EID__pc = '12345';
        accountTest1.PersonMailingState = 'CA';
        accountTest1.RecordTypeId = newRecord.Id;
        insert accountTest1;
        contact cont = [select Id from contact where accountId =: accountTest1.Id];
        Id ecmRecordTypeID = Schema.SObjectType.Case.getRecordTypeInfosByName().get('ECM').getRecordTypeId();
        Case ecmCas = TestDataFactory.createCases(1)[0];
        ecmCas.RecordTypeId =ecmRecordTypeID;
        ecmCas.Topic__c = 'Appeals - Post Service';
        ecmCas.AccountId = accountTest1.Id;
        ecmCas.ContactId = cont.Id;
        ecmCas.UHG_Restriction__c = 'No';
        ecmCas.DOB__c = '1999/08/09';
        ecmCas.ID__c = '';
        ecmCas.Onshore_Restriction__c = 'No';
        ecmCas.Subject_Name__c = 'ECM Test case' ;
        ecmCas.Subject_Group_ID__c = '0915181';
        Insert ecmCas;
        Id supportCsRecordTypeID = Schema.SObjectType.Case.getRecordTypeInfosByName().get('Support Request').getRecordTypeId();
		Case cas = TestDataFactory.createCases(1)[0];
        cas.RecordTypeId =supportCsRecordTypeID;
        cas.Topic__c = 'Appeals - Post Service';
        cas.Type__c = 'Family Advisor';
        cas.Support_Request__c = ecmCas.Id ;
        insert cas;
        
        Routing_Configuration__c routinConfig = new Routing_Configuration__c(Queue_Name__c = 'ECMTestQueue' ,  Topic1__c='View Authorizations', SortOrder__c=0);
        insert routinConfig;
        ECMAutoRouteCaseController con = constructECMAutoRouteCaseController(cas);
        //System.assertEquals(false,con.isSucess);
        try{
            cas.Priority_routing__c = 'Yes';
            cas.OwnerId = UserInfo.getUserId();
            con.cas = cas;
            con.invokeRoute();
        }catch(exception e){
            
        }
        
    }
    }
    private static ECMAutoRouteCaseController constructECMAutoRouteCaseController(Case cas){
        ApexPages.Standardcontroller stdController = new ApexPages.Standardcontroller(cas);
        PageReference pageRef = new Pagereference('apex/ECM_AutoRouteCase');
        pageRef.getParameters().put('Id',cas.id);
        Test.setCurrentPage(pageRef);
        ECMAutoRouteCaseController con = new ECMAutoRouteCaseController(stdController);
        return con;
    }  
    @isTest static void test_AdditionalScenarios() {
        Case cas = TestDataFactory.createCases(1)[0];
        cas.Topic__c = 'Other Inquiry';
        insert cas;
		ECMAutoRouteCaseController.InitLoadData testILD = new ECMAutoRouteCaseController.InitLoadData();
        ECMAutoRouteCaseController con = constructECMAutoRouteCaseController(cas);
        testILD = ECMAutoRouteCaseController.validateCasePermission(cas.Id);
        //check testIld.case = cas.id;
        System.assertEquals(cas.Id, testILD.caseObj.Id);
        String newTTSFilterStr = con.getTTSFilterStr();
        ECMAutoRouteCaseController.LightningReturnValue newLRV = new ECMAutoRouteCaseController.LightningReturnValue();
        newLRV = ECMAutoRouteCaseController.invokeRoute(cas.Id, '', '', '');
        System.assertNotEquals(null, newLRV);
        con.isSucess = null;
        con.accessMessage = 'test';
    }
    
    @isTest static void test_method_InvokeRoute_caseOwnerQueue1() {
        Id queueId = [Select Id,queue.id  From QueueSobject where SobjectType = 'Case'  and queue.Name ='ECMTestQueue' limit 1].queue.id;
        Case cas = TestDataFactory.createCases(1)[0];
        cas.Topic__c = 'Other Inquiry';
        cas.ownerID = queueId;
        insert cas;
        Case cas1 = TestDataFactory.createCases(1)[0];
        cas1.Topic__c = 'Other Inquiry';
        cas1.ownerID = queueId;
        insert cas1;
        
        TTS_Access__c ta = new TTS_Access__c(Topic__c = 'Other Inquiry');
        insert ta;
        Routing_Configuration__c routinConfig = new Routing_Configuration__c(Queue_Name__c = 'ECMTestQueue' ,  Topic1__c='Other Inquiry', SortOrder__c=0,IsActive__c = true,TTs_Access__c =ta.Id );
        insert routinConfig;
        ECMAutoRouteCaseController con = constructECMAutoRouteCaseController(cas);
        con.invokeRoute();
        ECMAutoRouteCaseController con1 = constructECMAutoRouteCaseController(cas1);
        con1.invokeRoute();
        //cas = [select owner.name from case LIMIT 1];
        //System.assertEquals(routinConfig.Queue_Name__c,cas.owner.name);
    }
}