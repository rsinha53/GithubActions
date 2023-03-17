@isTest
private class ACETLaunchConsumerDashboardtest{
    
    static testMethod void  ACETLaunchConsumerDashboardtestmethod1() {

           Interaction__c inte = TestDataFactory.createInteraction();
           RecordType newRecord = [SELECT Id FROM RecordType WHERE Name = 'Person Account' and SObjectType = 'Account'];
        
          Account accountTest = new Account();
          accountTest.FirstName = 'Test';
          accountTest.LastName = 'Contact';
          accountTest.EID__c = 'PIN';
          accountTest.EID__pc = 'PIN';
          accountTest.RecordTypeId = newRecord.Id;
          insert accountTest;

      Account acc = [SELECT Id,personcontactid from Account where Id=:accountTest.Id];
          Contact contactObj = [SELECT Id,LastName,FirstName,EID__c,AccountId from Contact where Id=:acc.personcontactid];
            
            ACETOrgInstanceURLToOrgNameMap__c orgnamemap1 = new ACETOrgInstanceURLToOrgNameMap__c();
            orgnamemap1.Name = 'qaacet--acetqa.cs26';
            orgnamemap1.Org_Name__c = 'qa';
            insert orgnamemap1;
            
            ACETOrgInstanceURLToOrgNameMap__c orgnamemap = new ACETOrgInstanceURLToOrgNameMap__c();
            orgnamemap.Name = 'devacet--acetdev.cs26';
            orgnamemap.Org_Name__c = 'dev';
            insert orgnamemap;
            
            ACETOrgInstanceURLToOrgNameMap__c urlinstance3 = new ACETOrgInstanceURLToOrgNameMap__c();
        urlinstance3.Name = 'cs14';
        urlinstance3.Org_Name__c = 'd1';
        insert urlinstance3;
        
        ACETOrgInstanceURLToOrgNameMap__c urlinstance4 = new ACETOrgInstanceURLToOrgNameMap__c();
        urlinstance4.Name = 'cs17';
        urlinstance4.Org_Name__c = 'qa';
        insert urlinstance4;
        
        ACETOrgInstanceURLToOrgNameMap__c urlinstance5 = new ACETOrgInstanceURLToOrgNameMap__c();
        urlinstance5.Name = 'acet-uhg';
        urlinstance5.Org_Name__c = 'prd';
        insert urlinstance5;
            
            
            ACETOrgNameToSwivelEndpointMap__c SwivelEndpoint = new ACETOrgNameToSwivelEndpointMap__c();
            SwivelEndpoint.name ='dev_ICUECreateAuthorization';
            SwivelEndpoint.Swivel_Endpoint__c = 'test';
            insert SwivelEndpoint;
            
            ACETOrgNameToSwivelEndpointMap__c SwivelEndpoint1 = new ACETOrgNameToSwivelEndpointMap__c();
            SwivelEndpoint1.name ='qa_ICUEConsumerDashboard';
            SwivelEndpoint1.Swivel_Endpoint__c = 'test';
            insert SwivelEndpoint1;
            
            ACETOrgNameToSwivelEndpointMap__c SwivelEndpoint2 = new ACETOrgNameToSwivelEndpointMap__c();
            SwivelEndpoint2.name ='d1_ICUEConsumerDashboard';
            SwivelEndpoint2.Swivel_Endpoint__c = 'test';
            insert SwivelEndpoint2;
            
            ACETOrgNameToSwivelEndpointMap__c swivel3 = new ACETOrgNameToSwivelEndpointMap__c();
            swivel3.Name = 'prd_ICUEConsumerDashboard';
            swivel3.Swivel_Endpoint__c = 'ICUECreateAuthorization';
            insert swivel3;
            
            
            ACETWrapEncryptionKey__c encryptKey = new ACETWrapEncryptionKey__c();
            encryptKey.name ='dev_ICUEEncryptionKey';
            encryptKey.Algorithm_Name__c = 'AES256';
            encryptKey.Key__c= 'tbC2KA36qE1psxs9mozyfOmy7GdrI3I9';
            insert encryptKey ;
            
            
            ACETWrapEncryptionKey__c encryptKey1 = new ACETWrapEncryptionKey__c();
            encryptKey1.name ='qa_ICUEEncryptionKey';
            encryptKey1.Algorithm_Name__c = 'AES256';
            encryptKey1.Key__c= 'tbC2KA36qE1psxs9mozyfOmy7GdrI3I9';
            insert encryptKey1;
            
            ACETWrapEncryptionKey__c dev1key = new ACETWrapEncryptionKey__c();
            dev1key.Name = 'd1_ICUEEncryptionKey';
            dev1key.Algorithm_Name__c = 'AES256';
            dev1key.Key__c = 'tbC2KA36qE1psxs9mozyfOmy7GdrI3I9';
            insert dev1key;
            
            ACETWrapEncryptionKey__c prdkey = new ACETWrapEncryptionKey__c();
            prdkey.Name = 'prd_ICUEEncryptionKey';
            prdkey.Algorithm_Name__c = 'AES256';
            prdkey.Key__c = 'tbC2KA36qE1psxs9mozyfOmy7GdrI3I9';
            insert prdkey;
            
            Map<String, String> mapTestCaseDetails = new Map<String, String>();
            //mapTestCaseDetails.put('AccountId', accountObj.Id);
            mapTestCaseDetails.put('ContactId', inte.Originator__c);
            mapTestCaseDetails.put('Interaction__c', inte.Id);
            mapTestCaseDetails.put('Status', 'Canceled');
            mapTestCaseDetails.put('Origin', 'Phone');
            mapTestCaseDetails.put('Topic__c', 'View Consumer Dashboard');
            Case TestCase = ACETTestDataUtility.CreateTestCase(mapTestCaseDetails); 
            
            Test.startTest();
            
            insert TestCase;
            string additional = '{"OriginatorRelationship":"Test","Relationship":"Test","SitusState":"Test","DOB":"10/05/1991","EndDate":"Test","EffectiveDate":"Test","PolicyNumber":"Test","GroupName":"Test","GroupN":"test1-test2","Product":"Test","ProductType":"Test","Network":"Test","ConsumerAccountIndicator":"Test"}';

            Pagereference vfpage = page.ACETLaunchConsumerDashboard;
            //test.setcurrentpagereference(vfpage);           
            vfpage.getparameters().put('additionalInfo',additional);
            vfpage.getparameters().put('contactId',contactObj.id);
            vfpage.getparameters().put('SRK','testkey');
            Test.setCurrentPage(vfpage);
            ACETLaunchConsumerDashboardController ACETLCDashboard = new ACETLaunchConsumerDashboardController();
            ACETLCDashboard.baseURL = 'https://devacet101--acetdev101.cs26.my.salesforce.com';
            ACETLCDashboard.isCancelCaseCreation = true;
            ACETLCDashboard.routeCase();
            ACETLCDashboard.Topic  = 'View Consumer Dashboard';
            ACETLCDashboard.getTopics();
            ACETLCDashboard.getdateError();
            ACETLCDashboard.checkValidations();
            ACETLCDashboard.clear();
            
            //String additionalInfoStr = apexpages.currentpage().getparameters().get('additionalInfo');
            //system.debug('additionalInfoStr is '+additionalInfoStr);
            ACETLCDashboard.updateWrapper();
            Test.stopTest();
        
    }
    
    static testMethod void  ACETLaunchConsumerDashboardtestmethod2() {

           Interaction__c inte = TestDataFactory.createInteraction();
           RecordType newRecord = [SELECT Id FROM RecordType WHERE Name = 'Person Account' and SObjectType = 'Account'];
        
          Account accountTest = new Account();
          accountTest.FirstName = 'Test';
          accountTest.LastName = 'Contact';
          accountTest.EID__c = 'PIN';
          accountTest.EID__pc = 'PIN';
          accountTest.RecordTypeId = newRecord.Id;
          insert accountTest;

      Account acc = [SELECT Id,personcontactid from Account where Id=:accountTest.Id];
          Contact contactObj = [SELECT Id,LastName,FirstName,EID__c,AccountId from Contact where Id=:acc.personcontactid]; 
            
            ACETOrgInstanceURLToOrgNameMap__c orgnamemap1 = new ACETOrgInstanceURLToOrgNameMap__c();
            orgnamemap1.Name = 'qaacet--acetqa.cs26';
            orgnamemap1.Org_Name__c = 'qa';
            insert orgnamemap1;
            
            ACETOrgInstanceURLToOrgNameMap__c orgnamemap = new ACETOrgInstanceURLToOrgNameMap__c();
            orgnamemap.Name = 'devacet--acetdev.cs26';
            orgnamemap.Org_Name__c = 'dev';
            insert orgnamemap;
            
            ACETOrgInstanceURLToOrgNameMap__c urlinstance3 = new ACETOrgInstanceURLToOrgNameMap__c();
        urlinstance3.Name = 'cs14';
        urlinstance3.Org_Name__c = 'd1';
        insert urlinstance3;
        
        ACETOrgInstanceURLToOrgNameMap__c urlinstance4 = new ACETOrgInstanceURLToOrgNameMap__c();
        urlinstance4.Name = 'cs17';
        urlinstance4.Org_Name__c = 'qa';
        insert urlinstance4;
        
        ACETOrgInstanceURLToOrgNameMap__c urlinstance5 = new ACETOrgInstanceURLToOrgNameMap__c();
        urlinstance5.Name = 'acet-uhg';
        urlinstance5.Org_Name__c = 'prd';
        insert urlinstance5;
            
            
            ACETOrgNameToSwivelEndpointMap__c SwivelEndpoint = new ACETOrgNameToSwivelEndpointMap__c();
            SwivelEndpoint.name ='dev_ICUECreateAuthorization';
            SwivelEndpoint.Swivel_Endpoint__c = 'test';
            insert SwivelEndpoint;
            
            ACETOrgNameToSwivelEndpointMap__c SwivelEndpoint1 = new ACETOrgNameToSwivelEndpointMap__c();
            SwivelEndpoint1.name ='qa_ICUEConsumerDashboard';
            SwivelEndpoint1.Swivel_Endpoint__c = 'test';
            insert SwivelEndpoint1;
            
            ACETOrgNameToSwivelEndpointMap__c SwivelEndpoint2 = new ACETOrgNameToSwivelEndpointMap__c();
            SwivelEndpoint2.name ='d1_ICUEConsumerDashboard';
            SwivelEndpoint2.Swivel_Endpoint__c = 'test';
            insert SwivelEndpoint2;
            
            ACETOrgNameToSwivelEndpointMap__c swivel3 = new ACETOrgNameToSwivelEndpointMap__c();
            swivel3.Name = 'prd_ICUEConsumerDashboard';
            swivel3.Swivel_Endpoint__c = 'ICUECreateAuthorization';
            insert swivel3;
            
            
            ACETWrapEncryptionKey__c encryptKey = new ACETWrapEncryptionKey__c();
            encryptKey.name ='dev_ICUEEncryptionKey';
            encryptKey.Algorithm_Name__c = 'AES256';
            encryptKey.Key__c= 'tbC2KA36qE1psxs9mozyfOmy7GdrI3I9';
            insert encryptKey ;
            
            
            ACETWrapEncryptionKey__c encryptKey1 = new ACETWrapEncryptionKey__c();
            encryptKey1.name ='qa_ICUEEncryptionKey';
            encryptKey1.Algorithm_Name__c = 'AES256';
            encryptKey1.Key__c= 'tbC2KA36qE1psxs9mozyfOmy7GdrI3I9';
            insert encryptKey1;
            
            ACETWrapEncryptionKey__c dev1key = new ACETWrapEncryptionKey__c();
            dev1key.Name = 'd1_ICUEEncryptionKey';
            dev1key.Algorithm_Name__c = 'AES256';
            dev1key.Key__c = 'tbC2KA36qE1psxs9mozyfOmy7GdrI3I9';
            insert dev1key;
            
            ACETWrapEncryptionKey__c prdkey = new ACETWrapEncryptionKey__c();
            prdkey.Name = 'prd_ICUEEncryptionKey';
            prdkey.Algorithm_Name__c = 'AES256';
            prdkey.Key__c = 'tbC2KA36qE1psxs9mozyfOmy7GdrI3I9';
            insert prdkey;
            
            Map<String, String> mapTestCaseDetails = new Map<String, String>();
            //mapTestCaseDetails.put('AccountId', accountObj.Id);
            mapTestCaseDetails.put('ContactId', inte.Originator__c);
            mapTestCaseDetails.put('Interaction__c', inte.Id);
            mapTestCaseDetails.put('Status', 'Canceled');
            mapTestCaseDetails.put('Origin', 'Phone');
            mapTestCaseDetails.put('Topic__c', 'View Consumer Dashboard');
            Case TestCase = ACETTestDataUtility.CreateTestCase(mapTestCaseDetails); 
            
            Test.startTest();
            
            insert TestCase;
            string additional = '{"OriginatorRelationship":"Test","Relationship":"Test","SitusState":"Test","DOB":"Test","EndDate":"Test","EffectiveDate":"Test","PolicyNumber":"Test","GroupName":"Test","GroupN":"test1-test2",Product":"Test","ProductType":"Test","Network":"Test","ConsumerAccountIndicator":"Test"}';

            Pagereference vfpage = page.ACETLaunchConsumerDashboard;
            //test.setcurrentpagereference(vfpage);           
            vfpage.getparameters().put('additionalInfo',additional);
            vfpage.getparameters().put('contactId',contactObj.id);
            //vfpage.getparameters().put('SRK','testkey');
            //vfpage.getparameters().put('SRK','testkey');
            Test.setCurrentPage(vfpage);
            ACETLaunchConsumerDashboardController ACETLCDashboard = new ACETLaunchConsumerDashboardController();
            ACETLCDashboard.baseURL = 'https://devacet101--acetdev101.cs26.my.salesforce.com';
            ACETLCDashboard.isCancelCaseCreation = true;
            ACETLCDashboard.timeOfAppointment = 'test';
            //ACETLCDashboard.routeCase();
            ACETLCDashboard.Topic  = 'View Consumer Dashboard';
            ACETLCDashboard.getTopics();
            ACETLCDashboard.getdateError();
            ACETLCDashboard.checkValidations();
            ACETLCDashboard.clear();
            
            //String additionalInfoStr = apexpages.currentpage().getparameters().get('additionalInfo');
            //system.debug('additionalInfoStr is '+additionalInfoStr);
            //ACETLCDashboard.updateWrapper();
            //String value = ACETURLEncryptionUtility.getICUEURL('dev_ICUEConsumerDashboard');
            //String newvalue = ACETURLEncryptionUtility.GetEncryptedValue('380db410e8b11fa9', 'AES256', value);
            Test.stopTest();
        
    }
    
}