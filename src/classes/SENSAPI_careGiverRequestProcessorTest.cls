/*------------------------------------------------------------
Description:   Test class for SENSAPI_PostSendInviteReqProcessor  

History
Date            Author              Comments
-------------------------------------------------------------
12-OCT-2022     Manmeet Kaur      	Created
------------------------------------------------------------*/
@isTest
public class SENSAPI_careGiverRequestProcessorTest {
    
    @testSetup static void dataSetup() {
        List<SNI_FL_Care_Team_Member__c> careTeamMember = new List<SNI_FL_Care_Team_Member__c>();
        List<Account> memberLst = new List<Account>();
        Id personRecTypeId = Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName().get('Individual').getRecordTypeId();
        Id familyRecTypeId = Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName().get('Family').getRecordTypeId();
        Account famAcc = new Account(Name = 'test', 
                                     Member_Id__c = '00756767666',
                                     recordtypeId = familyRecTypeId);
        memberLst.add(famAcc);  
        Account personAcc = new Account(FirstName = 'test', 
                                        lastName = 'test',
                                        Member_ID__c = famAcc.Member_Id__c,
                                        recordtypeId = personRecTypeId);
        memberLst.add(personAcc);
             
        INSERT memberLst;
        SNI_FL_Care_Team_Member__c ctmMember = new SNI_FL_Care_Team_Member__c(SNI_FL_Member__c = personAcc.id,
                                                                              SNI_FL_Status__c = 'Invited',
                                                                              SNI_FL_Family__c = famAcc.Id,
                                                                              SNI_FL_Primary_Caregiver__c = true,
                                                                              Email__c = 'test@test.com');
        
        careTeamMember.add(ctmMember);
        INSERT careTeamMember;
	
        Id conId = [select PersonContactId FROM account where ID =: personAcc.Id LIMIT 1].PersonContactId;
        
        AccountContactRelation acr = new AccountContactRelation(contactId = conId, AccountId = famAcc.Id);
        INSERT acr;
        
        Id profId = [SELECT ID FROM Profile WHERE NAME = 'Care Advisor Connect Community User' LIMIT 1].Id;
        system.runAs(new user(Id = userinfo.getUserId())){
            User commUsr = new User(
                alias = 'test123', email='test123@noemail.com',
                emailencodingkey='UTF-8', lastname='Testing', languagelocalekey='en_US',
                localesidkey='en_US', profileid = profId, country='United States',IsActive =true,
                ContactId = conId,
                timezonesidkey='America/Los_Angeles', username='tester@noemail.com');
            INSERT commUsr;
        }
    }
    
    static testMethod void removeCareGiverTestPositive(){
        Id accId = [SELECT Id FROM Account WHERE Recordtype.Name = 'Individual' LIMIT 1].Id;
        Account famId = [SELECT Id,Member_Id__c FROM Account WHERE Recordtype.Name = 'Family' LIMIT 1];
        SNI_FL_Care_Team_Member__c careTeamMember1 = [select id,SNI_FL_Member__c,SNI_FL_Family__c,SNI_FL_Family__r.Member_ID__c from SNI_FL_Care_Team_Member__c limit 1];
        careTeamMember1.SNI_FL_Status__c = 'Removed';
        update careTeamMember1;
        RestRequest req = new RestRequest(); 
        RestResponse res = new RestResponse();
        string requestStructure = '{"subscriberId": "'+famId.Member_Id__c+'","action": "removed","familyMember": {"sensId": "';
        requestStructure = requestStructure +  accId + '","firstName": "","lastname": "","dateOfBirth": "","relationship": "","email": ""}}';
        req.requestBody = Blob.valueof(requestStructure);
        RestContext.request = req;
        RestContext.response= res;
        string jsonValue = RestContext.request.requestBody.toString();
        test.startTest();
        SENSAPI_careGiverRequestProcessor reqprocessor = new SENSAPI_careGiverRequestProcessor();
        IRestResponseWrapper responseWrapper = reqprocessor.process(jsonValue);
        test.stopTest();
    }
    
    static testMethod void removeCareGiverTestPositiveFamily(){
        Id accId = [SELECT Id FROM Account WHERE Recordtype.Name = 'Individual' LIMIT 1].Id;
        Account famId = [SELECT Id,Member_Id__c FROM Account WHERE Recordtype.Name = 'Family' LIMIT 1];
        Id familyRecTypeId = Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName().get('Family').getRecordTypeId();
        Account famAcc = new Account(Name = 'test', 
                                     Member_Id__c = '11223344',
                                     recordtypeId = familyRecTypeId);
        insert famAcc;
        SNI_FL_Care_Team_Member__c careTeamMember1 = [select id,SNI_FL_Primary_Caregiver__c,SNI_FL_Member__c,SNI_FL_Family__c,SNI_FL_Family__r.Member_ID__c from SNI_FL_Care_Team_Member__c limit 1];
        careTeamMember1.SNI_FL_Primary_Caregiver__c = false;
        update careTeamMember1;
        RestRequest req = new RestRequest(); 
        RestResponse res = new RestResponse();
        string requestStructure = '{"subscriberId": "'+famId.Member_Id__c+'","action": "removed","familyMember": {"sensId": "';
        requestStructure = requestStructure +  accId + '","firstName": "","lastname": "","dateOfBirth": "","relationship": "","email": ""}}';
        req.requestBody = Blob.valueof(requestStructure);
        RestContext.request = req;
        RestContext.response= res;
        string jsonValue = RestContext.request.requestBody.toString();
        test.startTest();
        SENSAPI_careGiverRequestProcessor reqprocessor = new SENSAPI_careGiverRequestProcessor();
        IRestResponseWrapper responseWrapper = reqprocessor.process(jsonValue);
        test.stopTest();
    }
    
    static testMethod void removeCareGiverTestPrimaryCareGiver(){
        Id personRecTypeId = Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName().get('Individual').getRecordTypeId();
        Id familyRecTypeId = Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName().get('Family').getRecordTypeId();
        Account famAcc = new Account(Name = 'test', 
                                     Member_Id__c = '00756767666',
                                     recordtypeId = familyRecTypeId);
        insert famAcc;  
        Account personAcc = new Account(FirstName = 'test', 
                                        lastName = 'test',
                                        Member_ID__c = famAcc.Member_Id__c,
                                        recordtypeId = personRecTypeId);
        insert personAcc;
        SNI_FL_Care_Team_Member__c ctmMember = new SNI_FL_Care_Team_Member__c(SNI_FL_Member__c = personAcc.id,
                                                                              SNI_FL_Status__c = 'Invited',
                                                                              SNI_FL_Family__c = famAcc.Id,
                                                                              SNI_FL_Primary_Caregiver__c = true,
                                                                              Email__c = 'test792@test.com');
        
        insert ctmMember;
        RestRequest req = new RestRequest(); 
        RestResponse res = new RestResponse();
        string requestStructure = '{"subscriberId": "'+famAcc.Member_Id__c+'","action": "removed","familyMember": {"sensId": "';
        requestStructure = requestStructure +  personAcc.Id + '","firstName": "","lastname": "","dateOfBirth": "","relationship": "","email": ""}}';
        req.requestBody = Blob.valueof(requestStructure);
        RestContext.request = req;
        RestContext.response= res;
        string jsonValue = RestContext.request.requestBody.toString();
        test.startTest();
        SENSAPI_careGiverRequestProcessor reqprocessor = new SENSAPI_careGiverRequestProcessor();
        IRestResponseWrapper responseWrapper = reqprocessor.process(jsonValue);
        test.stopTest();
    }
    
    static testMethod void alreadyRemovedCareGiverTest(){
        Id personRecTypeId = Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName().get('Individual').getRecordTypeId();
        Id familyRecTypeId = Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName().get('Family').getRecordTypeId();
        Account famAcc = new Account(Name = 'test', 
                                     Member_Id__c = '00756767666',
                                     recordtypeId = familyRecTypeId);
        insert famAcc;  
        Account personAcc = new Account(FirstName = 'test', 
                                        lastName = 'test',
                                        Member_ID__c = famAcc.Member_Id__c,
                                        recordtypeId = personRecTypeId);
        insert personAcc;
        SNI_FL_Care_Team_Member__c ctmMember = new SNI_FL_Care_Team_Member__c(SNI_FL_Member__c = personAcc.id,
                                                                              SNI_FL_Status__c = 'Removed',
                                                                              SNI_FL_Family__c = famAcc.Id,
                                                                              SNI_FL_Primary_Caregiver__c = true,
                                                                              Email__c = 'test168@test.com');
        
        insert ctmMember;
        RestRequest req = new RestRequest(); 
        RestResponse res = new RestResponse();
        string requestStructure = '{"subscriberId": "'+famAcc.Member_Id__c+'","action": "removed","familyMember": {"sensId": "';
        requestStructure = requestStructure +  personAcc.Id + '","firstName": "","lastname": "","dateOfBirth": "","relationship": "","email": ""}}';
        req.requestBody = Blob.valueof(requestStructure);
        RestContext.request = req;
        RestContext.response= res;
        string jsonValue = RestContext.request.requestBody.toString();
        test.startTest();
        SENSAPI_careGiverRequestProcessor reqprocessor = new SENSAPI_careGiverRequestProcessor();
        IRestResponseWrapper responseWrapper = reqprocessor.process(jsonValue);
        test.stopTest();
    }
    
    static testMethod void postRegisterValidInput(){
        Id accId = [SELECT Id FROM Account WHERE Recordtype.Name = 'Individual' LIMIT 1].Id;
        Account famId = [select id,Member_Id__c from Account limit 1];
        SNI_FL_Care_Team_Member__c careTeamMember1 = [select id,SNI_FL_Member__c,SNI_FL_Family__c,SNI_FL_Family__r.Member_ID__c from SNI_FL_Care_Team_Member__c limit 1];
        RestRequest req = new RestRequest(); 
        RestResponse res = new RestResponse();
        string requestStructure = '{"subscriberId": "'+famId.Member_Id__c+'","action": "removed","familyMember": {"sensId": "';
        requestStructure = requestStructure +  accId + '","firstName": "","lastname": "","dateOfBirth": "","relationship": "","email": ""}}';
        req.requestBody = Blob.valueof(requestStructure);
        RestContext.request = req;
        RestContext.response= res;
        string jsonValue = RestContext.request.requestBody.toString();
        test.startTest();
        SENSAPI_careGiverRequestProcessor reqprocessor = new SENSAPI_careGiverRequestProcessor();
        IRestResponseWrapper responseWrapper = reqprocessor.process(jsonValue);
        test.stopTest();
        //SNI_FL_Care_Team_Member__c CTM = [SELECT SNI_FL_Status__c FROM SNI_FL_Care_Team_Member__c WHERE SNI_FL_Member__c=: accId LIMIT 1];
        //System.assertEquals('Registered', CTM.SNI_FL_Status__c);
    }
    
    static testMethod void postAlreadyRegistered(){
        Id accId = [SELECT Id FROM Account WHERE Recordtype.Name = 'Individual' LIMIT 1].Id;
        Account famId = [select id,Member_Id__c from Account limit 1];
        SNI_FL_Care_Team_Member__c careTeamMember1 = [select id,SNI_FL_Member__c,SNI_FL_Family__c,SNI_FL_Family__r.Member_ID__c from SNI_FL_Care_Team_Member__c limit 1];
        careTeamMember1.SNI_FL_Status__c = 'registered';
        update careTeamMember1;
        RestRequest req = new RestRequest(); 
        RestResponse res = new RestResponse();
        string requestStructure = '{"subscriberId": "'+famId.Member_Id__c+'","action": "registered","familyMember": {"sensId": "';
        requestStructure = requestStructure +  accId + '","firstName": "","lastname": "","dateOfBirth": "","relationship": "","email": ""}}';
        req.requestBody = Blob.valueof(requestStructure);
        RestContext.request = req;
        RestContext.response= res;
        string jsonValue = RestContext.request.requestBody.toString();
        test.startTest();
        SENSAPI_careGiverRequestProcessor reqprocessor = new SENSAPI_careGiverRequestProcessor();
        IRestResponseWrapper responseWrapper = reqprocessor.process(jsonValue);
        test.stopTest();
    }
    
    
    static testMethod void postRegisterBlankReqFields(){
        Id accId = [SELECT Id FROM Account WHERE Recordtype.Name = 'Individual' LIMIT 1].Id;
        RestRequest req = new RestRequest(); 
        RestResponse res = new RestResponse();
        string requestStructure = '{"subscriberId": "","action": "Registered","familyMember": {"sensId": "';
        requestStructure = requestStructure +  accId + '","firstName": "","lastname": "","dateOfBirth": "","relationship": "","email": ""}}';
        req.requestBody = Blob.valueof(requestStructure);
        RestContext.request = req;
        RestContext.response= res;
        string jsonValue = RestContext.request.requestBody.toString();
        test.startTest();
        SENSAPI_careGiverRequestProcessor reqprocessor = new SENSAPI_careGiverRequestProcessor();
        IRestResponseWrapper responseWrapper = reqprocessor.process(jsonValue);
        test.stopTest();
    }
    
    static testMethod void actionBlankTest(){
        Id accId = [SELECT Id FROM Account WHERE Recordtype.Name = 'Individual' LIMIT 1].Id;
        RestRequest req = new RestRequest(); 
        RestResponse res = new RestResponse();
        string requestStructure = '{"subscriberId": "12345","action": "","familyMember": {"sensId": "';
        requestStructure = requestStructure +  accId + '","firstName": "","lastname": "","dateOfBirth": "","relationship": "","email": ""}}';
        req.requestBody = Blob.valueof(requestStructure);
        RestContext.request = req;
        RestContext.response= res;
        string jsonValue = RestContext.request.requestBody.toString();
        test.startTest();
        SENSAPI_careGiverRequestProcessor reqprocessor = new SENSAPI_careGiverRequestProcessor();
        IRestResponseWrapper responseWrapper = reqprocessor.process(jsonValue);
        test.stopTest();
    }
    
    static testMethod void postRegisterNoCTeamFound(){
        Id accId = [SELECT Id FROM Account WHERE Recordtype.Name = 'Individual' LIMIT 1].Id;
        RestRequest req = new RestRequest(); 
        RestResponse res = new RestResponse();
        string requestStructure = '{"subscriberId": "1234","action": "Registered","familyMember": {"sensId": "';
        requestStructure = requestStructure +  accId + '","firstName": "","lastname": "","dateOfBirth": "","relationship": "","email": ""}}';
        req.requestBody = Blob.valueof(requestStructure);
        RestContext.request = req;
        RestContext.response= res;
        string jsonValue = RestContext.request.requestBody.toString();
        test.startTest();
        SENSAPI_careGiverRequestProcessor reqprocessor = new SENSAPI_careGiverRequestProcessor();
        IRestResponseWrapper responseWrapper = reqprocessor.process(jsonValue);
        test.stopTest();
    }
    
    static testMethod void postRegisterTestPositive(){
        Id accId = [SELECT Id FROM Account WHERE Recordtype.Name = 'Individual' LIMIT 1].Id;
        Account famId = [SELECT Id,Member_Id__c FROM Account WHERE Recordtype.Name = 'Family' LIMIT 1];
        SNI_FL_Care_Team_Member__c careTeamMember1 = [select id,SNI_FL_Member__c,SNI_FL_Family__c,SNI_FL_Family__r.Member_ID__c from SNI_FL_Care_Team_Member__c limit 1];
        RestRequest req = new RestRequest(); 
        RestResponse res = new RestResponse();
        string requestStructure = '{"subscriberId": "'+famId.Member_Id__c+'","action": "Registered","familyMember": {"sensId": "';
        requestStructure = requestStructure +  accId + '","firstName": "","lastname": "","dateOfBirth": "","relationship": "","email": ""}}';
		req.requestBody = Blob.valueof(requestStructure);
        RestContext.request = req;
        RestContext.response= res;
        string jsonValue = RestContext.request.requestBody.toString();
        test.startTest();
        SENSAPI_careGiverRequestProcessor reqprocessor = new SENSAPI_careGiverRequestProcessor();
        IRestResponseWrapper responseWrapper = reqprocessor.process(jsonValue);
        test.stopTest();
    }
    
    static testMethod void invalidUserDetailsTest(){
        Id accId = [SELECT Id FROM Account WHERE Recordtype.Name = 'Individual' LIMIT 1].Id;
        RestRequest req = new RestRequest(); 
        RestResponse res = new RestResponse();
        string requestStructure = '{"subscriberId": "5768967","action": "removed","familyMember": {"sensId": "';
        requestStructure = requestStructure +  accId + '","firstName": "","lastname": "","dateOfBirth": "","relationship": "","email": ""}}';
        req.requestBody = Blob.valueof(requestStructure);
        RestContext.request = req;
        RestContext.response= res;
        string jsonValue = RestContext.request.requestBody.toString();
        test.startTest();
        SENSAPI_careGiverRequestProcessor reqprocessor = new SENSAPI_careGiverRequestProcessor();
        IRestResponseWrapper responseWrapper = reqprocessor.process(jsonValue);
        test.stopTest();
        //SNI_FL_Care_Team_Member__c CTM = [SELECT Email__c FROM SNI_FL_Care_Team_Member__c WHERE SNI_FL_Member__c=: accId];
        //System.assertEquals('newTest@test.com', CTM.Email__c);
    }
    
    static testMethod void fieldMissingTest(){
        RestRequest req = new RestRequest(); 
        RestResponse res = new RestResponse();
        string requestStructure = '{"subscriberId": "","action": "removed","familyMember": {"sensId": "","firstName": "","lastname": "","dateOfBirth": "","relationship": "","email": ""}}';
        req.requestBody = Blob.valueof(requestStructure);
        RestContext.request = req;
        RestContext.response= res;
        string jsonValue = RestContext.request.requestBody.toString();
        test.startTest();
        SENSAPI_careGiverRequestProcessor reqprocessor = new SENSAPI_careGiverRequestProcessor();
        IRestResponseWrapper responseWrapper = reqprocessor.process(jsonValue);
        test.stopTest();
        //SNI_FL_Care_Team_Member__c CTM = [SELECT Email__c FROM SNI_FL_Care_Team_Member__c WHERE SNI_FL_Member__c=: accId];
        //System.assertEquals('newTest@test.com', CTM.Email__c);
    }
    
    static testMethod void catchExceptionTest(){
        Id accId = [SELECT Id FROM Account WHERE Recordtype.Name = 'Individual' LIMIT 1].Id;
        RestRequest req = new RestRequest(); 
        RestResponse res = new RestResponse();
        string requestStructure = '{"subscriberId": ,"action": "Registered","familyMember": {"sensId": "';
        requestStructure = requestStructure +  accId + '","firstName": "","lastname": "","dateOfBirth": "","relationship": "","email": ""}}';
        req.requestBody = Blob.valueof(requestStructure);
        RestContext.request = req;
        RestContext.response= res;
        string jsonValue = RestContext.request.requestBody.toString();
        test.startTest();
        SENSAPI_careGiverRequestProcessor reqprocessor = new SENSAPI_careGiverRequestProcessor();
        IRestResponseWrapper responseWrapper = reqprocessor.process(jsonValue);
        test.stopTest();
        //SNI_FL_Care_Team_Member__c CTM = [SELECT Email__c FROM SNI_FL_Care_Team_Member__c WHERE SNI_FL_Member__c=: accId];
        //System.assertEquals('newTest@test.com', CTM.Email__c);
    }
}