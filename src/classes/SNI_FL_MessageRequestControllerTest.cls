@isTest(SeeAllData = true)
public with sharing class SNI_FL_MessageRequestControllerTest {
    
    private static final String PROFILENAME = 'System Administrator';
    private static final String TESTUSERNAME = 'test_userr@optum.com';
    private static final String TIMEZONE = 'America/New_York';
    private static final String EMAILENCODINGKEY = 'ISO-8859-1';
    private static final String testEmail = 'familyLink@optum.com';
    private static final String testAlias= 'GDS';
    private static final String testLocaleKeys = 'en_US';
    private static final String testFirstName = 'FirstName';
    private static final String testLastName = 'LastName';
    private static final String testFileName = 'test File';
    private static final String testPathOnClient = 'testing.txt';
    private static final String testFileTitle = 'Testing Files';
    
    
    @IsTest
    static void getMessageRequestQueueDetailsTest(){
        List<Account> lstFamilyAccount = SNI_FL_DirectMessageTestDataFactory.createAccountRecordsTestData('Family',1);
        lstFamilyAccount[0].Ownerid = Userinfo.getuserid();
        update lstFamilyAccount;
        
        
        
        List<ID> ids = new List<ID>();
        
        profile p=[select Id from profile where Name=:PROFILENAME];
        User thisUser = [Select Id From User Where Id =:UserInfo.getUserId()];
        user u1;        
        
        System.runAs(thisUser){
            u1 = new User( email=testEmail,
                          profileid = p.id, 
                          UserName=TESTUSERNAME, 
                          Alias = testAlias,
                          TimeZoneSidKey=TIMEZONE,
                          EmailEncodingKey=EMAILENCODINGKEY,
                          LocaleSidKey=testLocaleKeys, 
                          LanguageLocaleKey=testLocaleKeys,
                          FirstName = testFirstName,
                          LastName = testLastName);
            insert u1;
        }
        
        
        ids.add(u1.id);
        SNI_FL_DirectMessageTestDataFactory.createDirectMessagesTestData(1,ids);
        List<DirectMessageFeed> lstDirectMsgFeed = [SELECT ID FROM DirectMessageFeed WHERE ParentId IN (SELECT ID FROM DirectMessage WHERE Subject LIKE 'DirectMsg_ACDC_Test') LIMIT 1];
        SNI_FL_Message__c message = new SNI_FL_Message__c(Family_ID__c=lstFamilyAccount[0].Id,Feed_Id__c=lstDirectMsgFeed[0].Id,Marked__c=false,Name='test');
        insert message;
        SNI_FL_DirectMessageTestDataFactory.insertFLDirectMessageTestData(lstFamilyAccount,lstDirectMsgFeed,1,false);
        
        List<SNI_FL_Message__c> lstFlMsg = [SELECT Id FROM SNI_FL_Message__c WHERE Name like 'Direct%'];
        
        ContentVersion conVer = new ContentVersion(PathOnClient = testPathOnClient,Title = testFileTitle,VersionData = EncodingUtil.base64Decode(testFileName));       
        insert conVer;   
        Id conDoc = [SELECT ContentDocumentId FROM ContentVersion WHERE Id =:conVer.Id].ContentDocumentId;
        ContentDocumentLink conDocLink = New ContentDocumentLink();
        conDocLink.LinkedEntityId = lstFamilyAccount.get(0).id; 
        conDocLink.ContentDocumentId = conDoc;
        conDocLink.shareType = 'V';
        insert conDocLink;
        
        String flId;        
        for(SNI_FL_Message__c fl: lstFlMsg){
            flId = fl.Id;
        }
        Message_Request_Queue__c msgReq = new Message_Request_Queue__c();
        msgReq.SNI_FL_Message__c = flId; 
        
        insert msgReq;
        
        String mrqId = [SELECT Id From Message_Request_Queue__c Where SNI_FL_Message__c =: flId Limit 1].Id;
        
        Id u01 = [Select Id From User Where profile.Name = 'System Administrator' AND IsActive = true order by name asc limit 1 ].Id;
        
        system.debug('user+ '+u01);
        System.debug('mrqId--->' +mrqId);
        Test.startTest();   
        SNI_FL_ThreeWayCommunicationController.getMessageRequestQueueDetails(mrqId,u01);  
        SNI_FL_ThreeWayCommunicationController.getMessageRequestQueueDetails(null,u01); 
        Test.stopTest();
        
        
    }
}