@isTest(SeeAllData=false)
private class ACETProviderFeeScheduleControllerTest {
  static testMethod void  findAgreementsHCOTest() {
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
        
       /* Account oAccount = ACETTestDataUtility.CreateAccount('Test Account', 'TstTaxID1', 'TestEID1');
        insert oAccount;
        Contact oContact = ACETTestDataUtility.CreateContact(oAccount.Id, 'Test Contact LN', 'Test Contact FN', 'TstTaxID1', 'TestEID1', 'TestNPI1');
        insert oContact;*/
      
			 RecordType newRecord = [SELECT Id FROM RecordType WHERE Name = 'Person Account' and SObjectType = 'Account'];
        
        Account accountTest = new Account();
        accountTest.FirstName = 'Test Contact FN1';
        accountTest.LastName = 'Test Contact LN1';
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
        AdditionalInfo.DOB = '12/27/2009';
        AdditionalInfo.SitusState = '12/27/2009';
        AdditionalInfo.EffectiveDate = '12/27/2009';
        AdditionalInfo.EndDate = '12/27/2009';
        AdditionalInfo.groupName  = 'Test';
        AdditionalInfo.Network    = 'Test';
        AdditionalInfo.OriginatorRelationship  = 'Test';
        AdditionalInfo.PolicyNumber  = 'UHC1234';
        AdditionalInfo.Product  = 'Product Test';
        AdditionalInfo.productType  = 'Care Service';
        AdditionalInfo.Relationship  = 'Primary'; 
        MockHttpCalloutResponseGenerator.MockHttpResponse OILTestResponse = new MockHttpCalloutResponseGenerator.MockHttpResponse(200, 'OK', GetAgrmntResponseJSON);
        OILTestResponse.TokenExpired = false;
        
        Test.startTest();
        
        MockHttpCalloutResponseGenerator MockHttpResponse = new MockHttpCalloutResponseGenerator(null, OILTestResponse);
        Test.setMock(HttpCalloutMock.class, MockHttpResponse);
        
        PageReference ACETPD = Page.ACETProviderFeeSchedule;
        ACETPD.getParameters().put('interactionId', oInteraction.Id);
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
        
        ACETProviderFeeScheduleController ACETPDCtrl = new ACETProviderFeeScheduleController();
        ACETPDCtrl.CallFindAgreements();
        ACETPDCtrl.rowEntry = '1';
        ACETPDCtrl.showvalue = false;
        ACETPDCtrl.AdditionalInfo = AdditionalInfo;
        system.assertNotEquals(null, ACETPDCtrl.AgrmntsDTWrapper);
        
        ACETFindAgreementsWebservice ACETFPLWS = (ACETFindAgreementsWebservice)JSON.deserialize(ACETPDCtrl.AgrmntsDTWrapper.Service.replace('&#x27;', '\''), ACETFindAgreementsWebservice.class);
        ACETFPLWS.queryPaginatedData(0, 5, 0);
        Test.stopTest();
    }
    static testMethod void  findAgreementsHCPTest() {
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
        
      /*  Account oAccount = ACETTestDataUtility.CreateAccount('Test Account', 'TstTaxID1', 'TestEID1');
        insert oAccount;
        Contact oContact = ACETTestDataUtility.CreateContact(oAccount.Id, 'Test Contact LN', 'Test Contact FN', 'TstTaxID1', 'TestEID1', 'TestNPI1');
        insert oContact;*/
        
			 RecordType newRecord = [SELECT Id FROM RecordType WHERE Name = 'Person Account' and SObjectType = 'Account'];
        
        Account accountTest = new Account();
        accountTest.FirstName = 'Test Contact FN1';
        accountTest.LastName = 'Test Contact LN1';
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
        
        MockHttpCalloutResponseGenerator.MockHttpResponse OILTestResponse = new MockHttpCalloutResponseGenerator.MockHttpResponse(200, 'OK', GetAgrmntResponseJSON);
        OILTestResponse.TokenExpired = false;
        
        Test.startTest();
        
        MockHttpCalloutResponseGenerator MockHttpResponse = new MockHttpCalloutResponseGenerator(null, OILTestResponse);
        Test.setMock(HttpCalloutMock.class, MockHttpResponse);
        
        PageReference ACETPD = Page.ACETProviderFeeSchedule;
        ACETPD.getParameters().put('interactionId', oInteraction.Id);
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
        
        ACETProviderFeeScheduleController ACETPDCtrl = new ACETProviderFeeScheduleController();
        ACETPDCtrl.CallFindAgreements();
        system.assertNotEquals(null, ACETPDCtrl.AgrmntsDTWrapper);
        
        ACETFindAgreementsWebservice ACETFPLWS = (ACETFindAgreementsWebservice)JSON.deserialize(ACETPDCtrl.AgrmntsDTWrapper.Service.replace('&#x27;', '\''), ACETFindAgreementsWebservice.class);
        ACETFPLWS.queryPaginatedData(0, 5, 0);
        Test.stopTest();
    }
       
}