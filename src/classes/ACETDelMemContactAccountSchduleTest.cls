@isTest
private class ACETDelMemContactAccountSchduleTest {
    
    public static testMethod void testschedule() {
        Test.StartTest();
        Interaction__c inte = new Interaction__c();
        inte.Originator__c = testdatafactory.CreatePersonAccount().personcontactid;
        inte.Originator_Type__c = 'Member';
        inte.Interaction_Type__c ='Research Only';
        insert inte;
        
        Account acc = ACETTestDataUtility.createAccount('testName');
        insert acc;
        
        Contact con = ACETTestDataUtility.createContact(acc.id, 'John', 'Miller');            
        insert con;
        
        
        ACETDelMemContactAccountSchdule sch = new ACETDelMemContactAccountSchdule ();
        sch.execute(null);
        
       
  
        Test.StopTest();
        
        
    }
}