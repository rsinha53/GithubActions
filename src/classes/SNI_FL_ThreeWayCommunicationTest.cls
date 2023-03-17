@isTest
public with sharing class SNI_FL_ThreeWayCommunicationTest {
    
    @testSetup
    static void createData(){
        Id familyrecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName().get('Family').getRecordTypeId();
        Id personAccountId = Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName().get('Individual').getRecordTypeId();
        
        Group g1 = new Group(Name='test_Group_ACDC', type='Queue');
        insert g1;
        
        
        Profile agentProfile=[SELECT Id FROM Profile where Name='Center for Health Navigation'];
        User thisUser = [Select Id From User Where Id =:UserInfo.getUserId()];
        user u1;
        System.runAs(thisUser){
            u1 = new User( email='agent1@optum.acet.com',
                          profileid = agentProfile.id, 
                          UserName='agent1_acdc_@optum.acet.com', 
                          Alias = 'GDS',
                          TimeZoneSidKey='America/New_York',
                          EmailEncodingKey='ISO-8859-1',
                          LocaleSidKey='en_US', 
                          isActive=true,
                          LanguageLocaleKey='en_US',
                          FirstName = 'Fagent1',
                          LastName = 'Lagent1');
            insert u1;
        }
        //Family acccount
        Account familyAc = new Account();
        familyAc.RecordTypeId= familyrecordTypeId;
        familyAc.Name = 'Test_Family_ACDC';
        familyAc.Member_ID__c = '112233';
        familyAc.OwnerId = u1.id;
        
        
        insert familyAc;
        
        Account personAccount= new Account(
            RecordTypeID=personAccountId ,
            FirstName='NewMSgFName@ACDC2',
            LastName='NewMSgLName@ACDC2',
            PersonMailingStreet='Greensboro',
            PersonMailingPostalCode='12345',
            PersonMailingCity='SFO',
            PersonEmail='acdc@yahoo.com',
            PersonHomePhone='1234567',
            PersonMobilePhone='43245345'
            
        );
        
        insert personAccount;
        
        Account personAcc = [SELECT PersonContactId FROM Account WHERE Id=:personAccount.id];
        Profile portal = [SELECT Id FROM Profile WHERE Name = 'Care Advisor Connect Provider User' LIMIT 1];
        user portaluser;
        System.runAs(thisUser){
            portaluser = new User(
                FirstName = 'Test_FirstNameACDC',
                LastName = 'Test_LastNameACDC',
                Email = 'testacdc@user.com',
                Username = 'test_acdc_@user.com',
                Alias = 'TestPA', 
                TimeZoneSidKey = 'GMT', 
                LocaleSidKey = 'en_US', 
                EmailEncodingKey = 'UTF-8', 
                ProfileId = portal.Id, 
                LanguageLocaleKey = 'en_US',
                ContactId = personAcc.PersonContactId);
            
            insert portaluser;
        }
        AccountContactRelation acr = new AccountContactRelation();
        acr.AccountId = familyAc.id;
        acr.ContactId = personAcc.PersonContactId;
        acr.IsActive = true;
        acr.Relationship__c = 'Subscriber/Recipient';
        
        insert acr;
        
        Profile toUser=[SELECT Id FROM Profile where Name='Center for Health Navigation'];
        user u2;
        System.runAs(thisUser){
            u2 = new User( email='user2@optum.acet.com',
                          profileid = toUser.id, 
                          UserName='user2_acdc_@optum.acet.com', 
                          Alias = 'GDS',
                          TimeZoneSidKey='America/New_York',
                          EmailEncodingKey='ISO-8859-1',
                          LocaleSidKey='en_US', 
                          isActive=true,
                          LanguageLocaleKey='en_US',
                          FirstName = 'Fagent1',
                          LastName = 'Lagent1');
            insert u2;
        }
    }
    
    @isTest
    static void inserNewRecordTest(){
        
        Group groupID = [SELECT ID FROM Group WHERE Name='test_Group_ACDC' LIMIT 1];
        
        QueuesObject q1 = new QueueSObject(QueueID = groupID.id, SobjectType = 'Message_Request_Queue__c');
        insert q1;
        
        User usr = [SELECT ID FROM User WHERE UserName='user2_acdc_@optum.acet.com' LIMIT 1];
        
        List<Id> userIDs = new List<ID>();
        userIDs.add(usr.id);
        
        Account familyAccount = [SELECT ID FROM Account WHERE Member_ID__c = '112233' LIMIT 1];
        
        Map<String,Object> data = new Map<String,Object>();
        data.put('FamilyAccountID',familyAccount.id);
        data.put('selectedQueue',new Map<Object,Object>{'name'=>'test','value' =>q1.QueueId});
        data.put('MessageContent','<p>SAMEERA</p>');
        data.put('MessageSubject','test');
        data.put('ToUsers',userIDs);
        
        Test.startTest();
        SNI_FL_ThreeWayCommunicationController.createNewMessageRequest(data,null);
        Test.stopTest();
    }
    
    @isTest
    static void getUserRelatedDataNullTest(){
        Group groupID = [SELECT ID FROM Group WHERE Name='test_Group_ACDC' LIMIT 1];
        
        QueuesObject q1 = new QueueSObject(QueueID = groupID.id, SobjectType = 'Message_Request_Queue__c');
        insert q1;
        
        User usr = [SELECT ID FROM User WHERE UserName='user2_acdc_@optum.acet.com' LIMIT 1];
        
        List<Id> userIDs = new List<ID>();
        userIDs.add(usr.id);
        
        Account familyAccount = [SELECT ID FROM Account WHERE Member_ID__c = '112233' LIMIT 1];
        
        Map<String,Object> data = new Map<String,Object>();
        data.put('FamilyAccountID',familyAccount.id);
        data.put('selectedQueue',new Map<Object,Object>{'name'=>'test','value' =>q1.QueueId});
        data.put('MessageContent','<p>SAMEERA</p>');
        data.put('MessageSubject','test');
        
        Test.startTest();
        SNI_FL_ThreeWayCommunicationController.createNewMessageRequest(data,null);   
        Test.stopTest();
    }
    
    @isTest
    static void getFamilyAccountDetailsNullTest(){
        Group groupID = [SELECT ID FROM Group WHERE Name='test_Group_ACDC' LIMIT 1];
        
        QueuesObject q1 = new QueueSObject(QueueID = groupID.id, SobjectType = 'Message_Request_Queue__c');
        insert q1;
        
        User usr = [SELECT ID FROM User WHERE UserName='user2_acdc_@optum.acet.com' LIMIT 1];
        
        List<Id> userIDs = new List<ID>();
        userIDs.add(usr.id);
        
        Account familyAccount = [SELECT ID FROM Account WHERE Member_ID__c = '112233' LIMIT 1];
        
        Map<String,Object> data = new Map<String,Object>();
        data.put('selectedQueue',new Map<Object,Object>{'name'=>'test','value' =>q1.QueueId});
        data.put('MessageContent','<p>SAMEERA</p>');
        data.put('MessageSubject','test');
        
        Test.startTest();
        SNI_FL_ThreeWayCommunicationController.createNewMessageRequest(data,null);   
        Test.stopTest();
    }
    
    @isTest
    static void getMessageRequestQueueDetailsTest(){
        Test.startTest();
        SNI_FL_ThreeWayCommunicationController.getMessageRequestQueueDetails('','');
        Test.stopTest();
    }
    
}