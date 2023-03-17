/************************************************************
Class Name: CaseOpenCountUpdateBatchTest
Description: using this for code coverage of CaseOpenCountUpdateBatch class
--------------------------------------------------------------
DEVELOPER         DATE             
---------------------------------------------------------------
Ravi Kishore      22/03/2021         
***************************************************************/
@isTest
public class CaseOpenCountUpdateBatchTest {
    
    public static testMethod void caseHistoryTestMethod() {
        test.startTest();
     Id individualRecordId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Individual').getRecordTypeId();
     Id familyRecordId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Family').getRecordTypeId();
     List<Account> acts = new List<Account>();
        Account busAcc= new Account(Name='Test Family', phone='1001290986');
        busAcc.RecordTypeId = familyRecordId;
        busAcc.UHG_Restriction__c='No';
        busAcc.Policy_ID__c='0915181';
        busAcc.Member_ID__c='0123456';
        acts.add(busAcc);
        Account accountTest1 = new Account();
        accountTest1.FirstName = 'TestFirst';
        accountTest1.LastName = 'TestLast';
        accountTest1.EID__c = '12345';
        accountTest1.EID__pc = '12345';
        accountTest1.PersonMailingState = 'CA';
        accountTest1.RecordTypeId = individualRecordId;
        acts.add(accountTest1);
        insert acts;
        
        Contact con = new Contact(lastName = 'test');
        insert con;
        
        contact cont = [select Id from contact limit 1];

        AccountContactRelation acr=new AccountContactRelation();
        acr.AccountId=busAcc.ID;
        acr.ContactId=cont.ID;
        acr.Relationship__c='Subscriber/Recipient';
        acr.Policy_ID__c='0915181';
        acr.Member_ID__c='0123456';
        Insert acr;
        
        Case cs = new Case(subject='text',contactid = cont.id);
        insert cs;
        
        //List<Case> cases = new List<Case>{};
        Case cas = [select Id from Case where ContactId =: cont.ID LIMIT 1];
        Id ecmRecordTypeID = Schema.SObjectType.Case.getRecordTypeInfosByName().get('ECM').getRecordTypeId();
        Case ecmCas = TestDataFactory.createCases(1)[0];
        ecmCas.RecordTypeId =ecmRecordTypeID;
        ecmCas.Topic__c = 'Appeals - Post Service';
        ecmCas.AccountId = accountTest1.Id;
        ecmCas.ContactId = cont.Id;
        ecmCas.UHG_Restriction__c = 'No';
        ecmCas.DOB__c = '1999/08/09';
        ecmCas.ID__c = '0123456';
        ecmCas.Onshore_Restriction__c = 'No';
        ecmCas.Subject_Name__c = 'ECM Test case' ;
        ecmCas.Subject_Group_ID__c = '0915181';
        ecmCas.ParentId =cas.Id;
        ecmCas.status='Open';
        ecmCas.Case_Type__c='Opportunity';
        //cases.add(ecmCas);
        insert ecmCas;
        CaseOpenCountUpdateBatch obj = new CaseOpenCountUpdateBatch();
        DataBase.executeBatch(obj);
        test.stopTest();
    }
}