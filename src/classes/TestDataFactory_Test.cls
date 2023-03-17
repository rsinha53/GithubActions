@isTest
public class TestDataFactory_Test {

    @isTest
    public static void testMethod1(){
        
        TestDataFactory.createContact();
        TestDataFactory.createBulkContact();
        TestDataFactory.createBulkAccounts();
        TestDataFactory.createContactwithEID();
        TestDataFactory.createInteraction();
        TestDataFactory.createBulkInteraction();
        TestDataFactory.createACETHighlightsPanelAdditionalInfo();
        TestDataFactory.CreateISLWebserviceCS('test','test');
        TestDataFactory.getUser('System Administrator');
        TestDataFactory.randomWithLimit(99999);
        TestDataFactory.createCases(3);
        TestDataFactory.createCase();
        TestDataFactory.createCaseandCaseItem();
        TestDataFactory.CreatePersonAccount();
        TestDataFactory.createInteractionNoContact();       
    }
}