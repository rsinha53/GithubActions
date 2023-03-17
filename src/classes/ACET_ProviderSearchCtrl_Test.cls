@isTest
global class ACET_ProviderSearchCtrl_Test {
    
    @testSetup static void testSetupMethod() {
        Organization_Properties__c orgProps = Organization_Properties__c.getOrgDefaults();
        orgProps.OrganizationName__c = 'QA';
        Upsert orgProps;
		
		// Token API data
        WebserviceConfigurations__c tokenAPIWSConfig = ACET_WebserviceCalloutFramework_Test.createTokenWSConfigs('StarGateTokenAPI');
        OrgSpecificConfigurations__c tokenAPIOrgSpecificConfigs = ACET_WebserviceCalloutFramework_Test.createTokenOrgWSConfigs(tokenAPIWSConfig.Id);

        // Service API data
        WebserviceConfigurations__c wsConfig = ACET_WebserviceCalloutFramework_Test.createWSConfig('FastProviderSearch', tokenAPIWSConfig.Id);
        OrgSpecificConfigurations__c orgSpecificConfigs = ACET_WebserviceCalloutFramework_Test.createOrgWSConfigs(wsConfig.Id);
        
        //ISL Webservice custom setting insert
        ISL_Webservice_Config__c endpointSetting = new ISL_Webservice_Config__c();
        endpointSetting.Name = 'dev_PESProviderSearch';
        endpointSetting.Is_Available__c = true;
        endpointSetting.Value__c = 'https://api-gateway-stage.linkhealth.com/elink-services/api/eligibility/v2.0';
        Insert endpointSetting;
        
		ISL_Webservice_Config__c apiEndpointSetting = new ISL_Webservice_Config__c();
        apiEndpointSetting.Name = 'SNIAPIAccessToken';
        apiEndpointSetting.Is_Available__c = true;
        apiEndpointSetting.Value__c = 'zwdsk9VPXJASohgqS2zqXD0UxD9MEa5g';
        Insert apiEndpointSetting;
    }

    @isTest static void getProviderSearchResults_Test1() {
        Test.setMock(HttpCalloutMock.class, new WebserviceCalloutFrameworkMock(200));
        Test.startTest();
        ACET_ProviderSearchCtrl.ProviderDetails providerDetails = new ACET_ProviderSearchCtrl.ProviderDetails();
        providerDetails.isAdvancedSearch = true;
        providerDetails.practicingStatus = 'Active';
        providerDetails.taxId = '123456789';
        providerDetails.npi = '1234567891';
        providerDetails.firstName = 'pfn';
        providerDetails.lastName = 'pln ';
        providerDetails.filterType = 'Physician';
        providerDetails.state = 'TX';
        providerDetails.zip = 'NY';
        providerDetails.state = '100001';
        ACET_ProviderSearchCtrl.getProviderSearchResults(providerDetails);
        Test.stopTest();
    }

    @isTest static void getProviderSearchResults_Test2() {
        Test.setMock(HttpCalloutMock.class, new WebserviceCalloutFrameworkMock(200));
        Test.startTest();
        ACET_ProviderSearchCtrl.ProviderDetails providerDetails = new ACET_ProviderSearchCtrl.ProviderDetails();
        providerDetails.isAdvancedSearch = true;
        providerDetails.isValidProvider = true;
        providerDetails.isProviderNotFound = true;
        providerDetails.isNoProviderToSearch = true;
        providerDetails.isOther = true;
        providerDetails.isPysician = true;
        providerDetails.practicingStatus = 'Active';
        providerDetails.taxId = '';
        providerDetails.npi = '1234567891';
        providerDetails.firstName = 'pfn';
        providerDetails.lastName = 'pln ';
        providerDetails.filterType = 'Facility';
        providerDetails.state = 'TX';
        providerDetails.zip = 'NY';
        providerDetails.state = '100001';
        providerDetails.interactionType = 'Email';
        providerDetails.providerUniqueId = '12345';
        providerDetails.providerId = '12345';
        providerDetails.phoneNumber = '1234567890';
        providerDetails.contactType = '';
        providerDetails.corpMPIN = '';
        providerDetails.isNiceProvider = false;
        providerDetails.tpsmIndicator = '';
        providerDetails.addressLine1 = '';
        providerDetails.addressLine2 = '';
        providerDetails.degreeCode = '';
        providerDetails.EffectivePhoneNumber = '';
        providerDetails.AddressCity = '';
        ACET_ProviderSearchCtrl.getProviderSearchResults(providerDetails);
        Test.stopTest();
    }

    @isTest static void getProviderSearchResults_Test_ErrorStatus() {
        Test.setMock(HttpCalloutMock.class, new WebserviceCalloutFrameworkMock(401));
        Test.startTest();
        ACET_ProviderSearchCtrl.ProviderDetails providerDetails = new ACET_ProviderSearchCtrl.ProviderDetails();
        providerDetails.isAdvancedSearch = true;
        providerDetails.practicingStatus = 'Active';
        providerDetails.taxId = '';
        providerDetails.npi = '1234567891';
        providerDetails.firstName = 'pfn';
        providerDetails.lastName = 'pln ';
        providerDetails.filterType = 'Facility';
        providerDetails.state = 'TX';
        providerDetails.zip = 'NY';
        providerDetails.state = '100001';
        ACET_ProviderSearchCtrl.getProviderSearchResults(providerDetails);
        Test.stopTest();
    }
    // US3368954:TECH Story: Tech debt Reduction and Improvements
    @isTest static void getAuthTokenTest() {
        Test.startTest();
        String authToken = ACET_ProviderSearchCtrl.getAuthToken();
        Test.stopTest();
    }

    global class WebserviceCalloutFrameworkMock implements HttpCalloutMock {
        public Integer statusCode;
        
        public WebserviceCalloutFrameworkMock(Integer statusCode) {
            this.statusCode = statusCode;
        }
        global HTTPResponse respond(HTTPRequest request) {
            HttpResponse response = new HttpResponse();
            response.setHeader('Content-Type', 'application/json');
            response.setBody('{"att1": "1"}');
            response.setStatusCode(statusCode);
            response.setStatus('status');
            return response; 
        }
    }

}