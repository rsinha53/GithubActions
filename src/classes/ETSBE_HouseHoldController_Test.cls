@isTest
public class ETSBE_HouseHoldController_Test {
    
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
        TTS_Access__c ttsObj = SAETestDataFactory.createTTSAccess(
            SAEConstants.TA_TOPIC,
            SAEConstants.TA_TYPE,
            SAEConstants.TA_SUBTYPE,
            SAEConstants.TA_PERMISSION
        );
    }
    
    static testMethod void test_getHouseHoldData() {
        Test.startTest();
        Test.setMock(HttpCalloutMock.class, new SAEHttpCalloutMock.SAEExtendedCoverageWSMock());
        ETSBE_HouseHoldController.SearchResultWrapper responseData = ETSBE_HouseHoldController.getHouseHoldMembers(SAEConstants.SAE_POLICYSEARCH_TRANSACTION_ID);       
        Test.stopTest();
    }

}