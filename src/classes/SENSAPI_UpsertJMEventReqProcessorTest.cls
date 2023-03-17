/*------------------------------------------------------------
Description:   Test class for SENSAPI_UpsertJMEventRequestProcessor  

History
Date            Author              Comments
-------------------------------------------------------------
21-NOV-2022     Geeta Koli      	Created
------------------------------------------------------------*/
@isTest
public class SENSAPI_UpsertJMEventReqProcessorTest {

     @testSetup static void dataSetup() {
        List<Account> memberLst = new List<Account>();
        Id personRecTypeId = Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName().get('Individual').getRecordTypeId();
        Id familyRecTypeId = Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName().get('Family').getRecordTypeId();
        Account famAcc = new Account(Name = 'test', 
                                     Member_Id__c = '00011223344',
                                     recordtypeId = familyRecTypeId);
        insert famAcc;

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
         insert ctmMember;
         
        Id conId = [select PersonContactId FROM account where ID =: personAcc.Id LIMIT 1].PersonContactId;
        
        AccountContactRelation acr = new AccountContactRelation(contactId = conId, AccountId = famAcc.Id);
        INSERT acr;
        
        User commUsr;
        Id profId = [SELECT ID FROM Profile WHERE NAME = 'Care Advisor Connect Community User' LIMIT 1].Id;
        system.runAs(new user(Id = userinfo.getUserId())){
                commUsr= new User(
                alias = 'test123', email='test123@noemail.com',
                emailencodingkey='UTF-8', lastname='Testing', languagelocalekey='en_US',
                localesidkey='en_US', profileid = profId, country='United States',IsActive =true,
                ContactId = conId,
                timezonesidkey='America/Los_Angeles', username='tester83@noemail.com');
            INSERT commUsr;
        }
     }
    
    static testMethod void upsertActivityTestAssignmentType(){
        Account personAcc = [SELECT Id FROM Account WHERE Recordtype.Name = 'Individual' LIMIT 1];
        Account famAcc = [SELECT Id,Member_ID__c FROM Account WHERE Recordtype.Name = 'Family' LIMIT 1];
        SNI_FL_Care_Team_Member__c careTeamMember1 = [select id,SNI_FL_Member__c,SNI_FL_Family__c,SNI_FL_Family__r.Member_ID__c from SNI_FL_Care_Team_Member__c limit 1];
        Member_Activity__c act = new Member_Activity__c(Care_Plan_Id__c ='careplan123',Family__c=famAcc.Id,Member__c=personAcc.Id);
        insert act;
        User commUsr = [select id from User limit 1];
        RestRequest req = new RestRequest(); 
        RestResponse res = new RestResponse();
        string requestStructure = '{"id": "id","version": "v1","type": "assignment","data":{"activityTitle": "go for a run","subscriberId" : "' + famAcc.Member_ID__c + '","memberSensId" : "'+ personAcc.Id + '","carePlanId" : "' + act.Care_Plan_Id__c + '","taskId" : "task6381", "careAdvisorId" : "","createdAt":"2022-07-14T13:00:01.098Z"}}';
        req.requestBody = Blob.valueof(requestStructure);
        RestContext.request = req;
        RestContext.response= res;
        string jsonValue = RestContext.request.requestBody.toString();
        test.startTest();
        SENSAPI_UpsertJMEventRequestProcessor reqprocessor = new SENSAPI_UpsertJMEventRequestProcessor();
        IRestResponseWrapper responseWrapper = reqprocessor.process(jsonValue);
        test.stopTest();
    }

    static testMethod void upsertActivityTestActivityUpdateType(){
        Account personAcc = [SELECT Id FROM Account WHERE Recordtype.Name = 'Individual' LIMIT 1];
        Account famAcc = [SELECT Id,Member_ID__c FROM Account WHERE Recordtype.Name = 'Family' LIMIT 1];
        User commUsr = [select id from User limit 1];
        RestRequest req = new RestRequest(); 
        RestResponse res = new RestResponse();
        string requestStructure = '{"id": "id","version": "v1","type": "activityUpdate","data":{"activityTitle": "go for a run","subscriberId" : "' + famAcc.Member_ID__c + '","memberSensId" : "'+ personAcc.Id + '","carePlanId" : "ad2235","taskId" : "task3719","careAdvisorId" : "' + commUsr.Id + '","lastModifiedAt":"2022-07-14T13:00:01.098Z","status":"removed"}}';
        req.requestBody = Blob.valueof(requestStructure);
        RestContext.request = req;
        RestContext.response= res;
        string jsonValue = RestContext.request.requestBody.toString();
        test.startTest();
        SENSAPI_UpsertJMEventRequestProcessor reqprocessor = new SENSAPI_UpsertJMEventRequestProcessor();
        IRestResponseWrapper responseWrapper = reqprocessor.process(jsonValue);
        test.stopTest();
    }
    
    static testMethod void upsertActivityTestActivityUpdateTypeExpired(){
        Account personAcc = [SELECT Id FROM Account WHERE Recordtype.Name = 'Individual' LIMIT 1];
        Account famAcc = [SELECT Id,Member_ID__c FROM Account WHERE Recordtype.Name = 'Family' LIMIT 1];
        User commUsr = [select id from User limit 1];
        RestRequest req = new RestRequest(); 
        RestResponse res = new RestResponse();
        string requestStructure = '{"id": "id","version": "v1","type": "activityUpdate","data":{"activityTitle": "go for a run","subscriberId" : "' + famAcc.Member_ID__c + '","memberSensId" : "'+ personAcc.Id + '","carePlanId" : "ad2235","taskId" : "task285","careAdvisorId" : "' + commUsr.Id + '","lastModifiedAt":"2022-07-14T13:00:01.098Z","status":"expired"}}';
        req.requestBody = Blob.valueof(requestStructure);
        RestContext.request = req;
        RestContext.response= res;
        string jsonValue = RestContext.request.requestBody.toString();
        test.startTest();
        SENSAPI_UpsertJMEventRequestProcessor reqprocessor = new SENSAPI_UpsertJMEventRequestProcessor();
        IRestResponseWrapper responseWrapper = reqprocessor.process(jsonValue);
        test.stopTest();
    }
    
    static testMethod void upsertActivityTestActivityUpdateTypeCompletedStatus(){
        Account personAcc = [SELECT Id FROM Account WHERE Recordtype.Name = 'Individual' LIMIT 1];
        Account famAcc = [SELECT Id,Member_ID__c FROM Account WHERE Recordtype.Name = 'Family' LIMIT 1];
        //Member_Activity__c act = new Member_Activity__c(Care_Plan_Id__c ='careplan123',Family__c=famAcc.Id,Member__c=personAcc.Id,Status__c='completed');
        //insert act;
        User commUsr = [select id from User limit 1];
        RestRequest req = new RestRequest(); 
        RestResponse res = new RestResponse();
        string requestStructure = '{"id": "id","version": "v1","type": "activityUpdate","data":{"activityTitle": "go for a run","subscriberId" : "' + famAcc.Member_ID__c + '","memberSensId" : "'+ personAcc.Id + '","carePlanId" : "ad2235","taskId" : "task3719","careAdvisorId" : "' + commUsr.Id + '","lastModifiedAt":"2022-07-14T13:00:01.098Z","status":"completed"}}';
        req.requestBody = Blob.valueof(requestStructure);
        RestContext.request = req;
        RestContext.response= res;
        string jsonValue = RestContext.request.requestBody.toString();
        test.startTest();
        SENSAPI_UpsertJMEventRequestProcessor reqprocessor = new SENSAPI_UpsertJMEventRequestProcessor();
        IRestResponseWrapper responseWrapper = reqprocessor.process(jsonValue);
        test.stopTest();
    }
    
    static testMethod void upsertActivityTestActivityUpdateTypeNewAssigned(){
        Account personAcc = [SELECT Id FROM Account WHERE Recordtype.Name = 'Individual' LIMIT 1];
        Account famAcc = [SELECT Id,Member_ID__c FROM Account WHERE Recordtype.Name = 'Family' LIMIT 1];
        Member_Activity__c act = new Member_Activity__c(Care_Plan_Id__c ='careplan123',Family__c=famAcc.Id,Member__c=personAcc.Id,Status__c='completed');
        insert act;
        User commUsr = [select id from User limit 1];
        RestRequest req = new RestRequest(); 
        RestResponse res = new RestResponse();
        string requestStructure = '{"id": "id","version": "v1","type": "activityUpdate","data":{"activityTitle": "go for a run","subscriberId" : "' + famAcc.Member_ID__c + '","memberSensId" : "'+ personAcc.Id + '","carePlanId" : "' + act.Care_Plan_Id__c + '","taskId" : "task285","careAdvisorId" : "' + commUsr.Id + '","lastModifiedAt":"2022-07-14T13:00:01.098Z","status":"assigned"}}';
        req.requestBody = Blob.valueof(requestStructure);
        RestContext.request = req;
        RestContext.response= res;
        string jsonValue = RestContext.request.requestBody.toString();
        test.startTest();
        SENSAPI_UpsertJMEventRequestProcessor reqprocessor = new SENSAPI_UpsertJMEventRequestProcessor();
        IRestResponseWrapper responseWrapper = reqprocessor.process(jsonValue);
        test.stopTest();
    }
    
    static testMethod void upsertActivityTestActivityUpdateTypeCompletedToRemoved(){
        Account personAcc = [SELECT Id FROM Account WHERE Recordtype.Name = 'Individual' LIMIT 1];
        Account famAcc = [SELECT Id,Member_ID__c FROM Account WHERE Recordtype.Name = 'Family' LIMIT 1];
        Member_Activity__c act = new Member_Activity__c(Care_Plan_Id__c ='careplan123',Family__c=famAcc.Id,Member__c=personAcc.Id,Status__c='completed');
        insert act;
        User commUsr = [select id from User limit 1];
        RestRequest req = new RestRequest(); 
        RestResponse res = new RestResponse();
        string requestStructure = '{"id": "id","version": "v1","type": "activityUpdate","data":{"activityTitle": "go for a run","subscriberId" : "' + famAcc.Member_ID__c + '","memberSensId" : "'+ personAcc.Id + '","carePlanId" : "' + act.Care_Plan_Id__c + '","taskId" : "task285","careAdvisorId" : "' + commUsr.Id + '","lastModifiedAt":"2022-07-14T13:00:01.098Z","status":"removed"}}';
        req.requestBody = Blob.valueof(requestStructure);
        RestContext.request = req;
        RestContext.response= res;
        string jsonValue = RestContext.request.requestBody.toString();
        test.startTest();
        SENSAPI_UpsertJMEventRequestProcessor reqprocessor = new SENSAPI_UpsertJMEventRequestProcessor();
        IRestResponseWrapper responseWrapper = reqprocessor.process(jsonValue);
        test.stopTest();
    }
    
    static testMethod void upsertActivityTestActivityUpdateTypeExpiredStatus(){
        Account personAcc = [SELECT Id FROM Account WHERE Recordtype.Name = 'Individual' LIMIT 1];
        Account famAcc = [SELECT Id,Member_ID__c FROM Account WHERE Recordtype.Name = 'Family' LIMIT 1];
        User commUsr = [select id from User limit 1];
        RestRequest req = new RestRequest(); 
        RestResponse res = new RestResponse();
        string requestStructure = '{"id": "id68","version": "v1","type": "activityUpdate","data":{"subscriberId" : " ' + famAcc.Member_ID__c + '","memberSensId" : "'+ personAcc.Id + '","careplanId" : "ad2235","taskId" : "32342akljd","lastModifiedAt": "2022-07-15T13:00:01.098Z","careAdvisorId" : "' + commUsr.Id + '","status" : "expired"}}';
        req.requestBody = Blob.valueof(requestStructure);
        RestContext.request = req;
        RestContext.response= res;
        string jsonValue = RestContext.request.requestBody.toString();
        test.startTest();
        SENSAPI_UpsertJMEventRequestProcessor reqprocessor = new SENSAPI_UpsertJMEventRequestProcessor();
        IRestResponseWrapper responseWrapper = reqprocessor.process(jsonValue);
        test.stopTest();
    }
    
    static testMethod void upsertActivityTestRequiredFieldsMissingException(){
        Account famAcc = [SELECT Id,Member_ID__c FROM Account WHERE Recordtype.Name = 'Family' LIMIT 1];
      	User commUsr = [select id from User limit 1];
        RestRequest req = new RestRequest(); 
        RestResponse res = new RestResponse();
        string requestStructure = '{"id": "id","version": "v1","type": "assignment","data":{"activityTitle": "go for a run","subscriberId" : "' + famAcc.Member_ID__c + '","carePlanId" : "ad2235","taskId" : "task6381", "careAdvisorId" : "' + commUsr.Id + '","createdAt":"2022-07-14T13:00:01.098Z"}}';
        req.requestBody = Blob.valueof(requestStructure);
        RestContext.request = req;
        RestContext.response= res;
        string jsonValue = RestContext.request.requestBody.toString();
        test.startTest();
        SENSAPI_UpsertJMEventRequestProcessor reqprocessor = new SENSAPI_UpsertJMEventRequestProcessor();
        IRestResponseWrapper responseWrapper = reqprocessor.process(jsonValue);
        test.stopTest();
    }
    
    static testMethod void upsertActivityTestInvalidUserDetailsException(){
        Id personRecTypeId = Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName().get('Individual').getRecordTypeId();
        Id familyRecTypeId = Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName().get('Family').getRecordTypeId();
        Account famAcc1 = new Account(Name = 'test11', 
                                     Member_Id__c = '5372196',
                                     recordtypeId = familyRecTypeId);
        insert famAcc1;
        Account personAcc1 = new Account(FirstName = 'test12', 
                                        lastName = 'test11', 
                                        Member_ID__c = famAcc1.Member_Id__c,
                                        recordtypeId = personRecTypeId);
        insert personAcc1;
        User commUsr = [select id from User limit 1];
        RestRequest req = new RestRequest(); 
        RestResponse res = new RestResponse();
        string requestStructure = '{"id": "id","version": "v1","type": "assignment","data":{"activityTitle": "go for a run","subscriberId" : "' + famAcc1.Member_ID__c + '","memberSensId" : "'+ personAcc1.Id + '","carePlanId" : "ad2235","taskId" : "task6381", "careAdvisorId" : "' + commUsr.Id + '","createdAt":"2022-07-14T13:00:01.098Z"}}';
		req.requestBody = Blob.valueof(requestStructure);
        RestContext.request = req;
        RestContext.response= res;
        string jsonValue = RestContext.request.requestBody.toString();
        test.startTest();
        SENSAPI_UpsertJMEventRequestProcessor reqprocessor = new SENSAPI_UpsertJMEventRequestProcessor();
        IRestResponseWrapper responseWrapper = reqprocessor.process(jsonValue);
        test.stopTest();
    }
    
    static testMethod void upsertActivityTestActivityUpdateTypeCompleted(){
        Account personAcc = [SELECT Id FROM Account WHERE Recordtype.Name = 'Individual' LIMIT 1];
        Account famAcc = [SELECT Id,Member_ID__c FROM Account WHERE Recordtype.Name = 'Family' LIMIT 1];
        User commUsr = [select id from User limit 1];
        RestRequest req = new RestRequest(); 
        RestResponse res = new RestResponse();
        string requestStructure = '{"id": "id","version": "v1","type": "activityUpdate","data":{"activityTitle": "go for a run","subscriberId" : "' + famAcc.Member_ID__c + '","memberSensId" : "'+ personAcc.Id + '","carePlanId" : "ad2235","careAdvisorId" : "' + commUsr.Id + '","lastModifiedAt":"2022-07-14T13:00:01.098Z","status":"completed"}}';
        req.requestBody = Blob.valueof(requestStructure);
        RestContext.request = req;
        RestContext.response= res;
        string jsonValue = RestContext.request.requestBody.toString();
        test.startTest();
        SENSAPI_UpsertJMEventRequestProcessor reqprocessor = new SENSAPI_UpsertJMEventRequestProcessor();
        IRestResponseWrapper responseWrapper = reqprocessor.process(jsonValue);
        test.stopTest();
    }
    
    static testMethod void upsertActivityTestActivityUpdateTypeAssigned(){
        Account personAcc = [SELECT Id FROM Account WHERE Recordtype.Name = 'Individual' LIMIT 1];
        Account famAcc = [SELECT Id,Member_ID__c FROM Account WHERE Recordtype.Name = 'Family' LIMIT 1];
        User commUsr = [select id from User limit 1];
        RestRequest req = new RestRequest(); 
        RestResponse res = new RestResponse();
        string requestStructure = '{"id": "id","version": "v1","type": "activityUpdate","data":{"activityTitle": "go for a run","subscriberId" : "' + famAcc.Member_ID__c + '","memberSensId" : "'+ personAcc.Id + '","carePlanId" : "ad2235","careAdvisorId" : "' + commUsr.Id + '","lastModifiedAt":"2022-07-14T13:00:01.098Z","status":"assigned"}}';
        req.requestBody = Blob.valueof(requestStructure);
        RestContext.request = req;
        RestContext.response= res;
        string jsonValue = RestContext.request.requestBody.toString();
        test.startTest();
        SENSAPI_UpsertJMEventRequestProcessor reqprocessor = new SENSAPI_UpsertJMEventRequestProcessor();
        IRestResponseWrapper responseWrapper = reqprocessor.process(jsonValue);
        test.stopTest();
    }
    
    static testMethod void upsertActivityTestTypException(){
        Account personAcc = [SELECT Id FROM Account WHERE Recordtype.Name = 'Individual' LIMIT 1];
        Account famAcc = [SELECT Id,Member_ID__c FROM Account WHERE Recordtype.Name = 'Family' LIMIT 1];
        User commUsr = [select id from User limit 1];
        RestRequest req = new RestRequest(); 
        RestResponse res = new RestResponse();
        string requestStructure = '{"id": "id","version": "v1","type": "activityUpdateTest","data":{"activityTitle": "go for a run","subscriberId" : "' + famAcc.Member_ID__c + '","memberSensId" : "'+ personAcc.Id + '","carePlanId" : "ad2235","taskId" : "task12345","careAdvisorId" : "' + commUsr.Id + '","lastModifiedAt":"2022-07-14T13:00:01.098Z","status":"removed"}}';
        req.requestBody = Blob.valueof(requestStructure);
        RestContext.request = req;
        RestContext.response= res;
        string jsonValue = RestContext.request.requestBody.toString();
        test.startTest();
        SENSAPI_UpsertJMEventRequestProcessor reqprocessor = new SENSAPI_UpsertJMEventRequestProcessor();
        IRestResponseWrapper responseWrapper = reqprocessor.process(jsonValue);
        test.stopTest();
    }
    
}