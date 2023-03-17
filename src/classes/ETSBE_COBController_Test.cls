@isTest
Public class ETSBE_COBController_Test{
    @testSetup static void setup() {
        ISL_Webservice_Config__c configObj = SAETestDataFactory.insertISLWebserviceConfig(
            SAEConstants.SAE_POLICYSEARCH_NAME,
            SAEConstants.SAE_POLICYSEARCH_COMMON_NAME,
            SAEConstants.SAE_POLICYSEARCH_ERRORLOG_ENABLED,
            SAEConstants.SAE_POLICYSEARCH_ISAVAILABLE,
            SAEConstants.SAE_POLICYSEARCH_ISLWEBSERVICE_EID,
            SAEConstants.SAE_POLICYSEARCH_PAGESIZE,
            SAEConstants.SAE_POLICYSEARCH_SCOPEHEADER_FLAG,
            SAEConstants.SAE_POLICYSEARCH_SERVICENAME,
            SAEConstants.SAE_POLICYSEARCH_VALUE
        );
        System.assertNotEquals(configObj, null);
        configObj = SAETestDataFactory.insertISLWebserviceConfig(
            SAEConstants.SAE_MEMBERPROVIDER_NAME,
            SAEConstants.SAE_POLICYSEARCH_COMMON_NAME,
            SAEConstants.SAE_POLICYSEARCH_ERRORLOG_ENABLED,
            SAEConstants.SAE_POLICYSEARCH_ISAVAILABLE,
            SAEConstants.SAE_POLICYSEARCH_ISLWEBSERVICE_EID,
            SAEConstants.SAE_POLICYSEARCH_PAGESIZE,
            !SAEConstants.SAE_POLICYSEARCH_SCOPEHEADER_FLAG,
            SAEConstants.SAE_MEMBERPROVIDER_SERVICENAME,
            SAEConstants.SAE_MEMBERPROVIDER_VALUE
        );
        System.assertNotEquals(configObj, null);

        TestDataFactory.createInteraction(); // Thanish - 8th October 2019
    }
    static testmethod void cobmethod(){
        Test.startTest();
        Test.setMock(HttpCalloutMock.class, new ETSBE_HttpCalloutMock.ETSBE_ExtendedCoverageWSMock());
        ETSBE_COBController.getCob(SAEConstants.SAE_POLICYSEARCH_TRANSACTION_ID);
        ETSBE_ExtendedCoverageWS exetendedservice = new ETSBE_ExtendedCoverageWS();
        exetendedservice.getPolicyWS(SAEConstants.SAE_POLICYSEARCH_TRANSACTION_ID);
        Test.stopTest();
    
    }

}