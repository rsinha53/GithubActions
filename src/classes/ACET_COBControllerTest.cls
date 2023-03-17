@isTest(seealldata=false)
private class ACET_COBControllerTest {
    
    @testsetup
    static void testsetupMethod() {
        Organization_Properties__c orgProps = Organization_Properties__c.getOrgDefaults();
        orgProps.OrganizationName__c = 'QA';
        Upsert orgProps;
        
        // Token API data
        WebserviceConfigurations__c tokenAPIWSConfig = ACET_WebserviceCalloutFramework_Test.createTokenWSConfigs('StarGateTokenAPI');
        OrgSpecificConfigurations__c tokenAPIOrgSpecificConfigs = ACET_WebserviceCalloutFramework_Test.createTokenOrgWSConfigs(tokenAPIWSConfig.Id);
        
        // Service API data
        WebserviceConfigurations__c wsConfig = ACET_WebserviceCalloutFramework_Test.createWSConfig('ADBLoyaltyEndpoint', tokenAPIWSConfig.Id);
        OrgSpecificConfigurations__c orgSpecificConfigs = ACET_WebserviceCalloutFramework_Test.createOrgWSConfigs(wsConfig.Id);
    }
    
    @isTest
    static void getENICOBResponseTest() {
        ACET_ReadConsumerEligibilityService.RCEDRequest requestParam = new ACET_ReadConsumerEligibilityService.RCEDRequest();
        requestParam.subscriberId = '00000000000000';
        requestParam.dateOfBirth = '12/12/2020';
        requestParam.firstName = 'test';
        requestParam.isSubscriber = true;
        requestParam.policyNumber = '0905509';
        requestParam.sourceCode = 'CS';
        Test.startTest();
        Test.setMock(HttpCalloutMock.class, new SAEHttpCalloutMock.ACET_ENICOBResponse());
        //Calling ENI Method
        SAECOBController.getENIData(requestParam);
        requestParam.firstName = 'WILLIAM';
        requestParam.dateOfBirth = '02/05/1950';
        requestParam.isSubscriber = false;
        SAECOBController.getENIData(requestParam);
        Test.stopTest();
    }
    
    @isTest
    static void getMNRCOBResponseTest() {
        //Inserting custom setting
        ACET_TestDataFactory.createWebServiceSetting('SNIAPIAccessToken', 'zwdsk9VPXJASohgqS2zqXD0UxD9MEa5g');
        ACET_TestDataFactory.createWebServiceSetting('dev_ORSEAIPToken', 'zwdsk9VPXJASohgqS2zqXD0UxD9MEa5g');
        //TOPS Encryption
        Tops_Encryption_Mappings__c topsEncryption = new Tops_Encryption_Mappings__c(EBCDIC__c='B', Char_1__c='0C', Char_2__c='37', 
                                                                                     Char_3__c='18', Char_4__c='17', Char_5__c='1C', 
                                                                                     Char_6__c='51', Char_7__c='45', Char_8__c='38');
        Insert topsEncryption;
        
        //Request body
        SAECOBController.COBRequest cobRequestInfo = new SAECOBController.COBRequest();
        cobRequestInfo.cosmosDiv = 'ATL';
        cobRequestInfo.dependentCode = '001';
        cobRequestInfo.effectiveDate = '2021-02-17';
        cobRequestInfo.groupNumber = '0012345';
        cobRequestInfo.subscriberId = '00123456789';
        
        Test.startTest();
        Test.setMock(HttpCalloutMock.class, new SAEHttpCalloutMock.ACET_MNRCOBResponse());
        //Calling MNR Method
        SAECOBController.getMNRData(cobRequestInfo);
        Test.stopTest();
    }
    
    @isTest
    static void getErrorCOBResponseTest() {
        //Inserting custom setting
        ACET_TestDataFactory.createWebServiceSetting('SNIAPIAccessToken', 'zwdsk9VPXJASohgqS2zqXD0UxD9MEa5g');
        ACET_TestDataFactory.createWebServiceSetting('dev_ORSEAIPToken', 'zwdsk9VPXJASohgqS2zqXD0UxD9MEa5g');
        //TOPS Encryption
        Tops_Encryption_Mappings__c	 topsEncryption = new Tops_Encryption_Mappings__c(EBCDIC__c='B', Char_1__c='0C', Char_2__c='37', 
                                                                                     Char_3__c='18', Char_4__c='17', Char_5__c='1C', 
                                                                                     Char_6__c='51', Char_7__c='45', Char_8__c='38');
        Insert topsEncryption;
        
        //Request body
        SAECOBController.COBRequest cobRequestInfo = new SAECOBController.COBRequest();
        cobRequestInfo.cosmosDiv = 'ATL';
        cobRequestInfo.dependentCode = '00';
        cobRequestInfo.effectiveDate = '2021-02-17';
        cobRequestInfo.groupNumber = '0012345';
        cobRequestInfo.subscriberId = '00123456789';
        
        ACET_ReadConsumerEligibilityService.RCEDRequest requestParam = new ACET_ReadConsumerEligibilityService.RCEDRequest();
        requestParam.subscriberId = '00000000000000';
        requestParam.dateOfBirth = '12/12/2020';
        requestParam.firstName = 'test';
        requestParam.isSubscriber = true;
        requestParam.policyNumber = '0905509';
        requestParam.sourceCode = 'CS';
		ACET_ReadConsumerEligibilityService.call_RCED_API(requestParam.subscriberId,requestParam.policyNumber,requestParam.sourceCode,'2',requestParam.dateOfBirth);
        ACET_ReadConsumerEligibilityService.createAppErrorLog_ORS('Sample','Sample','Sample','Sample',400,'Sample','Sample','Sample');
        Test.startTest();
        //Calling ENI Method
        SAECOBController.getENIData(requestParam);
        //Calling MNR Method
        SAECOBController.getMNRData(cobRequestInfo);
        Test.stopTest();
    }

    @isTest
    static void readCarrieComments_COM_Test() {
        //Request body
		Test.startTest();
        Test.setMock(HttpCalloutMock.class, new SAEHttpCalloutMock.ACET_ISETCOBResponse());
        ACET_ReadCarrierComments.invokeService('COMMERCIAL', '673', 'JAM', 'JAM', 'em', '123456789', '123456789');
        Test.stopTest();
    }

    @isTest
    static void readCarrieComments_MED_Test() {
        //Request body
		Test.startTest();
        Test.setMock(HttpCalloutMock.class, new SAEHttpCalloutMock.ACET_ISETCOBResponse_Medicare());
        ACET_ReadCarrierComments.invokeService('MEDICARE', '673', 'JAM', 'JAM', 'em', '123456789', '123456789');
        Test.stopTest();
    }

}