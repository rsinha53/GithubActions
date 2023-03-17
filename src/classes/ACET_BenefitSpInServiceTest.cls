@isTest
public class ACET_BenefitSpInServiceTest {
    
     public class BenefitSpInMock200 implements HttpCalloutMock {
        public  HTTPResponse respond(HTTPRequest request) {
            HttpResponse response = new HttpResponse();
            response.setBody('{"result":[{"procedureCode":"62321","paStatus":"MAY BE","productType":"RIVER VALLEY","effectiveDate":"Archive: Dates of Services  1/1/2021-1/7/2021","description":null,"dataSource":"HTML","specialInstructions":[{"key":"html","data":"test"}],"remarks":""}]}');
            response.setStatusCode(200);
            return response;
        }
    }

    
    @testSetup static void createTestData() {
         Organization_Properties__c orgProps = Organization_Properties__c.getOrgDefaults();
        orgProps.OrganizationName__c = 'QA';
        Upsert orgProps;
        // Token API data
        WebserviceConfigurations__c tokenAPIWSConfig = ACET_WebserviceCalloutFramework_Test.createTokenWSConfigs('StarGateTokenAPI');
        OrgSpecificConfigurations__c tokenAPIOrgSpecificConfigs = ACET_WebserviceCalloutFramework_Test.createTokenOrgWSConfigs(tokenAPIWSConfig.Id);
        
        // Service API data
        WebserviceConfigurations__c wsConfig = ACET_WebserviceCalloutFramework_Test.createWSConfig('BenefitSpecialInstructions', tokenAPIWSConfig.Id);
        OrgSpecificConfigurations__c orgSpecificConfigs = ACET_WebserviceCalloutFramework_Test.createOrgWSConfigs(wsConfig.Id);
        
         WebserviceConfigurations__c wsConfig2 = ACET_WebserviceCalloutFramework_Test.createWSConfig('BenefitCheckClaim', tokenAPIWSConfig.Id);
        OrgSpecificConfigurations__c orgSpecificConfigs2 = ACET_WebserviceCalloutFramework_Test.createOrgWSConfigs(wsConfig2.Id);
        
        
    }
    static testmethod void SpInTest(){
        ACET_BenefitSpInService.BenefitSIReq req = new ACET_BenefitSpInService.BenefitSIReq();
        SAEUtils.spInsInp inpR = new SAEUtils.spInsInp();

        Test.startTest();
        
        Test.setMock(HttpCalloutMock.class, new ACET_ViewPCPReferralMockResponse(400,true));
        ACET_BenefitSpInService.callBenfitSpInService(req);
        
        Test.setMock(HttpCalloutMock.class, new BenefitSpInMock200());
        SAEUtils.getSPInsString(inpR);
        
        Test.setMock(HttpCalloutMock.class, new ACET_ViewPCPReferralMockResponse(500,true));
        ACET_BenefitSpInService.callBenfitSpInService(req);
        Test.stopTest();
    }
    
    static testmethod void BenefitCheckTest(){
        ACET_BenefitCheckRequest req = new ACET_BenefitCheckRequest();
        StaticResource response = [SELECT Id, Body FROM StaticResource WHERE Name = 'ACET_BenefitCheck_Request' LIMIT 1];
        Test.startTest();
        
        Test.setMock(HttpCalloutMock.class, new ACET_ViewPCPReferralMockResponse(400,true));
        ACET_BenefitCheckController.getBenefitCheckData(response.body.toString());

        StaticResourceCalloutMock mock = new StaticResourceCalloutMock();
        mock.setStaticResource('ACET_BenefitCheck_Response');
        mock.setStatusCode(200);
        mock.setHeader('Content-Type', 'application/json');
        Test.setMock(HttpCalloutMock.class, mock);
        
        ACET_BenefitCheckController.getBenefitCheckData(response.body.toString());

        
        Test.setMock(HttpCalloutMock.class, new ACET_ViewPCPReferralMockResponse(500,true));
        ACET_BenefitCheckController.getBenefitCheckData(response.body.toString());
        Test.stopTest();
    }
}