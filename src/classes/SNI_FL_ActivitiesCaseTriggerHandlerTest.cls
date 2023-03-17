@isTest
public class SNI_FL_ActivitiesCaseTriggerHandlerTest {
    
    @isTest public static void caseStatusCapture(){
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
        
        Contact con = new contact(lastname='test');
        insert con;
        
        Case cs = new case(Subject = 'test', contactId = con.id);
        insert cs;
        contact cont = [select Id from contact LIMIT 1];

        AccountContactRelation acr=new AccountContactRelation();
        acr.AccountId=busAcc.ID;
        acr.ContactId=cont.ID;
        acr.Relationship__c='Subscriber/Recipient';
        acr.Policy_ID__c='0915181';
        acr.Member_ID__c='0123456';
        Insert acr;
        
        Case cas = [select Id from Case LIMIT 1];
        Id ecmRecordTypeID = Schema.SObjectType.Case.getRecordTypeInfosByName().get('ECM').getRecordTypeId();
        Case ecmCas = TestDataFactory.createCases(1)[0];
        ecmCas.RecordTypeId =ecmRecordTypeID;
        ecmCas.Topic__c = 'Appeals - Post Service';
        ecmCas.AccountId = accountTest1.Id;
        ecmCas.ContactId = cont.Id;
        ecmCas.UHG_Restriction__c = 'No';
        ecmCas.DOB__c = '1999/08/09';
        
        ecmCas.Onshore_Restriction__c = 'No';
        ecmCas.Subject_Name__c = 'ECM Test case' ;
        ecmCas.Subject_Group_ID__c = '0915181';
        ecmCas.ParentId =cas.Id;
        ecmCas.status='Open';
        ecmCas.Case_Type__c ='Opportunity';
        
        insert ecmCas;
        List<SNI_FL_Activity_History__c> ActivityHistory = [select Id from SNI_FL_Activity_History__c where ParentId__c = :ecmCas.Id];
        //System.assertEquals(1, ActivityHistory.size());
        
        RecursiveTriggerHandler.isFirstCaseHistory = true;
        ecmCas.status='Closed';
        update ecmCas;
        List<SNI_FL_Activity_History__c> ActivityHistory1 = [select Id, Name, New_Value__c from SNI_FL_Activity_History__c where ParentId__c = :ecmCas.Id];
        
        //System.assertEquals(2, ActivityHistory1.size());
        
        test.stopTest();
        
     }

}