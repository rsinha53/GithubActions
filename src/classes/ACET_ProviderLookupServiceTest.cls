@isTest
public class ACET_ProviderLookupServiceTest {
    
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
    }

    @isTest static void lookuPServiceTest_1() {
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

        Token_Generation__c token = new Token_Generation__c();
        token.Value__c = 'jdkjahdajdhjadhkajdakjdka';
        token.Token_Name__c = 'StageGate';
        insert token;

        // US2782863 - Thanish - 12th Aug 2020
        test.startTest();
        Test.setMock(HttpCalloutMock.class, new SAEProviderServiceResponseMock(200));
        ACET_ProviderLookupDetailController.contactDetails contactWrapper = new ACET_ProviderLookupDetailController.contactDetails();
        ACET_ProviderLookupDetailController.getProviderData('111111111', '111111111', '111111111', 'P', contactWrapper);
        ACET_ProviderLookupDetailController.getProviderData('111111111', '111111111', '111111111', 'Facility', contactWrapper);
        ACET_ProviderLookupDetailController.getAffiliationData('111111111', '111111111');
        ACET_ProviderLookupController.SearchResultWrapper wrap = ACET_ProviderLookupController.getLookupData('111111111', '111111111', '111111111', 'P', 'ABC', 'TestProvider', 'TestProvider', 'AZ', '54345', '5', 'Y', 'Y', 'Y', 'Y', 'ATL', '123', '1234', 'PC', 'MR', 0, 50, true, 'All', '00222', '76', '01', '01', 'PS1', 'E');
        ACET_ProviderLookupController.CoverageDateWrapper coverageDate = new ACET_ProviderLookupController.CoverageDateWrapper();
        coverageDate.coverageStartDate = '1/1/2021';
        coverageDate.coverageEndDate = '1/1/2021';
        ACET_ProviderLookupController.getProviderLookupResults('111111111', '111111111', '111111111', 'P', 'ABC', 'TestProvider', 'TestProvider', 'AZ', '54345', '5', 'Y', 'Y', 'Y', 'Y', 'Y', '123', '1234', 'PC', 'MR', 0, 50, true, 'All', '00222', '76', '01', '01', 'PS1', 'E',false, 'CO', coverageDate);
        ACET_ProviderLookupService lkpService = new ACET_ProviderLookupService();
        lkpService.init('111111111', '111111111', '111111111', 'P', 'ABC', 'TestProvider', 'TestProvider', 'AZ', '54345', '5', 'Y', 'Y', 'Y', 'Y', 'Y', '123', '1234', 'PC', 'MR', 0, 50, true, 'All', '00222', '76', '01', '01', 'PS1', 'E');

        ACETWSCalloutResult result = lkpService.queryPaginatedData(0, 50, 0);

        // (benefitLevel == 'Tier 1' && memType == 'MR')
        lkpService.init('111111111', '111111111', '111111111', 'P', 'ABC', 'TestProvider', 'TestProvider', 'AZ', '54345', '5', 'Y', 'Y', 'Y', 'Y', 'Y', '123', '1234', 'PC', 'MR', 0, 50, true, 'Tier 1', '00222', '76', '01', '01', 'PS1', 'E');
        lkpService.queryPaginatedData(0, 50, 0);

        // (benefitLevel == 'Tier 1' && memType == 'EI')
        lkpService.init('111111111', '111111111', '111111111', 'P', 'ABC', 'TestProvider', 'TestProvider', 'AZ', '54345', '5', 'Y', 'Y', '', 'Y', 'Y', '123', '1234', 'PC', 'EI', 0, 50, true, 'Tier 1', '00222', '76', '01', '01', 'PS1', 'E');
        lkpService.queryPaginatedData(0, 50, 0);

        // (benefitLevel == 'INN' && memType == 'MR')
        lkpService.init('111111111', '111111111', '111111111', 'P', 'ABC', 'TestProvider', 'TestProvider', 'AZ', '54345', '5', 'Y', 'Y', 'Y', 'Y', 'Y', '123', '1234', 'PC', 'MR', 0, 50, true, 'INN', '00222', '76', '01', '01', 'PS1', 'E');
        lkpService.queryPaginatedData(0, 50, 0);

        // (benefitLevel == 'INN' && memType == 'EI')
        lkpService.init('111111111', '111111111', '111111111', 'P', 'ABC', 'TestProvider', 'TestProvider', 'AZ', '54345', '5', 'Y', 'Y', 'Y', 'Y', 'Y', '123', '1234', 'PC', 'EI', 0, 50, true, 'INN', '00222', '76', '01', '01', 'PS1', 'E');
        lkpService.queryPaginatedData(0, 50, 0);

        // (benefitLevel == 'INN' && memType == 'CS')
        lkpService.init('111111111', '111111111', '111111111', 'P', 'ABC', 'TestProvider', 'TestProvider', 'AZ', '54345', '5', 'Y', 'Y', 'Y', 'Y', 'Y', '123', '1234', 'PC', 'CS', 0, 50, true, 'INN', '00222', '76', '01', '01', 'PS1', 'E');
        lkpService.queryPaginatedData(0, 50, 0);

        lkpService.GetEndpoint();

        test.stopTest();
    }

    @isTest static void lookuPServiceTest_1_Fail() {
        test.startTest();
        ACET_ProviderLookupService lkpService = new ACET_ProviderLookupService();
        lkpService.init('111111111', '111111111', '111111111', 'P', 'ABC', 'TestProvider', 'TestProvider', 'AZ', '54345', '5', 'Y', 'Y', 'Y', 'Y', 'Y', '123', '1234', 'PC', 'EI', 0, 50, true, 'All', '00222', '76', '01', '01', 'PS1', 'E');

        ACETWSCalloutResult result = lkpService.queryPaginatedData(0, 50, 0);
        test.stopTest();
    }

    @isTest static void lookuPServiceTest_Fail_400() {
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

        Token_Generation__c token = new Token_Generation__c();
        token.Value__c = 'jdkjahdajdhjadhkajdakjdka';
        token.Token_Name__c = 'StageGate';
        insert token;

        test.startTest();
        Test.setMock(HttpCalloutMock.class, new SAEProviderServiceResponseMock(400));
        ACET_ProviderLookupService lkpService = new ACET_ProviderLookupService();
        lkpService.init('111111111', '111111111', '111111111', 'P', 'ABC', 'TestProvider', 'TestProvider', 'AZ', '54345', '5', 'Y', 'Y', 'Y', 'Y', 'Y', '123', '1234', 'PC', 'CS', 0, 50, true, 'All', '00222', '76', '01', '01', 'PS1', 'E');

        ACETWSCalloutResult result = lkpService.queryPaginatedData(0, 50, 0);
        test.stopTest();
    }
  
    // US2782863 - Thanish - 12th Aug 2020
    @isTest static void testGetSAEProductCodes() {
        test.startTest();
        SAEProviderSearchResultsWrapper.getSAEProductCodes();
        test.stopTest();
    }

}