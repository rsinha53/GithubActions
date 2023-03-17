/*------------------------------------------------------------
Author:        Tushar Kaore
Description:   Test class for SENSAPI_UpdateMemberRequestProcessor  

Test Class:   SENSAPI_UpdateMemberRequestProcessorTest
History
Date            Author              Comments
-------------------------------------------------------------
10-31-2022      Tushar Kaore      		Created
------------------------------------------------------------*/
@isTest
private class SENSAPI_UpdateMemberRequestProcessorTest {
    
    private static final String memberId = '00756767666'; 
    
    private static void createUser(Id contactId){
        User user = new User();
        user.ProfileID = [Select Id From Profile Where Name='Care Advisor Connect Provider User'].id;
        user.EmailEncodingKey = 'ISO-8859-1';
        user.LanguageLocaleKey = 'en_US';
        user.TimeZoneSidKey = 'America/New_York';
        user.LocaleSidKey = 'en_US';
        user.FirstName = 'TestFirst';
        user.LastName = 'TestLast';
        user.Username = 'testfirst_testlast@test.com';
        user.CommunityNickname = 'testUser';
        user.Alias = 'Alias';
        user.Email = 'testfirst_testlast@test.com';
        user.IsActive = true;
        user.ContactId = contactId;
        insert user;
    }
    
    /**
     * Test data setup
     */ 
    @testSetup static void setup() {
         
        Id recordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Family').getRecordTypeId();
        Account familyAcct = new Account();
        familyAcct.Member_ID__c = memberId;
        familyAcct.Policy_ID__c = '0070145';
        familyAcct.Name =   'TestFirst TestLast Family';
        familyAcct.RecordTypeId = recordTypeId;
        insert familyAcct;
        
        Id personAccRecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Individual').getRecordTypeId();
        Account personAcct =new Account();
        personAcct.PersonBirthdate = date.valueOf(ACETUtility.formatDateFutureDate('6/17/1979'));
        personAcct.FirstName = 'TestFirst'; 
        personAcct.LastName = 'TestLast'; 
        personAcct.RecordTypeId = personAccRecordTypeId;
        insert personAcct;
        
        
        
        Account queriedpersonAcct = [SELECT Id,PersonContactId FROM Account WHERE Id =: personAcct.Id];
        List<AccountContactRelation> acrList = new List<AccountContactRelation>();
        Map<Id, AccountContactRelation> acrMap = new Map<Id, AccountContactRelation>();
        AccountContactRelation acr = new AccountContactRelation();
        acr.ContactId = queriedpersonAcct.PersonContactId;            
        acr.Accountid = familyAcct.id;
        acr.Relationship__c = 'Subscriber/Recipient';
        acr.Complex_Indicator__c = 'Referral';
        insert acr;
		
        //creating user in future method
		createUser(queriedpersonAcct.PersonContactId); 
        
        List<SNI_FL_Care_Team_Member__c> careteamMemList = new List<SNI_FL_Care_Team_Member__c>(); 
        SNI_FL_Care_Team_Member__c careteamMem = new SNI_FL_Care_Team_Member__c();
        careteamMem.SNI_FL_Member__c = personAcct.Id;
        careteamMem.SNI_FL_Not_Visible_in_Familylink__c = false;
        careteamMem.SNI_FL_Family__c = familyAcct.Id; 
        careteamMem.SNI_FL_Primary_Caregiver__c = true;
        careteamMemList.add(careteamMem);
        insert careteamMemList;
        
    }
    
    /**
     * Testing success scearnio with existing subscriber id
     */ 
    @istest private static void processRequestSuccess(){
        Id personAccRecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Individual').getRecordTypeId();
        Account personAcct = [SELECT Id FROM Account WHERE RecordTypeId=:personAccRecordTypeId ];
        
        RestRequest req = new RestRequest(); 
        RestResponse res = new RestResponse();
        
        RestContext.request = req;
        RestContext.response= res;
        
        SENSAPI_UpdateMemberRequest request = new SENSAPI_UpdateMemberRequest();
        request.subscriberId = memberId;
        request.sensId = personAcct.Id;
        request.personalInfo = new SENSAPI_UpdateMemberRequest.PersonalInfo();
        request.notification = new SENSAPI_UpdateMemberRequest.Notification();
        request.personalInfo.preferredName = 'TestPreferredName';
        request.personalInfo.email = 'updateEmail@test.com';
        request.personalInfo.mobile = '1234567890';
        request.notification.email = true;
        request.notification.textSMS = true;
        
        SENSAPI_UpdateMemberRequestProcessor processor = new SENSAPI_UpdateMemberRequestProcessor();
        processor.process(JSON.serialize(request));
        
        system.assert(RestContext.response.statusCode  == 200, 'Error processing request');
    }
    
    /**
     * Testing failure scearnio with non-existing send id
     */ 
    @istest private static void processRequestInvalidSensId(){
        
        Id personAccRecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Individual').getRecordTypeId();
        Account personAcct = [SELECT Id FROM Account WHERE RecordTypeId=:personAccRecordTypeId ];
        
        RestRequest req = new RestRequest(); 
        RestResponse res = new RestResponse();
        
        RestContext.request = req;
        RestContext.response= res;
        
        SENSAPI_UpdateMemberRequest request = new SENSAPI_UpdateMemberRequest();
        request.subscriberId = memberId;
        request.sensId = 'invalid-sens';
        
        
        SENSAPI_UpdateMemberRequestProcessor processor = new SENSAPI_UpdateMemberRequestProcessor();
        processor.process(JSON.serialize(request));
        system.assert(RestContext.response.statusCode  == 400, 'Error processing request');
    }
    
    /**
     * Testing error scearnio without sens id
     */ 
    @istest private static void withoutSubId(){
        
        Id personAccRecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Individual').getRecordTypeId();
        Account personAcct = [SELECT Id FROM Account WHERE RecordTypeId=:personAccRecordTypeId ];
        
        RestRequest req = new RestRequest(); 
        RestResponse res = new RestResponse();
        
        RestContext.request = req;
        RestContext.response= res;
        
        SENSAPI_UpdateMemberRequest request = new SENSAPI_UpdateMemberRequest();
        request.subscriberId = memberId;
        request.sensId = null;
        request.personalInfo = new SENSAPI_UpdateMemberRequest.PersonalInfo();
        request.notification = new SENSAPI_UpdateMemberRequest.Notification();
		request.personalInfo.mobile = null;
        request.notification.textSMS = true;
        
        
        
        SENSAPI_UpdateMemberRequestProcessor processor = new SENSAPI_UpdateMemberRequestProcessor();
        processor.process(JSON.serialize(request));
        
        system.assert(RestContext.response.statusCode  == 400, 'Error processing request');
    }
    
    /**
     * Testing success scearnio with invalid mobile number
     */ 
    @istest private static void invalidMobile(){
        Id personAccRecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Individual').getRecordTypeId();
        Account personAcct = [SELECT Id FROM Account WHERE RecordTypeId=:personAccRecordTypeId ];
        
        RestRequest req = new RestRequest(); 
        RestResponse res = new RestResponse();
        
        RestContext.request = req;
        RestContext.response= res;
        
        SENSAPI_UpdateMemberRequest request = new SENSAPI_UpdateMemberRequest();
        request.subscriberId = memberId;
        request.sensId = personAcct.Id;
        request.personalInfo = new SENSAPI_UpdateMemberRequest.PersonalInfo();
        request.notification = new SENSAPI_UpdateMemberRequest.Notification();
        request.personalInfo.preferredName = 'TestPreferredName';
        request.personalInfo.email = 'updateEmail@test.com';
        request.personalInfo.mobile = '12345-67890';
        request.notification.email = true;
        request.notification.textSMS = false;
        
        SENSAPI_UpdateMemberRequestProcessor processor = new SENSAPI_UpdateMemberRequestProcessor();
        processor.process(JSON.serialize(request));
        
        system.assert(RestContext.response.statusCode  == 400, 'Error processing request');
    }
    
    /**
     * Testing with invalid JSON to check exception
     */ 
    @istest private static void testWithInvalidJSON(){
        Id personAccRecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Individual').getRecordTypeId();
        Account personAcct = [SELECT Id FROM Account WHERE RecordTypeId=:personAccRecordTypeId ];
        
        RestRequest req = new RestRequest(); 
        RestResponse res = new RestResponse();
        
        RestContext.request = req;
        RestContext.response= res;
        
        SENSAPI_UpdateMemberRequest request = new SENSAPI_UpdateMemberRequest();
        request.subscriberId = memberId;
        request.sensId = personAcct.Id;
        request.personalInfo = new SENSAPI_UpdateMemberRequest.PersonalInfo();
        request.notification = new SENSAPI_UpdateMemberRequest.Notification();
        request.personalInfo.preferredName = 'TestPreferredName';
        request.personalInfo.email = 'updateEmail@test.com';
        request.personalInfo.mobile = '12345-67890';
        request.notification.email = true;
        request.notification.textSMS = false;
        
        SENSAPI_UpdateMemberRequestProcessor processor = new SENSAPI_UpdateMemberRequestProcessor();
        processor.process('invalid json input');
        
        system.assert(RestContext.response.statusCode  == 500, 'Error handling exception');
    }
    
    
}