/*------------------------------------------------------------
Description:   Test class for SENSAPI_PostMarkThreadAsReadReqProcessor  

History
Date            Author                Comments
-------------------------------------------------------------
09-11-2022      Harshini Thotakura    Created
------------------------------------------------------------*/
@isTest(SeeAllData=true)
public class SENSAPI_PostMarkThreadAsReadReqProcTest {
    

     static testMethod void markThreadAsReadRequestPositive() {
      
        list<id> ids = new list<id>();
        
        List<Account> lstFamilyAccount = SNI_FL_DirectMessageTestDataFactory.createAccountRecordsTestData('Family',1);
        lstFamilyAccount[0].Ownerid = Userinfo.getuserid();
        update lstFamilyAccount;
        
        Profile p = [SELECT Id FROM Profile WHERE Name='System Administrator']; 
        User u;
         system.runAs(new user(Id = userinfo.getUserId())){
             String randomNumber = String.valueOf(Math.round((Math.random() * (900000) + 100000)));
             u = new User(Alias = 'standt', Email='standarduser@testorg.com' + randomNumber, 
                          EmailEncodingKey='UTF-8', LastName='Testing', LanguageLocaleKey='en_US', 
                          LocaleSidKey='en_US', ProfileId = p.Id, 
                          TimeZoneSidKey='America/Los_Angeles', UserName='standarduser@testorg.com' + randomNumber);
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
         
        RestRequest req = new RestRequest(); 
        RestResponse res = new RestResponse();
         
        string requestStructure = '{"sensUserId": "' + u.Id + '","threadId": "' + lstDirectMsgFeed[0].Id + '", "isRead": true}';
        req.requestBody = Blob.valueof(requestStructure);
        RestContext.request = req;
        RestContext.response= res;
        string jsonValue = RestContext.request.requestBody.toString();
        test.startTest();
        SENSAPI_PostMarkThreadAsReadReqProcessor reqprocessor = new SENSAPI_PostMarkThreadAsReadReqProcessor();
        IRestResponseWrapper responseWrapper = reqprocessor.process(jsonValue);
        test.stopTest();
        //System.assertEquals(true, mstatus.IsRead__c);
    }
    
    static testMethod void reqDetailsMissingTest(){
        RestRequest req = new RestRequest(); 
        RestResponse res = new RestResponse();
        string requestStructure = '{"sensUserId": "","threadId": "", "isRead": true}';
        req.requestBody = Blob.valueof(requestStructure);
        RestContext.request = req;
        RestContext.response= res;
        string jsonValue = RestContext.request.requestBody.toString();
        test.startTest();
        SENSAPI_PostMarkThreadAsReadReqProcessor reqprocessor = new SENSAPI_PostMarkThreadAsReadReqProcessor();
        IRestResponseWrapper responseWrapper = reqprocessor.process(jsonValue);
        test.stopTest();
        System.assert(string.valueOf(responseWrapper).contains(SENSAPI_Constant.REQUIREDFIELD_MISSING));
    }
    
    static testMethod void userNotFoundTest(){
        RestRequest req = new RestRequest(); 
        RestResponse res = new RestResponse();
        string requestStructure = '{"sensUserId": "00576000001AHZMAB5","threadId": "0D57600000UWoVuCAL", "isRead": true}';
        req.requestBody = Blob.valueof(requestStructure);
        RestContext.request = req;
        RestContext.response= res;
        string jsonValue = RestContext.request.requestBody.toString();
        test.startTest();
        SENSAPI_PostMarkThreadAsReadReqProcessor reqprocessor = new SENSAPI_PostMarkThreadAsReadReqProcessor();
        IRestResponseWrapper responseWrapper = reqprocessor.process(jsonValue);
        test.stopTest();
        System.assert(string.valueOf(responseWrapper).contains(SENSAPI_Constant.USER_INACTIVE));
    }
    
   static testMethod void messageThreadNotValidTest(){
        Profile p = [SELECT Id FROM Profile WHERE Name='System Administrator']; 
        User u;
       system.runAs(new user(Id = userinfo.getUserId())){
           String randomNumber = String.valueOf(Math.round((Math.random() * (900000) + 100000)));
           u = new User(Alias = 'standt', Email='standarduser@testorg.com' + randomNumber,  
                        EmailEncodingKey='UTF-8', LastName='Testing', LanguageLocaleKey='en_US', 
                        LocaleSidKey='en_US', ProfileId = p.Id, 
                        TimeZoneSidKey='America/Los_Angeles', UserName='standarduser@testorg.com' + randomNumber);
       }
        insert u;
        RestRequest req = new RestRequest(); 
        RestResponse res = new RestResponse();
        string requestStructure = '{"sensUserId": "'+u.id+'","threadId": "0D57600000VXpWvDBM", "isRead": true}';
        req.requestBody = Blob.valueof(requestStructure);
        RestContext.request = req;
        RestContext.response= res;
        string jsonValue = RestContext.request.requestBody.toString();
        test.startTest();
        SENSAPI_PostMarkThreadAsReadReqProcessor reqprocessor = new SENSAPI_PostMarkThreadAsReadReqProcessor();
        IRestResponseWrapper responseWrapper = reqprocessor.process(jsonValue);
        test.stopTest();
        System.assert(string.valueOf(responseWrapper).contains(SENSAPI_Constant.INVALID_THREADID));
    }
    
    static testMethod void statusRecordNotFoundTest(){        
        list<id> ids = new list<id>();
        
        List<Account> lstFamilyAccount = SNI_FL_DirectMessageTestDataFactory.createAccountRecordsTestData('Family',1);
        lstFamilyAccount[0].Ownerid = Userinfo.getuserid();
        update lstFamilyAccount;
        
        Profile p = [SELECT Id FROM Profile WHERE Name='System Administrator']; 
        User u1,u2;
        system.runAs(new user(Id = userinfo.getUserId())){
        u1 = new User(Alias = 'standt', Email='standarduser@testorg.com', 
            EmailEncodingKey='UTF-8', LastName='Testing', LanguageLocaleKey='en_US', 
            LocaleSidKey='en_US', ProfileId = p.Id, 
            TimeZoneSidKey='America/Los_Angeles', UserName='standarduser78##@testorg.com');
        insert u1;
        }
        
        system.runAs(new user(Id = userinfo.getUserId())){
            String randomNumber = String.valueOf(Math.round((Math.random() * (900000) + 100000)));
            u2 = new User(Alias = 'standt', Email='standarduser@testorg.com' + randomNumber, 
                          EmailEncodingKey='UTF-8', LastName='Testing', LanguageLocaleKey='en_US', 
                          LocaleSidKey='en_US', ProfileId = p.Id, 
                          TimeZoneSidKey='America/Los_Angeles', UserName='standarduser@testorg.com' + randomNumber);
            insert u2;
        }
        ids.add(u2.id);
        SNI_FL_DirectMessageTestDataFactory.createDirectMessagesTestData(1,ids);
        List<DirectMessageFeed> lstDirectMsgFeed = [SELECT ID FROM DirectMessageFeed WHERE ParentId IN (SELECT ID FROM DirectMessage WHERE Subject LIKE 'DirectMsg_ACDC_Test') LIMIT 1];
        SNI_FL_Message__c message = new SNI_FL_Message__c(Family_ID__c=lstFamilyAccount[0].Id,Feed_Id__c=lstDirectMsgFeed[0].Id,Marked__c=false,Name='test');
        insert message;
        SNI_FL_Message_Status__c mstatus = new SNI_FL_Message_Status__c();
        mstatus.SNI_FL_Message__c = message.id;
        mstatus.agent__c= u2.id ;
        insert mstatus;
        
        RestRequest req = new RestRequest(); 
        RestResponse res = new RestResponse();
        string requestStructure = '{"sensUserId": "'+u1.id+'","threadId": "' + lstDirectMsgFeed[0].Id + '", "isRead": true}';
        req.requestBody = Blob.valueof(requestStructure);
        RestContext.request = req;
        RestContext.response= res;
        string jsonValue = RestContext.request.requestBody.toString();
        test.startTest();
        SENSAPI_PostMarkThreadAsReadReqProcessor reqprocessor = new SENSAPI_PostMarkThreadAsReadReqProcessor();
        IRestResponseWrapper responseWrapper = reqprocessor.process(jsonValue);
        test.stopTest();
        System.assert(string.valueOf(responseWrapper).contains(SENSAPI_Constant.NO_STATUS_RECORD));
    }
   
    static testMethod void RequestWithCatchBlock(){
        List<Account> lstFamilyAccount = SNI_FL_DirectMessageTestDataFactory.createAccountRecordsTestData('Family',1);
        RestRequest req = new RestRequest(); 
        RestResponse res = new RestResponse();
        string requestStructure = '{"subscriberId": }';
        req.requestBody = Blob.valueof(requestStructure);
        RestContext.request = req;
        RestContext.response= res;
        string jsonValue = RestContext.request.requestBody.toString();
        test.startTest();
        SENSAPI_PostMarkThreadAsReadReqProcessor reqprocessor = new SENSAPI_PostMarkThreadAsReadReqProcessor();
        IRestResponseWrapper responseWrapper = reqprocessor.process(jsonValue);
        test.stopTest();
    }
    
}