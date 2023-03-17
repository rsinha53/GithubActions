@isTest
public class SNI_FL_MembersROITest {
 @isTest 
    static void SNI_FL_MembersROITestMethod(){
        list<SNI_FL_Members_ROI__c> lstRoiMem = new list<SNI_FL_Members_ROI__c>();
        SNI_FL_Members_ROI__c meroi = new SNI_FL_Members_ROI__c();
        meroi.SNI_FL_Status__c = 'InActive';
        insert meroi;
        meroi.SNI_FL_Status__c = 'Active';
        update meroi;
        
        
    }

    //Added by ACDC US3059977
    @isTest
    static void roiInactiveToActiveTest(){

        ID businessAccountType = Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName().get('Family').getRecordTypeId();
        

        Account acc1 = new Account();
        acc1.Name = 'CaseManagementAcct_ACDC';
        acc1.Phone = '123456789';
        acc1.Type = 'Prospect';
        acc1.EID__c = '!123abc_ACDC';
        acc1.RecordTypeId = businessAccountType;
        insert acc1;

        ID personAccountType =  Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName().get('PersonAccount').getRecordTypeId();
       
        Account acc2 = new Account();
        acc2.FirstName ='Firstperson_ACDC';
        acc2.LastName = 'LastName_ACDC';
        acc2.RecordTypeId = personAccountType;
        insert acc2;
		Contact cont = [SELECT ID FROM Contact WHERE AccountId=:acc2.id];

        Profile executionUser = [SELECT Id FROM profile WHERE Name=:'System Administrator'];
        profile p=[select Id from profile where Name=:'Care Advisor Connect Community User'];

        User executionUser1 = [SELECT id FROM User WHERE profileid=:executionUser.ID AND isActive=true LIMIT 1];
        System.runAs(executionUser1){
            
            User u1 = new User( email='familyLink@optum.acet.com',
                            profileid = p.id, 
                            UserName='test_uer@optum.acet.com', 
                            Alias = 'GDS',
                            TimeZoneSidKey='America/New_York',
                            EmailEncodingKey='ISO-8859-1',
                            LocaleSidKey='en_US', 
                            ContactId = cont.id,
                            LanguageLocaleKey='en_US',
                            FirstName = 'FirstNameAcet',
                            LastName = 'LastNameAcet');
            insert u1;
        }

        Account acc3 = new Account();
        acc3.FirstName ='Secondperson_ACDC';
        acc3.LastName = 'SecondName_ACDC';
        acc3.RecordTypeId = personAccountType;
        insert acc3;
		Contact cont2 = [SELECT ID FROM Contact WHERE AccountId=:acc3.id];

        User executionUser2 = [SELECT id FROM User WHERE profileid=:executionUser.ID AND isActive=true LIMIT 1];
        System.runAs(executionUser2){
            
            User u2 = new User( email='familyLink_ACDC@optum.acet.com',
                            profileid = p.id, 
                            UserName='test_uer_ACDC@optum.acet.com', 
                            Alias = 'GDS',
                            TimeZoneSidKey='America/New_York',
                            EmailEncodingKey='ISO-8859-1',
                            LocaleSidKey='en_US', 
                            ContactId = cont2.id,
                            LanguageLocaleKey='en_US',
                            FirstName = 'First_NameAcet',
                            LastName = 'Last_NameAcet');
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
        memberROI1.SNI_FL_Status__c = 'InActive';
        memberROI1.SNI_FL_Account__c = acc2.id;
        insert memberROI1;

        ID ecmRecordType = Schema.SObjectType.Case.getRecordTypeInfosByDeveloperName().get('SNI_Care_Plan').getRecordTypeId();
        
        Case openCase1 = new Case();
        openCase1.RecordTypeId = ecmRecordType;
        openCase1.Case_Name__c ='Overviewcase1';
        openCase1.ContactId = cont.id;
        openCase1.AccountId = acc2.id;
        insert openCase1;
        User usr = [SELECT id,AccountId FROM User WHERE UserName='test_uer_ACDC@optum.acet.com'];
        
        CaseTeamRole cstmRole = [select id,name from caseteamrole Limit 1];
        
        CaseTeamMember cstm = new CaseTeamMember(parentid = opencase1.id,teamroleid = cstmRole.id,memberid = usr.id);
        insert cstm;

        Test.startTest();

        SNI_FL_Members_ROI__c inactiveROI = [SELECT ID,SNI_FL_Status__c FROM SNI_FL_Members_ROI__c WHERE SNI_FL_Status__c = 'InActive'];
        inactiveROI.SNI_FL_Status__c = 'Active';
        update inactiveROI;

        Test.stopTest();

        List<CaseTeamMember> lstCaseTeamMembers = [SELECT ParentId,MemberId,Id FROM CaseTeamMember where ParentId IN (SELECT id FROM Case WHERE Case_Name__c ='Overviewcase1')];
        
        System.assertEquals(usr.id,lstCaseTeamMembers[0].MemberId);
        
    }
}