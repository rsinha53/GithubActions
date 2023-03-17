@isTest public class ADBAuthorizatonsControllerTest {
    
    @testSetup static void setup() {
        WebserviceConfigurations__c config = new WebserviceConfigurations__c(Name = 'ADBAuthorizationEndpoint',recordtypeText__c = 'Token_API', Method__c = 'POST', Timeout__c = 10000 );
        insert config;
        OrgSpecificConfigurations__c org = new OrgSpecificConfigurations__c(WebserviceConfigurations__c = config.Id,recordtypeText__c = 'TokenAPI', Name = 'QA', EndpointDomain__c = 'https://gateway-stage.optum.com' );
        insert org;
        Organization_Properties__c property = new Organization_Properties__c(OrganizationName__c = 'QA');
        insert property;
        
        // create test data for custom setting
        List<ACETOrgNameToSwivelEndpointMap__c> endpointUrlList = new List<ACETOrgNameToSwivelEndpointMap__c>{
            new ACETOrgNameToSwivelEndpointMap__c(name='ADBAddnAuthorization', Swivel_Endpoint__c='/HAPortlet/isetWork-flow.isx?_eventId=notificationsPage&execution=e1s6')
                };
                    insert endpointUrlList;
    }
    
    @isTest static void testAuthNotifications (){
        String userId = 'pchinnol'; 
        String memberId = 'S994061070'; 
        String policy = '0753348';
        String firstName  = 'JOHN'; 
        String relationship = 'EE';
        String consumerApplication = 'Acet';
        test.startTest();
        StaticResourceCalloutMock mock = new StaticResourceCalloutMock();
        mock.setStaticResource('ADBAuthorizationMockResponse');
        mock.setStatusCode(200);
        // Set the mock callout mode
        Test.setMock(HttpCalloutMock.class, mock);
        ADBAuthorizatonsController.getAuthNotifications(userId, memberId, policy, firstName, relationship, consumerApplication);
        test.stopTest(); 
    }
    
    @isTest static void testAuthNotificationsError (){
        String userId = 'pchinnol'; 
        String memberId = 'S994061070'; 
        String policy = '0753348';
        String firstName  = 'JOHN'; 
        String relationship = 'EE';
        String consumerApplication = 'Acet';
        test.startTest();
        StaticResourceCalloutMock mock = new StaticResourceCalloutMock();
        mock.setStaticResource('ADBAuthErrorMockData');
        mock.setStatusCode(200);
        // Set the mock callout mode
        Test.setMock(HttpCalloutMock.class, mock);
        ADBAuthorizatonsController.getAuthNotifications(userId, memberId, policy, firstName, relationship, consumerApplication);
        test.stopTest(); 
    }
    
   @isTest static void  testADBAuthorizationResponseWrapper(){
        test.startTest();
        String val = '{"unet-notifications-response":{"notifications":[{"notificationNumber":"TESTOP0002","sourceIndicator":"UCR","providerTin":"236216914706197","advancedNotificationDate":"2020-01-31","advancedNotificationTime":"10:10:00","commentIndicator":"N","detailTypeIndicator":"O","parsInfos":[{"caregiver":{"code":""},"cancelDate":"2020-02-05","cptDetails":[{"procedure":{"code":"J9000"}}],"dx1":{"code":"C399"},"effectiveDate":"2020-02-01","firstName":"JOHN","icdVersionIndicator":"0","notificationStatus":{"code":""},"relationship":{"code":"EE","description":"SUBSCRIBER"},"remark":{"code":"AS","description":"AUTHORIZED SERVICES - OON PROVIDER APPROVED FOR PAYMENT AT INN BENEFIT LEVEL"},"status":{"code":"","description":""},"topsFirstName":"","topsRelationship":{"code":"","description":"SUBSCRIBER"}}],"paidIndicator":{"code":"N","description":"No"},"fileKey":{"notificationNumber":"TESTOP0002","sourceIndicator":"UCR","cptCode":"J9000","effectiveDate":""},"programRecordIndicator":{"code":"N","description":"Notification"},"delegatedAuthorizationInd":""},{"notificationNumber":"A003832612","sourceIndicator":"OPT","providerTin":"245441735200002","advancedNotificationDate":"2020-06-17","advancedNotificationTime":"08:58:00","commentIndicator":"N","detailTypeIndicator":"O","parsInfos":[{"caregiver":{"code":""},"cancelDate":"2020-09-15","cptDetails":[{"procedure":{"code":"J9000"}}],"dx1":{"code":"C4A0"},"effectiveDate":"2020-06-17","firstName":"JOHN","icdVersionIndicator":"0","notificationStatus":{"code":""},"relationship":{"code":"EE","description":"SUBSCRIBER"},"remark":{"code":"AS","description":"AUTHORIZED SERVICES - OON PROVIDER APPROVED FOR PAYMENT AT INN BENEFIT LEVEL"},"status":{"code":"","description":""},"topsFirstName":"JOHN","topsRelationship":{"code":"EE","description":"SUBSCRIBER"}}],"paidIndicator":{"code":"Y","description":"Yes"},"fileKey":{"notificationNumber":"A003832612","sourceIndicator":"OPT","cptCode":"J9000","effectiveDate":""},"programRecordIndicator":{"code":"N","description":"Notification"},"delegatedAuthorizationInd":""}],"fileIndicator":"","pagingState":{"moreData":false,"nextKey":""}}}';
        ADBAuthorizationResponseWrapper.parse(val);
    	test.stopTest();
    } 
}