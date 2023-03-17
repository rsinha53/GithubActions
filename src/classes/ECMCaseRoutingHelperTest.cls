@isTest
private class ECMCaseRoutingHelperTest {

    @testsetup
    static void createTestQueues(){
        //create Test queue
        Group  testQueue1 = new Group(Type = 'Queue' , Name= 'ECMTestQueue1');
        Group  testQueue2 = new Group(Type = 'Queue' , Name= 'ECMTestQueue2');
        insert new list<Group>{testQueue1,testQueue2};

        QueuesObject q1 = new QueueSObject(QueueID = testQueue1.id, SobjectType = 'Case');
        QueuesObject q2 = new QueueSObject(QueueID = testQueue2.id, SobjectType = 'Case');
        insert new list<QueuesObject>{q1,q2};

    }



    @isTest static void caseOwnerAsQueue() {
        Profile p = [SELECT Id FROM Profile WHERE Name='Standard User'];
        Id ECMRecordType = Schema.SObjectType.Case.getRecordTypeInfosByName().get('ECM').getRecordTypeId();
        User u = new User(Alias = 'standt', Email='standarduser@testorg.com',
            EmailEncodingKey='UTF-8', LastName='Testing', LanguageLocaleKey='en_US',
            LocaleSidKey='en_US', ProfileId = p.Id,
            TimeZoneSidKey='America/Los_Angeles', UserName='standarduser@acettest.com');

        System.runAs(u) {
                        
            TTS_Access__c tts = new TTS_Access__c(Topic__c = 'Other Inquiry', Type__c = 'Account Closure');
            insert tts;
            Case cas = TestDataFactory.createCases(1)[0];
            cas.recordTypeId = ECMRecordType;
            cas.Topic__c = 'Other Inquiry';
            insert cas;
            
            list<Routing_Configuration__c> configLst = new list<Routing_Configuration__c>();
            configLst.addAll(ECMTestDataUtil.createRoutingConfiguration('ECMTestQueue1', 2, 1, false));
            configLst.addAll(ECMTestDataUtil.createRoutingConfiguration('ECMTestQueue2', 2, 1, false));
            for(Routing_Configuration__c confg:configLst){
                confg.isActive__C = true;
                confg.Topic1__c = 'Other Inquiry';
                confg.ProfileName__c = 'System Administrator';
                confg.RoleName__c = 'System Administrator';
            }

            insert configLst;
            Id queueId = [Select Id,queue.id  From QueueSobject where SobjectType = 'Case'  and queue.Name ='ECMTestQueue1' limit 1].queue.id;

            list<case> caseLst = new list<case>();
            caseLst.add(cas);
            List<ID> casIds = new list<id>{cas.id};
            Map<id, String> mapOfCaseAndCurrentQueue = new map<id, string>();
            Map<id, userRole> mapOfUserRole = new map<id, userRole>();
            string queId = queueId;
            mapOfCaseAndCurrentQueue.put(cas.id,queId);
            ECMCaseRoutingHelper.getQueueName(caseLst,mapOfCaseAndCurrentQueue,null);
            ECMCaseRoutingHelper.fetchCase(casIds);
			ECMCaseRoutingHelper.isStandrdCaseFieldMatch(cas,configLst[0],'test');
            ECMCaseRoutingHelper.isBasicCriteriaMatch(cas,configLst[0],u,mapOfUserRole);
            //List<String> resp = ECMCaseRoutingHelper.getNotNulValuesForQueueName(configLst[0]);
        }
 }
    
    
       @isTest static void caseOwnerAsQueueTest() {
        Profile p = [SELECT Id FROM Profile WHERE Name='Standard User'];
        Id ECMRecordType = Schema.SObjectType.Case.getRecordTypeInfosByName().get('ECM').getRecordTypeId();
        User u = new User(Alias = 'standt', Email='standarduser@testorg.com',
            EmailEncodingKey='UTF-8', LastName='Testing', LanguageLocaleKey='en_US',
            LocaleSidKey='en_US', ProfileId = p.Id,
            TimeZoneSidKey='America/Los_Angeles', UserName='standarduser@acettest.com');

        System.runAs(u) {
                        
            TTS_Access__c tts = new TTS_Access__c(Topic__c = 'Other Inquiry', Type__c = 'Account Closure');
            insert tts;
            Case cas = TestDataFactory.createCases(1)[0];
            cas.recordTypeId = ECMRecordType;
            cas.Topic__c = 'Other Inquiry';
            //cas.OwnerId = UserInfo.getUserId();
            insert cas;
            
            list<Routing_Configuration__c> configLst = new list<Routing_Configuration__c>();
            configLst.addAll(ECMTestDataUtil.createRoutingConfiguration('ECMTestQueue1', 2, 1, false));
            configLst.addAll(ECMTestDataUtil.createRoutingConfiguration('ECMTestQueue2', 2, 1, false));
            for(Routing_Configuration__c confg:configLst){
                confg.isActive__C = true;
                confg.Topic1__c = 'Other Inquiry';
                confg.ProfileName__c = null;
                confg.RoleName__c = null;
            }

            insert configLst;
            Id queueId = [Select Id,queue.id  From QueueSobject where SobjectType = 'Case'  and queue.Name ='ECMTestQueue1' limit 1].queue.id;

            list<case> caseLst = new list<case>();
            caseLst.add(cas);
            List<ID> casIds = new list<id>{cas.id};
            Map<id, String> mapOfCaseAndCurrentQueue = new map<id, string>();
            Map<id, userRole> mapOfUserRole = new map<id, userRole>();
            string queId = queueId;
            mapOfCaseAndCurrentQueue.put(cas.id,queId);
            ECMCaseRoutingHelper.getQueueName(caseLst,mapOfCaseAndCurrentQueue,null);
            ECMCaseRoutingHelper.fetchCase(casIds);
			ECMCaseRoutingHelper.isStandrdCaseFieldMatch(cas,configLst[0],'test');
            ECMCaseRoutingHelper.isBasicCriteriaMatch(cas,configLst[0],u,mapOfUserRole);
            //List<String> resp = ECMCaseRoutingHelper.getNotNulValuesForQueueName(configLst[0]);
            ECMCaseRoutingHelper.IsFieldAvliable(new Case(), '');
        }
 }
    
    @isTest static void isBasicCriteriaMatchTest() {
        Profile p = [SELECT Id FROM Profile WHERE Name='Standard User'];
        Id ECMRecordType = Schema.SObjectType.Case.getRecordTypeInfosByName().get('ECM').getRecordTypeId();
        User u = new User(Alias = 'standt', Email='standarduser@testorg.com',
            EmailEncodingKey='UTF-8', LastName='Testing', LanguageLocaleKey='en_US',
            LocaleSidKey='en_US', ProfileId = p.Id,
            TimeZoneSidKey='America/Los_Angeles', UserName='standarduser@acettest.com');

        System.runAs(u) {
                        
            TTS_Access__c tts = new TTS_Access__c(Topic__c = 'Other Inquiry', Type__c = 'Account Closure');
            insert tts;
            Case cas = TestDataFactory.createCases(1)[0];
            cas.recordTypeId = ECMRecordType;
            cas.Topic__c = 'Other Inquiry';
            insert cas;
            
            list<Routing_Configuration__c> configLst = new list<Routing_Configuration__c>();
            configLst.addAll(ECMTestDataUtil.createRoutingConfiguration('ECMTestQueue1', 2, 1, false));
            configLst.addAll(ECMTestDataUtil.createRoutingConfiguration('ECMTestQueue2', 2, 1, false));
            for(Routing_Configuration__c confg:configLst){
                confg.isActive__C = true;
                confg.Topic1__c = 'Other Inquiry';
                confg.ProfileName__c = null;
                confg.RoleName__c = 'System Administrative';
            }

            insert configLst;
            Id queueId = [Select Id,queue.id  From QueueSobject where SobjectType = 'Case'  and queue.Name ='ECMTestQueue1' limit 1].queue.id;

            list<case> caseLst = new list<case>();
            caseLst.add(cas);
            List<ID> casIds = new list<id>{cas.id};
            Map<id, String> mapOfCaseAndCurrentQueue = new map<id, string>();
            Map<id, userRole> mapOfUserRole = new map<id, userRole>();
            string queId = queueId;
            mapOfCaseAndCurrentQueue.put(cas.id,queId);
            Set<String> setOfRouteRoles = new Set<String>();
            setOfRouteRoles.add('Role');
            
            ECMCaseRoutingHelper.getQueueName(caseLst,mapOfCaseAndCurrentQueue,null);
            ECMCaseRoutingHelper.fetchCase(casIds);
            ECMCaseRoutingHelper.isBasicCriteriaMatch(cas,configLst[0],Null,mapOfUserRole);
            ECMCaseRoutingHelper.isMatchedWithCurrentOrParentOrGrandParentRole(configLst[0],setOfRouteRoles,u,mapOfUserRole);
            //List<String> resp = ECMCaseRoutingHelper.getNotNulValuesForQueueName(configLst[0]);
        }
 }
    
    
    @isTest static void caseOwnerAsQueueWhenCaseOwnerIsNull() {
        Profile p = [SELECT Id FROM Profile WHERE Name='Standard User'];
        Id ECMRecordType = Schema.SObjectType.Case.getRecordTypeInfosByName().get('ECM').getRecordTypeId();
        User u = new User(Alias = 'standt', Email='standarduser@testorg.com',
            EmailEncodingKey='UTF-8', LastName='Testing', LanguageLocaleKey='en_US',
            LocaleSidKey='en_US', ProfileId = p.Id,
            TimeZoneSidKey='America/Los_Angeles', UserName='standarduser@acettest.com');

        System.runAs(u) {
                        
            TTS_Access__c tts = new TTS_Access__c(Topic__c = 'Other Inquiry', Type__c = 'Account Closure');
            insert tts;            
            
            list<Routing_Configuration__c> configLst = new list<Routing_Configuration__c>();
            configLst.addAll(ECMTestDataUtil.createRoutingConfiguration('ECMTestQueue1', 2, 1, false));
            configLst.addAll(ECMTestDataUtil.createRoutingConfiguration('ECMTestQueue2', 2, 1, false));
            for(Routing_Configuration__c confg:configLst){
                confg.isActive__C = true;
                confg.Topic1__c = 'Other Inquiry';
                confg.ProfileName__c = null;
                confg.RoleName__c = null;
            }

            insert configLst;
            Map<id, userRole> mapOfUserRole = new map<id, userRole>();

            ECMCaseRoutingHelper.isBasicCriteriaMatch(null,configLst[0],u,mapOfUserRole);
        }
 }


    @isTest static void pushtoUrgentQueue() {
        list<Routing_Configuration__c> configLst = new list<Routing_Configuration__c>();
        configLst.addAll(ECMTestDataUtil.createRoutingConfiguration('ECMTestQueue1', 2, 1, false));
        configLst.addAll(ECMTestDataUtil.createRoutingConfiguration('ECMTestQueue2', 3, 1, false));
        for(Routing_Configuration__c confg:configLst){
            confg.isActive__C = true;
            confg.Topic1__c = 'Other Inquiry';
        }
        Routing_Configuration__c config1 = new Routing_Configuration__c();
        config1 = ECMTestDataUtil.createRoutingConfiguration('ECMTestQueue1', 5, 1, false)[0];
        config1.ProfileName__c = 'System Administrator;';
        config1.isActive__C = true;
        configLst.add(config1);
        insert configLst;
        Id queueId = [Select Id,queue.id  From QueueSobject where SobjectType = 'Case'  and queue.Name ='ECMTestQueue1' limit 1].queue.id;
        Case cas = TestDataFactory.createCases(1)[0];
        cas.Topic__c = 'Other Inquiry';
        insert cas;
        
        test.startTest();
        cas.Priority_Routing__c= 'Yes';
            update cas;
        test.stopTest();

    }
    
    
       @isTest static void isMatchedWithCurrentOrParentOrGrandParentRoleTest() {
        list<Routing_Configuration__c> configLst = new list<Routing_Configuration__c>();
        configLst.addAll(ECMTestDataUtil.createRoutingConfiguration('ECMTestQueue1', 2, 1, false));
        configLst.addAll(ECMTestDataUtil.createRoutingConfiguration('ECMTestQueue2', 3, 1, false));
        for(Routing_Configuration__c confg:configLst){
            confg.isActive__C = true;
            confg.Topic1__c = 'Other Inquiry';
        }
        Routing_Configuration__c config1 = new Routing_Configuration__c();
        config1 = ECMTestDataUtil.createRoutingConfiguration('ECMTestQueue1', 5, 1, false)[0];
        config1.ProfileName__c = 'System Administrator;';
        config1.isActive__C = true;
        config1.RoleName__c = 'true';
        configLst.add(config1);
           
        insert configLst;
        Id queueId = [Select Id,queue.id  From QueueSobject where SobjectType = 'Case'  and queue.Name ='ECMTestQueue1' limit 1].queue.id;
        Case cas = TestDataFactory.createCases(1)[0];
        cas.Topic__c = 'Other Inquiry';
        insert cas;
        
        test.startTest();
        cas.Priority_Routing__c= 'Yes';
            update cas;
        test.stopTest();

    }


}