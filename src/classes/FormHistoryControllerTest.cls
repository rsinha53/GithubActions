@istest
public class FormHistoryControllerTest {
	 static testMethod void ACETFormHistoryControllerTest1() {
        Map<String, String> TestISLWSConfigs = new Map<String, String>(); 
        TestISLWSConfigs.put('ISLConAccessToken', 'dfb379c2-06b7-46c4-8c6f-bbc390d1b854');
        TestISLWSConfigs.put('ISLOAuthContentType', 'application/x-www-form-urlencoded');
        TestISLWSConfigs.put('ISLOAuthGrantType', 'client_credentials');
        TestISLWSConfigs.put('OILHttpHeaderAccept', 'application/json;charset=UTF-8');
        TestISLWSConfigs.put('OILHttpHeaderActor', 'ACET');
        TestISLWSConfigs.put('OILHttpHeaderScope', 'read');
        TestISLWSConfigs.put('OILTimeout', '3000');
        TestISLWSConfigs.put('dev_ISLOAuthEndpoint', 'https://api-stg.optum.com:8443');
        TestISLWSConfigs.put('dev_findMedicalProviderAdapterEndpoint', '/api/alpha/eisl/fulfillment/order/v2.0/processFulfillment');
        List<ISL_Webservice_Config__c> lstISLWSConfigs = ACETTestDataUtility.CreateISLWebserviceConfigurations(TestISLWSConfigs);
        insert lstISLWSConfigs;
        
        StaticResource ResponseJSONSR = [SELECT Body FROM StaticResource WHERE Name = 'ACETProcessFulFillmentWebservice'];
        String ResponseJSON = ResponseJSONSR.Body.toString(); 
        system.debug(LoggingLevel.INFO, 'Response JSON: ' + ResponseJSON);
        
        Account oAccount = ACETTestDataUtility.CreateAccount('Test Account', 'TstTaxID1', 'TestEID1');
        insert oAccount;
        Contact oContact = ACETTestDataUtility.CreateContact(oAccount.Id, 'Test Contact LN', 'Test Contact FN', 'TstTaxID1', 'TestEID1', 'TestNPI1');
        insert oContact;
        Interaction__c oInteraction = ACETTestDataUtility.CreateInteraction(oContact.Id, 'Phone', 'Member', oContact.LastName);
        insert oInteraction;
        
        Material_Forms__c matform = new Material_Forms__c();
        matform.Document_Title__c = 'Test';
        matform.Document_URL__c = 'TESTURL';
        matform.Category__c = 'TEST FORMS';
        matform.MRE__c = '10700';
        matform.Business_Unit__c = 'Member';
        Insert matform;
        
        
        ACETHighlightsPanelAdditionalInfo AdditionalInfo = new ACETHighlightsPanelAdditionalInfo();
        AdditionalInfo.PolicyNumber = 'TestPolicyNumber';
        
        MockHttpCalloutResponseGenerator.MockHttpResponse OILTestResponse = new MockHttpCalloutResponseGenerator.MockHttpResponse(200, 'OK', ResponseJSON);
        OILTestResponse.TokenExpired = false;
        
        Test.startTest();
        
        
        
        PageReference pgRef = Page.ACETFormsHistory;
        Test.setCurrentPageReference (pgRef);
        
        ACETFormsHistoryController objCont = new ACETFormsHistoryController();
        
        
        
        objCont.BusinessUnit = 'Member';
        objCont.selectAddress = 'AddressOnFile';
        objCont.recepientId = '69688001800';
        objCont.idQualifier = 'MemberId';
        objCont.recipientType = 'Member';
        objCont.AddOnFilePersonWrap = new ACETFormsHistoryController.personWrapper();
        objCont.AddOnFilePersonWrap.personAddOne = 'Test 123';
        objCont.AddOnFilePersonWrap.personCity = 'HFD';
        objCont.AddOnFilePersonWrap.personState = 'CT';
        objCont.AddOnFilePersonWrap.personZipCode = '06484';
        objCont.AddOnFilePersonWrap.personFirstName = 'Test';
        objCont.AddOnFilePersonWrap.PersonLastName = 'Kelly';
        objCont.getMaterialForms();
        System.debug('test---->'+objCont.vListMaterialsForms);
        
        
        MockHttpCalloutResponseGenerator MockHttpResponse = new MockHttpCalloutResponseGenerator(null, OILTestResponse);
        Test.setMock(HttpCalloutMock.class, MockHttpResponse);
        
        //ApexPages.currentPage().getParameters().put('docId',JSON.serialize(new List<String>{'test123','test1234'}));
       // objCont.showbulkResend();
        objCont.btnSubmit();
        Test.Stoptest();
    
    }
    
}