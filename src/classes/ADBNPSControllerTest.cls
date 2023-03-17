@isTest
public class ADBNPSControllerTest {
    @testSetup static void setup() {
        Test.startTest();
        List<WebserviceConfigurations__c> configs = new List<WebserviceConfigurations__c>{
            new WebserviceConfigurations__c(Name = 'ADBNPSEndpoint',recordtypeText__c = 'Token_API', Method__c = 'POST', Timeout__c = 10000)
                };
                    insert configs;
        
        List<OrgSpecificConfigurations__c> orgConfigs = new List<OrgSpecificConfigurations__c>{
            new OrgSpecificConfigurations__c(WebserviceConfigurations__c = configs[0].Id,recordtypeText__c = 'TokenAPI', Name = 'QA', EndpointDomain__c = 'https://gateway-stage.optum.com')
                };
                    insert orgConfigs;
        
        Organization_Properties__c property = new Organization_Properties__c(OrganizationName__c = 'QA');
        insert property;
        Test.stopTest();
    }
    
    @isTest static void testcallNPSService (){
        String memberId = '474706605';
        test.startTest();
        StaticResourceCalloutMock mock = new StaticResourceCalloutMock();
        mock.setStaticResource('NPSMockResponse_909546670');
        mock.setStatusCode(200);
        // Set the mock callout mode
        Test.setMock(HttpCalloutMock.class, mock);
        ADBNPSController.callNPSService(memberId);
        test.stopTest(); 
    } 
    
    @isTest static void testcallNPSService2 (){
        String memberId = '474706605';
        test.startTest();
        StaticResourceCalloutMock mock = new StaticResourceCalloutMock();
        mock.setStaticResource('NPSMockResponse_178504598');
        mock.setStatusCode(200);
        // Set the mock callout mode
        Test.setMock(HttpCalloutMock.class, mock);
        ADBNPSController.callNPSService(memberId);
        test.stopTest(); 
    }
    
    @isTest static void  testADBNPSDetailsWrapper(){
        test.startTest();
        String val = '{"rowIndexId":7741057,"callTimestamp":"2022-08-19T13:41:28.190+0000","memberId":"110423706","policyNumber":"0196484","npsResult":"HU","callQualityResult":null,"issueResolutionResult":null},{"rowIndexId":2396067,"callTimestamp":"2020-02-26T14:16:55.027+0000","memberId":"110423706","policyNumber":"0196484","npsResult":"HU","callQualityResult":null,"issueResolutionResult":null},{"rowIndexId":1073362,"callTimestamp":"2019-11-19T13:36:31.520+0000","memberId":"110423706       ","policyNumber":"0196484","npsResult":"10","callQualityResult":"10","issueResolutionResult":"9"},{"rowIndexId":1026442,"callTimestamp":"2019-11-05T16:37:44.563+0000","memberId":"11042370 ","policyNumber":"0196484","npsResult":"HU","callQualityResult":null,"issueResolutionResult":null} ';
        ADBNPSDetailsWrapper.parse(val);
        test.stopTest();
    }
    
    @isTest static void testgetNPSIcon1 (){
    	test.startTest();
        List<String> iconData = ADBNPSController.getNPSIcon('9');
        test.stopTest();
    }
    
    @isTest static void testgetNPSIcon2 (){
    	test.startTest();
        List<String> iconData = ADBNPSController.getNPSIcon('');
        test.stopTest();
    }
    
}