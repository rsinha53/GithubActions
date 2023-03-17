@isTest
private class ACETHipaaDisclosureTest {

    static testMethod void myUnitTest() {
      setUpData();
        ACETHIPPADisclosureController ctrl = new ACETHIPPADisclosureController();
        ctrl.subDOB = '1954-01-28';
        ctrl.orgDOB = '1954-01-28';
        ctrl.InteractionId = createInteraction();
        ctrl.runHippaCategoryRules();
        
    }
    public static void setUpData(){
      ACETHippaCategoryRule__c  rule = new ACETHippaCategoryRule__c ();
      rule.Caller_SubType__c = null;
      rule.Caller_Type__c = 'Member';
      rule.General__c = true;
      rule.Max_Age__c = 200;
      rule.Medical__c = true;
      rule.Min_Age__c = 0;
      rule.Sensitive__c = true;
      rule.Dependent__c = 'Adult Dependent';
      insert rule;
    }
    public static String createInteraction(){
      RecordType newRecord = [SELECT Id FROM RecordType WHERE Name = 'Person Account' and SObjectType = 'Account'];
        
        Account accountTest = new Account();
        accountTest.FirstName = 'Test';
        accountTest.LastName = 'Test';
        accountTest.EID__c = 'Test';
        accountTest.EID__pc = 'Test';
        accountTest.RecordTypeId = newRecord.Id;
        insert accountTest;

    Account acc = [SELECT Id,personcontactid from Account where Id=:accountTest.Id];
        Contact con = [SELECT Id,LastName,FirstName,EID__c,AccountId from Contact where Id=:acc.personcontactid];
        con.Tax_ID__c = 'Test';
        con.NPI__c = 'Test';
      Interaction__c intraction = ACETTestDataUtility.createInteraction(con.Id, 'Test', 'Member','Test');
      insert intraction;
      return intraction.Id;
    }
}