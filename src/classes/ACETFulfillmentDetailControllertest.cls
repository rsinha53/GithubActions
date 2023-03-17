@istest
public with sharing class ACETFulfillmentDetailControllertest{
   
     static testmethod void testLetter1(){
        
       /* Account accountObj = ACETTestDataUtility.CreateAccount('test','1234567','123456789');
        insert accountObj;
        
        contact newContact= new contact();
        newContact.lastName='contact1';
        newContact.Birthdate = system.today();
        insert newContact;*/
         RecordType newRecord = [SELECT Id FROM RecordType WHERE Name = 'Person Account' and SObjectType = 'Account'];
        
        Account accountTest = new Account();
        accountTest.FirstName = 'Test Contact FN1';
        accountTest.LastName = 'Test Contact LN1';
        accountTest.EID__c = 'TestEID1';
        accountTest.EID__pc = 'TestEID1';
        accountTest.RecordTypeId = newRecord.Id;
        insert accountTest;

    Account accountObj = [SELECT Id,personcontactid from Account where Id=:accountTest.Id];
        Contact newContact = [SELECT Id,LastName,FirstName,EID__c,AccountId from Contact where Id=:accountObj.personcontactid];
        
        
        Map<String, String> mapTestCaseDetails = new Map<String, String>();
        mapTestCaseDetails.put('AccountId', accountObj.Id);
        mapTestCaseDetails.put('ContactId', newContact.Id);
        mapTestCaseDetails.put('Status', 'Canceled');
        mapTestCaseDetails.put('Origin', 'Phone');
        mapTestCaseDetails.put('Topic__c', 'View Claims');
        Case TestCase = ACETTestDataUtility.CreateTestCase(mapTestCaseDetails); 
        insert TestCase;
        
        Create_Letter__c fulfillment = new Create_Letter__c();
        fulfillment.Letter_Name__c = 'Balance Bill Letter';
        fulfillment.Case__c = TestCase.Id;
        fulfillment.Review_on_ActiveX__c = true;
        fulfillment.Letter_Status__c = 'Pending Submission';
        fulfillment.Submitted_By__c = userinfo.getName();
        fulfillment.Letter_Name__c='Balance Bill Letter';
        insert fulfillment;
        
        ACETOrgInstanceURLToOrgNameMap__c urlinstance = new ACETOrgInstanceURLToOrgNameMap__c();
        urlinstance.Name = 'devacet--acetdev.cs26';
        urlinstance.Org_Name__c = 'dev';
        insert urlinstance;
        
        ACETOrgInstanceURLToOrgNameMap__c urlinstance2 = new ACETOrgInstanceURLToOrgNameMap__c();
        urlinstance2.Name = 'qaacet--acetqa--c.cs26';
        urlinstance2.Org_Name__c = 'qa';
        insert urlinstance2;
        
        ACETOrgInstanceURLToOrgNameMap__c urlinstance3 = new ACETOrgInstanceURLToOrgNameMap__c();
        urlinstance3.Name = 'cs14';
        urlinstance3.Org_Name__c = 'd1';
        insert urlinstance3;
        
        ACETOrgInstanceURLToOrgNameMap__c urlinstance4 = new ACETOrgInstanceURLToOrgNameMap__c();
        urlinstance4.Name = 'devacet101--acetdev101.cs26';
        urlinstance4.Org_Name__c = 'dev101';
        insert urlinstance4;
        
        ACETOrgInstanceURLToOrgNameMap__c urlinstance5 = new ACETOrgInstanceURLToOrgNameMap__c();
        urlinstance5.Name = 'qaacet101--acetqa101.cs26';
        urlinstance5.Org_Name__c = 'qa101';
        insert urlinstance5;
        
        ACETOrgInstanceURLToOrgNameMap__c urlinstance6 = new ACETOrgInstanceURLToOrgNameMap__c();
        urlinstance6.Name = 'acet-uhg';
        urlinstance6.Org_Name__c = 'prd';
        insert urlinstance6;
        
        ACETOrgInstanceURLToOrgNameMap__c urlinstance7 = new ACETOrgInstanceURLToOrgNameMap__c();
        urlinstance7.Name = 'cs17';
        urlinstance7.Org_Name__c = 'qa';
        insert urlinstance7;
        
        ACETOrgNameToSwivelEndpointMap__c swivel = new ACETOrgNameToSwivelEndpointMap__c();
        swivel.Name = 'dev_EngageOne';
        swivel.Swivel_Endpoint__c = 'http://apsed4198.ms.ds.uhc.com:9090/editor/v1/EngageOne/tasks/workitem?';
        insert swivel;
        
        ACETOrgNameToSwivelEndpointMap__c swivel1 = new ACETOrgNameToSwivelEndpointMap__c();
        swivel1.Name = 'qa_EngageOne';
        swivel1.Swivel_Endpoint__c = 'http://apsed4198.ms.ds.uhc.com:9090/editor/v1/EngageOne/tasks/workitem?';
        insert swivel1;
        
        ACETOrgNameToSwivelEndpointMap__c swivel2 = new ACETOrgNameToSwivelEndpointMap__c();
        swivel2.Name = 'd1_EngageOne';
        swivel2.Swivel_Endpoint__c = 'http://apsed4198.ms.ds.uhc.com:9090/editor/v1/EngageOne/tasks/workitem?';
        insert swivel2;
        
        ACETOrgNameToSwivelEndpointMap__c swivel3 = new ACETOrgNameToSwivelEndpointMap__c();
        swivel3.Name = 'prd_EngageOne';
        swivel3.Swivel_Endpoint__c = 'http://apsed4198.ms.ds.uhc.com:9090/editor/v1/EngageOne/tasks/workitem?';
        insert swivel3;
        
        ACETWrapEncryptionKey__c devkey = new ACETWrapEncryptionKey__c();
        devkey.Name = 'dev_Engageonekey';
        devkey.Algorithm_Name__c = 'AES256';
        devkey.Key__c = 'JYbyFR9zdZFrGRzgaJtCTyLpFkIXFOs4';
        insert devkey;
        
        ACETWrapEncryptionKey__c qakey = new ACETWrapEncryptionKey__c();
        qakey.Name = 'qa_Engageonekey';
        qakey.Algorithm_Name__c = 'AES256';
        qakey.Key__c = 'JYbyFR9zdZFrGRzgaJtCTyLpFkIXFOs4';
        insert qakey;
        
        ACETWrapEncryptionKey__c dev1key = new ACETWrapEncryptionKey__c();
        dev1key.Name = 'd1_Engageonekey';
        dev1key.Algorithm_Name__c = 'AES256';
        dev1key.Key__c = 'JYbyFR9zdZFrGRzgaJtCTyLpFkIXFOs4';
        insert dev1key;
        
        ACETWrapEncryptionKey__c prdkey = new ACETWrapEncryptionKey__c();
        prdkey.Name = 'prd_Engageonekey';
        prdkey.Algorithm_Name__c = 'AES256';
        prdkey.Key__c = 'JYbyFR9zdZFrGRzgaJtCTyLpFkIXFOs4';
        insert prdkey;
        
        PageReference pgRef=Page.ACETFulfillmentDetail;
        Test.setCurrentPage(pgRef);
        ApexPages.currentPage().getParameters().put('letterid',fulfillment.id);
        ApexPages.currentPage().getParameters().put('myparam','testparam');
        ApexPages.StandardController sc=new ApexPages.StandardController(fulfillment);
        ACETFulfillmentDetailController acetFulDtlCntr=new ACETFulfillmentDetailController(sc);
        acetFulDtlCntr.CC='Test';
        acetFulDtlCntr.rendersubmitletter=false;
        acetFulDtlCntr.SubmitLetter();
        acetFulDtlCntr.LaunchActiveX();  
         acetFulDtlCntr.DisplayMessage();  
         try{
        acetFulDtlCntr.CancelLetter();
         }
         Catch(Exception e)
         {
             
         }
            
     }
     
     static testmethod void testLetter2(){
        
       /* Account accountObj = ACETTestDataUtility.CreateAccount('test','1234567','123456789');
        insert accountObj;
        
        contact newContact= new contact();
        newContact.lastName='contact1';
        newContact.Birthdate = system.today();
        insert newContact;*/
         RecordType newRecord = [SELECT Id FROM RecordType WHERE Name = 'Person Account' and SObjectType = 'Account'];
        
        Account accountTest = new Account();
        accountTest.FirstName = 'Test Contact FN1';
        accountTest.LastName = 'Test Contact LN1';
        accountTest.EID__c = 'TestEID1';
        accountTest.EID__pc = 'TestEID1';
        accountTest.RecordTypeId = newRecord.Id;
        insert accountTest;

    Account accountObj = [SELECT Id,personcontactid from Account where Id=:accountTest.Id];
        Contact newContact = [SELECT Id,LastName,FirstName,EID__c,AccountId from Contact where Id=:accountObj.personcontactid];
        
        
        Map<String, String> mapTestCaseDetails = new Map<String, String>();
        mapTestCaseDetails.put('AccountId', accountObj.Id);
        mapTestCaseDetails.put('ContactId', newContact.Id);
        mapTestCaseDetails.put('Status', 'Canceled');
        mapTestCaseDetails.put('Origin', 'Phone');
        mapTestCaseDetails.put('Topic__c', 'View Claims');
        Case TestCase = ACETTestDataUtility.CreateTestCase(mapTestCaseDetails); 
        insert TestCase;
        
        Create_Letter__c fulfillment = new Create_Letter__c();
        fulfillment.Letter_Name__c = 'Balance Bill Letter';
        fulfillment.Case__c = TestCase.Id;
        fulfillment.Review_on_ActiveX__c = true;
        fulfillment.Letter_Status__c = 'Pending Fulfillment';
        fulfillment.Submitted_By__c = userinfo.getName();
        fulfillment.Letter_Name__c='Balance Bill Letter';
        insert fulfillment;
        
        ACETOrgInstanceURLToOrgNameMap__c urlinstance = new ACETOrgInstanceURLToOrgNameMap__c();
        urlinstance.Name = 'devacet--acetdev.cs26';
        urlinstance.Org_Name__c = 'dev';
        insert urlinstance;
        
        ACETOrgInstanceURLToOrgNameMap__c urlinstance2 = new ACETOrgInstanceURLToOrgNameMap__c();
        urlinstance2.Name = 'qaacet--acetqa--c.cs26';
        urlinstance2.Org_Name__c = 'qa';
        insert urlinstance2;
        
        ACETOrgInstanceURLToOrgNameMap__c urlinstance3 = new ACETOrgInstanceURLToOrgNameMap__c();
        urlinstance3.Name = 'cs14';
        urlinstance3.Org_Name__c = 'd1';
        insert urlinstance3;
        
        ACETOrgInstanceURLToOrgNameMap__c urlinstance4 = new ACETOrgInstanceURLToOrgNameMap__c();
        urlinstance4.Name = 'devacet101--acetdev101.cs26';
        urlinstance4.Org_Name__c = 'dev101';
        insert urlinstance4;
        
        ACETOrgInstanceURLToOrgNameMap__c urlinstance5 = new ACETOrgInstanceURLToOrgNameMap__c();
        urlinstance5.Name = 'qaacet101--acetqa101.cs26';
        urlinstance5.Org_Name__c = 'qa101';
        insert urlinstance5;
        
        ACETOrgInstanceURLToOrgNameMap__c urlinstance6 = new ACETOrgInstanceURLToOrgNameMap__c();
        urlinstance6.Name = 'acet-uhg';
        urlinstance6.Org_Name__c = 'prd';
        insert urlinstance6;
        
        ACETOrgInstanceURLToOrgNameMap__c urlinstance7 = new ACETOrgInstanceURLToOrgNameMap__c();
        urlinstance7.Name = 'cs17';
        urlinstance7.Org_Name__c = 'qa';
        insert urlinstance7;
        
        ACETOrgNameToSwivelEndpointMap__c swivel = new ACETOrgNameToSwivelEndpointMap__c();
        swivel.Name = 'dev_EngageOne';
        swivel.Swivel_Endpoint__c = 'http://apsed4198.ms.ds.uhc.com:9090/editor/v1/EngageOne/tasks/workitem?';
        insert swivel;
        
        ACETOrgNameToSwivelEndpointMap__c swivel1 = new ACETOrgNameToSwivelEndpointMap__c();
        swivel1.Name = 'qa_EngageOne';
        swivel1.Swivel_Endpoint__c = 'http://apsed4198.ms.ds.uhc.com:9090/editor/v1/EngageOne/tasks/workitem?';
        insert swivel1;
        
        ACETOrgNameToSwivelEndpointMap__c swivel2 = new ACETOrgNameToSwivelEndpointMap__c();
        swivel2.Name = 'd1_EngageOne';
        swivel2.Swivel_Endpoint__c = 'http://apsed4198.ms.ds.uhc.com:9090/editor/v1/EngageOne/tasks/workitem?';
        insert swivel2;
        
        ACETOrgNameToSwivelEndpointMap__c swivel3 = new ACETOrgNameToSwivelEndpointMap__c();
        swivel3.Name = 'prd_EngageOne';
        swivel3.Swivel_Endpoint__c = 'http://apsed4198.ms.ds.uhc.com:9090/editor/v1/EngageOne/tasks/workitem?';
        insert swivel3;
        
        ACETWrapEncryptionKey__c devkey = new ACETWrapEncryptionKey__c();
        devkey.Name = 'dev_Engageonekey';
        devkey.Algorithm_Name__c = 'AES256';
        devkey.Key__c = 'JYbyFR9zdZFrGRzgaJtCTyLpFkIXFOs4';
        insert devkey;
        
        ACETWrapEncryptionKey__c qakey = new ACETWrapEncryptionKey__c();
        qakey.Name = 'qa_Engageonekey';
        qakey.Algorithm_Name__c = 'AES256';
        qakey.Key__c = 'JYbyFR9zdZFrGRzgaJtCTyLpFkIXFOs4';
        insert qakey;
        
        ACETWrapEncryptionKey__c dev1key = new ACETWrapEncryptionKey__c();
        dev1key.Name = 'd1_Engageonekey';
        dev1key.Algorithm_Name__c = 'AES256';
        dev1key.Key__c = 'JYbyFR9zdZFrGRzgaJtCTyLpFkIXFOs4';
        insert dev1key;
        
        ACETWrapEncryptionKey__c prdkey = new ACETWrapEncryptionKey__c();
        prdkey.Name = 'prd_Engageonekey';
        prdkey.Algorithm_Name__c = 'AES256';
        prdkey.Key__c = 'JYbyFR9zdZFrGRzgaJtCTyLpFkIXFOs4';
        insert prdkey;
        
        PageReference pgRef=Page.ACETFulfillmentDetail;
        Test.setCurrentPage(pgRef);
        ApexPages.currentPage().getParameters().put('letterid',fulfillment.id);
        ACETFulfillmentDetailController CONT;
        ApexPages.StandardController sc=new ApexPages.StandardController(fulfillment);
        CONT=new ACETFulfillmentDetailController(sc);
        CONT.CC='Test';
        CONT.strSubmittedBy='Test';
                 
     }
     static testmethod void testLetter3(){
        
      /*  Account accountObj = ACETTestDataUtility.CreateAccount('test','1234567','123456789');
        insert accountObj;
        
        contact newContact= new contact();
        newContact.lastName='contact1';
        newContact.Birthdate = system.today();
        insert newContact;*/
         RecordType newRecord = [SELECT Id FROM RecordType WHERE Name = 'Person Account' and SObjectType = 'Account'];
        
        Account accountTest = new Account();
        accountTest.FirstName = 'Test Contact FN1';
        accountTest.LastName = 'Test Contact LN1';
        accountTest.EID__c = 'TestEID1';
        accountTest.EID__pc = 'TestEID1';
        accountTest.RecordTypeId = newRecord.Id;
        insert accountTest;

    Account accountObj = [SELECT Id,personcontactid from Account where Id=:accountTest.Id];
        Contact newContact = [SELECT Id,LastName,FirstName,EID__c,AccountId from Contact where Id=:accountObj.personcontactid];
        
        
        Map<String, String> mapTestCaseDetails = new Map<String, String>();
        mapTestCaseDetails.put('AccountId', accountObj.Id);
        mapTestCaseDetails.put('ContactId', newContact.Id);
        mapTestCaseDetails.put('Status', 'Canceled');
        mapTestCaseDetails.put('Origin', 'Phone');
        mapTestCaseDetails.put('Topic__c', 'View Claims');
        Case TestCase = ACETTestDataUtility.CreateTestCase(mapTestCaseDetails); 
        insert TestCase;
        
        Create_Letter__c fulfillment = new Create_Letter__c();
        fulfillment.Letter_Name__c = 'Balance Bill Letter';
        fulfillment.Case__c = TestCase.Id;
        fulfillment.Review_on_ActiveX__c = true;
        fulfillment.Letter_Status__c = 'Cancelled';
        fulfillment.Submitted_By__c = userinfo.getName();
        fulfillment.Letter_Name__c='Balance Bill Letter';
        insert fulfillment;
        
        ACETOrgInstanceURLToOrgNameMap__c urlinstance = new ACETOrgInstanceURLToOrgNameMap__c();
        urlinstance.Name = 'devacet--acetdev.cs26';
        urlinstance.Org_Name__c = 'dev';
        insert urlinstance;
        
        ACETOrgInstanceURLToOrgNameMap__c urlinstance2 = new ACETOrgInstanceURLToOrgNameMap__c();
        urlinstance2.Name = 'qaacet--acetqa--c.cs26';
        urlinstance2.Org_Name__c = 'qa';
        insert urlinstance2;
        
        ACETOrgInstanceURLToOrgNameMap__c urlinstance3 = new ACETOrgInstanceURLToOrgNameMap__c();
        urlinstance3.Name = 'cs14';
        urlinstance3.Org_Name__c = 'd1';
        insert urlinstance3;
        
        ACETOrgInstanceURLToOrgNameMap__c urlinstance4 = new ACETOrgInstanceURLToOrgNameMap__c();
        urlinstance4.Name = 'devacet101--acetdev101.cs26';
        urlinstance4.Org_Name__c = 'dev101';
        insert urlinstance4;
        
        ACETOrgInstanceURLToOrgNameMap__c urlinstance5 = new ACETOrgInstanceURLToOrgNameMap__c();
        urlinstance5.Name = 'qaacet101--acetqa101.cs26';
        urlinstance5.Org_Name__c = 'qa101';
        insert urlinstance5;
        
        ACETOrgInstanceURLToOrgNameMap__c urlinstance6 = new ACETOrgInstanceURLToOrgNameMap__c();
        urlinstance6.Name = 'acet-uhg';
        urlinstance6.Org_Name__c = 'prd';
        insert urlinstance6;
        
        ACETOrgInstanceURLToOrgNameMap__c urlinstance7 = new ACETOrgInstanceURLToOrgNameMap__c();
        urlinstance7.Name = 'cs17';
        urlinstance7.Org_Name__c = 'qa';
        insert urlinstance7;
        
        ACETOrgNameToSwivelEndpointMap__c swivel = new ACETOrgNameToSwivelEndpointMap__c();
        swivel.Name = 'dev_EngageOne';
        swivel.Swivel_Endpoint__c = 'http://apsed4198.ms.ds.uhc.com:9090/editor/v1/EngageOne/tasks/workitem?';
        insert swivel;
        
        ACETOrgNameToSwivelEndpointMap__c swivel1 = new ACETOrgNameToSwivelEndpointMap__c();
        swivel1.Name = 'qa_EngageOne';
        swivel1.Swivel_Endpoint__c = 'http://apsed4198.ms.ds.uhc.com:9090/editor/v1/EngageOne/tasks/workitem?';
        insert swivel1;
        
        ACETOrgNameToSwivelEndpointMap__c swivel2 = new ACETOrgNameToSwivelEndpointMap__c();
        swivel2.Name = 'd1_EngageOne';
        swivel2.Swivel_Endpoint__c = 'http://apsed4198.ms.ds.uhc.com:9090/editor/v1/EngageOne/tasks/workitem?';
        insert swivel2;
        
        ACETOrgNameToSwivelEndpointMap__c swivel3 = new ACETOrgNameToSwivelEndpointMap__c();
        swivel3.Name = 'prd_EngageOne';
        swivel3.Swivel_Endpoint__c = 'http://apsed4198.ms.ds.uhc.com:9090/editor/v1/EngageOne/tasks/workitem?';
        insert swivel3;
        
        ACETWrapEncryptionKey__c devkey = new ACETWrapEncryptionKey__c();
        devkey.Name = 'dev_Engageonekey';
        devkey.Algorithm_Name__c = 'AES256';
        devkey.Key__c = 'JYbyFR9zdZFrGRzgaJtCTyLpFkIXFOs4';
        insert devkey;
        
        ACETWrapEncryptionKey__c qakey = new ACETWrapEncryptionKey__c();
        qakey.Name = 'qa_Engageonekey';
        qakey.Algorithm_Name__c = 'AES256';
        qakey.Key__c = 'JYbyFR9zdZFrGRzgaJtCTyLpFkIXFOs4';
        insert qakey;
        
        ACETWrapEncryptionKey__c dev1key = new ACETWrapEncryptionKey__c();
        dev1key.Name = 'd1_Engageonekey';
        dev1key.Algorithm_Name__c = 'AES256';
        dev1key.Key__c = 'JYbyFR9zdZFrGRzgaJtCTyLpFkIXFOs4';
        insert dev1key;
        
        ACETWrapEncryptionKey__c prdkey = new ACETWrapEncryptionKey__c();
        prdkey.Name = 'prd_Engageonekey';
        prdkey.Algorithm_Name__c = 'AES256';
        prdkey.Key__c = 'JYbyFR9zdZFrGRzgaJtCTyLpFkIXFOs4';
        insert prdkey;
        
        PageReference pgRef=Page.ACETFulfillmentDetail;
        Test.setCurrentPage(pgRef);
        ApexPages.currentPage().getParameters().put('letterid',fulfillment.id);
        ACETFulfillmentDetailController CONT;
        ApexPages.StandardController sc=new ApexPages.StandardController(fulfillment);
        CONT=new ACETFulfillmentDetailController(sc);
        CONT.CC='Test';
        CONT.strSubmittedBy='Test';
                 
     }
     static testmethod void testLetter4(){
        
        /*Account accountObj = ACETTestDataUtility.CreateAccount('test','1234567','123456789');
        insert accountObj;
        
        contact newContact= new contact();
        newContact.lastName='contact1';
        newContact.Birthdate = system.today();
        insert newContact;*/
         RecordType newRecord = [SELECT Id FROM RecordType WHERE Name = 'Person Account' and SObjectType = 'Account'];
        
        Account accountTest = new Account();
        accountTest.FirstName = 'Test Contact FN1';
        accountTest.LastName = 'Test Contact LN1';
        accountTest.EID__c = 'TestEID1';
        accountTest.EID__pc = 'TestEID1';
        accountTest.RecordTypeId = newRecord.Id;
        insert accountTest;

    Account accountObj = [SELECT Id,personcontactid from Account where Id=:accountTest.Id];
        Contact newContact = [SELECT Id,LastName,FirstName,EID__c,AccountId from Contact where Id=:accountObj.personcontactid];
        
        
        Map<String, String> mapTestCaseDetails = new Map<String, String>();
        mapTestCaseDetails.put('AccountId', accountObj.Id);
        mapTestCaseDetails.put('ContactId', newContact.Id);
        mapTestCaseDetails.put('Status', 'Canceled');
        mapTestCaseDetails.put('Origin', 'Phone');
        mapTestCaseDetails.put('Topic__c', 'View Claims');
        Case TestCase = ACETTestDataUtility.CreateTestCase(mapTestCaseDetails); 
        insert TestCase;
        
        Create_Letter__c fulfillment = new Create_Letter__c();
        fulfillment.Letter_Name__c = 'Balance Bill Letter';
        fulfillment.Case__c = TestCase.Id;
        fulfillment.Review_on_ActiveX__c = true;
        fulfillment.Letter_Status__c = 'Canceled';
        fulfillment.Submitted_By__c = userinfo.getName();
        fulfillment.Letter_Name__c='Balance Bill Letter';
        insert fulfillment;
        
        ACETOrgInstanceURLToOrgNameMap__c urlinstance = new ACETOrgInstanceURLToOrgNameMap__c();
        urlinstance.Name = 'devacet--acetdev.cs26';
        urlinstance.Org_Name__c = 'dev';
        insert urlinstance;
        
        ACETOrgInstanceURLToOrgNameMap__c urlinstance2 = new ACETOrgInstanceURLToOrgNameMap__c();
        urlinstance2.Name = 'qaacet--acetqa--c.cs26';
        urlinstance2.Org_Name__c = 'qa';
        insert urlinstance2;
        
        ACETOrgInstanceURLToOrgNameMap__c urlinstance3 = new ACETOrgInstanceURLToOrgNameMap__c();
        urlinstance3.Name = 'cs14';
        urlinstance3.Org_Name__c = 'd1';
        insert urlinstance3;
        
        ACETOrgInstanceURLToOrgNameMap__c urlinstance4 = new ACETOrgInstanceURLToOrgNameMap__c();
        urlinstance4.Name = 'devacet101--acetdev101.cs26';
        urlinstance4.Org_Name__c = 'dev101';
        insert urlinstance4;
        
        ACETOrgInstanceURLToOrgNameMap__c urlinstance5 = new ACETOrgInstanceURLToOrgNameMap__c();
        urlinstance5.Name = 'qaacet101--acetqa101.cs26';
        urlinstance5.Org_Name__c = 'qa101';
        insert urlinstance5;
        
        ACETOrgInstanceURLToOrgNameMap__c urlinstance6 = new ACETOrgInstanceURLToOrgNameMap__c();
        urlinstance6.Name = 'acet-uhg';
        urlinstance6.Org_Name__c = 'prd';
        insert urlinstance6;
        
        ACETOrgInstanceURLToOrgNameMap__c urlinstance7 = new ACETOrgInstanceURLToOrgNameMap__c();
        urlinstance7.Name = 'cs17';
        urlinstance7.Org_Name__c = 'qa';
        insert urlinstance7;
        
        ACETOrgNameToSwivelEndpointMap__c swivel = new ACETOrgNameToSwivelEndpointMap__c();
        swivel.Name = 'dev_EngageOne';
        swivel.Swivel_Endpoint__c = 'http://apsed4198.ms.ds.uhc.com:9090/editor/v1/EngageOne/tasks/workitem?';
        insert swivel;
        
        ACETOrgNameToSwivelEndpointMap__c swivel1 = new ACETOrgNameToSwivelEndpointMap__c();
        swivel1.Name = 'qa_EngageOne';
        swivel1.Swivel_Endpoint__c = 'http://apsed4198.ms.ds.uhc.com:9090/editor/v1/EngageOne/tasks/workitem?';
        insert swivel1;
        
        ACETOrgNameToSwivelEndpointMap__c swivel2 = new ACETOrgNameToSwivelEndpointMap__c();
        swivel2.Name = 'd1_EngageOne';
        swivel2.Swivel_Endpoint__c = 'http://apsed4198.ms.ds.uhc.com:9090/editor/v1/EngageOne/tasks/workitem?';
        insert swivel2;
        
        ACETOrgNameToSwivelEndpointMap__c swivel3 = new ACETOrgNameToSwivelEndpointMap__c();
        swivel3.Name = 'prd_EngageOne';
        swivel3.Swivel_Endpoint__c = 'http://apsed4198.ms.ds.uhc.com:9090/editor/v1/EngageOne/tasks/workitem?';
        insert swivel3;
        
        ACETWrapEncryptionKey__c devkey = new ACETWrapEncryptionKey__c();
        devkey.Name = 'dev_Engageonekey';
        devkey.Algorithm_Name__c = 'AES256';
        devkey.Key__c = 'JYbyFR9zdZFrGRzgaJtCTyLpFkIXFOs4';
        insert devkey;
        
        ACETWrapEncryptionKey__c qakey = new ACETWrapEncryptionKey__c();
        qakey.Name = 'qa_Engageonekey';
        qakey.Algorithm_Name__c = 'AES256';
        qakey.Key__c = 'JYbyFR9zdZFrGRzgaJtCTyLpFkIXFOs4';
        insert qakey;
        
        ACETWrapEncryptionKey__c dev1key = new ACETWrapEncryptionKey__c();
        dev1key.Name = 'd1_Engageonekey';
        dev1key.Algorithm_Name__c = 'AES256';
        dev1key.Key__c = 'JYbyFR9zdZFrGRzgaJtCTyLpFkIXFOs4';
        insert dev1key;
        
        ACETWrapEncryptionKey__c prdkey = new ACETWrapEncryptionKey__c();
        prdkey.Name = 'prd_Engageonekey';
        prdkey.Algorithm_Name__c = 'AES256';
        prdkey.Key__c = 'JYbyFR9zdZFrGRzgaJtCTyLpFkIXFOs4';
        insert prdkey;
        
        PageReference pgRef=Page.ACETFulfillmentDetail;
        Test.setCurrentPage(pgRef);
        ApexPages.currentPage().getParameters().put('letterid',fulfillment.id);
        ACETFulfillmentDetailController CONT;
        ApexPages.StandardController sc=new ApexPages.StandardController(fulfillment);
        CONT=new ACETFulfillmentDetailController(sc);
        CONT.CC='Test';
        CONT.strSubmittedBy='Test';
        CONT.rendersubmitletter=true;
        ACETProcessLetterWebservice service = new ACETProcessLetterWebservice();
        ACETWSCalloutResult processLetterCalloutResult = new ACETWSCalloutResult();
        processLetterCalloutResult=service.ProcessLetterWS(fulfillment.Work_Item_Id__c, 'PUBLISH');
         
     }

     static testmethod void testLetterStatusSubmitted(){
        
       /* Account accountObj = ACETTestDataUtility.CreateAccount('test','1234567','123456789');
        insert accountObj;
        
        contact newContact= new contact();
        newContact.lastName='contact1';
        newContact.Birthdate = system.today();
        insert newContact;*/
         RecordType newRecord = [SELECT Id FROM RecordType WHERE Name = 'Person Account' and SObjectType = 'Account'];
        
        Account accountTest = new Account();
        accountTest.FirstName = 'Test Contact FN1';
        accountTest.LastName = 'Test Contact LN1';
        accountTest.EID__c = 'TestEID1';
        accountTest.EID__pc = 'TestEID1';
        accountTest.RecordTypeId = newRecord.Id;
        insert accountTest;

    Account accountObj = [SELECT Id,personcontactid from Account where Id=:accountTest.Id];
        Contact newContact = [SELECT Id,LastName,FirstName,EID__c,AccountId from Contact where Id=:accountObj.personcontactid];
        
        
        Map<String, String> mapTestCaseDetails = new Map<String, String>();
        mapTestCaseDetails.put('AccountId', accountObj.Id);
        mapTestCaseDetails.put('ContactId', newContact.Id);
        mapTestCaseDetails.put('Status', 'Canceled');
        mapTestCaseDetails.put('Origin', 'Phone');
        mapTestCaseDetails.put('Topic__c', 'View Claims');
        Case TestCase = ACETTestDataUtility.CreateTestCase(mapTestCaseDetails); 
        insert TestCase;
        
        Create_Letter__c fulfillment = new Create_Letter__c();
        fulfillment.Letter_Name__c = 'Balance Bill Letter';
        fulfillment.Case__c = TestCase.Id;
        fulfillment.Review_on_ActiveX__c = true;
        fulfillment.Letter_Status__c = 'Submitted';
        fulfillment.Submitted_By__c = userinfo.getName();
        fulfillment.Letter_Name__c='Balance Bill Letter';
        fulfillment.Work_Item_Id__c='testworkitemid';
        insert fulfillment;
        
        ACETOrgInstanceURLToOrgNameMap__c urlinstance = new ACETOrgInstanceURLToOrgNameMap__c();
        urlinstance.Name = 'devacet--acetdev.cs26';
        urlinstance.Org_Name__c = 'dev';
        insert urlinstance;
        
        ACETOrgInstanceURLToOrgNameMap__c urlinstance2 = new ACETOrgInstanceURLToOrgNameMap__c();
        urlinstance2.Name = 'qaacet--acetqa--c.cs26';
        urlinstance2.Org_Name__c = 'qa';
        insert urlinstance2;
        
        ACETOrgInstanceURLToOrgNameMap__c urlinstance3 = new ACETOrgInstanceURLToOrgNameMap__c();
        urlinstance3.Name = 'cs14';
        urlinstance3.Org_Name__c = 'd1';
        insert urlinstance3;
        
        ACETOrgInstanceURLToOrgNameMap__c urlinstance4 = new ACETOrgInstanceURLToOrgNameMap__c();
        urlinstance4.Name = 'devacet101--acetdev101.cs26';
        urlinstance4.Org_Name__c = 'dev101';
        insert urlinstance4;
        
        ACETOrgInstanceURLToOrgNameMap__c urlinstance5 = new ACETOrgInstanceURLToOrgNameMap__c();
        urlinstance5.Name = 'qaacet101--acetqa101.cs26';
        urlinstance5.Org_Name__c = 'qa101';
        insert urlinstance5;
        
        ACETOrgInstanceURLToOrgNameMap__c urlinstance6 = new ACETOrgInstanceURLToOrgNameMap__c();
        urlinstance6.Name = 'acet-uhg';
        urlinstance6.Org_Name__c = 'prd';
        insert urlinstance6;
        
        ACETOrgInstanceURLToOrgNameMap__c urlinstance7 = new ACETOrgInstanceURLToOrgNameMap__c();
        urlinstance7.Name = 'cs17';
        urlinstance7.Org_Name__c = 'qa';
        insert urlinstance7;
        
        ACETOrgNameToSwivelEndpointMap__c swivel = new ACETOrgNameToSwivelEndpointMap__c();
        swivel.Name = 'dev_EngageOne';
        swivel.Swivel_Endpoint__c = 'http://apsed4198.ms.ds.uhc.com:9090/editor/v1/EngageOne/tasks/workitem?';
        insert swivel;
        
        ACETOrgNameToSwivelEndpointMap__c swivel1 = new ACETOrgNameToSwivelEndpointMap__c();
        swivel1.Name = 'qa_EngageOne';
        swivel1.Swivel_Endpoint__c = 'http://apsed4198.ms.ds.uhc.com:9090/editor/v1/EngageOne/tasks/workitem?';
        insert swivel1;
        
        ACETOrgNameToSwivelEndpointMap__c swivel2 = new ACETOrgNameToSwivelEndpointMap__c();
        swivel2.Name = 'd1_EngageOne';
        swivel2.Swivel_Endpoint__c = 'http://apsed4198.ms.ds.uhc.com:9090/editor/v1/EngageOne/tasks/workitem?';
        insert swivel2;
        
        ACETOrgNameToSwivelEndpointMap__c swivel3 = new ACETOrgNameToSwivelEndpointMap__c();
        swivel3.Name = 'prd_EngageOne';
        swivel3.Swivel_Endpoint__c = 'http://apsed4198.ms.ds.uhc.com:9090/editor/v1/EngageOne/tasks/workitem?';
        insert swivel3;
        
        ACETWrapEncryptionKey__c devkey = new ACETWrapEncryptionKey__c();
        devkey.Name = 'dev_Engageonekey';
        devkey.Algorithm_Name__c = 'AES256';
        devkey.Key__c = 'JYbyFR9zdZFrGRzgaJtCTyLpFkIXFOs4';
        insert devkey;
        
        ACETWrapEncryptionKey__c qakey = new ACETWrapEncryptionKey__c();
        qakey.Name = 'qa_Engageonekey';
        qakey.Algorithm_Name__c = 'AES256';
        qakey.Key__c = 'JYbyFR9zdZFrGRzgaJtCTyLpFkIXFOs4';
        insert qakey;
        
        ACETWrapEncryptionKey__c dev1key = new ACETWrapEncryptionKey__c();
        dev1key.Name = 'd1_Engageonekey';
        dev1key.Algorithm_Name__c = 'AES256';
        dev1key.Key__c = 'JYbyFR9zdZFrGRzgaJtCTyLpFkIXFOs4';
        insert dev1key;
        
        ACETWrapEncryptionKey__c prdkey = new ACETWrapEncryptionKey__c();
        prdkey.Name = 'prd_Engageonekey';
        prdkey.Algorithm_Name__c = 'AES256';
        prdkey.Key__c = 'JYbyFR9zdZFrGRzgaJtCTyLpFkIXFOs4';
        insert prdkey;
        //**//
        PageReference pgRef=Page.ACETFulfillmentDetail;
        Test.setCurrentPage(pgRef);
        ApexPages.currentPage().getParameters().put('letterid',fulfillment.id);
        ACETFulfillmentDetailController CONT;
        ApexPages.StandardController sc=new ApexPages.StandardController(fulfillment);
        CONT=new ACETFulfillmentDetailController(sc);  
        try{
        CONT.newletter=null;
        CONT.SubmitLetter();
        }catch(Exception ex){}
     }
     
     

}