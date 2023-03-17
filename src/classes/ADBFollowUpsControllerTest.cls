@isTest 
public class ADBFollowUpsControllerTest {
    @testSetup static void setup() {
        Test.startTest();
        Organization_Properties__c property = new Organization_Properties__c(OrganizationName__c = 'QA');
        insert property;
        List<WebserviceConfigurations__c> configs = new List<WebserviceConfigurations__c>{
            new WebserviceConfigurations__c(Name = 'ORSSelectIssue',recordtypeText__c = 'Token_API', Method__c = 'POST', Timeout__c = 10000),
            new WebserviceConfigurations__c(Name = 'ADBReadFollowupDetails',recordtypeText__c = 'Token_API', Method__c = 'POST', Timeout__c = 10000),
            new WebserviceConfigurations__c(Name = 'ADBCommitmentsServiceEndpoint',recordtypeText__c = 'Token_API', Method__c = 'POST', Timeout__c = 10000)
        };
        insert configs;
        List<OrgSpecificConfigurations__c> orgConfigs = new List<OrgSpecificConfigurations__c>{
            new OrgSpecificConfigurations__c(WebserviceConfigurations__c = configs[0].Id,recordtypeText__c = 'TokenAPI', Name = 'QA', EndpointDomain__c = 'https://gateway-stage.optum.com/api/stage/ccs/ci/issues/v1/search'),
            new OrgSpecificConfigurations__c(WebserviceConfigurations__c = configs[1].Id,recordtypeText__c = 'TokenAPI', Name = 'QA', EndpointDomain__c = 'https://gateway-stage.optum.com/api/stage/ccs/ci/issue-history-details/v1'),
            new OrgSpecificConfigurations__c(WebserviceConfigurations__c = configs[2].Id,recordtypeText__c = 'TokenAPI', Name = 'QA', EndpointDomain__c = 'https://gateway-stage.optum.com/api/alpha/clin/icue/memberdetails/v2.0/getAllOpenAssignmentsBySourceMemberID')
        };
        insert orgConfigs;
        Test.stopTest();
    }
    @isTest 
    static void testfetchCommitmentsDetails() {
        ADBCommitmentsUIWrapper result;
        Test.startTest();
        StaticResourceCalloutMock mock = new StaticResourceCalloutMock();
        mock.setStaticResource('ADBCommitmentsServiceResponseMultiple');
        mock.setStatusCode(200);
        // Set the mock callout mode
        Test.setMock(HttpCalloutMock.class, mock);
        result = ADBFollowUpsController.fetchCommitmentsDetails('12345678');
        Test.stopTest();
    }
    @isTest 
    static void testfetchCommitmentsDetailssingle() {
        ADBCommitmentsUIWrapper resultSingle;
        Test.startTest();
        StaticResourceCalloutMock mock = new StaticResourceCalloutMock();
        mock.setStaticResource('ADBCommitmentsServiceResponseSingle');
        mock.setStatusCode(200);
        // Set the mock callout mode
        Test.setMock(HttpCalloutMock.class, mock);
        resultSingle = ADBFollowUpsController.fetchCommitmentsDetails('12345678');
        Test.stopTest();
    }
    @isTest static void testORSCommitments() {
        MultiStaticResourceCalloutMock mock = new MultiStaticResourceCalloutMock();
        mock.setStaticResource('https://gateway-stage.optum.com/api/stage/ccs/ci/issues/v1/search', 'ACETSelectIssueMockResponse');
        mock.setStaticResource('https://gateway-stage.optum.com/api/stage/ccs/ci/issue-history-details/v1', 'ADBReadFollowupDetailMock');
        mock.setStatusCode(200);
        Test.setMock(HttpCalloutMock.class, mock);
        
        Test.startTest();
        ADBFollowUpsController.getFollowUps('1234567890', '222', '444');
        Test.stopTest();
    }
	
	@isTest 
    static void testfetchCommitmentsDetailsZero() {
        ADBCommitmentsUIWrapper resultSingle;
        Test.startTest();
        StaticResourceCalloutMock mock = new StaticResourceCalloutMock();
        mock.setStaticResource('ADBZeroMemberAssignments');
        mock.setStatusCode(200);
        // Set the mock callout mode
        Test.setMock(HttpCalloutMock.class, mock);
        resultSingle = ADBFollowUpsController.fetchCommitmentsDetails('12345678');
        Test.stopTest();
    }
    
    @isTest 
    static void coverADBORSCommitmentsWrapper() {
        Date todaysDate = System.today();
        ADBORSCommitmentsWrapper.Commitment commitmnt = new ADBORSCommitmentsWrapper.Commitment();
        commitmnt.type = '';
		commitmnt.create_Date = todaysDate;
		commitmnt.commitment = '';
        commitmnt.due_Date = '';
        commitmnt.isOverdue = false;
        
        ADBORSCommitmentsWrapper aocw = new ADBORSCommitmentsWrapper(commitmnt);
        aocw.compareTo(aocw);
        
    }
    
}