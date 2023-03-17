@isTest
global class MOTION_MemberAPIServiceControllerTest {
    
    @TestSetup 
    private static void testSetupMethod() {
        Organization_Properties__c orgProps = Organization_Properties__c.getOrgDefaults();
        orgProps.OrganizationName__c = 'QA';
        Upsert orgProps;
        
        // Token API data
        WebserviceConfigurations__c tokenAPIWSConfig = ACET_WebserviceCalloutFramework_Test.createTokenWSConfigs('MotionAccessTokenAPI');
        OrgSpecificConfigurations__c tokenAPIOrgSpecificConfigs = ACET_WebserviceCalloutFramework_Test.createTokenOrgWSConfigs(tokenAPIWSConfig.Id);
        WebserviceConfigurations__c authTokenWSConfig = ACET_WebserviceCalloutFramework_Test.createAuthTokenWSConfig('MotionAccessTokenAPI');

        // Service API data
        WebserviceConfigurations__c wsbasicConfig = ACET_WebserviceCalloutFramework_Test.createWSConfig('Motion_DERM_BasicSearchAPI', tokenAPIWSConfig.Id);
        OrgSpecificConfigurations__c orgSpecificBConfigs = ACET_WebserviceCalloutFramework_Test.createOrgWSConfigs(wsbasicConfig.Id);
        
        WebserviceConfigurations__c wsadvConfig = ACET_WebserviceCalloutFramework_Test.createWSConfig('Motion_DERM_AdvancedSearchAPI', tokenAPIWSConfig.Id);
        OrgSpecificConfigurations__c orgSpecificAConfigs = ACET_WebserviceCalloutFramework_Test.createOrgWSConfigs(wsadvConfig.Id);

        WebserviceConfigurations__c wsdetailConfig = ACET_WebserviceCalloutFramework_Test.createWSConfig('Motion_DERM_MemberDetailAPI', tokenAPIWSConfig.Id);
        OrgSpecificConfigurations__c orgSpecificDConfigs = ACET_WebserviceCalloutFramework_Test.createOrgWSConfigs(wsdetailConfig.Id);

        WebserviceConfigurations__c wsplanConfig = ACET_WebserviceCalloutFramework_Test.createWSConfig('Motion_DERM_PlanWaiverAPI', tokenAPIWSConfig.Id);
        OrgSpecificConfigurations__c orgSpecificPConfigs = ACET_WebserviceCalloutFramework_Test.createOrgWSConfigs(wsplanConfig.Id);
        
        WebserviceConfigurations__c wsconsConfig = ACET_WebserviceCalloutFramework_Test.createWSConfig('Motion_CONSOLE_API', tokenAPIWSConfig.Id);
        OrgSpecificConfigurations__c orgSpecificCConfigs = ACET_WebserviceCalloutFramework_Test.createOrgWSConfigs(wsconsConfig.Id);
    }

    @isTest
    private static void basicSearchMemberServiceTest(){
        Test.startTest();
        Test.setMock(HttpCalloutMock.class, new MotionAPIServiceFrameworkMock(200));
        HttpResponse res = MOTION_MemberAPIServiceController.basicSearchMemberService('Email', 'AARON', 'ABBOTT', '01/07/1938', '1');
        String contentType = res.getHeader('Content-Type');
        System.assert(contentType == 'application/json');
        System.assertEquals('{"firstName": "dev"}', res.getBody());
        System.assertEquals(200, res.getStatusCode());

        Test.setMock(HttpCalloutMock.class, new MotionAPIServiceFrameworkMock(401));
        HttpResponse res1 = MOTION_MemberAPIServiceController.basicSearchMemberService('Email', 'AARON', 'ABBOTT', '01/07/1938', '1');
		System.assertEquals(401, res1.getStatusCode());
        Test.stopTest();
    }
    
    @isTest
    private static void advanceSearchMemberServiceTest(){
        Test.startTest();
        Test.setMock(HttpCalloutMock.class, new MotionAPIServiceFrameworkMock(200));
        HttpResponse res = MOTION_MemberAPIServiceController.advanceSearchMemberService('Email', 'AARON', 'ABBOTT', '01/07/1938','aaronabbott@uhctesttest.com','145028','AutoCG_test_TCDPANG_HSA_ACIS001','Active','4534554', '1');        																									
        String contentType = res.getHeader('Content-Type');
        System.assert(contentType == 'application/json');
        System.assertEquals('{"firstName": "dev"}', res.getBody());
        System.assertEquals(200, res.getStatusCode());

        Test.setMock(HttpCalloutMock.class, new MotionAPIServiceFrameworkMock(401));
        HttpResponse res1 = MOTION_MemberAPIServiceController.advanceSearchMemberService('Email', 'AARON', 'ABBOTT', '01/07/1938','aaronabbott@uhctesttest.com','145028','AutoCG_test_TCDPANG_HSA_ACIS001','Active','4534554', '1');        																									
		System.assertEquals(401, res1.getStatusCode());
        Test.stopTest();
    }
    
    @isTest
    private static void memberDetailServiceTest(){
        Test.startTest();
        Test.setMock(HttpCalloutMock.class, new MotionAPIServiceFrameworkMock(200));
        HttpResponse res = MOTION_MemberAPIServiceController.memberDetailService('4534554', '4534554');        																									
        String contentType = res.getHeader('Content-Type');
        System.assert(contentType == 'application/json');
        System.assertEquals('{"firstName": "dev"}', res.getBody());
        System.assertEquals(200, res.getStatusCode());

        Test.setMock(HttpCalloutMock.class, new MotionAPIServiceFrameworkMock(401));
        HttpResponse res1 = MOTION_MemberAPIServiceController.memberDetailService('4534554', '4534554');        																									
		System.assertEquals(401, res1.getStatusCode());
        Test.stopTest();
    }
    
    @isTest
    private static void memberDetailMedicalwaiverServiceTest(){
        Test.startTest();
        Test.setMock(HttpCalloutMock.class, new MotionAPIServiceFrameworkMock(200));
        HttpResponse res = MOTION_MemberAPIServiceController.memberDetailMedicalwaiverService('4534554', '1');        																									
        String contentType = res.getHeader('Content-Type');
        System.assert(contentType == 'application/json');
        System.assertEquals('{"firstName": "dev"}', res.getBody());
        System.assertEquals(200, res.getStatusCode());

        Test.setMock(HttpCalloutMock.class, new MotionAPIServiceFrameworkMock(401));
        HttpResponse res1 = MOTION_MemberAPIServiceController.memberDetailMedicalwaiverService('4534554', '1');        																									
		System.assertEquals(401, res1.getStatusCode());
        Test.stopTest();
    }
    
    @isTest
    private static void streamLineConsoleForDeviceInfoTest(){
        Test.startTest();
        Test.setMock(HttpCalloutMock.class, new MotionAPIServiceFrameworkMock(200));
        HttpResponse res = MOTION_MemberAPIServiceController.streamLineConsoleForDeviceInfo('4534554');        																									
        String contentType = res.getHeader('Content-Type');
        System.assert(contentType == 'application/json');
        System.assertEquals('{"firstName": "dev"}', res.getBody());
        System.assertEquals(200, res.getStatusCode());

        Test.setMock(HttpCalloutMock.class, new MotionAPIServiceFrameworkMock(401));
        HttpResponse res1 = MOTION_MemberAPIServiceController.streamLineConsoleForDeviceInfo('4534554');        																									
		System.assertEquals(401, res1.getStatusCode());
        Test.stopTest();
    }
    
    @isTest
    private static void ACET_GetAuthTokenBatchScheduler_Test() {
        Test.startTest();
        Test.setMock(HttpCalloutMock.class, new MotionAPIServiceFrameworkMock(200));
        ACET_GetAuthTokenBatchScheduler scheduler = new ACET_GetAuthTokenBatchScheduler(); 
        String sch ='0 30 * * * ?'; 
        System.schedule('ACET Motion Scheduler', sch,scheduler);
        Test.stopTest();
    }

    global class MotionAPIServiceFrameworkMock implements HttpCalloutMock {
        public Integer statusCode;
        
        public MotionAPIServiceFrameworkMock(Integer statusCode) {
            this.statusCode = statusCode;
        }
        global HTTPResponse respond(HTTPRequest request) {
            HttpResponse response = new HttpResponse();
            response.setHeader('Content-Type', 'application/json');
            response.setBody('{"firstName": "dev"}');
            response.setStatusCode(statusCode);
            response.setStatus('status');
            return response; 
        }
    }
    
}