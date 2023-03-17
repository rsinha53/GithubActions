/*
ACET_FAST_ProviderSearchCtrl_Test
Testing Class Name:  ACET_FAST_ProviderSearchCtrl
Author: Ratna kumar
Date: 11/04/2020
Description: This is test class and designed to get test coverage for ACET_FAST_ProviderSearchCtrl. 
Initial: Ratna Kumar
*/

@isTest
global class ACET_FAST_ProviderSearchCtrl_Test {
    public static final String TOKEN_API = 'TokenAPI';
    
    @testSetup static void setup() {
        
        Organization_Properties__c orgProps = Organization_Properties__c.getOrgDefaults();
        orgProps.OrganizationName__c = 'Silk';
        Upsert orgProps;
        
        
        WebserviceConfigurations__c serviceTokenAPIWSConfig = new WebserviceConfigurations__c(
            Name = 'StarGateTokenAPI',
            RecordTypeId = Schema.SObjectType.WebserviceConfigurations__c.getRecordTypeInfosByDeveloperName().get('Token_API').getRecordTypeId(),
            Method__c = 'POST',
            Headers__c = '[{"key":"Content-Type","value":"application/x-www-form-urlencoded"}]',
            EndpointPath__c = '/auth/oauth2/cached/token',
            AuthorizationToken__c = '',
            GrantType__c = 'client_credentials',
            Timeout__c = 1000
        );
        Insert serviceTokenAPIWSConfig;
        
        
        OrgSpecificConfigurations__c tokenAPIOrgSpecificConfigs = new OrgSpecificConfigurations__c(
            WebserviceConfigurations__c = serviceTokenAPIWSConfig.id,
            Name = 'Silk',
            RecordTypeId = Schema.SObjectType.OrgSpecificConfigurations__c.getRecordTypeInfosByDeveloperName().get(TOKEN_API).getRecordTypeId(),
            EndpointDomain__c = 'https://gateway-stage.optum.com',
            EnableLogs__c = 'Only Error Logs',
            EnableMock__c=false,
            EnableMockForProfiles__c='str' 
        );
        Insert tokenAPIOrgSpecificConfigs;
        
        WebserviceConfigurations__c  webConifTokenApi = new WebserviceConfigurations__c ();        
        webConifTokenApi.GrantType__c  = 'client_credentials';
        webConifTokenApi.Headers__c  = '[{"key":"Authorization","value":"Bearer <:AUTH_TOKEN:>"},{"key":"Content-Type","value":"application/x-www-form-urlencoded"},{"key":"Accept","value":"application/json"}]';
        webConifTokenApi.JSONBodyWithMergeFields__c  = '';
        webConifTokenApi.Method__c  = 'POST';
        webConifTokenApi.Name  = 'FastProviderSearch';        
        RecordType recTypeTokenAPI = [SELECT Id FROM RecordType WHERE DeveloperName = 'Token_API' and SObjectType = 'WebserviceConfigurations__c'];
        webConifTokenApi.RecordTypeId  = recTypeTokenAPI.Id;
        webConifTokenApi.TokenAPI__c=serviceTokenAPIWSConfig.id;
        webConifTokenApi.Timeout__c = 10000;
        Insert webConifTokenApi;
        
        OrgSpecificConfigurations__c tokenAPIOrgSpecificConfigs1 = new OrgSpecificConfigurations__c(
            WebserviceConfigurations__c = webConifTokenApi.id,
            Name = 'Silk',
            RecordTypeId = Schema.SObjectType.OrgSpecificConfigurations__c.getRecordTypeInfosByDeveloperName().get(TOKEN_API).getRecordTypeId(),
            EndpointDomain__c = 'https://gateway-stage.optum.com/api/stage/pdr/pes/physicians-and-facilities/v4.0/search',
            EnableLogs__c = 'All Logs',
            EnableMock__c=false
        );
        Insert tokenAPIOrgSpecificConfigs1;
        
    }
    
    @isTest static void getProviderSearchResults_Test1() {
        Test.startTest();
        Test.setMock(HttpCalloutMock.class, new SAEHttpCalloutMock.SAEProviderWSMock());        
        ACET_FAST_ProviderSearchCtrl.ProviderDetails providerDetails = getProviderDetails();       
        ACET_FAST_ProviderSearchCtrl.getProviderSearchResults(providerDetails);
        // ACET_FAST_ProviderSearchCtrl.getAuthToken();
        ISL_Webservice_Config__c cs = new ISL_Webservice_Config__c();
        cs.Name='SNIAPIAccessToken';
        cs.Value__c='uytdfdduhkjm';
        insert cs;
        ACET_FAST_ProviderSearchCtrl.ACET_FastCalloutResult a=new ACET_FAST_ProviderSearchCtrl.ACET_FastCalloutResult();
        HttpResponse res = new HttpResponse();
        res.setStatusCode(200); 
        ACET_ProviderSearchResultsWrapper.Metadata metdatawrap =new ACET_ProviderSearchResultsWrapper.Metadata();
        metdatawrap.versionNumber='12';
        metdatawrap.wildCardResp='test';
        metdatawrap.total=12;
        metdatawrap.offset=2;
        metdatawrap.psize=2;
        metdatawrap.elapsedTime='22:05:55';
        ACET_ProviderSearchResultsWrapper.ServiceFault servicewrap =new ACET_ProviderSearchResultsWrapper.ServiceFault();
        servicewrap.faultCode='404';
        servicewrap.message='hello error';
         ACET_ProviderSearchResultsWrapper.TaxId taxwrap =new ACET_ProviderSearchResultsWrapper.TaxId();
         taxwrap.taxId='iiuytdfg';
        taxwrap.corporateOwnerLastName='jihu';
        taxwrap.corporateOwnerFirstName='first';
        taxwrap.corporateOwnerMiddleName='middle';
        taxwrap.cancelDate='9999-12-31';
        taxwrap.payeeProviderId='if';
        taxwrap.corpMPIN='6t6';
        
        ACET_ProviderSearchResultsWrapper.PhysicianFacilityInformation physinf =new ACET_ProviderSearchResultsWrapper.PhysicianFacilityInformation();
        physinf.firstName='test';
        physinf.taxId=taxwrap;
        List<ACET_ProviderSearchResultsWrapper.PhysicianFacilitySummary0002Response> physlst =new List<ACET_ProviderSearchResultsWrapper.PhysicianFacilitySummary0002Response>();
        ACET_ProviderSearchResultsWrapper.PhysicianFacilitySummary0002Response phys =new ACET_ProviderSearchResultsWrapper.PhysicianFacilitySummary0002Response();
        phys.physicianFacilityInformation=physinf;
        physlst.add(phys);
        ACET_ProviderSearchResultsWrapper providerSearchResponse =new ACET_ProviderSearchResultsWrapper();
        providerSearchResponse.metadata=metdatawrap;
        providerSearchResponse.serviceFault=servicewrap;
        providerSearchResponse.PhysicianFacilitySummary0002Response=physlst;
        res.setBody(JSON.serialize(providerSearchResponse));
        ACET_FAST_ProviderSearchCtrl.successCallout(res,a);
        Test.stopTest();
    } 
    
    
    public static ACET_FAST_ProviderSearchCtrl.ProviderDetails getProviderDetails(){
        ACET_FAST_ProviderSearchCtrl.ProviderDetails providerDetails = new ACET_FAST_ProviderSearchCtrl.ProviderDetails();
        providerDetails.isAdvancedSearch = true;
        providerDetails.practicingStatus = 'Active';
        providerDetails.taxId = '061330992';
        providerDetails.npi = '';
        providerDetails.firstName = 'pfn';
        providerDetails.lastName = 'pln ';
        providerDetails.filterType = 'Facility';
        providerDetails.state = 'TX';
        providerDetails.zip = 'NY';
        providerDetails.state = '100001';
        providerDetails.corpMPIN = '100001';
        providerDetails.isNiceProvider = true;
        providerDetails.tpsmIndicator = '100001';
        providerDetails.addressLine1 = '100001';
        providerDetails.addressLine2 = '100001';
        providerDetails.degreeCode = '100001';
        providerDetails.EffectivePhoneNumber = '100001';
        providerDetails.AddressCity = '100001';
        providerDetails.isValidProvider = true;
        providerDetails.isProviderNotFound = true;
        providerDetails.isNoProviderToSearch = false;
        providerDetails.isOther = false;
        providerDetails.isPysician = false;
        providerDetails.interactionType = 'Email';
        providerDetails.providerUniqueId = '100001';
        providerDetails.providerId = '100001';
        providerDetails.phoneNumber = '100001';
        providerDetails.contactType = '100001';
        return providerDetails;
    }
}