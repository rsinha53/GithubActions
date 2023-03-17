@isTest
public class ACET_ProviderStatusCtrlTest {
 
    @testSetup
    static void setupData() {
        // this is to add token for testing  (SAE_ProviderCardCtrl.getAuthToken())
        ISL_Webservice_Config__c islWebserviceConfig = new ISL_Webservice_Config__c();
        islWebserviceConfig.Name = 'SNIAPIAccessToken';
        islWebserviceConfig.Value__c = 'i9AvxmVh9vBMfvkOCBfIfG45y3Nb07vT';
        insert islWebserviceConfig;
         ISL_Webservice_Config__c webConfig = new ISL_Webservice_Config__c();
        webConfig.Name = 'dev_RCESNetworkKey';
        webConfig.Value__c = 'M';
        insert webConfig;
    }
    
    @isTest
    static void testGetMAndRProviderStatus() {
        System.runAs(ACET_TestDataFactory.getUser('Provider Service')) {
            Test.startTest();
            // Create the mock response
            StaticResourceCalloutMock mock = new StaticResourceCalloutMock();
            mock.setStaticResource('ACET_ProviderContractSummary_getAllContractsResponse');
            mock.setStatusCode(200);
            mock.setHeader('Content-Type', 'application/x-www-form-urlencoded');
            mock.setHeader('Accept', 'application/json');
            
            // Testing happy flow
            // adding additional params for getMAndRProviderStatus - US3244384 Integration for Member Div to Provider Div Mapping - Sarma - 01/03/2021
            Test.setMock(HttpCalloutMock.class, mock);
            ACET_ProviderStatusCtrl.getMAndRProviderStatus('000012763', '131623978', '001663941', 'cosDiv', 'cosPanel','startDate','endDate',''); //US3574032
            ACET_ProviderStatusCtrl.getEAndIProviderStatus('000012763', '131623978', '001663941', 'marketType', 'marketSite', 'insTypeCode', 'I');
            ACET_ProviderStatusCtrl.getEAndIProviderStatusNew('000012763', '131623978', '001663941', 'marketType', 'marketSite', 'insTypeCode', 'M','Choice Tier 1 IPA 001');
            SAE_PoliciesCtrl.getProviderCardStatus('000012763', '131623978', '001663941', 'marketType', 'marketSite', 'insTypeCode','Choice Tier 1 IPA 001');

            // Testing empty response flow
            mock.setStaticResource('ACET_ProviderContractSummary_EmptyResponse');
            Test.setMock(HttpCalloutMock.class, mock);
            ACET_ProviderStatusCtrl.getMAndRProviderStatus('000012763', '131623978', '001663941', 'cosDiv', 'cosPanel','startDate','endDate','');//US3574032
            ACET_ProviderStatusCtrl.getEAndIProviderStatus('000012763', '131623978', '001663941', 'marketType', 'marketSite', 'insTypeCode', 'I');
            ACET_ProviderStatusCtrl.getEAndIProviderStatusNew('000012763', '131623978', '001663941', 'marketType', 'marketSite', 'insTypeCode', 'M','Choice Tier 1 IPA 001');

            // Testing exception response flow
            mock.setStaticResource('ACET_ProviderContractSummary_ExceptionResponse');
            Test.setMock(HttpCalloutMock.class, mock);
            ACET_ProviderStatusCtrl.getMAndRProviderStatus('000012763', '131623978', '001663941', 'cosDiv', 'cosPanel','startDate','endDate','');//US3574032
            ACET_ProviderStatusCtrl.getEAndIProviderStatus('000012763', '131623978', '001663941', 'marketType', 'marketSite', 'insTypeCode', 'I');
            ACET_ProviderStatusCtrl.getEAndIProviderStatusNew('000012763', '131623978', '001663941', 'marketType', 'marketSite', 'insTypeCode', 'M','Choice Tier 1 IPA 001');

            // Testing bad status flow
            mock.setStaticResource('ACET_ProviderContractSummary_getAllContractsResponse');
            mock.setStatusCode(404);
            Test.setMock(HttpCalloutMock.class, mock);
            ACET_ProviderStatusCtrl.getMAndRProviderStatus('000012763', '131623978', '001663941', 'cosDiv', 'cosPanel','startDate','endDate','');//US3574032
            ACET_ProviderStatusCtrl.getEAndIProviderStatus('000012763', '131623978', '001663941', 'marketType', 'marketSite', 'insTypeCode', 'I');
            ACET_ProviderStatusCtrl.getEAndIProviderStatusNew('000012763', '131623978', '001663941', 'marketType', 'marketSite', 'insTypeCode', 'M','Choice Tier 1 IPA 001');
            ACET_ProviderStatusCtrl.getMockNetworkKey();
        	ACET_ProviderStatusCtrl.getNetworkKeyStatus('subscriberId', 'policyNumber', 'sourceCode', 'coverageLevel');
            
            Test.stopTest();
        }
    }

    @isTest
    static void testContractWrapper() {
        ACET_MAndRContractDataWrapper mn1 = new ACET_MAndRContractDataWrapper();
        ACET_MAndRContractDataWrapper.ACET_MAndRContractDetails mn2 = new ACET_MAndRContractDataWrapper.ACET_MAndRContractDetails();
        ACET_EAndIContractDataWrapper eni1 = new ACET_EAndIContractDataWrapper();
        ACET_EAndIContractDataWrapper.ACET_EAndIContractSummary eni2 = new ACET_EAndIContractDataWrapper.ACET_EAndIContractSummary();
    }

    @isTest
    static void testNetwokrString(){
        List<string> lstOfStrings = new List<string>{'Choice Network Tier 1-THR Preferred Hospitals IPA-901',
            'Choice Network Tier 1-THR Preferred Hospitals (IPA-901)','Choice Network Tier 1-THR Preferred Hospitals IPA/901','Choice Network Tier 1-THR Preferred Hospitals (IPA/901)',
            'Choice Network Tier 1-THR Preferred Hospitals IPA 901','Choice Network Tier 1-THR Preferred Hospitals (IPA 901)','Choice Network Tier 1-THR Preferred Hospitals IPA901',
            'Choice Network Tier 1-THR Preferred Hospitals (IPA901)','Choice Network Tier 1-THR Preferred Hospitals IPA-901, UHC Choice','Choice Network Tier 1-THR Preferred Hospitals (IPA-901), UHC Choice',
            'Choice Network Tier 1-THR Preferred Hospitals IPA/901, UHC Choice','Choice Network Tier 1-THR Preferred Hospitals (IPA/901), UHC Choice',
            'Choice Network IPA Test Tier 1-THR Preferred Hospitals IPA 901','Choice Network IPA Test Tier 1-THR Preferred Hospitals IPA 901, UHC Choice'};
                for(string st: lstOfStrings){
                    st = ACET_ProviderStatusCtrl.processIPAString(st);
                    system.assertEquals(Integer.valueof(st),901);
                }
                //US3767751
        for(string st2: lstOfStrings){
            st2 = ACET_ProviderLookupDetailController.getIPAValue(st2);
            system.assertEquals(Integer.valueof(st2),901);
        }

    }
}