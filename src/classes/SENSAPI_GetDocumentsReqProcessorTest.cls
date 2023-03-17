@isTest
public class SENSAPI_GetDocumentsReqProcessorTest {
	@testSetup static void dataSetup() {
		List<SNI_FL_Care_Team_Member__c> careTeamMember = new List<SNI_FL_Care_Team_Member__c>();
        List<Account> memberLst = new List<Account>();
        Id personRecTypeId = Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName().get('Individual').getRecordTypeId();
        Id familyRecTypeId = Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName().get('Family').getRecordTypeId();
        Account acc = new Account(FirstName = 'test', 
                                  lastName = 'test',
                                  member_id__c = '09202999992',
                                  recordtypeId = personRecTypeId);
        memberLst.add(acc);
        Account acc1 = new Account(FirstName = 'test1', 
                                  lastName = 'test1',
                                  member_id__c = '09202998882',
                                  recordtypeId = personRecTypeId);
        
        memberLst.add(acc1);
        Account famAcc = new Account(Name = 'test',
                                     member_id__c = '09202999992',
                                     recordtypeId = familyRecTypeId);
        Account famAcc1 = new Account(Name = 'test',
                                     member_id__c = '09202998882',
                                     recordtypeId = familyRecTypeId);
        memberLst.add(famAcc);
        memberLst.add(famAcc1);
        INSERT memberLst;
        Id conId = [Select PersonContactId From Account Where Id = :acc1.id].PersonContactId;
        AccountContactRelation acr = new AccountContactRelation(contactid = conId,accountid=famAcc.id);
        insert acr;
        
        
        Id profileId = [SELECT Id FROM Profile WHERE NAME = 'Care Advisor Connect Community User' LIMIT 1].Id;
   		User commUser = new User(alias = 'test123', email='test123@noemail.com',
                                emailencodingkey='UTF-8', lastname='Testing', languagelocalekey='en_US',
                                localesidkey='en_US', profileid = profileId, country='United States',IsActive =true,
                                ContactId = conId,
                                timezonesidkey='America/Los_Angeles', username='tester@noemail.com');
        insert commUser;

        SNI_FL_Care_Team_Member__c ctmMember = new SNI_FL_Care_Team_Member__c(SNI_FL_Member__c = acc.id,
                                                                              SNI_FL_Status__c = 'Added',
                                                                              SNI_FL_Family__c = famAcc.Id,
                                                                              Email__c = 'test@test.com');
        SNI_FL_Care_Team_Member__c ctmMember1 = new SNI_FL_Care_Team_Member__c(SNI_FL_Member__c = acc1.id,
                                                                              SNI_FL_Status__c = 'Added',
                                                                              SNI_FL_Family__c = famAcc1.Id,
                                                                              Email__c = 'test@test.com');
        
        careTeamMember.add(ctmMember);
        careTeamMember.add(ctmMember1);
        INSERT careTeamMember;
        Member_Information__c Meminfo = new Member_Information__c(Account__c = acc1.id);
        INSERT Meminfo;
        
        SNI_FL_Members_ROI__c roi = new SNI_FL_Members_ROI__c (SNI_FL_ROI_Signed_With__c = ctmMember1.id, SNI_FL_Account__c = acc1.id,SNI_FL_Status__c = 'Active');
        insert roi;

	}
    
    static testMethod void processorTestPositive(){
        Id accId = [SELECT Id FROM Account  WHERE Member_id__c = '09202999992'and isPersonAccount = true LIMIT 1].Id;
        string requestStructure = '{"subscriberId": "09202999992","memberSensId": "0017600000NQBEeAAP", "count": 4,"offset": 0,"latest": "2022-11-17T05:09:06.000Z","oldest": "2022-04-13T09:30:26.000Z"}';

        test.startTest();
		RestRequest req = new RestRequest();
        RestResponse res = new RestResponse();
        req.requestBody = Blob.valueof(requestStructure);
        RestContext.request = req;
        RestContext.response= res;
        string jsonValue = RestContext.request.requestBody.toString();
        SENSAPI_GetDocumentsReqProcessor reqprocessor = new SENSAPI_GetDocumentsReqProcessor();
        IRestResponseWrapper responseWrapper = reqprocessor.process(jsonValue);
        test.stopTest();
    }
    
    static testMethod void successTest(){
        Id accId = [SELECT Id FROM Account  WHERE Member_id__c = '09202999992' and isPersonAccount = true LIMIT 1].Id;
        string requestStructure = '{"subscriberId": "09202999992","memberSensId": "';
        requestStructure = requestStructure+ accId+ '", "count": 4,"offset": 0,"latest": "2022-11-17T05:09:06.000Z","oldest": "2022-04-13T09:30:26.000Z"}';

        test.startTest();
		RestRequest req = new RestRequest();
        RestResponse res = new RestResponse();
        req.requestBody = Blob.valueof(requestStructure);
        RestContext.request = req;
        RestContext.response= res;
        string jsonValue = RestContext.request.requestBody.toString();
        SENSAPI_GetDocumentsReqProcessor reqprocessor = new SENSAPI_GetDocumentsReqProcessor();
        IRestResponseWrapper responseWrapper = reqprocessor.process(jsonValue);
        test.stopTest();
    }
    static testMethod void exceptionTest(){
        string requestStructure = '{"subscriberId": "09202999992","memberSensId": "0017600000NQBEeAAP", "count": 4,"offset": 0,"latest": "2022-11-17T05:09:06.000Z","oldest": "2022-04-13T09:30:26.000Z"';

        test.startTest();
		RestRequest req = new RestRequest();
        RestResponse res = new RestResponse();
        req.requestBody = Blob.valueof(requestStructure);
        RestContext.request = req;
        RestContext.response= res;
        string jsonValue = RestContext.request.requestBody.toString();
        SENSAPI_GetDocumentsReqProcessor reqprocessor = new SENSAPI_GetDocumentsReqProcessor();
        IRestResponseWrapper responseWrapper = reqprocessor.process(jsonValue);
        test.stopTest();
    }
    static testMethod void initProcessorCatchTest(){
        string requestStructure = '{"subscriberId": "09202999992","memberSensId": "0017600000NQBEeAAP", "count": 4,"offset": 0,"latest": "2022-11-17T05:09:06.000Z","oldest": "2022-04-13T09:30:26.000Z"}';

        test.startTest();
		RestRequest req = new RestRequest();
        RestResponse res = new RestResponse();
        req.requestBody = Blob.valueof(requestStructure);
        RestContext.request = req;
        RestContext.response= res;
        string jsonValue = RestContext.request.requestBody.toString();
        SENSAPI_GetDocumentsReqProcessor reqprocessor = new SENSAPI_GetDocumentsReqProcessor();
        IRestResponseWrapper responseWrapper = reqprocessor.process(jsonValue);
        test.stopTest();
    }
    static testMethod void requiredParamBlankTest(){
        string requestStructure = '{"subscriberId": "","memberSensId": "0017600000NQBEeAAP", "count": 4,"offset": 0,"latest": "2022-11-17T05:09:06.000Z","oldest": "2022-04-13T09:30:26.000Z"}';

        test.startTest();
		RestRequest req = new RestRequest();
        RestResponse res = new RestResponse();
        req.requestBody = Blob.valueof(requestStructure);
        RestContext.request = req;
        RestContext.response= res;
        string jsonValue = RestContext.request.requestBody.toString();
        SENSAPI_GetDocumentsReqProcessor reqprocessor = new SENSAPI_GetDocumentsReqProcessor();
        IRestResponseWrapper responseWrapper = reqprocessor.process(jsonValue);
        test.stopTest();
    }
    static testMethod void invalidDetailsTest(){
        Id accId = [SELECT Id FROM Account  WHERE Member_id__c = '09202998882' LIMIT 1].Id;
        string requestStructure = '{"subscriberId": "09202998882","memberSensId": "';
        requestStructure = requestStructure+ accId+ '", "count": 4,"offset": 0,"latest": "2022-11-17T05:09:06.000Z","oldest": "2022-04-13T09:30:26.000Z"}';

        test.startTest();
		RestRequest req = new RestRequest();
        RestResponse res = new RestResponse();
        req.requestBody = Blob.valueof(requestStructure);
        RestContext.request = req;
        RestContext.response= res;
        string jsonValue = RestContext.request.requestBody.toString();
        SENSAPI_GetDocumentsReqProcessor reqprocessor = new SENSAPI_GetDocumentsReqProcessor();
        IRestResponseWrapper responseWrapper = reqprocessor.process(jsonValue);
        test.stopTest();
    }
   static testMethod void responseTest(){
		list<SENSAPI_GetDocumentsResponse.DocClass> documentList = new List<SENSAPI_GetDocumentsResponse.DocClass>();
        documentList.add(new SENSAPI_GetDocumentsResponse.DocClass());
        test.startTest();
		SENSAPI_GetDocumentsResponse.contentDocClass resp = new SENSAPI_GetDocumentsResponse.contentDocClass(documentList);
        test.stopTest();
    }
    static testMethod void positiveResponseTest(){
        List<Member_Information__c> memberInfo = [SELECT ID FROM Member_Information__c LIMIT 1];
        //Create Content Version
        ContentVersion cv = new ContentVersion();
        cv.Title = 'Test Document';
        cv.PathOnClient = 'Test Documentt.pdf';
        cv.VersionData = Blob.valueOf('Test Content');
        cv.IsMajorVersion = true;
        Insert cv;
        
        //Get Content Document
        List<ContentDocument> documents = [SELECT Id FROM ContentDocument];
    	system.debug('in cd:::::' + documents);
        List<ContentDocumentLink> cdList = new List<ContentDocumentLink>();
        ContentDocumentLink cdl = new ContentDocumentLink(Visibility = 'AllUsers',LinkedEntityId = memberInfo[0].Id,ContentDocumentId = documents[0].Id);
        cdList.add(cdl);
        insert cdList;
        
        Id accId = [SELECT Id FROM Account  WHERE Member_id__c = '09202998882' AND isPersonAccount = true LIMIT 1].Id;
        string requestStructure = '{"subscriberId": "09202998882","memberSensId": "';
        requestStructure = requestStructure+ accId+ '", "count": 4,"offset": 0,"latest": "2028-11-17T05:09:06.000Z","oldest": "2022-04-13T09:30:26.000Z"}';

        test.startTest();
		RestRequest req = new RestRequest();
        RestResponse res = new RestResponse();
        req.requestBody = Blob.valueof(requestStructure);
        RestContext.request = req;
        RestContext.response= res;
        string jsonValue = RestContext.request.requestBody.toString();
        SENSAPI_GetDocumentsReqProcessor reqprocessor = new SENSAPI_GetDocumentsReqProcessor();
        IRestResponseWrapper responseWrapper = reqprocessor.process(jsonValue);
        test.stopTest();
    }

}