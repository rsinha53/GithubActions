@isTest
public class SENSAPI_postMemberROITest {
    
    @testSetup static void setup() {
        
        Id recordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Family').getRecordTypeId();
        List<Account> accList=new List<Account>();
        List<SNI_FL_Care_Team_Member__c> teamlist=new List<SNI_FL_Care_Team_Member__c>();
        List<SNI_FL_Members_ROI__c> roiLst = new List<SNI_FL_Members_ROI__c>();
        Account famAcc = new Account();
        famAcc.Member_ID__c = '00756767666';
        famAcc.Policy_ID__c = '1230987';
        famAcc.Name = 'FLTestAcc123';
        famAcc.RecordTypeId = recordTypeId;
        insert famAcc;
        
        Id recordTypeId1 = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Family').getRecordTypeId();
        List<Account> accList1=new List<Account>();
        List<SNI_FL_Care_Team_Member__c> teamlist1=new List<SNI_FL_Care_Team_Member__c>();
        List<SNI_FL_Members_ROI__c> roiLst1 = new List<SNI_FL_Members_ROI__c>();
        Account famAcc1 = new Account();
        famAcc1.Member_ID__c = '00756767669';
        famAcc1.Policy_ID__c = '12309878';
        famAcc1.Name = 'FLTestAcc123';
        famAcc1.RecordTypeId = recordTypeId1;
        insert famAcc1;
        
        Id recordTypeId2 = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Family').getRecordTypeId();
        List<Account> accList2=new List<Account>();
        List<SNI_FL_Care_Team_Member__c> teamlist2=new List<SNI_FL_Care_Team_Member__c>();
        List<SNI_FL_Members_ROI__c> roiLst2 = new List<SNI_FL_Members_ROI__c>();
        Account famAcc2 = new Account();
        famAcc2.Member_ID__c = '00756767667';
        famAcc2.Policy_ID__c = '123098789';
        famAcc2.Name = 'FLTestAcc123';
        famAcc2.RecordTypeId = recordTypeId2;
        insert famAcc2;
        
        Id personAccRecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Individual').getRecordTypeId();
        Account pa =new account();
        pa.PersonBirthdate = date.valueOf(ACETUtility.formatDateFutureDate('6/17/1979'));
        pa.firstName = 'Community'; 
        pa.lastName = 'FLViewAuthTestUser'; 
        pa.RecordTypeId = personAccRecordTypeId;
        accList.add(pa);       
        
        Account pa2 =new account();
        pa2.PersonBirthdate = date.valueOf(ACETUtility.formatDateFutureDate('6/7/1977'));
        pa2.firstName = 'Community'; 
        pa2.lastName = 'FLViewAuthTestUser1'; 
        pa2.RecordTypeId = personAccRecordTypeId;
        accList.add(pa2);
        
        Account pa3 =new account();
        pa3.PersonBirthdate = date.valueOf(ACETUtility.formatDateFutureDate('6/7/1997'));
        pa3.firstName = 'Community'; 
        pa3.lastName = 'FLViewAuthTestUser2'; 
        pa3.RecordTypeId = personAccRecordTypeId;
        accList.add(pa3);          
        
        insert accList;
        
        SNI_FL_Care_Team_Member__c teamMemb = new SNI_FL_Care_Team_Member__c();
        teamMemb.SNI_FL_Primary_Caregiver__c = true;
        teamMemb.SNI_FL_Family__c = famAcc.Id;
        //teamMemb.SNI_FL_Family__r.member_id__c = famAcc.Member_ID__c;
        teamMemb.SNI_FL_Member__c = pa.Id;
        teamMemb.SNI_FL_Not_Visible_in_Familylink__c = false;
        teamMemb.SNI_FL_Status__c = 'Invited';
        teamlist.add(teamMemb);
        
        SNI_FL_Care_Team_Member__c teamMemb1 = new SNI_FL_Care_Team_Member__c();
        teamMemb1.SNI_FL_Primary_Caregiver__c = false;
        teamMemb1.SNI_FL_Family__c = famAcc.Id;
        //teamMemb.SNI_FL_Family__r.member_id__c = ac.Member_ID__c;
        teamMemb1.SNI_FL_Member__c = pa2.Id;
        teamMemb1.SNI_FL_Not_Visible_in_Familylink__c = false;
        teamMemb1.SNI_FL_Status__c = 'Invited';
        teamlist.add(teamMemb1);
        
        SNI_FL_Care_Team_Member__c teamMemb2 = new SNI_FL_Care_Team_Member__c();
        teamMemb2.SNI_FL_Primary_Caregiver__c = false;
        teamMemb2.SNI_FL_Family__c = famAcc.Id;
        //teamMemb2.SNI_FL_Family__r.Member_ID__c = ac.Member_ID__c;
        teamMemb2.SNI_FL_Member__c = pa3.Id;
        teamMemb2.SNI_FL_Not_Visible_in_Familylink__c = false;
        teamMemb2.SNI_FL_Status__c = 'Added';
        teamlist.add(teamMemb2);
        insert teamlist;
        
        SNI_FL_Members_ROI__c roi = new SNI_FL_Members_ROI__c();
        roi.SNI_FL_Account__c = teamMemb.SNI_FL_Member__c;
        roi.SNI_FL_Member__c = teamMemb.Id;
        roi.SNI_FL_ROI_Signed_Date__c = system.today();
        roi.SNI_FL_ROI_Signed_With__c = teamMemb1.Id;
        roi.SNI_FL_Status__c = 'Active';
        roi.SNI_FL_Type__c = 'Electronically';
        roiLst.add(roi);
        SNI_FL_Members_ROI__c roi1 = new SNI_FL_Members_ROI__c();
        roi1.SNI_FL_Account__c = teamMemb.SNI_FL_Member__c;
        roi1.SNI_FL_Member__c = teamMemb1.Id;
        roi1.SNI_FL_ROI_Signed_Date__c = system.today();
        roi1.SNI_FL_ROI_Signed_With__c = teamMemb.Id;
        roi1.SNI_FL_Status__c = 'InActive';
        roi1.SNI_FL_Type__c = 'Electronically';
        roiLst.add(roi1);
        insert roiLst;
        
    }
    
    @isTest static void testProcessReqWithInvalidReq() {
        Date PersonBirthdateBy = date.valueOf(ACETUtility.formatDateFutureDate('6/17/1979'));
        List<account> authorizedBy = [select id from account where PersonBirthdate =: PersonBirthdateBy LIMIT 1];
        
        Date PersonBirthdateFor = date.valueOf(ACETUtility.formatDateFutureDate('6/7/1977'));
        List<account> authorizedFor = [select id from account where PersonBirthdate =: PersonBirthdateFor LIMIT 1];
        List<contact> authorizedByContact = [select id,accountid from contact where accountid=:authorizedBy[0].id LIMIT 1];
        List<contact> authorizedForContact = [select id,accountid from contact where accountid=:authorizedFor[0].id LIMIT 1];
        
        Id p = [select id from profile where name='Care Advisor Connect Community User'].id;
        
        User authorizedByUser = new User(Alias = 'standt', Email='standarduser@testorg.com', 
                                         EmailEncodingKey='UTF-8', LastName='Testing', LanguageLocaleKey='en_US', 
                                         LocaleSidKey='en_US', ProfileId = p, ContactId = authorizedByContact[0].Id, isActive =false,
                                         TimeZoneSidKey='America/Los_Angeles', UserName = 'standarduser3##@testorg.com');
        insert authorizedByUser;
        
        User authorizedForUser = new User(Alias = 'standt', Email='standardusertesting1@testorg.com', 
                                          EmailEncodingKey='UTF-8', LastName='TestingUser', LanguageLocaleKey='en_US', 
                                          LocaleSidKey='en_US', ProfileId = p, ContactId = authorizedForContact[0].Id, isActive =false,
                                          TimeZoneSidKey='America/Los_Angeles', UserName = 'standardusertesting1##@testorg.com');
        insert authorizedForUser;
        
        String famId = [Select id from account where Policy_ID__c = '1230987' LIMIT 1].Id ;
        String subsId = [Select member_id__c from account where Policy_ID__c = '1230987' LIMIT 1].member_id__c ;
        
        RestRequest req = new RestRequest(); 
        RestResponse res = new RestResponse();
        
        String JSONMsg = '{"subscriberId" : ["'+subsId+'"],"sensId" : "'+authorizedBy[0].id+'","revokedFor" : ["'+authorizedFor[0].Id+'"]}';
        req.requestBody = Blob.valueof(JSONMsg);
        RestContext.request = req;
        RestContext.response= res;
        string jsonValue = RestContext.request.requestBody.toString();
        Test.startTest();  
        SENSAPI_postMemberROIReqProcessor reqprocess = new SENSAPI_postMemberROIReqProcessor();
        IRestResponseWrapper responseWrapper = reqprocess.process(jsonValue); 
        Test.stopTest();

    }
    
    @isTest static void testProcessReqWithNullAuth() {
        Date PersonBirthdateBy = date.valueOf(ACETUtility.formatDateFutureDate('6/17/1979'));
        List<account> authorizedBy = [select id from account where PersonBirthdate =: PersonBirthdateBy LIMIT 1];
        
        Date PersonBirthdateFor = date.valueOf(ACETUtility.formatDateFutureDate('6/7/1977'));
        List<account> authorizedFor = [select id from account where PersonBirthdate =: PersonBirthdateFor LIMIT 1];
        List<contact> authorizedByContact = [select id,accountid from contact where accountid=:authorizedBy[0].id LIMIT 1];
        List<contact> authorizedForContact = [select id,accountid from contact where accountid=:authorizedFor[0].id LIMIT 1];
        
        Id p = [select id from profile where name='Care Advisor Connect Community User'].id;
        
        User authorizedByUser = new User(Alias = 'standt', Email='standarduser@testorg.com', 
                                         EmailEncodingKey='UTF-8', LastName='Testing', LanguageLocaleKey='en_US', 
                                         LocaleSidKey='en_US', ProfileId = p, ContactId = authorizedByContact[0].Id, isActive =true,
                                         TimeZoneSidKey='America/Los_Angeles', UserName = 'standarduser3##@testorg.com');
        insert authorizedByUser;
        
        User authorizedForUser = new User(Alias = 'standt', Email='standardusertesting1@testorg.com', 
                                          EmailEncodingKey='UTF-8', LastName='TestingUser', LanguageLocaleKey='en_US', 
                                          LocaleSidKey='en_US', ProfileId = p, ContactId = authorizedForContact[0].Id, isActive =true,
                                          TimeZoneSidKey='America/Los_Angeles', UserName = 'standardusertesting1##@testorg.com');
        insert authorizedForUser;
        
        String famId = [Select id from account where Policy_ID__c = '1230987' LIMIT 1].Id ;
        String subsId = [Select member_id__c from account where Policy_ID__c = '1230987' LIMIT 1].member_id__c ;
        List<SNI_FL_Care_Team_Member__c> ctmLst = new List<SNI_FL_Care_Team_Member__c>();
        for(SNI_FL_Care_Team_Member__c ctm : [SELECT Id,SNI_FL_Family__r.member_id__c from SNI_FL_Care_Team_Member__c where SNI_FL_Family__c =: famId])
        {
            ctm.SNI_FL_Family__r.member_id__c = subsId;
            ctmLst.add(ctm);
        }
        update ctmLst;
        
        List<SNI_FL_Care_Team_Member__c> cteam = [SELECT Id from SNI_FL_Care_Team_Member__c where SNI_FL_Member__c =: authorizedFor[0].Id LIMIT 1];
        List<SNI_FL_Members_ROI__c> roiLst = [SELECT Id from SNI_FL_Members_ROI__c where SNI_FL_Member__c =: ctmLst[0].Id];
        List<SNI_FL_Members_ROI__c> existingList = new List<SNI_FL_Members_ROI__c>();
        for(SNI_FL_Members_ROI__c roi : roiLst){
            roi.SNI_FL_Account__c = authorizedFor[0].id;
            existingList.add(roi);
        }
        update existingList;
        
        RestRequest req = new RestRequest(); 
        RestResponse res = new RestResponse();
        
        String JSONMsg = '{"subscriberId" : "'+subsId+'","sensId" : "'+authorizedBy[0].id+'","revokedFor" : ["'+authorizedFor[0].Id+'"]}';
        req.requestBody = Blob.valueof(JSONMsg);
        RestContext.request = req;
        RestContext.response= res;
        string jsonValue = RestContext.request.requestBody.toString();
        Test.startTest();  
        SENSAPI_postMemberROIReqProcessor reqprocess = new SENSAPI_postMemberROIReqProcessor();
        IRestResponseWrapper responseWrapper = reqprocess.process(jsonValue); 
        Test.stopTest();

    }
    
    @isTest static void testProcessReqWithNullRevoke() {
        Date PersonBirthdateBy = date.valueOf(ACETUtility.formatDateFutureDate('6/17/1979'));
        List<account> authorizedBy = [select id from account where PersonBirthdate =: PersonBirthdateBy LIMIT 1];
        
        Date PersonBirthdateFor = date.valueOf(ACETUtility.formatDateFutureDate('6/7/1977'));
        List<account> authorizedFor = [select id from account where PersonBirthdate =: PersonBirthdateFor LIMIT 1];
        List<contact> authorizedByContact = [select id,accountid from contact where accountid=:authorizedBy[0].id LIMIT 1];
        List<contact> authorizedForContact = [select id,accountid from contact where accountid=:authorizedFor[0].id LIMIT 1];
        
        Id p = [select id from profile where name='Care Advisor Connect Community User'].id;
        
        User authorizedByUser = new User(Alias = 'standt', Email='standarduser@testorg.com', 
                                         EmailEncodingKey='UTF-8', LastName='Testing', LanguageLocaleKey='en_US', 
                                         LocaleSidKey='en_US', ProfileId = p, ContactId = authorizedByContact[0].Id, isActive =true,
                                         TimeZoneSidKey='America/Los_Angeles', UserName = 'standarduser3##@testorg.com');
        insert authorizedByUser;
        
        User authorizedForUser = new User(Alias = 'standt', Email='standardusertesting1@testorg.com', 
                                          EmailEncodingKey='UTF-8', LastName='TestingUser', LanguageLocaleKey='en_US', 
                                          LocaleSidKey='en_US', ProfileId = p, ContactId = authorizedForContact[0].Id, isActive =true,
                                          TimeZoneSidKey='America/Los_Angeles', UserName = 'standardusertesting1##@testorg.com');
        insert authorizedForUser;
        
        String famId = [Select id from account where Policy_ID__c = '1230987' LIMIT 1].Id ;
        String subsId = [Select member_id__c from account where Policy_ID__c = '1230987' LIMIT 1].member_id__c ;
        List<SNI_FL_Care_Team_Member__c> ctmLst = new List<SNI_FL_Care_Team_Member__c>();
        for(SNI_FL_Care_Team_Member__c ctm : [SELECT Id,SNI_FL_Family__r.member_id__c from SNI_FL_Care_Team_Member__c where SNI_FL_Family__c =: famId])
        {
            ctm.SNI_FL_Family__r.member_id__c = subsId;
            ctmLst.add(ctm);
        }
        update ctmLst;
        
        List<SNI_FL_Care_Team_Member__c> cteam = [SELECT Id from SNI_FL_Care_Team_Member__c where SNI_FL_Member__c =: authorizedFor[0].Id LIMIT 1];
        List<SNI_FL_Members_ROI__c> roiLst = [SELECT Id from SNI_FL_Members_ROI__c where SNI_FL_Member__c =: ctmLst[0].Id];
        List<SNI_FL_Members_ROI__c> existingList = new List<SNI_FL_Members_ROI__c>();
        for(SNI_FL_Members_ROI__c roi : roiLst){
            roi.SNI_FL_Account__c = authorizedFor[0].id;
            existingList.add(roi);
        }
        update existingList;
        
        RestRequest req = new RestRequest(); 
        RestResponse res = new RestResponse();
        
        String JSONMsg = '{"subscriberId" : "'+subsId+'","sensId" : "'+authorizedBy[0].id+'","authorizedFor" : ["'+authorizedFor[0].Id+'"]}';
        req.requestBody = Blob.valueof(JSONMsg);
        RestContext.request = req;
        RestContext.response= res;
        string jsonValue = RestContext.request.requestBody.toString();
        Test.startTest();  
        SENSAPI_postMemberROIReqProcessor reqprocess = new SENSAPI_postMemberROIReqProcessor();
        IRestResponseWrapper responseWrapper = reqprocess.process(jsonValue); 
        Test.stopTest();

    }
    
    @isTest static void testProcessReqWithAuthMems() {
        
        Date PersonBirthdateBy = date.valueOf(ACETUtility.formatDateFutureDate('6/17/1979'));
        List<account> authorizedBy = [select id from account where PersonBirthdate =: PersonBirthdateBy LIMIT 1];
        
        Date PersonBirthdateFor = date.valueOf(ACETUtility.formatDateFutureDate('6/7/1977'));
        List<account> authorizedFor = [select id from account where PersonBirthdate =: PersonBirthdateFor LIMIT 1];
        List<contact> authorizedByContact = [select id,accountid from contact where accountid=:authorizedBy[0].id LIMIT 1];
        List<contact> authorizedForContact = [select id,accountid from contact where accountid=:authorizedFor[0].id LIMIT 1];
        
        Id p = [select id from profile where name='Care Advisor Connect Community User'].id;
        
        User authorizedByUser = new User(Alias = 'standt', Email='standarduser@testorg.com', 
                                         EmailEncodingKey='UTF-8', LastName='Testing', LanguageLocaleKey='en_US', 
                                         LocaleSidKey='en_US', ProfileId = p, ContactId = authorizedByContact[0].Id, isActive =true,
                                         TimeZoneSidKey='America/Los_Angeles', UserName = 'standarduser3##@testorg.com');
        insert authorizedByUser;
        
        User authorizedForUser = new User(Alias = 'standt', Email='standardusertesting1@testorg.com', 
                                          EmailEncodingKey='UTF-8', LastName='TestingUser', LanguageLocaleKey='en_US', 
                                          LocaleSidKey='en_US', ProfileId = p, ContactId = authorizedForContact[0].Id, isActive =true,
                                          TimeZoneSidKey='America/Los_Angeles', UserName = 'standardusertesting1##@testorg.com');
        insert authorizedForUser;
        
        String famId = [Select id from account where Policy_ID__c = '1230987' LIMIT 1].Id ;
        String subsId = [Select member_id__c from account where Policy_ID__c = '1230987' LIMIT 1].member_id__c ;
        List<SNI_FL_Care_Team_Member__c> ctmLst = new List<SNI_FL_Care_Team_Member__c>();
        for(SNI_FL_Care_Team_Member__c ctm : [SELECT Id,SNI_FL_Family__r.member_id__c from SNI_FL_Care_Team_Member__c where SNI_FL_Family__c =: famId])
        {
            ctm.SNI_FL_Family__r.member_id__c = subsId;
            ctmLst.add(ctm);
        }
        update ctmLst;
        
        List<SNI_FL_Care_Team_Member__c> cteam = [SELECT Id from SNI_FL_Care_Team_Member__c where SNI_FL_Member__c =: authorizedFor[0].Id LIMIT 1];
        List<SNI_FL_Members_ROI__c> roiLst = [SELECT Id from SNI_FL_Members_ROI__c where SNI_FL_Member__c =: ctmLst[0].Id];
        List<SNI_FL_Members_ROI__c> existingList = new List<SNI_FL_Members_ROI__c>();
        for(SNI_FL_Members_ROI__c roi : roiLst){
            roi.SNI_FL_Account__c = authorizedFor[0].id;
            existingList.add(roi);
        }
        update existingList;
        
        RestRequest req = new RestRequest(); 
        RestResponse res = new RestResponse();
        
        String JSONMsg = '{"subscriberId" : "'+subsId+'","sensId" : "'+authorizedBy[0].id+'","authorizedFor" : ["'+authorizedFor[0].Id+'"],"revokedFor" : []}';
        req.requestBody = Blob.valueof(JSONMsg);
        RestContext.request = req;
        RestContext.response= res;
        string jsonValue = RestContext.request.requestBody.toString();
        Test.startTest();  
        SENSAPI_postMemberROIReqProcessor reqprocess = new SENSAPI_postMemberROIReqProcessor();
        IRestResponseWrapper responseWrapper = reqprocess.process(jsonValue); 
        Test.stopTest();
        
    }
    
    @isTest static void testProcessReqWithRequiredMissing() {
        RestRequest req = new RestRequest(); 
        RestResponse res = new RestResponse();
        String JSONMsg = '{"subscriberId" : "","sensId" : "","authorizedFor" : [],"revokedFor" : []}';
        req.requestBody = Blob.valueof(JSONMsg);
        RestContext.request = req;
        RestContext.response= res;
        string jsonValue = RestContext.request.requestBody.toString();
        Test.startTest(); 
        SENSAPI_postMemberROIReqProcessor reqprocess = new SENSAPI_postMemberROIReqProcessor();
        IRestResponseWrapper responseWrapper = reqprocess.process(jsonValue);  
        Test.stopTest();
    }
    
    @isTest static void testProcessReqWithInvalidValues() {
        Date PersonBirthdateFor = date.valueOf(ACETUtility.formatDateFutureDate('6/7/1977'));
        List<account> authorizedFor = [select id from account where PersonBirthdate =: PersonBirthdateFor LIMIT 1];
        RestRequest req = new RestRequest(); 
        RestResponse res = new RestResponse();
        String JSONMsg = '{"subscriberId" : "6555","sensId" : "abcd","authorizedFor" : ["'+authorizedFor[0].Id+'"],"revokedFor" : []}';
        req.requestBody = Blob.valueof(JSONMsg);
        RestContext.request = req;
        RestContext.response= res;
        string jsonValue = RestContext.request.requestBody.toString();
        Test.startTest();  
        SENSAPI_postMemberROIReqProcessor reqprocess = new SENSAPI_postMemberROIReqProcessor();
        IRestResponseWrapper responseWrapper = reqprocess.process(jsonValue); 
        Test.stopTest();
    }
    
    @isTest static void testProcessReqWithRevokedIds() {
        Date PersonBirthdateBy = date.valueOf(ACETUtility.formatDateFutureDate('6/17/1979'));
        List<account> authorizedBy = [select id from account where PersonBirthdate =: PersonBirthdateBy LIMIT 1];
        List<contact> authorizedByContact = [select id,accountid from contact where accountid=:authorizedBy[0].id LIMIT 1];
        
        Id p = [select id from profile where name='Care Advisor Connect Community User'].id;
        
        User authorizedByUser = new User(Alias = 'standt', Email='standarduser@testorg.com', 
                                         EmailEncodingKey='UTF-8', LastName='Testing', LanguageLocaleKey='en_US', 
                                         LocaleSidKey='en_US', ProfileId = p, ContactId = authorizedByContact[0].Id, isActive =true,
                                         TimeZoneSidKey='America/Los_Angeles', UserName = 'standarduser3##@testorg.com');
        insert authorizedByUser;
        String famId = [Select id from account where Policy_ID__c = '1230987' LIMIT 1].Id ;
        String subsId = [Select member_id__c from account where Policy_ID__c = '1230987' LIMIT 1].member_id__c ;
        List<SNI_FL_Care_Team_Member__c> ctmLst = new List<SNI_FL_Care_Team_Member__c>();
        for(SNI_FL_Care_Team_Member__c ctm : [SELECT Id,SNI_FL_Family__r.member_id__c from SNI_FL_Care_Team_Member__c where SNI_FL_Family__c =: famId])
        {
            ctm.SNI_FL_Family__r.member_id__c = subsId;
            ctmLst.add(ctm);
        }
        update ctmLst;
        
        List<SNI_FL_Care_Team_Member__c> cteam = [SELECT Id from SNI_FL_Care_Team_Member__c where SNI_FL_Member__c =: authorizedBy[0].Id LIMIT 1];
        List<SNI_FL_Members_ROI__c> roiLst = [SELECT Id from SNI_FL_Members_ROI__c where SNI_FL_Member__c =: ctmLst[0].Id];
        List<SNI_FL_Members_ROI__c> existingList = new List<SNI_FL_Members_ROI__c>();
        for(SNI_FL_Members_ROI__c roi : roiLst){
            roi.SNI_FL_Account__c = authorizedBy[0].id;
            existingList.add(roi);
        }
        update existingList;
        
        RestRequest req = new RestRequest(); 
        RestResponse res = new RestResponse();
        
        String JSONMsg = '{"subscriberId" : "'+subsId+'","sensId" : "'+authorizedBy[0].id+'","authorizedFor" : [],"revokedFor" : ["'+authorizedBy[0].Id+'"]}';
        req.requestBody = Blob.valueof(JSONMsg);
        RestContext.request = req;
        RestContext.response= res;
        string jsonValue = RestContext.request.requestBody.toString();
        Test.startTest();  
        SENSAPI_postMemberROIReqProcessor reqprocess = new SENSAPI_postMemberROIReqProcessor();
        IRestResponseWrapper responseWrapper = reqprocess.process(jsonValue); 
        Test.stopTest();
    }
    
    @isTest static void testProcessReqWithBothMems() {
        
        Date PersonBirthdateBy = date.valueOf(ACETUtility.formatDateFutureDate('6/17/1979'));
        List<account> authorizedBy = [select id from account where PersonBirthdate =: PersonBirthdateBy LIMIT 1];
        
        Date PersonBirthdateFor = date.valueOf(ACETUtility.formatDateFutureDate('6/7/1977'));
        List<account> authorizedFor = [select id from account where PersonBirthdate =: PersonBirthdateFor LIMIT 1];
        List<contact> authorizedByContact = [select id,accountid from contact where accountid=:authorizedBy[0].id LIMIT 1];
        List<contact> authorizedForContact = [select id,accountid from contact where accountid=:authorizedFor[0].id LIMIT 1];
        
        Id p = [select id from profile where name='Care Advisor Connect Community User'].id;
        
        User authorizedByUser = new User(Alias = 'standt', Email='standarduser@testorg.com', 
                                         EmailEncodingKey='UTF-8', LastName='Testing', LanguageLocaleKey='en_US', 
                                         LocaleSidKey='en_US', ProfileId = p, ContactId = authorizedByContact[0].Id, isActive =true,
                                         TimeZoneSidKey='America/Los_Angeles', UserName = 'standarduser3##@testorg.com');
        insert authorizedByUser;
        
        User authorizedForUser = new User(Alias = 'standt', Email='standardusertesting1@testorg.com', 
                                          EmailEncodingKey='UTF-8', LastName='TestingUser', LanguageLocaleKey='en_US', 
                                          LocaleSidKey='en_US', ProfileId = p, ContactId = authorizedForContact[0].Id, isActive =true,
                                          TimeZoneSidKey='America/Los_Angeles', UserName = 'standardusertesting1##@testorg.com');
        insert authorizedForUser;
        
        String famId = [Select id from account where Policy_ID__c = '1230987' LIMIT 1].Id ;
        String subsId = [Select member_id__c from account where Policy_ID__c = '1230987' LIMIT 1].member_id__c ;
        List<SNI_FL_Care_Team_Member__c> ctmLst = new List<SNI_FL_Care_Team_Member__c>();
        for(SNI_FL_Care_Team_Member__c ctm : [SELECT Id,SNI_FL_Family__r.member_id__c from SNI_FL_Care_Team_Member__c where SNI_FL_Family__c =: famId])
        {
            ctm.SNI_FL_Family__r.member_id__c = subsId;
            ctmLst.add(ctm);
        }
        update ctmLst;
        
        List<SNI_FL_Care_Team_Member__c> cteam = [SELECT Id from SNI_FL_Care_Team_Member__c where SNI_FL_Member__c =: authorizedFor[0].Id LIMIT 1];
        List<SNI_FL_Members_ROI__c> roiLst = [SELECT Id from SNI_FL_Members_ROI__c where SNI_FL_Member__c =: ctmLst[0].Id];
        List<SNI_FL_Members_ROI__c> existingList = new List<SNI_FL_Members_ROI__c>();
        for(SNI_FL_Members_ROI__c roi : roiLst){
            roi.SNI_FL_Account__c = authorizedFor[0].id;
            existingList.add(roi);
        }
        update existingList;
        
        RestRequest req = new RestRequest(); 
        RestResponse res = new RestResponse();
        
        String JSONMsg = '{"subscriberId" : "'+subsId+'","sensId" : "'+authorizedBy[0].id+'","authorizedFor" : ["'+authorizedFor[0].Id+'"],"revokedFor" : ["'+authorizedBy[0].Id+'"]}';
        req.requestBody = Blob.valueof(JSONMsg);
        RestContext.request = req;
        RestContext.response= res;
        string jsonValue = RestContext.request.requestBody.toString();
        Test.startTest();  
        SENSAPI_postMemberROIReqProcessor reqprocess = new SENSAPI_postMemberROIReqProcessor();
        IRestResponseWrapper responseWrapper = reqprocess.process(jsonValue); 
        Test.stopTest();
    }
    
    @isTest static void testProcessReqWithinvalidRevoke() {
        
        Date PersonBirthdateBy = date.valueOf(ACETUtility.formatDateFutureDate('6/17/1979'));
        List<account> authorizedBy = [select id from account where PersonBirthdate =: PersonBirthdateBy LIMIT 1];
        
        Date PersonBirthdateFor = date.valueOf(ACETUtility.formatDateFutureDate('6/7/1977'));
        List<account> authorizedFor = [select id from account where PersonBirthdate =: PersonBirthdateFor LIMIT 1];
        List<contact> authorizedByContact = [select id,accountid from contact where accountid=:authorizedBy[0].id LIMIT 1];
        List<contact> authorizedForContact = [select id,accountid from contact where accountid=:authorizedFor[0].id LIMIT 1];
        
        String famId1 = [Select id from account where Policy_ID__c = '12309878' LIMIT 1].Id ;
        AccountContactRelation acr = new accountcontactrelation();
        acr.AccountId = famId1;
        acr.contactid = authorizedForContact[0].id;
        insert acr;
        
        Id p = [select id from profile where name='Care Advisor Connect Community User'].id;
        
        User authorizedByUser = new User(Alias = 'standt', Email='standarduser@testorg.com', 
                                         EmailEncodingKey='UTF-8', LastName='Testing', LanguageLocaleKey='en_US', 
                                         LocaleSidKey='en_US', ProfileId = p, ContactId = authorizedByContact[0].Id, isActive =true,
                                         TimeZoneSidKey='America/Los_Angeles', UserName = 'standarduser3##@testorg.com');
        insert authorizedByUser;
        
        User authorizedForUser = new User(Alias = 'standt', Email='standardusertesting1@testorg.com', 
                                          EmailEncodingKey='UTF-8', LastName='TestingUser', LanguageLocaleKey='en_US', 
                                          LocaleSidKey='en_US', ProfileId = p, ContactId = authorizedForContact[0].Id, isActive =true,
                                          TimeZoneSidKey='America/Los_Angeles', UserName = 'standardusertesting1##@testorg.com');
        insert authorizedForUser;
        
        String famId = [Select id from account where Policy_ID__c = '1230987' LIMIT 1].Id ;
        String subsId = [Select member_id__c from account where Policy_ID__c = '1230987' LIMIT 1].member_id__c ;
        List<SNI_FL_Care_Team_Member__c> ctmLst = new List<SNI_FL_Care_Team_Member__c>();
        for(SNI_FL_Care_Team_Member__c ctm : [SELECT Id,SNI_FL_Family__r.member_id__c from SNI_FL_Care_Team_Member__c where SNI_FL_Family__c =: famId])
        {
            ctm.SNI_FL_Family__r.member_id__c = subsId;
            ctm.SNI_FL_Member__c = authorizedBy[0].id;
            ctmLst.add(ctm);
        }
        update ctmLst;
        
        RestRequest req = new RestRequest(); 
        RestResponse res = new RestResponse();
        
        String JSONMsg = '{"subscriberId" : "'+subsId+'","sensId" : "'+authorizedBy[0].id+'","revokedFor" : ["'+authorizedFor[0].Id+'"]}';
        req.requestBody = Blob.valueof(JSONMsg);
        RestContext.request = req;
        RestContext.response= res;
        string jsonValue = RestContext.request.requestBody.toString();
        Test.startTest();  
        SENSAPI_postMemberROIReqProcessor reqprocess = new SENSAPI_postMemberROIReqProcessor();
        IRestResponseWrapper responseWrapper = reqprocess.process(jsonValue); 
        Test.stopTest();
    }
    
    @isTest static void testProcessReqWithValidReqCheck1() {
        
        RestRequest req = new RestRequest(); 
        RestResponse res = new RestResponse();
        
        String JSONMsg = '{"subscriberId" : "","sensId" : "","revokedFor" : []}';
        req.requestBody = Blob.valueof(JSONMsg);
        RestContext.request = req;
        RestContext.response= res;
        string jsonValue = RestContext.request.requestBody.toString();
        Test.startTest();  
        SENSAPI_postMemberROIReqProcessor reqprocess = new SENSAPI_postMemberROIReqProcessor();
        IRestResponseWrapper responseWrapper = reqprocess.process(jsonValue); 
        Test.stopTest();
    }
    
    @isTest static void testProcessReqWithValidReqCheck2() {
        
        RestRequest req = new RestRequest(); 
        RestResponse res = new RestResponse();
        
        String JSONMsg = '{"subscriberId" : "","sensId" : "","authorizedFor" : []}';
        req.requestBody = Blob.valueof(JSONMsg);
        RestContext.request = req;
        RestContext.response= res;
        string jsonValue = RestContext.request.requestBody.toString();
        Test.startTest();  
        SENSAPI_postMemberROIReqProcessor reqprocess = new SENSAPI_postMemberROIReqProcessor();
        IRestResponseWrapper responseWrapper = reqprocess.process(jsonValue); 
        Test.stopTest();
    }
    
    
   
}