@istest
public class ACETGetCases_Test {
    @testSetup static void setupCS(){

        Id recordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Family').getRecordTypeId();
        List<Account> accList=new List<Account>();
        Account ac = new Account();
        ac.Member_ID__c = '123543987';
        ac.Policy_ID__c = '1230987';
        ac.Name = 'FLTestAcc123';
        ac.RecordTypeId = recordTypeId;
        Insert ac;
        Id personAccRecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Individual').getRecordTypeId();
        Account pa =new account();
        pa.PersonBirthdate = date.valueOf(ACETUtility.formatDateFutureDate('6/17/1979'));
        pa.firstName = 'Community';
        pa.lastName = 'FLViewAuthTestUser';
        pa.RecordTypeId = personAccRecordTypeId;
        accList.add(pa);
        insert accList;
        
        List<Contact> conId = [SELECT id from contact where accountId =: pa.Id];
        AccountContactRelation accConRelation = new AccountContactRelation();
        accConRelation.AccountId = ac.Id;
        accConRelation.ContactId = conId[0].Id;
        insert accConRelation;
        
        Family_Overview__c fo = new Family_Overview__c();
        fo.Name='test';
        fo.Account__c = ac.Id;
        insert fo;
        
        Member_Information__c mi = new Member_Information__c();
        mi.Name = 'test';
        mi.Account__c = pa.Id;
        insert mi;
        Test.startTest();
        Id ecmRecordTypeID = Schema.SObjectType.Case.getRecordTypeInfosByName().get('ECM').getRecordTypeId();
        Case ecmCas = TestDataFactory.createCases(1)[0];
        ecmCas.RecordTypeId =ecmRecordTypeID;
        ecmCas.Topic__c = 'Appeals - Post Service';
        ecmCas.AccountId = pa.Id;
        ecmCas.ContactId = conId[0].Id;
        ecmCas.UHG_Restriction__c = 'No';
        ecmCas.DOB__c = '1999/08/09';
        //ecmCas.ID__c = '';
        ecmCas.Onshore_Restriction__c = 'No';
        ecmCas.Subject_Name__c = 'ECM Test case' ;
        ecmCas.Subject_Group_ID__c = '0915181';
        ecmCas.ORS_Issue_ID__c = '0915181';
        ecmCas.Facets_Issue_ID__c  = '0915181';
        ecmCas.status='Open';
        insert ecmCas;
    
    } 
    static testMethod void casesTest() { 
        List<Case> csList = [SELECT ID,casenumber,Originator_Type__c,CreatedDate,Subject_Name__c,Relationship__c,ORS_Issue_ID__c,Facets_Issue_ID__c ,Topic__c,Original_Subtype__c,status  FROM case WHERE status = 'Open' LIMIT 1];
        ACETGetCases.CaseWrapper csWrap = new ACETGetCases.CaseWrapper();
        csWrap.subject = 'test';
        csWrap.IDType = 'test';
        
        ACETGetCases.getRelatedCases('1234','12345',true,'Member');
        ACETGetCases.getRelatedCases('1234','12345',false,'Member');
        ACETGetCases.getRelatedCases('1234','12345',true,'test');
        ACETGetCases.getCases(csList);
    }
}