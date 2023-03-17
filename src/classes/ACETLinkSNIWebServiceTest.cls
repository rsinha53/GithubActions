@isTest
public class ACETLinkSNIWebServiceTest {
    
    @testSetup
    static void dataSetup () {
        User us=  TestDataFactory.getUser('System Administrator');
        us.Username='tUserEHU1P@testorg.acet';
        us.FederationIdentifier='tUser1';
        Insert us;
    }
    
    public static testmethod void test1(){
        
        Organization_Properties__c orgProps = Organization_Properties__c.getOrgDefaults();
        orgProps.OrganizationName__c = 'QA';
        Upsert orgProps;
   
        //Token API
        WebserviceConfigurations__c tokenAPIWSConfig = ACET_WebserviceCalloutFramework_Test.createTokenWSConfigs('StarGateTokenAPI');
        OrgSpecificConfigurations__c tokenAPIOrgSpecificConfigs = new OrgSpecificConfigurations__c(
            WebserviceConfigurations__c = tokenAPIWSConfig.Id,
            Name = 'QA',
            RecordTypeId = Schema.SObjectType.OrgSpecificConfigurations__c.getRecordTypeInfosByName().get('Token API').getRecordTypeId(),
            EndpointDomain__c = 'https://www.test.com',
            EnableLogs__c = 'All Logs',
            RecordTypeText__c='TokenAPI',
            EnableMock__c = true
        );
        Insert tokenAPIOrgSpecificConfigs;
        //OrgSpecificConfigurations__c tokenAPIOrgSpecificConfigs = ACET_WebserviceCalloutFramework_Test.createTokenOrgWSConfigs(tokenAPIWSConfig.Id);
        // Service API data
        WebserviceConfigurations__c wsConfig = ACET_WebserviceCalloutFramework_Test.createWSConfig('SNI Eligibility API', tokenAPIWSConfig.Id);
        OrgSpecificConfigurations__c orgSpecificConfigs = new OrgSpecificConfigurations__c(
            WebserviceConfigurations__c = wsConfig.Id,
            Name = 'QA',
            EnableMockForProfiles__c = 'test',
            RecordTypeId = Schema.SObjectType.OrgSpecificConfigurations__c.getRecordTypeInfosByName().get('Service API').getRecordTypeId(),
            EndpointDomain__c = 'https://www.test.com',
            EnableLogs__c = 'All Logs',
            RecordTypeText__c='ServiceAPI',
            EnableMock__c = true
        );
        Insert orgSpecificConfigs;
        //OrgSpecificConfigurations__c orgSpecificConfigs = ACET_WebserviceCalloutFramework_Test.createOrgWSConfigs(wsConfig.Id);
        
        
        Test.setMock(HttpCalloutMock.class, new MockHttpSNIResponseGenerator(200,'ACETSNIMockResponse'));
        ACETLinkSNIWebService acc= new ACETLinkSNIWebService();
        //acc.GetRequestBody('1718226201','1256153490','Shravyaa','Bussarii','2001-11-24');
        acc.getMemberWS('1718226201','1256153490','Shravyaa','Bussarii','2001-11-24');  
    }

	@isTest static void ACETLinkSNIWebServiceMethod1()
    {
        ISL_Webservice_Config__c webConfig = new ISL_Webservice_Config__c();
        webConfig.Name = 'dev_SNIEligibilityAPI';
        webConfig.ACET_Common_Name__c = 'SNIEligibilityAPI';
        webConfig.Value__c = 'https://gateway-stage.optum.com/api/nonprod/cel/sni-members-api-riptide/messages/v3';
        insert webConfig;

        /*
        ISL_Webservice_Config__c webConfig_token = new ISL_Webservice_Config__c();
        webConfig_token.Name = 'ISLOAuthContentType';
        webConfig_token.Value__c = 'bearer';
        insert webConfig_token;
        */

		ISL_Webservice_Config__c newCustomSetting = new ISL_Webservice_Config__c();
        newCustomSetting.Name = 'SNIAPIAccessToken';
        newCustomSetting.Value__c = 'Y4N9dcrZdBttxpYtEu8OjqdlHEYUNh4J';
	    newCustomSetting.ACET_Common_Name__c = 'SNIApiEndpoint';
        insert newCustomSetting;

        Test.startTest();
            Test.setMock(HttpCalloutMock.class, new MockHttpSNIResponseGenerator(200,'SNIEligibilityAPI'));
            ACETLinkMemberSearch.SearchResultWrapper returnWrapper = ACETLinkMemberSearch.findSNIDetails('961825885','700406','SHANNON','PELKIE','09/18/1976');
            //System.assertEquals(200, returnWrapper.statusCode);
            String memberResponse = ACETLinkMemberSearch.getMemberResponse();
            String requestFormat = ACETLinkMemberSearch.GetRequestFormatByName('SampleResource');
            String requestBody = ACETLinkMemberSearch.GetRequestBody('SampleResource', new List<String>{'1','2'});
        Test.stopTest();
    }

    @isTest static void ACETLinkSNIWebServiceMethod1_500()
    {
          ISL_Webservice_Config__c webConfig = new ISL_Webservice_Config__c();
        webConfig.Name = 'dev_SNIEligibilityAPI';
        webConfig.ACET_Common_Name__c = 'SNIEligibilityAPI';
        webConfig.Value__c = 'https://gateway-stage.optum.com/api/nonprod/cel/sni-members-api-riptide/messages/v3';
        insert webConfig;
       ISL_Webservice_Config__c accessToken = new ISL_Webservice_Config__c();
        accessToken.Name = 'SNIAPIAccessToken';
        accessToken.Value__c = 'Y4N9dcrZdBttxpYtEu8OjqdlHEYUNh4J';
	    accessToken.ACET_Common_Name__c = 'SNIApiEndpoint';
        insert accessToken;

       Test.startTest();
            Test.setMock(HttpCalloutMock.class, new MockHttpSNIResponseGenerator(500,'SNIEligibilityAPI'));
            ACETLinkMemberSearch.SearchResultWrapper returnWrapper = ACETLinkMemberSearch.findSNIDetails('961825885','700406','SHANNON','PELKIE','09/18/1976');
            //System.assertEquals(500, returnWrapper.statusCode);
       Test.stopTest();
    }

    @isTest static void ACETLinkSNIWebServiceMethod1_400()
    {
         ISL_Webservice_Config__c webConfig = new ISL_Webservice_Config__c();
        webConfig.Name = 'dev_SNIEligibilityAPI';
        webConfig.ACET_Common_Name__c = 'SNIEligibilityAPI';
        webConfig.Value__c = 'https://gateway-stage.optum.com/api/nonprod/cel/sni-members-api-riptide/messages/v3';
        insert webConfig;

        ISL_Webservice_Config__c accessToken = new ISL_Webservice_Config__c();
        accessToken.Name = 'SNIAPIAccessToken';
        accessToken.Value__c = 'Y4N9dcrZdBttxpYtEu8OjqdlHEYUNh4J';
	    accessToken.ACET_Common_Name__c = 'SNIApiEndpoint';
        insert accessToken;

       Test.startTest();
            Test.setMock(HttpCalloutMock.class, new MockHttpSNIResponseGenerator(400,'SNIEligibilityAPI'));
            ACETLinkMemberSearch.SearchResultWrapper returnWrapper = ACETLinkMemberSearch.findSNIDetails('961825885','700406','SHANNON','PELKIE','09/18/1976');
            //System.assertEquals(400, returnWrapper.statusCode);
       Test.stopTest();
    }

    @isTest static void ACETLinkSNIWebServiceMethod1_404()
    {
         ISL_Webservice_Config__c webConfig = new ISL_Webservice_Config__c();
        webConfig.Name = 'dev_SNIEligibilityAPI';
        webConfig.ACET_Common_Name__c = 'SNIEligibilityAPI';
        webConfig.Value__c = 'https://gateway-stage.optum.com/api/nonprod/cel/sni-members-api-riptide/messages/v3';
        insert webConfig;

        ISL_Webservice_Config__c accessToken = new ISL_Webservice_Config__c();
        accessToken.Name = 'SNIAPIAccessToken';
        accessToken.Value__c = 'Y4N9dcrZdBttxpYtEu8OjqdlHEYUNh4J';
	    accessToken.ACET_Common_Name__c = 'SNIApiEndpoint';
        insert accessToken;


       Test.startTest();
            Test.setMock(HttpCalloutMock.class, new MockHttpSNIResponseGenerator(404,'SNIEligibilityAPI'));
            ACETLinkMemberSearch.SearchResultWrapper returnWrapper = ACETLinkMemberSearch.findSNIDetails('961825885','700406','SHANNON','PELKIE','09/18/1976');
            //System.assertEquals(404, returnWrapper.statusCode);
       Test.stopTest();
    }

    @isTest static void ACETLinkSNIWebServiceMethod1_999()
    {
        ISL_Webservice_Config__c webConfig = new ISL_Webservice_Config__c();
        webConfig.Name = 'dev_SNIEligibilityAPI';
        webConfig.ACET_Common_Name__c = 'SNIEligibilityAPI';
        webConfig.Value__c = 'https://gateway-stage.optum.com/api/nonprod/cel/sni-members-api-riptide/messages/v3';
        insert webConfig;

        ISL_Webservice_Config__c accessToken = new ISL_Webservice_Config__c();
        accessToken.Name = 'SNIAPIAccessToken';
        accessToken.Value__c = 'Y4N9dcrZdBttxpYtEu8OjqdlHEYUNh4J';
	    accessToken.ACET_Common_Name__c = 'SNIApiEndpoint';
        insert accessToken;
         ISL_Webservice_Config__c sniApiTimeOut = new ISL_Webservice_Config__c();
        sniApiTimeOut.Name = 'SNIapiTimeout';
        sniApiTimeOut.Value__c = '12000';
	    sniApiTimeOut.ACET_Common_Name__c = 'SNIApiEndpoint';
        insert sniApiTimeOut;

       Test.startTest();
            Test.setMock(HttpCalloutMock.class, new MockHttpSNIResponseGenerator(999,'SNIEligibilityAPI'));
            ACETLinkMemberSearch.SearchResultWrapper returnWrapper = ACETLinkMemberSearch.findSNIDetails('961825885','700406','SHANNON','PELKIE','09/18/1976');
            //System.assertEquals(999, returnWrapper.statusCode);
       Test.stopTest();
    }
}