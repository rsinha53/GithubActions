@isTest
public class ACETSNIEligibilityWSTest {
	@isTest static void ACETSNIEligibilityWSMethod1() 
    {
        ISL_Webservice_Config__c webConfig = new ISL_Webservice_Config__c();
        webConfig.Name = 'dev_SNIEligibilityAPI';
        webConfig.ACET_Common_Name__c = 'SNIEligibilityAPI';
        webConfig.Value__c = 'https://gateway-stage.optum.com/api/nonprod/cel/sni-riptide/eligibilities/v4/search';
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
            ACETSNILinkMemberSearch.SearchResultWrapper returnWrapper = ACETSNILinkMemberSearch.findSNIDetails('961825885','700406','SHANNON','PELKIE','09/18/1976');
            //System.assertEquals(200, returnWrapper.statusCode);
            String memberResponse = ACETSNILinkMemberSearch.getMemberResponse();
            String requestFormat = ACETSNILinkMemberSearch.GetRequestFormatByName('SampleResource');
            String requestBody = ACETSNILinkMemberSearch.GetRequestBody('SampleResource', new List<String>{'1','2'});
        Test.stopTest();
    }

    @isTest static void ACETSNIEligibilityWSMethod1_500() 
    {
          ISL_Webservice_Config__c webConfig = new ISL_Webservice_Config__c();
        webConfig.Name = 'dev_SNIEligibilityAPI';
        webConfig.ACET_Common_Name__c = 'SNIEligibilityAPI';
        webConfig.Value__c = 'https://gateway-stage.optum.com/api/nonprod/cel/sni-riptide/eligibilities/v4/search';
        insert webConfig;
       ISL_Webservice_Config__c accessToken = new ISL_Webservice_Config__c();
        accessToken.Name = 'SNIAPIAccessToken';
        accessToken.Value__c = 'Y4N9dcrZdBttxpYtEu8OjqdlHEYUNh4J';
	    accessToken.ACET_Common_Name__c = 'SNIApiEndpoint';
        insert accessToken; 

       Test.startTest();
            Test.setMock(HttpCalloutMock.class, new MockHttpSNIResponseGenerator(500,'SNIEligibilityAPI'));
            ACETSNILinkMemberSearch.SearchResultWrapper returnWrapper = ACETSNILinkMemberSearch.findSNIDetails('961825885','700406','SHANNON','PELKIE','09/18/1976');
            //System.assertEquals(500, returnWrapper.statusCode);
       Test.stopTest();
    }

    @isTest static void ACETSNIEligibilityWSMethod1_400() 
    {
         ISL_Webservice_Config__c webConfig = new ISL_Webservice_Config__c();
        webConfig.Name = 'dev_SNIEligibilityAPI';
        webConfig.ACET_Common_Name__c = 'SNIEligibilityAPI';
        webConfig.Value__c = 'https://gateway-stage.optum.com/api/nonprod/cel/sni-riptide/eligibilities/v4/search';
        insert webConfig;
        
        ISL_Webservice_Config__c accessToken = new ISL_Webservice_Config__c();
        accessToken.Name = 'SNIAPIAccessToken';
        accessToken.Value__c = 'Y4N9dcrZdBttxpYtEu8OjqdlHEYUNh4J';
	    accessToken.ACET_Common_Name__c = 'SNIApiEndpoint';
        insert accessToken; 
        
       Test.startTest();
            Test.setMock(HttpCalloutMock.class, new MockHttpSNIResponseGenerator(400,'SNIEligibilityAPI'));
            ACETSNILinkMemberSearch.SearchResultWrapper returnWrapper = ACETSNILinkMemberSearch.findSNIDetails('961825885','700406','SHANNON','PELKIE','09/18/1976');
            //System.assertEquals(400, returnWrapper.statusCode);
       Test.stopTest();
    }

    @isTest static void ACETSNIEligibilityWSMethod1_404() 
    {
         ISL_Webservice_Config__c webConfig = new ISL_Webservice_Config__c();
        webConfig.Name = 'dev_SNIEligibilityAPI';
        webConfig.ACET_Common_Name__c = 'SNIEligibilityAPI';
        webConfig.Value__c = 'https://gateway-stage.optum.com/api/nonprod/cel/sni-riptide/eligibilities/v4/search';
        insert webConfig;
        
        ISL_Webservice_Config__c accessToken = new ISL_Webservice_Config__c();
        accessToken.Name = 'SNIAPIAccessToken';
        accessToken.Value__c = 'Y4N9dcrZdBttxpYtEu8OjqdlHEYUNh4J';
	    accessToken.ACET_Common_Name__c = 'SNIApiEndpoint';
        insert accessToken; 
        

       Test.startTest();
            Test.setMock(HttpCalloutMock.class, new MockHttpSNIResponseGenerator(404,'SNIEligibilityAPI'));
            ACETSNILinkMemberSearch.SearchResultWrapper returnWrapper = ACETSNILinkMemberSearch.findSNIDetails('961825885','700406','SHANNON','PELKIE','09/18/1976');
            //System.assertEquals(404, returnWrapper.statusCode);
       Test.stopTest();
    }

    @isTest static void ACETSNIEligibilityWSMethod1_999() 
    {
        ISL_Webservice_Config__c webConfig = new ISL_Webservice_Config__c();
        webConfig.Name = 'dev_SNIEligibilityAPI';
        webConfig.ACET_Common_Name__c = 'SNIEligibilityAPI';
        webConfig.Value__c = 'https://gateway-stage.optum.com/api/nonprod/cel/sni-riptide/eligibilities/v4/search';
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
            ACETSNILinkMemberSearch.SearchResultWrapper returnWrapper = ACETSNILinkMemberSearch.findSNIDetails('961825885','700406','SHANNON','PELKIE','09/18/1976');
            //System.assertEquals(999, returnWrapper.statusCode);
       Test.stopTest();
    }
}