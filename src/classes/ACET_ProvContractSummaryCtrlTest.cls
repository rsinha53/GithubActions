@isTest
public class ACET_ProvContractSummaryCtrlTest {

    @testSetup
    static void setupData() {
        // this is to add token for testing  (SAE_ProviderCardCtrl.getAuthToken())
        ISL_Webservice_Config__c islWebserviceConfig = new ISL_Webservice_Config__c();
        islWebserviceConfig.Name = 'SNIAPIAccessToken';
        islWebserviceConfig.Value__c = 'i9AvxmVh9vBMfvkOCBfIfG45y3Nb07vT';
        insert islWebserviceConfig;
    }

    // Krishnanshu - test - getAllContractsData
    @isTest
    static void testGetAllContractsData() {
        System.runAs(ACET_TestDataFactory.getUser('Provider Service')) {
            Test.startTest();
            // Create the mock response
            StaticResourceCalloutMock mock = new StaticResourceCalloutMock();
            mock.setStaticResource('ACET_ProviderContractSummary_getAllContractsResponse');
            mock.setStatusCode(200);
            mock.setHeader('Content-Type', 'application/x-www-form-urlencoded');
            mock.setHeader('Accept', 'application/json');

            // Testing happy flow
            Test.setMock(HttpCalloutMock.class, mock);
            Map<String, ACET_ProviderContractSummaryController.ContractTable> allContractsTable = ACET_ProviderContractSummaryController.getAllContracts('000012763', '131623978', '001663941', '001663941');
            System.assertNotEquals(null, allContractsTable, 'The callout returned a null response.');

            // Testing empty response flow
            mock.setStaticResource('ACET_ProviderContractSummary_EmptyResponse');
            Test.setMock(HttpCalloutMock.class, mock);
            allContractsTable = ACET_ProviderContractSummaryController.getAllContracts('000012763', '131623978', '001663941', '001663941');

            // Testing exception response flow
            mock.setStaticResource('ACET_ProviderContractSummary_ExceptionResponse');
            Test.setMock(HttpCalloutMock.class, mock);
            allContractsTable = ACET_ProviderContractSummaryController.getAllContracts('000012763', '131623978', '001663941', '001663941');

            // Testing bad status flow
            mock.setStaticResource('ACET_ProviderContractSummary_getAllContractsResponse');
            mock.setStatusCode(404);
            Test.setMock(HttpCalloutMock.class, mock);
            allContractsTable = ACET_ProviderContractSummaryController.getAllContracts('000012763', '131623978', '001663941', '001663941');

            Test.stopTest();
        }
    }
}