@isTest
private class ACETHSAAccountsControllerTest {
   static testMethod void hsaSummaryContrMethod(){
        //Setup records in custom setting
        Map<String, String> mapISLWSConfigs = new Map<String, String>(); 
        mapISLWSConfigs.put('ISLConAccessToken', 'e9b3f2b1-8863-49ec-9ff8-40da25961ef5');
        mapISLWSConfigs.put('OILHttpHeaderAccept', 'application/json;charset=UTF-8');
        mapISLWSConfigs.put('OILHttpHeaderActor', 'ACET');
        mapISLWSConfigs.put('OILHttpHeaderScope', 'read');
        mapISLWSConfigs.put('ISLOAuthContentType', 'application/x-www-form-urlencoded');
        mapISLWSConfigs.put('ISLOAuthGrantType', 'client_credentials');
        mapISLWSConfigs.put('d1_CISLOAuthClientId', 'ISLStageConClientId');
        mapISLWSConfigs.put('d1_CISLOAuthClientSecret', 'ISLStageConClientSecret');
        mapISLWSConfigs.put('d1_CISLOAuthEndpoint', 'https://api-stg.optum.com:8443');
        mapISLWSConfigs.put('d1_ISLOAuthTokenEndpoint', '/auth/oauth/v2/token');
        mapISLWSConfigs.put('OILTimeout', '8000');
        mapISLWSConfigs.put('d1_HsaSummary','/api/alpha/eisl/member/healthsavings/accounts/v1.0/search');
        
        List<ISL_Webservice_Config__c> lstISLWSConfigs = ACETTestDataUtility.CreateISLWebserviceConfigurations(mapISLWSConfigs);
        insert lstISLWSConfigs;
        
        StaticResource ResponseJSONSR = [SELECT Body FROM StaticResource WHERE Name = 'ACETHsaSummaryResponseJSON'];
        String ResponseJSON = ResponseJSONSR.Body.toString(); 
        system.debug(LoggingLevel.INFO, 'Response JSON: ' + ResponseJSON);
        
        MockHttpCalloutResponseGenerator.MockHttpResponse OILResponse = new MockHttpCalloutResponseGenerator.MockHttpResponse(200, 'OK', ResponseJSON );
        OILResponse.TokenExpired = false;
        
        Test.startTest();
        
        MockHttpCalloutResponseGenerator MockHttpRes = new MockHttpCalloutResponseGenerator(null, OILResponse);
        Test.setMock(HttpCalloutMock.class, MockHttpRes);
        
        PageReference ACETHSA= Page.ACETHSAAccounts;
        RecordType newRecord = [SELECT Id FROM RecordType WHERE Name = 'Person Account' and SObjectType = 'Account'];
        
        Account accountTest = new Account();
        accountTest.FirstName = 'Test';
        accountTest.LastName = 'Contact';
        accountTest.EID__c = 'PIN';
        accountTest.EID__pc = 'PIN';
        accountTest.RecordTypeId = newRecord.Id;
        insert accountTest;

    Account acc = [SELECT Id,personcontactid from Account where Id=:accountTest.Id];
        Contact cont = [SELECT Id,LastName,FirstName,EID__c,AccountId from Contact where Id=:acc.personcontactid];
        Interaction__c Interaction = new Interaction__c();
        Interaction.Contact_Name__c = 'Test contname';
        Interaction.Originator__c = cont.id;
        Interaction.Originator_Type__c = 'Member';
        insert Interaction ;
        ACETHSA.getParameters().put('InteractionId', Interaction.Id);
        ACETHSA.getParameters().put('additionalInfo', TestDataFactory.createACETHighlightsPanelAdditionalInfo());        
        ACETHSA.getParameters().put('contactId', cont.Id);
        ACETHSA.getParameters().put('memberId', '123456789');    
        ACETHSA.getParameters().put('callTopic', 'HSA Account');
        ACETHSA.getParameters().put('SRK', '123456789'); 
        ACETHSA.getParameters().put('unmaskedSSN', '123456789'); 
        Test.setCurrentPage(ACETHSA);
       
        ACETHSAAccountsController hsaAcc= new ACETHSAAccountsController();
        hsaAcc.Subject = cont;
        hsaAcc.callWSOnLoad();
        
        ACETHSASummaryWebservice summaryWS = new ACETHSASummaryWebservice();
        HttpResponse response = new HttpResponse();
        response.setStatusCode(200);
        summaryWS.GetHsaSummary('920002001');
        summaryWS.parseSuccessAdapterResponse(ResponseJSON);
        
        ACETHSASummaryJSON2Apex.PostalAddress  j2aPa = new ACETHSASummaryJSON2Apex.PostalAddress();
        j2aPa.typeCode = 'A';
        j2aPa.countryCode = 'USA';
        
        ACETHSASummaryJSON2Apex.ElectronicAddress j2aEa = new ACETHSASummaryJSON2Apex.ElectronicAddress();
        j2aEa.emailAddress= 'A';
        
        ACETHSASummaryJSON2Apex.Individuals j2aInd = new ACETHSASummaryJSON2Apex.Individuals();
        j2aInd.genderCode= 'A';
        j2aInd.electronicAddress = j2aEa;
        
        Test.stopTest();
   } 
   
   static testMethod void hsaSummaryContrMethod2(){
        //Setup records in custom setting
        Map<String, String> mapISLWSConfigs = new Map<String, String>(); 
        mapISLWSConfigs.put('ISLConAccessToken', 'e9b3f2b1-8863-49ec-9ff8-40da25961ef5');
        mapISLWSConfigs.put('OILHttpHeaderAccept', 'application/json;charset=UTF-8');
        mapISLWSConfigs.put('OILHttpHeaderActor', 'ACET');
        mapISLWSConfigs.put('OILHttpHeaderScope', 'read');
        mapISLWSConfigs.put('ISLOAuthContentType', 'application/x-www-form-urlencoded');
        mapISLWSConfigs.put('ISLOAuthGrantType', 'client_credentials');
        mapISLWSConfigs.put('d1_CISLOAuthClientId', 'ISLStageConClientId');
        mapISLWSConfigs.put('d1_CISLOAuthClientSecret', 'ISLStageConClientSecret');
        mapISLWSConfigs.put('d1_CISLOAuthEndpoint', 'https://api-stg.optum.com:8443');
        mapISLWSConfigs.put('d1_ISLOAuthTokenEndpoint', '/auth/oauth/v2/token');
        mapISLWSConfigs.put('OILTimeout', '8000');
        mapISLWSConfigs.put('d1_HsaSummary','/api/alpha/eisl/member/healthsavings/accounts/v1.0/search');
        
        List<ISL_Webservice_Config__c> lstISLWSConfigs = ACETTestDataUtility.CreateISLWebserviceConfigurations(mapISLWSConfigs);
        insert lstISLWSConfigs;
        
        StaticResource ResponseJSONSR = [SELECT Body FROM StaticResource WHERE Name = 'ACETHsaSummaryResponse2JSON'];
        String ResponseJSON = ResponseJSONSR.Body.toString(); 
        system.debug(LoggingLevel.INFO, 'Response JSON: ' + ResponseJSON);
        
        MockHttpCalloutResponseGenerator.MockHttpResponse OILResponse = new MockHttpCalloutResponseGenerator.MockHttpResponse(200, 'OK', ResponseJSON );
        OILResponse.TokenExpired = false;
        
        Test.startTest();
        
        MockHttpCalloutResponseGenerator MockHttpRes = new MockHttpCalloutResponseGenerator(null, OILResponse);
        Test.setMock(HttpCalloutMock.class, MockHttpRes);
        
        PageReference ACETHSA= Page.ACETHSAAccounts;
        RecordType newRecord = [SELECT Id FROM RecordType WHERE Name = 'Person Account' and SObjectType = 'Account'];
        
        Account accountTest = new Account();
        accountTest.FirstName = 'Test';
        accountTest.LastName = 'Contact';
        accountTest.EID__c = 'PIN';
        accountTest.EID__pc = 'PIN';
        accountTest.RecordTypeId = newRecord.Id;
        insert accountTest;

    Account acc = [SELECT Id,personcontactid from Account where Id=:accountTest.Id];
        Contact cont = [SELECT Id,LastName,FirstName,EID__c,AccountId from Contact where Id=:acc.personcontactid];
        Interaction__c Interaction = new Interaction__c();
        Interaction.Contact_Name__c = 'Test contname';
        Interaction.Originator__c = cont.id;
        Interaction.Originator_Type__c = 'Member';
        insert Interaction ;
        ACETHSA.getParameters().put('InteractionId', Interaction.Id);
        ACETHSA.getParameters().put('additionalInfo', TestDataFactory.createACETHighlightsPanelAdditionalInfo());        
        ACETHSA.getParameters().put('contactId', cont.Id);
        ACETHSA.getParameters().put('memberId', '123456789');    
        ACETHSA.getParameters().put('callTopic', 'HSA Account');
        ACETHSA.getParameters().put('SRK', '123456789'); 
        ACETHSA.getParameters().put('unmaskedSSN', '123456789'); 
        Test.setCurrentPage(ACETHSA);
       
        ACETHSAAccountsController hsaAcc= new ACETHSAAccountsController();
        hsaAcc.Subject = cont;
        hsaAcc.callWSOnLoad();
        
        ACETHSASummaryWebservice summaryWS = new ACETHSASummaryWebservice();
        HttpResponse response = new HttpResponse();
        response.setStatusCode(200);
        summaryWS.GetHsaSummary('920002001');
        summaryWS.parseSuccessAdapterResponse(ResponseJSON);
        
        Test.stopTest();
   }
   
   /*static testMethod void hsaSummaryContrMethodErr(){
        //Setup records in custom setting
        Map<String, String> mapISLWSConfigs = new Map<String, String>(); 
        mapISLWSConfigs.put('ISLConAccessToken', 'e9b3f2b1-8863-49ec-9ff8-40da25961ef5');
        mapISLWSConfigs.put('OILHttpHeaderAccept', 'application/json;charset=UTF-8');
        mapISLWSConfigs.put('OILHttpHeaderActor', 'ACET');
        mapISLWSConfigs.put('OILHttpHeaderScope', 'read');
        mapISLWSConfigs.put('ISLOAuthContentType', 'application/x-www-form-urlencoded');
        mapISLWSConfigs.put('ISLOAuthGrantType', 'client_credentials');
        mapISLWSConfigs.put('d1_CISLOAuthClientId', 'ISLStageConClientId');
        mapISLWSConfigs.put('d1_CISLOAuthClientSecret', 'ISLStageConClientSecret');
        mapISLWSConfigs.put('d1_CISLOAuthEndpoint', 'https://api-stg.optum.com:8443');
        mapISLWSConfigs.put('d1_ISLOAuthTokenEndpoint', '/auth/oauth/v2/token');
        mapISLWSConfigs.put('OILTimeout', '8000');
        mapISLWSConfigs.put('d1_HsaSummary','/api/alpha/eisl/member/healthsavings/accounts/v1.0/search');
        
        List<ISL_Webservice_Config__c> lstISLWSConfigs = ACETTestDataUtility.CreateISLWebserviceConfigurations(mapISLWSConfigs);
        insert lstISLWSConfigs;
        
        StaticResource ResponseJSONSR = [SELECT Body FROM StaticResource WHERE Name = 'ACETHsaSummaryResponseErrorJSON'];
        String ResponseJSON = ResponseJSONSR.Body.toString(); 
        system.debug(LoggingLevel.INFO, 'Response JSON: ' + ResponseJSON);
        
        MockHttpCalloutResponseGenerator.MockHttpResponse OILResponse = new MockHttpCalloutResponseGenerator.MockHttpResponse(200, 'OK', ResponseJSON );
        OILResponse.TokenExpired = false;
        
        Test.startTest();
        
        MockHttpCalloutResponseGenerator MockHttpRes = new MockHttpCalloutResponseGenerator(null, OILResponse);
        Test.setMock(HttpCalloutMock.class, MockHttpRes);
        
        PageReference ACETHSA= Page.ACETHSAAccounts;
        Contact cont = TestDataFactory.createContact();
        Interaction__c Interaction = new Interaction__c();
        Interaction.Contact_Name__c = 'Test contname';
        Interaction.Originator__c = cont.id;
        Interaction.Originator_Type__c = 'Member';
        insert Interaction ;
        ACETHSA.getParameters().put('InteractionId', Interaction.Id);
        ACETHSA.getParameters().put('additionalInfo', TestDataFactory.createACETHighlightsPanelAdditionalInfo());        
        ACETHSA.getParameters().put('contactId', cont.Id);
        ACETHSA.getParameters().put('memberId', '123456789');    
        ACETHSA.getParameters().put('callTopic', 'HSA Account');
        ACETHSA.getParameters().put('SRK', '123456789'); 
        ACETHSA.getParameters().put('unmaskedSSN', '123456789'); 
        Test.setCurrentPage(ACETHSA);
       
        ACETHSAAccountsController hsaAcc= new ACETHSAAccountsController();
        hsaAcc.Subject = cont;
        hsaAcc.callWSOnLoad();
        
        ACETHSASummaryWebservice summaryWS = new ACETHSASummaryWebservice();
        HttpResponse response = new HttpResponse();
        response.setStatusCode(404);
        summaryWS.GetHsaSummary('920002001');
        summaryWS.parseSuccessAdapterResponse(ResponseJSON);
        
        Test.stopTest();
   }*/

}