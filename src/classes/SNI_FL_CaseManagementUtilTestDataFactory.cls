/****************************************************************************** 
Class Name     : SNI_FL_CaseManagementUtilTestDataFactory.apxc
Description    : 
Created By     : Sameera De Silva - ACDC
Created Date   : 11/17/2020
******************************************************************************/


@isTest
public with sharing class SNI_FL_CaseManagementUtilTestDataFactory {

    private static final String profName='Care Advisor Connect Community User';
    private static final String timeZone = 'America/New_York';
    private static final String emailEncodingKey = 'ISO-8859-1';

    public static void checkWrapperObjectTest1Data(){
        
        ID businessAccountType = Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName().get('Business_Account').getRecordTypeId();
        

        Account acc1 = new Account();
        acc1.Name = 'CaseManagementAcct_ACDC';
        acc1.Phone = '123456789';
        acc1.Type = 'Prospect';
        acc1.EID__c = '!123abc_ACDC';
        acc1.RecordTypeId = businessAccountType;
        insert acc1;

        ID personAccountType = Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName().get('PersonAccount').getRecordTypeId();
        
        Account acc2 = new Account();
        acc2.FirstName ='Firstperson_ACDC';
        acc2.LastName = 'LastName_ACDC';
        acc2.RecordTypeId = personAccountType;
        insert acc2;
		Contact cont = [SELECT ID FROM Contact WHERE AccountId=:acc2.id];
        
        Profile executionUser = [SELECT Id FROM profile WHERE Name=:'System Administrator'];
        User executionUser1 = [SELECT id FROM User WHERE profileid=:executionUser.ID AND isActive=true LIMIT 1];
        System.runAs(executionUser1){
            profile p=[select Id from profile where Name=:profName];
            User u1 = new User( email='familyLink@optum.acet.com',
                            profileid = p.id, 
                            UserName='test_uer@optum.acet.com', 
                            Alias = 'GDS',
                            TimeZoneSidKey=timeZone,
                            EmailEncodingKey=emailEncodingKey,
                            LocaleSidKey='en_US', 
                            ContactId = cont.id,
                            LanguageLocaleKey='en_US',
                            FirstName = 'FirstNameAcet',
                            LastName = 'LastNameAcet');
            insert u1;
        }
        

        Account acc3 = new Account();
        acc3.FirstName ='Seconperson_ACDC';
        acc3.LastName = 'SecondLastName_ACDC';
        acc3.RecordTypeId = personAccountType;
        insert acc3;
		Contact cont2 = [SELECT ID FROM Contact WHERE AccountId=:acc3.id];
        
        System.runAs(executionUser1){
            profile p2=[select Id from profile where Name=:profName];
            User u2 = new User( email='familyLink_second@optum.acet.com',
                            profileid = p2.id, 
                            UserName='test_uer_second@optum.acet.com', 
                            Alias = 'GDS',
                            TimeZoneSidKey=timeZone,
                            EmailEncodingKey=emailEncodingKey,
                            LocaleSidKey='en_US', 
                            ContactId = cont2.id,
                            LanguageLocaleKey='en_US',
                            FirstName = 'SecondNameAcet',
                            LastName = 'SecondLastNameAcet');
            insert u2;
        }
        

        SNI_FL_Care_Team_Member__c careTeamRecord1 = new SNI_FL_Care_Team_Member__c();
        careTeamRecord1.SNI_FL_Family__c = acc1.id;
        careTeamRecord1.SNI_FL_Member__c = acc2.id;
        careTeamRecord1.SNI_FL_Status__c	= 'Registered';
        insert careTeamRecord1;

        SNI_FL_Care_Team_Member__c careTeamRecord2 = new SNI_FL_Care_Team_Member__c();
        careTeamRecord2.SNI_FL_Family__c = acc1.id;
        careTeamRecord2.SNI_FL_Member__c = acc3.id;
        careTeamRecord2.SNI_FL_Status__c	= 'Registered';
        insert careTeamRecord2;

        SNI_FL_Members_ROI__c memberROI1 = new SNI_FL_Members_ROI__c();
        memberROI1.SNI_FL_Member__c = careTeamRecord1.id;
        memberROI1.SNI_FL_ROI_Signed_With__c =careTeamRecord2.id;
        memberROI1.SNI_FL_Status__c = 'Active';
        memberROI1.SNI_FL_Account__c = acc2.id;
        insert memberROI1;

        ID ecmRecordType = Schema.SObjectType.Case.getRecordTypeInfosByDeveloperName().get('ECM').getRecordTypeId();
        
        Case openCase1 = new Case();
        openCase1.Case_Type__c = 'Opportunity';
        openCase1.RecordTypeId = ecmRecordType;
        openCase1.Case_Name__c ='openCase1';
        openCase1.ContactId = cont.id;
        openCase1.Community__c = true;
        insert openCase1;

        CaseComment comment1 = new CaseComment();
        comment1.CommentBody = 'comment1';
        comment1.IsPublished = true;
        comment1.ParentId = openCase1.id;
        insert comment1;

        ID caseCloseRecordType = Schema.SObjectType.Case.getRecordTypeInfosByDeveloperName().get('Case_Close').getRecordTypeId();
        
        Case closeCase1 = new Case();
        closeCase1.Case_Type__c = 'Opportunity';
        closeCase1.Status = 'Closed';
        closeCase1.RecordTypeId = caseCloseRecordType;
        closeCase1.Case_Name__c = 'closeCase1';
        closeCase1.ContactId = cont2.id;
        closeCase1.Community__c = true;
        insert closeCase1;

        CaseComment comment2 = new CaseComment();
        comment2.CommentBody = 'comment1';
        comment2.IsPublished = true;
        comment2.ParentId = closeCase1.id;
        insert comment2;

        ContentVersion contentVersion = new ContentVersion(
        Title = 'Penguins',
        PathOnClient = 'Penguins.jpg',
        VersionData = Blob.valueOf('Test Content'),
        IsMajorVersion = true
        );
        insert contentVersion;    
        List<ContentDocument> documents = [SELECT Id, Title, LatestPublishedVersionId FROM ContentDocument WHERE LatestPublishedVersionId=:contentVersion.ID];

        //create ContentDocumentLink  record 
        ContentDocumentLink cdl = New ContentDocumentLink();
        cdl.LinkedEntityId = openCase1.id;
        cdl.ContentDocumentId = documents[0].Id;
        cdl.shareType = 'V';
        cdl.Visibility='AllUsers';
        insert cdl;

        ContentVersion contentVersion2 = new ContentVersion(
        Title = 'PenguinsS',
        PathOnClient = 'PenguinsS.jpg',
        VersionData = Blob.valueOf('Test ContentT'),
        IsMajorVersion = true
        );
        insert contentVersion2;    
        List<ContentDocument> documentss = [SELECT Id, Title, LatestPublishedVersionId FROM ContentDocument WHERE LatestPublishedVersionId=:contentVersion2.ID];

        //create ContentDocumentLink  record 
        ContentDocumentLink cd2 = New ContentDocumentLink();
        cd2.LinkedEntityId = closeCase1.id;
        cd2.ContentDocumentId = documentss[0].Id;
        cd2.shareType = 'V';
        cd2.Visibility='AllUsers';
        insert cd2;

        
        ContentVersion contentVersion3 = new ContentVersion(
        Title = 'Tiger',
        PathOnClient = 'Tiger.jpg',
        VersionData = Blob.valueOf('Tiger Test ContentT'),
        IsMajorVersion = true
        );
        insert contentVersion3;    
        List<ContentDocument> documentsss = [SELECT Id, Title, LatestPublishedVersionId FROM ContentDocument WHERE LatestPublishedVersionId=:contentVersion3.ID];

        //create ContentDocumentLink  record 
        ContentDocumentLink cd3 = New ContentDocumentLink();
        cd3.LinkedEntityId = closeCase1.id;
        cd3.ContentDocumentId = documentsss[0].Id;
        cd3.shareType = 'V';
        cd3.Visibility='AllUsers';
        insert cd3;
        
    }

    public static void checkWrapperObjectTest2Data(){

        ID businessAccountType = Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName().get('Business_Account').getRecordTypeId();
        

        Account acc1 = new Account();
        acc1.Name = 'CaseManagementAcct_ACDC';
        acc1.Phone = '123456789';
        acc1.Type = 'Prospect';
        acc1.EID__c = '!123abc_ACDC';
        acc1.RecordTypeId = businessAccountType;
        insert acc1;

        ID personAccountType = Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName().get('PersonAccount').getRecordTypeId();
        
        Account acc2 = new Account();
        acc2.FirstName ='Firstperson_ACDC';
        acc2.LastName = 'LastName_ACDC';
        acc2.RecordTypeId = personAccountType;
        insert acc2;
		Contact cont = [SELECT ID FROM Contact WHERE AccountId=:acc2.id];
        
        
        Profile executionUser = [SELECT Id FROM profile WHERE Name=:'System Administrator'];
        User executionUser1 = [SELECT id FROM User WHERE profileid=:executionUser.ID AND isActive=true LIMIT 1];
        System.runAs(executionUser1){
            profile p=[select Id from profile where Name=:profName];
            User u1 = new User( email='familyLink@optum.acet.com',
                            profileid = p.id, 
                            UserName='test_uer@optum.acet.com', 
                            Alias = 'GDS',
                            TimeZoneSidKey=timeZone,
                            EmailEncodingKey=emailEncodingKey,
                            LocaleSidKey='en_US', 
                            ContactId = cont.id,
                            LanguageLocaleKey='en_US',
                            FirstName = 'FirstNameAcet',
                            LastName = 'LastNameAcet');
            insert u1;
        }
        

        Account acc3 = new Account();
        acc3.FirstName ='Seconperson_ACDC';
        acc3.LastName = 'SecondLastName_ACDC';
        acc3.RecordTypeId = personAccountType;
        insert acc3;
		Contact cont2 = [SELECT ID FROM Contact WHERE AccountId=:acc3.id];
     
        System.runAs(executionUser1){
            profile p2=[select Id from profile where Name=:profName];
            User u2 = new User( email='familyLink_second@optum.acet.com',
                            profileid = p2.id, 
                            UserName='test_uer_second@optum.acet.com', 
                            Alias = 'GDS',
                            TimeZoneSidKey=timeZone,
                            EmailEncodingKey=emailEncodingKey,
                            LocaleSidKey='en_US', 
                            ContactId = cont2.id,
                            LanguageLocaleKey='en_US',
                            FirstName = 'SecondNameAcet',
                            LastName = 'SecondLastNameAcet');
            insert u2;
        }
        

        SNI_FL_Care_Team_Member__c careTeamRecord1 = new SNI_FL_Care_Team_Member__c();
        careTeamRecord1.SNI_FL_Family__c = acc1.id;
        careTeamRecord1.SNI_FL_Member__c = acc2.id;
        careTeamRecord1.SNI_FL_Status__c	= 'Registered';
        insert careTeamRecord1;

        SNI_FL_Care_Team_Member__c careTeamRecord2 = new SNI_FL_Care_Team_Member__c();
        careTeamRecord2.SNI_FL_Family__c = acc1.id;
        careTeamRecord2.SNI_FL_Member__c = acc3.id;
        careTeamRecord2.SNI_FL_Status__c	= 'Registered';
        insert careTeamRecord2;

        SNI_FL_Members_ROI__c memberROI1 = new SNI_FL_Members_ROI__c();
        memberROI1.SNI_FL_Member__c = careTeamRecord1.id;
        memberROI1.SNI_FL_ROI_Signed_With__c =careTeamRecord2.id;
        memberROI1.SNI_FL_Status__c = 'Active';
        memberROI1.SNI_FL_Account__c = acc2.id;
        insert memberROI1;

        ID ecmRecordType = Schema.SObjectType.Case.getRecordTypeInfosByDeveloperName().get('ECM').getRecordTypeId();
        
        Case openCase1 = new Case();
        openCase1.Case_Type__c = 'Opportunity';
        openCase1.RecordTypeId = ecmRecordType;
        openCase1.Case_Name__c ='openCase1';
        openCase1.ContactId = cont.id;
        openCase1.Community__c = true;
        insert openCase1;
        
        casecomment cm = new casecomment();
        cm.parentId = openCase1.Id;
       cm.IsPublished=true;
        cm.commentBody = 'test';
        insert cm;

        ID caseCloseRecordType = Schema.SObjectType.Case.getRecordTypeInfosByDeveloperName().get('Case_Close').getRecordTypeId();
        Case closeCase1 = new Case();
        closeCase1.Case_Type__c = 'Opportunity';
        closeCase1.Status = 'Closed';
        closeCase1.RecordTypeId = caseCloseRecordType;
        closeCase1.Case_Name__c = 'closeCase1';
        closeCase1.ContactId = cont2.id;
        closeCase1.Community__c = true;
        insert closeCase1;
        
        casecomment cm1 = new casecomment();
        cm1.parentId = closeCase1.Id;
        cm1.commentBody = 'test';
        cm1.IsPublished=true;
        insert cm1;

        ContentVersion contentVersion = new ContentVersion(
        Title = 'Penguins',
        PathOnClient = 'Penguins.jpg',
        VersionData = Blob.valueOf('Test Content'),
        IsMajorVersion = true
        );
        insert contentVersion;    
        List<ContentDocument> documents = [SELECT Id, Title, LatestPublishedVersionId FROM ContentDocument WHERE LatestPublishedVersionId=:contentVersion.ID];

        //create ContentDocumentLink  record 
        ContentDocumentLink cdl = New ContentDocumentLink();
        cdl.LinkedEntityId = openCase1.id;
        cdl.ContentDocumentId = documents[0].Id;
        cdl.shareType = 'V';
        cdl.Visibility='AllUsers';
        insert cdl;

        ContentVersion contentVersion2 = new ContentVersion(
        Title = 'PenguinsS',
        PathOnClient = 'PenguinsS.jpg',
        VersionData = Blob.valueOf('Test ContentT'),
        IsMajorVersion = true
        );
        insert contentVersion2;    
        List<ContentDocument> documentss = [SELECT Id, Title, LatestPublishedVersionId FROM ContentDocument WHERE LatestPublishedVersionId=:contentVersion2.ID];

        //create ContentDocumentLink  record 
        ContentDocumentLink cd2 = New ContentDocumentLink();
        cd2.LinkedEntityId = closeCase1.id;
        cd2.ContentDocumentId = documentss[0].Id;
        cd2.shareType = 'V';
        cd2.Visibility='AllUsers';
        insert cd2;

        
        ContentVersion contentVersion3 = new ContentVersion(
        Title = 'Tiger',
        PathOnClient = 'Tiger.jpg',
        VersionData = Blob.valueOf('Tiger Test ContentT'),
        IsMajorVersion = true
        );
        insert contentVersion3;    
        List<ContentDocument> documentsss = [SELECT Id, Title, LatestPublishedVersionId FROM ContentDocument WHERE LatestPublishedVersionId=:contentVersion3.ID];

        //create ContentDocumentLink  record 
        ContentDocumentLink cd3 = New ContentDocumentLink();
        cd3.LinkedEntityId = closeCase1.id;
        cd3.ContentDocumentId = documentsss[0].Id;
        cd3.shareType = 'V';
        cd3.Visibility='AllUsers';
        insert cd3;
    }
}