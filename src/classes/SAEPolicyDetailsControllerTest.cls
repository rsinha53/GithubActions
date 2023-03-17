@isTest
public class SAEPolicyDetailsControllerTest {
    @testSetup static void setupCS(){
        Organization_Properties__c orgProps = Organization_Properties__c.getOrgDefaults();
        orgProps.OrganizationName__c = 'slayer';
        Upsert orgProps;
        
        //Ketki - Stargte
        //Create WS records for service and token APIS
        WebserviceConfigurations__c  webConifTokenApiStargate = new WebserviceConfigurations__c ();
        webConifTokenApiStargate.EndpointPath__c = '/auth/oauth2/cached/token';
        webConifTokenApiStargate.GrantType__c  = 'client_credentials';
        webConifTokenApiStargate.Headers__c  = '[{"key":"Content-Type","value":"application/x-www-form-urlencoded"}]';
        webConifTokenApiStargate.JSONBodyWithMergeFields__c  = '';
        webConifTokenApiStargate.Method__c  = 'POST';
        webConifTokenApiStargate.Name  = 'StarGateTokenAPI';
        //Id RecordTypeId = Schema.SObjectType.WebserviceConfigurations__c.getRecordTypeInfosByName().get('Token_API').getRecordTypeId();
        RecordType recTypeToken = [SELECT Id FROM RecordType WHERE DeveloperName = 'Token_API' and SObjectType = 'WebserviceConfigurations__c'];
        webConifTokenApiStargate.RecordTypeId  = recTypeToken.Id;
        insert webConifTokenApiStargate;
        
        OrgSpecificConfigurations__c orgSpecTokenAPIStargate = new OrgSpecificConfigurations__c();
        //Id RecordTypeId = Schema.SObjectType.OrgSpecificConfigurations__c.getRecordTypeInfosByName().get('TokenAPI').getRecordTypeId(); 
        RecordType recTypeOrgToken = [SELECT Id FROM RecordType WHERE DeveloperName = 'TokenAPI' and SObjectType = 'OrgSpecificConfigurations__c'];
        orgSpecTokenAPIStargate.RecordTypeId  = recTypeOrgToken.Id;
        orgSpecTokenAPIStargate.EndpointDomain__c = 'https://gateway-stage.optum.com';
        orgSpecTokenAPIStargate.ClientId__c = 'test';
        orgSpecTokenAPIStargate.ClientSecret__c = 'HOt08KbsGwIXiS6uD65hjG8wU83v12RX';
        orgSpecTokenAPIStargate.WebserviceConfigurations__c = webConifTokenApiStargate.Id;
        insert orgSpecTokenAPIStargate;
        
        WebserviceConfigurations__c tokenRecordAPI = new WebserviceConfigurations__c();
        tokenRecordAPI.Name = 'StarGateTokenAPIToken';
        RecordType recTypeAuthToken = [SELECT Id FROM RecordType WHERE DeveloperName = 'Authorization_Token' and SObjectType = 'WebserviceConfigurations__c'];
        tokenRecordAPI.RecordTypeId = recTypeAuthToken.Id;
        tokenRecordAPI.AuthorizationToken__c = 'sdakhjsadkjsagdiuqwy912879182371okasbdfo123y984e1279479812hkdjasahdo12987349182ehkj';
        insert tokenRecordAPI;
        
        WebserviceConfigurations__c  webConifPESServiceAPI = new WebserviceConfigurations__c ();
        webConifPESServiceAPI.EndpointPath__c = '';
        webConifPESServiceAPI.GrantType__c  = 'client_credentials';
        webConifPESServiceAPI.Headers__c  = '[{"key":"Authorization","value":"Bearer <:AUTH_TOKEN:>"},{"key":"Content-Type","value":"application/x-www-form-urlencoded"}]';
        webConifPESServiceAPI.AuthorizationToken__c  = 'SELECT AuthorizationToken__c FROM WebserviceConfigurations__c WHERE Name = StarGateTokenAPIToken';
        webConifPESServiceAPI.Method__c  = 'POST';
        webConifPESServiceAPI.TokenAPI__c  = webConifTokenApiStargate.id;
        webConifPESServiceAPI.Name  = 'IPAMarketAssociationService';
        webConifPESServiceAPI.Timeout__c = 10000;
        RecordType recTypeWebPESServiceAPI = [SELECT Id FROM RecordType WHERE DeveloperName = 'Service_API' and SObjectType = 'WebserviceConfigurations__c'];
        webConifPESServiceAPI.RecordTypeId  = recTypeWebPESServiceAPI.id;
        insert webConifPESServiceAPI;
        
        OrgSpecificConfigurations__c orgSpecRCEDServiceAPI2 = new OrgSpecificConfigurations__c();
        RecordType recTypeOrgRCEDServiceAPI2 = [SELECT Id FROM RecordType WHERE DeveloperName = 'ServiceAPI' and SObjectType = 'OrgSpecificConfigurations__c'];
        orgSpecRCEDServiceAPI2.RecordTypeId  = recTypeOrgRCEDServiceAPI2.Id;
        orgSpecRCEDServiceAPI2.Name = 'QA';
        orgSpecRCEDServiceAPI2.EndpointDomain__c = 'https://gateway-stage.optum.com/api/alpha/pdr/pes/market-ipa-associations/v1.0/search';
        orgSpecRCEDServiceAPI2.EnableMock__c  = true;
        orgSpecRCEDServiceAPI2.WebserviceConfigurations__c = webConifPESServiceAPI.Id;
        insert orgSpecRCEDServiceAPI2;
        
        Mock_Response_Details__c mock=new Mock_Response_Details__c();
        mock.Status_Code__c='200';
        mock.FileName__c='IPAMarketAssociation_0000005440';
        mock.SearchParameter__c='IPAMarketAssociation_0000005440';
        mock.WebserviceConfigurations__c = webConifPESServiceAPI.id;
        insert mock;
        
        
        
        WebserviceConfigurations__c  webConifRCEDServiceAPI = new WebserviceConfigurations__c ();
        webConifRCEDServiceAPI.EndpointPath__c = '';
        webConifRCEDServiceAPI.GrantType__c  = 'client_credentials';
        webConifRCEDServiceAPI.Headers__c  = '[{"key":"Authorization","value":"Bearer <:AUTH_TOKEN:>"},{"key":"Content-Type","value":"application/json"},{"key":"actor","value":"ACET"}]';
        webConifRCEDServiceAPI.AuthorizationToken__c  = 'SELECT AuthorizationToken__c FROM WebserviceConfigurations__c WHERE Name = StarGateTokenAPIToken';
        webConifRCEDServiceAPI.Method__c  = 'POST';
        webConifRCEDServiceAPI.TokenAPI__c  = webConifTokenApiStargate.id;
        webConifRCEDServiceAPI.Name  = 'ADBLoyaltyEndpoint';
        webConifRCEDServiceAPI.Timeout__c = 10000;
        RecordType recTypeWebRCEDServiceAPI = [SELECT Id FROM RecordType WHERE DeveloperName = 'Service_API' and SObjectType = 'WebserviceConfigurations__c'];
        webConifRCEDServiceAPI.RecordTypeId  = recTypeWebRCEDServiceAPI.id;
        insert webConifRCEDServiceAPI;
        
        
        OrgSpecificConfigurations__c orgSpecRCEDServiceAPI3 = new OrgSpecificConfigurations__c();
        RecordType recTypeOrgRCEDServiceAPI3 = [SELECT Id FROM RecordType WHERE DeveloperName = 'ServiceAPI' and SObjectType = 'OrgSpecificConfigurations__c'];
        orgSpecRCEDServiceAPI3.RecordTypeId  = recTypeOrgRCEDServiceAPI3.id;
        orgSpecRCEDServiceAPI3.Name = 'QA';
        orgSpecRCEDServiceAPI3.EndpointDomain__c = 'https://gateway-stage.optum.com/api/alpha/cel/consumer/eligibilities/v1/read';
        orgSpecRCEDServiceAPI3.EnableMock__c  = true;
        orgSpecRCEDServiceAPI3.WebserviceConfigurations__c = webConifRCEDServiceAPI.Id;
        insert orgSpecRCEDServiceAPI3;
        
        Mock_Response_Details__c mockRCED=new Mock_Response_Details__c();
        mockRCED.Status_Code__c='200';
        mockRCED.FileName__c='RCED_00158561234_904449_CS';
        mockRCED.SearchParameter__c='RCED_00158561234_904449_CS';
        mockRCED.WebserviceConfigurations__c = webConifRCEDServiceAPI.id;
        insert mockRCED;
    }
    
   
    static testMethod void test_call_IPA_MarketAssociation_API(){
        Test.startTest();
       // Test.setMock(HttpCalloutMock.class, new SAEHttpCalloutMock.ACETGetIPAMarketAssociationMock());
        SAEPolicyDetailsController.IPAMarketInputs input=new SAEPolicyDetailsController.IPAMarketInputs();
        input.appName='acet';
        input.marketNumber='0000005440'; 
        input.marketType='95'; 
        input.ipa='002';
        SAEPolicyDetailsController.IPAMarketResponseWrap ipaMarketResponse = SAEPolicyDetailsController.call_IPA_MarketAssociation_API(input);
        System.assertNotEquals(ipaMarketResponse, null);
        Test.stopTest();
    }
    
    static testMethod void test_call_RCED_API(){
        Test.startTest();
        SAEPolicyDetailsController.RCEDResponseWrap response= SAEPolicyDetailsController.call_RCED('00158561234','904449','CS');      
        System.assertNotEquals(response, null);
        Test.stopTest();
    }
    static testMethod void test_ACETIPAMarketAssociationWS(){
        Test.startTest();
        ACETIPAMarketAssociationWS amws = new ACETIPAMarketAssociationWS();
		amws.appName ='test';
        amws.ipa = 'test';
        amws.marketNumber = 'test';
        amws.marketType = 'test';
        Test.stopTest();
    }
}