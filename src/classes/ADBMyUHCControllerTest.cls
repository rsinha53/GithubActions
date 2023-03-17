@isTest
public class ADBMyUHCControllerTest {
    @testSetup static void setup() {
        Test.startTest();
        List<WebserviceConfigurations__c> configs = new List<WebserviceConfigurations__c>{
            new WebserviceConfigurations__c(Name = 'ADBMyUhcServiceEndpoint',recordtypeText__c = 'Token_API', Method__c = 'POST', Timeout__c = 10000)
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
    
     @isTest static void callMyUhcService(){
        String memberId = '916036407';
        String memDob = '05/01/1999';
        String memFirstName = 'Sharon';
        String memLastName = 'Thorman'; 
        String memberPolicy = '0911585';
        test.startTest();
        StaticResourceCalloutMock mock = new StaticResourceCalloutMock();
        mock.setStaticResource('ACETMyUHCMockResponse');
        mock.setStatusCode(200);
        // Set the mock callout mode
        Test.setMock(HttpCalloutMock.class, mock);
        ADBMyUHCController.callMyUhcService(memberId, memDob, memFirstName, memLastName, memberPolicy);
        test.stopTest();
    } 
     @isTest static void callMyUhcService2(){
        String memberId = '0054604377';
        String memDob = '05/03/1957';
        String memFirstName = 'Milton';
        String memLastName = 'Chow'; 
        String memberPolicy = '0710264';
        test.startTest();
        StaticResourceCalloutMock mock = new StaticResourceCalloutMock();
        mock.setStaticResource('ACETMyUHCNotRegMockResponse');
        mock.setStatusCode(200);
        // Set the mock callout mode
        Test.setMock(HttpCalloutMock.class, mock);
        ADBMyUHCController.callMyUhcService(memberId, memDob, memFirstName, memLastName, memberPolicy);
        test.stopTest();
    }
    @isTest static void  testADBMyUhcDetailsWrapper(){
        test.startTest();
        String val = '{"lastTimeMemberLoggedInsuccessfully":"06-22-2018","membersMyUhcRegistrationStatus":"DISABLED","responseStatusMessage":"Member information successfully found"}';
        ADBMyUhcDetailsWrapper.parse(val);
        test.stopTest();
    }
    
}