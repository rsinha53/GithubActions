/*------------------------------------------------------------
Description:   Test class for SENSAPI_GetMemberDocumentsReqProcessor  

History
Date            Author              Comments
-------------------------------------------------------------
25-NOV-2022     Geeta Koli      	Created
------------------------------------------------------------*/
@isTest
public class SENSAPI_GetMemberDocsReqProcessorTest {
    @testSetup static void dataSetup() {
		List<SNI_FL_Care_Team_Member__c> careTeamMember = new List<SNI_FL_Care_Team_Member__c>();
        List<Account> memberLst = new List<Account>();
        Id personRecTypeId = Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName().get('Individual').getRecordTypeId();
        Id familyRecTypeId = Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName().get('Family').getRecordTypeId();
        Account famAcc = new Account(Name = 'test', 
                                     Member_Id__c = '00011223344',
                                     recordtypeId = familyRecTypeId);
        insert famAcc;
        //memberLst.add(famAcc);
        Account personAcc = new Account(FirstName = 'test', 
                                        lastName = 'test', 
                                        Member_ID__c = famAcc.Member_Id__c,
                                        recordtypeId = personRecTypeId);
        memberLst.add(personAcc);
               
        INSERT memberLst;

        Id conId = [Select PersonContactId From Account Where Id = :personAcc.id].PersonContactId;
        AccountContactRelation acr = new AccountContactRelation(contactid = conId,accountid=famAcc.id);
        insert acr;
        
        Id profileId = [SELECT Id FROM Profile WHERE NAME = 'Care Advisor Connect Community User' LIMIT 1].Id;
   		User commUser = new User(alias = 'test123', email='test123@noemail.com',
                                emailencodingkey='UTF-8', lastname='Testing', languagelocalekey='en_US',
                                localesidkey='en_US', profileid = profileId, country='United States',IsActive =true,
                                ContactId = conId,
                                timezonesidkey='America/Los_Angeles', username='tester@noemail.com');
        insert commUser;

        Member_Information__c Meminfo = new Member_Information__c(Account__c = personAcc.id);
        INSERT Meminfo;
       
        //Create Content Version
        ContentVersion cv = new ContentVersion();
        cv.Title = 'Test Document PratikshyaSat';
        cv.PathOnClient = 'Test Document PratikshyaSat.pdf';
        cv.VersionData = Blob.valueOf('Test Content');
        cv.IsMajorVersion = true;
        Insert cv;
        
        //Get Content Document
        List<ContentVersion> cversion = [SELECT Id, contentdocumentid FROM contentversion where id=:cv.id]; 

        List<ContentDocument> documents = [SELECT Id, Title, LatestPublishedVersionId FROM ContentDocument];
    
        ContentDocumentLink cdl = new ContentDocumentLink(Visibility = 'AllUsers',LinkedEntityId = Meminfo.Id,ContentDocumentId = documents[0].Id);
        insert cdl;
        
        /*List<ContentDocument> documents = [
            SELECT Id, Title, LatestPublishedVersionId
            FROM ContentDocument limit 1];
        
        ContentDocumentLink contentlink=new ContentDocumentLink();
        contentlink.LinkedEntityId=Meminfo.id;
        contentlink.ShareType= 'C';
        contentlink.LinkedEntityId = Meminfo.Id; 
        contentlink.ContentDocumentId=documents[0].Id;
        contentlink.Visibility = 'AllUsers'; 
        insert contentlink;*/
	}
    
    static testMethod void PostSendInviteReqProcessorTestPositive(){
        Account personAcc = [SELECT Id FROM Account WHERE Recordtype.Name = 'Individual' LIMIT 1];
        Account famAcc = [SELECT Id,Member_ID__c FROM Account WHERE Recordtype.Name = 'Family' LIMIT 1];

        string requestStructure = '{"subscriberId": "' + famAcc.Member_ID__c + '","memberSensId": "' + personAcc.Id + '", "count": 4,"offset": 0,"latest": "2022-11-28T05:09:06.000Z","oldest": "2022-11-28T05:09:06.000Z"}';

        test.startTest();
		RestRequest req = new RestRequest();
        RestResponse res = new RestResponse();
        req.requestBody = Blob.valueof(requestStructure);
        RestContext.request = req;
        RestContext.response= res;
        string jsonValue = RestContext.request.requestBody.toString();
        SENSAPI_GetMemberDocumentsReqProcessor reqprocessor = new SENSAPI_GetMemberDocumentsReqProcessor();
        IRestResponseWrapper responseWrapper = reqprocessor.process(jsonValue);
        test.stopTest();
    }
    
    static testMethod void PostSendInviteReqProcessorTestDocuments(){
        Id personRecTypeId = Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName().get('Individual').getRecordTypeId();
        Id familyRecTypeId = Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName().get('Family').getRecordTypeId();
        Account famAcc = new Account(Name = 'test', 
                                     Member_Id__c = '54781335841',
                                     recordtypeId = familyRecTypeId);
        insert famAcc;

        Account personAcc = new Account(FirstName = 'test', 
                                        lastName = 'test', 
                                        Member_ID__c = famAcc.Member_Id__c,
                                        recordtypeId = personRecTypeId);      
        INSERT personAcc;
        
        string requestStructure = '{"subscriberId": "' + famAcc.Member_ID__c + '","memberSensId": "' + personAcc.Id + '", "count": 4,"offset": 0,"latest": "2022-11-28T05:09:06.000Z","oldest": "2022-11-28T05:09:06.000Z"}';

        
        Id conId = [Select PersonContactId From Account Where Id = :personAcc.id].PersonContactId;
        AccountContactRelation acr = new AccountContactRelation(contactid = conId,accountid=famAcc.id);
        insert acr;
        test.startTest();
        Id profileId = [SELECT Id FROM Profile WHERE NAME = 'Care Advisor Connect Community User' LIMIT 1].Id;
   		User commUser = new User(alias = 'test123', email='test138@noemail.com',
                                emailencodingkey='UTF-8', lastname='Testing', languagelocalekey='en_US',
                                localesidkey='en_US', profileid = profileId, country='United States',IsActive =true,
                                ContactId = conId,
                                timezonesidkey='America/Los_Angeles', username='tester873@noemail.com');
        insert commUser;

        Member_Information__c Meminfo = new Member_Information__c(Account__c = personAcc.id);
        INSERT Meminfo;
                
        map<id,id> memberInfoToAccountMap = new map<id,id>();
        memberInfoToAccountMap.put(Meminfo.id,Meminfo.Account__c);
        
        //Create Content Version
        ContentVersion cv = new ContentVersion();
        cv.Title = 'Test Document PratikshyaSat';
        cv.PathOnClient = 'Test Document PratikshyaSat.pdf';
        cv.VersionData = Blob.valueOf('Test Content');
        cv.IsMajorVersion = true;
        Insert cv;
        
        //Get Content Document
        List<ContentVersion> cversion = [SELECT Id, contentdocumentid FROM contentversion where id=:cv.id]; 

        List<ContentDocument> documents = [SELECT Id, Title, LatestPublishedVersionId, ContentDocument.OwnerId, ContentDocument.LastModifiedDate,
                                           ContentDocument.FileType, ContentDocument.contentsize, ContentDocument.createddate
                                           FROM ContentDocument];
    
        List<ContentDocumentLink> cdList = new List<ContentDocumentLink>();
        ContentDocumentLink cdl = new ContentDocumentLink(Visibility = 'AllUsers',LinkedEntityId = Meminfo.Id,ContentDocumentId = documents[0].Id);
        cdList.add(cdl);
        insert cdList;
        
		RestRequest req = new RestRequest();
        RestResponse res = new RestResponse();
        req.requestBody = Blob.valueof(requestStructure);
        RestContext.request = req;
        RestContext.response= res;
        string jsonValue = RestContext.request.requestBody.toString();
        SENSAPI_GetMemberDocumentsReqProcessor reqprocessor = new SENSAPI_GetMemberDocumentsReqProcessor();
        IRestResponseWrapper responseWrapper = reqprocessor.process(jsonValue);
        reqprocessor.generateGetDocumentsResponse(documents, cdList, memberInfoToAccountMap, 2);
        test.stopTest();
    }
    
    static testMethod void PostSendInviteReqProcessorTestInactiveUserException(){
        Id personRecTypeId = Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName().get('Individual').getRecordTypeId();
        Id familyRecTypeId = Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName().get('Family').getRecordTypeId();
        Account famAcc = new Account(Name = 'test', 
                                     Member_Id__c = '54781357841',
                                     recordtypeId = familyRecTypeId);
        insert famAcc;

        Account personAcc = new Account(FirstName = 'test', 
                                        lastName = 'test', 
                                        Member_ID__c = famAcc.Member_Id__c,
                                        recordtypeId = personRecTypeId);      
        INSERT personAcc;
        
        string requestStructure = '{"subscriberId": "' + famAcc.Member_ID__c + '","memberSensId": "' + personAcc.Id + '", "count": 1,"offset": 0,"latest": "","oldest": ""}';

        test.startTest();
		RestRequest req = new RestRequest();
        RestResponse res = new RestResponse();
        req.requestBody = Blob.valueof(requestStructure);
        RestContext.request = req;
        RestContext.response= res;
        string jsonValue = RestContext.request.requestBody.toString();
        SENSAPI_GetMemberDocumentsReqProcessor reqprocessor = new SENSAPI_GetMemberDocumentsReqProcessor();
        IRestResponseWrapper responseWrapper = reqprocessor.process(jsonValue);
        test.stopTest();
    }
    
    static testMethod void PostSendInviteReqProcessorTestInvalidUserException(){
        Id personRecTypeId = Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName().get('Individual').getRecordTypeId();
        Id familyRecTypeId = Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName().get('Family').getRecordTypeId();
        Account famAcc = new Account(Name = 'test', 
                                     Member_Id__c = '54781357841',
                                     recordtypeId = familyRecTypeId);
        insert famAcc;

        Account personAcc = new Account(FirstName = 'test', 
                                        lastName = 'test', 
                                        Member_ID__c = famAcc.Member_Id__c,
                                        recordtypeId = personRecTypeId);      
        INSERT personAcc;
        
        Id conId = [Select PersonContactId From Account Where Id = :personAcc.id].PersonContactId;
        Id profileId = [SELECT Id FROM Profile WHERE NAME = 'Care Advisor Connect Community User' LIMIT 1].Id;
   		User commUser = new User(alias = 'test1234', email='test1235@noemail.com',
                                emailencodingkey='UTF-8', lastname='Testing', languagelocalekey='en_US',
                                localesidkey='en_US', profileid = profileId, country='United States',IsActive =true,
                                ContactId = conId,
                                timezonesidkey='America/Los_Angeles', username='tester6@noemail.com');
        insert commUser;
        
        string requestStructure = '{"subscriberId": "' + famAcc.Member_ID__c + '","memberSensId": "' + personAcc.Id + '", "count": 1,"offset": 0,"latest": "","oldest": ""}';

        test.startTest();
		RestRequest req = new RestRequest();
        RestResponse res = new RestResponse();
        req.requestBody = Blob.valueof(requestStructure);
        RestContext.request = req;
        RestContext.response= res;
        string jsonValue = RestContext.request.requestBody.toString();
        SENSAPI_GetMemberDocumentsReqProcessor reqprocessor = new SENSAPI_GetMemberDocumentsReqProcessor();
        IRestResponseWrapper responseWrapper = reqprocessor.process(jsonValue);
        test.stopTest();
    }
    
    static testMethod void PostSendInviteReqProcessorTestJunkException(){
        Id personRecTypeId = Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName().get('Individual').getRecordTypeId();
        Id familyRecTypeId = Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName().get('Family').getRecordTypeId();
        Account famAcc = new Account(Name = 'test', 
                                     Member_Id__c = 'junk',
                                     recordtypeId = familyRecTypeId);
        insert famAcc;

        Account personAcc = new Account(FirstName = 'test', 
                                        lastName = 'test', 
                                        Member_ID__c = famAcc.Member_Id__c,
                                        recordtypeId = personRecTypeId);      
        INSERT personAcc;
        
        Id conId = [Select PersonContactId From Account Where Id = :personAcc.id].PersonContactId;
        AccountContactRelation acr = new AccountContactRelation(contactid = conId,accountid=famAcc.id);
        insert acr;
        Id profileId = [SELECT Id FROM Profile WHERE NAME = 'Care Advisor Connect Community User' LIMIT 1].Id;
   		User commUser = new User(alias = 'test1234', email='test1235@noemail.com',
                                emailencodingkey='UTF-8', lastname='Testing', languagelocalekey='en_US',
                                localesidkey='en_US', profileid = profileId, country='United States',IsActive =true,
                                ContactId = conId,
                                timezonesidkey='America/Los_Angeles', username='tester6@noemail.com');
        insert commUser;
        
        string requestStructure = '{"subscriberId": "' + famAcc.Member_ID__c + '","memberSensId": "' + personAcc.Id + '", "count": 1,"offset": 0,"latest": "","oldest": ""}';

        test.startTest();
		RestRequest req = new RestRequest();
        RestResponse res = new RestResponse();
        req.requestBody = Blob.valueof(requestStructure);
        RestContext.request = req;
        RestContext.response= res;
        string jsonValue = RestContext.request.requestBody.toString();
        SENSAPI_GetMemberDocumentsReqProcessor reqprocessor = new SENSAPI_GetMemberDocumentsReqProcessor();
        IRestResponseWrapper responseWrapper = reqprocessor.process(jsonValue);
        test.stopTest();
    }
    
    static testMethod void PostSendInviteReqProcessorTestRequiredFieldsException(){
        Id personRecTypeId = Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName().get('Individual').getRecordTypeId();
        Id familyRecTypeId = Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName().get('Family').getRecordTypeId();
        Account famAcc = new Account(Name = 'test', 
                                     Member_Id__c = 'junk',
                                     recordtypeId = familyRecTypeId);
        insert famAcc;

        Account personAcc = new Account(FirstName = 'test', 
                                        lastName = 'test', 
                                        Member_ID__c = famAcc.Member_Id__c,
                                        recordtypeId = personRecTypeId);      
        INSERT personAcc;
        
        Id conId = [Select PersonContactId From Account Where Id = :personAcc.id].PersonContactId;
        AccountContactRelation acr = new AccountContactRelation(contactid = conId,accountid=famAcc.id);
        insert acr;
        Id profileId = [SELECT Id FROM Profile WHERE NAME = 'Care Advisor Connect Community User' LIMIT 1].Id;
   		User commUser = new User(alias = 'test1234', email='test1235@noemail.com',
                                emailencodingkey='UTF-8', lastname='Testing', languagelocalekey='en_US',
                                localesidkey='en_US', profileid = profileId, country='United States',IsActive =true,
                                ContactId = conId,
                                timezonesidkey='America/Los_Angeles', username='tester6@noemail.com');
        insert commUser;
        
        string requestStructure = '{"memberSensId": "' + personAcc.Id + '", "count": 1,"offset": 0,"latest": "","oldest": ""}';

        test.startTest();
		RestRequest req = new RestRequest();
        RestResponse res = new RestResponse();
        req.requestBody = Blob.valueof(requestStructure);
        RestContext.request = req;
        RestContext.response= res;
        string jsonValue = RestContext.request.requestBody.toString();
        SENSAPI_GetMemberDocumentsReqProcessor reqprocessor = new SENSAPI_GetMemberDocumentsReqProcessor();
        IRestResponseWrapper responseWrapper = reqprocessor.process(jsonValue);
        test.stopTest();
    }
    
    static testMethod void PostSendInviteReqProcessorTestInitProcessorException(){
        Id personRecTypeId = Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName().get('Individual').getRecordTypeId();
        Id familyRecTypeId = Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName().get('Family').getRecordTypeId();
        Account famAcc = new Account(Name = 'test', 
                                     Member_Id__c = '711223344',
                                     recordtypeId = familyRecTypeId);
        insert famAcc;

        Account personAcc1 = new Account(FirstName = 'test', 
                                        lastName = 'test', 
                                        Member_ID__c = famAcc.Member_Id__c,
                                        recordtypeId = personRecTypeId);      
        INSERT personAcc1;
        string requestStructure = '{"subscriberId": "' + famAcc.Id + '","memberSensId": "' + personAcc1.Id + '", "count": 4,"offset": 0,"latest": "","oldest": ""}';

        test.startTest();
		RestRequest req = new RestRequest();
        RestResponse res = new RestResponse();
        req.requestBody = Blob.valueof(requestStructure);
        RestContext.request = req;
        RestContext.response= res;
        string jsonValue = RestContext.request.requestBody.toString();
        SENSAPI_GetMemberDocumentsReqProcessor reqprocessor = new SENSAPI_GetMemberDocumentsReqProcessor();
        IRestResponseWrapper responseWrapper = reqprocessor.process(jsonValue);
        test.stopTest();
    }
    
    static testMethod void initProcessorCatchTest(){
        Account personAcc = [SELECT Id FROM Account WHERE Recordtype.Name = 'Individual' LIMIT 1];
        Account famAcc = [SELECT Id,Member_ID__c FROM Account WHERE Recordtype.Name = 'Family' LIMIT 1];
        string requestStructure = '{"subscriberId": "3283","memberSensId": "' + personAcc.Id + '"count": 4,"offset": 0,"latest": "2022-11-17T05:09:06.000Z","oldest": "2022-04-13T09:30:26.000Z"}';

        test.startTest();
		RestRequest req = new RestRequest();
        RestResponse res = new RestResponse();
        req.requestBody = Blob.valueof(requestStructure);
        RestContext.request = req;
        RestContext.response= res;
        string jsonValue = RestContext.request.requestBody.toString();
        SENSAPI_GetMemberDocumentsReqProcessor reqprocessor = new SENSAPI_GetMemberDocumentsReqProcessor();
        IRestResponseWrapper responseWrapper = reqprocessor.process(jsonValue);
        test.stopTest();
    }
}