@isTest
public class SAE_PoliciesCtrlTest {
	
    @testSetup static void setupCS(){
    	Organization_Properties__c orgProps = Organization_Properties__c.getOrgDefaults();
        orgProps.OrganizationName__c = 'aerosmith';
        Upsert orgProps;	  
        
        //Create WS records for service and token APIS
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
        
        WebserviceConfigurations__c  webConifExtendedServiceAPI = new WebserviceConfigurations__c ();
        webConifExtendedServiceAPI.EndpointPath__c = '/elink-extended/api/networkStatus/v3.0';
        webConifExtendedServiceAPI.GrantType__c  = 'client_credentials';
        webConifExtendedServiceAPI.Headers__c  = '[{"key":"Authorization","value":"Bearer <:AUTH_TOKEN:>"},{"key":"Content-Type","value":"application/json"},{"key":"actor","value":"ACET"}]';
        webConifExtendedServiceAPI.AuthorizationToken__c  = 'SELECT AuthorizationToken__c FROM WebserviceConfigurations__c WHERE Name = LinkServiceTokenAPIToken';
        webConifExtendedServiceAPI.Method__c  = 'GET';
        webConifExtendedServiceAPI.TokenAPI__c  = webConifTokenApi.id;
        webConifExtendedServiceAPI.Name  = 'LinkExtendedNetworkStatus';
        webConifExtendedServiceAPI.Timeout__c = 10000;
        RecordType recTypeWebExtendedServiceAPI = [SELECT Id FROM RecordType WHERE DeveloperName = 'Service_API' and SObjectType = 'WebserviceConfigurations__c'];
        webConifExtendedServiceAPI.RecordTypeId  = recTypeWebExtendedServiceAPI.id;
        insert webConifExtendedServiceAPI;
        
        OrgSpecificConfigurations__c orgSpecExtendedServiceAPI = new OrgSpecificConfigurations__c();
        RecordType recTypeOrgExtebdedServiceAPI = [SELECT Id FROM RecordType WHERE DeveloperName = 'ServiceAPI' and SObjectType = 'OrgSpecificConfigurations__c'];
        orgSpecExtendedServiceAPI.RecordTypeId  = recTypeOrgExtebdedServiceAPI.Id;
        orgSpecExtendedServiceAPI.Name = 'aerosmith';
        orgSpecExtendedServiceAPI.EndpointDomain__c = 'https://api-gateway-stage.linkhealth.com';
        orgSpecExtendedServiceAPI.EnableMock__c  = false;
        orgSpecExtendedServiceAPI.WebserviceConfigurations__c = webConifExtendedServiceAPI.Id;
        insert orgSpecExtendedServiceAPI;
        
        WebserviceConfigurations__c  webConifExtendedServiceAPI2 = new WebserviceConfigurations__c ();
        webConifExtendedServiceAPI2.EndpointPath__c = '/elink-extended/api/coverageAttributes/v2.0';
        webConifExtendedServiceAPI2.GrantType__c  = 'client_credentials';
        webConifExtendedServiceAPI2.Headers__c  = '[{"key":"Authorization","value":"Bearer <:AUTH_TOKEN:>"},{"key":"Content-Type","value":"application/json"},{"key":"actor","value":"ACET"}]';
        webConifExtendedServiceAPI2.AuthorizationToken__c  = 'SELECT AuthorizationToken__c FROM WebserviceConfigurations__c WHERE Name = LinkServiceTokenAPIToken';
        webConifExtendedServiceAPI2.Method__c  = 'GET';
        webConifExtendedServiceAPI2.TokenAPI__c  = webConifTokenApi.id;
        webConifExtendedServiceAPI2.Name  = 'LinkExtendedCoverage';
        webConifExtendedServiceAPI2.Timeout__c = 10000;
        RecordType recTypeWebExtendedServiceAPI2 = [SELECT Id FROM RecordType WHERE DeveloperName = 'Service_API' and SObjectType = 'WebserviceConfigurations__c'];
        webConifExtendedServiceAPI2.RecordTypeId  = recTypeWebExtendedServiceAPI2.id;
        insert webConifExtendedServiceAPI2;
        
        OrgSpecificConfigurations__c orgSpecExtendedServiceAPI2 = new OrgSpecificConfigurations__c();
        RecordType recTypeOrgExtebdedServiceAPI2 = [SELECT Id FROM RecordType WHERE DeveloperName = 'ServiceAPI' and SObjectType = 'OrgSpecificConfigurations__c'];
        orgSpecExtendedServiceAPI2.RecordTypeId  = recTypeOrgExtebdedServiceAPI2.Id;
        orgSpecExtendedServiceAPI2.Name = 'aerosmith';
        orgSpecExtendedServiceAPI2.EndpointDomain__c = 'https://api-gateway-stage.linkhealth.com';
        orgSpecExtendedServiceAPI2.EnableMock__c  = false;
        orgSpecExtendedServiceAPI2.WebserviceConfigurations__c = webConifExtendedServiceAPI2.Id;
        insert orgSpecExtendedServiceAPI2;

    }

    static testMethod void test_call_RCED_API(){
        Test.startTest();
        Test.setMock(HttpCalloutMock.class, new SAEHttpCalloutMock.ACETGetRCEDMock());
        Integer size=0;
        SAEPolicyDetailsController.RCEDResponseWrap rcedResponse = SAE_PoliciesCtrl.call_RCED_API('524291072','0914534','CS');
        System.assertNotEquals(rcedResponse, null);
        Test.stopTest();
    }

    static testMethod void test_getExtendedData() {
        Test.startTest();
        Test.setMock(HttpCalloutMock.class, new SAEHttpCalloutMock.SAEGetCOBWebServiceMock());
        //getExtendedResult method code coverage
        SAE_PoliciesCtrl.ExtendedResultWrapper extSuccessResult=SAE_PoliciesCtrl.getExtendedResult(SAEConstants.SAE_POLICYSEARCH_TRANSACTION_ID);
       	 System.assertNotEquals(extSuccessResult, null);
         //System.assertEquals(extSuccessResult.statusCode,200);

        Test.setMock(HttpCalloutMock.class, new SAEHttpCalloutMock.SAEWebserviceMockForError(500,'ED270SE'));
        SAE_PoliciesCtrl.ExtendedResultWrapper extSuccessResultError=SAE_PoliciesCtrl.getExtendedResult(SAEConstants.SAE_POLICYSEARCH_TRANSACTION_ID);
        System.assertNotEquals(extSuccessResultError, null);

        Test.setMock(HttpCalloutMock.class, new SAEHttpCalloutMock.SAEWebserviceMockForError(999,'ED270SE'));
        SAE_PoliciesCtrl.ExtendedResultWrapper extSuccessResultError1=SAE_PoliciesCtrl.getExtendedResult(SAEConstants.SAE_POLICYSEARCH_TRANSACTION_ID);
        System.assertNotEquals(extSuccessResultError1, null);
        Test.setMock(HttpCalloutMock.class, new SAEHttpCalloutMock.SAEWebserviceMockFor400());
        SAE_PoliciesCtrl.ExtendedResultWrapper extSuccessResultError3=SAE_PoliciesCtrl.getExtendedResult(null);
        System.assertNotEquals(extSuccessResultError3, null);
    }

    static testMethod void test_getOptumExlusions(){
        List<UHG_Restricted_Plans__mdt> expectedOutcome = new List<UHG_Restricted_Plans__mdt>();
        expectedOutcome = SAE_PoliciesCtrl.getOptumExlusions();
        SAE_PoliciesCtrl.getPCPURL();//US2644766 - PCP Indicator UI and  Implementation - Durga [08/06/2020]-
        System.assertNotEquals(expectedOutcome, NULL);
    }

    // Thanish - 17th Jun 2020 - Code Coverage
    static testMethod void test_webServiceFormQueryString(){
        List<String> strLst = new String[13];
		String returnValue = SAEWebservice.formQueryString(strLst);
        System.assertNotEquals(NULL, returnValue);
    }
    
    
    static testMethod void test_getMemberPolicyNetworkInfo() {
        Test.startTest();
        Test.setMock(HttpCalloutMock.class, new SAEHttpCalloutMock.SAEWebserviceMockForError(200,''));
        SAE_PoliciesCtrl.getMemberPolicyNetworkInfo(SAEConstants.SAE_POLICYSEARCH_TRANSACTION_ID);
        Test.stopTest();
    }
    
    static testMethod void getMemberPolicyNetworkInfoNewFramework() {
        Test.startTest();
        try{
            Test.setMock(HttpCalloutMock.class, new SAEHttpCalloutMock.SAEWebserviceMockForError(200,''));
            SAE_PoliciesCtrl.getMemberPolicyNetworkInfo(SAEConstants.SAE_POLICYSEARCH_TRANSACTION_ID,null);
        }
        catch(exception ex){
            system.debug('exception occured');
        }

        Test.stopTest();
    }
    
    static testMethod void test_getMemberPolicyNetworkInfo400() {
        Test.startTest();
        Test.setMock(HttpCalloutMock.class, new SAEHttpCalloutMock.SAEWebserviceMockForError(400,''));
        SAE_PoliciesCtrl.getMemberPolicyNetworkInfo(SAEConstants.SAE_POLICYSEARCH_TRANSACTION_ID);
        Test.stopTest();
    }
    
    static testMethod void getMemberPolicyNetworkInfoNewFramework400() {
        Test.startTest();
        try{
            Test.setMock(HttpCalloutMock.class, new SAEHttpCalloutMock.SAEWebserviceMockForError(400,''));
            SAE_PoliciesCtrl.getMemberPolicyNetworkInfo(SAEConstants.SAE_POLICYSEARCH_TRANSACTION_ID,null);
        }
        catch(exception ex){
            system.debug('exception occured');
        }
        Test.stopTest();
    }
    
    static testMethod void test_getMemberPolicyNetworkInfo500() {
        Test.startTest();
        Test.setMock(HttpCalloutMock.class, new SAEHttpCalloutMock.SAEWebserviceMockForError(500,''));
        SAE_PoliciesCtrl.getMemberPolicyNetworkInfo(SAEConstants.SAE_POLICYSEARCH_TRANSACTION_ID);
        Test.stopTest();
    }
    
    
    static testMethod void getMemberPolicyNetworkInfoNewFramework500() {
        Test.startTest();
        try{
            Test.setMock(HttpCalloutMock.class, new SAEHttpCalloutMock.SAEWebserviceMockForError(500,''));
            SAE_PoliciesCtrl.getMemberPolicyNetworkInfo(SAEConstants.SAE_POLICYSEARCH_TRANSACTION_ID,null);
        }
        catch(exception ex){
            system.debug('exception occured');
        }
        Test.stopTest();
    }
    
    static testMethod void test_getMemberPolicyNetworkInfo404() {
        Test.startTest();
        Test.setMock(HttpCalloutMock.class, new SAEHttpCalloutMock.SAEWebserviceMockForError(404,''));
        SAE_PoliciesCtrl.getMemberPolicyNetworkInfo(SAEConstants.SAE_POLICYSEARCH_TRANSACTION_ID);
        Test.stopTest();
    }
    
    static testMethod void getMemberPolicyNetworkInfoNewFramework404() {
        Test.startTest();
        try{
            Test.setMock(HttpCalloutMock.class, new SAEHttpCalloutMock.SAEWebserviceMockForError(404,''));
            SAE_PoliciesCtrl.getMemberPolicyNetworkInfo(SAEConstants.SAE_POLICYSEARCH_TRANSACTION_ID,null);
        }
        catch(exception ex){
            system.debug('exception occured');
        }
        Test.stopTest();
    }
    
    static testMethod void test_getMemberPolicyNetworkInfo9SAEHttpCalloutMock99() {
        Test.startTest();
        Test.setMock(HttpCalloutMock.class, new SAEHttpCalloutMock.SAEWebserviceMockForError(999,''));
        SAE_PoliciesCtrl.getMemberPolicyNetworkInfo(SAEConstants.SAE_POLICYSEARCH_TRANSACTION_ID);
        Test.stopTest();
    }
    
    
    static testMethod void getMemberPolicyNetworkInfoNewFramework999() {
        Test.startTest();
        try{
            Test.setMock(HttpCalloutMock.class, new SAEHttpCalloutMock.SAEWebserviceMockForError(999,''));
            SAE_PoliciesCtrl.getMemberPolicyNetworkInfo(SAEConstants.SAE_POLICYSEARCH_TRANSACTION_ID,null);
        }
        catch(exception ex){
            system.debug('exception occured');
        }
        Test.stopTest();
    }
}