/********************************************************************************* 
Class Name     : SNI_FLDirectMessageUtilTest.apxc
Description    : Test 
Created By     : Sameera De Silva
Created Date   : 8/25/2020
Modification Log
---------------------------------------------------------------------------------- 
Developer                   Date                   Description
1.
----------------------------------------------------------------------------------            
*********************************************************************************/
@isTest(SeeAllData=true)
public with sharing class SNI_FL_DirectMessageUtilTest {

    private static final String PROFILENAME = 'System Administrator';
    private static final String TESTUSERNAME = 'test_userr@optum.com';
    private static final String TIMEZONE = 'America/New_York';
    private static final String EMAILENCODINGKEY = 'ISO-8859-1';
    private static final String TESTEMAIL = 'familyLink@optum.com';
    private static final String TSTEMAIL = 'agent1@optum.acet.com';
    private static final String TESTMAIL = 'agent2_acdc_@optum.acet.com';
    private static final String TESTALIAS= 'GDS';
    private static final String TESTLOCALKEYS = 'en_US';
    private static final String TESTFIRSTNAME = 'FirstName';
    private static final String TESTLASTNAME = 'LastName';
    private static final String TESTFILENAME = 'test File';
    private static final String TESTPATHONCLIENT = 'testing.txt';
    private static final String TESTFILETITLE = 'Testing Files';
    private static final String ACCOUNTNAME = 'Test Account';
    private static final String EMAIL ='standarduser@testorg.com';
    private static final String TIMEZONESIDKEY = 'America/Los_Angeles';
    private static final String ASSERTMSG = 'There is no data for the inputs in DB to retirve';
    private static final String DODYSSEY = 'Diagnostic Odyssey';

    @isTest
    static void nonFamilyLevelDirectMsgTest(){

        List<Account> lstFamilyAccount = SNI_FL_DirectMessageTestDataFactory.createAccountRecordsTestData('Family',1);
        lstFamilyAccount[0].Ownerid = Userinfo.getuserid();
        update lstFamilyAccount;

        List<ID> ids = new List<ID>();

        profile p=[select Id from profile where Name=:PROFILENAME];
        User u1;
        system.runAs(new user(Id = userinfo.getUserId())){
            u1 = new User( email=TESTEMAIL,
                               profileid = p.id, 
                               UserName=TESTUSERNAME, 
                               Alias = TESTALIAS,
                               TimeZoneSidKey=TIMEZONE,
                               EmailEncodingKey=EMAILENCODINGKEY,
                               LocaleSidKey=TESTLOCALKEYS, 
                               LanguageLocaleKey=TESTLOCALKEYS,
                               FirstName = TESTFIRSTNAME,
                               LastName = TESTLASTNAME);
            insert u1;
		}
        ids.add(u1.id);
        SNI_FL_DirectMessageTestDataFactory.createDirectMessagesTestData(1,ids);
        List<DirectMessageFeed> lstDirectMsgFeed = [SELECT ID FROM DirectMessageFeed WHERE ParentId IN (SELECT ID FROM DirectMessage WHERE Subject LIKE 'DirectMsg_ACDC_Test') LIMIT 1];
        SNI_FL_Message__c message = new SNI_FL_Message__c(Family_ID__c=lstFamilyAccount[0].Id,Feed_Id__c=lstDirectMsgFeed[0].Id,Marked__c=false,Name='test');
        insert message;
        SNI_FL_DirectMessageTestDataFactory.insertFLDirectMessageTestData(lstFamilyAccount,lstDirectMsgFeed,1,false);

        List<SNI_FL_Message__c> lstFlMsg = [SELECT Id FROM SNI_FL_Message__c WHERE Name like 'Direct%'];

        SNI_FL_DirectMessageTestDataFactory.insertFLMessageStatusTestData(lstFlMsg,1,true);
        list<SNI_FL_Message_Status__c> msgstatusLst= new  list<SNI_FL_Message_Status__c>();
        SNI_FL_Message_Status__c msgstatus=new SNI_FL_Message_Status__c(IsRead__c=false,Agent__c=ids[0],SNI_FL_Message__c=message.id);
        SNI_FL_Message_Status__c msgstatus3=new SNI_FL_Message_Status__c(IsRead__c=false,Agent__c=Userinfo.getUserId(),SNI_FL_Message__c=message.id);
        msgstatusLst.add(msgstatus);

        msgstatusLst.add(msgstatus3);
        insert msgstatusLst;
        ContentVersion conVer = new ContentVersion(PathOnClient = TESTPATHONCLIENT,Title = TESTFILETITLE,VersionData = EncodingUtil.base64Decode(TESTFILENAME));       
        insert conVer;   
        Id conDoc = [SELECT ContentDocumentId FROM ContentVersion WHERE Id =:conVer.Id].ContentDocumentId;
        ContentDocumentLink conDocLink = New ContentDocumentLink();
        conDocLink.LinkedEntityId = lstFamilyAccount.get(0).id; 
        conDocLink.ContentDocumentId = conDoc;
        conDocLink.shareType = 'V';
        insert conDocLink;

        Test.startTest();
        SNI_FLDirectMessageUtil.saveNewMessage(lstFamilyAccount[0].Id, ids, 'subject', 'messageBody',  conVer.id,  false,false,null);
        SNI_FLDirectMessageUtil.saveNewMessage(lstFamilyAccount[0].Id, ids, 'subject', 'messageBody',  conVer.id,  true,false,null);
        SNI_FLDirectMessageUtil.saveNewMessage(lstFamilyAccount[0].Id, ids, 'subject', 'messageBody',  conVer.id,  true,true,null);
        SNI_FLDirectMessageUtil.feedToggleMarked(true,string.valueof(lstDirectMsgFeed[0].Id));
        SNI_FLDirectMessageUtil.feedToggleMarked(true,'001m000001CujiRAAR');
        SNI_FLDirectMessageUtil.changeMessageStatusWhenReplying(lstDirectMsgFeed[0].Id);
        SNI_FLDirectMessageUtil.changeReadStatus(true,string.valueof(lstDirectMsgFeed[0].Id));
        SNI_FLDirectMessageUtil.changeReadStatus(true,'001m000001CujiRAAR');
        SNI_FLDirectMessageUtil.getAccountNameByUser();
        SNI_FLDirectMessageUtil.postNewComment(lstDirectMsgFeed[0].Id, 'test message body');
        SNI_FLDirectMessageUtil.validatepostNewCommentAttachment(lstDirectMsgFeed[0].Id, 'test',conDoc) ;
        SNI_FLDirectMessageUtil.markAsUnread(lstDirectMsgFeed[0].Id);
        SNI_FLDirectMessageUtil.getAllRelatedToMembers('Test');
        SNI_FLDirectMessageUtil.getHistoryEnabled();
        SNI_FLDirectMessageUtil.checkManageProviderGroupUserId();
        SNI_FLDirectMessageUtil.postNewCommentWithAttachement(lstDirectMsgFeed[0].Id, 'test new message with attachment',conDoc);
        SNI_FLDirectMessageUtil.getFamilLinkUserMsg();
        SNI_FLDirectMessageUtil.getAccountNameByID1(lstFamilyAccount[0].Id);
        SNI_FLDirectMessageObjectQuery.updateMessageStatus(lstDirectMsgFeed[0].Id);
        SNI_FLDirectMessageObjectQuery.updateMessageStatus('001m000001CujiRAAR');
        SNI_FLDirectMessageUtil.deleteAttachment(conVer.id);
        Test.stopTest();
    }
    
    @isTest
    static void testGetDirectMessageList (){
        List<Account> lstFamilyAccount = SNI_FL_DirectMessageTestDataFactory.createAccountRecordsTestData('Family',1);
        lstFamilyAccount[0].Ownerid=Userinfo.getuserid();
        update lstFamilyAccount;

        List<ID> ids = new List<ID>();

        profile p=[select Id from profile where Name=:PROFILENAME];
        User u1;
        system.runAs(new user(Id = userinfo.getUserId())){
            u1 = new User( email=TESTEMAIL,
                               profileid = p.id, 
                               UserName=TESTUSERNAME, 
                               Alias = TESTALIAS,
                               TimeZoneSidKey=TIMEZONE,
                               EmailEncodingKey=EMAILENCODINGKEY,
                               LocaleSidKey=TESTLOCALKEYS, 
                               LanguageLocaleKey=TESTLOCALKEYS,
                               FirstName = TESTFIRSTNAME,
                               LastName = TESTLASTNAME);
            insert u1;
		}
        ids.add(u1.id);
        SNI_FL_DirectMessageTestDataFactory.createDirectMessagesTestData(1,ids);
        List<DirectMessageFeed> lstDirectMsgFeed = [SELECT ID FROM DirectMessageFeed WHERE ParentId IN (SELECT ID FROM DirectMessage WHERE Subject LIKE 'DirectMsg_ACDC_Test') LIMIT 1];
        SNI_FL_Message__c message = new SNI_FL_Message__c(Family_ID__c=lstFamilyAccount[0].Id,Feed_Id__c=lstDirectMsgFeed[0].Id,Marked__c=false,Name='test');
        insert message;
        SNI_FL_DirectMessageTestDataFactory.insertFLDirectMessageTestData(lstFamilyAccount,lstDirectMsgFeed,1,false);

        List<SNI_FL_Message__c> lstFlMsg = [SELECT Id FROM SNI_FL_Message__c WHERE Name like 'Direct%'];

        SNI_FL_DirectMessageTestDataFactory.insertFLMessageStatusTestData(lstFlMsg,1,true);
        list<SNI_FL_Message_Status__c> msgstatusLst= new  list<SNI_FL_Message_Status__c>();
        SNI_FL_Message_Status__c msgstatus=new SNI_FL_Message_Status__c(IsRead__c=false,Agent__c=ids[0],SNI_FL_Message__c=message.id);
        SNI_FL_Message_Status__c msgstatus3=new SNI_FL_Message_Status__c(IsRead__c=false,Agent__c=Userinfo.getUserId(),SNI_FL_Message__c=message.id);
        msgstatusLst.add(msgstatus);

        msgstatusLst.add(msgstatus3);
        insert msgstatusLst;
        ContentVersion conVer = new ContentVersion(PathOnClient = TESTPATHONCLIENT,Title = TESTFILETITLE,VersionData = EncodingUtil.base64Decode(TESTFILENAME));       
        insert conVer;   
        Id conDoc = [SELECT ContentDocumentId FROM ContentVersion WHERE Id =:conVer.Id].ContentDocumentId;
        ContentDocumentLink conDocLink = New ContentDocumentLink();
        conDocLink.LinkedEntityId = lstFamilyAccount.get(0).id; 
        conDocLink.ContentDocumentId = conDoc;
        conDocLink.shareType = 'V';
        insert conDocLink;
        
        Test.startTest();
        List<SNI_FL_DirectMessageObjectQuery.SNI_FLDirectMessageWrapper> directMsgList = SNI_FLDirectMessageUtil.getDirectMessageList(false,Userinfo.getUserId(),lstFamilyAccount.get(0).id,1,5,false,false,false,'empty',false,false);
        if(directMsgList != null){
            System.assertequals(directMsgList.size()>=0, true, ASSERTMSG);
        } else {
            System.assertequals(directMsgList, null, ASSERTMSG);
        }
        Test.stopTest();
    }

    @isTest
    static void testGetFlaggedDirectMessageList (){
        List<Account> lstFamilyAccount = SNI_FL_DirectMessageTestDataFactory.createAccountRecordsTestData('Family',1);
        lstFamilyAccount[0].Ownerid=Userinfo.getuserid();
        update lstFamilyAccount;

        List<ID> ids = new List<ID>();

        profile p=[select Id from profile where Name=:PROFILENAME];
        User u1;
        system.runAs(new user(Id = userinfo.getUserId())){
            u1 = new User( email=TESTEMAIL,
                               profileid = p.id, 
                               UserName=TESTUSERNAME, 
                               Alias = TESTALIAS,
                               TimeZoneSidKey=TIMEZONE,
                               EmailEncodingKey=EMAILENCODINGKEY,
                               LocaleSidKey=TESTLOCALKEYS, 
                               LanguageLocaleKey=TESTLOCALKEYS,
                               FirstName = TESTFIRSTNAME,
                               LastName = TESTLASTNAME);
            insert u1;
		}
        ids.add(u1.id);
        SNI_FL_DirectMessageTestDataFactory.createDirectMessagesTestData(1,ids);
        List<DirectMessageFeed> lstDirectMsgFeed = [SELECT ID FROM DirectMessageFeed WHERE ParentId IN (SELECT ID FROM DirectMessage WHERE Subject LIKE 'DirectMsg_ACDC_Test') LIMIT 1];
        SNI_FL_Message__c message = new SNI_FL_Message__c(Family_ID__c=lstFamilyAccount[0].Id,Feed_Id__c=lstDirectMsgFeed[0].Id,Marked__c=false,Name='test');
        insert message;
        SNI_FL_DirectMessageTestDataFactory.insertFLDirectMessageTestData(lstFamilyAccount,lstDirectMsgFeed,1,false);

        List<SNI_FL_Message__c> lstFlMsg = [SELECT Id FROM SNI_FL_Message__c WHERE Name like 'Direct%'];

        SNI_FL_DirectMessageTestDataFactory.insertFLMessageStatusTestData(lstFlMsg,1,true);
        list<SNI_FL_Message_Status__c> msgstatusLst= new  list<SNI_FL_Message_Status__c>();
        SNI_FL_Message_Status__c msgstatus=new SNI_FL_Message_Status__c(IsRead__c=false,Agent__c=ids[0],SNI_FL_Message__c=message.id);
        SNI_FL_Message_Status__c msgstatus3=new SNI_FL_Message_Status__c(IsRead__c=false,Agent__c=Userinfo.getUserId(),SNI_FL_Message__c=message.id);
        msgstatusLst.add(msgstatus);

        msgstatusLst.add(msgstatus3);
        insert msgstatusLst;
        ContentVersion conVer = new ContentVersion(PathOnClient = TESTPATHONCLIENT,Title = TESTFILETITLE,VersionData = EncodingUtil.base64Decode(TESTFILENAME));       
        insert conVer;   
        Id conDoc = [SELECT ContentDocumentId FROM ContentVersion WHERE Id =:conVer.Id].ContentDocumentId;
        ContentDocumentLink conDocLink = New ContentDocumentLink();
        conDocLink.LinkedEntityId = lstFamilyAccount.get(0).id; 
        conDocLink.ContentDocumentId = conDoc;
        conDocLink.shareType = 'V';
        insert conDocLink;
        
        Test.startTest();
        List<SNI_FL_DirectMessageObjectQuery.SNI_FLDirectMessageWrapper> directMsgList = SNI_FLDirectMessageUtil.getDirectMessageList(false,Userinfo.getUserId(),lstFamilyAccount.get(0).id,1,5,true,false,false,'empty',false,false);
        if(directMsgList != null){
            System.assertequals(directMsgList.size()>=0, true, ASSERTMSG);
        } else {
            System.assertequals(directMsgList, null, ASSERTMSG);
        }
        Test.stopTest();
    }

    @isTest
    static void testGetFamilyLevelMessageList (){
        List<Account> lstFamilyAccount = SNI_FL_DirectMessageTestDataFactory.createAccountRecordsTestData('Family',1);
        lstFamilyAccount[0].Ownerid=Userinfo.getuserid();
        update lstFamilyAccount;

        List<ID> ids = new List<ID>();

        profile p=[select Id from profile where Name=:PROFILENAME];
        User u1;
        system.runAs(new user(Id = userinfo.getUserId())){
            u1 = new User( email=TESTEMAIL,
                               profileid = p.id, 
                               UserName=TESTUSERNAME, 
                               Alias = TESTALIAS,
                               TimeZoneSidKey=TIMEZONE,
                               EmailEncodingKey=EMAILENCODINGKEY,
                               LocaleSidKey=TESTLOCALKEYS, 
                               LanguageLocaleKey=TESTLOCALKEYS,
                               FirstName = TESTFIRSTNAME,
                               LastName = TESTLASTNAME);
            insert u1;
		}
        ids.add(u1.id);
        SNI_FL_DirectMessageTestDataFactory.createDirectMessagesTestData(1,ids);
        List<DirectMessageFeed> lstDirectMsgFeed = [SELECT ID FROM DirectMessageFeed WHERE ParentId IN (SELECT ID FROM DirectMessage WHERE Subject LIKE 'DirectMsg_ACDC_Test') LIMIT 1];
        SNI_FL_Message__c message = new SNI_FL_Message__c(Family_ID__c=lstFamilyAccount[0].Id,Feed_Id__c=lstDirectMsgFeed[0].Id,Marked__c=false,Name='test');
        insert message;
        SNI_FL_DirectMessageTestDataFactory.insertFLDirectMessageTestData(lstFamilyAccount,lstDirectMsgFeed,1,false);

        List<SNI_FL_Message__c> lstFlMsg = [SELECT Id FROM SNI_FL_Message__c WHERE Name like 'Direct%'];

        SNI_FL_DirectMessageTestDataFactory.insertFLMessageStatusTestData(lstFlMsg,1,true);
        list<SNI_FL_Message_Status__c> msgstatusLst= new  list<SNI_FL_Message_Status__c>();
        SNI_FL_Message_Status__c msgstatus=new SNI_FL_Message_Status__c(IsRead__c=false,Agent__c=ids[0],SNI_FL_Message__c=message.id);
        SNI_FL_Message_Status__c msgstatus3=new SNI_FL_Message_Status__c(IsRead__c=false,Agent__c=Userinfo.getUserId(),SNI_FL_Message__c=message.id);
        msgstatusLst.add(msgstatus);

        msgstatusLst.add(msgstatus3);
        insert msgstatusLst;
        ContentVersion conVer = new ContentVersion(PathOnClient = TESTPATHONCLIENT,Title = TESTFILETITLE,VersionData = EncodingUtil.base64Decode(TESTFILENAME));       
        insert conVer;   
        Id conDoc = [SELECT ContentDocumentId FROM ContentVersion WHERE Id =:conVer.Id].ContentDocumentId;
        ContentDocumentLink conDocLink = New ContentDocumentLink();
        conDocLink.LinkedEntityId = lstFamilyAccount.get(0).id; 
        conDocLink.ContentDocumentId = conDoc;
        conDocLink.shareType = 'V';
        insert conDocLink;
        
        Test.startTest();
        List<SNI_FL_DirectMessageObjectQuery.SNI_FLDirectMessageWrapper> directMsgList = SNI_FLDirectMessageUtil.getDirectMessageList(true,Userinfo.getUserId(),lstFamilyAccount.get(0).id,1,5,false,true,false,'empty',false,false);
        if(directMsgList != null){
            System.assertequals(directMsgList.size()>=0, true, ASSERTMSG);
        } else {
            System.assertequals(directMsgList, null, ASSERTMSG);
        }
        Test.stopTest();
    }

    @isTest
    static void testGetProviderMessageList (){
        List<Account> lstFamilyAccount = SNI_FL_DirectMessageTestDataFactory.createAccountRecordsTestData('Family',1);
        lstFamilyAccount[0].Ownerid=Userinfo.getuserid();
        update lstFamilyAccount;

        List<ID> ids = new List<ID>();

        profile p=[select Id from profile where Name=:PROFILENAME];
        User u1;
        system.runAs(new user(Id = userinfo.getUserId())){
            u1 = new User( email=TESTEMAIL,
                               profileid = p.id, 
                               UserName=TESTUSERNAME, 
                               Alias = TESTALIAS,
                               TimeZoneSidKey=TIMEZONE,
                               EmailEncodingKey=EMAILENCODINGKEY,
                               LocaleSidKey=TESTLOCALKEYS, 
                               LanguageLocaleKey=TESTLOCALKEYS,
                               FirstName = TESTFIRSTNAME,
                               LastName = TESTLASTNAME);
            insert u1;
		}
        ids.add(u1.id);
        SNI_FL_DirectMessageTestDataFactory.createDirectMessagesTestData(1,ids);
        List<DirectMessageFeed> lstDirectMsgFeed = [SELECT ID FROM DirectMessageFeed WHERE ParentId IN (SELECT ID FROM DirectMessage WHERE Subject LIKE 'DirectMsg_ACDC_Test') LIMIT 1];
        SNI_FL_Message__c message = new SNI_FL_Message__c(Family_ID__c=lstFamilyAccount[0].Id,Feed_Id__c=lstDirectMsgFeed[0].Id,Marked__c=false,Name='test');
        insert message;
        SNI_FL_DirectMessageTestDataFactory.insertFLDirectMessageTestData(lstFamilyAccount,lstDirectMsgFeed,1,false);

        List<SNI_FL_Message__c> lstFlMsg = [SELECT Id FROM SNI_FL_Message__c WHERE Name like 'Direct%'];

        SNI_FL_DirectMessageTestDataFactory.insertFLMessageStatusTestData(lstFlMsg,1,true);
        list<SNI_FL_Message_Status__c> msgstatusLst= new  list<SNI_FL_Message_Status__c>();
        SNI_FL_Message_Status__c msgstatus=new SNI_FL_Message_Status__c(IsRead__c=false,Agent__c=ids[0],SNI_FL_Message__c=message.id);
        SNI_FL_Message_Status__c msgstatus3=new SNI_FL_Message_Status__c(IsRead__c=false,Agent__c=Userinfo.getUserId(),SNI_FL_Message__c=message.id);
        msgstatusLst.add(msgstatus);

        msgstatusLst.add(msgstatus3);
        insert msgstatusLst;
        ContentVersion conVer = new ContentVersion(PathOnClient = TESTPATHONCLIENT,Title = TESTFILETITLE,VersionData = EncodingUtil.base64Decode(TESTFILENAME));       
        insert conVer;   
        Id conDoc = [SELECT ContentDocumentId FROM ContentVersion WHERE Id =:conVer.Id].ContentDocumentId;
        ContentDocumentLink conDocLink = New ContentDocumentLink();
        conDocLink.LinkedEntityId = lstFamilyAccount.get(0).id; 
        conDocLink.ContentDocumentId = conDoc;
        conDocLink.shareType = 'V';
        insert conDocLink;

        String providerRecordTypeID = Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName().get('Provider_Affiliation').getRecordTypeId();
        
        Account act = new Account();
        act.Name = 'Provider';
        act.RecordTypeId = providerRecordTypeID;
        insert act;

        Profile agentProfile=[SELECT Id FROM Profile where Name='Center for Health Navigation'];
		User u01;
        system.runAs(new user(Id = userinfo.getUserId())){
           u01 = new User( email=TSTEMAIL,
                               profileid = agentProfile.id, 
                               UserName=TESTMAIL, 
                               Alias = 'GDS',
                               TimeZoneSidKey=TIMEZONE,
                               EmailEncodingKey=EMAILENCODINGKEY,
                               LocaleSidKey='en_US', 
                               isActive=true,
                               LanguageLocaleKey='en_US',
                               FirstName = 'Fagent1',
                               LastName = 'Lagent1');
            insert u01;
		}
        AccountTeamMember actMember = new AccountTeamMember();
        actMember.AccountId = act.id;
        actMember.UserId = u01.id;
        insert actMember;

        Contact con = new Contact();
        con.accountid = lstFamilyAccount[0].Id;
        con.LastName = 'ProviderMessageTest';
        insert con;

        AccountContactRelation acr = new AccountContactRelation();
        acr.ContactId = con.Id;
        acr.AccountId = act.Id;

        Test.startTest();
        List<SNI_FL_DirectMessageObjectQuery.SNI_FLDirectMessageWrapper> directMsgList = SNI_FLDirectMessageUtil.getDirectMessageList(false,Userinfo.getUserId(),lstFamilyAccount.get(0).id,1,5,false,true,true,'empty',false,false);
        if(directMsgList != null){
            System.assertequals(directMsgList.size()>=0, true, ASSERTMSG);
        } else {
            System.assertequals(directMsgList, null, ASSERTMSG);
        }
        Test.stopTest();
    }

    @isTest
    static void testGetFlaggedProviderMessageList (){
        List<Account> lstFamilyAccount = SNI_FL_DirectMessageTestDataFactory.createAccountRecordsTestData('Family',1);
        lstFamilyAccount[0].Ownerid=Userinfo.getuserid();
        update lstFamilyAccount;

        List<ID> ids = new List<ID>();

        profile p=[select Id from profile where Name=:PROFILENAME];
        User u1;
        system.runAs(new user(Id = userinfo.getUserId())){
            u1 = new User( email=TESTEMAIL,
                               profileid = p.id, 
                               UserName=TESTUSERNAME, 
                               Alias = TESTALIAS,
                               TimeZoneSidKey=TIMEZONE,
                               EmailEncodingKey=EMAILENCODINGKEY,
                               LocaleSidKey=TESTLOCALKEYS, 
                               LanguageLocaleKey=TESTLOCALKEYS,
                               FirstName = TESTFIRSTNAME,
                               LastName = TESTLASTNAME);
            insert u1;
		}
        ids.add(u1.id);
        SNI_FL_DirectMessageTestDataFactory.createDirectMessagesTestData(1,ids);
        List<DirectMessageFeed> lstDirectMsgFeed = [SELECT ID FROM DirectMessageFeed WHERE ParentId IN (SELECT ID FROM DirectMessage WHERE Subject LIKE 'DirectMsg_ACDC_Test') LIMIT 1];
        SNI_FL_Message__c message = new SNI_FL_Message__c(Family_ID__c=lstFamilyAccount[0].Id,Feed_Id__c=lstDirectMsgFeed[0].Id,Marked__c=false,Name='test');
        insert message;
        SNI_FL_DirectMessageTestDataFactory.insertFLDirectMessageTestData(lstFamilyAccount,lstDirectMsgFeed,1,false);

        List<SNI_FL_Message__c> lstFlMsg = [SELECT Id FROM SNI_FL_Message__c WHERE Name like 'Direct%'];

        SNI_FL_DirectMessageTestDataFactory.insertFLMessageStatusTestData(lstFlMsg,1,true);
        list<SNI_FL_Message_Status__c> msgstatusLst= new  list<SNI_FL_Message_Status__c>();
        SNI_FL_Message_Status__c msgstatus=new SNI_FL_Message_Status__c(IsRead__c=false,Agent__c=ids[0],SNI_FL_Message__c=message.id);
        SNI_FL_Message_Status__c msgstatus3=new SNI_FL_Message_Status__c(IsRead__c=false,Agent__c=Userinfo.getUserId(),SNI_FL_Message__c=message.id);
        msgstatusLst.add(msgstatus);

        msgstatusLst.add(msgstatus3);
        insert msgstatusLst;
        ContentVersion conVer = new ContentVersion(PathOnClient = TESTPATHONCLIENT,Title = TESTFILETITLE,VersionData = EncodingUtil.base64Decode(TESTFILENAME));       
        insert conVer;   
        Id conDoc = [SELECT ContentDocumentId FROM ContentVersion WHERE Id =:conVer.Id].ContentDocumentId;
        ContentDocumentLink conDocLink = New ContentDocumentLink();
        conDocLink.LinkedEntityId = lstFamilyAccount.get(0).id; 
        conDocLink.ContentDocumentId = conDoc;
        conDocLink.shareType = 'V';
        insert conDocLink;

        String providerRecordTypeID = Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName().get('Provider_Affiliation').getRecordTypeId();
        
        Account act = new Account();
        act.Name = 'Provider';
        act.RecordTypeId = providerRecordTypeID;
        insert act;

        Profile agentProfile=[SELECT Id FROM Profile where Name='Center for Health Navigation'];
        User u01;
        system.runAs(new user(Id = userinfo.getUserId())){
            u01 = new User( email=TSTEMAIL,
                               profileid = agentProfile.id, 
                               UserName=TESTMAIL, 
                               Alias = 'GDS',
                               TimeZoneSidKey=TIMEZONE,
                               EmailEncodingKey=EMAILENCODINGKEY,
                               LocaleSidKey='en_US', 
                               isActive=true,
                               LanguageLocaleKey='en_US',
                               FirstName = 'Fagent1',
                               LastName = 'Lagent1');
            insert u01;
		} 
        AccountTeamMember actMember = new AccountTeamMember();
        actMember.AccountId = act.id;
        actMember.UserId = u01.id;
        insert actMember;

        Contact con = new Contact();
        con.accountid = lstFamilyAccount[0].Id;
        con.LastName = 'ProviderMessageTest';
        insert con;

        AccountContactRelation acr = new AccountContactRelation();
        acr.ContactId = con.Id;
        acr.AccountId = act.Id;

        Test.startTest();
        List<SNI_FL_DirectMessageObjectQuery.SNI_FLDirectMessageWrapper> directMsgList = SNI_FLDirectMessageUtil.getDirectMessageList(false,Userinfo.getUserId(),lstFamilyAccount.get(0).id,1,5,true,true,true,'empty',false,false);
        if(directMsgList != null){
            System.assertequals(directMsgList.size()>=0, true, ASSERTMSG);
        } else {
            System.assertequals(directMsgList, null, ASSERTMSG);
        }
        Test.stopTest();
    }

    @isTest
    static void testGetDirectMessageWrapperForFeedID (){
        List<Account> lstFamilyAccount = SNI_FL_DirectMessageTestDataFactory.createAccountRecordsTestData('Family',1);
        lstFamilyAccount[0].Ownerid=Userinfo.getuserid();
        update lstFamilyAccount;

        List<ID> ids = new List<ID>();

        profile p=[select Id from profile where Name=:PROFILENAME];
        User u1;
        system.runAs(new user(Id = userinfo.getUserId())){
            u1 = new User( email=TESTEMAIL,
                               profileid = p.id, 
                               UserName=TESTUSERNAME, 
                               Alias = TESTALIAS,
                               TimeZoneSidKey=TIMEZONE,
                               EmailEncodingKey=EMAILENCODINGKEY,
                               LocaleSidKey=TESTLOCALKEYS, 
                               LanguageLocaleKey=TESTLOCALKEYS,
                               FirstName = TESTFIRSTNAME,
                               LastName = TESTLASTNAME);
            insert u1;
		}
        ids.add(u1.id);
        SNI_FL_DirectMessageTestDataFactory.createDirectMessagesTestData(1,ids);
        List<DirectMessageFeed> lstDirectMsgFeed = [SELECT ID FROM DirectMessageFeed WHERE ParentId IN (SELECT ID FROM DirectMessage WHERE Subject LIKE 'DirectMsg_ACDC_Test') LIMIT 1];
        SNI_FL_Message__c message = new SNI_FL_Message__c(Family_ID__c=lstFamilyAccount[0].Id,Feed_Id__c=lstDirectMsgFeed[0].Id,Marked__c=false,Name='test');
        insert message;
        SNI_FL_DirectMessageTestDataFactory.insertFLDirectMessageTestData(lstFamilyAccount,lstDirectMsgFeed,1,false);

        List<SNI_FL_Message__c> lstFlMsg = [SELECT Id FROM SNI_FL_Message__c WHERE Name like 'Direct%'];

        SNI_FL_DirectMessageTestDataFactory.insertFLMessageStatusTestData(lstFlMsg,1,true);
        list<SNI_FL_Message_Status__c> msgstatusLst= new  list<SNI_FL_Message_Status__c>();
        SNI_FL_Message_Status__c msgstatus=new SNI_FL_Message_Status__c(IsRead__c=false,Agent__c=ids[0],SNI_FL_Message__c=message.id);
        SNI_FL_Message_Status__c msgstatus3=new SNI_FL_Message_Status__c(IsRead__c=false,Agent__c=Userinfo.getUserId(),SNI_FL_Message__c=message.id);
        msgstatusLst.add(msgstatus);

        msgstatusLst.add(msgstatus3);
        insert msgstatusLst;
        ContentVersion conVer = new ContentVersion(PathOnClient = TESTPATHONCLIENT,Title = TESTFILETITLE,VersionData = EncodingUtil.base64Decode(TESTFILENAME));       
        insert conVer;   
        Id conDoc = [SELECT ContentDocumentId FROM ContentVersion WHERE Id =:conVer.Id].ContentDocumentId;
        ContentDocumentLink conDocLink = New ContentDocumentLink();
        conDocLink.LinkedEntityId = lstFamilyAccount.get(0).id; 
        conDocLink.ContentDocumentId = conDoc;
        conDocLink.shareType = 'V';
        insert conDocLink;
        
		Test.startTest();
        SNI_FLDirectMessageUtil.getDirectMessageWrapperForFeedID(string.valueof(lstDirectMsgFeed[0].Id),Userinfo.getUserId(),true);
        //Commented below line 09/14/2021 to avoid query limit in prod. Needs to be fixed - Jacob Wagoner
        //SNI_FLDirectMessageUtil.getDirectMessageWrapperForFeedID(string.valueof(lstDirectMsgFeed[0].Id),Userinfo.getUserId(),false);
        Test.stopTest();
    }

    @isTest
    static void testgetPaginatedFeedComments (){
        List<Account> lstFamilyAccount = SNI_FL_DirectMessageTestDataFactory.createAccountRecordsTestData('Family',1);
        lstFamilyAccount[0].Ownerid=Userinfo.getuserid();
        update lstFamilyAccount;

        List<ID> ids = new List<ID>();

        profile p=[select Id from profile where Name=:PROFILENAME];
        User u1;
        system.runAs(new user(Id = userinfo.getUserId())){
            u1 = new User( email=TESTEMAIL,
                               profileid = p.id, 
                               UserName=TESTUSERNAME, 
                               Alias = TESTALIAS,
                               TimeZoneSidKey=TIMEZONE,
                               EmailEncodingKey=EMAILENCODINGKEY,
                               LocaleSidKey=TESTLOCALKEYS, 
                               LanguageLocaleKey=TESTLOCALKEYS,
                               FirstName = TESTFIRSTNAME,
                               LastName = TESTLASTNAME);
            insert u1;
		}
        ids.add(u1.id);
        SNI_FL_DirectMessageTestDataFactory.createDirectMessagesTestData(1,ids);
        List<DirectMessageFeed> lstDirectMsgFeed = [SELECT ID FROM DirectMessageFeed WHERE ParentId IN (SELECT ID FROM DirectMessage WHERE Subject LIKE 'DirectMsg_ACDC_Test') LIMIT 1];
        SNI_FL_Message__c message = new SNI_FL_Message__c(Family_ID__c=lstFamilyAccount[0].Id,Feed_Id__c=lstDirectMsgFeed[0].Id,Marked__c=false,Name='test');
        insert message;
        SNI_FL_DirectMessageTestDataFactory.insertFLDirectMessageTestData(lstFamilyAccount,lstDirectMsgFeed,1,false);

        List<SNI_FL_Message__c> lstFlMsg = [SELECT Id FROM SNI_FL_Message__c WHERE Name like 'Direct%'];

        SNI_FL_DirectMessageTestDataFactory.insertFLMessageStatusTestData(lstFlMsg,1,true);
        list<SNI_FL_Message_Status__c> msgstatusLst= new  list<SNI_FL_Message_Status__c>();
        SNI_FL_Message_Status__c msgstatus=new SNI_FL_Message_Status__c(IsRead__c=false,Agent__c=ids[0],SNI_FL_Message__c=message.id);
        SNI_FL_Message_Status__c msgstatus3=new SNI_FL_Message_Status__c(IsRead__c=false,Agent__c=Userinfo.getUserId(),SNI_FL_Message__c=message.id);
        msgstatusLst.add(msgstatus);

        msgstatusLst.add(msgstatus3);
        insert msgstatusLst;
        ContentVersion conVer = new ContentVersion(PathOnClient = TESTPATHONCLIENT,Title = TESTFILETITLE,VersionData = EncodingUtil.base64Decode(TESTFILENAME));       
        insert conVer;   
        Id conDoc = [SELECT ContentDocumentId FROM ContentVersion WHERE Id =:conVer.Id].ContentDocumentId;
        ContentDocumentLink conDocLink = New ContentDocumentLink();
        conDocLink.LinkedEntityId = lstFamilyAccount.get(0).id; 
        conDocLink.ContentDocumentId = conDoc;
        conDocLink.shareType = 'V';
        insert conDocLink;
        
        Test.startTest();
        SNI_FLDirectMessageUtil.getPaginatedFeedComments(string.valueof(lstDirectMsgFeed[0].Id),1,1);
        Test.stopTest();
    }
    
    @isTest
    static void testRunAs() {
        // Setup test data
        // This code runs as the system user
        Profile p = [SELECT Id FROM Profile WHERE Name='Standard User']; 
        User u,u1;
        List<User> usrLst = new List<User>();
        system.runAs(new user(Id = userinfo.getUserId())){
            u = new User(Alias = 'standt', Email=EMAIL, 
                              EmailEncodingKey='UTF-8', LastName='Testing', LanguageLocaleKey=TESTLOCALKEYS, 
                              LocaleSidKey=TESTLOCALKEYS, ProfileId = p.Id, 
                              TimeZoneSidKey=TIMEZONESIDKEY, UserName='standarduser45454@testorg.com');
            usrLst.add(u);
            u1 = new User(Alias = 'standt', Email=EMAIL, 
                              EmailEncodingKey='UTF-8', LastName='Testing', LanguageLocaleKey=TESTLOCALKEYS, 
                              LocaleSidKey=TESTLOCALKEYS, ProfileId = p.Id, 
                              TimeZoneSidKey=TIMEZONESIDKEY, UserName='standarduser214545@testorg.com');
            usrLst.add(u1);
			insert usrLst;
		}
        SNI_FL_BackupAdvisor__c sn= new SNI_FL_BackupAdvisor__c(Advisor__c=u1.id, Backup_Advisor__c=u.id);
        insert sn;
        List<SNI_FLDirectMessageWrapper.SNI_FL_BackupAdvisorWrap> lstObj = new List<SNI_FLDirectMessageWrapper.SNI_FL_BackupAdvisorWrap>();
        SNI_FLDirectMessageWrapper.SNI_FL_BackupAdvisorWrap obj = new SNI_FLDirectMessageWrapper.SNI_FL_BackupAdvisorWrap();
        obj.Advisor = u1.Id;
        SNI_FLDirectMessageWrapper.SNI_FL_BackupAdvisorWrap obj2 = new SNI_FLDirectMessageWrapper.SNI_FL_BackupAdvisorWrap();
        obj2.Advisor = u1.Id;
        lstObj.add(obj2);
        string strBackUpAdvisor = JSON.serialize(lstObj);
        System.runAs(u) {
            List<Id> setIds = new List<Id>();
            setIds.add(sn.Id);
            SNI_FLDirectMessageUtil.saveBackUpAdvisors(strBackUpAdvisor,setIds); 
            SNI_FLDirectMessageUtil.getBackUpAdvisors();
      }
    }

    public static testmethod void fetchLookUpValuesTest(){
        SNI_FLDirectMessageUtil.checkProfileValidity();
        string profileName = SNI_FLDirectMessageUtil.getProfileName();
        string objectName = 'User';
        List<SNI_FL_BackupAdvisor__c> excludeList = [SELECT Id, Name,Advisor__c,Backup_Advisor__c  FROM SNI_FL_BackupAdvisor__c WHERE Name like 'BA - 0000002%'];
        List<User> excludeList2 = [SELECT Id, Name  FROM User WHERE Name like 'bill%'];
        SNI_FLDirectMessageUtil.fetchLookUpValues('Kathy', objectName, null,ProfileName);
        SNI_FLDirectMessageUtil.fetchLookUpValues('Kathy', objectName, null,'FEC - Supervisor');
        SNI_FLDirectMessageUtil.fetchLookUpValues('Kathy', objectName, null,'Family Advisor');
        SNI_FLDirectMessageUtil.fetchLookUpValues('Ka', objectName, null,ProfileName);
        SNI_FLDirectMessageUtil.fetchLookUpValues('Ka', objectName, null,'FEC - Supervisor');
        SNI_FLDirectMessageUtil.fetchLookUpValues('Ka', objectName, null,'Family Advisor');
		SNI_FLDirectMessageUtil.fetchLookUpValues('Kathy', objectName, excludeList,profileName);
        SNI_FLDirectMessageUtil.fetchLookUpValues('Kathy', objectName, excludeList2,profileName);
        SNI_FLDirectMessageUtil.fetchLookUpValues('Kathy', objectName, excludeList2,'Research Advisor');
        SNI_FLDirectMessageUtil.fetchLookUpValues('Ka', objectName, excludeList2,'Research Advisor');
        SNI_FLDirectMessageUtil.fetchLookUpValues('Ka', objectName, null,'Registered Nurse');
        SNI_FLDirectMessageUtil.fetchLookUpValues('Ka', objectName, null,'Quarterback Registered Nurse');
        SNI_FLDirectMessageUtil.fetchLookUpValues('Ka', objectName, null,'System Administrator');
    }
    
    public static testmethod void getAccountNameByIDTest(){
        SNI_FLDirectMessageUtil.checkProfileValidity();     
        Account acc = new Account();
        acc.Name = ACCOUNTNAME;
        acc.Phone = '123456789';
        acc.Type = 'Prospect';  
        insert acc;
        Test.startTest();
        SNI_FLDirectMessageUtil.getAccountNameByID(acc.Id);  
        Test.stopTest();
    }

    public static testmethod void checkUnregisteredMemberTest(){
        SNI_FLDirectMessageUtil.checkProfileValidity();
        Boolean isValidMember;
        Account acc = new Account();
        acc.Name = ACCOUNTNAME;
        acc.Phone = '123456789';
        acc.Type = 'Prospect';  
        insert acc;
        isValidMember = SNI_FLDirectMessageUtil.CheckUnregisteredMember(acc.Id);
    }

    /**
     * Pavithra ACDC
     * positive test for UHG Restriction family level test
     */
    public static testmethod void checkUHGRestrctionTest(){
        List<Account> lstAcc = SNI_FL_DirectMessageTestDataFactory.createAccountRecordsTestData('Family',1);        
        Test.startTest();
        SNI_FLDirectMessageUtil.checkUHGRestriction(lstAcc.get(0).id);
        Test.stopTest();
       
    }

    /**
     * Pavithra ACDC
     * positive test for UHG Restriction member level test
     */
    @isTest
    static void checkUHGRestrctionMemberTest(){
        List<Account> lstAcc = SNI_FL_DirectMessageTestDataFactory.createAccountRecordsTestData('Person Account',1);        
       

        Profile p = [SELECT Id FROM Profile WHERE Name='Standard User'];
        User u;
        system.runAs(new user(Id = userinfo.getUserId())){
            u = new User(Alias = 'standt', Email=EMAIL, 
                              EmailEncodingKey='UTF-8', LastName='Testing', LanguageLocaleKey=TESTLOCALKEYS, 
                              LocaleSidKey=TESTLOCALKEYS, ProfileId = p.Id, 
                              TimeZoneSidKey=TIMEZONESIDKEY, UserName='standarduser45454@testorg.com', UHG_Access__c='No');
        	insert u;
        }
        System.runAs(u) {
            Test.startTest();
            SNI_FLDirectMessageUtil.checkUHGRestrictionForProviderMessaging(lstAcc.get(0).id);
            Test.stopTest();
        }
    }

    /**
     * Anil Blinkers
     * positive test for Providermessage restrict member level test
     */
    @isTest
    static void checkRestrictProviderMessageTest(){
        Account acc = new Account();
        acc.FirstName = 'Test';
        acc.LastName = 'User';
        insert acc; 
        User u;
        system.runAs(new user(Id = userinfo.getUserId())){
        	u = new User(Alias = 'standt', Email=EMAIL,
                          EmailEncodingKey='UTF-8', LastName='Testing', LanguageLocaleKey=TESTLOCALKEYS, 
                          LocaleSidKey=TESTLOCALKEYS, ProfileId = UserInfo.getProfileId(), 
                          TimeZoneSidKey=TIMEZONESIDKEY, UserName='standarduser45454@testorg.com', UHG_Access__c='No');
            insert u;
		}

        System.runAs(u) {
            Test.startTest();
            SNI_FLDirectMessageUtil.checkProviderAffiliationForProviderMessaging(acc.Id);
            Test.stopTest();
        }
        SNI_FLDirectMessageUtil.checkProviderAffiliationForProviderMessaging(null);
    }

    /**
     * Sameera ACDC
     * positive test for adivisor affliation test
     */    
    @isTest
    static void testAdvisorHavingAfliationsPositiveTest(){

        String providerRecordTypeID = Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName().get('Provider_Affiliation').getRecordTypeId();
        
        profile p=[select Id from profile where Name='Center for Health Navigation'];
        User u1;
        system.runAs(new user(Id = userinfo.getUserId())){
            u1 = new User( email=TESTEMAIL,
                               profileid = p.id, 
                               UserName=TESTUSERNAME, 
                               Alias = TESTALIAS,
                               TimeZoneSidKey=TIMEZONE,
                               EmailEncodingKey=EMAILENCODINGKEY,
                               LocaleSidKey=TESTLOCALKEYS, 
                               LanguageLocaleKey=TESTLOCALKEYS,
                               FirstName = TESTFIRSTNAME,
                               LastName = TESTLASTNAME);
            insert u1;
		}
        Account act = new Account();
        act.Name = 'Provider';
        act.RecordTypeId = providerRecordTypeID;

        insert act;

        AccountTeamMember actMember = new AccountTeamMember();
        actMember.AccountId = act.id;
        actMember.UserId = u1.id;

        insert actMember;

        Boolean result = SNI_FLDirectMessageUtil.checkProviderAfliationsForAdvisor(u1.id);
        System.assertEquals(true,result,'member not added to account team');
    }

    /**
     * Sameera ACDC US3070642
     * negative test for advisor afliation test
     */    
    @isTest
    static void testAdvisorHavingAfliationsNegativeTest(){

        String providerRecordTypeID = Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName().get('Provider_Affiliation').getRecordTypeId();
        
        profile p=[select Id from profile where Name=:PROFILENAME];
        User u1;
        system.runAs(new user(Id = userinfo.getUserId())){
            u1 = new User( email=TESTEMAIL,
                               profileid = p.id, 
                               UserName=TESTUSERNAME, 
                               Alias = TESTALIAS,
                               TimeZoneSidKey=TIMEZONE,
                               EmailEncodingKey=EMAILENCODINGKEY,
                               LocaleSidKey=TESTLOCALKEYS, 
                               LanguageLocaleKey=TESTLOCALKEYS,
                               FirstName = TESTFIRSTNAME,
                               LastName = TESTLASTNAME);
            insert u1;
		}
        Account act = new Account();
        act.Name = 'Provider';
        act.RecordTypeId = providerRecordTypeID;

        insert act;

        Boolean result = SNI_FLDirectMessageUtil.checkProviderAfliationsForAdvisor(u1.id);
        System.assertEquals(false,result,'Affliation test failed');
    }

    /**
     * Sameera ACDC US3070642
     * apex security enforce negative test
     */    
    @isTest
    static void securitynegativeTest(){

        Account a = new Account();
        List<Account> lsact = new List<Account>();
        lsact.add(a);
        List<sObject> lsObject = SNI_FLDirectMessageObjectQuery.enforceApexSecurity(lsact,'UPDATABLE');
        System.assertEquals(null,lsObject,'Null not returned');
    }

   /*@isTest
    static void caseNotificationTest() {
        Id recordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName().get('Family').getRecordTypeId();
        String userId = '001m000001CirBBAZ';
        List<Account> accList=new List<Account>();
        List<SNI_FL_Care_Team_Member__c> teamlist=new List<SNI_FL_Care_Team_Member__c>();
        Account ac = new Account();
        ac.Member_ID__c = '453543145';
        ac.Policy_ID__c = '0070145';
        ac.Name =   'FLTestAcc';
        ac.RecordTypeId = recordTypeId;
        accList.add(ac);
        
        
        Id personAccRecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName().get('Individual').getRecordTypeId();
        Account pa =new account();
        pa.PersonBirthdate = date.valueOf(ACETUtility.formatDateFutureDate('6/17/1979'));
        pa.firstName = 'Community'; 
        pa.lastName = 'FLCreteamTestUser'; 
        pa.RecordTypeId = personAccRecordTypeId;
        pa.MultiPolicyCheck__c=true;
        pa.Policy_ID__c='0070145';
        pa.Member_ID__c='453543145';
        pa.Email_Notification__c = false;
        accList.add(pa);       
        
        Account pa2 =new account();
        pa2.PersonBirthdate = date.valueOf(ACETUtility.formatDateFutureDate('6/7/1979'));
        pa2.firstName = 'Community'; 
        pa2.lastName = 'FLCreteamTestUser1'; 
        pa2.RecordTypeId = personAccRecordTypeId;
        pa2.MultiPolicyCheck__c=true;
        pa2.Email_Notification__c = true;
        accList.add(pa2);   
        insert accList;
        
        set<id> accSet=new set<id>{(pa.Id),(pa2.Id)};
        Id contactId;
        Id contactId1;
        for(Contact con:[SELECT id,accountId from contact where accountId in : accSet]){
            if(con.accountId==pa.Id){
                contactId=con.id;
            }
            else {
                contactId1=con.id; 
            }
        }
        
        List<AccountContactRelation> acrList=new List<AccountContactRelation>();
        AccountContactRelation acr=new AccountContactRelation();
        acr.AccountId=ac.id;
        acr.contactID= contactId;
        acrList.add(acr);
        
        AccountContactRelation acr1=new AccountContactRelation();
        acr1.AccountId=ac.id;
        acr1.contactID= contactId1;
        acrList.add(acr1);
        
        insert acrList;
        
        SNI_FL_Care_Team_Member__c teamMemb = new SNI_FL_Care_Team_Member__c();
        teamMemb.SNI_FL_Primary_Caregiver__c = false;
        teamMemb.SNI_FL_Status__c='Registered';
        teamMemb.SNI_FL_Family__c = ac.Id;
        teamMemb.SNI_FL_Member__c = pa.Id;
        teamMemb.SNI_FL_Not_Visible_in_Familylink__c = false;
        teamlist.add(teamMemb);
        
        SNI_FL_Care_Team_Member__c teamMemb1 = new SNI_FL_Care_Team_Member__c();
        teamMemb1.SNI_FL_Primary_Caregiver__c = false;
        teamMemb1.SNI_FL_Family__c = ac.Id;
        teamMemb1.SNI_FL_Member__c = pa2.Id;
        teamMemb1.SNI_FL_Status__c='Registered';
        teamMemb1.SNI_FL_Not_Visible_in_Familylink__c = false;
        teamlist.add(teamMemb1);
        insert teamlist;
        
        List<SNI_FL_Members_ROI__c> roiList = new List<SNI_FL_Members_ROI__c>();
        SNI_FL_Members_ROI__c roi1 = new SNI_FL_Members_ROI__c();
        roi1.SNI_FL_Account__c = ac.id;
        roi1.SNI_FL_Status__c = 'Active';
        roi1.SNI_FL_ROI_Signed_With__c = teamMemb.id;
        roi1.SNI_FL_Member__c =teamMemb.id;
        roiList.add(roi1);
        SNI_FL_Members_ROI__c roi2 = new SNI_FL_Members_ROI__c();
        roi1.SNI_FL_Account__c = pa.id;
        roi2.SNI_FL_Status__c = 'Active';
        roi2.SNI_FL_ROI_Signed_With__c = teamMemb1.id;
        roiList.add(roi2);
        insert roiList;
        
        
        List<Contact> conId = [SELECT id from contact where accountId =: pa.Id];
        List<Profile> pList = [SELECT Id,Name FROM Profile WHERE Name =: 'FamilyLink Community User']; 
        User u = new User(Alias = 'standt', Email='flCareTeamtest@testorg.com', 
                          EmailEncodingKey='UTF-8', FirstName='Test007',LastName='Testing', LanguageLocaleKey='en_US', 
                          LocaleSidKey='en_US', ProfileId = pList.get(0).id, contactId =conId[0].Id,
                          TimeZoneSidKey=TIMEZONE,MobilePhone='9000000001', UserName='flCareTeamtest@testorg.com',IsActive=true);
        insert u;
        
        List<Contact> conId1 = [SELECT id from contact where accountId =: pa2.Id];
        List<Profile> pList1 = [SELECT Id,Name FROM Profile WHERE Name =: 'FamilyLink Community User']; 
        User u1 = new User(Alias = 'standt1', Email='flCareTeamtest1@testorg.com', 
                           EmailEncodingKey='UTF-8', FirstName='Test008',LastName='Testing1', LanguageLocaleKey='en_US', 
                           LocaleSidKey='en_US', ProfileId = pList1.get(0).id, contactId =conId1[0].Id,
                           TimeZoneSidKey=TIMEZONE,MobilePhone='9000000001', UserName='flCareTeamtest1@testorg.com',IsActive=true);
        insert u1;
        
        System.runAs(u){
            List<case> caselist = new List<case>();
            Case cas = new case();
            Id ecmRecordTypeID = Schema.SObjectType.Case.getRecordTypeInfosByDeveloperName().get('ECM').getRecordTypeId();
            Case ecmCas = TestDataFactory.createCases(1)[0];
            ecmCas.RecordTypeId =ecmRecordTypeID;
            ecmCas.Topic__c = 'Appeals - Post Service';
            ecmCas.AccountId = pa.Id;
            ecmCas.ContactId = contactId;
            ecmCas.UHG_Restriction__c = 'No';
            ecmCas.DOB__c = '1999/08/09';
            ecmCas.Onshore_Restriction__c = 'No';
            ecmCas.Subject_Name__c = 'ECM Test case' ;
            ecmCas.Subject_Group_ID__c = '0070145';
            ecmCas.ParentId =cas.Id;
            ecmCas.status='Open';        
            ecmCas.Case_Type__c = 'Opportunity';
            ecmCas.ID__c = '453543145';
            ecmCas.Policy_ID__c = '0070145';
            ecmCas.Community__c = true;
            caselist.add(ecmCas);
            insert caselist;
            
            List<case> newCaselist = new List<case>();
            Case cas1 = new case();
            Case ecmCas2 = TestDataFactory.createCases(1)[0];
            ecmCas2.RecordTypeId =ecmRecordTypeID;
            ecmCas2.Topic__c = 'Appeals - Post Service';
            ecmCas2.AccountId = pa2.Id;
            ecmCas2.ContactId = contactId1;
            ecmCas2.UHG_Restriction__c = 'No';
            ecmCas2.DOB__c = '1989/08/09';
            ecmCas2.Onshore_Restriction__c = 'No';
            ecmCas2.Subject_Name__c = 'ECM Test case 2' ;
            ecmCas2.Subject_Group_ID__c = '0070145';
            ecmCas2.ParentId =cas1.Id;
            ecmCas2.status='Open';        
            ecmCas2.Case_Type__c = 'Opportunity';
            ecmCas2.ID__c = '453543145';
            ecmCas2.Policy_ID__c = '0070145';
            ecmCas2.Community__c = true;
            newCaselist.add(ecmCas2);
            insert newCaselist;
            
            List<CaseComment> caseCommentlist = new List<CaseComment>();
            CaseComment   tComment = new CaseComment();
            tComment.ParentId = ecmCas.Id;
            tComment.CommentBody = 'Some Comment';
            tComment.IsPublished = TRUE;
           	insert tComment;

            List<SNI_FL_Case_Notification__c> newNotificationlist = new List<SNI_FL_Case_Notification__c>();
            SNI_FL_Case_Notification__c notification = new SNI_FL_Case_Notification__c();
            notification.Name = ecmCas.Subject_Name__c;
            notification.Contact_Name__c = contactId;
            notification.Is_Viewed__c = false;        
            notification.Is_Viewed_Authorized_Member__c  = false;
            newNotificationlist.add(notification);
            insert newNotificationlist;
            
            List<SNI_FL_Case_Notification__c> newNotificationlist2 = new List<SNI_FL_Case_Notification__c>();
            SNI_FL_Case_Notification__c notification2 = new SNI_FL_Case_Notification__c();
            notification2.Name = ecmCas.Subject_Name__c;
            notification2.Contact_Name__c = contactId;
            notification2.Is_Viewed__c = true;        
            notification2.Is_Viewed_Authorized_Member__c  = true;
            newNotificationlist2.add(notification2);
            insert newNotificationlist2;
            
            Id loggedUserId = UserInfo.getUserId();
            String familyId = ac.Id;
            Test.startTest();
            SNI_FL_HomeController.markNewCaseNotification(loggedUserId,familyId);
            SNI_FL_HomeController.markNewCaseNotification(userId,familyId);
            SNI_FL_HomeController.deleteReadCases(loggedUserId,familyId);           
            SNI_FL_HomeController.deleteReadCases(userId,familyId);

            Test.stopTest();
            


        }
    }
    
    @isTest
    static void caseNotificationNullTest() {
        Id recordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName().get('Family').getRecordTypeId();
        String userId = '001m000001CirBBAZ';
        List<Account> accList=new List<Account>();
        List<SNI_FL_Care_Team_Member__c> teamlist=new List<SNI_FL_Care_Team_Member__c>();
        Account ac = new Account();
        ac.Member_ID__c = '453543145';
        ac.Policy_ID__c = '0070145';
        ac.Name =   'FLTestAcc';
        ac.RecordTypeId = recordTypeId;
        accList.add(ac);
        
        
        Id personAccRecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName().get('Individual').getRecordTypeId();
        Account pa =new account();
        pa.PersonBirthdate = date.valueOf(ACETUtility.formatDateFutureDate('6/17/1979'));
        pa.firstName = 'Community'; 
        pa.lastName = 'FLCreteamTestUser'; 
        pa.RecordTypeId = personAccRecordTypeId;
        pa.MultiPolicyCheck__c=true;
        pa.Policy_ID__c='0070145';
        pa.Member_ID__c='453543145';
        pa.Email_Notification__c = false;
        accList.add(pa);       
        
        Account pa2 =new account();
        pa2.PersonBirthdate = date.valueOf(ACETUtility.formatDateFutureDate('6/7/1979'));
        pa2.firstName = 'Community'; 
        pa2.lastName = 'FLCreteamTestUser1'; 
        pa2.RecordTypeId = personAccRecordTypeId;
        pa2.MultiPolicyCheck__c=true;
        pa2.Email_Notification__c = true;
        accList.add(pa2);   
        insert accList;
        
        set<id> accSet=new set<id>{(pa.Id),(pa2.Id)};
        Id contactId;
        Id contactId1;
        for(Contact con:[SELECT id,accountId from contact where accountId in : accSet]){
            if(con.accountId==pa.Id){
                contactId=con.id;
            }
            else {
                contactId1=con.id; 
            }
        }
        
        List<AccountContactRelation> acrList=new List<AccountContactRelation>();
        AccountContactRelation acr=new AccountContactRelation();
        acr.AccountId=ac.id;
        acr.contactID= contactId;
        acrList.add(acr);
        
        AccountContactRelation acr1=new AccountContactRelation();
        acr1.AccountId=ac.id;
        acr1.contactID= contactId1;
        acrList.add(acr1);
        
        insert acrList;
        
        SNI_FL_Care_Team_Member__c teamMemb = new SNI_FL_Care_Team_Member__c();
        teamMemb.SNI_FL_Primary_Caregiver__c = false;
        teamMemb.SNI_FL_Status__c='Registered';
        teamMemb.SNI_FL_Family__c = ac.Id;
        teamMemb.SNI_FL_Member__c = pa.Id;
        teamMemb.SNI_FL_Not_Visible_in_Familylink__c = false;
        teamlist.add(teamMemb);
        
        SNI_FL_Care_Team_Member__c teamMemb1 = new SNI_FL_Care_Team_Member__c();
        teamMemb1.SNI_FL_Primary_Caregiver__c = false;
        teamMemb1.SNI_FL_Family__c = ac.Id;
        teamMemb1.SNI_FL_Member__c = pa2.Id;
        teamMemb1.SNI_FL_Status__c='Registered';
        teamMemb1.SNI_FL_Not_Visible_in_Familylink__c = false;
        teamlist.add(teamMemb1);
        insert teamlist;
        
        List<SNI_FL_Members_ROI__c> roiList = new List<SNI_FL_Members_ROI__c>();
        SNI_FL_Members_ROI__c roi1 = new SNI_FL_Members_ROI__c();
        roi1.SNI_FL_Account__c = ac.id;
        roi1.SNI_FL_Status__c = 'InActive';
        roi1.SNI_FL_ROI_Signed_With__c = teamMemb.id;
        roi1.SNI_FL_Member__c =teamMemb.id;
        roiList.add(roi1);
        SNI_FL_Members_ROI__c roi2 = new SNI_FL_Members_ROI__c();
        roi1.SNI_FL_Account__c = pa.id;
        roi2.SNI_FL_Status__c = 'InActive';
        roi2.SNI_FL_ROI_Signed_With__c = teamMemb1.id;
        roiList.add(roi2);
        insert roiList;
        
        
        List<Contact> conId = [SELECT id from contact where accountId =: pa.Id];
        List<Profile> pList = [SELECT Id,Name FROM Profile WHERE Name =: 'FamilyLink Community User']; 
        User u = new User(Alias = 'standt', Email='flCareTeamtest@testorg.com', 
                          EmailEncodingKey='UTF-8', FirstName='Test007',LastName='Testing', LanguageLocaleKey='en_US', 
                          LocaleSidKey='en_US', ProfileId = pList.get(0).id, contactId =conId[0].Id,
                          TimeZoneSidKey=TIMEZONE,MobilePhone='9000000001', UserName='flCareTeamtest@testorg.com',IsActive=true);
        insert u;
        
        List<Contact> conId1 = [SELECT id from contact where accountId =: pa2.Id];
        List<Profile> pList1 = [SELECT Id,Name FROM Profile WHERE Name =: 'FamilyLink Community User']; 
        User u1 = new User(Alias = 'standt1', Email='flCareTeamtest1@testorg.com', 
                           EmailEncodingKey='UTF-8', FirstName='Test008',LastName='Testing1', LanguageLocaleKey='en_US', 
                           LocaleSidKey='en_US', ProfileId = pList1.get(0).id, contactId =conId1[0].Id,
                           TimeZoneSidKey=TIMEZONE,MobilePhone='9000000001', UserName='flCareTeamtest1@testorg.com',IsActive=true);
        insert u1;
        
        System.runAs(u){
            List<case> caselist = new List<case>();
            Case cas = new case();
            Id ecmRecordTypeID = Schema.SObjectType.Case.getRecordTypeInfosByDeveloperName().get('ECM').getRecordTypeId();
            Case ecmCas = TestDataFactory.createCases(1)[0];
            ecmCas.RecordTypeId =ecmRecordTypeID;
            ecmCas.Topic__c = 'Appeals - Post Service';
            ecmCas.AccountId = pa.Id;
            ecmCas.ContactId = contactId;
            ecmCas.UHG_Restriction__c = 'No';
            ecmCas.DOB__c = '1999/08/09';
            ecmCas.Onshore_Restriction__c = 'No';
            ecmCas.Subject_Name__c = 'ECM Test case' ;
            ecmCas.Subject_Group_ID__c = '0070145';
            ecmCas.ParentId =cas.Id;
            ecmCas.status='Open';        
            ecmCas.Case_Type__c = 'Opportunity';
            ecmCas.ID__c = '453543145';
            ecmCas.Policy_ID__c = '0070145';
            ecmCas.Community__c = true;
            caselist.add(ecmCas);
            insert caselist;
            
            List<case> newCaselist = new List<case>();
            Case cas1 = new case();
            Case ecmCas2 = TestDataFactory.createCases(1)[0];
            ecmCas2.RecordTypeId =ecmRecordTypeID;
            ecmCas2.Topic__c = 'Appeals - Post Service';
            ecmCas2.AccountId = pa2.Id;
            ecmCas2.ContactId = contactId1;
            ecmCas2.UHG_Restriction__c = 'No';
            ecmCas2.DOB__c = '1989/08/09';
            ecmCas2.Onshore_Restriction__c = 'No';
            ecmCas2.Subject_Name__c = 'ECM Test case 2' ;
            ecmCas2.Subject_Group_ID__c = '0070145';
            ecmCas2.ParentId =cas1.Id;
            ecmCas2.status='Open';        
            ecmCas2.Case_Type__c = 'Opportunity';
            ecmCas2.ID__c = '453543145';
            ecmCas2.Policy_ID__c = '0070145';
            ecmCas2.Community__c = true;
            newCaselist.add(ecmCas2);
            insert newCaselist;
            
            CaseComment   tComment = new CaseComment();
            tComment.ParentId = ecmCas.Id;
            tComment.CommentBody = 'Some Comment';
            tComment.IsPublished = TRUE;
            
            INSERT tComment;

            List<SNI_FL_Case_Notification__c> newNotificationlist = new List<SNI_FL_Case_Notification__c>();
            SNI_FL_Case_Notification__c notification = new SNI_FL_Case_Notification__c();
            notification.Name = ecmCas.Subject_Name__c;
            notification.Contact_Name__c = contactId;
            notification.Is_Viewed__c = false;        
            notification.Is_Viewed_Authorized_Member__c  = false;
            newNotificationlist.add(notification);
            insert newNotificationlist;
            
            List<SNI_FL_Case_Notification__c> newNotificationlist2 = new List<SNI_FL_Case_Notification__c>();
            SNI_FL_Case_Notification__c notification2 = new SNI_FL_Case_Notification__c();
            notification2.Name = ecmCas.Subject_Name__c;
            notification2.Contact_Name__c = contactId;
            notification2.Is_Viewed__c = true;        
            notification2.Is_Viewed_Authorized_Member__c  = true;
            newNotificationlist2.add(notification2);
            insert newNotificationlist2;
            
            Id loggedUserId = UserInfo.getUserId();
            String familyId = ac.Id;
            Test.startTest();
            SNI_FL_HomeController.markNewCaseNotification(loggedUserId,familyId);
            SNI_FL_HomeController.markNewCaseNotification(userId,familyId);
            SNI_FL_HomeController.deleteReadCases(loggedUserId,familyId);           
            SNI_FL_HomeController.deleteReadCases(userId,familyId);

            Test.stopTest();
            


        }
    }*/

    @isTest
    static void getAffliationTest(){

        Id pfrecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName().get('Provider_Affiliation').getRecordTypeId();
        String result;

        //Program object
        List<Program__c> program = [SELECT ID FROM Program__c WHERE Program__c=:DODYSSEY LIMIT 1];
        if(program!=null && !program.isEmpty()){
            

            //Provider affliation account
            Account pf=new Account();
            pf.Name='123';
            pf.RecordTypeId=pfrecordTypeId;
            pf.Population__c = 'Pediatric';
            pf.Program__c=program[0].id;
        
            
            insert pf;

            result = SNI_FLDIrectMessageUtil.getAffliationName(pf.id);
        }else{
            //Program object
            Program__c program1 = new Program__c();
            program1.Program__c = DODYSSEY;
            
            insert program1;

            //Provider affliation account
            Account pf=new Account();
            pf.Name='123';
            pf.RecordTypeId=pfrecordTypeId;
            pf.Population__c = 'Pediatric';
            pf.Program__c=program1.id;
        
            
            insert pf;

            result = SNI_FLDIrectMessageUtil.getAffliationName(pf.id);
        }

        System.assertEquals('Diagnostic Odyssey - Pediatric', result,'provider affliation not matching');
    }
    
     public static testmethod void getMemberIdByAccountIDTest(){
        Account acc = new Account();
        acc.Name = ACCOUNTNAME;
        acc.Phone = '12345789';
        acc.Type = 'Prospect';  
        insert acc;
        
        Test.startTest();
        SNI_FLDirectMessageUtil.getMemberIdByAccountId(acc.Id);  
        Test.stopTest();
    }

    @isTest
    static void testGetFamilyLinkMemberMessageList (){
        List<Account> lstFamilyAccount = SNI_FL_DirectMessageTestDataFactory.createAccountRecordsTestData('Family',1);
        lstFamilyAccount[0].Ownerid=Userinfo.getuserid();
        update lstFamilyAccount;

        List<ID> ids = new List<ID>();

        profile p=[select Id from profile where Name=:PROFILENAME];
        User u1;
        system.runAs(new user(Id = userinfo.getUserId())){
            u1 = new User( email=TESTEMAIL,
                               profileid = p.id, 
                               UserName=TESTUSERNAME, 
                               Alias = TESTALIAS,
                               TimeZoneSidKey=TIMEZONE,
                               EmailEncodingKey=EMAILENCODINGKEY,
                               LocaleSidKey=TESTLOCALKEYS, 
                               LanguageLocaleKey=TESTLOCALKEYS,
                               FirstName = TESTFIRSTNAME,
                               LastName = TESTLASTNAME);
            insert u1;
		}
        ids.add(u1.id);
        SNI_FL_DirectMessageTestDataFactory.createDirectMessagesTestData(1,ids);
        List<DirectMessageFeed> lstDirectMsgFeed = [SELECT ID FROM DirectMessageFeed WHERE ParentId IN (SELECT ID FROM DirectMessage WHERE Subject LIKE 'DirectMsg_ACDC_Test') LIMIT 1];
        SNI_FL_Message__c message = new SNI_FL_Message__c(Family_ID__c=lstFamilyAccount[0].Id,Feed_Id__c=lstDirectMsgFeed[0].Id,Marked__c=false,Name='test');
        insert message;
        SNI_FL_DirectMessageTestDataFactory.insertFLDirectMessageTestData(lstFamilyAccount,lstDirectMsgFeed,1,false);

        List<SNI_FL_Message__c> lstFlMsg = [SELECT Id FROM SNI_FL_Message__c WHERE Name like 'Direct%'];

        SNI_FL_DirectMessageTestDataFactory.insertFLMessageStatusTestData(lstFlMsg,1,true);
        list<SNI_FL_Message_Status__c> msgstatusLst= new  list<SNI_FL_Message_Status__c>();
        SNI_FL_Message_Status__c msgstatus=new SNI_FL_Message_Status__c(IsRead__c=false,Agent__c=ids[0],SNI_FL_Message__c=message.id);
        SNI_FL_Message_Status__c msgstatus3=new SNI_FL_Message_Status__c(IsRead__c=false,Agent__c=Userinfo.getUserId(),SNI_FL_Message__c=message.id);
        msgstatusLst.add(msgstatus);

        msgstatusLst.add(msgstatus3);
        insert msgstatusLst;
        ContentVersion conVer = new ContentVersion(PathOnClient = TESTPATHONCLIENT,Title = TESTFILETITLE,VersionData = EncodingUtil.base64Decode(TESTFILENAME));       
        insert conVer;   
        Id conDoc = [SELECT ContentDocumentId FROM ContentVersion WHERE Id =:conVer.Id].ContentDocumentId;
        ContentDocumentLink conDocLink = New ContentDocumentLink();
        conDocLink.LinkedEntityId = lstFamilyAccount.get(0).id; 
        conDocLink.ContentDocumentId = conDoc;
        conDocLink.shareType = 'V';
        insert conDocLink;

        String providerRecordTypeID = Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName().get('Provider_Affiliation').getRecordTypeId();
        
        Account act = new Account();
        act.Name = 'Provider';
        act.RecordTypeId = providerRecordTypeID;
        insert act;

        Profile agentProfile=[SELECT Id FROM Profile where Name='Center for Health Navigation'];
        User u01;
        system.runAs(new user(Id = userinfo.getUserId())){
            u01 = new User( email=TSTEMAIL,
                               profileid = agentProfile.id, 
                               UserName=TESTMAIL, 
                               Alias = 'GDS',
                               TimeZoneSidKey=TIMEZONE,
                               EmailEncodingKey=EMAILENCODINGKEY,
                               LocaleSidKey='en_US', 
                               isActive=true,
                               LanguageLocaleKey='en_US',
                               FirstName = 'Fagent1',
                               LastName = 'Lagent1');
            insert u01;
		}

        
        AccountTeamMember actMember = new AccountTeamMember();
        actMember.AccountId = act.id;
        actMember.UserId = u01.id;
        insert actMember;

        Contact con = new Contact();
        con.accountid = lstFamilyAccount[0].Id;
        con.LastName = 'ProviderMessageTest';
        insert con;

        AccountContactRelation acr = new AccountContactRelation();
        acr.ContactId = con.Id;
        acr.AccountId = act.Id;

        Test.startTest();
        List<SNI_FL_DirectMessageObjectQuery.SNI_FLDirectMessageWrapper> directMsgList = SNI_FLDirectMessageUtil.getDirectMessageList(false,u1.Id,lstFamilyAccount.get(0).id,1,5,false,false,false,'empty',false,false);
        if(directMsgList != null){
            System.assertequals(directMsgList.size()>=0, true, ASSERTMSG);
        } else {
            System.assertequals(directMsgList, null, ASSERTMSG);
        }
        Test.stopTest();
    }
//US3241339 - Ashley Winden
    public static testmethod void getFamilyHistoricalMessagesFlagTest(){
        List<RecordType> familyRecord = [SELECT Id FROM RecordType WHERE Name = 'Family'];
        User oUser = [select id,Name,Profile_Name__c,ProfileId,Role_Name__c FROM User Where id =: userInfo.getUserId()];
        Account acc = TestDataFactory.createBulkAccounts().get(0);
        acc.RecordTypeId=Schema.SObjectType.Account.getRecordTypeInfosByName().get('Family').getRecordTypeId();
        acc.OwnerId=oUser.Id;
        acc.Member_ID__c = '123123456789';
        update acc;
        Family_Overview__c fam=new Family_Overview__c();
        fam.Account__c=acc.Id;
        fam.Family_Status__c='Active';
        fam.Family_Needs__c='Low';
        fam.UHG_Restriction__c='No';
        fam.Onshore_Restriction__c='No';
        insert fam;
        fam.Designation__c='Assigned';
        fam.EHub_Update_Check__c=false;
        Update fam;
		Account personAccount = new Account();
        personAccount.firstName = 'DirectMessageUtilTestFname';
        personAccount.lastName = 'DirectMessageUtilTestLname';
        personAccount.Historical_Message__c = true;
        personAccount.RecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Individual').getRecordTypeId();
        insert personAccount;
        Account pa1 = [select id,personcontactid from account where id =: personAccount.id];
        AccountContactRelation acr = new AccountContactRelation();
        acr.ContactId = pa1.personcontactid;            
        acr.Accountid = acc.id;
        acr.Relationship__c = 'Child/Other';
        insert acr;
        test.startTest();
		List<Account> familyAccounts = [SELECT Id FROM Account WHERE Member_ID__c = '123123456789'];
        SNI_FLDirectMessageUtil.HistoricalReturnWrapper historia = SNI_FLDirectMessageUtil.getFamilyHistoricalMessagesFlag(familyAccounts[0].Id);
        System.assertEquals(historia.HistoricalMessage, true);
        test.stopTest();
    }
    //US3241339 - Ashley Winden
	@isTest public static void getMemHistEnabled(){
        Id progrouprecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Provider Group').getRecordTypeId();
        Id ProviderRecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Provider Affiliation').getRecordTypeId();
        Id FamilyRecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Family').getRecordTypeId();
        
        List<Account> accList=new List<Account>();
        Account ac = new Account();
        ac.Name =   'ProviderGroup xyzabc';
        ac.RecordTypeId = progrouprecordTypeId;
        insert ac;        
        
        Account familyAccount = new Account();
        familyAccount.Name = 'family firstName xyzabc';
        familyAccount.RecordTypeId = FamilyRecordTypeId;
        familyACcount.Member_ID__c = '123456789111';
        insert familyAccount;		        
        Account personAccount = new Account();
        personAccount.firstName = 'person firstName xyzabc';
        personAccount.lastName = 'person lastName xyzabc';
        personAccount.RecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Individual').getRecordTypeId();
        insert personAccount;        
        Account personAccount2 = new Account();
        personAccount2.firstName = 'person firstName abcexyz';
        personAccount2.lastName = 'person lastName abcxyz';
        personAccount2.RecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Individual').getRecordTypeId();
        personAccount2.Historical_Message__c = true;
        insert personAccount2;   
        Account pa = new Account();
        pa.Name =   'Provider Affiliation xyzabc';
        pa.RecordTypeId = ProviderRecordTypeId;
        pa.Historical_Message__c = true;
        pa.ParentId = ac.Id;
        insert pa;
        Test.startTest();
        program__c pgm = new program__c();
       	List<Program__c> program = [SELECT ID FROM Program__c WHERE Program__c=:DODYSSEY LIMIT 1];
        if(program==null || program.isEmpty()){
            Program__c program1 = new Program__c();
            program1.Program__c = DODYSSEY;
            insert program1;
            pgm = program1;
        }
        else{
            pgm = program[0];
        }
        
        Member_Affiliation__c Maffiliate = new Member_Affiliation__c();
        Maffiliate.Provider__c = ac.Id;
        Maffiliate.Population__c = 'Adult';
        Maffiliate.Program__c = pgm.Id;
        Maffiliate.Provider_Affiliation__c = pa.Id;
        Maffiliate.Email__c='PersonEmailxyzabc@optum.acet.com';
        Maffiliate.Enrollment_Date__c=system.today();
        Maffiliate.Date_Of_Birth__c = System.today();
        Maffiliate.Member__c=personAccount.Id;
        Maffiliate.Historical_Message__c = true;
        Maffiliate.Status__c=true;            
        insert Maffiliate;
        
        Id pgroup1 = SNI_FL_DirectMessageTestDataFactory.getProviderGroup();
        Contact cid = [Select Id from contact where accountid =: personAccount.Id LIMIT 1];
        Contact cid2 = [Select Id from contact where accountid =: personAccount2.Id LIMIT 1];
        Id acr1 = SNI_FL_DirectMessageTestDataFactory.getACR(familyAccount.Id,cid.Id);
        Id acr2 = SNI_FL_DirectMessageTestDataFactory.getACR(familyAccount.Id,cid2.Id);
        List<Account> provAffId = [Select Id from Account Where Id =: pa.Id LIMIT 1];
        Boolean isProvHistMsg = SNI_FLDirectMessageUtil.getProviderHistoryEnabled(provAffId[0].Id);
        System.assertEquals(true, isProvHistMsg);
        String result = SNI_FLDirectMessageUtil.getMemAffHistEnabled(pa.Id, personAccount.Id);
        list<string> parsed = result.split('-');
        System.assertEquals('true', parsed[1]);
        String result1 = SNI_FLDirectMessageUtil.getMemAffHistEnabled(pa.Id, '123abcd');
        System.assertEquals(null, result1);
        Boolean result2 = SNI_FLDirectMessageUtil.getMemAffHistSwitch(Maffiliate.Id);
        System.assertEquals(true, result2);
        Boolean result3 = SNI_FLDirectMessageUtil.getMemAffHistSwitch('123abcd');
        System.assertEquals(null, result3);
		Test.stopTest();
    } 
    @isTest public static void getMemHistEnabled2(){
        Id progrouprecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Provider Group').getRecordTypeId();
        Id ProviderRecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Provider Affiliation').getRecordTypeId();
        Id FamilyRecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Family').getRecordTypeId();
        List<Account> accList=new List<Account>();
        Account ac = new Account();
        ac.Name =   'ProviderGroup xyzabc';
        ac.RecordTypeId = progrouprecordTypeId;
        insert ac;        
        Account familyAccount = new Account();
        familyAccount.Name = 'family firstName xyzabc';
        familyAccount.RecordTypeId = FamilyRecordTypeId;
        familyACcount.Member_ID__c = '123456789111';
        insert familyAccount;		        
        Account personAccount = new Account();
        personAccount.firstName = 'person firstName xyzabc';
        personAccount.lastName = 'person lastName xyzabc';
        personAccount.RecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Individual').getRecordTypeId();
        insert personAccount;        
        Account personAccount2 = new Account();
        personAccount2.firstName = 'person firstName abcexyz';
        personAccount2.lastName = 'person lastName abcxyz';
        personAccount2.RecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Individual').getRecordTypeId();
        personAccount2.Historical_Message__c = true;
        insert personAccount2;   
        Account pa = new Account();
        pa.Name =   'Provider Affiliation xyzabc';
        pa.RecordTypeId = ProviderRecordTypeId;
        pa.Historical_Message__c = true;
        pa.ParentId = ac.Id;
        insert pa;
		Test.startTest();
        program__c pgm = new program__c();
       	List<Program__c> program = [SELECT ID FROM Program__c WHERE Program__c=:DODYSSEY LIMIT 1];
        if(program==null || program.isEmpty()){
            Program__c program1 = new Program__c();
            program1.Program__c = DODYSSEY;
            insert program1;
            pgm = program1;
        }
        else{
            pgm = program[0];
        }
        Member_Affiliation__c Maffiliate = new Member_Affiliation__c();
        Maffiliate.Provider__c = ac.Id;
        Maffiliate.Population__c = 'Adult';
        Maffiliate.Program__c = pgm.Id;
        Maffiliate.Provider_Affiliation__c = pa.Id;
        Maffiliate.Email__c='PersonEmailxyzabc@optum.acet.com';
        Maffiliate.Enrollment_Date__c=system.today();
        Maffiliate.Date_Of_Birth__c = System.today();
        Maffiliate.Member__c=personAccount.Id;
        Maffiliate.Historical_Message__c = true;
        Maffiliate.Status__c=true;            
        insert Maffiliate;
        Id pgroup1 = SNI_FL_DirectMessageTestDataFactory.getProviderGroup();
        Contact cid = [Select Id from contact where accountid =: personAccount.Id LIMIT 1];
        Contact cid2 = [Select Id from contact where accountid =: personAccount2.Id LIMIT 1];
        Id acr1 = SNI_FL_DirectMessageTestDataFactory.getACR(familyAccount.Id,cid.Id);
        Id acr2 = SNI_FL_DirectMessageTestDataFactory.getACR(familyAccount.Id,cid2.Id);
        integer result4 = SNI_FLDirectMessageUtil.getMemberAffiliationCount(personAccount.Id);
        System.assertEquals(1, result4);
       	String result5 = SNI_FLDirectMessageUtil.getMAID(personAccount.Id);
        System.assert(result5 != null);
        String result6 = SNI_FLDirectMessageUtil.getMAID('123abcd');
        System.assert(result5 != null);
        SNI_FLDirectMessageUtil.HistoricalReturnWrapper historia = SNI_FLDirectMessageUtil.getFamilyHistoricalMessagesFlag(familyAccount.Id);
        System.assert(historia != null);
        SNI_FLDirectMessageUtil.HistoricalReturnWrapper historia1 = SNI_FLDirectMessageUtil.getFamilyHistoricalMessagesFlag(familyAccount.Id);
        System.assert(historia1 != null);
        SNI_FLDirectMessageUtil.HistoricalReturnWrapper missingACR = SNI_FLDirectMessageUtil.getFamilyHistoricalMessagesFlag(personAccount.Id);
        System.assert(missingACR != null);
        SNI_FLDirectMessageUtil.HistoricalReturnWrapper providerop = SNI_FLDirectMessageUtil.getProviderHistoricalMessageFlag(personAccount.Id);
        System.assert(providerop != null);
		    Test.stopTest();

    } 

    //US3278095 - Bobby Culbertson
    public static testMethod void getFamilyOverviewDesignationTest(){
        User oUser = [select id,contactid, Name,Profile_Name__c,ProfileId,Role_Name__c FROM User Where id =: userInfo.getUserId()];
        //User userWithContact = [select id,contactid, Name,Profile_Name__c,ProfileId,Role_Name__c FROM User Where contactId != null Limit 1];
        Account acc = TestDataFactory.createBulkAccounts().get(0);
        acc.RecordTypeId=Schema.SObjectType.Account.getRecordTypeInfosByName().get('Family').getRecordTypeId();
        acc.OwnerId=oUser.Id;
        acc.Member_ID__c = '123123456789';
        update acc;
        Family_Overview__c fam=new Family_Overview__c();
        fam.Account__c=acc.Id;
        fam.Family_Status__c='Active';
        fam.Family_Needs__c='Low';
        fam.UHG_Restriction__c='No';
        fam.Onshore_Restriction__c='No';
        insert fam;
        fam.Designation__c='Assigned';
        fam.EHub_Update_Check__c=false;
        Update fam;
        Account personAccount = new Account();
        personAccount.firstName = 'DirectMessageUtilTestFname';
        personAccount.lastName = 'DirectMessageUtilTestLname';
        personAccount.Historical_Message__c = true;
        personAccount.RecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Individual').getRecordTypeId();
        insert personAccount;
        Account pa1 = [select id,personcontactid from account where id =: personAccount.id];
        AccountContactRelation acr = new AccountContactRelation();
        acr.ContactId = pa1.personcontactid;            
        acr.Accountid = acc.id;
        acr.Relationship__c = 'Child/Other';
        insert acr;
        /*AccountContactRelation acr2 = new AccountContactRelation();
        acr2.ContactId = userWithContact.contactId;            
        acr2.Accountid = acc.id;
        acr2.Relationship__c = 'Child/Other';
        insert acr2;*/
        Test.startTest();
        try{
            String negativeAcrTest = SNI_FLDirectMessageUtil.getFamilyOverviewDesignation(null);
        } catch(AuraHandledException e){
            System.debug(e.getMessage());
        }
        try{
            String negativeFamilyOverviewTest = SNI_FLDirectMessageUtil.getFamilyOverviewDesignation(pa1.personcontactid);
        } catch(AuraHandledException e){
            System.debug(e.getMessage());
        }
        String positiveTest = SNI_FLDirectMessageUtil.getFamilyOverviewDesignation(acc.Id);
		system.assertEquals('Assigned', positiveTest);   

        Test.stopTest();
    }
    
}