/*------------------------------------------------------------
Author:        Manmeet Kaur
Description:   Test class for SENSAPI_PostSendInviteReqProcessor  

History
Date            Author              Comments
-------------------------------------------------------------
03-10-2022      Manmeet Kaur      	Created
------------------------------------------------------------*/
@isTest
public class SENSAPI_PostSendInviteReqProcessorTest {
    
    @testSetup static void dataSetup() {
		List<SNI_FL_Care_Team_Member__c> careTeamMember = new List<SNI_FL_Care_Team_Member__c>();
        List<Account> memberLst = new List<Account>();
        Id personRecTypeId = Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName().get('Individual').getRecordTypeId();
        Id famTypeId = Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName().get('Family').getRecordTypeId();
        for(integer i = 0; i<2;i++){
            Account acc = new Account(FirstName = 'test'+i, 
                                      lastName = 'test'+i, 
                                      recordtypeId = personRecTypeId);
            memberLst.add(acc);
        }
        Account fam = new Account(Name = 'Sheperd Family' , recordtypeId = famTypeId, member_id__c = '00756767666');
        memberLst.add(fam);
        INSERT memberLst;
        for(integer i = 0; i<2;i++){
            SNI_FL_Care_Team_Member__c ctmMember = new SNI_FL_Care_Team_Member__c(SNI_FL_Member__c = memberLst[i].id,
                																  SNI_FL_Status__c = 'Added',
                                                                                  Email__c = 'test'+i+'@test.com',
                                                                                  SNI_FL_Family__c = fam.id);
            
            careTeamMember.add(ctmMember);
        }
        INSERT careTeamMember;
	}
    
    static testMethod void PostSendInviteReqProcessorTestPositive(){
        Id accId = [SELECT Id FROM Account LIMIT 1].Id;
        RestRequest req = new RestRequest(); 
        RestResponse res = new RestResponse();
        string requestStructure = '{"subscriberId": "00756767666","sensId": ';
        requestStructure = requestStructure + '"'+ accId + '", "email": "newTest@test.com"}';
        req.requestBody = Blob.valueof(requestStructure);
        RestContext.request = req;
        RestContext.response= res;
        string jsonValue = RestContext.request.requestBody.toString();
        test.startTest();
        SENSAPI_PostSendInviteReqProcessor reqprocessor = new SENSAPI_PostSendInviteReqProcessor();
        IRestResponseWrapper responseWrapper = reqprocessor.process(jsonValue);
        test.stopTest();
        SNI_FL_Care_Team_Member__c CTM = [SELECT Email__c FROM SNI_FL_Care_Team_Member__c WHERE SNI_FL_Member__c=: accId];
        System.assertEquals('newTest@test.com', CTM.Email__c);
    }
    
    static testMethod void ResendInviteTest(){
        Account acc = [SELECT Id FROM Account LIMIT 1];
        Contact con = [SELECT Id FROM Contact where Contact.AccountId=: acc.id];
        Profile p = [SELECT Id FROM Profile WHERE Name='Care Advisor Connect Community User'];
        User u = new user(LastName = 'Test Code',Email = 'test@test.com',Alias = 'Tcode',contactid = con.id,
                          Username = 'test9217@test.com',LocaleSidKey = 'en_US',TimeZoneSidKey = 'GMT',
                          ProfileID = p.Id,LanguageLocaleKey = 'en_US',EmailEncodingKey = 'UTF-8');
        Insert u;
        
        Id accId = [SELECT Id FROM Account LIMIT 1].Id;
        RestRequest req = new RestRequest(); 
        RestResponse res = new RestResponse();
        string requestStructure = '{"subscriberId": "00756767666","sensId": ';
        requestStructure = requestStructure + '"'+ accId + '", "email": "newTest@test.com"}';
        req.requestBody = Blob.valueof(requestStructure);
        RestContext.request = req;
        RestContext.response= res;
        string jsonValue = RestContext.request.requestBody.toString();
        test.startTest();
        SENSAPI_PostSendInviteReqProcessor reqprocessor = new SENSAPI_PostSendInviteReqProcessor();
        IRestResponseWrapper responseWrapper = reqprocessor.process(jsonValue);
        test.stopTest();
        SNI_FL_Care_Team_Member__c CTM = [SELECT Email__c FROM SNI_FL_Care_Team_Member__c WHERE SNI_FL_Member__c=: accId];
        System.assertEquals('newTest@test.com', CTM.Email__c);
    }
    static testMethod void RegisteredStatusTest(){
        SNI_FL_Care_Team_Member__c updateTM = [SELECT Id,SNI_FL_Status__c,SNI_FL_Member__c FROM SNI_FL_Care_Team_Member__c LIMIT 1];
        updateTM.SNI_FL_Status__c = 'Registered';
        UPDATE updateTM;
        
        RestRequest req = new RestRequest(); 
        RestResponse res = new RestResponse();
        string requestStructure = '{"subscriberId": "00756767666","sensId": ';
        requestStructure = requestStructure + '"'+ updateTM.SNI_FL_Member__c + '", "email": "Test@test.com"}';
        req.requestBody = Blob.valueof(requestStructure);
        RestContext.request = req;
        RestContext.response= res;
        string jsonValue = RestContext.request.requestBody.toString();
        test.startTest();
        SENSAPI_PostSendInviteReqProcessor reqprocessor = new SENSAPI_PostSendInviteReqProcessor();
        IRestResponseWrapper responseWrapper = reqprocessor.process(jsonValue);
        test.stopTest();
        System.assert(string.valueOf(responseWrapper).contains(SENSAPI_Constant.CTM_ALREADY_REGISTERED));
    }
    static testMethod void noCTMTest(){
        RestRequest req = new RestRequest(); 
        RestResponse res = new RestResponse();
        string requestStructure = '{"subscriberId": "00756767666","sensId": "849493933395","email": "Test@test.com"}';
        req.requestBody = Blob.valueof(requestStructure);
        RestContext.request = req;
        RestContext.response= res;
        string jsonValue = RestContext.request.requestBody.toString();
        test.startTest();
        SENSAPI_PostSendInviteReqProcessor reqprocessor = new SENSAPI_PostSendInviteReqProcessor();
        IRestResponseWrapper responseWrapper = reqprocessor.process(jsonValue);
        test.stopTest();
    }
    static testMethod void emailMissingTest(){
        RestRequest req = new RestRequest(); 
        RestResponse res = new RestResponse();
        string requestStructure = '{"subscriberId": "00756767666","sensId": "","email": ""}';
        req.requestBody = Blob.valueof(requestStructure);
        RestContext.request = req;
        RestContext.response= res;
        string jsonValue = RestContext.request.requestBody.toString();
        test.startTest();
        SENSAPI_PostSendInviteReqProcessor reqprocessor = new SENSAPI_PostSendInviteReqProcessor();
        IRestResponseWrapper responseWrapper = reqprocessor.process(jsonValue);
        test.stopTest();
    }
    static testMethod void invalidEmailTest(){
        RestRequest req = new RestRequest(); 
        RestResponse res = new RestResponse();
        string requestStructure = '{"subscriberId": "00756767666","sensId": "849493933395","email": "abc@gmail"}';
        req.requestBody = Blob.valueof(requestStructure);
        RestContext.request = req;
        RestContext.response= res;
        string jsonValue = RestContext.request.requestBody.toString();
        test.startTest();
        SENSAPI_PostSendInviteReqProcessor reqprocessor = new SENSAPI_PostSendInviteReqProcessor();
        IRestResponseWrapper responseWrapper = reqprocessor.process(jsonValue);
        test.stopTest();
        System.assert(string.valueOf(responseWrapper).contains(SENSAPI_Constant.EMAIL_ADDRESS_INVALID));
    }
    static testMethod void resendInvite(){
        SNI_FL_Care_Team_Member__c updateTM = [SELECT Id,SNI_FL_Status__c,SNI_FL_Member__c FROM SNI_FL_Care_Team_Member__c LIMIT 1];
        updateTM.SNI_FL_Status__c = 'Invited';
        UPDATE updateTM;
        RestRequest req = new RestRequest(); 
        RestResponse res = new RestResponse();
        string requestStructure = '{"subscriberId": "00756767666","sensId": ';
        requestStructure = requestStructure + '"'+ updateTM.SNI_FL_Member__c + '", "email": "Test@test.com"}';
        req.requestBody = Blob.valueof(requestStructure);
        RestContext.request = req;
        RestContext.response= res;
        string jsonValue = RestContext.request.requestBody.toString();
        test.startTest();
        SENSAPI_PostSendInviteReqProcessor reqprocessor = new SENSAPI_PostSendInviteReqProcessor();
        IRestResponseWrapper responseWrapper = reqprocessor.process(jsonValue);
        test.stopTest();
    }
    static testMethod void initProcessorCatchTest(){
        RestRequest req = new RestRequest(); 
        RestResponse res = new RestResponse();
        string requestStructure = '{"subscriberId": "00756767666","sensId": ","email": ""}';
        req.requestBody = Blob.valueof(requestStructure);
        RestContext.request = req;
        RestContext.response= res;
        string jsonValue = RestContext.request.requestBody.toString();
        test.startTest();
        SENSAPI_PostSendInviteReqProcessor reqprocessor = new SENSAPI_PostSendInviteReqProcessor();
        IRestResponseWrapper responseWrapper = reqprocessor.process(jsonValue);
        test.stopTest();
    }
    static testMethod void invalidRequestTest(){
        RestRequest req = new RestRequest(); 
        RestResponse res = new RestResponse();
        string requestStructure = '{"subscriberId": "1756767666","sensId": "90008755789999","email": "Test@test.com"}';
        req.requestBody = Blob.valueof(requestStructure);
        RestContext.request = req;
        RestContext.response= res;
        string jsonValue = RestContext.request.requestBody.toString();
        test.startTest();
        SENSAPI_PostSendInviteReqProcessor reqprocessor = new SENSAPI_PostSendInviteReqProcessor();
        IRestResponseWrapper responseWrapper = reqprocessor.process(jsonValue);
        test.stopTest();
    }
}