@IsTest(SeeAllData=true)
public class SENSAPI_PostThreadReqProcessorTest {

@isTest static void testProcessRequestWithDocumentUser() {
        list<id> ids = new list<id>();
        List<Account> lstFamilyAccount = SNI_FL_DirectMessageTestDataFactory.createAccountRecordsTestData('Family',1);
        lstFamilyAccount[0].Ownerid = Userinfo.getuserid();
        update lstFamilyAccount;
        
        Profile p = [SELECT Id FROM Profile WHERE Name='System Administrator']; 
        User u;
    	User fromUser;
        system.runAs(new user(Id = userinfo.getUserId())){
            u = new User(Alias = 'standt', Email='standardusersysAdmin@testorg.com', 
                         EmailEncodingKey='UTF-8', LastName='Testing', LanguageLocaleKey='en_US', 
                         LocaleSidKey='en_US', ProfileId = p.Id, 
                         TimeZoneSidKey='America/Los_Angeles', UserName='standardUserAdminSys#@testorg.com');
            insert u;

            fromUser = new User(Alias = 'standt', Email='fromUser@testorg.com', 
                         EmailEncodingKey='UTF-8', LastName='Testing', LanguageLocaleKey='en_US', 
                         LocaleSidKey='en_US', ProfileId = p.Id, 
                         TimeZoneSidKey='America/Los_Angeles', UserName='fromUser#@testorg.com');
            insert fromUser;
        }
        ids.add(u.id);
        SNI_FL_DirectMessageTestDataFactory.createDirectMessagesTestData(1,ids);
        List<DirectMessageFeed> lstDirectMsgFeed = [SELECT ID FROM DirectMessageFeed WHERE ParentId IN (SELECT ID FROM DirectMessage WHERE Subject LIKE 'DirectMsg_ACDC_Test') LIMIT 1];
        SNI_FL_Message__c message = new SNI_FL_Message__c(Family_ID__c=lstFamilyAccount[0].Id,Feed_Id__c=lstDirectMsgFeed[0].Id,Marked__c=false,Name='test');
        insert message;
        SNI_FL_Message_Status__c mstatusAdv = new SNI_FL_Message_Status__c();
        mstatusAdv.SNI_FL_Message__c = message.id;
        mstatusAdv.agent__c = u.id ;
        mstatusAdv.isRead__c = true;
        insert mstatusAdv;
        
        RestRequest req = new RestRequest(); 
        RestResponse res = new RestResponse();
        string requestStructure = '{"fromUserSensId" : "'+fromUser.id+'", "toUserSensId" :["'+u.Id+'"],"subject": "chat from the post","messageText": "Information","documentId":"","familySensId":"'+lstFamilyAccount[0].id+'"}';
        req.requestBody = Blob.valueof(requestStructure);
        RestContext.request = req;
        RestContext.response= res;
        string jsonValue = RestContext.request.requestBody.toString();
        
        test.startTest();
        SENSAPI_PostThreadReqProcessor reqprocessor = new SENSAPI_PostThreadReqProcessor();
        IRestResponseWrapper responseWrapper = reqprocessor.process(jsonValue);
        test.stopTest();
    }
    
    @isTest static void testProcessRequestWithDocument() {
        list<id> ids = new list<id>();
        List<Account> lstFamilyAccount = SNI_FL_DirectMessageTestDataFactory.createAccountRecordsTestData('Family',1);
        lstFamilyAccount[0].Ownerid = Userinfo.getuserid();
        update lstFamilyAccount;
        
        Profile p = [SELECT Id FROM Profile WHERE Name='System Administrator']; 
        User u;
        system.runAs(new user(Id = userinfo.getUserId())){
            u = new User(Alias = 'standt', Email='standardusersysAdmin@testorg.com', 
                         EmailEncodingKey='UTF-8', LastName='Testing', LanguageLocaleKey='en_US', 
                         LocaleSidKey='en_US', ProfileId = p.Id, 
                         TimeZoneSidKey='America/Los_Angeles', UserName='standardUserAdminSys#@testorg.com');
            insert u;
        }
        ids.add(u.id);
        SNI_FL_DirectMessageTestDataFactory.createDirectMessagesTestData(1,ids);
        List<DirectMessageFeed> lstDirectMsgFeed = [SELECT ID FROM DirectMessageFeed WHERE ParentId IN (SELECT ID FROM DirectMessage WHERE Subject LIKE 'DirectMsg_ACDC_Test') LIMIT 1];
        SNI_FL_Message__c message = new SNI_FL_Message__c(Family_ID__c=lstFamilyAccount[0].Id,Feed_Id__c=lstDirectMsgFeed[0].Id,Marked__c=false,Name='test');
        insert message;
        SNI_FL_Message_Status__c mstatusAdv = new SNI_FL_Message_Status__c();
        mstatusAdv.SNI_FL_Message__c = message.id;
        mstatusAdv.agent__c = lstFamilyAccount[0].Ownerid;
        mstatusAdv.isRead__c = true;
        insert mstatusAdv;
        
        RestRequest req = new RestRequest(); 
        RestResponse res = new RestResponse();
        string requestStructure = '{"fromUserSensId" : "'+u.id+'", "toUserSensId" :["'+lstFamilyAccount[0].Ownerid+'"],"subject": "chat from the post","messageText": "Information","documentId":"","familySensId":"'+lstFamilyAccount[0].id+'"}';
        req.requestBody = Blob.valueof(requestStructure);
        RestContext.request = req;
        RestContext.response= res;
        string jsonValue = RestContext.request.requestBody.toString();
        
        test.startTest();
        SENSAPI_PostThreadReqProcessor reqprocessor = new SENSAPI_PostThreadReqProcessor();
        IRestResponseWrapper responseWrapper = reqprocessor.process(jsonValue);
        test.stopTest();
    }
    
    @isTest static void testProcessRequestWithoutDocument() {
        list<id> ids = new list<id>();
        List<Account> lstFamilyAccount = SNI_FL_DirectMessageTestDataFactory.createAccountRecordsTestData('Family',1);
        lstFamilyAccount[0].Ownerid = Userinfo.getuserid();
        update lstFamilyAccount;
        
        Profile p = [SELECT Id FROM Profile WHERE Name='System Administrator']; 
        User u;
        system.runAs(new user(Id = userinfo.getUserId())){
            u = new User(Alias = 'standt', Email='standardusersysAdmindoc@testorg.com', 
                         EmailEncodingKey='UTF-8', LastName='Testing', LanguageLocaleKey='en_US', 
                         LocaleSidKey='en_US', ProfileId = p.Id, 
                         TimeZoneSidKey='America/Los_Angeles', UserName='standardUserAdminSysdoc#@testorg.com');
            insert u;
        }
        ids.add(u.id);
        SNI_FL_DirectMessageTestDataFactory.createDirectMessagesTestData(1,ids);
        List<DirectMessageFeed> lstDirectMsgFeed = [SELECT ID FROM DirectMessageFeed WHERE ParentId IN (SELECT ID FROM DirectMessage WHERE Subject LIKE 'DirectMsg_ACDC_Test') LIMIT 1];
        SNI_FL_Message__c message = new SNI_FL_Message__c(Family_ID__c=lstFamilyAccount[0].Id,Feed_Id__c=lstDirectMsgFeed[0].Id,Marked__c=false,Name='test');
        insert message;
        SNI_FL_Message_Status__c mstatus = new SNI_FL_Message_Status__c();
        mstatus.SNI_FL_Message__c = message.id;
        mstatus.agent__c= u.id ;
        insert mstatus;
        
        //Create Content Version
        ContentVersion cv = new ContentVersion();
        cv.Title = 'Test Document PratikshyaSat';
        cv.PathOnClient = 'Test Document PratikshyaSat.pdf';
        cv.VersionData = Blob.valueOf('Test Content');
        cv.IsMajorVersion = true;
        Insert cv;
        
        //Get Content Document
        List<ContentVersion> cversion = [SELECT Id, contentdocumentid FROM contentversion where id=:cv.id]; 
        
        RestRequest req = new RestRequest(); 
        RestResponse res = new RestResponse();
        string requestStructure = '{"fromUserSensId" : "'+u.id+'", "toUserSensId" :["'+lstFamilyAccount[0].Ownerid+'"],"subject": "chat from the post","messageText": "Information","documentId":"'+cversion[0].contentdocumentid+'","familySensId":"'+lstFamilyAccount[0].id+'"}';
        req.requestBody = Blob.valueof(requestStructure);
        RestContext.request = req;
        RestContext.response= res;
        string jsonValue = RestContext.request.requestBody.toString();
        
        test.startTest();
        SENSAPI_PostThreadReqProcessor reqprocessor = new SENSAPI_PostThreadReqProcessor();
        IRestResponseWrapper responseWrapper = reqprocessor.process(jsonValue);
        test.stopTest();
    }
    
    @isTest static void testProcessRequestWithRequiredMissing() {
        RestRequest req = new RestRequest(); 
        RestResponse res = new RestResponse();
        string requestStructure = '{"fromUserSensId" : "", "toUserSensId" :[""],"subject": "chat from the post","messageText": "Information","documentId":"","familySensId":""}';
        req.requestBody = Blob.valueof(requestStructure);
        RestContext.request = req;
        RestContext.response= res;
        string jsonValue = RestContext.request.requestBody.toString();
        
        test.startTest();
        SENSAPI_PostThreadReqProcessor reqprocessor = new SENSAPI_PostThreadReqProcessor();
        IRestResponseWrapper responseWrapper = reqprocessor.process(jsonValue);
        test.stopTest();
    }
    
    @isTest static void testProcessRequestWithInvalidUser() {
        List<Account> lstFamilyAccount = SNI_FL_DirectMessageTestDataFactory.createAccountRecordsTestData('Family',1);
        Id personRecTypeId = Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName().get('Individual').getRecordTypeId();
        Account famAcc = new Account(lastName = 'test',
                                     recordtypeId = personRecTypeId);
        insert famAcc;
        List<contact> con = [select id,accountid from contact where accountid=:famAcc.id LIMIT 1];
        Id p = [select id from profile where name='Care Advisor Connect Community User'].id;
        User authorizedByUser = new User(Alias = 'standt', Email='standarduser@testorg.com', 
                                         EmailEncodingKey='UTF-8', LastName='Testing', LanguageLocaleKey='en_US', 
                                         LocaleSidKey='en_US', ProfileId = p,isActive =false,ContactId = con[0].Id,
                                         TimeZoneSidKey='America/Los_Angeles', UserName = 'standarduser3##@testorg.com');
        insert authorizedByUser;
        RestRequest req = new RestRequest(); 
        RestResponse res = new RestResponse();
        string requestStructure = '{"fromUserSensId" : "'+authorizedByUser.id+'", "toUserSensId" :["nmnm"],"subject": "chat from the post","messageText": "Information","documentId":"","familySensId":"'+lstFamilyAccount[0].id+'"}';
        req.requestBody = Blob.valueof(requestStructure);
        RestContext.request = req;
        RestContext.response= res;
        string jsonValue = RestContext.request.requestBody.toString();
        
        test.startTest();
        SENSAPI_PostThreadReqProcessor reqprocessor = new SENSAPI_PostThreadReqProcessor();
        IRestResponseWrapper responseWrapper = reqprocessor.process(jsonValue);
        test.stopTest();
    }
    
    @isTest static void testProcessRequestWithInvalidReqParams() {
        List<Account> lstFamilyAccount = SNI_FL_DirectMessageTestDataFactory.createAccountRecordsTestData('Family',1);
        lstFamilyAccount[0].Ownerid = Userinfo.getuserid();
        update lstFamilyAccount;
        RestRequest req = new RestRequest(); 
        RestResponse res = new RestResponse();
        string requestStructure = '{"fromUserSensId" : "'+lstFamilyAccount[0].Ownerid+'", "toUserSensId" :"'+lstFamilyAccount[0].Ownerid+'","subject": "chat from the post","messageText": "Information","documentId":"","familySensId":"'+lstFamilyAccount[0].Ownerid+'"}';
        req.requestBody = Blob.valueof(requestStructure);
        RestContext.request = req;
        RestContext.response= res;
        string jsonValue = RestContext.request.requestBody.toString();
        
        test.startTest();
        SENSAPI_PostThreadReqProcessor reqprocessor = new SENSAPI_PostThreadReqProcessor();
        IRestResponseWrapper responseWrapper = reqprocessor.process(jsonValue);
        test.stopTest();
    }
    
    @isTest static void testProcessRequestWithInvalidSubsId() {
        Profile p = [SELECT Id FROM Profile WHERE Name='System Administrator']; 
        User u;
        system.runAs(new user(Id = userinfo.getUserId())){
            u = new User(Alias = 'standt', Email='standardusersysAdmin@testorg.com', 
                         EmailEncodingKey='UTF-8', LastName='Testing', LanguageLocaleKey='en_US', 
                         LocaleSidKey='en_US', ProfileId = p.Id, 
                         TimeZoneSidKey='America/Los_Angeles', UserName='standardUserAdminSys#@testorg.com');
            insert u;
        }
        List<Account> lstFamilyAccount = SNI_FL_DirectMessageTestDataFactory.createAccountRecordsTestData('Family',1);
        lstFamilyAccount[0].Ownerid = Userinfo.getuserid();
        update lstFamilyAccount;
        RestRequest req = new RestRequest(); 
        RestResponse res = new RestResponse(); 
        string requestStructure = '{"fromUserSensId" : "'+u.id+'", "toUserSensId" :["'+lstFamilyAccount[0].Ownerid+'"],"subject": "chat from the post","messageText": "Information","documentId":"","familySensId":"'+lstFamilyAccount[0].member_id__C+'"}';
        req.requestBody = Blob.valueof(requestStructure);
        RestContext.request = req;
        RestContext.response= res;
        string jsonValue = RestContext.request.requestBody.toString();
        
        test.startTest();
        SENSAPI_PostThreadReqProcessor reqprocessor = new SENSAPI_PostThreadReqProcessor();
        IRestResponseWrapper responseWrapper = reqprocessor.process(jsonValue);
        test.stopTest();
    }
    
    @isTest static void testProcessRequestWithBlankDoc() {
        Profile p = [SELECT Id FROM Profile WHERE Name='System Administrator']; 
        User u;
        system.runAs(new user(Id = userinfo.getUserId())){
            u = new User(Alias = 'standt', Email='standardusersysAdmin@testorg.com', 
                         EmailEncodingKey='UTF-8', LastName='Testing', LanguageLocaleKey='en_US', 
                         LocaleSidKey='en_US', ProfileId = p.Id, 
                         TimeZoneSidKey='America/Los_Angeles', UserName='standardUserAdminSys#@testorg.com');
            insert u;
        }
        List<Account> lstFamilyAccount = SNI_FL_DirectMessageTestDataFactory.createAccountRecordsTestData('Family',1);
        lstFamilyAccount[0].Ownerid = Userinfo.getuserid();
        update lstFamilyAccount;
        RestRequest req = new RestRequest(); 
        RestResponse res = new RestResponse(); 
        string requestStructure = '{"fromUserSensId" : "'+u.id+'", "toUserSensId" :["'+lstFamilyAccount[0].Ownerid+'"],"subject": "chat from the post","messageText": "","documentId":"","familySensId":"'+lstFamilyAccount[0].Id+'"}';
        req.requestBody = Blob.valueof(requestStructure);
        RestContext.request = req;
        RestContext.response= res;
        string jsonValue = RestContext.request.requestBody.toString();
        
        test.startTest();
        SENSAPI_PostThreadReqProcessor reqprocessor = new SENSAPI_PostThreadReqProcessor();
        IRestResponseWrapper responseWrapper = reqprocessor.process(jsonValue);
        test.stopTest();
    }
    
    @isTest static void testProcessRequestWithBlankForAndToUsers() {
        Profile p = [SELECT Id FROM Profile WHERE Name='System Administrator']; 
        User u;
        system.runAs(new user(Id = userinfo.getUserId())){
            u = new User(Alias = 'standt', Email='standardusersysAdmin@testorg.com', 
                         EmailEncodingKey='UTF-8', LastName='Testing', LanguageLocaleKey='en_US', 
                         LocaleSidKey='en_US', ProfileId = p.Id, 
                         TimeZoneSidKey='America/Los_Angeles', UserName='standardUserAdminSys#@testorg.com');
            insert u;
        }
        //Create Content Version
        ContentVersion cv = new ContentVersion();
        cv.Title = 'Test Document PratikshyaSat';
        cv.PathOnClient = 'Test Document PratikshyaSat.pdf';
        cv.VersionData = Blob.valueOf('Test Content');
        cv.IsMajorVersion = true;
        Insert cv;
        
        //Get Content Document
        List<ContentVersion> cversion = [SELECT Id, contentdocumentid FROM contentversion where id=:cv.id];
        
        List<Account> lstFamilyAccount = SNI_FL_DirectMessageTestDataFactory.createAccountRecordsTestData('Family',1);
        lstFamilyAccount[0].Ownerid = Userinfo.getuserid();
        update lstFamilyAccount;
        RestRequest req = new RestRequest(); 
        RestResponse res = new RestResponse();
        string requestStructure = '{"fromUserSensId" : "'+u.id+'", "toUserSensId" :[],"subject": "chat from the post","messageText": "Information","documentId":"'+cversion[0].contentdocumentid+'","familySensId":""}';
        req.requestBody = Blob.valueof(requestStructure);
        RestContext.request = req;
        RestContext.response= res;
        string jsonValue = RestContext.request.requestBody.toString();
        
        test.startTest();
        SENSAPI_PostThreadReqProcessor reqprocessor = new SENSAPI_PostThreadReqProcessor();
        IRestResponseWrapper responseWrapper = reqprocessor.process(jsonValue);
        test.stopTest();
    }
    
}