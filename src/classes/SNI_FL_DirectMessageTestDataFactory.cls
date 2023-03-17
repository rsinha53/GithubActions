/********************************************************************************* 
Class Name     : SNI_FL_DirectMessageTestDataFactory.apxc
Description    : Test data util class 
Created By     : Sameera De Silva
Created Date   : 9/6/2020
Modification Log
---------------------------------------------------------------------------------- 
Developer                   Date                   Description
1.
----------------------------------------------------------------------------------            
*********************************************************************************/

@isTest
public with sharing class SNI_FL_DirectMessageTestDataFactory {
    static final String accountName = 'Direct ';
    static Id pgrecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName().get('Provider_Group').getRecordTypeId();
    static Id pfrecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName().get('Provider_Affiliation').getRecordTypeId();
    static Id personactRecordId = Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName().get('PersonAccount').getRecordTypeId();
    static Id providerTeamRecordId = Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName().get('Provider_Team').getRecordTypeId();
    static Id providerUserRecordId = Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName().get('Provider_User').getRecordTypeId();
        
    public static List<Account> createAccountRecordsTestData(String recordType,Integer numberOfActs){
        
        ID accountRecordType = Schema.SObjectType.Account.getRecordTypeInfosByName().get(recordType).getRecordTypeId();
        List<Account> lstOfTestAccounts = new List<Account>();
        Integer num=0;
        for(;num<numberOfActs;num++){
            
            Account acc=new Account();
            if(recordType!='Person Account')
            {
            acc.Name = accountName +num;
            }
            else{
             acc.FirstName='MemberFirstName'+num;
             acc.Lastname='MemberLastName'+num;
             acc.UHG_Restriction__c = 'Yes';
            }
            acc.RecordTypeId = accountRecordType;
            
            lstOfTestAccounts.add(acc);
        }
        
        insert lstOfTestAccounts;
        return lstOfTestAccounts;
        
    }

    public static void createDirectMessagesTestData(Integer numberOfDirectMsg,List<ID> lstOfDirectMsgUsers){
        Id networkId=[Select Id from Network limit 1].Id;
        Integer num =0;
        for(;num<numberOfDirectMsg;num++){
            
            ConnectApi.FeedItemInput feedItemInput = new ConnectApi.FeedItemInput();
            
            ConnectApi.TextSegmentInput textSegmentInput = new ConnectApi.TextSegmentInput();
            textSegmentInput.text = 'Hi '+num;
            
            ConnectApi.MessageBodyInput messageBodyInput = new ConnectApi.MessageBodyInput();
            messageBodyInput.messageSegments = new List < ConnectApi.MessageSegmentInput > ();
            messageBodyInput.messageSegments.add(textSegmentInput);
            feedItemInput.body = messageBodyInput;
            
            ConnectApi.DirectMessageCapabilityInput dmInput = new ConnectApi.DirectMessageCapabilityInput();
            dmInput.subject = 'DirectMsg_ACDC_Test';
            dmInput.membersToAdd = lstOfDirectMsgUsers;
            
            ConnectApi.FeedElementCapabilitiesInput feedElementCapabilitiesInput = new ConnectApi.FeedElementCapabilitiesInput();
            
            feedElementCapabilitiesInput.directMessage = dmInput;
            feedItemInput.capabilities = feedElementCapabilitiesInput;
            
            ConnectApi.FeedElement feedElement = ConnectApi.ChatterFeeds.postFeedElement(networkId, feedItemInput);
        
        }
    }

    public static void insertFLDirectMessageTestData(List<Account> lstOFAccounts,List<DirectMessageFeed> lstOfFeedIds,Integer numberOfFlmsgs,Boolean isMarked){

        List<SNI_FL_Message__c> flMsg = new LIst<SNI_FL_Message__c>();
        Integer num=0;
        for(;num<numberOfFlmsgs;num++){

            SNI_FL_Message__c msg = new SNI_FL_Message__c();
            msg.Family_ID__c = lstOFAccounts.get(num).ID;
            msg.Feed_id__c = lstOfFeedIds.get(num).ID;
            msg.Marked__c = isMarked;
            msg.Name = accountName +num;

            flMsg.add(msg);
        }

        insert flMsg;
        
    }

    public static void insertFLMessageStatusTestData(List<SNI_FL_Message__c> lstFLMsg,Integer numberOfFlMsgStatus,Boolean isRead){

        List<SNI_FL_Message_Status__c> lstMsgStatus = new List<SNI_FL_Message_Status__c>();
        Integer num=0;
        for(;num<numberOfFlMsgStatus;num++){

            SNI_FL_Message_Status__c msgStatus = new SNI_FL_Message_Status__c();
            msgStatus.SNI_FL_Message__c = lstFLMsg.get(num).ID;
            msgStatus.isRead__c = isRead;
            msgStatus.Name = accountName +num;

            lstMsgStatus.add(msgStatus);
        }

        insert lstMsgStatus;
        
    }

    //Used to test "getFamilyAgentDetails" method in "SNI_FLReUsableMultiSelectLookUpCtrl" class
    //Author: Sameera ACDC
    public static void createAccountWIthOwner(String recordType){

        ID accountRecordType = Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName().get(recordType).getRecordTypeId();
        profile p=[select Id from profile where Name=:'System Administrator'];
        User u1 = new User( email='familyLink@optum.acet.com',
                           profileid = p.id, 
                           UserName='test_uer@optum.acet.com', 
                           Alias = 'GDS',
                           TimeZoneSidKey='America/New_York',
                           EmailEncodingKey='ISO-8859-1',
                           LocaleSidKey='en_US', 
                           LanguageLocaleKey='en_US',
                           FirstName = 'FirstNameAcet',
                           LastName = 'LastNameAcet');
        insert u1;

        Account acc = new Account();
        acc.Name = 'TestAccount_123456';
        acc.Phone = '123456789';
        acc.Type = 'Prospect';
        acc.EID__c = '!123abcACDC';
        acc.RecordTypeId = accountRecordType;

        insert acc;

        acc.OwnerId = u1.Id;
        update acc;
    }

    //Used to test "getFamilyAgentDetails" method in "SNI_FLReUsableMultiSelectLookUpCtrl" class
    //Author: Sameera ACDC
    public static void createAccountWIthInactiveOwner(String recordType){

        ID accountRecordType = Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName().get(recordType).getRecordTypeId();

        profile p=[select Id from profile where Name=:'System Administrator'];
        User u1 = new User( email='familyLink@optum.acet.com',
                           profileid = p.id, 
                           UserName='test_uer@optum.acet.com', 
                           Alias = 'GDS',
                           TimeZoneSidKey='America/New_York',
                           EmailEncodingKey='ISO-8859-1',
                           LocaleSidKey='en_US', 
                           isActive=true,
                           LanguageLocaleKey='en_US',
                           FirstName = 'FirstNameAcet',
                           LastName = 'LastNameAcet');
        insert u1;

        Account acc = new Account();
        acc.Name = 'TestAccount_123456';
        acc.Phone = '123456789';
        acc.Type = 'Prospect';
        acc.EID__c = '!1234abcACDC';
        acc.RecordTypeId = accountRecordType;

        insert acc;

        acc.OwnerId = u1.Id;
        update acc;

        
    }


    ////////////////////////Provider Messaging Test Data/////////////////////////////////////////////////////
    public static Id getProviderGroup(){
        //Provider group acccount
        Account pg = new Account();
        pg.RecordTypeId= pgrecordTypeId;
        pg.Name = 'Test_Hospital_createNewMsg_@ACDC';
        
        insert pg;
        return pg.id;
    }

    //provider user person account
    public static Id getProviderUser(Id providerGroup){

        Account providerUser= new Account(
                RecordTypeID=providerUserRecordId ,
                FirstName='NewMSgFName@ACDC1',
                LastName='NewMSgLName@ACDC1',
                Provider_Group__c=providerGroup,
                PersonMailingStreet='Greensboro',
                PersonMailingPostalCode='12345',
                PersonMailingCity='SFO',
                PersonEmail='acdc@yahoo.com',
                PersonHomePhone='1234567',
                PersonMobilePhone='43245345'
               
            );
            insert providerUser;
            return providerUser.id;
    }

    //provider team user person account
    public static Id getProviderUserForProviderTeam(Id providerGroup){

        Account providerUserTeam= new Account(
                RecordTypeID=providerUserRecordId ,
                FirstName='NewMSgFName@ACDC2',
                LastName='NewMSgLName@ACDC2',
                Provider_Group__c=providerGroup,
                PersonMailingStreet='Greensboro',
                PersonMailingPostalCode='12345',
                PersonMailingCity='SFO',
                PersonEmail='acdc@yahoo.com',
                PersonHomePhone='1234567',
                PersonMobilePhone='43245345'
               
            );
            insert providerUserTeam;
            return providerUserTeam.id;
    }
    
    //Provider user's user record
    public static Id getProviderUserRecord(Id actType){

        
        List<Account> providerUseracc = [SELECT PersonContactId FROM Account WHERE Id = :actType];
        Profile portal = [SELECT Id FROM Profile WHERE Name = 'Care Advisor Connect Provider User' LIMIT 1];
        Account provider = [SELECT PersonContactId FROM Account WHERE Id=:actType];

        User portaluser = new User(
            FirstName = 'Test_FirstNameACDC',
            LastName = 'Test_LastNameACDC',
            Email = 'testacdc@user.com',
            Username = 'test_acdc_@user.com',
            Alias = 'TestPA', 
            TimeZoneSidKey = 'GMT', 
            LocaleSidKey = 'en_US', 
            EmailEncodingKey = 'UTF-8', 
            ProfileId = portal.Id, 
            LanguageLocaleKey = 'en_US',
            ContactId = provider.PersonContactId);
        
        insert portaluser;
        return portaluser.id;
    }

    //Provider team related user record
    public static Id getProviderTeamUserRecord(Id actType){

        
        List<Account> providerUseracc = [SELECT PersonContactId FROM Account WHERE Id = :actType];
        Profile portal = [SELECT Id FROM Profile WHERE Name = 'Care Advisor Connect Provider User' LIMIT 1];
        Account provider = [SELECT PersonContactId FROM Account WHERE Id=:actType];

        User portaluser = new User(
            FirstName = 'Test_TeamNameACDC',
            LastName = 'Test_LTeamNameACDC',
            Email = 'test_acdc@user.com',
            Username = 'team_acdc_@user.com',
            Alias = 'TestPA', 
            TimeZoneSidKey = 'GMT', 
            LocaleSidKey = 'en_US', 
            EmailEncodingKey = 'UTF-8', 
            ProfileId = portal.Id, 
            LanguageLocaleKey = 'en_US',
            ContactId = provider.PersonContactId);
        
        insert portaluser;
        return portaluser.id;
    }
   
    public static Id getProviderTeam(Id providerGroupd){
        //Provider team acccount
        Account pt = new Account();
        pt.RecordTypeId= providerTeamRecordId;
        pt.FirstName = 'FName@ACDC';
        pt.LastName='LName@ACDC';
        pt.Provider_Group_Team__c = providerGroupd;
            
        insert pt;
        return pt.id;
    }
   
    public static Id getACR(Id providerTeamId,id personContactID){
        AccountContactRelation acr = new AccountContactRelation();
        acr.AccountId = providerTeamId;
        acr.ContactId = personContactID;

        insert acr;
        return acr.id;
    }
    
    public static Id getProviderAffliations(Id providerGroup){

        //Provider affliation account
        Account pf=new Account();
        pf.Name='Test_Hospital_Complex_Care-Adult@ACDC';
        pf.RecordTypeId=pfrecordTypeId;
        pf.Population__c = 'Adult';
     
        pf.ParentId	= providerGroup;
        
        insert pf;
        return pf.id;
    }
    
    public static Id getMember(){
        Account member= new Account(
            RecordTypeID=personactRecordId ,
            FirstName='@ACDCTest_FName',
            LastName='@ACDCTest_LName',
            PersonMailingStreet='HillStreet',
            PersonMailingPostalCode='12345',
            PersonMailingCity='SFO',
            PersonEmail='test@yahoo.com',
            PersonHomePhone='1234567',
            PersonMobilePhone='12345678'
        );
            
        insert member;
        return member.id;
    }

    public static Id getDocumentID(){
        
        ContentVersion conVer = new ContentVersion(PathOnClient = 'testing.txt',Title = 'Testing Files',VersionData = EncodingUtil.base64Decode('test file'));       
        insert conVer;  
        return [SELECT ContentDocumentId FROM ContentVersion WHERE Id =:conVer.Id].ContentDocumentId;
    }
  /////////////////////////////////Provider Message Data Ends/////////////////////////

    
 
    
}