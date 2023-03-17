// Author - Sanka
// Edited by - Thanish
// Last Updated - 4th Oct 2019
// Tested Classes - SAE_ProviderCardCtrl, SAEProviderSearch, SAE_ProviderSnapshotController

@isTest
public class SAEProviderSearchTest {
    
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
    
	@isTest
    static void saeUtilsTest(){
 
        Interaction__c interact = new Interaction__c();
        interact.Originator_Type__c = 'Member';
        interact.tax_Id__c = '234234223';
        interact.Interaction_Type__c = 'Incoming call';
        insert interact;
        
        Account acc = new Account();
        acc.Name = 'utils Test';
        insert acc;
        
        Third_party__c tp = new Third_party__c();
        tp.First_Name__c = 'tp First';
        tp.LastName__c = 'tp Last';
        tp.FullName__c = tp.First_Name__c + ' ' + tp.LastName__c;
        insert tp;
        
        string dateStr = '12/12/2019';
        string dateStr1 = '12-12-2019';
        SAEUtils.formatDate(dateStr);
        SAEUtils.formatDateFutureDate(dateStr1);
        SAEUtils.formatDateRequest(dateStr1);
        SAEUtils.getAgeFromBirthDate(dateStr1);
        SAEUtils.getAgeFromBirthday(dateStr1);
        SAEUtils.queryInteraction(interact.Id);
        SAEUtils.createInteraction('Incoming Call',acc,'mnf',tp,'Member');
        //SAEUtils.createAccountContact('firstName','Middle Name','last Name', '1234-567890', '4353453453', '343453453', 'Incoming Call','','Provider',false, false, true,'mnf',false,'member first Name','member last name','test');
        ACET_ExplorePageCtrl.FlowDetails fd = new ACET_ExplorePageCtrl.FlowDetails();//US2903847
        fd.contactExt = '123';
        fd.contactName = 'cfn cln';
        fd.contactNumber = '1234567890';
        fd.interactionType = 'Email';
        fd.isGenesys = false;
        fd.IVRInfo = null;
        fd.GeneysysQuestionType = '';
         SAEUtils.createAccountContact('Durga', 'Lova', 'Kommana', '1234567890','1234567890', '15432123','', '', '', false, false, false, 'mnf', false,'test', 'tes1','',false,'',fd);
        SAEUtils.createInteraction(interact.id,'Incoming Call','','provier','Member','234234234', true,false,'',fd);
        
    }
	
	@isTest static void searchMember() 
    {
        ISL_Webservice_Config__c webConfig = new ISL_Webservice_Config__c();
        webConfig.Name = 'SAE_ProviderSearch';
        webConfig.Value__c = 'https://api-gateway-stage.linkhealth.com/elink-services/api/eligibility';
        insert webConfig;

        ISL_Webservice_Config__c webConfig_token = new ISL_Webservice_Config__c();
        webConfig_token.Name = 'ISLOAuthContentType';
        webConfig_token.Value__c = 'bearer';
        insert webConfig_token;

        Token_Generation__c tokenGen = new Token_Generation__c();
        tokenGen.Token_Name__c = 'ISLConAccessToken';
        tokenGen.Value__c = '1234567890hagjhadgsayytqyetxhzcxhgsdadaudyia';
        insert tokenGen;

        Test.startTest();
            Test.setMock(HttpCalloutMock.class, new SAEProviderSearchResponseMock(200));
            SAEProviderSearch.SearchResultWrapper returnWrapper = SAEProviderSearch.findMembers('956876492', '6/8/1977','AMANDA', 'KELLER', '','', '87726','','','','');
            System.assertEquals(200, returnWrapper.statusCode);

            String queryString = SAEProviderSearch.formQueryString(new List<String>{'op','fname','lname','','','','','','',''});
            SAEProviderSearch.createAccountContact('firstName', 'middleName', 'lastName', '6/8/1977', '956876492');

            String memberResponse = SAEProviderSearch.getMemberResponse();
            String requestFormat = SAEProviderSearch.GetRequestFormatByName('SampleResource');
            String requestBody = SAEProviderSearch.GetRequestBody('SampleResource', new List<String>{'1','2'});
            List<State__mdt> states = SAE_cmdStateValues.getStateValues();
        Test.stopTest();
    }

    @isTest static void searchMember_ResponseData()
    {
        StaticResource sampleResponse =[SELECT Body FROM StaticResource WHERE Name = 'SAEEligibilityResponseMock_Vinay'];
        SAEEligibilityResponseJSON2Apex json2Apex = SAEEligibilityResponseJSON2Apex.parse(sampleResponse.Body.toString());
        List<SAEEligibilityResponseJSON2Apex.MemberPolicies> memberpolicies = new List<SAEEligibilityResponseJSON2Apex.MemberPolicies>();

       // List<SAEProviderSearch.wrapperResponse> wrapperResponse = SAEProviderSearch.returnResponseData(json2Apex.memberPolicies.get(0));
    }

    @isTest static void searchMember_500() 
    {
        ISL_Webservice_Config__c webConfig = new ISL_Webservice_Config__c();
        webConfig.Name = 'SAE_ProviderSearch';
        webConfig.Value__c = 'https://api-gateway-stage.linkhealth.com/elink-services/api/eligibility';
        insert webConfig;

        Test.startTest();
            Test.setMock(HttpCalloutMock.class, new SAEProviderSearchResponseMock(500));
            SAEProviderSearch.SearchResultWrapper returnWrapper = SAEProviderSearch.findMembers('956876492', '6/8/1977','AMANDA', 'KELLER', '','', '87726','','','','');
            System.assertEquals(500, returnWrapper.statusCode);
        Test.stopTest();
    }

    @isTest static void searchMember_400() 
    {
        ISL_Webservice_Config__c webConfig = new ISL_Webservice_Config__c();
        webConfig.Name = 'SAE_ProviderSearch';
        webConfig.Value__c = 'https://api-gateway-stage.linkhealth.com/elink-services/api/eligibility';
        insert webConfig;

        Test.startTest();
            Test.setMock(HttpCalloutMock.class, new SAEProviderSearchResponseMock(400));
            SAEProviderSearch.SearchResultWrapper returnWrapper = SAEProviderSearch.findMembers('85969010', '5/11/1962','AMANDA', 'KELLER', '','', '87726','','','','');
            System.assertEquals(400, returnWrapper.statusCode);
        Test.stopTest();
    }

    @isTest static void searchMember_404() 
    {
        ISL_Webservice_Config__c webConfig = new ISL_Webservice_Config__c();
        webConfig.Name = 'SAE_ProviderSearch';
        webConfig.Value__c = 'https://api-gateway-stage.linkhealth.com/elink-services/api/eligibility';
        insert webConfig;

        Test.startTest();
            Test.setMock(HttpCalloutMock.class, new SAEProviderSearchResponseMock(404));
            SAEProviderSearch.SearchResultWrapper returnWrapper = SAEProviderSearch.findMembers('85969010', '5/11/1962','AMANDA', 'KELLER', '','', '87726','','','','');
            System.assertEquals(404, returnWrapper.statusCode);
        Test.stopTest();
    }

    @isTest static void searchMember_Other() 
    {
        ISL_Webservice_Config__c webConfig = new ISL_Webservice_Config__c();
        webConfig.Name = 'SAE_ProviderSearch';
        webConfig.Value__c = 'https://api-gateway-stage.linkhealth.com/elink-services/api/eligibility';
        insert webConfig;

        Test.startTest();
            Test.setMock(HttpCalloutMock.class, new SAEProviderSearchResponseMock(999));
            SAEProviderSearch.SearchResultWrapper returnWrapper = SAEProviderSearch.findMembers('85969010', '5/11/1962','AMANDA', 'KELLER', '','', '87726','','','','');
            System.assertEquals(999, returnWrapper.statusCode);
        Test.stopTest();
    }

    @isTest static void SAE_ProviderSnapshotController_Test()
    {
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

        System.assert(token.Value__c != '');

        Test.startTest();
            Test.setMock(HttpCalloutMock.class, new SAEProviderServiceResponseMock('O'));
            SAE_ProviderSnapshotController.getProviderData('111111111', '111111', 'US-INDIA');
            SAE_ProviderSnapshotController.getAddresses('111111111', '061330992', 1, 50);
			SAE_ProviderSnapshotController.getAddressData('111111111', '061330992', 1, 50,true,true);
			ACET_AdditionalAddressService.getAdditionalAddressesService('111111111', '061330992', 1, 50, true, true);
			ACET_AdditionalAddressService.getAdditionalAddressesService('111111111', '061330992', 1, 50, false, false);
			ACET_AdditionalAddressService.getAdditionalAddressesService('111111111', '061330992', 1, 50, true, false);
			ACET_AdditionalAddressService.getAdditionalAddressesService('111111111', '061330992', 1, 50, false, true);
            SAE_AdditionalAddressService addaddress = new SAE_AdditionalAddressService();
            addaddress.filtered = true;
        	addaddress.onlyActive = true;
            ACETWSCalloutResult oACETWSCalloutResult = addaddress.queryPaginatedData(10, 50, 1);
            //Negative
            SAE_AdditionalAddressService addaddress2 = new SAE_AdditionalAddressService();
            addaddress2.filtered = false;
        	addaddress2.onlyActive = false;
            ACETWSCalloutResult oACETWSCalloutResult2 = addaddress2.queryPaginatedData(10, 50, 1);

            SAE_ProviderResponse.PostalAddress postalAddr = new SAE_ProviderResponse.PostalAddress();
            postalAddr.addressLine1 = '';
            postalAddr.addressLine2 = '';
            postalAddr.city = '';
            postalAddr.county = '';
            postalAddr.state = '';
            postalAddr.zip = '';
            postalAddr.zip4 = '';
            SAE_ProviderResponse.Address addr = new SAE_ProviderResponse.Address();
            addr.postalAddress = postalAddr;
        addaddress.GetEndpoint();
            SAE_ProviderSnapshotController.createAddress(addr, true);
        // Thanish - 7th Feb 2020
        Test.setMock(HttpCalloutMock.class, new SAEProviderServiceResponseMock('P'));
        SAE_ProviderSnapshotController.getProviderData('111111111', '111111', 'US-INDIA');

        //Sanka - Code Coverage - 17/06/2020
        Test.setMock(HttpCalloutMock.class, new SAEProviderServiceResponseMock(400));
		ACET_AdditionalAddressService.getAdditionalAddressesService('111111111', '061330992', 1, 50, true, true);
        SAE_AdditionalAddressService addaddress3 = new SAE_AdditionalAddressService();
        addaddress3.filtered = false;
        addaddress3.onlyActive = false;
        ACETWSCalloutResult oACETWSCalloutResult3 = addaddress3.queryPaginatedData(10, 50, 1);
        SAE_ProviderSnapshotController.getProviderData('111111111', '111111', 'US-INDIA');

        Test.setMock(HttpCalloutMock.class, new SAEProviderServiceResponseMock(404));
		ACET_AdditionalAddressService.getAdditionalAddressesService('111111111', '061330992', 1, 50, true, true);
        SAE_AdditionalAddressService addaddress4 = new SAE_AdditionalAddressService();
        addaddress4.filtered = false;
        addaddress4.onlyActive = false;
        ACETWSCalloutResult oACETWSCalloutResult4 = addaddress4.queryPaginatedData(10, 50, 1);
        SAE_ProviderSnapshotController.getProviderData('111111111', '111111', 'US-INDIA');

        Test.setMock(HttpCalloutMock.class, new SAEProviderServiceResponseMock(500));
		ACET_AdditionalAddressService.getAdditionalAddressesService('111111111', '061330992', 1, 50, true, true);
        SAE_AdditionalAddressService addaddress500 = new SAE_AdditionalAddressService();
        addaddress500.filtered = false;
        addaddress500.onlyActive = false;
        ACETWSCalloutResult oACETWSCalloutResult500 = addaddress500.queryPaginatedData(10, 50, 1);
        SAE_ProviderSnapshotController.getProviderData('111111111', '111111', 'US-INDIA');

        Test.setMock(HttpCalloutMock.class, new SAEProviderServiceResponseMock(100));
		ACET_AdditionalAddressService.getAdditionalAddressesService('111111111', '061330992', 1, 50, true, true);
        SAE_AdditionalAddressService addaddress100 = new SAE_AdditionalAddressService();
        addaddress100.filtered = false;
        addaddress100.onlyActive = false;
        ACETWSCalloutResult oACETWSCalloutResult100 = addaddress100.queryPaginatedData(10, 50, 1);
        //SAE_ProviderSnapshotController.getProviderData('111111111', '111111', 'US-INDIA');

        Test.setMock(HttpCalloutMock.class, new SAEProviderServiceResponseMock(505));
		//ACET_AdditionalAddressService.getAdditionalAddressesService('111111111', '061330992', 1, 50, true, true);
        SAE_AdditionalAddressService addaddress505 = new SAE_AdditionalAddressService();
        addaddress505.filtered = false;
        addaddress505.onlyActive = false;
        //ACETWSCalloutResult oACETWSCalloutResult505 = addaddress505.queryPaginatedData(10, 50, 1);
        //SAE_ProviderSnapshotController.getProviderData('111111111', '111111', 'US-INDIA');

        SAE_ProviderSnapshotController.CaseWrapper cwrap = new SAE_ProviderSnapshotController.CaseWrapper();
		cwrap.OriginatorType  = 'test';
        cwrap.CreatedDate = 'test';
        cwrap.ID = 'test';
        cwrap.IDType = 'test';
        cwrap.CaseNumber = 'test';
        cwrap.TopicReason = 'test';
        cwrap.Status = 'test';
        cwrap.recordID = 'test';

        //List<ACETGetCases.CaseWrapper> cases = SAE_ProviderSnapshotController.getRelatedCasesHistory('111111111', 'sashjahsjashajs', true, 'Member');

        Test.stopTest();
    }

    @isTest static void SAE_AdditionalAddress_Fail()
    {
        test.startTest();
        Test.setMock(HttpCalloutMock.class, new SAEProviderServiceResponseMock(400));
		ACET_AdditionalAddressService.getAdditionalAddressesService('111111111', '061330992', 0, 50, true, true);
        SAE_AdditionalAddressService addaddress = new SAE_AdditionalAddressService();
        ACETWSCalloutResult oACETWSCalloutResult = addaddress.queryPaginatedData(0, 50, -1);
        test.stopTest();
    }

    @isTest static void SAE_AdditionalAddress_Fail_2()
    {
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

        System.assert(token.Value__c != '');

        test.startTest();
        Test.setMock(HttpCalloutMock.class, new SAEProviderServiceResponseMock(400));
		ACET_AdditionalAddressService.getAdditionalAddressesService('111111111', '061330992', 1, 50, true, true);
        SAE_AdditionalAddressService addaddress = new SAE_AdditionalAddressService();
        ACETWSCalloutResult oACETWSCalloutResult = addaddress.queryPaginatedData(10, 50, 1);
        test.stopTest();
    }

    @isTest static void SAE_AffiliationService_Test()
    {
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

        System.assert(token.Value__c != '');

        test.startTest();
        Test.setMock(HttpCalloutMock.class, new SAEProviderServiceResponseMock(200));
        SAE_ProviderAffiliationService affliation = new SAE_ProviderAffiliationService();
        ACETWSCalloutResult oACETWSCalloutResult = affliation.queryPaginatedData(10, 50, 1);
        test.stopTest();
    }

    @isTest static void SAE_AffiliationService_Test_2()
    {
        //ISL Webservice custom setting insert
        ISL_Webservice_Config__c endpointSetting = new ISL_Webservice_Config__c();
        endpointSetting.Name = 'SAE_ProviderAffiliation';
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

        System.assert(token.Value__c != '');

        test.startTest();
        Test.setMock(HttpCalloutMock.class, new SAEProviderServiceResponseMock(200));
        SAE_ProviderAffiliationService affliation = new SAE_ProviderAffiliationService();
        ACETWSCalloutResult oACETWSCalloutResult = affliation.queryPaginatedData(10, 50, 1);
        test.stopTest();
    }

    @isTest static void SAE_AffiliationService_Test_3()
    {
        //ISL Webservice custom setting insert
        ISL_Webservice_Config__c endpointSetting = new ISL_Webservice_Config__c();
        endpointSetting.Name = 'SAE_ProviderAffiliation';
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

        System.assert(token.Value__c != '');

        test.startTest();
        Test.setMock(HttpCalloutMock.class, new SAEProviderServiceResponseMock(400));
        SAE_ProviderAffiliationService affliation = new SAE_ProviderAffiliationService();
        affliation.init('123','456', 0, 50);
        affliation.GetEndpoint();
        ACETWSCalloutResult oACETWSCalloutResult = affliation.queryPaginatedData(10, 50, 1);
        test.stopTest();
    }

    @isTest static void SAE_AffiliationService_Test_404()
    {
        //ISL Webservice custom setting insert
        ISL_Webservice_Config__c endpointSetting = new ISL_Webservice_Config__c();
        endpointSetting.Name = 'SAE_ProviderAffiliation';
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

        System.assert(token.Value__c != '');

        test.startTest();
        Test.setMock(HttpCalloutMock.class, new SAEProviderServiceResponseMock(404));
        SAE_ProviderAffiliationService affliation = new SAE_ProviderAffiliationService();
        ACETWSCalloutResult oACETWSCalloutResult = affliation.queryPaginatedData(10, 50, 1);
        test.stopTest();
    }

    @isTest static void SAE_AffiliationService_Test_500()
    {
        //ISL Webservice custom setting insert
        ISL_Webservice_Config__c endpointSetting = new ISL_Webservice_Config__c();
        endpointSetting.Name = 'SAE_ProviderAffiliation';
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

        System.assert(token.Value__c != '');

        test.startTest();
        Test.setMock(HttpCalloutMock.class, new SAEProviderServiceResponseMock(500));
        SAE_ProviderAffiliationService affliation = new SAE_ProviderAffiliationService();
        ACETWSCalloutResult oACETWSCalloutResult = affliation.queryPaginatedData(10, 50, 1);
        test.stopTest();
    }

    @isTest static void SAE_AffiliationService_Test_100()
    {
        //ISL Webservice custom setting insert
        ISL_Webservice_Config__c endpointSetting = new ISL_Webservice_Config__c();
        endpointSetting.Name = 'SAE_ProviderAffiliation';
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

        System.assert(token.Value__c != '');

        test.startTest();
        Test.setMock(HttpCalloutMock.class, new SAEProviderServiceResponseMock(100));
        SAE_ProviderAffiliationService affliation = new SAE_ProviderAffiliationService();
        ACETWSCalloutResult oACETWSCalloutResult = affliation.queryPaginatedData(10, 50, 1);
        test.stopTest();
    }

    @isTest static void SAE_AffiliationService_Test_505()
    {
        //ISL Webservice custom setting insert
        ISL_Webservice_Config__c endpointSetting = new ISL_Webservice_Config__c();
        endpointSetting.Name = 'SAE_ProviderAffiliation';
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

        System.assert(token.Value__c != '');

        test.startTest();
        Test.setMock(HttpCalloutMock.class, new SAEProviderServiceResponseMock(505));
        SAE_ProviderAffiliationService affliation = new SAE_ProviderAffiliationService();
        ACETWSCalloutResult oACETWSCalloutResult = affliation.queryPaginatedData(10, 50, 1);
        test.stopTest();
    }

    @isTest static void SAE_ProviderSnapshotController_Test_Physician()
    {
        //ISL Webservice custom setting insert
        ISL_Webservice_Config__c endpointSetting = new ISL_Webservice_Config__c();
        endpointSetting.Name = 'dev_PESProviderSearch';
        endpointSetting.Is_Available__c = true;
        endpointSetting.Value__c = 'https://api-gateway-stage.linkhealth.com/elink-services/api/eligibility/v2.0';
        Insert endpointSetting;
            
        Token_Generation__c token = new Token_Generation__c();
        token.Value__c = 'jdkjahdajdhjadhkajdakjdka';
        token.Token_Name__c = 'StageGate';
        insert token;

        System.assert(token.Value__c != '');

        Test.startTest();
            Test.setMock(HttpCalloutMock.class, new SAEProviderServiceResponseMock('P'));
            SAE_ProviderSnapshotController.getProviderData('111111111', '111111', '0000007');

            SAE_ProviderSnapshotWrapper.ActiveAffWrapper activeAff = new SAE_ProviderSnapshotWrapper.ActiveAffWrapper();
            activeAff.ProviderId = '';
            activeAff.Name = 'Name';
            activeAff.EffectiveDate = '12/12/1212';

            SAE_ProviderSnapshotWrapper.ProviderCardWrapper sp = new SAE_ProviderSnapshotWrapper.ProviderCardWrapper();
            sp.PremiumDesignation = 'Designation';
            sp.EffectiveDate = '12/12/1212';
            sp.CancelDate = '12/12/1212';

        Test.stopTest();
    }

	// Thanish
	@isTest
    static void testGetStateValues() {
        List<State__mdt> stateList = [SELECT Id, DeveloperName, MasterLabel FROM State__mdt ORDER BY DeveloperName asc];
        
        System.assertEquals(stateList, SAE_ProviderCardCtrl.getStateValues());
    }
    
    @isTest 
    static void testGetProviderSearchResponse() {
        SAE_ProviderCardCtrl.ProviderDetails pDetails = new SAE_ProviderCardCtrl.ProviderDetails();
        pDetails.taxIdOrNPI = '123456789'; pDetails.contactName = 'Thanish'; pDetails.filterType = 'Physician';
        pDetails.firstName = 'Bruce'; pDetails.lastName = 'Wayne'; pDetails.zip = '1234';
        pDetails.phone = '0754448186'; pDetails.state = 'CA'; pDetails.searchOption = '';
        pDetails.practicingStatus = 'Active'; pDetails.IsSnapshot = false; pDetails.SnapshotParameters = '';
        
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
        
        Test.startTest();
        
        Test.setMock(HttpCalloutMock.class, new SAEProviderServiceResponseMock('P'));
        System.assertNotEquals(null, SAE_ProviderCardCtrl.getProviderSearchResponse(pDetails, true) );
        
        pDetails.filterType = 'Facility'; pDetails.taxIdOrNPI = '1234567890';
        System.assertNotEquals(null, SAE_ProviderCardCtrl.getProviderSearchResponse(pDetails, true) );
        
        Test.stopTest();
    }
    
    // Thanish - Oct 8th 2019
    @isTest 
    static void testSearchMembers() {
        String memDetail = '{ "memberId" : "", "memberDOB" : "", "firstName" : "Bruce", "lastName" : "Wayne", "groupNumber" : "1212121", "searchOption" : "", "payerID" : "121212", "providerLastName" : "", "providerFirstName" : "", "npi" : "", "providerFlow" : "" }';
        System.assertNotEquals(null, SAEProviderSearch.searchMembers(memDetail));
    }
    
    @isTest 
    static void testGetEndpoint() { 
    	SAEProviderSearch ps = new SAEProviderSearch();
        ps.getEndpoint();
    }
    
    @isTest 
    static void testReturnResponseData() { 
        SAEEligibilityResponseJSON2Apex.MemberPolicies pat = new SAEEligibilityResponseJSON2Apex.MemberPolicies();
        
        SAEEligibilityResponseJSON2Apex.PatientInfo patInfo = new SAEEligibilityResponseJSON2Apex.PatientInfo();
        patInfo.firstName = 'Bruce'; patInfo.middleName = 'Thomas'; patInfo.lastName = 'Wayne';
        patInfo.dateOfBirth = '12/12/2020'; patInfo.relationship = 'Son';
        List<SAEEligibilityResponseJSON2Apex.PatientInfo> patInfoList = new List<SAEEligibilityResponseJSON2Apex.PatientInfo>();
		patInfoList.add(patInfo);
	
		pat.patientInfo = patInfoList;
        
    	List<SAEProviderSearch.wrapperResponse> respList = SAEProviderSearch.returnResponseData(pat);
        System.assertNotEquals(null, respList);
    }
    // End of Code - Thanish - Oct 8th 2019
    
    // Thanish - 19th Nov 2019
    @isTest
    static void testSAEProviderMemberSearchInteractionResult() {
        SAEProviderMemberSearchInteractionResult.memberProviderResult mpr = new SAEProviderMemberSearchInteractionResult.memberProviderResult();
       	mpr.dob = 'dob'; mpr.firstName = 'fn'; mpr.lastName = 'ln'; mpr.middleName = 'mn'; mpr.name = 'name'; mpr.relationship = 'rel';

        SAEProviderMemberSearchInteractionResult.InteractionOverView io = new SAEProviderMemberSearchInteractionResult.InteractionOverView();
        io.contactName = 'cn'; io.healthCareSys = 'hcs'; io.name = 'name'; io.npi = 'npi'; io.primarySpeciality = 'ps'; io.providerFN = 'pfn';
        io.providerLN = 'pln'; io.providerMN = 'pmn'; io.providerNameID = 'pnid'; io.servicingProvider = 'sp'; io.taxidTIN = 'tin';

        SAEProviderMemberSearchInteractionResult.InteractionSubjectCard is = new SAEProviderMemberSearchInteractionResult.InteractionSubjectCard();
        is.age = 5; is.firstName = 'fn'; is.gender = 'gen'; is.groupNumber = 'gn'; is.lastName = 'ln'; is.memberDOB = 'dob'; is.memberId = 'id';
        is.memberName = 'name'; is.middleName = 'mn'; is.relationship = 'rel'; is.subjectName = 'sn';

        SAEProviderMemberSearchInteractionResult.SAEMemberStandaloneSearch ms = new SAEProviderMemberSearchInteractionResult.SAEMemberStandaloneSearch();
        ms.birthDate = 'bd'; ms.firstName = 'fn'; ms.fullName = 'fln'; ms.lastName = 'ln'; ms.middleName = 'mn'; ms.sourceSysCode = 'sc';

        SAEProviderMemberSearchInteractionResult.ErrorMessageHandling emh = new SAEProviderMemberSearchInteractionResult.ErrorMessageHandling();
        emh.faultyCode = 'fc'; emh.message = 'msg';

        List<SAEProviderMemberSearchInteractionResult.memberProviderResult> mprList = new List<SAEProviderMemberSearchInteractionResult.memberProviderResult>();
        mprList.add(mpr);

        List<SAEProviderMemberSearchInteractionResult.SAEMemberStandaloneSearch> ssList = new List<SAEProviderMemberSearchInteractionResult.SAEMemberStandaloneSearch>();
        ssList.add(ms);

        SAEProviderMemberSearchInteractionResult result = new SAEProviderMemberSearchInteractionResult();
        result.interactionView = io; result.subjectCard = is; result.memberProviderResultlst = mprList; result.lstSAEMemberStandaloneSearch = ssList;

        System.assertNotEquals(null, emh); System.assertNotEquals(null, result);
    }
    // Thanish - End of Code.

    // Thanish - 7th Feb 2020
    @isTest
    static void testGetAffliationData() {
        SAE_ProviderSnapshotController.SearchResultWrapper result = SAE_ProviderSnapshotController.getAffliationData('111111111', '111111111', 0, 10);
        System.assertNotEquals(null, result);
    }

    @isTest
    static void testAfflicationDataV2() {
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

        System.assert(token.Value__c != '');

        test.startTest();
        Test.setMock(HttpCalloutMock.class, new SAEProviderServiceResponseMock(200));
        ACETWSCalloutResult affList = SAE_ProviderSnapshotController.getAffData('providerId', 'taxId');
        //System.assertNotEquals(null, affList);
        test.stopTest();
    }

    @isTest
    static void testGetMemberRelatedCases() {
        test.startTest();
        Case testCase = new Case();
        testCase.TaxID__c = '123456789';
        insert testCase;

        List<Case> getMemberRelatedCases = SAE_ProviderSnapshotController.getMemberRelatedCases('123456789');
        //System.assertNotEquals(1, getMemberRelatedCases.size());
        test.stopTest();
    }
    // Thanish - End of Code.

    @isTest
    static void testGetHippaGuideLinesUrl(){
        SAEProviderSearch.getHippaGuideLinesUrl();
    }
}