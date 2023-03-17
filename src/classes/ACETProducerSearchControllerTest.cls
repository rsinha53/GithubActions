@isTest
private class ACETProducerSearchControllerTest {
   
    private static testMethod void unitTestMethodForEBAgent(){
        MockHttpCalloutResponseGenerator.MockHttpResponse OILResponse =  new MockHttpCalloutResponseGenerator.MockHttpResponse(500, 'OK', ACETTestDataUtility.GetProducerSearchJSON());
        OILResponse.TokenExpired = false;        
        MockHttpCalloutResponseGenerator MockHttpRes = new MockHttpCalloutResponseGenerator(null, OILResponse);
        
        Test.setMock(HttpCalloutMock.class, MockHttpRes);  
        Test.startTest();
        
        ACETFindProducerWebservice findwebservice = new ACETFindProducerWebservice();
        findwebservice.GetRequestBody('', 'Test','Testlastname','Testfirstname','CA','Lastname');                                                 
        findwebservice.queryPaginatedData(2,3,1);
        findwebservice.FindProducers('333','3AcQ','167106', 'Test','1234567','Testlastname','Testfirstname','CA','Lastname','ASC','FirstName','0');
            ACETProducerSearchController acetSEG = new ACETProducerSearchController();
            ACETCallTopicsDataWrapper acetCallTopicDW = new ACETCallTopicsDataWrapper(); 
            acetSEG.getSourceOriginators();   
            acetSEG.firstNameParam = 'JIM';
            acetSEG.lastNameParam = 'KEITH';
            acetSEG.producerIdParam = 'PIN';   
            acetSEG.SortBy = 'LastName';
            acetSEG.LastSortBy = 'firstName'; 
            acetSEG.sortTable(); 
            acetSEG.clear();
            acetSEG.doinit();
            acetSEG.search();
          ACETProducerSearchController.crtInteraction('JIM','Keith','PIN','Phone');
            Test.stopTest();       
        }  
    private static testMethod void unitTestMethodForLegacyID(){
        MockHttpCalloutResponseGenerator.MockHttpResponse OILResponse =  new MockHttpCalloutResponseGenerator.MockHttpResponse(500, 'OK', ACETTestDataUtility.GetProducerSearchJSON());
        OILResponse.TokenExpired = false;        
        MockHttpCalloutResponseGenerator MockHttpRes = new MockHttpCalloutResponseGenerator(null, OILResponse);
        
        Test.setMock(HttpCalloutMock.class, MockHttpRes);  
        Test.startTest();
        
        ACETFindProducerWebservice findwebservice = new ACETFindProducerWebservice();
        findwebservice.init('333','3AcQ','BA7105', 'Test','','Testlastname','Testfirstname','CA','Lastname','ASC','FirstName');                                                 
        findwebservice.GetRequestBody('', 'Test','Testlastname','Testfirstname','CA','Lastname');
        findwebservice.queryPaginatedData(2,3,1);
        findwebservice.FindProducers('333','3AcQ','BA7106', 'Test','1234567','Testlastname','Testfirstname','CA','Lastname','ASC','FirstName','0');
            ACETProducerSearchController acetSEG = new ACETProducerSearchController();
            ACETCallTopicsDataWrapper acetCallTopicDW = new ACETCallTopicsDataWrapper(); 
            acetSEG.getSourceOriginators();   
            acetSEG.firstNameParam = 'JIM';
            acetSEG.lastNameParam = 'KEITH';
            acetSEG.producerIdParam = 'PIN';   
            acetSEG.SortBy = 'LastName';
            acetSEG.LastSortBy = 'firstName'; 
            acetSEG.sortTable(); 
            acetSEG.clear();
            acetSEG.doinit();
            acetSEG.search();
          ACETProducerSearchController.crtInteraction('JIM','Keith','PIN','Phone');
            Test.stopTest();       
        }  
   private static testMethod void unitTestMethodForLegacyIDNumeric(){
        MockHttpCalloutResponseGenerator.MockHttpResponse OILResponse =  new MockHttpCalloutResponseGenerator.MockHttpResponse(500, 'OK', ACETTestDataUtility.GetProducerSearchJSON());
        OILResponse.TokenExpired = false;        
        MockHttpCalloutResponseGenerator MockHttpRes = new MockHttpCalloutResponseGenerator(null, OILResponse);
        
        Test.setMock(HttpCalloutMock.class, MockHttpRes);  
        Test.startTest();
        
        ACETFindProducerWebservice findwebservice = new ACETFindProducerWebservice();
        findwebservice.init('333','3AcQ','547105', 'Test','','Testlastname','Testfirstname','CA','Lastname','ASC','FirstName');                                                 
        findwebservice.GetRequestBody('', 'Test','Testlastname','Testfirstname','CA','Lastname');
        findwebservice.queryPaginatedData(2,3,1);
        findwebservice.FindProducers('333','3AcQ','BA7106', 'Test','1234567','Testlastname','Testfirstname','CA','Lastname','ASC','FirstName','0');
            ACETProducerSearchController acetSEG = new ACETProducerSearchController();
            ACETCallTopicsDataWrapper acetCallTopicDW = new ACETCallTopicsDataWrapper(); 
            acetSEG.getSourceOriginators();   
            acetSEG.firstNameParam = 'JIM';
            acetSEG.lastNameParam = 'KEITH';
            acetSEG.producerIdParam = 'PIN';   
            acetSEG.SortBy = 'LastName';
            acetSEG.LastSortBy = 'firstName'; 
            acetSEG.sortTable(); 
            acetSEG.clear();
            acetSEG.doinit();
            acetSEG.search();
          ACETProducerSearchController.crtInteraction('JIM','Keith','PIN','Phone');
            Test.stopTest();       
        }
    private static testMethod void unitTestMethodForEBAgentProducerID(){
        MockHttpCalloutResponseGenerator.MockHttpResponse OILResponse =  new MockHttpCalloutResponseGenerator.MockHttpResponse(200, 'OK', ACETTestDataUtility.GetProducerSearchJSON());
        OILResponse.TokenExpired = false;        
        MockHttpCalloutResponseGenerator MockHttpRes = new MockHttpCalloutResponseGenerator(null, OILResponse);
        
        Test.setMock(HttpCalloutMock.class, MockHttpRes);  
        Test.startTest();
            ACETProducerSearchController acetSEG = new ACETProducerSearchController();
            ACETCallTopicsDataWrapper acetCallTopicDW = new ACETCallTopicsDataWrapper(); 
            acetSEG.getSourceOriginators();   
            acetSEG.firstNameParam = 'JIM';
            acetSEG.lastNameParam = 'KEITH';
            acetSEG.producerIdParam = 'PIN';   
            acetSEG.SortBy = 'LastName';     
            acetSEG.clear();
            acetSEG.doinit();
            acetSEG.sortTable();   
            acetSEG.search();
            Test.stopTest();       
        } 
        
    private static testMethod void unitTestMethodForEBAgentCompany(){
        MockHttpCalloutResponseGenerator.MockHttpResponse OILResponse =  new MockHttpCalloutResponseGenerator.MockHttpResponse(200, 'OK', ACETTestDataUtility.GetProducerSearchJSON());
        OILResponse.TokenExpired = false;        
        MockHttpCalloutResponseGenerator MockHttpRes = new MockHttpCalloutResponseGenerator(null, OILResponse);
        
        Test.setMock(HttpCalloutMock.class, MockHttpRes);  
        Test.startTest();
        ACETFindProducerWebservice findwebservice = new ACETFindProducerWebservice();
        findwebservice.GetRequestBody('167106', 'Test','Testlastname','Testfirstname','CA','Lastname');                                                 
        findwebservice.queryPaginatedData(2,3,1);
        findwebservice.FindProducers('333','3AcQ','167106', 'Test','1234567','Testlastname','Testfirstname','CA','Lastname','ASC','FirstName','2');
            ACETProducerSearchController acetSEG = new ACETProducerSearchController();
            ACETCallTopicsDataWrapper acetCallTopicDW = new ACETCallTopicsDataWrapper(); 
            acetSEG.getSourceOriginators();   
            acetSEG.Companyname = 'MasterVista';
            acetSEG.lastNameParam = 'KEITH';
            acetSEG.firstNameParam = 'JIM';
 
            acetSEG.SortBy = 'LastName';     
            acetSEG.clear();
            acetSEG.doinit();
            acetSEG.search();
            Test.stopTest();       
        }           
    private static testMethod void unitTestMethodForEBAgentExistingAccount(){
        MockHttpCalloutResponseGenerator.MockHttpResponse OILResponse =  new MockHttpCalloutResponseGenerator.MockHttpResponse(500, 'OK', ACETTestDataUtility.GetProducerSearchJSON());
        OILResponse.TokenExpired = false;        
        MockHttpCalloutResponseGenerator MockHttpRes = new MockHttpCalloutResponseGenerator(null, OILResponse);
        
        RecordType newRecord = [SELECT Id FROM RecordType WHERE Name = 'Person Account' and SObjectType = 'Account'];
        
        Account accountTest = new Account();
        accountTest.FirstName = 'JIM';
        accountTest.LastName = 'KEITH';
        accountTest.EID__c = 'PIN';
        accountTest.EID__pc = 'PIN';
        accountTest.RecordTypeId = newRecord.Id;
        insert accountTest;
        
        System.assertNotEquals(null,accountTest.id);
        
        Test.setMock(HttpCalloutMock.class, MockHttpRes);  
        Test.startTest();
        ACETFindProducerWebservice findwebservice = new ACETFindProducerWebservice();
        findwebservice.queryPaginatedData(2,3,1);
        findwebservice.getMaskedSSN('123Cs');
            ACETProducerSearchController acetSEG = new ACETProducerSearchController();
            ACETCallTopicsDataWrapper acetCallTopicDW = new ACETCallTopicsDataWrapper(); 
            acetSEG.getSourceOriginators();   
            acetSEG.firstNameParam = 'JIM';
            acetSEG.lastNameParam = 'KEITH';
            acetSEG.SortBy = 'LastName';
            acetSEG.LastSortBy = 'LastName';
            acetSEG.sortTable();   
            acetSEG.search();
            acetSEG.producerIdParam = accountTest.EID__c;
            ACETProducerSearchController.crtInteraction('JIM','Keith','PING','Phone');

            Test.stopTest();       
        }  
        
        private static testMethod void unitTesforjsontoApex(){
        MockHttpCalloutResponseGenerator.MockHttpResponse OILResponse =  new MockHttpCalloutResponseGenerator.MockHttpResponse(200, 'OK', ACETTestDataUtility.GetProducerSearchJSON());
        OILResponse.TokenExpired = false;        
        MockHttpCalloutResponseGenerator MockHttpRes = new MockHttpCalloutResponseGenerator(null, OILResponse);
        
        RecordType newRecord = [SELECT Id FROM RecordType WHERE Name = 'Person Account' and SObjectType = 'Account'];
        
        Account accountTest = new Account();
        accountTest.FirstName = 'JIM';
        accountTest.LastName = 'KEITH';
        accountTest.EID__c = 'PIN';
        accountTest.EID__pc = 'PIN';
        accountTest.RecordTypeId = newRecord.Id;
        insert accountTest;
        
        System.assertNotEquals(null,accountTest.id);
        
        Test.setMock(HttpCalloutMock.class, MockHttpRes);  
        Test.startTest();        
        ACETFindProducerWebservice findwebservice = new ACETFindProducerWebservice();
        findwebservice.GetRequestBody('167106', 'Test','Testlastname','Testfirstname','CA','Lastname');                                                 
        findwebservice.queryPaginatedData(2,3,1);
        findwebservice.FindProducers('333','3AcQ','167106', 'Test','1234567','Testlastname','Testfirstname','CA','Lastname','ASC','FirstName','1');
        ACETFindProducersAdaptJSON2Apex acetJson2apex = new ACETFindProducersAdaptJSON2Apex();
        
        ACETFindProducersAdaptJSON2Apex.MemberGroupDetails memberinfo = new ACETFindProducersAdaptJSON2Apex.MemberGroupDetails();
        memberinfo.groupNumber = '3797692017185927';
        memberinfo.groupName = 'Testing';
        
        ACETFindProducersAdaptJSON2Apex.ServiceAttributes serviceinfo = new ACETFindProducersAdaptJSON2Apex.ServiceAttributes();
        serviceinfo.applicationIdentifier = '123456';
        serviceinfo.requestIdentifier = '1111';
        serviceinfo.responseCode = '123';
        serviceinfo.responseDescription = 'status ok';
        
        ACETFindProducersAdaptJSON2Apex.FindProducerResponse responseinfo = new ACETFindProducersAdaptJSON2Apex.FindProducerResponse();
        responseinfo.producerGroupValidated = 'Y';
        responseinfo.producerStatus = 'Active';
        responseinfo.legacyBrokerCode = '34987';
        
        ACETProducerSearchController acetSEG = new ACETProducerSearchController();
        ACETCallTopicsDataWrapper acetCallTopicDW = new ACETCallTopicsDataWrapper(); 
        acetSEG.getSourceOriginators();   
        acetSEG.firstNameParam = 'JIM';
        acetSEG.lastNameParam = 'KEITH';
        acetSEG.SortBy = 'LastName';
        acetSEG.LastSortBy = 'LastName';
        acetSEG.sortTable();   
        acetSEG.search();       
        acetSEG.producerIdParam = accountTest.EID__c;
        ACETProducerSearchController.crtInteraction('JIM','Keith','PING','Phone');

        Test.stopTest();       
        }  

}