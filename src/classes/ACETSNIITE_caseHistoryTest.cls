@istest(seealldata=false)
public class ACETSNIITE_caseHistoryTest {

    @isTest static void ACETSNIITE_caseHistoryTest() {
        RecordType newRecord = [SELECT Id FROM RecordType WHERE Name = 'Individual' and SObjectType = 'Account'];
    	Account accountTest1 = new Account();
        accountTest1.FirstName = 'TestFirst';
        accountTest1.LastName = 'TestLast';
        accountTest1.EID__c = '12345';
        accountTest1.EID__pc = '12345';
        accountTest1.RecordTypeId = newRecord.Id;
        insert accountTest1;
        
        Id ecmRecordTypeID = Schema.SObjectType.Case.getRecordTypeInfosByName().get('ECM').getRecordTypeId();
        Case ecmCas = TestDataFactory.createCases(1)[0];
        ecmCas.RecordTypeId =ecmRecordTypeID;
        ecmCas.Topic__c = 'Appeals - Post Service';
        ecmCas.Type__c = 'Family Advisor';
        ecmCas.AccountId = accountTest1.Id;
        Insert ecmCas;
       
        Account acct = new Account(Name='HelloWorld');
        insert acct;

        Contact con = new Contact(AccountId = acct.id,lastname = 'testdata' , firstname ='testdata1');
        insert con; 

        AccountContactRelation acctcr = new AccountContactRelation(AccountId = accountTest1.id, ContactId = con.id, IsActive = TRUE);
        insert acctcr;

        ACETSNIITE_caseHistory.getCaseHistoryResults(acct.Id);
        
      
    }
}