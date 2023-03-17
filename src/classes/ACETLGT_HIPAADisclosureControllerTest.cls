@isTest
private class ACETLGT_HIPAADisclosureControllerTest {

    @testSetup
    static void setUpData(){
        Test.startTest();
        
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
        
        Third_Party__c tp = new Third_Party__c();
        insert tp;
        Interaction__c intraction = ACETTestDataUtility.createInteraction(con.Id, 'Test', 'Member','Test');
        intraction.Third_Party__c = tp.Id;
        insert intraction;
        
        Third_Party_Originator__c tpo = new Third_Party_Originator__c();
        tpo.Third_Party__c = tp.Id;
        insert tpo;
        Test.stopTest();
    }
    
    @isTest static void testGetCategories() {
        Test.startTest();
        
        Interaction__c interaction = [SELECT Id FROM Interaction__c LIMIT 1];
        List<String> categories = ACETLGT_HIPAADisclosureController.getHipaaCategories(interaction.Id, '1954-01-28', '1954-01-28','Self');
        System.assert(categories != null);
        
        Test.stopTest();
    }
    
    @isTest static void testOtherFlows() {
        Test.startTest();
        
        Interaction__c interaction = [SELECT Id FROM Interaction__c LIMIT 1];
        List<String> categories = ACETLGT_HIPAADisclosureController.getHipaaCategories(interaction.Id, NULL, '', 'Self');
        System.assert(categories != null);
        
        Test.stopTest();
    }
}