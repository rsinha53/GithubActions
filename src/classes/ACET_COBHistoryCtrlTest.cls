@isTest(seealldata=false)
private class ACET_COBHistoryCtrlTest {
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
    static testmethod void getCOBHistoryMNRTest(){
        //Inserting custom setting
        ACET_TestDataFactory.createWebServiceSetting('SNIAPIAccessToken', 'zwdsk9VPXJASohgqS2zqXD0UxD9MEa5g');
        ACET_TestDataFactory.createWebServiceSetting('dev_ORSEAIPToken', 'zwdsk9VPXJASohgqS2zqXD0UxD9MEa5g');
        //TOPS Encryption
        Tops_Encryption_Mappings__c topsEncryption = new Tops_Encryption_Mappings__c(EBCDIC__c='B', Char_1__c='0C', Char_2__c='37', 
                                                                                     Char_3__c='18', Char_4__c='17', Char_5__c='1C', 
                                                                                     Char_6__c='51', Char_7__c='45', Char_8__c='38');
        Insert topsEncryption;
        
        ACET_COBHistoryCtrl.COBHistoryRequest request = new ACET_COBHistoryCtrl.COBHistoryRequest();
        request.cosmosDivision = 'ATL';
        request.dependentCode = '001';
        request.effectiveDate = '2021-02-17';
        request.groupNumber = '0012345';
        request.subscriberId = '00123456789';
        request.medicareType = 'a';
        request.medicareEntReason = 'b';
        // testing good flow
        test.setMock(HttpCalloutMock.class, new SAEHttpCalloutMock.ACET_MNRCOBResponse());
        test.startTest();
        ACET_COBHistoryCtrl.getCOBHistoryMNR(request);
        test.stopTest();
    }
    // getCOBCommentsENI
    static testmethod void getCOBCommentsENITest(){
        Per_User_Credentials__c user = new Per_User_Credentials__c();
        user.UserName__c = '000005307';
        user.Password__c = 'Feb2021!';
        insert user;
        String sysName = 'ACU1';
        String empId = '464910134';
        String policyId = '1W4576';
        // testing good flow
        test.setMock(HttpCalloutMock.class, new SAEHttpCalloutMock.ACET_getCOBCommentsENIResponse_Commercial());
        test.startTest();
        ACET_COBHistoryCtrl.getCOBCommentsENI(sysName, empId, policyId);
        test.setMock(HttpCalloutMock.class, new SAEHttpCalloutMock.ACET_getCOBCommentsENIResponse_Medicare());
        ACET_COBHistoryCtrl.getCOBCommentsENI(sysName, empId, policyId);
        test.setMock(HttpCalloutMock.class, new SAEHttpCalloutMock.ACET_MNRCOBResponse());
        ACET_COBHistoryCtrl.getCOBCommentsENI(sysName, empId, policyId);
        test.stopTest();
    }
}