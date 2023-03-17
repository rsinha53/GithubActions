@isTest
public class ADBRepeatCallControllerTest {
    @testSetup static void setup() {
        Test.startTest();
        List<WebserviceConfigurations__c> configs = new List<WebserviceConfigurations__c>{
            new WebserviceConfigurations__c(Name = 'ADBRepeatCallerEndpoint',recordtypeText__c = 'Token_API', Method__c = 'POST', Timeout__c = 10000)
                };
                    insert configs;
        
        List<OrgSpecificConfigurations__c> orgConfigs = new List<OrgSpecificConfigurations__c>{
            new OrgSpecificConfigurations__c(WebserviceConfigurations__c = configs[0].Id,recordtypeText__c = 'TokenAPI', Name = 'QA', EndpointDomain__c = 'https://gateway-stage.optum.com/api/stage/ccs/cm/v1/gate-results')
                };
                    insert orgConfigs;
        
        Organization_Properties__c property = new Organization_Properties__c(OrganizationName__c = 'QA');
        insert property;
        Test.stopTest();
    }
    @isTest static void testRepeatCaller(){
        String reqBody = '{"_Request": "script:ACET_Dashboard_RepeatCaller",'+
            '"_ENT_ContactFirstNm": "Jessic",'+
            '"_ENT_ContactLastNm": "Dupas",'+
            '"_ENT_ContactConstituentID": "12345656789",'+
            '"_ENT_ContactDOB": "1991-01-01"}';

        test.startTest();
        StaticResourceCalloutMock mock = new StaticResourceCalloutMock();
        mock.setStaticResource('ADBRepeatCallerMock');
        mock.setStatusCode(200);
        // Set the mock callout mode
        Test.setMock(HttpCalloutMock.class, mock);
        ADBRepeatCallController.getRepeatCallerInfo(reqBody);

        test.stopTest();
    }
}