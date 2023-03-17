@isTest(SeeAllData=false)
private class ACETProviderDetailControllerTest
{
        static testMethod void  ACETProviderUtilityTest1() {
            account acc = TestDataFactory.CreatePersonAccount();
            case ca = TestDataFactory.createCase();
            //update added to help code coverage for ACETContactHistoryCase class
            ca.TaxID__c = '12345678';
            update ca;
            ACETProviderUtility.CreateProviderAccount('testpro','test123','srl1234');
            ACETProviderUtility.CreateProviderContact('ProviderType', acc,'ProviderId','TaxId','NPI');
            //Used to establish results of a SOSL statement in the GetACETContactCaseHistory method
            Id [] fixedSearchResults = new Id[1];
            fixedSearchResults.add(ca.Id);
            Test.setFixedSearchResults(fixedSearchResults);
            ACETProviderUtility.GetACETContactCaseHistory('12345678');
            ACETProviderUtility.getClasifications('Physician');
            ACETProviderUtility.getSpecilities('Physician');
            ACETProviderUtility.getFederationIDByUserID();
                }
    //Get for HCO
    static testMethod void  ACETProviderDetailControllerTest1() {
        Map<String, String> TestISLWSConfigs = new Map<String, String>(); 
        TestISLWSConfigs.put('ISLConAccessToken', 'dfb379c2-06b7-46c4-8c6f-bbc390d1b854');
        TestISLWSConfigs.put('OILHttpHeaderAccept', 'application/json;charset=UTF-8');
        TestISLWSConfigs.put('OILHttpHeaderActor', 'ACET');
        TestISLWSConfigs.put('OILHttpHeaderScope', 'read');
        TestISLWSConfigs.put('OILTimeout', '3000');
        TestISLWSConfigs.put('dev_ISLOAuthEndpoint', 'https://api-stg.optum.com:8443');
        TestISLWSConfigs.put('dev_getHCOEndpoint', '/api/alpha/eisl/providers/medicalhealthcareorganization/v2.0/read');
        TestISLWSConfigs.put('dev_findAgreementsEndpoint', '/api/alpha/eisl/providers/medicalprovideragreements/v2.0/search');
        List<ISL_Webservice_Config__c> lstISLWSConfigs = ACETTestDataUtility.CreateISLWebserviceConfigurations(TestISLWSConfigs);
        insert lstISLWSConfigs;
        
        StaticResource GetHCOSR = [SELECT Body FROM StaticResource WHERE Name = 'ACETGetHCOResponseJSON1'];
        String GetHCOResponseJSON = GetHCOSR.Body.toString(); 
        system.debug(LoggingLevel.INFO, 'Get HCO Response JSON: ' + GetHCOResponseJSON);
        
        StaticResource GetAgrmntSR = [SELECT Body FROM StaticResource WHERE Name = 'ACETGetAgrmntResponseJSON1'];
        String GetAgrmntResponseJSON = GetAgrmntSR.Body.toString(); 
        system.debug(LoggingLevel.INFO, 'Get Agreement Response JSON: ' + GetAgrmntResponseJSON);
        

        RecordType newRecord = [SELECT Id FROM RecordType WHERE Name = 'Person Account' and SObjectType = 'Account'];
        
        Account accountTest = new Account();
        accountTest.FirstName = 'Test Contact FN';
        accountTest.LastName = 'Test Contact LN';
        accountTest.EID__c = 'TestEID1';
        accountTest.EID__pc = 'TestEID1';
        accountTest.RecordTypeId = newRecord.Id;
        insert accountTest;
        Account oAccount = [SELECT Id,personcontactid from Account where Id=:accountTest.Id];
        Contact oContact = [SELECT Id,LastName,FirstName,EID__c,AccountId from Contact where Id=:oAccount.personcontactid];
        Interaction__c oInteraction = ACETTestDataUtility.CreateInteraction(oContact.Id, 'Phone', 'Member', oContact.LastName);
        insert oInteraction;
        
        ACETHighlightsPanelAdditionalInfo AdditionalInfo = new ACETHighlightsPanelAdditionalInfo();
        AdditionalInfo.PolicyNumber = 'TestPolicyNumber';
        
    //To Cover the ACETContactHistoryCase
        Map<String, String> mapTestCaseDetails = new Map<String, String>();
        mapTestCaseDetails.put('AccountId', oAccount.Id);
        mapTestCaseDetails.put('ContactId', oContact.Id);
        mapTestCaseDetails.put('Interaction__c', oInteraction.Id);
        mapTestCaseDetails.put('Status', 'Open');
        mapTestCaseDetails.put('Origin', 'Phone');
        mapTestCaseDetails.put('Topic__c', 'Provider Other Inquiry');
        Case TestCase = ACETTestDataUtility.CreateTestCase(mapTestCaseDetails); 
        TestCase.TaxID__c='TstTaxID1';
        insert TestCase;
        Id [] fixedSearchResults= new Id[]{TestCase.Id};
        Test.setFixedSearchResults(fixedSearchResults);
        Test.startTest();
        
        PageReference ACETPD = Page.ACETProviderDetail;
        ACETPD.getParameters().put('Id', oInteraction.Id);
        ACETPD.getParameters().put('Type', 'ProviderNotFound');
        ACETPD.getParameters().put('ProviderTypeCode', 'HCO');
        ACETPD.getParameters().put('providerTINStatusCode', 'A');
        ACETPD.getParameters().put('ProvideraddressTypeCode', 'PRAC');
        ACETPD.getParameters().put('providerTINOwner', '');
        ACETPD.getParameters().put('hcoTypeCode', '');
        ACETPD.getParameters().put('providerStatusCode', '');
        ACETPD.getParameters().put('providerTINTypeCode', 'TIN');
        ACETPD.getParameters().put('addressId', '1452407774842');
        ACETPD.getParameters().put('addressTypeCode', 'PRAC');
        ACETPD.getParameters().put('contactName', 'TestContact');

        Test.setCurrentPageReference(ACETPD);
        
        ACETProviderDetailController ACETPDCtrl = new ACETProviderDetailController();
        ACETPDCtrl.Init();
        
        Continuation oContinuation = (Continuation)ACETPDCtrl.CallWSOnPageLoad();
        Map<String, HttpRequest> HttpRequests = oContinuation.getRequests();
        system.assertEquals(1, HttpRequests.size());
        
        HttpResponse response;
        HttpRequest request;
        
        for (String RequestLabel: HttpRequests.keyset()) {
            request = HttpRequests.get(RequestLabel);
            response = new HttpResponse();
            response.setStatusCode(200);
            response.setStatus('OK');
            if (request.getEndpoint().contains('/api/alpha/eisl/providers/medicalhealthcareorganization/v2.0/read')) {
                response.setBody(GetHCOResponseJSON);
            }      
            else {
                response.setBody(GetAgrmntResponseJSON);
            }     
            Test.setContinuationResponse(RequestLabel, response); 
        }
        Object result = Test.invokeContinuationMethod(ACETPDCtrl, oContinuation);
        
             
        Test.stopTest();
    }
    
    //Get for HCP
    static testMethod void  ACETProviderDetailControllerTest2() {
        Map<String, String> TestISLWSConfigs = new Map<String, String>(); 
        TestISLWSConfigs.put('ISLConAccessToken', 'dfb379c2-06b7-46c4-8c6f-bbc390d1b854');
        TestISLWSConfigs.put('OILHttpHeaderAccept', 'application/json;charset=UTF-8');
        TestISLWSConfigs.put('OILHttpHeaderActor', 'ACET');
        TestISLWSConfigs.put('OILHttpHeaderScope', 'read');
        TestISLWSConfigs.put('OILTimeout', '3000');
        TestISLWSConfigs.put('dev_ISLOAuthEndpoint', 'https://api-stg.optum.com:8443');
        TestISLWSConfigs.put('dev_getHCPAdapterEndpoint', '/api/alpha/eisl/providers/medicalhealthcareprofessional/v2.0/read');
        TestISLWSConfigs.put('dev_findAgreementsEndpoint', '/api/alpha/eisl/providers/medicalprovideragreements/v2.0/search');
        List<ISL_Webservice_Config__c> lstISLWSConfigs = ACETTestDataUtility.CreateISLWebserviceConfigurations(TestISLWSConfigs);
        insert lstISLWSConfigs;
        
        StaticResource GetHCOSR = [SELECT Body FROM StaticResource WHERE Name = 'ACETGetHCPResponseJSON1'];
        String GetHCOResponseJSON = GetHCOSR.Body.toString(); 
        system.debug(LoggingLevel.INFO, 'Get HCO Response JSON: ' + GetHCOResponseJSON);
        
        StaticResource GetAgrmntSR = [SELECT Body FROM StaticResource WHERE Name = 'ACETGetAgrmntResponseJSON2'];
        String GetAgrmntResponseJSON = GetAgrmntSR.Body.toString(); 
        system.debug(LoggingLevel.INFO, 'Get Agreement Response JSON: ' + GetAgrmntResponseJSON);
        
        Contact oContact = createContactPA();
        Interaction__c oInteraction = ACETTestDataUtility.CreateInteraction(oContact.Id, 'Phone', 'Member', oContact.LastName);
        insert oInteraction;
        
        ACETHighlightsPanelAdditionalInfo AdditionalInfo = new ACETHighlightsPanelAdditionalInfo();
        AdditionalInfo.PolicyNumber = 'TestPolicyNumber';
        
        Test.startTest();
        
        PageReference ACETPD = Page.ACETProviderDetail;
        ACETPD.getParameters().put('Id', oInteraction.Id);
        ACETPD.getParameters().put('Type', 'ProviderNotFound');
        ACETPD.getParameters().put('ProviderTypeCode', 'HCP');
        ACETPD.getParameters().put('providerTINStatusCode', 'A');
        ACETPD.getParameters().put('ProvideraddressTypeCode', 'PRAC');
        ACETPD.getParameters().put('providerTINOwner', '');
        ACETPD.getParameters().put('hcoTypeCode', '');
        ACETPD.getParameters().put('providerStatusCode', '');
        ACETPD.getParameters().put('providerTINTypeCode', 'TIN');
        ACETPD.getParameters().put('addressId', '1452407774842');
        ACETPD.getParameters().put('addressTypeCode', 'PRAC');
        Test.setCurrentPageReference(ACETPD);
        
        ACETProviderDetailController ACETPDCtrl = new ACETProviderDetailController();
        ACETPDCtrl.Init();
        ACETPDCtrl.subject = oContact;

        
        Continuation oContinuation = (Continuation)ACETPDCtrl.CallWSOnPageLoad();
        Map<String, HttpRequest> HttpRequests = oContinuation.getRequests();
        system.assertEquals(1, HttpRequests.size());
        
        HttpResponse response;
        HttpRequest request;
        for (String RequestLabel: HttpRequests.keyset()) {
            request = HttpRequests.get(RequestLabel);
            response = new HttpResponse();
            response.setStatusCode(200);
            response.setStatus('OK');
            if (request.getEndpoint().contains('/api/alpha/eisl/providers/medicalhealthcareprofessional/v2.0/read')) {
                response.setBody(GetHCOResponseJSON);
            }      
            else {
                response.setBody(GetAgrmntResponseJSON);
            }     
            Test.setContinuationResponse(RequestLabel, response); 
        }
        Object result = Test.invokeContinuationMethod(ACETPDCtrl, oContinuation);
        
        ACETGetHCPAdapterJSON2Apex.tpsm acgt = new ACETGetHCPAdapterJSON2Apex.tpsm();
        acgt.statusCode= 'A';
        acgt.statusEffectiveDate= '0001-01-01';
        acgt.statusCancelDate='0001-01-01';
     
        Test.stopTest();
    }
    
    //Get addresses for HCO
    static testMethod void  ACETProviderDetailControllerTest3() {
        Map<String, String> TestISLWSConfigs = new Map<String, String>(); 
        TestISLWSConfigs.put('ISLConAccessToken', 'dfb379c2-06b7-46c4-8c6f-bbc390d1b854');
        TestISLWSConfigs.put('OILHttpHeaderAccept', 'application/json;charset=UTF-8');
        TestISLWSConfigs.put('OILHttpHeaderActor', 'ACET');
        TestISLWSConfigs.put('OILHttpHeaderScope', 'read');
        TestISLWSConfigs.put('OILTimeout', '3000');
        TestISLWSConfigs.put('dev_ISLOAuthEndpoint', 'https://api-stg.optum.com:8443');
        TestISLWSConfigs.put('dev_findMedicalProviderAdapterEndpoint', '/api/alpha/eisl/providers/medicalproviders/v2.0/search');
        List<ISL_Webservice_Config__c> lstISLWSConfigs = ACETTestDataUtility.CreateISLWebserviceConfigurations(TestISLWSConfigs);
        insert lstISLWSConfigs;
        
        StaticResource ResponseJSONSR = [SELECT Body FROM StaticResource WHERE Name = 'ACETFindMedicalHCOResponseJSON'];
        String ResponseJSON = ResponseJSONSR.Body.toString(); 
        system.debug(LoggingLevel.INFO, 'Response JSON: ' + ResponseJSON);
        
    Contact oContact = createContactPA();
        Interaction__c oInteraction = ACETTestDataUtility.CreateInteraction(oContact.Id, 'Phone', 'Member', oContact.LastName);
        insert oInteraction;
        
        ACETHighlightsPanelAdditionalInfo AdditionalInfo = new ACETHighlightsPanelAdditionalInfo();
        AdditionalInfo.PolicyNumber = 'TestPolicyNumber';
        
        MockHttpCalloutResponseGenerator.MockHttpResponse OILTestResponse = new MockHttpCalloutResponseGenerator.MockHttpResponse(200, 'OK', ResponseJSON);
        OILTestResponse.TokenExpired = false;
        
        Test.startTest();
        
        MockHttpCalloutResponseGenerator MockHttpResponse = new MockHttpCalloutResponseGenerator(null, OILTestResponse);
        Test.setMock(HttpCalloutMock.class, MockHttpResponse);
        
        PageReference ACETPD = Page.ACETProviderDetail;
        ACETPD.getParameters().put('Id', oInteraction.Id);
        ACETPD.getParameters().put('Type', 'ProviderNotFound');
        ACETPD.getParameters().put('ProviderTypeCode', 'HCO');
        ACETPD.getParameters().put('providerTINStatusCode', 'A');
        ACETPD.getParameters().put('ProvideraddressTypeCode', 'PRAC');
        ACETPD.getParameters().put('providerTINOwner', '');
        ACETPD.getParameters().put('hcoTypeCode', '');
        ACETPD.getParameters().put('providerStatusCode', '');
        ACETPD.getParameters().put('providerTINTypeCode', 'TIN');
        ACETPD.getParameters().put('addressId', '1452407774842');
        ACETPD.getParameters().put('addressTypeCode', 'PRAC');
        Test.setCurrentPageReference(ACETPD);
        
        ACETProviderDetailController ACETPDCtrl = new ACETProviderDetailController();
        ACETPDCtrl.CallFindMedicalProvider();
        system.assertNotEquals(null, ACETPDCtrl.AddrDTWrapper);
        
        ACETFindHCOWebservice ACETFPLWS = (ACETFindHCOWebservice)JSON.deserialize(ACETPDCtrl.AddrDTWrapper.Service.replace('&#x27;', '\''), ACETFindHCOWebservice.class);
        ACETFPLWS.queryPaginatedData(0, 5, 0);
     
        Test.stopTest();
    }
    
    //Get addresses for HCP
    static testMethod void  ACETProviderDetailControllerTest4() {
        Map<String, String> TestISLWSConfigs = new Map<String, String>(); 
        TestISLWSConfigs.put('ISLConAccessToken', 'dfb379c2-06b7-46c4-8c6f-bbc390d1b854');
        TestISLWSConfigs.put('OILHttpHeaderAccept', 'application/json;charset=UTF-8');
        TestISLWSConfigs.put('OILHttpHeaderActor', 'ACET');
        TestISLWSConfigs.put('OILHttpHeaderScope', 'read');
        TestISLWSConfigs.put('OILTimeout', '3000');
        TestISLWSConfigs.put('dev_ISLOAuthEndpoint', 'https://api-stg.optum.com:8443');
        TestISLWSConfigs.put('dev_findMedicalProviderAdapterEndpoint', '/api/alpha/eisl/providers/medicalproviders/v2.0/search');
        List<ISL_Webservice_Config__c> lstISLWSConfigs = ACETTestDataUtility.CreateISLWebserviceConfigurations(TestISLWSConfigs);
        insert lstISLWSConfigs;
        
        StaticResource ResponseJSONSR = [SELECT Body FROM StaticResource WHERE Name = 'ACETFindMedicalHCPResponseJSON'];
        String ResponseJSON = ResponseJSONSR.Body.toString(); 
        system.debug(LoggingLevel.INFO, 'Response JSON: ' + ResponseJSON);
        
    Contact oContact = createContactPA();
        Interaction__c oInteraction = ACETTestDataUtility.CreateInteraction(oContact.Id, 'Phone', 'Member', oContact.LastName);
        insert oInteraction;
        
        ACETHighlightsPanelAdditionalInfo AdditionalInfo = new ACETHighlightsPanelAdditionalInfo();
        AdditionalInfo.PolicyNumber = 'TestPolicyNumber';
        
        MockHttpCalloutResponseGenerator.MockHttpResponse OILTestResponse = new MockHttpCalloutResponseGenerator.MockHttpResponse(200, 'OK', ResponseJSON);
        OILTestResponse.TokenExpired = false;
        
        Test.startTest();
        
        MockHttpCalloutResponseGenerator MockHttpResponse = new MockHttpCalloutResponseGenerator(null, OILTestResponse);
        Test.setMock(HttpCalloutMock.class, MockHttpResponse);
        
        PageReference ACETPD = Page.ACETProviderDetail;
        ACETPD.getParameters().put('Id', oInteraction.Id);
        ACETPD.getParameters().put('Type', 'ProviderNotFound');
        ACETPD.getParameters().put('ProviderTypeCode', 'HCP');
        ACETPD.getParameters().put('providerTINStatusCode', 'A');
        ACETPD.getParameters().put('ProvideraddressTypeCode', 'PRAC');
        ACETPD.getParameters().put('providerTINOwner', '');
        ACETPD.getParameters().put('hcoTypeCode', '');
        ACETPD.getParameters().put('providerStatusCode', '');
        ACETPD.getParameters().put('providerTINTypeCode', 'TIN');
        ACETPD.getParameters().put('addressId', '1452407774842');
        ACETPD.getParameters().put('addressTypeCode', 'PRAC');
        Test.setCurrentPageReference(ACETPD);
        
        ACETProviderDetailController ACETPDCtrl = new ACETProviderDetailController();
        ACETPDCtrl.CallFindMedicalProvider();
        system.assertNotEquals(null, ACETPDCtrl.AddrDTWrapper);
        
        ACETFindHCPWebservice ACETFPLWS = (ACETFindHCPWebservice)JSON.deserialize(ACETPDCtrl.AddrDTWrapper.Service.replace('&#x27;', '\''), ACETFindHCPWebservice.class);
        ACETFPLWS.queryPaginatedData(0, 5, 0);
     
        Test.stopTest();
    }
    
    //Get affiliations for HCO
    static testMethod void  ACETProviderDetailControllerTest5() {
        Map<String, String> TestISLWSConfigs = new Map<String, String>(); 
        TestISLWSConfigs.put('ISLConAccessToken', 'dfb379c2-06b7-46c4-8c6f-bbc390d1b854');
        TestISLWSConfigs.put('OILHttpHeaderAccept', 'application/json;charset=UTF-8');
        TestISLWSConfigs.put('OILHttpHeaderActor', 'ACET');
        TestISLWSConfigs.put('OILHttpHeaderScope', 'read');
        TestISLWSConfigs.put('OILTimeout', '3000');
        TestISLWSConfigs.put('dev_ISLOAuthEndpoint', 'https://api-stg.optum.com:8443');
        TestISLWSConfigs.put('dev_FindHCOAffEndpoint', '    /api/alpha/eisl/providers/medicalhealthcareorganizationaffiliations/v2.0/search');
        List<ISL_Webservice_Config__c> lstISLWSConfigs = ACETTestDataUtility.CreateISLWebserviceConfigurations(TestISLWSConfigs);
        insert lstISLWSConfigs;
        
        StaticResource ResponseJSONSR = [SELECT Body FROM StaticResource WHERE Name = 'ACETFindHCOAffResponseJSON1'];
        String ResponseJSON = ResponseJSONSR.Body.toString(); 
        system.debug(LoggingLevel.INFO, 'Response JSON: ' + ResponseJSON);
        
    Contact oContact = createContactPA();
        Interaction__c oInteraction = ACETTestDataUtility.CreateInteraction(oContact.Id, 'Phone', 'Member', oContact.LastName);
        insert oInteraction;
        
        ACETHighlightsPanelAdditionalInfo AdditionalInfo = new ACETHighlightsPanelAdditionalInfo();
        AdditionalInfo.PolicyNumber = 'TestPolicyNumber';
        
        MockHttpCalloutResponseGenerator.MockHttpResponse OILTestResponse = new MockHttpCalloutResponseGenerator.MockHttpResponse(200, 'OK', ResponseJSON);
        OILTestResponse.TokenExpired = false;
        
        Test.startTest();
        
        MockHttpCalloutResponseGenerator MockHttpResponse = new MockHttpCalloutResponseGenerator(null, OILTestResponse);
        Test.setMock(HttpCalloutMock.class, MockHttpResponse);
        
        PageReference ACETPD = Page.ACETProviderDetail;
        ACETPD.getParameters().put('Id', oInteraction.Id);
        ACETPD.getParameters().put('Type', 'ProviderNotFound');
        ACETPD.getParameters().put('ProviderTypeCode', 'HCO');
        ACETPD.getParameters().put('providerTINStatusCode', 'A');
        ACETPD.getParameters().put('ProvideraddressTypeCode', 'PRAC');
        ACETPD.getParameters().put('providerTINOwner', '');
        ACETPD.getParameters().put('hcoTypeCode', '');
        ACETPD.getParameters().put('providerStatusCode', '');
        ACETPD.getParameters().put('providerTINTypeCode', 'TIN');
        ACETPD.getParameters().put('addressId', '1452407774842');
        ACETPD.getParameters().put('addressTypeCode', 'PRAC');
        Test.setCurrentPageReference(ACETPD);
        
        ACETProviderDetailController ACETPDCtrl = new ACETProviderDetailController();
        ACETPDCtrl.CallFindAffiliations();
        system.assertNotEquals(null, ACETPDCtrl.AffDTWrapper);
        
        ACETFindHCOAffiliationsWebservice ACETFPLWS = (ACETFindHCOAffiliationsWebservice)JSON.deserialize(ACETPDCtrl.AffDTWrapper.Service.replace('&#x27;', '\''), ACETFindHCOAffiliationsWebservice.class);
        ACETFPLWS.queryPaginatedData(0, 5, 0);
     
        Test.stopTest();
    }
    
    //Get affiliations for HCO, no records found
    static testMethod void  ACETProviderDetailControllerTest6() {
        Map<String, String> TestISLWSConfigs = new Map<String, String>(); 
        TestISLWSConfigs.put('ISLConAccessToken', 'dfb379c2-06b7-46c4-8c6f-bbc390d1b854');
        TestISLWSConfigs.put('OILHttpHeaderAccept', 'application/json;charset=UTF-8');
        TestISLWSConfigs.put('OILHttpHeaderActor', 'ACET');
        TestISLWSConfigs.put('OILHttpHeaderScope', 'read');
        TestISLWSConfigs.put('OILTimeout', '3000');
        TestISLWSConfigs.put('dev_ISLOAuthEndpoint', 'https://api-stg.optum.com:8443');
        TestISLWSConfigs.put('dev_FindHCOAffEndpoint', '    /api/alpha/eisl/providers/medicalhealthcareorganizationaffiliations/v2.0/search');
        List<ISL_Webservice_Config__c> lstISLWSConfigs = ACETTestDataUtility.CreateISLWebserviceConfigurations(TestISLWSConfigs);
        insert lstISLWSConfigs;
        
        String ResponseJSON = '{"findMedicalHealthcareOrganizationAffiliationsResult":{"findMedicalHealthcareOrganizationAffiliationsResponseType":{"errors":[{"code":"W008","name":"No records returned",';
        ResponseJSON += '"severity":"low","origin":"Consumer","description":"Consumer has requested a query for which no records have been found.';
        ResponseJSON += '"}],"pagination":{"pageNumber":"0","pageSize":"2","recordCount":"0","totalCount":"0","totalPages":"0"}}}}'; 
        
    Contact oContact = createContactPA();
        Interaction__c oInteraction = ACETTestDataUtility.CreateInteraction(oContact.Id, 'Phone', 'Member', oContact.LastName);
        insert oInteraction;
        
        ACETHighlightsPanelAdditionalInfo AdditionalInfo = new ACETHighlightsPanelAdditionalInfo();
        AdditionalInfo.PolicyNumber = 'TestPolicyNumber';
        
        MockHttpCalloutResponseGenerator.MockHttpResponse OILTestResponse = new MockHttpCalloutResponseGenerator.MockHttpResponse(200, 'OK', ResponseJSON);
        OILTestResponse.TokenExpired = false;
        
        Test.startTest();
        
        MockHttpCalloutResponseGenerator MockHttpResponse = new MockHttpCalloutResponseGenerator(null, OILTestResponse);
        Test.setMock(HttpCalloutMock.class, MockHttpResponse);
        
        PageReference ACETPD = Page.ACETProviderDetail;
        ACETPD.getParameters().put('Id', oInteraction.Id);
        ACETPD.getParameters().put('Type', 'ProviderNotFound');
        ACETPD.getParameters().put('ProviderTypeCode', 'HCO');
        ACETPD.getParameters().put('providerTINStatusCode', 'A');
        ACETPD.getParameters().put('ProvideraddressTypeCode', 'PRAC');
        ACETPD.getParameters().put('providerTINOwner', '');
        ACETPD.getParameters().put('hcoTypeCode', '');
        ACETPD.getParameters().put('providerStatusCode', '');
        ACETPD.getParameters().put('providerTINTypeCode', 'TIN');
        ACETPD.getParameters().put('addressId', '1452407774842');
        ACETPD.getParameters().put('addressTypeCode', 'PRAC');
        Test.setCurrentPageReference(ACETPD);
        
        ACETProviderDetailController ACETPDCtrl = new ACETProviderDetailController();
        ACETPDCtrl.CallFindAffiliations();
        system.assertNotEquals(null, ACETPDCtrl.AffDTWrapper);
        
        ACETFindHCOAffiliationsWebservice ACETFPLWS = (ACETFindHCOAffiliationsWebservice)JSON.deserialize(ACETPDCtrl.AffDTWrapper.Service.replace('&#x27;', '\''), ACETFindHCOAffiliationsWebservice.class);
        ACETFPLWS.queryPaginatedData(0, 5, 0);
     
        Test.stopTest();
    }
    
    //Get affiliations for HCO, error response
    static testMethod void  ACETProviderDetailControllerTest7() {
        Map<String, String> TestISLWSConfigs = new Map<String, String>(); 
        TestISLWSConfigs.put('ISLConAccessToken', 'dfb379c2-06b7-46c4-8c6f-bbc390d1b854');
        TestISLWSConfigs.put('OILHttpHeaderAccept', 'application/json;charset=UTF-8');
        TestISLWSConfigs.put('OILHttpHeaderActor', 'ACET');
        TestISLWSConfigs.put('OILHttpHeaderScope', 'read');
        TestISLWSConfigs.put('OILTimeout', '3000');
        TestISLWSConfigs.put('dev_ISLOAuthEndpoint', 'https://api-stg.optum.com:8443');
        TestISLWSConfigs.put('dev_FindHCOAffEndpoint', '    /api/alpha/eisl/providers/medicalhealthcareorganizationaffiliations/v2.0/search');
        List<ISL_Webservice_Config__c> lstISLWSConfigs = ACETTestDataUtility.CreateISLWebserviceConfigurations(TestISLWSConfigs);
     /*   ISL_Webservice_Config__c EndpointWSConfig = new ISL_Webservice_Config__c();
        EndpointWSConfig.Name = 'dev_FindHCOAffEndpoint';
        EndpointWSConfig.Value__c = '/api/alpha/eisl/providers/medicalhealthcareorganizationaffiliations/v2.0/search';
        EndpointWSConfig.Error_Log_Enabled__c = true;
        lstISLWSConfigs.add(EndpointWSConfig); */
        insert lstISLWSConfigs;
        
        String ResponseJSON = '{"findMedicalHealthcareOrganizationAffiliationsResult":{"errors":[{"code":"W008","name":"No records returned","severity":"low",';
        ResponseJSON += '"origin":"Consumer","description":"Consumer has requested a query for which no records have been found."}]}}';
        
    Contact oContact = createContactPA();
        Interaction__c oInteraction = ACETTestDataUtility.CreateInteraction(oContact.Id, 'Phone', 'Member', oContact.LastName);
        insert oInteraction;
        
        ACETHighlightsPanelAdditionalInfo AdditionalInfo = new ACETHighlightsPanelAdditionalInfo();
        AdditionalInfo.PolicyNumber = 'TestPolicyNumber';
        
        MockHttpCalloutResponseGenerator.MockHttpResponse OILTestResponse = new MockHttpCalloutResponseGenerator.MockHttpResponse(500, 'Internal Server Error', ResponseJSON);
        OILTestResponse.TokenExpired = false;
        
        Test.startTest();
        
        MockHttpCalloutResponseGenerator MockHttpResponse = new MockHttpCalloutResponseGenerator(null, OILTestResponse);
        Test.setMock(HttpCalloutMock.class, MockHttpResponse);
        
        PageReference ACETPD = Page.ACETProviderDetail;
        ACETPD.getParameters().put('Id', oInteraction.Id);
        ACETPD.getParameters().put('Type', 'ProviderNotFound');
        ACETPD.getParameters().put('ProviderTypeCode', 'HCO');
        ACETPD.getParameters().put('providerTINStatusCode', 'A');
        ACETPD.getParameters().put('ProvideraddressTypeCode', 'PRAC');
        ACETPD.getParameters().put('providerTINOwner', '');
        ACETPD.getParameters().put('hcoTypeCode', '');
        ACETPD.getParameters().put('providerStatusCode', '');
        ACETPD.getParameters().put('providerTINTypeCode', 'TIN');
        ACETPD.getParameters().put('addressId', '1452407774842');
        ACETPD.getParameters().put('addressTypeCode', 'PRAC');
        Test.setCurrentPageReference(ACETPD);
        
        ACETProviderDetailController ACETPDCtrl = new ACETProviderDetailController();
        ACETPDCtrl.CallFindAffiliations();
        system.assertNotEquals(null, ACETPDCtrl.AffDTWrapper);
        
        ACETFindHCOAffiliationsWebservice ACETFPLWS = (ACETFindHCOAffiliationsWebservice)JSON.deserialize(ACETPDCtrl.AffDTWrapper.Service.replace('&#x27;', '\''), ACETFindHCOAffiliationsWebservice.class);
        ACETFPLWS.queryPaginatedData(0, 5, 0);
     
        Test.stopTest();
    }
    
    //Get affiliations for HCO, invalid JSON
    static testMethod void  ACETProviderDetailControllerTest8() {
        Map<String, String> TestISLWSConfigs = new Map<String, String>(); 
        TestISLWSConfigs.put('ISLConAccessToken', 'dfb379c2-06b7-46c4-8c6f-bbc390d1b854');
        TestISLWSConfigs.put('OILHttpHeaderAccept', 'application/json;charset=UTF-8');
        TestISLWSConfigs.put('OILHttpHeaderActor', 'ACET');
        TestISLWSConfigs.put('OILHttpHeaderScope', 'read');
        TestISLWSConfigs.put('OILTimeout', '3000');
        TestISLWSConfigs.put('dev_ISLOAuthEndpoint', 'https://api-stg.optum.com:8443');
        TestISLWSConfigs.put('dev_FindHCOAffEndpoint', '    /api/alpha/eisl/providers/medicalhealthcareorganizationaffiliations/v2.0/search');
        List<ISL_Webservice_Config__c> lstISLWSConfigs = ACETTestDataUtility.CreateISLWebserviceConfigurations(TestISLWSConfigs);
        insert lstISLWSConfigs;
        
        String ResponseJSON = '{"findMedicalHealthcareOrganizationAffiliationsResult":{"errors":"code":"W008","name":"No records returned","severity":"low",';
        ResponseJSON += '"origin":"Consumer","description":"Consumer has requested a query for which no records have been found."}]}}';
        
    Contact oContact = createContactPA();
        Interaction__c oInteraction = ACETTestDataUtility.CreateInteraction(oContact.Id, 'Phone', 'Member', oContact.LastName);
        insert oInteraction;
        
        ACETHighlightsPanelAdditionalInfo AdditionalInfo = new ACETHighlightsPanelAdditionalInfo();
        AdditionalInfo.PolicyNumber = 'TestPolicyNumber';
        
        MockHttpCalloutResponseGenerator.MockHttpResponse OILTestResponse = new MockHttpCalloutResponseGenerator.MockHttpResponse(200, 'OK', ResponseJSON);
        OILTestResponse.TokenExpired = false;
        
        Test.startTest();
        
        MockHttpCalloutResponseGenerator MockHttpResponse = new MockHttpCalloutResponseGenerator(null, OILTestResponse);
        Test.setMock(HttpCalloutMock.class, MockHttpResponse);
        
        PageReference ACETPD = Page.ACETProviderDetail;
        ACETPD.getParameters().put('Id', oInteraction.Id);
        ACETPD.getParameters().put('Type', 'ProviderNotFound');
        ACETPD.getParameters().put('ProviderTypeCode', 'HCO');
        ACETPD.getParameters().put('providerTINStatusCode', 'A');
        ACETPD.getParameters().put('ProvideraddressTypeCode', 'PRAC');
        ACETPD.getParameters().put('providerTINOwner', '');
        ACETPD.getParameters().put('hcoTypeCode', '');
        ACETPD.getParameters().put('providerStatusCode', '');
        ACETPD.getParameters().put('providerTINTypeCode', 'TIN');
        ACETPD.getParameters().put('addressId', '1452407774842');
        ACETPD.getParameters().put('addressTypeCode', 'PRAC');
        Test.setCurrentPageReference(ACETPD);
        
        ACETProviderDetailController ACETPDCtrl = new ACETProviderDetailController();
        ACETPDCtrl.CallFindAffiliations();
        system.assertNotEquals(null, ACETPDCtrl.AffDTWrapper);
        
        ACETFindHCOAffiliationsWebservice ACETFPLWS = (ACETFindHCOAffiliationsWebservice)JSON.deserialize(ACETPDCtrl.AffDTWrapper.Service.replace('&#x27;', '\''), ACETFindHCOAffiliationsWebservice.class);
        ACETFPLWS.queryPaginatedData(0, 5, 0);
     
        Test.stopTest();
    }
    
    //Get affiliations for HCP
    static testMethod void  ACETProviderDetailControllerTest9() {
        Map<String, String> TestISLWSConfigs = new Map<String, String>(); 
        TestISLWSConfigs.put('ISLConAccessToken', 'dfb379c2-06b7-46c4-8c6f-bbc390d1b854');
        TestISLWSConfigs.put('OILHttpHeaderAccept', 'application/json;charset=UTF-8');
        TestISLWSConfigs.put('OILHttpHeaderActor', 'ACET');
        TestISLWSConfigs.put('OILHttpHeaderScope', 'read');
        TestISLWSConfigs.put('OILTimeout', '3000');
        TestISLWSConfigs.put('dev_ISLOAuthEndpoint', 'https://api-stg.optum.com:8443');
        TestISLWSConfigs.put('dev_FindHCPAffEndpoint', '/api/alpha/eisl/providers/medicalhealthcareprofessionalaffiliations/v2.0/search');
        List<ISL_Webservice_Config__c> lstISLWSConfigs = ACETTestDataUtility.CreateISLWebserviceConfigurations(TestISLWSConfigs);
        insert lstISLWSConfigs;
        
        StaticResource ResponseJSONSR = [SELECT Body FROM StaticResource WHERE Name = 'ACETFindHCPAffResponseJSON1'];
        String ResponseJSON = ResponseJSONSR.Body.toString(); 
        system.debug(LoggingLevel.INFO, 'Response JSON: ' + ResponseJSON);
        
    Contact oContact = createContactPA();
        Interaction__c oInteraction = ACETTestDataUtility.CreateInteraction(oContact.Id, 'Phone', 'Member', oContact.LastName);
        insert oInteraction;
        
        ACETHighlightsPanelAdditionalInfo AdditionalInfo = new ACETHighlightsPanelAdditionalInfo();
        AdditionalInfo.PolicyNumber = 'TestPolicyNumber';
        
        MockHttpCalloutResponseGenerator.MockHttpResponse OILTestResponse = new MockHttpCalloutResponseGenerator.MockHttpResponse(200, 'OK', ResponseJSON);
        OILTestResponse.TokenExpired = false;
        
        Test.startTest();
        
        MockHttpCalloutResponseGenerator MockHttpResponse = new MockHttpCalloutResponseGenerator(null, OILTestResponse);
        Test.setMock(HttpCalloutMock.class, MockHttpResponse);
        
        PageReference ACETPD = Page.ACETProviderDetail;
        ACETPD.getParameters().put('Id', oInteraction.Id);
        ACETPD.getParameters().put('Type', 'ProviderNotFound');
        ACETPD.getParameters().put('ProviderTypeCode', 'HCP');
        ACETPD.getParameters().put('providerTINStatusCode', 'A');
        ACETPD.getParameters().put('ProvideraddressTypeCode', 'PRAC');
        ACETPD.getParameters().put('providerTINOwner', '');
        ACETPD.getParameters().put('hcoTypeCode', '');
        ACETPD.getParameters().put('providerStatusCode', '');
        ACETPD.getParameters().put('providerTINTypeCode', 'TIN');
        ACETPD.getParameters().put('addressId', '1452407774842');
        ACETPD.getParameters().put('addressTypeCode', 'PRAC');
        Test.setCurrentPageReference(ACETPD);
        
        ACETProviderDetailController ACETPDCtrl = new ACETProviderDetailController();
        ACETPDCtrl.CallFindAffiliations();
        system.assertNotEquals(null, ACETPDCtrl.AffDTWrapper);
        
        ACETFindHCPAffiliationsWebservice ACETFPLWS = (ACETFindHCPAffiliationsWebservice)JSON.deserialize(ACETPDCtrl.AffDTWrapper.Service.replace('&#x27;', '\''), ACETFindHCPAffiliationsWebservice.class);
        ACETFPLWS.queryPaginatedData(0, 5, 0);
     
        Test.stopTest();
    }
    
    //Get affiliations for HCP, no records found
    static testMethod void  ACETProviderDetailControllerTest10() {
        Map<String, String> TestISLWSConfigs = new Map<String, String>(); 
        TestISLWSConfigs.put('ISLConAccessToken', 'dfb379c2-06b7-46c4-8c6f-bbc390d1b854');
        TestISLWSConfigs.put('OILHttpHeaderAccept', 'application/json;charset=UTF-8');
        TestISLWSConfigs.put('OILHttpHeaderActor', 'ACET');
        TestISLWSConfigs.put('OILHttpHeaderScope', 'read');
        TestISLWSConfigs.put('OILTimeout', '3000');
        TestISLWSConfigs.put('dev_ISLOAuthEndpoint', 'https://api-stg.optum.com:8443');
        TestISLWSConfigs.put('dev_FindHCPAffEndpoint', '/api/alpha/eisl/providers/medicalhealthcareprofessionalaffiliations/v2.0/search');
        List<ISL_Webservice_Config__c> lstISLWSConfigs = ACETTestDataUtility.CreateISLWebserviceConfigurations(TestISLWSConfigs);
        insert lstISLWSConfigs;
        
        String ResponseJSON = '{"findMedicalHealthcareProfessionalAffiliationsResult":{"findMedicalHealthcareProfessionalAffiliationsResponseType":{"errors":[{"code":"W008","name":"No records returned",';
        ResponseJSON += '"severity":"low","origin":"Consumer","description":"Consumer has requested a query for which no records have been found.';
        ResponseJSON += '"}],"pagination":{"pageNumber":"0","pageSize":"2","recordCount":"0","totalCount":"0","totalPages":"0"}}}}';
        
    Contact oContact = createContactPA();
        Interaction__c oInteraction = ACETTestDataUtility.CreateInteraction(oContact.Id, 'Phone', 'Member', oContact.LastName);
        insert oInteraction;
        
        ACETHighlightsPanelAdditionalInfo AdditionalInfo = new ACETHighlightsPanelAdditionalInfo();
        AdditionalInfo.PolicyNumber = 'TestPolicyNumber';
        
        MockHttpCalloutResponseGenerator.MockHttpResponse OILTestResponse = new MockHttpCalloutResponseGenerator.MockHttpResponse(200, 'OK', ResponseJSON);
        OILTestResponse.TokenExpired = false;
        
        Test.startTest();
        
        MockHttpCalloutResponseGenerator MockHttpResponse = new MockHttpCalloutResponseGenerator(null, OILTestResponse);
        Test.setMock(HttpCalloutMock.class, MockHttpResponse);
        
        PageReference ACETPD = Page.ACETProviderDetail;
        ACETPD.getParameters().put('Id', oInteraction.Id);
        ACETPD.getParameters().put('Type', 'ProviderNotFound');
        ACETPD.getParameters().put('ProviderTypeCode', 'HCP');
        ACETPD.getParameters().put('providerTINStatusCode', 'A');
        ACETPD.getParameters().put('ProvideraddressTypeCode', 'PRAC');
        ACETPD.getParameters().put('providerTINOwner', '');
        ACETPD.getParameters().put('hcoTypeCode', '');
        ACETPD.getParameters().put('providerStatusCode', '');
        ACETPD.getParameters().put('providerTINTypeCode', 'TIN');
        ACETPD.getParameters().put('addressId', '1452407774842');
        ACETPD.getParameters().put('addressTypeCode', 'PRAC');
        Test.setCurrentPageReference(ACETPD);
        
        ACETProviderDetailController ACETPDCtrl = new ACETProviderDetailController();
        ACETPDCtrl.CallFindAffiliations();
        system.assertNotEquals(null, ACETPDCtrl.AffDTWrapper);
        
        ACETFindHCPAffiliationsWebservice ACETFPLWS = (ACETFindHCPAffiliationsWebservice)JSON.deserialize(ACETPDCtrl.AffDTWrapper.Service.replace('&#x27;', '\''), ACETFindHCPAffiliationsWebservice.class);
        ACETFPLWS.queryPaginatedData(0, 5, 0);
     
        Test.stopTest();
    }
    
    //Get affiliations for HCP, error response
    static testMethod void  ACETProviderDetailControllerTest11() {
        Map<String, String> TestISLWSConfigs = new Map<String, String>(); 
        TestISLWSConfigs.put('ISLConAccessToken', 'dfb379c2-06b7-46c4-8c6f-bbc390d1b854');
        TestISLWSConfigs.put('OILHttpHeaderAccept', 'application/json;charset=UTF-8');
        TestISLWSConfigs.put('OILHttpHeaderActor', 'ACET');
        TestISLWSConfigs.put('OILHttpHeaderScope', 'read');
        TestISLWSConfigs.put('OILTimeout', '3000');
        TestISLWSConfigs.put('dev_ISLOAuthEndpoint', 'https://api-stg.optum.com:8443');
        TestISLWSConfigs.put('dev_FindHCPAffEndpoint', '/api/alpha/eisl/providers/medicalhealthcareprofessionalaffiliations/v2.0/search');
        List<ISL_Webservice_Config__c> lstISLWSConfigs = ACETTestDataUtility.CreateISLWebserviceConfigurations(TestISLWSConfigs);
        insert lstISLWSConfigs;
        
        String ResponseJSON = '{"findMedicalHealthcareProfessionalAffiliationsResult":{"errors":[{"code":"W008","name":"No records returned","severity":"low",';
        ResponseJSON += '"origin":"Consumer","description":"Consumer has requested a query for which no records have been found."}]}}';
        
    Contact oContact = createContactPA();
        Interaction__c oInteraction = ACETTestDataUtility.CreateInteraction(oContact.Id, 'Phone', 'Member', oContact.LastName);
        insert oInteraction;
        
        ACETHighlightsPanelAdditionalInfo AdditionalInfo = new ACETHighlightsPanelAdditionalInfo();
        AdditionalInfo.PolicyNumber = 'TestPolicyNumber';
        
        MockHttpCalloutResponseGenerator.MockHttpResponse OILTestResponse = new MockHttpCalloutResponseGenerator.MockHttpResponse(500, 'Internal Server Error', ResponseJSON);
        OILTestResponse.TokenExpired = false;
        
        Test.startTest();
        
        MockHttpCalloutResponseGenerator MockHttpResponse = new MockHttpCalloutResponseGenerator(null, OILTestResponse);
        Test.setMock(HttpCalloutMock.class, MockHttpResponse);
        
        PageReference ACETPD = Page.ACETProviderDetail;
        ACETPD.getParameters().put('Id', oInteraction.Id);
        ACETPD.getParameters().put('Type', 'ProviderNotFound');
        ACETPD.getParameters().put('ProviderTypeCode', 'HCP');
        ACETPD.getParameters().put('providerTINStatusCode', 'A');
        ACETPD.getParameters().put('ProvideraddressTypeCode', 'PRAC');
        ACETPD.getParameters().put('providerTINOwner', '');
        ACETPD.getParameters().put('hcoTypeCode', '');
        ACETPD.getParameters().put('providerStatusCode', '');
        ACETPD.getParameters().put('providerTINTypeCode', 'TIN');
        ACETPD.getParameters().put('addressId', '1452407774842');
        ACETPD.getParameters().put('addressTypeCode', 'PRAC');
        Test.setCurrentPageReference(ACETPD);
        
        ACETProviderDetailController ACETPDCtrl = new ACETProviderDetailController();
        ACETPDCtrl.CallFindAffiliations();
        system.assertNotEquals(null, ACETPDCtrl.AffDTWrapper);
        
        ACETFindHCPAffiliationsWebservice ACETFPLWS = (ACETFindHCPAffiliationsWebservice)JSON.deserialize(ACETPDCtrl.AffDTWrapper.Service.replace('&#x27;', '\''), ACETFindHCPAffiliationsWebservice.class);
        ACETFPLWS.queryPaginatedData(0, 5, 0);
     
        Test.stopTest();
    }
    
    //Get affiliations for HCP, invalid json
    static testMethod void  ACETProviderDetailControllerTest12() {
        Map<String, String> TestISLWSConfigs = new Map<String, String>(); 
        TestISLWSConfigs.put('ISLConAccessToken', 'dfb379c2-06b7-46c4-8c6f-bbc390d1b854');
        TestISLWSConfigs.put('OILHttpHeaderAccept', 'application/json;charset=UTF-8');
        TestISLWSConfigs.put('OILHttpHeaderActor', 'ACET');
        TestISLWSConfigs.put('OILHttpHeaderScope', 'read');
        TestISLWSConfigs.put('OILTimeout', '3000');
        TestISLWSConfigs.put('dev_ISLOAuthEndpoint', 'https://api-stg.optum.com:8443');
        TestISLWSConfigs.put('dev_FindHCPAffEndpoint', '/api/alpha/eisl/providers/medicalhealthcareprofessionalaffiliations/v2.0/search');
        List<ISL_Webservice_Config__c> lstISLWSConfigs = ACETTestDataUtility.CreateISLWebserviceConfigurations(TestISLWSConfigs);
        insert lstISLWSConfigs;
        
        String ResponseJSON = '{"findMedicalHealthcareProfessionalAffiliationsResult":{"errors":"code":"W008","name":"No records returned","severity":"low",';
        ResponseJSON += '"origin":"Consumer","description":"Consumer has requested a query for which no records have been found."}]}}';
        
    Contact oContact = createContactPA();
        Interaction__c oInteraction = ACETTestDataUtility.CreateInteraction(oContact.Id, 'Phone', 'Member', oContact.LastName);
        insert oInteraction;
        
        ACETHighlightsPanelAdditionalInfo AdditionalInfo = new ACETHighlightsPanelAdditionalInfo();
        AdditionalInfo.PolicyNumber = 'TestPolicyNumber';
        
        MockHttpCalloutResponseGenerator.MockHttpResponse OILTestResponse = new MockHttpCalloutResponseGenerator.MockHttpResponse(200, 'OK', ResponseJSON);
        OILTestResponse.TokenExpired = false;
        
        Test.startTest();
        
        MockHttpCalloutResponseGenerator MockHttpResponse = new MockHttpCalloutResponseGenerator(null, OILTestResponse);
        Test.setMock(HttpCalloutMock.class, MockHttpResponse);
        
        PageReference ACETPD = Page.ACETProviderDetail;
        ACETPD.getParameters().put('Id', oInteraction.Id);
        ACETPD.getParameters().put('Type', 'ProviderNotFound');
        ACETPD.getParameters().put('ProviderTypeCode', 'HCP');
        ACETPD.getParameters().put('providerTINStatusCode', 'A');
        ACETPD.getParameters().put('ProvideraddressTypeCode', 'PRAC');
        ACETPD.getParameters().put('providerTINOwner', '');
        ACETPD.getParameters().put('hcoTypeCode', '');
        ACETPD.getParameters().put('providerStatusCode', '');
        ACETPD.getParameters().put('providerTINTypeCode', 'TIN');
        ACETPD.getParameters().put('addressId', '1452407774842');
        ACETPD.getParameters().put('addressTypeCode', 'PRAC');
        Test.setCurrentPageReference(ACETPD);
        
        ACETProviderDetailController ACETPDCtrl = new ACETProviderDetailController();
        ACETPDCtrl.CallFindAffiliations();
        system.assertNotEquals(null, ACETPDCtrl.AffDTWrapper);
        
        ACETFindHCPAffiliationsWebservice ACETFPLWS = (ACETFindHCPAffiliationsWebservice)JSON.deserialize(ACETPDCtrl.AffDTWrapper.Service.replace('&#x27;', '\''), ACETFindHCPAffiliationsWebservice.class);
        ACETFPLWS.queryPaginatedData(0, 5, 0);
     
        Test.stopTest();
    }
   static testMethod void  ACETProviderDetailControllerTest13() {
        Map<String, String> TestISLWSConfigs = new Map<String, String>(); 
        TestISLWSConfigs.put('ISLConAccessToken', 'dfb379c2-06b7-46c4-8c6f-bbc390d1b854');
        TestISLWSConfigs.put('OILHttpHeaderAccept', 'application/json;charset=UTF-8');
        TestISLWSConfigs.put('OILHttpHeaderActor', 'ACET');
        TestISLWSConfigs.put('OILHttpHeaderScope', 'read');
        TestISLWSConfigs.put('OILTimeout', '3000');
        TestISLWSConfigs.put('dev_ISLOAuthEndpoint', 'https://api-stg.optum.com:8443');
        TestISLWSConfigs.put('dev_FindHCPAffEndpoint', '/api/alpha/eisl/providers/medicalhealthcareprofessionalaffiliations/v2.0/search');
        List<ISL_Webservice_Config__c> lstISLWSConfigs = ACETTestDataUtility.CreateISLWebserviceConfigurations(TestISLWSConfigs);
        insert lstISLWSConfigs;
        
        String ResponseJSON = '{"findMedicalHealthcareProfessionalAffiliationsResult":{"errors":[{"code":"W008","name":"No records returned","severity":"low",';
        ResponseJSON += '"origin":"Consumer","description":"Consumer has requested a query for which no records have been found."}]}}';
        
    Contact oContact = createContactPA();
        Interaction__c oInteraction = ACETTestDataUtility.CreateInteraction(oContact.Id, 'Phone', 'Member', oContact.LastName);
        insert oInteraction;
        
        ACETHighlightsPanelAdditionalInfo AdditionalInfo = new ACETHighlightsPanelAdditionalInfo();
        AdditionalInfo.PolicyNumber = 'TestPolicyNumber';
        
        MockHttpCalloutResponseGenerator.MockHttpResponse OILTestResponse = new MockHttpCalloutResponseGenerator.MockHttpResponse(500, 'Internal Server Error', ResponseJSON);
        OILTestResponse.TokenExpired = false;
        
        Test.startTest();
        
        MockHttpCalloutResponseGenerator MockHttpResponse = new MockHttpCalloutResponseGenerator(null, OILTestResponse);
        Test.setMock(HttpCalloutMock.class, MockHttpResponse);
        
        PageReference ACETPD = Page.ACETProviderDetail;
        ACETPD.getParameters().put('Id', oInteraction.Id);
        ACETPD.getParameters().put('Type', 'ProviderNotFound');
        ACETPD.getParameters().put('ProviderTypeCode', 'HCP');
        ACETPD.getParameters().put('providerTINStatusCode', 'A');
        ACETPD.getParameters().put('ProvideraddressTypeCode', 'PRAC');
        ACETPD.getParameters().put('providerTINOwner', '');
        ACETPD.getParameters().put('hcoTypeCode', '');
        ACETPD.getParameters().put('providerStatusCode', '');
        ACETPD.getParameters().put('providerTINTypeCode', 'TIN');
        ACETPD.getParameters().put('addressId', '1452407774842');
        ACETPD.getParameters().put('addressTypeCode', 'PRAC');
        Test.setCurrentPageReference(ACETPD);
        
        ACETProviderDetailController ACETPDCtrl = new ACETProviderDetailController();
       // ACETPDCtrl.getCallTopicOptions();
        ACETPDCtrl.CallFindAffiliations();
        system.assertNotEquals(null, ACETPDCtrl.AffDTWrapper);
        
        ACETFindHCPAffiliationsWebservice ACETFPLWS = (ACETFindHCPAffiliationsWebservice)JSON.deserialize(ACETPDCtrl.AffDTWrapper.Service.replace('&#x27;', '\''), ACETFindHCPAffiliationsWebservice.class);
        ACETFPLWS.queryPaginatedData(0, 5, 0);
        
        Interaction__c ProviderTestInteraction = ACETProviderSearchController.RedirectToProviderDetail('Phone Call', 'Contact Name', 'EID1', '999999999', '9999999999', 'Group Name', 'Physician','1452423968971','12345','60005');
        ACETGetHCPWebservice GHCPWS = new ACETGetHCPWebservice();
        GHCPWS.returningFromService = 'providerLookup';

        PageReference ACETPDPage = Page.ACETProviderDetail;
        ACETPDPage.getParameters().put('Id', ProviderTestInteraction.Id);
        test.setCurrentPage(ACETPDPage);
         string resp=  ACETTestDataUtility.getHCPAdapterJSON();
        GHCPWS .ProcessResponse('tesrt',resp);
        ACETProviderDetailController.ACETProviderGeneralInfo APGI = new ACETProviderDetailController.ACETProviderGeneralInfo();
        APGI.phone ='9090909090';
        APGI.primaryPhysician='primaryPhysician';
        APGI.newPatients='newPatients';
        APGI.paytoIndividual='paytoIndividual';
        APGI.medicareId='medicareId';
        APGI.medicaidId='medicaidId';
        APGI.providerType='Type1';
        APGI.lastName='';
        APGI.firstName='';
        APGI.taxId='24234343';
        APGI.providerID='2424242342342342';
        APGI.platinumProvider='';
        APGI.providerTINOwner='';
        APGI.hcoTypeCode='';
        APGI.providerTINTypeCode='';
        APGI.providerGenderCode='';
        APGI.providerBirthDate='';
        APGI.patientAgeRange='';
        ACETProviderDetailController.ACETProviderSpeciality prsp = new ACETProviderDetailController.ACETProviderSpeciality();
        prsp.primarySpeciality = '';
        prsp.speciality = '';
        prsp.boardCert = '';
        prsp.cancelDate = '';
        
        ACETProviderDetailController.Degree deg = new ACETProviderDetailController.Degree();
        deg.code = '';
        deg.schoolName = '';
        ACETProviderDetailController.HoursOfOperation HO = new ACETProviderDetailController.HoursOfOperation();
        HO.weekCode = ''; 
        HO.startTime1 = '';
        HO.endTime1 = '';
        HO.startTime2 = '';
        HO.endTime2 = '';
       
        ACETProviderDetailController.ACETProviderUnitedPremium Unitedpriem = new ACETProviderDetailController.ACETProviderUnitedPremium();
        Unitedpriem.premiumDesignation = '';
        Unitedpriem.premiumSpeciality = '';
        Unitedpriem.effectiveDate = '';
        Unitedpriem.premiumCancelDate = '';
       
        ACETProviderDetailController.Language ALNG = new ACETProviderDetailController.Language();
        ALNG.languageStatusCode='ENG';
        ALNG.languageCode='ENG';
        ALNG.languageSpokenByCode='ENG1';
        ALNG.languageSpokenByDesc='TEST';
        ALNG.languageWrittenByCode='TESTCODE';
        ALNG.languageWrittenByDesc='TEL';
        ALNG.language = 'dutch';
        Test.stopTest();
    }

    static testMethod void  ACETProviderDetailControllerTest14() {
        Map<String, String> TestISLWSConfigs = new Map<String, String>(); 
        TestISLWSConfigs.put('ISLConAccessToken', 'dfb379c2-06b7-46c4-8c6f-bbc390d1b854');
        TestISLWSConfigs.put('OILHttpHeaderAccept', 'application/json;charset=UTF-8');
        TestISLWSConfigs.put('OILHttpHeaderActor', 'ACET');
        TestISLWSConfigs.put('OILHttpHeaderScope', 'read');
        TestISLWSConfigs.put('OILTimeout', '3000');
        TestISLWSConfigs.put('dev_ISLOAuthEndpoint', 'https://api-stg.optum.com:8443');
        TestISLWSConfigs.put('dev_getHCOEndpoint', '/api/alpha/eisl/providers/medicalhealthcareorganization/v2.0/read');
        List<ISL_Webservice_Config__c> lstISLWSConfigs = ACETTestDataUtility.CreateISLWebserviceConfigurations(TestISLWSConfigs);
        insert lstISLWSConfigs;
        
        Test.startTest();
        
        ACETGetHCOWebservice ACETGetHCOWS = new ACETGetHCOWebservice();
        ACETGetHCOWS.queryPaginatedData(0, 50, 0);
        ACETGetHCOWS.queryPaginatedData(0, 50);
        ACETProviderDetailController.ACETProviderUnitedPremium ACETPUP = new ACETProviderDetailController.ACETProviderUnitedPremium();
        ACETPUP.efficiencyTypeDescription='test';
        ACETPUP.qualityTypeDescription ='test';
       Test.stopTest();
    }
    
    static testMethod void  ACETProviderDetailControllerTest61() {
        Map<String, String> TestISLWSConfigs = new Map<String, String>(); 
        TestISLWSConfigs.put('ISLConAccessToken', 'dfb379c2-06b7-46c4-8c6f-bbc390d1b854');
        TestISLWSConfigs.put('OILHttpHeaderAccept', 'application/json;charset=UTF-8');
        TestISLWSConfigs.put('OILHttpHeaderActor', 'ACET');
        TestISLWSConfigs.put('OILHttpHeaderScope', 'read');
        TestISLWSConfigs.put('OILTimeout', '3000');
        TestISLWSConfigs.put('dev_ISLOAuthEndpoint', 'https://api-stg.optum.com:8443');
        TestISLWSConfigs.put('dev_getHCOEndpoint', '/api/alpha/eisl/providers/medicalhealthcareorganization/v2.0/read');
        TestISLWSConfigs.put('dev_findAgreementsEndpoint', '/api/alpha/eisl/providers/medicalprovideragreements/v2.0/search');
        List<ISL_Webservice_Config__c> lstISLWSConfigs = ACETTestDataUtility.CreateISLWebserviceConfigurations(TestISLWSConfigs);
        insert lstISLWSConfigs;
        
        StaticResource GetHCOSR = [SELECT Body FROM StaticResource WHERE Name = 'ACETGetHCOResponseJSON1'];
        String GetHCOResponseJSON = GetHCOSR.Body.toString(); 
        system.debug(LoggingLevel.INFO, 'Get HCO Response JSON: ' + GetHCOResponseJSON);
        
        StaticResource GetAgrmntSR = [SELECT Body FROM StaticResource WHERE Name = 'ACETGetAgrmntResponseJSON1'];
        String GetAgrmntResponseJSON = GetAgrmntSR.Body.toString(); 
        system.debug(LoggingLevel.INFO, 'Get Agreement Response JSON: ' + GetAgrmntResponseJSON);
        
        RecordType newRecord = [SELECT Id FROM RecordType WHERE Name = 'Person Account' and SObjectType = 'Account'];
        
        Account accountTest = new Account();
        accountTest.FirstName = 'Test Contact FN';
        accountTest.LastName = 'Test Contact LN';
        accountTest.EID__c = 'TestEID1';
        accountTest.EID__pc = 'TestEID1';
        accountTest.RecordTypeId = newRecord.Id;
        insert accountTest;
        Account oAccount = [SELECT Id,personcontactid from Account where Id=:accountTest.Id];
        Contact oContact = [SELECT Id,LastName,FirstName,EID__c,AccountId from Contact where Id=:oAccount.personcontactid];
        
        Interaction__c oInteraction = ACETTestDataUtility.CreateInteraction(oContact.Id, 'Phone', '', oContact.LastName);
        insert oInteraction;
        
        ACETHighlightsPanelAdditionalInfo AdditionalInfo = new ACETHighlightsPanelAdditionalInfo();
        AdditionalInfo.PolicyNumber = 'TestPolicyNumber';
        
    //To Cover the ACETContactHistoryCase
        Map<String, String> mapTestCaseDetails = new Map<String, String>();
        mapTestCaseDetails.put('AccountId',oAccount.Id);
        mapTestCaseDetails.put('ContactId',oContact.Id );
        mapTestCaseDetails.put('Interaction__c', oInteraction.Id);
        mapTestCaseDetails.put('Status', 'Open');
        mapTestCaseDetails.put('Origin', 'Phone');
        mapTestCaseDetails.put('Topic__c', 'Provider Other Inquiry');
        Case TestCase = ACETTestDataUtility.CreateTestCase(mapTestCaseDetails); 
        TestCase.TaxID__c='TstTaxID1';
        insert TestCase;
        Id [] fixedSearchResults= new Id[]{TestCase.Id};
        Test.setFixedSearchResults(fixedSearchResults);
        Test.startTest();
        
        PageReference ACETPD = Page.ACETProviderDetail;
        ACETPD.getParameters().put('Id', oInteraction.Id);
        ACETPD.getParameters().put('Type', 'ProviderNotFound');
        ACETPD.getParameters().put('ProviderTypeCode', 'HCO');
        ACETPD.getParameters().put('providerTINStatusCode', 'A');
        ACETPD.getParameters().put('ProvideraddressTypeCode', 'PRAC');
        ACETPD.getParameters().put('providerTINOwner', '');
        ACETPD.getParameters().put('hcoTypeCode', '');
        ACETPD.getParameters().put('providerStatusCode', '');
        ACETPD.getParameters().put('providerTINTypeCode', 'TIN');
        ACETPD.getParameters().put('addressId', '1452407774842');
        ACETPD.getParameters().put('addressTypeCode', 'PRAC');
        ACETPD.getParameters().put('contactName', 'TestContact');

        Test.setCurrentPageReference(ACETPD);
        
        ACETProviderDetailController ACETPDCtrl = new ACETProviderDetailController();
        ACETProviderDetailController.ACETProviderSpeciality APDSCtrl = new ACETProviderDetailController.ACETProviderSpeciality();
        APDSCtrl.primarySpeciality = 'test';
        APDSCtrl.speciality = 'test';
        APDSCtrl.boardCert = 'test';
        APDSCtrl.cancelDate = '0001-01-01';
        List<ACETProviderDetailController.ACETProviderSpeciality> APDSpList = new List<ACETProviderDetailController.ACETProviderSpeciality>{APDSCtrl};
        ACETProviderDetailController.ACETProviderDetail APDSPT = new ACETProviderDetailController.ACETProviderDetail();
        APDSPT.specialities = APDSpList;
        ACETPDCtrl.Init();
        
        Continuation oContinuation = (Continuation)ACETPDCtrl.CallWSOnPageLoad();
        Map<String, HttpRequest> HttpRequests = oContinuation.getRequests();
        //system.assertEquals(1, HttpRequests.size());
        
        HttpResponse response;
        HttpRequest request;
        
        for (String RequestLabel: HttpRequests.keyset()) {
            request = HttpRequests.get(RequestLabel);
            response = new HttpResponse();
            response.setStatusCode(200);
            response.setStatus('OK');
            if (request.getEndpoint().contains('/api/alpha/eisl/providers/medicalhealthcareorganization/v2.0/read')) {
                response.setBody(GetHCOResponseJSON);
            }      
            else {
                response.setBody(GetAgrmntResponseJSON);
            }     
            Test.setContinuationResponse(RequestLabel, response); 
        }
        Object result = Test.invokeContinuationMethod(ACETPDCtrl, oContinuation);
        
             
        Test.stopTest();
       }
    //Get agreements
    static testMethod void  getAgreementsTest() {
        Map<String, String> TestISLWSConfigs = new Map<String, String>(); 
        TestISLWSConfigs.put('ISLConAccessToken', 'dfb379c2-06b7-46c4-8c6f-bbc390d1b854');
        TestISLWSConfigs.put('OILHttpHeaderAccept', 'application/json;charset=UTF-8');
        TestISLWSConfigs.put('OILHttpHeaderActor', 'ACET');
        TestISLWSConfigs.put('OILHttpHeaderScope', 'read');
        TestISLWSConfigs.put('OILTimeout', '3000');
        TestISLWSConfigs.put('dev_ISLOAuthEndpoint', 'https://api-stg.optum.com:8443');
        TestISLWSConfigs.put('d1_findAgreementsEndpoint', '/api/alpha/eisl/providers/medicalprovideragreements/v2.0/search');
        List<ISL_Webservice_Config__c> lstISLWSConfigs = ACETTestDataUtility.CreateISLWebserviceConfigurations(TestISLWSConfigs);
        insert lstISLWSConfigs;
        
        StaticResource GetAgrmntSR = [SELECT Body FROM StaticResource WHERE Name = 'ACETGetAgrmntResponseJSON1'];
        String GetAgrmntResponseJSON = GetAgrmntSR.Body.toString(); 
        
    Contact oContact = createContactPA();
        Interaction__c oInteraction = ACETTestDataUtility.CreateInteraction(oContact.Id, 'Phone', 'Member', oContact.LastName);
        insert oInteraction;
        
        ACETHighlightsPanelAdditionalInfo AdditionalInfo = new ACETHighlightsPanelAdditionalInfo();
        AdditionalInfo.PolicyNumber = 'TestPolicyNumber';
        
        MockHttpCalloutResponseGenerator.MockHttpResponse OILTestResponse = new MockHttpCalloutResponseGenerator.MockHttpResponse(200, 'OK', GetAgrmntResponseJSON);
        OILTestResponse.TokenExpired = false;
        
        Test.startTest();
        
        MockHttpCalloutResponseGenerator MockHttpResponse = new MockHttpCalloutResponseGenerator(null, OILTestResponse);
        Test.setMock(HttpCalloutMock.class, MockHttpResponse);
        
        PageReference ACETPD = Page.ACETProviderDetail;
        ACETPD.getParameters().put('Id', oInteraction.Id);
        ACETPD.getParameters().put('Type', 'ProviderNotFound');
        ACETPD.getParameters().put('ProviderTypeCode', 'HCO');
        ACETPD.getParameters().put('providerTINStatusCode', 'A');
        ACETPD.getParameters().put('ProvideraddressTypeCode', 'PRAC');
        ACETPD.getParameters().put('providerTINOwner', '');
        ACETPD.getParameters().put('hcoTypeCode', '');
        ACETPD.getParameters().put('providerStatusCode', '');
        ACETPD.getParameters().put('providerTINTypeCode', 'TIN');
        ACETPD.getParameters().put('addressId', '1452407774842');
        ACETPD.getParameters().put('addressTypeCode', 'PRAC');
        Test.setCurrentPageReference(ACETPD);
        
        ACETProviderDetailController ACETPDCtrl = new ACETProviderDetailController();
        ACETPDCtrl.CallFindAgreements();
        system.assertNotEquals(null, ACETPDCtrl.AgrmntsDTWrapper);
        
        ACETFindAgreementsWebservice ACETFPLWS = (ACETFindAgreementsWebservice)JSON.deserialize(ACETPDCtrl.AgrmntsDTWrapper.Service.replace('&#x27;', '\''), ACETFindAgreementsWebservice.class);
        ACETFPLWS.queryPaginatedData(0, 5, 0);
        Test.stopTest();
    }
    static testMethod void getAgreementTestFailure() {
        
        Map<String, String> TestISLWSConfigs = new Map<String, String>(); 
        TestISLWSConfigs.put('ISLConAccessToken', 'dfb379c2-06b7-46c4-8c6f-bbc390d1b854');
        TestISLWSConfigs.put('ISLOAuthContentType', 'application/x-www-form-urlencoded');
        TestISLWSConfigs.put('ISLOAuthGrantType', 'client_credentials');
        TestISLWSConfigs.put('OILHttpHeaderAccept', 'application/json;charset=UTF-8');
        TestISLWSConfigs.put('OILHttpHeaderActor', 'ACET');
        TestISLWSConfigs.put('OILHttpHeaderScope', 'read');
        TestISLWSConfigs.put('OILTimeout', '3000');
        TestISLWSConfigs.put('dev_ISLOAuthEndpoint', 'https://api-stg.optum.com:8443');
        TestISLWSConfigs.put('dev_findMedicalProviderAdapterEndpoint', '/api/alpha/eisl/providers/medicalprovideragreements/v2.0/search');
        List<ISL_Webservice_Config__c> lstISLWSConfigs = ACETTestDataUtility.CreateISLWebserviceConfigurations(TestISLWSConfigs);
        insert lstISLWSConfigs;
        
        String ResponseJSON = '{"findMedicalProviderAgreementsResponse":{"errors":[{"code":"W008","name":"No records returned","severity":"low",';
        ResponseJSON += '"origin":"Consumer","description":"Consumer has requested a query for which no records have been found."}]}}'; 
        
        system.debug(LoggingLevel.INFO, 'Response JSON: ' + ResponseJSON);
        
    Contact oContact = createContactPA();
        Interaction__c oInteraction = ACETTestDataUtility.CreateInteraction(oContact.Id, 'Phone', 'Member', oContact.LastName);
        insert oInteraction;
        
        ACETHighlightsPanelAdditionalInfo AdditionalInfo = new ACETHighlightsPanelAdditionalInfo();
        AdditionalInfo.PolicyNumber = 'TestPolicyNumber';
        
        MockHttpCalloutResponseGenerator.MockHttpResponse OILTestResponse = new MockHttpCalloutResponseGenerator.MockHttpResponse(500, 'Internal Server Error', ResponseJSON);
        OILTestResponse.TokenExpired = false;
        
        Test.startTest();
        
        MockHttpCalloutResponseGenerator MockHttpResponse = new MockHttpCalloutResponseGenerator(null, OILTestResponse);
        Test.setMock(HttpCalloutMock.class, MockHttpResponse);
        
       PageReference ACETPD = Page.ACETProviderDetail;
        ACETPD.getParameters().put('Id', oInteraction.Id);
        ACETPD.getParameters().put('Type', 'ProviderNotFound');
        ACETPD.getParameters().put('ProviderTypeCode', 'HCO');
        ACETPD.getParameters().put('providerTINStatusCode', 'A');
        ACETPD.getParameters().put('ProvideraddressTypeCode', 'PRAC');
        ACETPD.getParameters().put('providerTINOwner', '');
        ACETPD.getParameters().put('hcoTypeCode', '');
        ACETPD.getParameters().put('providerStatusCode', '');
        ACETPD.getParameters().put('providerTINTypeCode', 'TIN');
        ACETPD.getParameters().put('addressId', '1452407774842');
        ACETPD.getParameters().put('addressTypeCode', 'PRAC');
        Test.setCurrentPageReference(ACETPD);
        ACETProviderDetailController ACETPDCtrl = new ACETProviderDetailController();
        ACETPDCtrl.CallFindAgreements();
        //system.assertNotEquals(null, ACETPDCtrl.AgrmntsDTWrapper);
        
        ACETFindAgreementsWebservice ACETFPLWS = (ACETFindAgreementsWebservice)JSON.deserialize(ACETPDCtrl.AgrmntsDTWrapper.Service.replace('&#x27;', '\''), ACETFindAgreementsWebservice.class);
        ACETFPLWS.init('','','','','','','@@networkId@@','');
        ACETFPLWS.queryPaginatedData(0, 5, 0);
        
        
        Test.stopTest();
    }
    
    public static Contact createContactPA(){
      RecordType newRecord = [SELECT Id FROM RecordType WHERE Name = 'Person Account' and SObjectType = 'Account'];
        
        Account accountTest = new Account();
        accountTest.FirstName = 'Test Contact FN';
        accountTest.LastName = 'Test Contact LN';
        accountTest.EID__c = 'TestEID1';
        accountTest.EID__pc = 'TestEID1';
        accountTest.RecordTypeId = newRecord.Id;
        insert accountTest;

    Account acc = [SELECT Id,personcontactid from Account where Id=:accountTest.Id];
        Contact con = [SELECT Id,LastName,FirstName,EID__c,AccountId from Contact where Id=:acc.personcontactid];
        con.Tax_Id__c = 'TstTaxID1';
        con.NPI__c = 'TestNPI1';
        return con;
    }
    
}