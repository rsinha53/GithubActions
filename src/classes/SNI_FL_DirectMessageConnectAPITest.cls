/********************************************************************************* 
Class Name     : SNI_FL_DirectMessageConnectAPITest.apxc
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
public with sharing class SNI_FL_DirectMessageConnectAPITest {
    
    private static final string msg = 'Backup Agent Msg';

    @isTest
    static void createDirectMessagesTest(){
        //createDirectMessages with and without attachments
        id communityId= [Select Id from Network limit 1].id;
        
        List<Account> lstFamilyAccount = SNI_FL_DirectMessageTestDataFactory.createAccountRecordsTestData('Family',1);
        system.debug('lstFamilyAccount - ' + lstFamilyAccount);
        Account acc =[select Id,OwnerId from Account where Id=:lstFamilyAccount[0].Id];
        User u =[select Id from User where Id=:acc.OwnerId];
        List<ID> ids = new List<ID>();
        
        profile p=[select Id from profile where Name=:'System Administrator'];
        User u1;
        system.runAs(new user(Id = userinfo.getUserId())){
            u1 = new User( email='familyLink@optum.com',
                               profileid = p.id, 
                               UserName='test_uer@optum.com', 
                               Alias = 'GDS',
                               TimeZoneSidKey='America/New_York',
                               EmailEncodingKey='ISO-8859-1',
                               LocaleSidKey='en_US', 
                               LanguageLocaleKey='en_US',
                               FirstName = 'FirstNAme',
                               LastName = 'LastName');
            insert u1;
		}
        ids.add(u1.id);
        ids.add(u.id);
        ConnectApi.FeedElementPage testPage = new ConnectApi.FeedElementPage();
        List<ConnectApi.FeedItem> testItemList = new List<ConnectApi.FeedItem>();
        testItemList.add(new ConnectApi.FeedItem());
        testItemList.add(new ConnectApi.FeedItem());
        testPage.elements = testItemList;
        
        // Set the test data
        ConnectApi.ChatterFeeds.setTestGetFeedElementsFromFeed(null,
                                                               ConnectApi.FeedType.DirectMessages, 'me', testPage);
        SNI_FL_DirectMessageTestDataFactory.createDirectMessagesTestData(1,ids);
        List<DirectMessageFeed> lstDirectMsgFeed = [SELECT ID FROM DirectMessageFeed WHERE ParentId IN (SELECT ID FROM DirectMessage WHERE Subject LIKE 'DirectMsg_ACDC_Test') LIMIT 1];

        SNI_FL_DirectMessageTestDataFactory.insertFLDirectMessageTestData(lstFamilyAccount,lstDirectMsgFeed,1,false);
        
        List<SNI_FL_Message__c> lstFlMsg = [SELECT Id FROM SNI_FL_Message__c WHERE Name like 'Direct%'];
        
        SNI_FL_DirectMessageTestDataFactory.insertFLMessageStatusTestData(lstFlMsg,1,true);

        ContentVersion conVer = new ContentVersion(PathOnClient = 'testing.txt',Title = 'Testing Files',VersionData = EncodingUtil.base64Decode('test file'));       
        insert conVer;   
        Id conDoc = [SELECT ContentDocumentId FROM ContentVersion WHERE Id =:conVer.Id].ContentDocumentId;

		List<Id>testIds= new list<Id>();        
        testIds.add(conDoc);

        Test.startTest();	
        SNI_FLDirectMessageConnectAPI.setSavePoint();
        SNI_FLDirectMessageConnectAPI.agentNewMessage(lstFamilyAccount[0].id,ids,'Regarding Msg','Hi',NULL,NULL);
        SNI_FLDirectMessageConnectAPI.agentNewMessage(lstFamilyAccount[0].id,ids,'Regarding Docs','Hi',conDoc,NULL); 
        SNI_FLDirectMessageConnectAPI.agentNewMessage(lstFamilyAccount[0].id,testIds,'Regarding Docs','Hi',conDoc,NULL); 
        SNI_FLDirectMessageConnectAPI.agentNewMessage(lstFamilyAccount[0].id,testIds,'Regarding Msg','Hi',NULL,NULL);        
        SNI_FLDirectMessageConnectAPI.validatepostNewCommentAttachment(lstDirectMsgFeed[0].Id,'Test Message','');
        SNI_FLDirectMessageConnectAPI.validatepostNewCommentAttachment(lstDirectMsgFeed[0].Id,'Test Message with attachment',conDoc);       
        SNI_FLDirectMessageConnectAPI.backupAgentNewMessage(lstFamilyAccount[0].id,ids, msg,  'Testing Attachment',  conDoc, false,NULL);
        SNI_FLDirectMessageConnectAPI.backupAgentNewMessage(lstFamilyAccount[0].id,ids, msg,  'testing text',  NULL, false,NULL);
        SNI_FLDirectMessageConnectAPI.familyLinkeNewMessage(lstFamilyAccount[0].id,ids, msg,  'testing text',  conDoc);
        SNI_FLDirectMessageConnectAPI.familyLinkeNewMessage(lstFamilyAccount[0].id,ids, msg,  'testing text',  NULL);
        SNI_FLDirectMessageConnectAPI.familyPartnerNewMessage(lstFamilyAccount[0].id,ids,'Regarding Msg','Hi',NULL,NULL);
        SNI_FLDirectMessageConnectAPI.familyPartnerNewMessage(lstFamilyAccount[0].id,ids,'Regarding Docs','Hi',conDoc,NULL); 
        SNI_FLDirectMessageConnectAPI.familyPartnerNewMessage(lstFamilyAccount[0].id,testIds,'Regarding Docs','Hi',conDoc,NULL); 
        SNI_FLDirectMessageConnectAPI.familyPartnerNewMessage(lstFamilyAccount[0].id,testIds,'Regarding Msg','Hi',NULL,NULL);        
        SNI_FLDirectMessageConnectAPI.deleteFiles(conDoc);
        Test.stopTest();
    }
}