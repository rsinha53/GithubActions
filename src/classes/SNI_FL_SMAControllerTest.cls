@isTest(SeeAllData=true)
public with sharing class SNI_FL_SMAControllerTest {
	@isTest
    public static void MemberAffiliationList(){
        Id progrouprecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Provider Group').getRecordTypeId();
        Id ProviderRecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Provider Affiliation').getRecordTypeId();
        List<Account> accList=new List<Account>();
        Account ac = new Account();
        ac.Name =   'ProviderGroup xyzabc';
        ac.RecordTypeId = progrouprecordTypeId;
        insert ac;
        Account personAccount = new Account();
        personAccount.firstName = 'person firstName xyzabc';
        personAccount.lastName = 'person lastName xyzabc';
        personAccount.RecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Individual').getRecordTypeId();
        insert personAccount;   
        Account pa = new Account();
        pa.Name =   'Provider Affiliation xyzabc';
        pa.RecordTypeId = ProviderRecordTypeId;
        pa.ParentId = ac.Id;
        insert pa;        
        program__c pgm = new program__c();      
       	List<Program__c> program = [SELECT ID FROM Program__c WHERE Program__c='Diagnostic Odyssey' LIMIT 1];
        if(program==null || program.isEmpty()){
            Program__c program1 = new Program__c();
            program1.Program__c = 'Diagnostic Odyssey';
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
        
        List<SNI_FL_SelectMemberAffiliationController.MemberAffiliationWrapper> mawrapper = SNI_FL_SelectMemberAffiliationController.getMemberAffiliationList(personAccount.Id);
        System.assert(mawrapper.size() > 0);
    }
}