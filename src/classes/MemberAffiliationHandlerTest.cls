@isTest
public class MemberAffiliationHandlerTest {
    static testMethod void getData_NewMemberAffiliationMethod() {
        Id progrouprecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Provider Group').getRecordTypeId();
        Id proAffrecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Provider Affiliation').getRecordTypeId();
        Id proTeamrecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Provider Team').getRecordTypeId();
        Id proUserrecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Provider User').getRecordTypeId();
            List<Account> accList=new List<Account>();
            Account ac = new Account();
            ac.Name =   'ProviderGroup';
            ac.RecordTypeId = progrouprecordTypeId;
            accList.add(ac);
            Account acff = new Account();
            acff.Name =   'ProviderAffiliation';
            acff.RecordTypeId = proAffrecordTypeId;
            acff.parentId=ac.id;
            accList.add(acff);
            Account acteam = new Account();
            acteam.LastName =   'ProviderTeam';
            acteam.RecordTypeId = proTeamrecordTypeId;
            accList.add(acteam);
            Account acUser = new Account();
            acUser.LastName =   'ProviderUser';
            acUser.RecordTypeId = proUserrecordTypeId;
            acUser.Email_Notification__c =true;
            accList.add(acUser);
            insert accList;
        List<program__c> programList=new List<program__c>();
            Program__c pgm = new Program__c();
            pgm.Program__c = 'Complex Care';
            programList.add(pgm);
            insert programList;
        account acUser1 = [select id,personcontactid from account where id =: acUser.id];
        AccountContactRelation acrrec = new AccountContactRelation();
        acrrec.ContactId = acUser1.personcontactid;             
        acrrec.Accountid = acteam.id;
        acrrec.Relationship__c = 'Provider User';
        insert acrrec;
        account acteam1 = [select id,personcontactid from account where id =: acteam.id];
        AccountContactRelation acrrec1 = new AccountContactRelation();
        acrrec1.ContactId = acteam1.personcontactid;            
        acrrec1.Accountid = acff.id;
        acrrec1.Relationship__c = 'Provider Team';
        insert acrrec1;
        AccountContactRelation acrrec2 = new AccountContactRelation();
        acrrec2.ContactId = acUser1.personcontactid;             
        acrrec2.Accountid = acff.id;
        acrrec2.Relationship__c = 'Provider User';
        insert acrrec2;
        List<Contact> conId = [SELECT id from contact where accountId =: acUser.Id];
        List<Profile> pList = [SELECT Id FROM Profile WHERE Name =: 'Care Advisor Connect Provider User'];
        system.runAs(new User(Id = UserInfo.getUserId())){
            User u = new User(Alias = 'standt', Email='flCareTeamtest@testorg.com', 
                              EmailEncodingKey='UTF-8', FirstName='Test007',LastName='Testing', LanguageLocaleKey='en_US', 
                              LocaleSidKey='en_US', ProfileId = pList[0].id, contactId =conId[0].Id,
                              TimeZoneSidKey='America/Los_Angeles',MobilePhone='9000000001', UserName='flCareTeamtest@testorg.com',IsActive=true);
            insert u;
        }
       
        List<Member_Affiliation__c> mflst = new List<Member_Affiliation__c>();
        Member_Affiliation__c Maffiliate = new Member_Affiliation__c();
        //Maffiliate.Provider__c = ac.Id;
        Maffiliate.Population__c = 'Adult';
        Maffiliate.Program__c = pgm.Id;
        Maffiliate.Provider_group__c = ac.Id;
        Maffiliate.Provider_Affiliation__c = acff.Id;
        Maffiliate.Email__c='PersonEmail@gmail.com';
        Maffiliate.Enrollment_Date__c=system.today();
        Maffiliate.Date_Of_Birth__c = System.today();
        Maffiliate.Member__c=ac.Id;
        Maffiliate.Status__c=true; 
        mflst.add(Maffiliate);
        insert mflst;
        Test.startTest();
        try
         {
            MemberAffiliationTriggerHandler memcall = new MemberAffiliationTriggerHandler();
            memcall.Memberrecordsharing(mflst,null);
        }
        catch(exception e)
        {
        }    
        Test.stopTest();
    }

}