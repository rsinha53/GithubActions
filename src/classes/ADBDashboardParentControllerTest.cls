/**
* Author: Hasara Disanayaka
* Description : Test class for the unit test.
* Date Created: 10/29/2020
*/

@isTest
public class ADBDashboardParentControllerTest {
    
    @testSetup static void setup() {
  String stargateHost = 'https://gateway-stage.optum.com';
  String baseURL = 'https://gateway-stage.optum.com/api/test/cdm/cust/ocm-oam-service/v1';
    List<WebserviceConfigurations__c> configs = new List<WebserviceConfigurations__c>{
            new WebserviceConfigurations__c(Name = 'ADBClientEventGetIcueMemberId',recordtypeText__c = 'Token_API',Method__c = 'POST',Timeout__c = 10000),
            new WebserviceConfigurations__c(Name = 'ADBAlertsPreferenceEndpoint', recordtypeText__c = 'Token_API',Method__c = 'POST', Timeout__c = 10000),
            new WebserviceConfigurations__c(Name = 'FindIndividualMemberships', recordtypeText__c = 'Token_API',Method__c = 'POST', Timeout__c = 10000),
            new WebserviceConfigurations__c(Name = 'LinkEligibilityMemberSearch', recordtypeText__c = 'Token_API',Method__c = 'POST', Timeout__c = 10000)
        };
        insert configs;
        
        List<OrgSpecificConfigurations__c> orgConfigs = new List<OrgSpecificConfigurations__c>{
            new OrgSpecificConfigurations__c(WebserviceConfigurations__c = configs[0].Id,recordtypeText__c = 'TokenAPI',Name = 'QA',EndpointDomain__c = baseURL + '/getIcueMemberId'),
            new OrgSpecificConfigurations__c(WebserviceConfigurations__c = configs[1].Id,recordtypeText__c = 'TokenAPI', Name = 'QA', EndpointDomain__c = stargateHost + '/api/stage/cel/optumisl/epmp/v1.5/alerts'),
            new OrgSpecificConfigurations__c(WebserviceConfigurations__c = configs[2].Id,recordtypeText__c = 'TokenAPI', Name = 'QA', EndpointDomain__c = stargateHost + '/api/alpha/cel/eisl/individual-memberships/v2.0/search'),
        new OrgSpecificConfigurations__c(WebserviceConfigurations__c = configs[3].Id, recordtypeText__c = 'TokenAPI',Name = 'QA', EndpointDomain__c = 'https://api-gateway-stage.linkhealth.com/elink-services/api/eligibility/v2.0')
                };
        insert orgConfigs;

        Organization_Properties__c property = new Organization_Properties__c(OrganizationName__c = 'QA');
        insert property;
        // create test data for custom setting
        List<ISL_Webservice_Config__c> tokenUrl = new List<ISL_Webservice_Config__c>{
             new ISL_Webservice_Config__c(name='dev_LinkEligibilityAPI', value__c='https://api-gateway-stage.linkhealth.com/elink-services/api/eligibility/v2.0'),
            new ISL_Webservice_Config__c(name='dev_LinkExtendedCoverageAPI', value__c='https://api-gateway-stage.linkhealth.com/elink-extended/api/coverageAttributes/v2.0')
         };
            
        insert tokenUrl;  
    }
          
    @isTest static void testEpmpAlertsDetails(){
        String memberId = '456404852';
        String firstName = 'Maria';
        String lastName = 'Ricky';
        String dob = '02-21-1988';
        String policyNumber = '03L0329';
        test.startTest();
        StaticResourceCalloutMock mock = new StaticResourceCalloutMock();
        mock.setStaticResource('ADBEpmpAlertsTestData');
        mock.setStatusCode(200);
        // Set the mock callout mode
        Test.setMock(HttpCalloutMock.class, mock);
        ADBDashboardParentController.callEpmpAlertsAPI(memberId, dob, firstName, lastName, policyNumber);
        test.stopTest();
    }  
    
    @isTest static void testEpmpAlertsDetailsError(){
        
        test.startTest();
        StaticResourceCalloutMock mock = new StaticResourceCalloutMock();
        mock.setStaticResource('');
        mock.setStatusCode(500);
        // Set the mock callout mode
        Test.setMock(HttpCalloutMock.class, mock);
        ADBDashboardParentController.callEpmpAlertsAPI('', '', '', '', '');
        test.stopTest();
    }

    //  US3360530 : Find individual membership integration
    @isTest static void testFIMService(){
        String memId = '11111111';
        String dob = '1986-10-27';

        //  Failure scenario
        ADBDashboardParentController.callFIMService(memId, dob);

        //  success scenario
        StaticResourceCalloutMock mock = new StaticResourceCalloutMock();
        mock.setStaticResource('ADBFindIndMockResponse');
        mock.setStatusCode(200);
        Test.startTest();
        Test.setMock(HttpCalloutMock.class, mock);
        ADBDashboardParentController.callFIMService(memId, dob);
        Test.stopTest();
    }
        // To test eligibility v2 service - When policyStatus == ACTIVE_POLICY
    @isTest static void testgetCallerPopupDetails (){
        String memberId = '036169100';
        String memberDob = '1954-07-11';
        String firstName='PEGGY';
        String lastName='BROGAN';
        String groupNumber = '0226310';                 
        test.startTest();
        
        StaticResourceCalloutMock mock = new StaticResourceCalloutMock();
        mock.setStaticResource('ACETEligibilityV2MockResponse');
        mock.setStatusCode(200);
        // Set the mock callout mode
        Test.setMock(HttpCalloutMock.class, mock);
        ISL_Webservice_Config__c web = [SELECT id, name, value__c from ISL_Webservice_Config__c LIMIT 1];
        system.debug('webbbbbbbbbbbbbb'+ web.Value__c);
        system.assertEquals(true, web.Value__c != null);
        // Call the method that performs the callout 
        ADBCallerProfilePopupDetailsWrapper popups = ADBDashboardParentController.getCallerPopupDetails(memberId, memberDob,firstName,lastName,groupNumber);
        popups.memberFirstName = 'DAVID';
        test.stopTest(); 
    }
    
    // To test eligibility v2 service - When policyStatus == PAST_POLICY
    @isTest static void testgetCallerPopupDetails3 (){
        String memberId = '036169100';
        String memberDob = '1970-12-23';
        String firstName='CRAIG';
        String lastName='BROGAN';
        String groupNumber = '0226310';                 
        test.startTest();
        
        StaticResourceCalloutMock mock = new StaticResourceCalloutMock();
        mock.setStaticResource('EligibilityV2_036169100_1996_09_16');
        mock.setStatusCode(200);
        // Set the mock callout mode
        Test.setMock(HttpCalloutMock.class, mock);
        ISL_Webservice_Config__c web = [SELECT id, name, value__c from ISL_Webservice_Config__c LIMIT 1];
        system.debug('webbbbbbbbbbbbbb'+ web.Value__c);
        system.assertEquals(true, web.Value__c != null);
        // Call the method that performs the callout 
        ADBCallerProfilePopupDetailsWrapper popups = ADBDashboardParentController.getCallerPopupDetails(memberId, memberDob,firstName,lastName,groupNumber);
        popups.memberFirstName = 'DAVID';
        test.stopTest(); 
    }
    
    // To test eligibility v2 service - When policyStatus == PAST_POLICY
    @isTest static void testgetCallerPopupDetails2 (){
        String memberId = '036169100';
        String memberDob = '1996-09-16';
    String firstName='JAKE';
        String lastName='BROGAN';
        String groupNumber = '0226310';  

        test.startTest();
        
        StaticResourceCalloutMock mock = new StaticResourceCalloutMock();
        //mock.setStaticResource('EligibilityV2_036169100_1996_09_16');
        mock.setStatusCode(200);
        // Set the mock callout mode
        Test.setMock(HttpCalloutMock.class, mock);
        ISL_Webservice_Config__c web = [SELECT id, name, value__c from ISL_Webservice_Config__c LIMIT 1];
        system.debug('webbbbbbbbbbbbbb'+ web.Value__c);
        system.assertEquals(true, web.Value__c != null);
        // Call the method that performs the callout 
        ADBCallerProfilePopupDetailsWrapper popups = ADBDashboardParentController.getCallerPopupDetails(memberId, memberDob,firstName,lastName,groupNumber);
        popups.memberFirstName = 'DAVID';
        test.stopTest(); 
    }
    
}