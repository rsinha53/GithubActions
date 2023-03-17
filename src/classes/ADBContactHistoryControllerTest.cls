/**
* Author: Madhura Priyadarshana
* Description : Test class for ADBContactHistoryController
* Date Created: 01/15/2020
*/
@isTest
public class ADBContactHistoryControllerTest {

    @testSetup
    static void setpTestData(){
        Test.startTest();
        List<WebserviceConfigurations__c> configs = new List<WebserviceConfigurations__c>{
            new WebserviceConfigurations__c(Name = 'ADBMemEngagementHistoryEndpoint',recordtypeText__c = 'Token_API', Method__c = 'POST', Timeout__c = 10000),
            new WebserviceConfigurations__c(Name = 'ADBMemEngagementDetailsEndpoint',recordtypeText__c = 'Token_API', Method__c = 'POST', Timeout__c = 10000),
            new WebserviceConfigurations__c(Name = 'ADBMemEngagementNotesEndpoint',recordtypeText__c = 'Token_API', Method__c = 'GET', Timeout__c = 10000)
        };
        insert configs;
        
        List<OrgSpecificConfigurations__c> orgConfigs = new List<OrgSpecificConfigurations__c>{
            new OrgSpecificConfigurations__c(WebserviceConfigurations__c = configs[0].Id,recordtypeText__c = 'TokenAPI', Name = 'QA', EndpointDomain__c = 'https://gateway-stage.optum.com/api/bravo/clin/icue/engagements/v4/getMemberEngagementHistory'),
            new OrgSpecificConfigurations__c(WebserviceConfigurations__c = configs[1].Id,recordtypeText__c = 'TokenAPI', Name = 'QA', EndpointDomain__c = 'https://gateway-stage.optum.com/api/bravo/clin/icue/engagements/v4/getMemberEngagementDetails'),
            new OrgSpecificConfigurations__c(WebserviceConfigurations__c = configs[2].Id,recordtypeText__c = 'TokenAPI', Name = 'QA', EndpointDomain__c = 'https://gateway-stage.optum.com/api/bravo/clin/icue/notes/v2/engagementnotes')
        };
        insert orgConfigs;
        
        Organization_Properties__c property = new Organization_Properties__c(OrganizationName__c = 'QA');
        insert property;
        Test.stopTest();
    }
    
    @isTest static void testHistoryAPI(){
        Test.startTest();
        //	Error flow
        ADBMemEngagementUIWrapper histories = ADBContactHistoryController.getMemEngagementHistory('0345678');
        System.assert(String.isNotBlank(histories.systemErrorMsg));
        
        //	Success flow
        StaticResourceCalloutMock mock = new StaticResourceCalloutMock();
        mock.setStaticResource('ADBMemberEngagementHistoryMock');
        mock.setStatusCode(200);
        // Set the mock callout mode
        Test.setMock(HttpCalloutMock.class, mock);
        histories = ADBContactHistoryController.getMemEngagementHistory('0345678');
        System.assert(String.isBlank(histories.systemErrorMsg));
        
        //	service error flow
		mock.setStatusCode(500);
        histories = ADBContactHistoryController.getMemEngagementHistory('0345678');
        Test.stopTest();
    }
    
    @isTest static void testDetailAPI(){
        //	Error flow
        ADBMemEngagementDetailsWrapper details = ADBContactHistoryController.getMemEngagementDetails('0345678');
        System.assert(String.isNotBlank(details.systemErrorMsg));
        
        //	Success flow
        StaticResourceCalloutMock mock = new StaticResourceCalloutMock();
        mock.setStaticResource('ADBMemberEngagementDetailMock');
        mock.setStatusCode(200);

		Test.startTest();
        Test.setMock(HttpCalloutMock.class, mock);

        details = ADBContactHistoryController.getMemEngagementDetails('0345678');
        System.assert(String.isNotBlank(details.notesErrorMsg));
        
        //	service error flow
        mock.setStatusCode(500);
        details = ADBContactHistoryController.getMemEngagementDetails('0345678');
        Test.stopTest();
    }
}