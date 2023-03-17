@isTest
public class ACETLinkMemberSearchTest {
     @testSetup static void testSetupSNILinkMemberSearch(){
        Organization_Properties__c orgProp = new Organization_Properties__c();
        orgProp.OrganizationName__c = 'QA';
        orgProp.SetupOwnerId=UserInfo.getOrganizationId();
        insert orgProp;                 
        
        WebserviceConfigurations__c  webConifTokenApi = new WebserviceConfigurations__c ();
        webConifTokenApi.EndpointPath__c = '/oauth/token';
        webConifTokenApi.GrantType__c  = 'client_credentials';
        webConifTokenApi.Headers__c  = '[{"key":"Content-Type","value":"application/x-www-form-urlencoded"}]';
        webConifTokenApi.JSONBodyWithMergeFields__c  = '';
        webConifTokenApi.Method__c  = 'POST';
        webConifTokenApi.Name  = 'LinkServiceTokenAPI';
        //Id RecordTypeId = Schema.SObjectType.WebserviceConfigurations__c.getRecordTypeInfosByName().get('Token_API').getRecordTypeId();
        RecordType recTypeTokenAPI = [SELECT Id FROM RecordType WHERE DeveloperName = 'Token_API' and SObjectType = 'WebserviceConfigurations__c'];
        webConifTokenApi.RecordTypeId  = recTypeTokenAPI.Id;
        insert webConifTokenApi;
        OrgSpecificConfigurations__c orgSpecTokenAPI = new OrgSpecificConfigurations__c();
        //Id RecordTypeId = Schema.SObjectType.OrgSpecificConfigurations__c.getRecordTypeInfosByName().get('TokenAPI').getRecordTypeId(); 
        RecordType recTypeOrgTokenAPI = [SELECT Id FROM RecordType WHERE DeveloperName = 'TokenAPI' and SObjectType = 'OrgSpecificConfigurations__c'];
        orgSpecTokenAPI.RecordTypeId  = recTypeOrgTokenAPI.Id;
        orgSpecTokenAPI.EndpointDomain__c = 'https://api-gateway-stage.linkhealth.com';
        orgSpecTokenAPI.ClientId__c = 'test';
        orgSpecTokenAPI.ClientSecret__c = 'a723ef27-493b-4afa-2d43-43542cc87rf3';
        orgSpecTokenAPI.WebserviceConfigurations__c = webConifTokenApi.Id;
        insert orgSpecTokenAPI;             
        WebserviceConfigurations__c tokenRecord = new WebserviceConfigurations__c();
        tokenRecord.Name = 'LinkServiceTokenAPIToken';
        RecordType recTypeAuthTokenAPI = [SELECT Id FROM RecordType WHERE DeveloperName = 'Authorization_Token' and SObjectType = 'WebserviceConfigurations__c'];
        tokenRecord.RecordTypeId = recTypeAuthTokenAPI.Id;
        tokenRecord.AuthorizationToken__c = 'sdakhjsadkjsagdiuqwy912879182371okasbdfo123y984e1279479812hkdjasahdo12987349182ehkj';
        insert tokenRecord;

        WebserviceConfigurations__c  webConifServiceAPI = new WebserviceConfigurations__c ();
        webConifServiceAPI.EndpointPath__c = '/elink-services/api/eligibility/v2.0';
        webConifServiceAPI.GrantType__c  = 'client_credentials';
        webConifServiceAPI.Headers__c  = '[{"key":"Authorization","value":"Bearer <:AUTH_TOKEN:>"},{"key":"Content-Type","value":"application/json"},{"key":"actor","value":"ACET"}]';
        webConifServiceAPI.AuthorizationToken__c  = 'SELECT AuthorizationToken__c FROM WebserviceConfigurations__c WHERE Name = LinkServiceTokenAPIToken';
        webConifServiceAPI.Method__c  = 'GET';
        webConifServiceAPI.TokenAPI__c  = webConifTokenApi.id;
        webConifServiceAPI.Name  = 'LinkEligibilityMemberSearch';
        webConifServiceAPI.Timeout__c = 10000;
        RecordType recTypeWebServiceAPI = [SELECT Id FROM RecordType WHERE DeveloperName = 'Service_API' and SObjectType = 'WebserviceConfigurations__c'];
        webConifServiceAPI.RecordTypeId  = recTypeWebServiceAPI.id;
        insert webConifServiceAPI;
        OrgSpecificConfigurations__c orgSpecServiceAPI = new OrgSpecificConfigurations__c();
        RecordType recTypeOrgServiceAPI = [SELECT Id FROM RecordType WHERE DeveloperName = 'ServiceAPI' and SObjectType = 'OrgSpecificConfigurations__c'];
        orgSpecServiceAPI.RecordTypeId  = recTypeOrgServiceAPI.Id;
        orgSpecServiceAPI.Name = 'QA';
        orgSpecServiceAPI.EndpointDomain__c = 'https://api-gateway-stage.linkhealth.com';
        orgSpecServiceAPI.EnableMock__c  = false;
        orgSpecServiceAPI.WebserviceConfigurations__c = webConifServiceAPI.Id;
        insert orgSpecServiceAPI;
        WebserviceConfigurations__c  webConifExtendedServiceAPI = new WebserviceConfigurations__c ();
        webConifExtendedServiceAPI.EndpointPath__c = '/elink-extended/api/coverageAttributes/v2.0';
        webConifExtendedServiceAPI.GrantType__c  = 'client_credentials';
        webConifExtendedServiceAPI.Headers__c  = '[{"key":"Authorization","value":"Bearer <:AUTH_TOKEN:>"},{"key":"Content-Type","value":"application/json"},{"key":"actor","value":"ACET"}]';
        webConifExtendedServiceAPI.AuthorizationToken__c  = 'SELECT AuthorizationToken__c FROM WebserviceConfigurations__c WHERE Name = LinkServiceTokenAPIToken';
        webConifExtendedServiceAPI.Method__c  = 'GET';
        webConifExtendedServiceAPI.TokenAPI__c  = webConifTokenApi.id;
        webConifExtendedServiceAPI.Name  = 'LinkExtendedCoverage';
        webConifExtendedServiceAPI.Timeout__c = 10000;
        RecordType recTypeWebExtendedServiceAPI = [SELECT Id FROM RecordType WHERE DeveloperName = 'Service_API' and SObjectType = 'WebserviceConfigurations__c'];
        webConifExtendedServiceAPI.RecordTypeId  = recTypeWebExtendedServiceAPI.id;
        insert webConifExtendedServiceAPI;
        OrgSpecificConfigurations__c orgSpecExtendedServiceAPI = new OrgSpecificConfigurations__c();
        RecordType recTypeOrgExtebdedServiceAPI = [SELECT Id FROM RecordType WHERE DeveloperName = 'ServiceAPI' and SObjectType = 'OrgSpecificConfigurations__c'];
        orgSpecExtendedServiceAPI.RecordTypeId  = recTypeOrgExtebdedServiceAPI.Id;
        orgSpecExtendedServiceAPI.Name = 'QA';
        orgSpecExtendedServiceAPI.EndpointDomain__c = 'https://api-gateway-stage.linkhealth.com';
        orgSpecExtendedServiceAPI.EnableMock__c  = false;
        orgSpecExtendedServiceAPI.WebserviceConfigurations__c = webConifExtendedServiceAPI.Id;
        insert orgSpecExtendedServiceAPI;
    }
	@isTest static void linkElligibilityTest()
    {
        Test.startTest();
            Test.setMock(HttpCalloutMock.class, new ACETLinkMockResponse(200,'LinkEligibilityAPI'));
            ACETLinkMemberSearch.SearchResultWrapper returnWrapper = ACETLinkMemberSearch.findMembers('123456789', '6/8/1977','Test', 'User', '','');
            System.assertEquals(200, returnWrapper.statusCode);
            String memberResponse = ACETLinkMemberSearch.getMemberResponse();
            String requestFormat = ACETLinkMemberSearch.GetRequestFormatByName('SampleResource');
            String requestBody = ACETLinkMemberSearch.GetRequestBody('SampleResource', new List<String>{'1','2'});
        Test.stopTest();
    }

    @isTest static void linkElligibilityTest_ResponseData()
    {
        StaticResource sampleResponse =[SELECT Body FROM StaticResource WHERE Name = 'ACETLinkEligibilityResponseMock'];
        AcetLinkEligibilityJSON2Apex json2Apex = AcetLinkEligibilityJSON2Apex.parse(sampleResponse.Body.toString());
        List<AcetLinkEligibilityJSON2Apex.MemberPolicies> memberpolicies = new List<AcetLinkEligibilityJSON2Apex.MemberPolicies>();

        List<ACETLinkMemberSearch.wrapperResponse> wrapperResponse = ACETLinkMemberSearch.returnResponseData(json2Apex.memberPolicies.get(0));
    }

    @isTest static void linkElligibilityTest_500() 
    {

        Test.startTest();
            Test.setMock(HttpCalloutMock.class, new ACETLinkMockResponse(500,'LinkEligibilityAPI'));
            ACETLinkMemberSearch.SearchResultWrapper returnWrapper = ACETLinkMemberSearch.findMembers('123456789', '6/8/1977','Test', 'User', '','');
            System.assertEquals(500, returnWrapper.statusCode);
        Test.stopTest();
    }

    @isTest static void linkElligibilityTest_400() 
    {

        Test.startTest();
            Test.setMock(HttpCalloutMock.class, new ACETLinkMockResponse(400,'LinkEligibilityAPI'));
            ACETLinkMemberSearch.SearchResultWrapper returnWrapper = ACETLinkMemberSearch.findMembers('123456789', '6/8/1977','Test', 'User', '','');
            System.assertEquals(400, returnWrapper.statusCode);
        Test.stopTest();
    }

    @isTest static void linkElligibilityTest_404() 
    {

        Test.startTest();
            Test.setMock(HttpCalloutMock.class, new ACETLinkMockResponse(404,'LinkEligibilityAPI'));
            ACETLinkMemberSearch.SearchResultWrapper returnWrapper = ACETLinkMemberSearch.findMembers('123456789', '6/8/1977','Test', 'User', '','');
            System.assertEquals(404, returnWrapper.statusCode);
        Test.stopTest();
    }

    @isTest static void linkElligibilityTest_Other() 
    {

        Test.startTest();
            Test.setMock(HttpCalloutMock.class, new ACETLinkMockResponse(999,'LinkEligibilityAPI'));
            ACETLinkMemberSearch.SearchResultWrapper returnWrapper = ACETLinkMemberSearch.findMembers('123456789', '6/8/1977','Test', 'User', '','');
            System.assertEquals(999, returnWrapper.statusCode);
        Test.stopTest();
    }
   
    @isTest static void linkExtendedCovTest() 
    {
              
        

        
        Test.startTest();
            Test.setMock(HttpCalloutMock.class, new ACETLinkMockResponse(200,'LinkExtendedCoverageAPI'));
            ACETLinkMemberSearch.SearchResultWrapper returnWrapper = ACETLinkMemberSearch.getHouseHoldData('AgALAmMZHImaaWqkDNmFyo4u4Xhei');
            System.assertEquals(200, returnWrapper.statusCode);
         Test.stopTest();
    }

    
    @isTest static void linkExtendedCovTest_500() 
    {

        Test.startTest();
            Test.setMock(HttpCalloutMock.class, new ACETLinkMockResponse(500,'LinkExtendedCoverageAPI'));
            ACETLinkMemberSearch.SearchResultWrapper returnWrapper = ACETLinkMemberSearch.getHouseHoldData('AgALAmMZHImaaWqkDNmFyo4u4Xhei');
            //System.assertEquals(500, returnWrapper.statusCode);
        Test.stopTest();
    }

    @isTest static void linkExtendedCovTest_400() 
    {

        Test.startTest();
            Test.setMock(HttpCalloutMock.class, new ACETLinkMockResponse(400,'LinkExtendedCoverageAPI'));
            ACETLinkMemberSearch.SearchResultWrapper returnWrapper = ACETLinkMemberSearch.getHouseHoldData('AgALAmMZHImaaWqkDNmFyo4u4Xhei');
            //System.assertEquals(400, returnWrapper.statusCode); 
        Test.stopTest();
    }

    @isTest static void linkExtendedCovTest_404() 
    {

        Test.startTest();
            Test.setMock(HttpCalloutMock.class, new ACETLinkMockResponse(404,'LinkExtendedCoverageAPI'));
            ACETLinkMemberSearch.SearchResultWrapper returnWrapper = ACETLinkMemberSearch.getHouseHoldData('AgALAmMZHImaaWqkDNmFyo4u4Xhei');
            //System.assertEquals(404, returnWrapper.statusCode);
        Test.stopTest();
    }

    @isTest static void linkExtendedCovTest_Other() 
    {

        Test.startTest();
            Test.setMock(HttpCalloutMock.class, new ACETLinkMockResponse(999,'LinkExtendedCoverageAPI'));
            ACETLinkMemberSearch.SearchResultWrapper returnWrapper = ACETLinkMemberSearch.getHouseHoldData('AgALAmMZHImaaWqkDNmFyo4u4Xhei');
            //System.assertEquals(999, returnWrapper.statusCode);
        Test.stopTest();
    }
   
}