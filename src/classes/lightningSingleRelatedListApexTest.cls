@istest(seealldata=false)
public class lightningSingleRelatedListApexTest {

    @isTest static void lightningSingleRelatedListApexTest() {
        RecordType newRecord = [SELECT Id FROM RecordType WHERE Name = 'Individual' and SObjectType = 'Account'];
        Account accountTest1 = new Account();
        accountTest1.FirstName = 'TestFirst';
        accountTest1.LastName = 'TestLast';
        accountTest1.EID__c = '12345';
        accountTest1.EID__pc = '12345';
        accountTest1.PersonMailingState = 'CA';
        accountTest1.RecordTypeId = newRecord.Id;
        insert accountTest1;
        contact cont = [select Id from contact where accountId =: accountTest1.Id];
        Id ecmRecordTypeID = Schema.SObjectType.Case.getRecordTypeInfosByName().get('Case Overview').getRecordTypeId();
        Case coCas = TestDataFactory.createCases(1)[0];
        coCas.RecordTypeId =ecmRecordTypeID;
        coCas.AccountId = accountTest1.Id;
        coCas.ContactId = cont.Id;
        Insert coCas;
        lightningSingleRelatedListApexController.getCaseFromId(accountTest1.Id);
    }
}