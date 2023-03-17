@isTest
public class ADBMyFollowUpsControllerTest {
    
    @testSetup static void setup() {
        Test.startTest();
        List<WebserviceConfigurations__c> configs = new List<WebserviceConfigurations__c>{
            new WebserviceConfigurations__c(Name = 'ADBMyFollowupsSelectWorkloadList',recordtypeText__c = 'Token_API', Method__c = 'POST', Timeout__c = 10000),
                new WebserviceConfigurations__c(Name = 'ORSMyFollowupsSelectWorkloadList',recordtypeText__c = 'Token_API', Method__c = 'POST', Timeout__c = 10000)
        };
        insert configs;
        
        List<OrgSpecificConfigurations__c> orgConfigs = new List<OrgSpecificConfigurations__c>{
            new OrgSpecificConfigurations__c(WebserviceConfigurations__c = configs[0].Id,recordtypeText__c = 'TokenAPI', Name = 'QA', EndpointDomain__c = 'https://gateway-stage.optum.com'),
                new OrgSpecificConfigurations__c(WebserviceConfigurations__c = configs[1].Id,recordtypeText__c = 'TokenAPI', Name = 'QA', EndpointDomain__c = 'https://gateway-stage.optum.com')
       };
        insert orgConfigs;
        
        Organization_Properties__c property = new Organization_Properties__c(OrganizationName__c = 'QA');
        insert property;
        
       
          Test.stopTest();
    }
    
     @isTest static void testGetMyFollowupsWorkloadList(){
       	String logonId = 'SK8';
        String officeId = '673';
        test.startTest();
        StaticResourceCalloutMock mock = new StaticResourceCalloutMock();
        mock.setStaticResource('ADBMyFollowUpsWorkloadListResponse');
        mock.setStatusCode(200);
        // Set the mock callout mode
        Test.setMock(HttpCalloutMock.class, mock);
        ADBMyFollowUpsController.getMyFollowupsWorkloadList(logonId,officeId);
        test.stopTest();
    }

}