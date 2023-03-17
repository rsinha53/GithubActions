@isTest
public class ACET_FacetsGETProviderContractsS_Test {
    
    @testSetup static void setup() {
        List<ISL_Webservice_Config__c> lstoFservicesettings = new list<ISL_Webservice_Config__c>();
        ISL_Webservice_Config__c serviceSetting = new ISL_Webservice_Config__c(Name='dev_ContractSummary',
                                                                               Value__c='https://gateway-stage.optum.com/api/alpha/pdr/pes/contracts/v1.0/search');lstoFservicesettings.add(serviceSetting);
        ISL_Webservice_Config__c serviceSetting2 = new ISL_Webservice_Config__c(Name='SNIAPIAccessToken',
                                                                                Value__c='jdfskd');lstoFservicesettings.add(serviceSetting2);
        ISL_Webservice_Config__c serviceSetting3 = new ISL_Webservice_Config__c(Name='devFacetsGETProviderContracts',
                                                                                Value__c='https://gateway-stage.optum.com/api/alpha/pdr/pes/contracts/v1.0/search');lstoFservicesettings.add(serviceSetting3);
        
        insert lstoFservicesettings;
        
         Organization_Properties__c orgProps = Organization_Properties__c.getOrgDefaults();
        orgProps.OrganizationName__c = 'QA';
        Upsert orgProps;
        // Token API data
        WebserviceConfigurations__c tokenAPIWSConfig = ACET_WebserviceCalloutFramework_Test.createTokenWSConfigs('StarGateTokenAPI');
        OrgSpecificConfigurations__c tokenAPIOrgSpecificConfigs = ACET_WebserviceCalloutFramework_Test.createTokenOrgWSConfigs(tokenAPIWSConfig.Id);
        //WebserviceConfigurations__c authTokenWSConfig = ACET_WebserviceCalloutFramework_Test.createAuthTokenWSConfig('StarGateTokenAPI');

        // Service API data
        WebserviceConfigurations__c wsConfig = ACET_WebserviceCalloutFramework_Test.createWSConfig('FacetsGETProviderContracts', tokenAPIWSConfig.Id);
        OrgSpecificConfigurations__c orgSpecificConfigs = ACET_WebserviceCalloutFramework_Test.createOrgWSConfigs(wsConfig.Id);


    }
    
    static testmethod void testSucessScenario(){
        Test.startTest();
        Test.setMock(HttpCalloutMock.class, new SAEHttpCalloutMock.ACET_FacetsGETProviderContractsService200());
        ACET_FacetsGETProviderContractsService service = new ACET_FacetsGETProviderContractsService();
        service.getContractDetails('12321312321312312');
        ACET_ProviderContractSummaryController.processFacetsContractDataResult('12321312321312312');
        Test.setMock(HttpCalloutMock.class, new ACET_ViewPCPReferralMockResponse(400,true));
        service.getContractDetails('12321312321312312');
        ACET_ProviderContractSummaryController.processFacetsContractDataResult('12321312321312312');
        Test.stopTest();
    }
    static testmethod void testgetFacetsCSNContractsData(){
        Test.startTest();
        Test.setMock(HttpCalloutMock.class, new SAEHttpCalloutMock.CAndScontractsSuccessResponse());
        ACET_ProviderContractSummaryController.getFacetsCSNContractsData('123213','12312312312','12312312',true);
        Test.setMock(HttpCalloutMock.class, new ACET_ViewPCPReferralMockResponse(400,true));
        ACET_ProviderContractSummaryController.getFacetsCSNContractsData('123213','12312312312','12312312',true);
        Test.stopTest();
    }
}