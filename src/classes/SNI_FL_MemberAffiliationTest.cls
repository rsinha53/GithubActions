/********************************************************************************* 
Class Name     : SNI_FL_MemberAffiliationTest.cls
Description    : This is test class for SNI_FL_MemberAffiliation
Created By     : Karthik
Created Date   : 11/30/2020
*********************************************************************************/
@isTest
public class SNI_FL_MemberAffiliationTest {
    static testMethod void getData_NewMemberAffiliationMethod() {
        Id progrouprecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Provider Group').getRecordTypeId();
        Id ProviderRecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Provider Affiliation').getRecordTypeId();
        
        List<program__c> programList=new List<program__c>();
        Program__c pgm = new Program__c();
        pgm.Program__c = 'Complex Care';
        programList.add(pgm);
        insert programList;
        
        List<Account> accList=new List<Account>();
        Account ac = new Account();
        ac.Name =   'ProviderGroup';
        ac.RecordTypeId = progrouprecordTypeId;
        ac.Member_ID__c = '853359473';
        insert ac;
        
        Account acc = new Account();
        acc.Name =   'Provider Affiliation';
        acc.RecordTypeId = ProviderRecordTypeId;
        acc.ParentId = ac.Id;
        acc.Program__c =pgm.id;
        acc.Population__c ='Adult';
        insert acc;
        
        Account pGroup = new Account();
        pGroup.Name =   'Provider Affiliation';
        pGroup.Provider_Group__c = ac.Id;
        insert pGroup;
        
        Account pTeam = new Account();
        pTeam.Name =   'Provider Affiliation';
        pTeam.Provider_Group_Team__c = ac.Id;
        insert pTeam;
        
        Contact con = new Contact();
        con.AccountId = ac.Id;
        con.LastName = 'Test';
        insert con;
        
        
        Member_Affiliation__c Maffiliate = new Member_Affiliation__c();
        Maffiliate.Provider__c = ac.Id;
        Maffiliate.Population__c = 'Adult';
        Maffiliate.Program__c = pgm.Id;
        Maffiliate.Provider_Affiliation__c = ac.Id;
        Maffiliate.Email__c='PersonEmail@gmail.com';
        Maffiliate.Enrollment_Date__c=system.today();
        Maffiliate.Date_Of_Birth__c = System.today();
        Maffiliate.Member__c=ac.Id;
        Maffiliate.Status__c=true;
        Maffiliate.Member_ID__c = '853359473';
        insert Maffiliate;
        boolean isValid;
        Test.startTest();
        SNI_FL_MemberAffiliation.getData_NewMemberAffiliation();
        SNI_FL_MemberAffiliation.getchildaccountFromId(ac.Id);
        SNI_FL_MemberAffiliation.deletememberaffiliation(Maffiliate.Id);
        SNI_FL_MemberAffiliation.fetchLookUp(pgm.Id, 'Adult', ac.Id); 
        SNI_FL_MemberAffiliation.wrapperFetchLookUp warpItem =  SNI_FL_MemberAffiliation.fetchLookUpValues('Complex Care', 'Adult',string.valueOf(ac.Id));
        SNI_FL_MemberAffiliation.createAccount('Complex Care', 'Adult', ac.Id, pgm.Id, System.today(), ac.Id, ac.Id);
        isValid = SNI_FL_MemberAffiliation.isFecPro();
        Test.stopTest();
    }
}