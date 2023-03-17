@isTest(seealldata=false)
private class ACETProviderSearchControllerTest
{
    //Success response for FindMedicalProviders for both
    static testMethod void ACETProviderSearchControllerTest1() {
        
        Map<String, String> TestISLWSConfigs = new Map<String, String>(); 
        TestISLWSConfigs.put('ISLConAccessToken', 'dfb379c2-06b7-46c4-8c6f-bbc390d1b854');
        TestISLWSConfigs.put('ISLOAuthContentType', 'application/x-www-form-urlencoded');
        TestISLWSConfigs.put('ISLOAuthGrantType', 'client_credentials');
        TestISLWSConfigs.put('OILHttpHeaderAccept', 'application/json;charset=UTF-8');
        TestISLWSConfigs.put('OILHttpHeaderActor', 'ACET');
        TestISLWSConfigs.put('OILHttpHeaderScope', 'read');
        TestISLWSConfigs.put('OILTimeout', '3000');
        TestISLWSConfigs.put('dev_ISLOAuthEndpoint', 'https://api-stg.optum.com:8443');
        TestISLWSConfigs.put('dev_findMedicalProviderAdapterEndpoint', '/api/alpha/eisl/providers/medicalproviders/v2.0/search');
        List<ISL_Webservice_Config__c> lstISLWSConfigs = ACETTestDataUtility.CreateISLWebserviceConfigurations(TestISLWSConfigs);
        insert lstISLWSConfigs;
        
        StaticResource ResponseJSONSR = [SELECT Body FROM StaticResource WHERE Name = 'ACETFindMedicalProvidersResponseJSON'];
        String ResponseJSON = ResponseJSONSR.Body.toString(); 
        system.debug(LoggingLevel.INFO, 'Response JSON: ' + ResponseJSON);
        
        MockHttpCalloutResponseGenerator.MockHttpResponse OILTestResponse = new MockHttpCalloutResponseGenerator.MockHttpResponse(200, 'OK', ResponseJSON);
        OILTestResponse.TokenExpired = false;
        
        Test.startTest();
        
        MockHttpCalloutResponseGenerator MockHttpResponse = new MockHttpCalloutResponseGenerator(null, OILTestResponse);
        Test.setMock(HttpCalloutMock.class, MockHttpResponse);
        
        PageReference ACETPS = Page.ACETProviderSearch;
        Test.setCurrentPageReference(ACETPS);
        
        ACETProviderSearchController ACETPSCtrl = new ACETProviderSearchController();
        ACETPSCtrl.getInteractionTypes();
        ACETPSCtrl.InteractionType = 'Phone Call';
        ACETPSCtrl.CallerName = 'Test Caller Name';
        ACETPSCtrl.FilterBy = 'Both';
        ACETPSCtrl.TaxId = '362340413';
        
        ACETPSCtrl.Search();
        system.assertNotEquals(null, ACETPSCtrl.DTWrapper);
        
        ACETFindProviderLookupWebservice ACETFPLWS = (ACETFindProviderLookupWebservice)JSON.deserialize(ACETPSCtrl.DTWrapper.Service.replace('&#x27;', '\''), ACETFindProviderLookupWebservice.class);
        ACETFPLWS.queryPaginatedData(0, 5, 0);
        
        Interaction__c TestInteraction = ACETProviderSearchController.RedirectToProviderDetail(ACETPSCtrl.InteractionType, ACETPSCtrl.CallerName, 
                'PID11111', 'TaxId1111', 'NPI11111', 'FName LName', Label.ACETProviderPhysician,'1452423968971','12345','60005');
        system.assertNotEquals(null, TestInteraction);
        
        ACETPSCtrl.clearResults();
        system.assertEquals(null, ACETPSCtrl.DTWrapper);
        
        Test.stopTest();
    }
    
    //Success response for FindMedicalProviders for physician
    static testMethod void ACETProviderSearchControllerTest2() {
        
        Map<String, String> TestISLWSConfigs = new Map<String, String>(); 
        TestISLWSConfigs.put('ISLConAccessToken', 'dfb379c2-06b7-46c4-8c6f-bbc390d1b854');
        TestISLWSConfigs.put('ISLOAuthContentType', 'application/x-www-form-urlencoded');
        TestISLWSConfigs.put('ISLOAuthGrantType', 'client_credentials');
        TestISLWSConfigs.put('OILHttpHeaderAccept', 'application/json;charset=UTF-8');
        TestISLWSConfigs.put('OILHttpHeaderActor', 'ACET');
        TestISLWSConfigs.put('OILHttpHeaderScope', 'read');
        TestISLWSConfigs.put('OILTimeout', '3000');
        TestISLWSConfigs.put('dev_ISLOAuthEndpoint', 'https://api-stg.optum.com:8443');
        TestISLWSConfigs.put('dev_findMedicalProviderAdapterEndpoint', '/api/alpha/eisl/providers/medicalproviders/v2.0/search');
        List<ISL_Webservice_Config__c> lstISLWSConfigs = ACETTestDataUtility.CreateISLWebserviceConfigurations(TestISLWSConfigs);
        insert lstISLWSConfigs;
        
        StaticResource ResponseJSONSR = [SELECT Body FROM StaticResource WHERE Name = 'ACETFindMedProvHCPResponseJSON'];
        String ResponseJSON = ResponseJSONSR.Body.toString(); 
        system.debug(LoggingLevel.INFO, 'Response JSON: ' + ResponseJSON);
        
        MockHttpCalloutResponseGenerator.MockHttpResponse OILTestResponse = new MockHttpCalloutResponseGenerator.MockHttpResponse(200, 'OK', ResponseJSON);
        OILTestResponse.TokenExpired = false;
        
        Test.startTest();
        
        MockHttpCalloutResponseGenerator MockHttpResponse = new MockHttpCalloutResponseGenerator(null, OILTestResponse);
        Test.setMock(HttpCalloutMock.class, MockHttpResponse);
        
        PageReference ACETPS = Page.ACETProviderSearch;
        Test.setCurrentPageReference(ACETPS);
        
        ACETStateCodeContainer ACETSC = new ACETStateCodeContainer('CA');
        
        ACETProviderSearchController ACETPSCtrl = new ACETProviderSearchController();
        ACETPSCtrl.getInteractionTypes();
        ACETPSCtrl.InteractionType = 'Phone Call';
        ACETPSCtrl.CallerName = 'Test Caller Name';
        ACETPSCtrl.FilterBy = 'PROF';
        ACETPSCtrl.TaxId = '362340413';
        ACETPSCtrl.StateCode = ACETSC;
        
        ACETStateCodeController ACETSCCtrl = new ACETStateCodeController();
        ACETSCCtrl.setStateCodeContainer(ACETSC);
        ACETSCCtrl.getStateCodeContainer();
                
        ACETPSCtrl.Search();
        system.assertNotEquals(null, ACETPSCtrl.DTWrapper);
        
        ACETFindProviderLookupWebservice ACETFPLWS = (ACETFindProviderLookupWebservice)JSON.deserialize(ACETPSCtrl.DTWrapper.Service.replace('&#x27;', '\''), ACETFindProviderLookupWebservice.class);
        ACETFPLWS.queryPaginatedData(0, 5, 0);
        
        //Cover exception block in "RedirectToProviderDetail" method        
        String PID = 'PID111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111';
        PID +=  '111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111';
        Interaction__c TestInteraction = ACETProviderSearchController.RedirectToProviderDetail(ACETPSCtrl.InteractionType, ACETPSCtrl.CallerName, 
             PID, 'TaxId1111', 'NPI11111', 'FName LName', Label.ACETProviderPhysician,'1452423968971','12345','60005');
        system.assertEquals(null, TestInteraction);
         
        Test.stopTest();
    }
    
    //Success response for FindMedicalProviders for facility
    static testMethod void ACETProviderSearchControllerTest3() {
        
        Map<String, String> TestISLWSConfigs = new Map<String, String>(); 
        TestISLWSConfigs.put('ISLConAccessToken', 'dfb379c2-06b7-46c4-8c6f-bbc390d1b854');
        TestISLWSConfigs.put('ISLOAuthContentType', 'application/x-www-form-urlencoded');
        TestISLWSConfigs.put('ISLOAuthGrantType', 'client_credentials');
        TestISLWSConfigs.put('OILHttpHeaderAccept', 'application/json;charset=UTF-8');
        TestISLWSConfigs.put('OILHttpHeaderActor', 'ACET');
        TestISLWSConfigs.put('OILHttpHeaderScope', 'read');
        TestISLWSConfigs.put('OILTimeout', '3000');
        TestISLWSConfigs.put('dev_ISLOAuthEndpoint', 'https://api-stg.optum.com:8443');
        TestISLWSConfigs.put('dev_findMedicalProviderAdapterEndpoint', '/api/alpha/eisl/providers/medicalproviders/v2.0/search');
        List<ISL_Webservice_Config__c> lstISLWSConfigs = ACETTestDataUtility.CreateISLWebserviceConfigurations(TestISLWSConfigs);
        insert lstISLWSConfigs;
        
        StaticResource ResponseJSONSR = [SELECT Body FROM StaticResource WHERE Name = 'ACETFindMedicalProvidersResponseJSON'];
        String ResponseJSON = ResponseJSONSR.Body.toString(); 
        system.debug(LoggingLevel.INFO, 'Response JSON: ' + ResponseJSON);
        
        MockHttpCalloutResponseGenerator.MockHttpResponse OILTestResponse = new MockHttpCalloutResponseGenerator.MockHttpResponse(200, 'OK', ResponseJSON);
        OILTestResponse.TokenExpired = false;
        
        Test.startTest();
        
        MockHttpCalloutResponseGenerator MockHttpResponse = new MockHttpCalloutResponseGenerator(null, OILTestResponse);
        Test.setMock(HttpCalloutMock.class, MockHttpResponse);
        
        PageReference ACETPS = Page.ACETProviderSearch;
        Test.setCurrentPageReference(ACETPS);
        
        ACETProviderSearchController ACETPSCtrl = new ACETProviderSearchController();
        ACETPSCtrl.getInteractionTypes();
        ACETPSCtrl.InteractionType = 'Phone Call';
        ACETPSCtrl.CallerName = 'Test Caller Name';
        ACETPSCtrl.FilterBy = 'FACL';
        ACETPSCtrl.TaxId = '362340413';
       // ACETPSCtrl.display=true;
        ACETPSCtrl.FirstName='FName';
        ACETPSCtrl.filterTypeChange();
        ACETPSCtrl.FNameDisable();
        ACETPSCtrl.Search();
        system.assertNotEquals(null, ACETPSCtrl.DTWrapper);
        
        Test.stopTest();
    }
   static testMethod void ACETProviderSearchControllerTest4() {
        
        Map<String, String> TestISLWSConfigs = new Map<String, String>(); 
        TestISLWSConfigs.put('ISLConAccessToken', 'dfb379c2-06b7-46c4-8c6f-bbc390d1b854');
        TestISLWSConfigs.put('ISLOAuthContentType', 'application/x-www-form-urlencoded');
        TestISLWSConfigs.put('ISLOAuthGrantType', 'client_credentials');
        TestISLWSConfigs.put('OILHttpHeaderAccept', 'application/json;charset=UTF-8');
        TestISLWSConfigs.put('OILHttpHeaderActor', 'ACET');
        TestISLWSConfigs.put('OILHttpHeaderScope', 'read');
        TestISLWSConfigs.put('OILTimeout', '3000');
        TestISLWSConfigs.put('dev_ISLOAuthEndpoint', 'https://api-stg.optum.com:8443');
        TestISLWSConfigs.put('dev_findMedicalProviderAdapterEndpoint', '/api/alpha/eisl/providers/medicalproviders/v2.0/search');
        List<ISL_Webservice_Config__c> lstISLWSConfigs = ACETTestDataUtility.CreateISLWebserviceConfigurations(TestISLWSConfigs);
        insert lstISLWSConfigs;
        
        StaticResource ResponseJSONSR = [SELECT Body FROM StaticResource WHERE Name = 'ACETFindMedicalProvidersResponseJSON'];
        String ResponseJSON = ResponseJSONSR.Body.toString(); 
        system.debug(LoggingLevel.INFO, 'Response JSON: ' + ResponseJSON);
        
        MockHttpCalloutResponseGenerator.MockHttpResponse OILTestResponse = new MockHttpCalloutResponseGenerator.MockHttpResponse(200, 'OK', ResponseJSON);
        OILTestResponse.TokenExpired = false;
        
        Test.startTest();
        
        MockHttpCalloutResponseGenerator MockHttpResponse = new MockHttpCalloutResponseGenerator(null, OILTestResponse);
        Test.setMock(HttpCalloutMock.class, MockHttpResponse);
        
        PageReference ACETPS = Page.ACETProviderSearch;
        Test.setCurrentPageReference(ACETPS);
        
        ACETProviderSearchController ACETPSCtrl = new ACETProviderSearchController();
        ACETPSCtrl.getInteractionTypes();
        ACETPSCtrl.InteractionType = 'Phone Call';
        ACETPSCtrl.CallerName = 'Test Caller Name';
        ACETPSCtrl.FilterBy = 'FACL';
        ACETPSCtrl.TaxId = '362340413';
        //ACETPSCtrl.display=true;
        ACETPSCtrl.FirstName='';
        ACETPSCtrl.filterTypeChange();
        ACETPSCtrl.FilterBy = 'FACL';
        ACETPSCtrl.FNameDisable();
        ACETPSCtrl.Search();
        system.assertNotEquals(null, ACETPSCtrl.DTWrapper);
        
        Test.stopTest();
    }

}