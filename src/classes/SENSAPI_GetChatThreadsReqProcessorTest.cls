/*------------------------------------------------------------
Author:        Tushar Kaore
Description:   Test class for SENSAPI_GetChatThreadsReqProcessor  

Test Class:   SENSAPI_GetChatThreadsReqProcessorTest
History
Date            Author              Comments
-------------------------------------------------------------
11-11-2022      Tushar Kaore      		Created
------------------------------------------------------------*/
@isTest(SeeAllData=true)
// reason for using SeeAllData=true - https://ideas.salesforce.com/s/idea/a0B8W00000GdZzDUAV/fix-connectapi-methods-are-not-supported-in-data-siloed-tests
private class SENSAPI_GetChatThreadsReqProcessorTest {
   
    /**
     * Testing success scearnio with existing subscriber id
     */ 
    @isTest private static void processRequestSuccess(){
        
        list<id> ids = new list<id>();
        List<Account> lstFamilyAccount = SNI_FL_DirectMessageTestDataFactory.createAccountRecordsTestData('Family',1);
        lstFamilyAccount[0].Ownerid = Userinfo.getuserid();
        update lstFamilyAccount;
        
        Profile p = [SELECT Id FROM Profile WHERE Name='System Administrator']; 
        User u;
        system.runAs(new user(Id = userinfo.getUserId())){
            string randomNumber = string.valueOf(Math.round((Math.random() * (900000) + 100000)));
            u = new User(Alias = 'standt', Email='standarduser@testorg.com' + randomNumber, 
                         EmailEncodingKey='UTF-8', LastName='Testing', LanguageLocaleKey='en_US', 
                         LocaleSidKey='en_US', ProfileId = p.Id, 
                         TimeZoneSidKey='America/Los_Angeles', UserName='standarduser@testorg.com' + randomNumber);
            insert u;
        }
        ids.add(u.id);
        SNI_FL_DirectMessageTestDataFactory.createDirectMessagesTestData(1,ids);
        List<DirectMessageFeed> lstDirectMsgFeed = [SELECT ID FROM DirectMessageFeed WHERE ParentId IN (SELECT ID FROM DirectMessage WHERE Subject LIKE 'DirectMsg_ACDC_Test') LIMIT 1];
       	FeedComment fc = new FeedComment(FeedItemId = lstDirectMsgFeed[0].Id, CommentBody = 'Test Comment');
        insert fc;
        SNI_FL_Message__c message = new SNI_FL_Message__c(Family_ID__c=lstFamilyAccount[0].Id,Feed_Id__c=lstDirectMsgFeed[0].Id,Marked__c=false,Name='test');
        insert message;
        SNI_FL_Message_Status__c mstatus = new SNI_FL_Message_Status__c();
        mstatus.SNI_FL_Message__c = message.id;
        mstatus.agent__c= u.id ;
        insert mstatus;
        
        RestContext.request = new RestRequest(); 
        RestContext.response= new RestResponse();
        
        SENSAPI_GetChatThreadsRequest request = new SENSAPI_GetChatThreadsRequest();
        request.userSensId = u.Id;
        request.count = 10;
        request.offset = 0;
            
        
        SENSAPI_GetChatThreadsReqProcessor processor = new SENSAPI_GetChatThreadsReqProcessor();
        processor.process(JSON.serialize(request));
        
        system.assert(RestContext.response.statusCode  == 200, 'Error processing request');
    }
    
    
    /**
     * Testing error scearnio bad request
     */ 
    @isTest private static void testingWithBadRequest(){
        
        RestContext.request = new RestRequest(); 
        RestContext.response= new RestResponse();
        
        SENSAPI_GetChatThreadsRequest request = new SENSAPI_GetChatThreadsRequest();
        request.userSensId = null;
        request.count = -1;
        request.offset = -1;
            
        
        SENSAPI_GetChatThreadsReqProcessor processor = new SENSAPI_GetChatThreadsReqProcessor();
        processor.process(JSON.serialize(request));
        
        system.assert(RestContext.response.statusCode  == 400, 'Error validating request');
    }
    
    /**
     * Testing error scearnio bad request for pagination attributes
     */ 
    @isTest private static void testingWithBadPaginationRequest(){
        
        RestContext.request = new RestRequest(); 
        RestContext.response= new RestResponse();
        
        SENSAPI_GetChatThreadsRequest request = new SENSAPI_GetChatThreadsRequest();
        //only passing count but not offset value
        request.count = 1;
        
        SENSAPI_GetChatThreadsReqProcessor processor = new SENSAPI_GetChatThreadsReqProcessor();
        processor.process(JSON.serialize(request));
        
        system.assert(RestContext.response.statusCode  == 400, 'Error validating request');
    }
    
    /**
     * Testing error scearnio invalid JSON
     */ 
    @isTest private static void testingWithInvalidJSON(){
        
        RestContext.request = new RestRequest(); 
        RestContext.response= new RestResponse();
        
        
        SENSAPI_GetChatThreadsReqProcessor processor = new SENSAPI_GetChatThreadsReqProcessor();
        processor.process('Invalid JSON');
        
        system.assert(RestContext.response.statusCode  == 500, 'Error exception handling');
    }
    
    /**
     * Testing user with no threads
     */
    @isTest private static void userWithoutThreads(){
        
        list<id> ids = new list<id>();
        List<Account> lstFamilyAccount = SNI_FL_DirectMessageTestDataFactory.createAccountRecordsTestData('Family',1);
        lstFamilyAccount[0].Ownerid = Userinfo.getuserid();
        update lstFamilyAccount;
        
        Profile p = [SELECT Id FROM Profile WHERE Name='System Administrator']; 
        User u;
        system.runAs(new user(Id = userinfo.getUserId())){
            string randomNumber = string.valueOf(Math.round((Math.random() * (900000) + 100000)));
            
            u = new User(Alias = 'standt', Email='standarduser@testorg.com' + randomNumber, 
                         EmailEncodingKey='UTF-8', LastName='Testing', LanguageLocaleKey='en_US', 
                         LocaleSidKey='en_US', ProfileId = p.Id, 
                         TimeZoneSidKey='America/Los_Angeles', UserName='standarduser@testorg.com' + randomNumber);
            insert u;
        }
        ids.add(u.id);
        
        RestContext.request = new RestRequest(); 
        RestContext.response= new RestResponse();
        
        SENSAPI_GetChatThreadsRequest request = new SENSAPI_GetChatThreadsRequest();
        request.userSensId = u.Id;
        request.count = 10;
        request.offset = 0;
            
        
        SENSAPI_GetChatThreadsReqProcessor processor = new SENSAPI_GetChatThreadsReqProcessor();
        processor.process(JSON.serialize(request));
        
        system.assert(RestContext.response.statusCode  == 200, 'Error processing request for now user threads');
    }
    
    /**
     * Testing with inactive user
     */ 
    @isTest private static void testWithInactiveUser(){
        
        list<id> ids = new list<id>();
        List<Account> lstFamilyAccount = SNI_FL_DirectMessageTestDataFactory.createAccountRecordsTestData('Family',1);
        lstFamilyAccount[0].Ownerid = Userinfo.getuserid();
        update lstFamilyAccount;
        
        Profile p = [SELECT Id FROM Profile WHERE Name='System Administrator']; 
        User u;
        system.runAs(new user(Id = userinfo.getUserId())){
            string randomNumber = string.valueOf(Math.round((Math.random() * (900000) + 100000)));
            u = new User(Alias = 'standt', Email='standarduser@testorg.com' + randomNumber, 
                         EmailEncodingKey='UTF-8', LastName='Testing', LanguageLocaleKey='en_US', 
                         LocaleSidKey='en_US', ProfileId = p.Id, 
                         TimeZoneSidKey='America/Los_Angeles', UserName='standarduser@testorg.com' + randomNumber, 
						 IsActive= false);
            insert u;
        }
        ids.add(u.id);
        
        RestContext.request = new RestRequest(); 
        RestContext.response= new RestResponse();
        
        SENSAPI_GetChatThreadsRequest request = new SENSAPI_GetChatThreadsRequest();
        request.userSensId = u.Id;
        request.count = 10;
        request.offset = 0;
            
        
        SENSAPI_GetChatThreadsReqProcessor processor = new SENSAPI_GetChatThreadsReqProcessor();
        processor.process(JSON.serialize(request));
        
        system.assert(RestContext.response.statusCode  == 400, 'Inactive User validation failed');
    }
    
    
    /**
     * Testing getPaginatedDetails method with negative scenario parameter
     */ 
    @isTest private static void testGetPaginatedDetails(){
        SENSAPI_GetChatThreadsReqProcessor processor = new SENSAPI_GetChatThreadsReqProcessor();
        List<SENSAPI_GetChatThreadsResponse.Threads> threads = processor.getPaginatedDetails(null);
        system.assert(threads  == null, 'Error handling failed in getPaginatedDetails method');
    }
    
}