@istest
global class ACETClaimSearchControllerTest {
    static testMethod void testACETClaimSearchController(){         
        List<string> str = new List<String>();
        ACETClaimSearchUtility.getClaims('strTaxId', 'strNetworkStatus', 'strCoverageType', 'strStartDate', 'strEndDate', 'strDeductibleOnly', 'strClaimId', 'strAuthorizationNumber', 'strReferrelNumber', 'filterBy', 'SortBy', 'SortOrder', str);
        ACETClaimSearchUtility.getCheckStatus('strcheckNumber', 'strSeriesDesignator');
        
           /* Contact cont = new Contact();
            cont.FirstName='Test';
            cont.LastName='Test';
            cont.Tax_ID__c = '123456789';
            insert cont;*/
            
                    RecordType newRecord = [SELECT Id FROM RecordType WHERE Name = 'Person Account' and SObjectType = 'Account'];
        
        Account accountTest = new Account();
        accountTest.FirstName = 'TestFirst';
        accountTest.LastName = 'TestLast';
        accountTest.EID__c = '12345';
        accountTest.EID__pc = '12345';
        accountTest.RecordTypeId = newRecord.Id;
        insert accountTest;
        
        Account acc = [SELECT Id,personcontactid from Account where Id=:accountTest.Id];
        Contact cont = [SELECT Id,LastName,FirstName,EID__c,AccountId from Contact where Id=:acc.personcontactid];
            
            
            Interaction__c interaction = new Interaction__c();
            interaction.Originator__c = cont.Id; 
            interaction.Interaction_Type__c = 'Phone Call';
            interaction.Originator_Type__c = 'Provider';        
            insert interaction;
        
        
            PageReference pageRef = Page.ACETClaimSearch;
            Test.setCurrentPage(pageRef);
            
            System.currentPageReference().getParameters().put('SRK', 'SRK_Key');
            System.currentPageReference().getParameters().put('contactId', cont.Id);
            System.currentPageReference().getParameters().put('id', cont.Id);
            System.currentPageReference().getParameters().put('interactionId', interaction.Id);
            System.currentPageReference().getParameters().put('additionalInfo', '{"SitusState":"IA","Relationship":"Subscriber/Recipient","ProductType":"HMO","Product":"HMO","PolicyNumber":"0909003","OriginatorRelationship":"Subscriber/Recipient","Network":"788909","GroupName":null,"EndDate":"1/1/8888","EffectiveDate":"8/8/2012","DOB":"2/1/1963","ConsumerAccountIndicator":null}');
            System.currentPageReference().getParameters().put('claimId', 'MS27810014');
            System.currentPageReference().getParameters().put('memberid', '12345678900');
                    
            ACETClaimSearchController Controller  = new ACETClaimSearchController();
            Controller.init();
            Controller.clear();
            Controller.SortBy = 'ClaimId';
            Controller.SortOrder = 'Asc';
            Controller.searchbyaction();
            Controller.dateServiceChange();
            
            Controller.searchBy = 'ClaimNumber';
            
            Controller.searchbyaction();
            Controller.dateOfService = 'Day';
            
            Controller.dateServiceChange();      
            
            Controller.searchBy = 'CaseNumber';
            
            Controller.searchbyaction();
            
            Controller.dateOfService = 'ThisYear';
            
            Controller.dateServiceChange();
            
            Controller.searchBy = 'AuthorizationNumber';
            
            Controller.searchbyaction();
            
            Controller.searchBy= 'referralnumber';
            Controller.searchbyaction();
            Controller.dateOfService = 'LastYear';
            
            Controller.dateServiceChange();
            
            //Rest Values
            Controller.casenumberhide = true;
            Controller.isClaim = true;
            Controller.isCancelCaseCreation = true;
            
            Controller.LastSortBy = 'Desc';
            Controller.strSelectedClaims = 'Test';
            Controller.ClaimsResultJson = 'Test';
            Controller.status = 'Test';
            Controller.renderCancelCaseSection();
             Controller.inNetwork='Combination';

            //Controller.SaveAndClose();  
                 
            ACETFindClaimWebservice ACETFindClaimWebservice = new ACETFindClaimWebservice();
            /*ACETFindClaimWebservice.getStatusCodeDesc('P');
            ACETFindClaimWebservice.getStatusCodeDesc('D');
            ACETFindClaimWebservice.getStatusCodeDesc('A');
            ACETFindClaimWebservice.getStatusCodeDesc('C');*/
        
        Test.startTest();
            Test.setMock(HttpCalloutMock.class, new MockHttpResponseGenerator());
            Controller.Search();
                        Controller.dateOfService = 'Day';

            //  Controller.sortTable();       
        Test.stopTest();
    }
    
     static testMethod void testACETClaimSearchControllerone(){         
        List<string> str = new List<String>();
        ACETClaimSearchUtility.getClaims('strTaxId', 'strNetworkStatus', 'strCoverageType', 'strStartDate', 'strEndDate', 'strDeductibleOnly', 'strClaimId', 'strAuthorizationNumber', 'strReferrelNumber', 'filterBy', 'SortBy', 'SortOrder', str);
        ACETClaimSearchUtility.getCheckStatus('strcheckNumber', 'strSeriesDesignator');
        
           /* Contact cont = new Contact();
            cont.FirstName='Test';
            cont.LastName='Test';
            cont.Tax_ID__c = '123456789';
            insert cont;*/
                    RecordType newRecord = [SELECT Id FROM RecordType WHERE Name = 'Person Account' and SObjectType = 'Account'];
        
        Account accountTest = new Account();
        accountTest.FirstName = 'TestFirst';
        accountTest.LastName = 'TestLast';
        accountTest.EID__c = '12345';
        accountTest.EID__pc = '12345';
        accountTest.RecordTypeId = newRecord.Id;
        insert accountTest;
        
        Account acc = [SELECT Id,personcontactid from Account where Id=:accountTest.Id];
        Contact cont = [SELECT Id,LastName,FirstName,EID__c,AccountId from Contact where Id=:acc.personcontactid];
            
            
            Interaction__c interaction = new Interaction__c();
            interaction.Originator__c = cont.Id; 
            interaction.Interaction_Type__c = 'Phone Call';
            interaction.Originator_Type__c = 'Provider';        
            insert interaction;
        
        
            PageReference pageRef = Page.ACETClaimSearch;
            Test.setCurrentPage(pageRef);
            
            System.currentPageReference().getParameters().put('SRK', 'SRK_Key');
            System.currentPageReference().getParameters().put('contactId', cont.Id);
            System.currentPageReference().getParameters().put('id', cont.Id);
            System.currentPageReference().getParameters().put('interactionId', interaction.Id);
            System.currentPageReference().getParameters().put('additionalInfo', '{"SitusState":"IA","Relationship":"Subscriber/Recipient","ProductType":"HMO","Product":"HMO","PolicyNumber":"0909003","OriginatorRelationship":"Subscriber/Recipient","Network":"788909","GroupName":null,"EndDate":"1/1/8888","EffectiveDate":"8/8/2012","DOB":"2/1/1963","ConsumerAccountIndicator":null,"isMember":false}');
            System.currentPageReference().getParameters().put('claimId', 'MS27810014');
            System.currentPageReference().getParameters().put('memberid', '12345678900');
                    
            ACETClaimSearchController Controller  = new ACETClaimSearchController();
            Controller.init();
            Controller.clear();
            Controller.SortBy = 'ClaimId';
            Controller.SortOrder = 'Asc';
            Controller.searchbyaction();
            Controller.dateServiceChange();
            
            Controller.searchBy = 'ClaimNumber';
            
            Controller.searchbyaction();
           // Controller.dateOfService = 'Day';
            
            Controller.dateServiceChange();      
            
            Controller.searchBy = 'CaseNumber';
            
            Controller.searchbyaction();
            
          //  Controller.dateOfService = 'ThisYear';
            
            Controller.dateServiceChange();
            
            Controller.searchBy = 'AuthorizationNumber';
            
            Controller.searchbyaction();
            
            Controller.searchBy= 'referralnumber';
            Controller.searchbyaction();
            Controller.dateOfService = 'All';
            
            Controller.dateServiceChange();
            
            //Rest Values
            Controller.casenumberhide = true;
            Controller.isClaim = true;
            Controller.isCancelCaseCreation = true;
            
            Controller.LastSortBy = 'Desc';
            Controller.strSelectedClaims = 'Test';
            Controller.ClaimsResultJson = 'Test';
            Controller.status = 'Test';
            Controller.renderCancelCaseSection();
            //Controller.SaveAndClose();  
                        Controller.providers='Physician';
              Controller.inNetwork='In Network';
                 
            ACETFindClaimWebservice ACETFindClaimWebservice = new ACETFindClaimWebservice();
            /*ACETFindClaimWebservice.getStatusCodeDesc('P');
            ACETFindClaimWebservice.getStatusCodeDesc('D');
            ACETFindClaimWebservice.getStatusCodeDesc('A');
            ACETFindClaimWebservice.getStatusCodeDesc('C');*/
        
        Test.startTest();
            Test.setMock(HttpCalloutMock.class, new MockHttpResponseGenerator());
            Controller.Search();
            
             Controller.onClickDetail(); 
             Controller.clearResults();      
        Test.stopTest();
    }
    
    
     static testMethod void testACETClaimSearchControllertwo(){         
        List<string> str = new List<String>();
        ACETClaimSearchUtility.getClaims('strTaxId', 'strNetworkStatus', 'strCoverageType', 'strStartDate', 'strEndDate', 'strDeductibleOnly', 'strClaimId', 'strAuthorizationNumber', 'strReferrelNumber', 'filterBy', 'SortBy', 'SortOrder', str);
        ACETClaimSearchUtility.getCheckStatus('strcheckNumber', 'strSeriesDesignator');
        
            Contact cont = new Contact();
            cont.FirstName='Test';
            cont.LastName='Test';
            cont.Tax_ID__c = '123456789';
            insert cont;
            
            Interaction__c interaction = new Interaction__c();
            interaction.Originator__c = cont.Id; 
            interaction.Interaction_Type__c = 'Phone Call';
            interaction.Originator_Type__c = 'Provider';        
            insert interaction;
        
        
            PageReference pageRef = Page.ACETClaimSearch;
            Test.setCurrentPage(pageRef);
            
            System.currentPageReference().getParameters().put('SRK', 'SRK_Key');
            System.currentPageReference().getParameters().put('contactId', cont.Id);
            System.currentPageReference().getParameters().put('id', cont.Id);
            System.currentPageReference().getParameters().put('interactionId', interaction.Id);
            System.currentPageReference().getParameters().put('additionalInfo', '{"SitusState":"IA","Relationship":"Subscriber/Recipient","ProductType":"HMO","Product":"HMO","PolicyNumber":"0909003","OriginatorRelationship":"Subscriber&Recipient","Network":"788909","GroupName":null,"EndDate":"1/1/8888","EffectiveDate":"8/8/2012","DOB":null,"ConsumerAccountIndicator":null,"isMember":false}');
            //System.currentPageReference().getParameters().put('claimId', 'MS27810014');
            System.currentPageReference().getParameters().put('memberid', '12345678900');
                        System.currentPageReference().getParameters().put('surrogateKey', '12345678900');
        
            ACETClaimSearchController Controller  = new ACETClaimSearchController();
            Controller.init();
            Controller.clear();
            Controller.SortBy = 'ClaimId';
            Controller.SortOrder = 'Asc';
            Controller.searchbyaction();
            Controller.dateServiceChange();
            Controller.providers='Facility';
                          Controller.inNetwork='Out of Network';

            Controller.searchBy = 'ClaimNumber';
            
            Controller.searchbyaction();
            Controller.dateOfService = 'Day';
            
            Controller.dateServiceChange();      
            
            Controller.searchBy = 'CaseNumber';
            
            Controller.searchbyaction();
            
           // Controller.dateOfService = 'ThisYear';
            
            Controller.dateServiceChange();
            
            Controller.searchBy = 'AuthorizationNumber';
            
            Controller.searchbyaction();
            
            Controller.searchBy= 'referralnumber';
            Controller.searchbyaction();
            //Controller.dateOfService = 'Day';
            
            Controller.dateServiceChange();
            
            //Rest Values
            Controller.casenumberhide = true;
            Controller.isClaim = true;
            Controller.isCancelCaseCreation = true;
            
            Controller.LastSortBy = 'Desc';
            Controller.strSelectedClaims = 'Test';
            Controller.ClaimsResultJson = 'Test';
            Controller.status = 'Test';
            Controller.renderCancelCaseSection();
            //Controller.SaveAndClose();  
                 
            ACETFindClaimWebservice ACETFindClaimWebservice = new ACETFindClaimWebservice();
            /*ACETFindClaimWebservice.getStatusCodeDesc('P');
            ACETFindClaimWebservice.getStatusCodeDesc('D');
            ACETFindClaimWebservice.getStatusCodeDesc('A');
            ACETFindClaimWebservice.getStatusCodeDesc('C');*/
        
        Test.startTest();
            Test.setMock(HttpCalloutMock.class, new MockHttpResponseGenerator());
                        Controller.dateOfService = 'ThisYear';

            Controller.Search();
            
            //  Controller.sortTable();       
        Test.stopTest();
    }
    
    static testMethod void testClaimSearcWebservice(){
        
        
        
        ACETFindClaimJSON2Apex.Pagination js2apexpage = new ACETFindClaimJSON2Apex.Pagination();
        js2apexpage.pageNumber = '1';
        js2apexpage.pageSize = '50';
        js2apexpage.recordCount = '200';
        js2apexpage.totalCount = '400';
        ACETFindClaimJSON2Apex.Name name = new ACETFindClaimJSON2Apex.Name();
        name.firstName = 'test';
        name.lastName = 'test';
        name.middleName = 'test';
        ACETFindClaimJSON2Apex.Identifiers iden = new ACETFindClaimJSON2Apex.Identifiers();
        iden.id = 'test';
        iden.type_Z = 'test';
        List<ACETFindClaimJSON2Apex.Identifiers> listiden = new List<ACETFindClaimJSON2Apex.Identifiers>();
        listiden.add(iden);
        ACETFindClaimJSON2Apex.Provider prov = new ACETFindClaimJSON2Apex.Provider();
        prov.providerID = 'test';
        prov.providerNPI = 'test';
        ACETFindClaimJSON2Apex.Patient pat = new ACETFindClaimJSON2Apex.Patient();
        pat.birthDate = 'test';
        pat.identifiers = listiden;
        pat.name = name;
        ACETFindClaimJSON2Apex.DiagnosisCode code = new ACETFindClaimJSON2Apex.DiagnosisCode();
        code.levelType = 'test';
        ACETFindClaimJSON2Apex.Subscriber sub = new ACETFindClaimJSON2Apex.Subscriber();
        sub.identifiers = listiden;
        sub.name = name;
        ACETFindClaimJSON2Apex.Claims clms = new ACETFindClaimJSON2Apex.Claims();
        clms.claimSourceSystemCode = 'test';
        clms.claimReceivedDate = 'test';
        clms.totalCopayAmount = 'test';
        clms.totalNotCoveredAmount = 'test';
        clms.claimTotalAllowedAmount = 'test';
        clms.patientAccountNumber = 'test';
        clms.patient = pat;
        clms.subscriber = sub;
        Object obj;
        
        ACETClaimSearchResult res = new ACETClaimSearchResult();
        res.BenefitLevel = 'test';
        res.PHIRestriction = 'test';
        res.claimEvtType = 'test';
        res.ClaimID = '12345';
        res.claimType = 'test';
        res.Deductible = 'true';
        res.levelTypeCode = 'test';
        res.Network = 'test';
        res.patientResponsibility = 'test';
        res.PrimaryDiagnosisCode = 'test';
        res.Processed = 'test';
        res.Provider = 'test';
        res.selected  = true;
        res.ServiceEnd = 'test';
        res.ServiceStart = 'test';
        res.Status = 'test';
        res.TaxID = '12345';
        res.TotalCharged = '12345';
        res.TotalPaid = '12345';
        ACETClaimSearchResult.SortBy = 'PHIRestriction';
        ACETClaimSearchResult.SortOrder = 'Asc';
        obj = (Object)res;
        Integer i = res.compareTo(obj);
        
        
         ACETFindClaimWebservice service = new ACETFindClaimWebservice();         
         service.init('a','a','a','a','a','a12345','a','a','a','a','a','a');
         service.formattedDate('09/04/2018');
          
         MockHttpCalloutResponseGenerator.MockHttpResponse OILResponse1 = new MockHttpCalloutResponseGenerator.MockHttpResponse(200, 'OK', ACETTestDataUtility.getFindClaimWebserviceResponse());
         OILResponse1.TokenExpired = false;        
         MockHttpCalloutResponseGenerator MockHttpRes1 = new MockHttpCalloutResponseGenerator(null, OILResponse1);
         Test.setMock(HttpCalloutMock.class, MockHttpRes1);           
         service.queryPaginatedData(1,1,1);
         
         MockHttpCalloutResponseGenerator.MockHttpResponse OILResponse2 = new MockHttpCalloutResponseGenerator.MockHttpResponse(404, 'Resource Not Found', '');
         OILResponse2.TokenExpired = false;        
         MockHttpCalloutResponseGenerator MockHttpRes2 = new MockHttpCalloutResponseGenerator(null, OILResponse2);
         Test.setMock(HttpCalloutMock.class, MockHttpRes2); 
         service.queryPaginatedData(1,1,1);
         
         MockHttpCalloutResponseGenerator.MockHttpResponse OILResponse3 = new MockHttpCalloutResponseGenerator.MockHttpResponse(500, 'Server Error', '');
         OILResponse3.TokenExpired = false;        
         MockHttpCalloutResponseGenerator MockHttpRes3 = new MockHttpCalloutResponseGenerator(null, OILResponse3);
         Test.setMock(HttpCalloutMock.class, MockHttpRes3); 
         service.queryPaginatedData(1,1,1); 
    } 
    
    static testMethod void testClaimSearcWebservice_2(){
        
        ACETFindClaimJSON2Apex.Pagination js2apexpage = new ACETFindClaimJSON2Apex.Pagination();
        js2apexpage.pageNumber = '1';
        js2apexpage.pageSize = '50';
        js2apexpage.recordCount = '200';
        js2apexpage.totalCount = '400';
       /*ACETFindClaimJSON2Apex.provider provider = new ACETFindClaimJSON2Apex.provider();
        provider.name = name;*/
        ACETFindClaimJSON2Apex.Name name = new ACETFindClaimJSON2Apex.Name();
        name.firstName = 'test';
        name.lastName = 'test';
        name.middleName = 'test';
        //ACETFindClaimJSON2Apex.provider provider = new ACETFindClaimJSON2Apex.provider();
        //provider.name = name;
       
        ACETFindClaimJSON2Apex.Identifiers iden = new ACETFindClaimJSON2Apex.Identifiers();
        iden.id = 'test';
        iden.type_Z = 'test';
        List<ACETFindClaimJSON2Apex.Identifiers> listiden = new List<ACETFindClaimJSON2Apex.Identifiers>();
        listiden.add(iden);
        ACETFindClaimJSON2Apex.Provider prov = new ACETFindClaimJSON2Apex.Provider();
                prov.name = name;

        prov.providerID = 'test';
        prov.providerNPI = 'test';
        ACETFindClaimJSON2Apex.Patient pat = new ACETFindClaimJSON2Apex.Patient();
        pat.birthDate = 'test';
        pat.identifiers = listiden;
        pat.name = name;
        ACETFindClaimJSON2Apex.DiagnosisCode code = new ACETFindClaimJSON2Apex.DiagnosisCode();
        code.levelType = 'test';
        ACETFindClaimJSON2Apex.Subscriber sub = new ACETFindClaimJSON2Apex.Subscriber();
        sub.identifiers = listiden;
        sub.name = name;
        ACETFindClaimJSON2Apex.Claims clms = new ACETFindClaimJSON2Apex.Claims();
        clms.claimSourceSystemCode = 'test';
        clms.claimReceivedDate = 'test';
        clms.totalCopayAmount = 'test';
        clms.totalNotCoveredAmount = 'test';
        clms.claimTotalAllowedAmount = 'test';
        clms.patientAccountNumber = 'test';
        clms.patient = pat;
        clms.subscriber = sub;
        Object obj;
        
        ACETClaimSearchResult res = new ACETClaimSearchResult();
        res.BenefitLevel = 'test';
        res.PHIRestriction = 'test';
        res.claimEvtType = 'test';
        res.ClaimID = '12345';
        res.claimType = 'test';
        res.Deductible = 'true';
        res.levelTypeCode = 'test';
        res.Network = 'test';
        res.patientResponsibility = 'test';
        res.PrimaryDiagnosisCode = 'test';
        res.Processed = 'test';
        res.Provider = 'test';
        res.selected  = true;
            res.ServiceEnd = 'test';
                res.ServiceStart = 'test';
        res.Status = 'test';
        res.TaxID = '12345';
        res.TotalCharged = '12345';
        res.TotalPaid = '12345';
        ACETClaimSearchResult.SortBy = 'PHIRestriction';
        ACETClaimSearchResult.SortOrder = 'Asc';
        obj = (Object)res;
        Integer i = res.compareTo(obj);
        
        
         ACETFindClaimWebservice service = new ACETFindClaimWebservice();         
         service.init(null,'a',null,null,null,null,null,null,null,null,null,null);
         
         MockHttpCalloutResponseGenerator.MockHttpResponse OILResponse1 = new MockHttpCalloutResponseGenerator.MockHttpResponse(200, 'OK', ACETTestDataUtility.getFindClaimWebserviceResponse());
         OILResponse1.TokenExpired = false;        
         MockHttpCalloutResponseGenerator MockHttpRes1 = new MockHttpCalloutResponseGenerator(null, OILResponse1);
         Test.setMock(HttpCalloutMock.class, MockHttpRes1);           
         service.queryPaginatedData(1,1,1);
         
         service.init(null,null,null,null,null,null,'a','a',null,'false',null,null);
         
         MockHttpCalloutResponseGenerator.MockHttpResponse OILResponse4 = new MockHttpCalloutResponseGenerator.MockHttpResponse(200, 'OK', ACETTestDataUtility.getFindClaimWebserviceResponse());
         OILResponse1.TokenExpired = false;        
         MockHttpCalloutResponseGenerator MockHttpRes4 = new MockHttpCalloutResponseGenerator(null, OILResponse4);
         Test.setMock(HttpCalloutMock.class, MockHttpRes4);           
         service.queryPaginatedData(1,1,1);
         
         MockHttpCalloutResponseGenerator.MockHttpResponse OILResponse2 = new MockHttpCalloutResponseGenerator.MockHttpResponse(404, 'Resource Not Found', '');
         OILResponse2.TokenExpired = false;        
         MockHttpCalloutResponseGenerator MockHttpRes2 = new MockHttpCalloutResponseGenerator(null, OILResponse2);
         Test.setMock(HttpCalloutMock.class, MockHttpRes2); 
         service.queryPaginatedData(1,1,1);
         
         MockHttpCalloutResponseGenerator.MockHttpResponse OILResponse3 = new MockHttpCalloutResponseGenerator.MockHttpResponse(500, 'Server Error', '');
         OILResponse3.TokenExpired = false;        
         MockHttpCalloutResponseGenerator MockHttpRes3 = new MockHttpCalloutResponseGenerator(null, OILResponse3);
         Test.setMock(HttpCalloutMock.class, MockHttpRes3); 
         service.queryPaginatedData(1,1,1); 
    }
        
    global class MockHttpResponseGenerator implements HttpCalloutMock {
        // Implement this interface method
        global HTTPResponse respond(HTTPRequest req) {
            
            // Create a fake response
            HttpResponse res = new HttpResponse();
            res.setHeader('Content-Type', 'application/json');
            res.setBody(ACETTestDataUtility.FindClaimsJSON());
            res.setStatusCode(200);
            return res;
        }
    }
    
    static testmethod void getcompareresult()
    {
        Object obj;
        
        ACETClaimSearchResult res = new ACETClaimSearchResult();
        res.BenefitLevel = 'test';
        res.PHIRestriction = 'test';
        res.claimEvtType = 'test';
        res.ClaimID = '12345';
        res.claimType = 'test';
        res.Deductible = 'true';
        res.levelTypeCode = 'test';
        res.Network = 'test';
        res.patientResponsibility = 'test';
        res.PrimaryDiagnosisCode = 'test';
        res.Processed = 'test';
        res.Provider = 'test';
        res.selected  = true;
            res.ServiceEnd = 'test';
                res.ServiceStart = 'test';
        res.Status = 'test';
        res.TaxID = '12345';
        res.TotalCharged = '12345';
        res.TotalPaid = '12345';
        ACETClaimSearchResult.SortBy = 'ClaimID';
        ACETClaimSearchResult.SortOrder = 'Asc';
        obj = (Object)res;
        Integer i = res.compareTo(obj);
    }
    
    static testmethod void getcompareresult1()
    {
        Object obj;
        
        ACETClaimSearchResult res = new ACETClaimSearchResult();
        res.BenefitLevel = 'test';
        res.PHIRestriction = 'test';
        res.claimEvtType = 'test';
        res.ClaimID = '12345';
        res.claimType = 'test';
        res.Deductible = 'true';
        res.levelTypeCode = 'test';
        res.Network = 'test';
        res.patientResponsibility = 'test';
        res.PrimaryDiagnosisCode = 'test';
        res.Processed = 'test';
        res.Provider = 'test';
        res.selected  = true;
            res.ServiceEnd = 'test';
                res.ServiceStart = 'test';
        res.Status = 'test';
        res.TaxID = '12345';
        res.TotalCharged = '12345';
        res.TotalPaid = '12345';
        ACETClaimSearchResult.SortBy = 'Provider';
        ACETClaimSearchResult.SortOrder = 'Asc';
        obj = (Object)res;
        Integer i = res.compareTo(obj);
    }
    
    static testmethod void getcompareresult2()
    {
        Object obj;
        
        ACETClaimSearchResult res = new ACETClaimSearchResult();
        res.BenefitLevel = 'test';
        res.PHIRestriction = 'test';
        res.claimEvtType = 'test';
        res.ClaimID = '12345';
        res.claimType = 'test';
        res.Deductible = 'true';
        res.levelTypeCode = 'test';
        res.Network = 'test';
        res.patientResponsibility = 'test';
        res.PrimaryDiagnosisCode = 'test';
        res.Processed = 'test';
        res.Provider = 'test';
        res.selected  = true;
            res.ServiceEnd = 'test';
                res.ServiceStart = 'test';
        res.Status = 'test';
        res.TaxID = '12345';
        res.TotalCharged = '12345';
        res.TotalPaid = '12345';
        ACETClaimSearchResult.SortBy = 'TaxID';
        ACETClaimSearchResult.SortOrder = 'Asc';
        obj = (Object)res;
        Integer i = res.compareTo(obj);
    }
    
    static testmethod void getcompareresult3()
    {
        Object obj;
        
        ACETClaimSearchResult res = new ACETClaimSearchResult();
        res.BenefitLevel = 'test';
        res.PHIRestriction = 'test';
        res.claimEvtType = 'test';
        res.ClaimID = '12345';
        res.claimType = 'test';
        res.Deductible = 'true';
        res.levelTypeCode = 'test';
        res.Network = 'test';
        res.patientResponsibility = 'test';
        res.PrimaryDiagnosisCode = 'test';
        res.Processed = 'test';
        res.Provider = 'test';
        res.selected  = true;
            res.ServiceEnd = 'test';
                res.ServiceStart = 'test';
        res.Status = 'test';
        res.TaxID = '12345';
        res.TotalCharged = '12345';
        res.TotalPaid = '12345';
        ACETClaimSearchResult.SortBy = 'Network';
        ACETClaimSearchResult.SortOrder = 'Asc';
        obj = (Object)res;
        Integer i = res.compareTo(obj);
    }
    
    static testmethod void getcompareresult4()
    {
        Object obj;
        
        ACETClaimSearchResult res = new ACETClaimSearchResult();
        res.BenefitLevel = 'test';
        res.PHIRestriction = 'test';
        res.claimEvtType = 'test';
        res.ClaimID = '12345';
        res.claimType = 'test';
        res.Deductible = 'true';
        res.levelTypeCode = 'test';
        res.Network = 'test';
        res.patientResponsibility = 'test';
        res.PrimaryDiagnosisCode = 'test';
        res.Processed = 'test';
        res.Provider = 'test';
        res.selected  = true;
            res.ServiceEnd = 'test';
                res.ServiceStart = 'test';
        res.Status = 'test';
        res.TaxID = '12345';
        res.TotalCharged = '12345';
        res.TotalPaid = '12345';
        ACETClaimSearchResult.SortBy = 'PHIRestriction';
        ACETClaimSearchResult.SortOrder = 'Desc';
        obj = (Object)res;
        Integer i = res.compareTo(obj);
    }
    
    static testmethod void getcompareresult5()
    {
        Object obj;
        
        ACETClaimSearchResult res = new ACETClaimSearchResult();
        res.BenefitLevel = 'test';
        res.PHIRestriction = 'test';
        res.claimEvtType = 'test';
        res.ClaimID = '12345';
        res.claimType = 'test';
        res.Deductible = 'true';
        res.levelTypeCode = 'test';
        res.Network = 'test';
        res.patientResponsibility = 'test';
        res.PrimaryDiagnosisCode = 'test';
        res.Processed = 'test';
        res.Provider = 'test';
        res.selected  = true;
            res.ServiceEnd = 'test';
                res.ServiceStart = 'test';
        res.Status = 'test';
        res.TaxID = '12345';
        res.TotalCharged = '12345';
        res.TotalPaid = '12345';
        ACETClaimSearchResult.SortBy = 'Provider';
        ACETClaimSearchResult.SortOrder = 'Desc';
        obj = (Object)res;
        Integer i = res.compareTo(obj);
    }
    
    static testmethod void getcompareresult6()
    {
        Object obj;
        
        ACETClaimSearchResult res = new ACETClaimSearchResult();
        res.BenefitLevel = 'test';
        res.PHIRestriction = 'test';
        res.claimEvtType = 'test';
        res.ClaimID = '12345';
        res.claimType = 'test';
        res.Deductible = 'true';
        res.levelTypeCode = 'test';
        res.Network = 'test';
        res.patientResponsibility = 'test';
        res.PrimaryDiagnosisCode = 'test';
        res.Processed = 'test';
        res.Provider = 'test';
        res.selected  = true;
            res.ServiceEnd = 'test';
                res.ServiceStart = 'test';
        res.Status = 'test';
        res.TaxID = '12345';
        res.TotalCharged = '12345';
        res.TotalPaid = '12345';
        ACETClaimSearchResult.SortBy = 'TaxID';
        ACETClaimSearchResult.SortOrder = 'Desc';
        obj = (Object)res;
        Integer i = res.compareTo(obj);
    }
    
    static testmethod void getcompareresult7()
    {
        Object obj;
        
        ACETClaimSearchResult res = new ACETClaimSearchResult();
        res.BenefitLevel = 'test';
        res.PHIRestriction = 'test';
        res.claimEvtType = 'test';
        res.ClaimID = '12345';
        res.claimType = 'test';
        res.Deductible = 'true';
        res.levelTypeCode = 'test';
        res.Network = 'test';
        res.patientResponsibility = 'test';
        res.PrimaryDiagnosisCode = 'test';
        res.Processed = 'test';
        res.Provider = 'test';
        res.selected  = true;
            res.ServiceEnd = 'test';
                res.ServiceStart = 'test';
        res.Status = 'test';
        res.TaxID = '12345';
        res.TotalCharged = '12345';
        res.TotalPaid = '12345';
        ACETClaimSearchResult.SortBy = 'Network';
        ACETClaimSearchResult.SortOrder = 'Desc';
        obj = (Object)res;
        Integer i = res.compareTo(obj);
       }
    static testmethod void getcompareresult9()
    {
        Object obj;
        
        ACETClaimSearchResult res = new ACETClaimSearchResult();
        res.BenefitLevel = 'test';
        res.PHIRestriction = 'test';
        res.claimEvtType = 'test';
        res.ClaimID = '12345';
        res.claimType = 'test';
        res.Deductible = 'true';
        res.levelTypeCode = 'test';
        res.Network = 'test';
        res.patientResponsibility = 'test';
        res.PrimaryDiagnosisCode = 'test';
        res.Processed = 'test';
        res.Provider = 'test';
        res.selected  = true;
            res.ServiceEnd = 'test';
                res.ServiceStart = 'test';
        res.Status = 'test';
        res.TaxID = '12345';
        res.TotalCharged = '12345';
        res.TotalPaid = '12345';
        ACETClaimSearchResult.SortBy = 'Status';
        ACETClaimSearchResult.SortOrder = 'Desc';
        obj = (Object)res;
        Integer i = res.compareTo(obj);
    }
    static testmethod void getcompareresult8()
    {
        Object obj;
        
        ACETClaimSearchResult res = new ACETClaimSearchResult();
        res.BenefitLevel = 'test';
        res.PHIRestriction = 'test';
        res.claimEvtType = 'test';
        res.ClaimID = '12345';
        res.claimType = 'test';
        res.Deductible = 'true';
        res.levelTypeCode = 'test';
        res.Network = 'test';
        res.patientResponsibility = 'test';
        res.PrimaryDiagnosisCode = 'test';
        res.Processed = 'test';
        res.Provider = 'test';
        res.selected  = true;
            res.ServiceEnd = 'test';
                res.ServiceStart = 'test';
        res.Status = 'test';
        res.TaxID = '12345';
        res.TotalCharged = '12345';
        res.TotalPaid = '12345';
        ACETClaimSearchResult.SortBy = 'BenefitLevel';
        ACETClaimSearchResult.SortOrder = 'Desc';
        obj = (Object)res;
        Integer i = res.compareTo(obj);
    }
    static testMethod void testRemoteAction(){
        list<String> testlist = new list<String>();
        testlist.add('test1');
        testlist.add('test2');
        try{
            ACETWSCalloutResult remoteActionResult = ACETClaimSearchController.getEncoderProDescriptionMap(testlist); 

            
        }
        catch(exception e){}
    }   
}