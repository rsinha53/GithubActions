@isTest
public class ACET_ViewPCPReferralsCtrlTest {
    
    @testSetup static void testSetupMethod() {
         ISL_Webservice_Config__c webConfig = new ISL_Webservice_Config__c();
        webConfig.Name = 'dev_ViewPCPReferrals';
        webConfig.Value__c = 'https://api-gateway-stage.linkhealth.com/rlink-extended/api/referralStatus/v1.0';
        insert webConfig;
        Organization_Properties__c orgProps = Organization_Properties__c.getOrgDefaults();
        orgProps.OrganizationName__c = 'QA';
        Upsert orgProps;
        // Token API data
        WebserviceConfigurations__c tokenAPIWSConfig = ACET_WebserviceCalloutFramework_Test.createTokenWSConfigs('LinkServiceTokenAPI');
        OrgSpecificConfigurations__c tokenAPIOrgSpecificConfigs = ACET_WebserviceCalloutFramework_Test.createTokenOrgWSConfigs(tokenAPIWSConfig.Id);
        //WebserviceConfigurations__c authTokenWSConfig = ACET_WebserviceCalloutFramework_Test.createAuthTokenWSConfig('StarGateTokenAPI');

        // Service API data
        WebserviceConfigurations__c wsConfig = ACET_WebserviceCalloutFramework_Test.createWSConfig('LinkViewPCPReferrals', tokenAPIWSConfig.Id);
        OrgSpecificConfigurations__c orgSpecificConfigs = ACET_WebserviceCalloutFramework_Test.createOrgWSConfigs(wsConfig.Id);

         WebserviceConfigurations__c wsConfig2 = ACET_WebserviceCalloutFramework_Test.createWSConfig('SNIWebService',tokenAPIWSConfig.Id);
        OrgSpecificConfigurations__c orgSpecificConfigs2 = ACET_WebserviceCalloutFramework_Test.createOrgWSConfigs(wsConfig2.Id);
    }
    
    public static testmethod void successscenario(){
        Test.setMock(HttpCalloutMock.class, new ACET_ViewPCPReferralMockResponse(200,false));
        Test.startTest();
        ACET_ViewPCPReferralsService.ACET_ViewPCPReferralsRequest req = new ACET_ViewPCPReferralsService.ACET_ViewPCPReferralsRequest();
        req.memberId = '823189694';
        req.policyNumber = '708547';
        req.dateOfBirth = '1999-05-03';
        req.firstName = 'VERONICA';
        req.firstDateOfService = '2020-01-01';
        req.lastDateOfService ='2020-12-31';
        req.payerId='87726';
        req.allOff = '1';
        req.newReferralNumber = '51213';
        ACET_ViewPCPReferrralsCtrl.getPolicyInfo(req);
        ACET_ViewPCPReferrralsCtrl.getSAEReferralEntryReasonCodes('AP');
        ACET_ViewPCPReferrralsCtrl.getACETReferralDisplayMessages('CO','No','PCP on file is incorrect');
        ACET_ViewPCPReferrralsCtrl.getACETReferralDisplayMessages('CO','No','');
        Test.stopTest();
    }
    
    public static testmethod void failedscenario(){
        Test.setMock(HttpCalloutMock.class, new ACET_ViewPCPReferralMockResponse(400,true));
        Test.startTest();
        ACET_ViewPCPReferralsService.ACET_ViewPCPReferralsRequest req = new ACET_ViewPCPReferralsService.ACET_ViewPCPReferralsRequest();
        req.memberId = '823189694';
        req.policyNumber = '708547';
        req.dateOfBirth = '1999-05-03';
        req.firstName = 'VERONICA';
        req.firstDateOfService = '2020-01-01';
        req.lastDateOfService ='2020-12-31';
        req.payerId='87726';
        req.allOff = '1';
        ACET_ViewPCPReferrralsCtrl.getPolicyInfo(req);
        Test.stopTest();
    }

    public static testmethod void SNIWebserviceSuccess(){
        Test.startTest();
        Test.setMock(HttpCalloutMock.class, new ACET_ViewPCPReferralMockResponse(400,true));
        SAEPolicyDetailsController.getMarketTypeCode('63','CS','test');
        SAEPolicyDetailsController.getMarketTypeCode('99','CO','test');
        SAEPolicyDetailsController.getMarketTypeCode('99','CS','test');

        Test.setMock(HttpCalloutMock.class, new SAEHttpCalloutMock.ACET_SNIWebService200());
         SAEPolicyDetailsController.getMarketTypeCode('63','CS','test');
ACET_ViewPCPReferrralsCtrl.getclaimProviderLookupResults('111111111', '111111111', '111111111', 'P', 'ABC', 'TestProvider', 'TestProvider', 'AZ', '54345', '5', 'Y', 'Y', 'Y', 'Y', 'Y', '123', '1234', 'PC', 'MR', 0, 50, true, 'All', '00222', '76', '01', '01', 'PS1', 'E',false, 'CO');		
        Test.stopTest();
    }


}