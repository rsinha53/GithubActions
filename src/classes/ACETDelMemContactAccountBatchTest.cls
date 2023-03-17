@isTest
private class ACETDelMemContactAccountBatchTest{
    public static testMethod void test1() {
        Test.StartTest();
        List<Interaction__c> lstInteraction = TestDataFactory.createBulkInteraction();
        //List<Contact> lstContact = TestDataFactory.createBulkContact();
        //List<Account> lstAccount = TestDataFactory.createBulkAccounts();
        List<Account> lstAccount = TestDataFactory.CreateBulkPersonAccount();
        ACETDelMemContactAccountBatch batchObj = new ACETDelMemContactAccountBatch();
        batchObj.ACETDelMemContactAccountBatch();
        Database.executeBatch(batchObj);
        Test.StopTest();
    }
}