@isTest
public class AssociatedCasesTriggerHandler_Test{
    static testMethod void popRelCaseMethod(){
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
        
        Id ecmRecordTypeID = Schema.SObjectType.Case.getRecordTypeInfosByName().get('ECM').getRecordTypeId();
        Case ecmCas = TestDataFactory.createCases(1)[0];
        ecmCas.RecordTypeId =ecmRecordTypeID;
        ecmCas.Topic__c = 'Appeals - Post Service';
        ecmCas.AccountId = pa.Id;
        ecmCas.ContactId = conId[0].Id;
        ecmCas.UHG_Restriction__c = 'No';
        ecmCas.DOB__c = '1999/08/09';
        ecmCas.Onshore_Restriction__c = 'No';
        ecmCas.Subject_Name__c = 'ECM Test case' ;
        ecmCas.Subject_Group_ID__c = '0915181';
        ecmCas.status='Open';
        insert ecmCas;
        
        Case ecmCas1 = TestDataFactory.createCases(1)[0];
        ecmCas1.RecordTypeId =ecmRecordTypeID;
        ecmCas1.Topic__c = 'Appeals - Post Service';
        ecmCas1.AccountId = pa.Id;
        ecmCas1.ContactId = conId[0].Id;
        ecmCas1.UHG_Restriction__c = 'No';
        ecmCas1.DOB__c = '1999/08/09';
        ecmCas1.Onshore_Restriction__c = 'No';
        ecmCas1.Subject_Name__c = 'ECM Test case' ;
        ecmCas1.Subject_Group_ID__c = '0915181';
        ecmCas1.status='Open';
        insert ecmCas1;
        
        Associated_Cases__c assCs = new Associated_Cases__c();
        assCs.Case__c = ecmCas.id;
        //assCs.Member__c = pa.id;
        assCs.Parent_Case__c = ecmCas.id;
        insert assCs;
        
        Associated_Cases__c assCs1 = new Associated_Cases__c();
        assCs1.Case__c = ecmCas1.id;
        //assCs1.Member__c = pa.id;
        assCs1.Parent_Case__c = ecmCas1.id;
        insert assCs1;
        
        Map<Id, Associated_Cases__c> associatedCasesNewMap = new Map<Id, Associated_Cases__c>();
        associatedCasesNewMap.put(assCs.id,assCs);
        
        AssociatedCasesTriggerHandler.populateRelatedCases(associatedCasesNewMap,true);
        
        delete assCs1;
    }
}