/********************************************************************************* 
Class Name     : SNI_FL_MemberDataFactory for Member_Affiliation__c();
Created By     : Sireesha
*********************************************************************************/

@isTest
public class SNI_FL_MembersDataFactoryTest {

    public static void initialDataPreparation() {
        Id progrouprecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Provider Group').getRecordTypeId();
        Id ProviderRecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Provider Affiliation').getRecordTypeId();
        
        List<Account> accList=new List<Account>();
        Account ac = new Account();
        ac.Name =   'ProviderGroup';
        ac.RecordTypeId = progrouprecordTypeId;
        insert ac;
        
        Account ac1 = new Account();
        ac1.Name =   'Provider Affiliation';
        ac1.RecordTypeId = ProviderRecordTypeId;
        ac1.ParentId = ac.Id;
        insert ac1;
        
        Account ac2 = new Account();
        ac2.Name =   'Provider Affiliation';
        ac2.Provider_Group__c = ac.Id;
        insert ac2;
        
        Account ac3 = new Account();
        ac3.Name =   'Provider Affiliation';
        ac3.Provider_Group_Team__c = ac.Id;
        insert ac3;
        
        List<program__c> programList=new List<program__c>();
        Program__c pgm = new Program__c();
        pgm.Program__c = 'Complex Care';
        programList.add(pgm);
        insert programList;
        
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
        insert Maffiliate;
        
    }
}