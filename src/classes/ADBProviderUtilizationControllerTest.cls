/**
* Author: Hasara Disanayaka
* Description : Test class for the unit test.
* Date Created: 07/09/2020
*/

@isTest
public class ADBProviderUtilizationControllerTest {
    
    @TestVisible private static String windowHostName='iset-dev2.uhc.com';
    @testSetup static void setup() {
        List<WebserviceConfigurations__c> configs = new List<WebserviceConfigurations__c>{
            new WebserviceConfigurations__c(Name = 'ADBMemberSearchEndpoint',recordtypeText__c = 'Token_API',Method__c = 'POST',Timeout__c = 10000),
            new WebserviceConfigurations__c(Name = 'ADBClaimSearchEndpoint',recordtypeText__c = 'Token_API',Method__c = 'POST',Timeout__c = 10000),
            new WebserviceConfigurations__c(Name = 'ADBMedicalClaimsEndpoint',recordtypeText__c = 'Token_API',Method__c = 'POST',Timeout__c = 10000)
        };                
        insert configs;
        
        List<OrgSpecificConfigurations__c> orgConfigs = new List<OrgSpecificConfigurations__c>{
            new OrgSpecificConfigurations__c(WebserviceConfigurations__c = configs[0].Id,recordtypeText__c = 'TokenAPI',Name = 'QA',EndpointDomain__c = 'https://orxapi-stage.optum.com/api/stage/cel/members/search/v2.0'),
            new OrgSpecificConfigurations__c(WebserviceConfigurations__c = configs[1].Id,recordtypeText__c = 'TokenAPI',Name = 'QA',EndpointDomain__c = 'https://orxapi-stage.optum.com/api/stage/clm/claims/search/v2.0'),
            new OrgSpecificConfigurations__c(WebserviceConfigurations__c = configs[2].Id,recordtypeText__c = 'TokenAPI',Name = 'QA',EndpointDomain__c = 'https://gateway-stage.optum.com')
        };
        insert orgConfigs;
        
        Organization_Properties__c property = new Organization_Properties__c(OrganizationName__c = 'QA');
        insert property;
        
        // create test data for custom setting
        List<ISL_Webservice_Config__c> tokenUrl = new List<ISL_Webservice_Config__c>{
            new ISL_Webservice_Config__c(name='dev_ADBMemberSearchEndpoint', value__c='https://orxapi-stage.optum.com/api/stage/cel/members/search/v2.0'),
            new ISL_Webservice_Config__c(name='dev_ADBClaimSearchEndpoint', value__c='https://orxapi-stage.optum.com/api/stage/clm/claims/search/v2.0'),
            new ISL_Webservice_Config__c(name='dev_ADBMedicalClaimsEndpoint', value__c='https://gateway-stage.optum.com/api/test/clm/tops-dashboard/v1/claims') 
        };
        insert tokenUrl; 
        
        // create test data for custom setting
        List<ACETOrgNameToSwivelEndpointMap__c> endpointUrlList = new List<ACETOrgNameToSwivelEndpointMap__c>{
            new ACETOrgNameToSwivelEndpointMap__c(name='ADBMedicalClaimUrl', Swivel_Endpoint__c='/HAPortlet/isetWork-flow.isx?_eventId=claimsSearchAndDetailsPage&execution=e1s3'),
            new ACETOrgNameToSwivelEndpointMap__c(name='ADBPharmacyClaimsUrl', Swivel_Endpoint__c='/HAPortlet/isetWork-flow.isx?_eventId=rxMemberPage&execution=e1s3'),
            new ACETOrgNameToSwivelEndpointMap__c(name='ADBProviderSearchUrl', Swivel_Endpoint__c='/HAPortlet/isetWork-flow.isx?_eventId=providerSearchAndDetailsPage&execution=e1s5')
        };
        insert endpointUrlList; 
    }
    
    @isTest static void testMemberSearchResponse(){
        String firstName = 'RACHEL QQ'; 
        String lastName = 'SEVICK'; 
        String memDob = '20040923';
        String memberId  = ''; 
        String timestamp = '123654789';
        ADBMemberDetailWrapper res = ADBProviderUtilizationController.memberSearchV2(memberId, memDob, firstName, lastName, timestamp);
        System.assert(res.memberId == null);
        test.startTest();
        StaticResourceCalloutMock mock = new StaticResourceCalloutMock();
        mock.setStaticResource('ADBMemberSearchMockResponse');
        mock.setStatusCode(200);
        // Set the mock callout mode
        Test.setMock(HttpCalloutMock.class, mock);
        res = ADBProviderUtilizationController.memberSearchV2(memberId, memDob, firstName, lastName, timestamp);
        System.assert(res.accountId != null);
        test.stopTest(); 
    }
    
    @isTest static void testClaimSearchResponse (){
        String carrierID = 'BXG001PIX'; 
        String accountId = '7000'; 
        String groupId = '611100014';
        String rxMemberId  = 'ZCF039758224058003'; 
        String instanceId = 'BOOK1';
        String fillDateThru = '20391231';
        String fillDateFrom = '20190101';
        String timestamp = '123654789';
        test.startTest();
        StaticResourceCalloutMock mock = new StaticResourceCalloutMock();
        mock.setStaticResource('ADBClaimSearchMockResponse');
        mock.setStatusCode(200);
        // Set the mock callout mode
        Test.setMock(HttpCalloutMock.class, mock);
        ADBProviderUtilizationController.claimsSearchV2(carrierID, accountId, groupId, rxMemberId, instanceId, timestamp, fillDateThru, fillDateFrom);
        
        test.stopTest(); 
    }
    
    @isTest static void testTopDashboardClaims (){
        String userId = 'pchinnol'; 
        String memberId = 'S994061057'; 
        String policy = '0701648';
        String firstName  = 'RAJIV'; 
        String relationship = 'RR';
        String consumerApplication = 'Acet';
        test.startTest();
        StaticResourceCalloutMock mock = new StaticResourceCalloutMock();
        mock.setStaticResource('ADBMedicalClaimsMockResponse');
        mock.setStatusCode(200);
        // Set the mock callout mode
        Test.setMock(HttpCalloutMock.class, mock);
        ADBProviderUtilizationController.topDashboardClaims(userId, memberId, policy, firstName, relationship, consumerApplication);
        
        test.stopTest(); 
    }
        
    @isTest static void testTopDashboardClaimsError (){
        String userId = 'pchinnol'; 
        String memberId = 'S994061057'; 
        String policy = '0701648';
        String firstName  = 'RAJIV'; 
        String relationship = 'RR';
        String consumerApplication = 'Acet';
        test.startTest();
        StaticResourceCalloutMock mock = new StaticResourceCalloutMock();
        mock.setStaticResource('ADBMedicalErrorResponse');
        mock.setStatusCode(200);
        // Set the mock callout mode
        Test.setMock(HttpCalloutMock.class, mock);
        ADBProviderUtilizationController.topDashboardClaims(userId, memberId, policy, firstName, relationship, consumerApplication);
        
        test.stopTest(); 
    }
    

    @isTest static void  testADBMedicalClaimResponseWrapper(){
        test.startTest();
       	String val = '{"searchResult": { "searchOutput": { "claims": [{ "firstServiceDate": "2021-01-13", "lastServiceDate": "2021-01-13", "claimType": "PHYSICIAN", "providerTaxId": "390806261", "providerName": "KERI S CHANEY", "providerTier": "I", "totalPatientResponsibility": "255.72", "providerSpecialty": "D" } ] } } } }';
        ADBMedicalClaimResponseWrapper.parse(val);
    	test.stopTest();
    }
    
    @isTest static void  testADBClaimsSearchResponseWrapper(){
        test.startTest();
        String val = '{"searchOutputMetaData": { "respCode": "200", "correlationID": "ACETDASHBOARD-1593596901-486", "respMessage": ["Success"] }, "claimSearchResponse": { "pagination": { "maxResults": 2, "maxResultsIndicator": false }, "claimSearchV2ServiceItem": [ { "claimStatus": "P", "fillDate": "20180201", "productNameAbbreviation": "LEVOTHYROXIN TAB 100MCG", "pharmacyName": "CVS PHARMACY #03083 03083", "daysSupply": "30" } ] } }';
        ADBClaimsSearchResponseWrapper.parse(val);
    	test.stopTest();
    }	 
}