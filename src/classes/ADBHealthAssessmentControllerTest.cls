/**
* Author: Sunil Vennam
* Description : Test class for the unit test.
* Date Created:
*/
@isTest
public class ADBHealthAssessmentControllerTest {
    @testSetup static void setup() {
        // create test data for custom setting
        List<ISL_Webservice_Config__c> tokenUrl = new List<ISL_Webservice_Config__c>{
            new ISL_Webservice_Config__c(name='dev_ADBHealthAssessmentEndpoint', value__c='https://api.werally.com/bluesteel/survey/v3/summary'),
                new ISL_Webservice_Config__c(name='dev_ADBIncentiveEndpoint', value__c='https://dev-api.werally.com/bluesteel/incentives-program/optum/'),
                new ISL_Webservice_Config__c(name='dev_ADBPersonIdTokenEndpoint', value__c='https://gateway-stage.optum.com/auth/oauth2/token')
                };
                    insert tokenUrl;
        List<ACETOrgNameToSwivelEndpointMap__c> orgNameMpping = new List<ACETOrgNameToSwivelEndpointMap__c>{
            new ACETOrgNameToSwivelEndpointMap__c(name='ADBWellnessHASummaryUrl', Swivel_Endpoint__c='https://icue.uhc.com/icue/memberWellness.uhg?action=getHealthAssessmentSummary'),
                new ACETOrgNameToSwivelEndpointMap__c(name='ADBWellnessDefaultUrl', Swivel_Endpoint__c='https://icue.uhc.com/icue/memberWellness.uhg?action=defaultAction')
                };
                    insert orgNameMpping; 
        List<WebserviceConfigurations__c> configs = new List<WebserviceConfigurations__c>{
            new WebserviceConfigurations__c(Name = 'ADBMPEServiceEndpoint',recordtypeText__c = 'Token_API',Method__c = 'POST',Timeout__c = 10000)
                };                
                    insert configs;
        List<OrgSpecificConfigurations__c> orgConfigs = new List<OrgSpecificConfigurations__c>{
            new OrgSpecificConfigurations__c(WebserviceConfigurations__c = configs[0].Id,recordtypeText__c = 'TokenAPI',Name = 'QA',EndpointDomain__c = 'https://gateway-stage.optum.com/api/stage/cel/mpe/eligibility/v3.0')
                };
                    insert orgConfigs;
        Organization_Properties__c property = new Organization_Properties__c(OrganizationName__c = 'QA');
        insert property;
    }
    @isTest static void testGetCompletionDate (){
        
        String memberId = '962619661';
        String firstName = 'STEPHANIE';
        String lastName = 'MILLER';
        String memberDob = '1965-02-25';
        String contractNumber = '0192086';
        test.startTest();
        StaticResourceCalloutMock mock = new StaticResourceCalloutMock();
        mock.setStaticResource('ADBCompDateTestData');
        mock.setStatusCode(200);
        // Set the mock callout mode
        Test.setMock(HttpCalloutMock.class, mock);
        String completionDate = ADBHealthAssessmentController.getCompletionDate(memberId, firstName, lastName, memberDob, contractNumber);
        system.assertEquals('2020-01-07T23:27:49+0000', completionDate);
        test.stopTest();
    }
    @isTest static void testtokenResponse (){
        test.startTest();
        StaticResourceCalloutMock mock = new StaticResourceCalloutMock();
        mock.setStaticResource('ADBTokenServiceResponse');
        mock.setStatusCode(200);
        // Set the mock callout mode
        Test.setMock(HttpCalloutMock.class, mock);
        //	calling the general token generation logic - Madhura : US2574136            
        String authToken = ADBWebService.generateTokenbyMetadata('ADBStargateDashboardTokenParams', 'Eligibility');
        system.assertEquals(true, authToken!=null);
        Test.stopTest();
    }
    @isTest static void testGetPersonId (){
        String memberId = '169485626';
        String firstName = 'JOHN';
        String lastName = 'WARGO';
        String memberDob = '1956-09-18';
        List<String> contractNumber = new List<String>();
        contractNumber.add('0197944');
        test.startTest();
        StaticResourceCalloutMock mock = new StaticResourceCalloutMock();
        mock.setStaticResource('ADBMPETestData');
        mock.setStatusCode(200);
        // Set the mock callout mode
        Test.setMock(HttpCalloutMock.class, mock);       
        ADBMPEResponseWrapper PersonIdresponse = ADBHealthAssessmentController.getPersonId(memberId, firstName, lastName, memberDob, contractNumber);
        system.assertEquals(185569224, PersonIdresponse.MemberProductEligibilityResponse.consumerDetails[0].idSet.personId);
        test.stopTest();
    } 
    
    @isTest static void testGetIncentives (){
        String memberNumber = '169485626';
        String firstName = 'JOHN';
        String lastName = 'WARGO';
        String dob = '1956-09-18';
        String groupNumber = '0197944';
        test.startTest();
        StaticResourceCalloutMock mock = new StaticResourceCalloutMock();
        mock.setStaticResource('ADBIncentiveTestData');
        mock.setStatusCode(200);
        // Set the mock callout mode
        Test.setMock(HttpCalloutMock.class, mock);  
        ADBHealthAssessmentResponceWrapper incentive = ADBHealthAssessmentController.getIncentives(dob, firstName, lastName, memberNumber, groupNumber);
        system.assertEquals('Mammogram', incentive.pendingActivitiesList[0].activityName);
        test.stopTest();
    }
	@isTest static void testGetCompleteIncentives (){
        String memberNumber = '169485626';
        String firstName = 'JOHN';
        String lastName = 'WARGO';
        String dob = '1956-09-18';
        String groupNumber = '0197944';
        test.startTest();
        StaticResourceCalloutMock mock = new StaticResourceCalloutMock();
        mock.setStaticResource('ADBIncentiveCompleteTestData');
        mock.setStatusCode(200);
        // Set the mock callout mode
        Test.setMock(HttpCalloutMock.class, mock);  
        ADBHealthAssessmentController.getIncentives(dob, firstName, lastName, memberNumber, groupNumber);
        test.stopTest();
    } 
    @isTest static void testWellnessHASummaryUrl() {
        test.startTest(); 
        String cdbXrefId='4234234',userId='test3';
        ADBHealthAssessmentController.getWellnessHASummaryUrl(cdbXrefId,userId);
        test.stopTest();
    }
    @isTest static void testWellnessDefaultUrl() {
        test.startTest(); 
        String cdbXrefId='4234234',userId='test3';
        ADBHealthAssessmentController.getWellnessDefaultUrl(cdbXrefId,userId);
        test.stopTest();
    }
   @isTest static void  testADBMPEResponseWrapper(){
        test.startTest();
        String val = '{"MemberProductEligibilityResponse":{"responseHeader":{"transactionId":"20200237stargateMPEv3change"},"consumerDetails":[{"demographics":{"firstName":"JOHN","lastName":"WARGO","middleName":"G","dateOfBirth":"1956-09-18T00:00:00Z","gender":"M","relationship":"RR","relationshipDescription":"SUBSCRIBER RECIPIENT"},"contactDetails":{"email":"JWARGO779@GMAIL.COM","addressLine1":"2176 YARDVILLE HAMILTON SQ RD","city":"HAMILTON SQ","state":"NJ","zipCode":"08690"},"idSet":{"personId":185569224,"subscriberSSN":"169485626","memberSSN":"169485626","subscriberID":"00169485626","alternateId":"930689393","xrefId":"0030018120","xrefPartitionNumber":"00000"},"populationDetails":{},"reportingAttributes":{"maritalStatus":"M","countryCode":"US","familyId":"17132514"},"coverageDetails":{"recordType":"HEALTH_COVERAGE","employeeStatus":"R","contractNumber":"0197944","eligibilitySourceSystem":"CS","planVariation":"0367","reportingCode":"0367","customerName":"PORT AUTH. TRANS-HUDSON CORP.","coverageType":"M","coverageEffectiveDate":"2019-04-01T00:00:00Z","coverageTerminationDate":"2019-12-31T00:00:00Z","hireDate":"1985-10-28T00:00:00Z","stateOfIssue":"NY","marketSite":"0029523"},"productDetails":{"product":[]}},{"demographics":{"firstName":"JOHN","lastName":"WARGO","middleName":"G","dateOfBirth":"1956-09-18T00:00:00Z","gender":"M","relationship":"RR","relationshipDescription":"SUBSCRIBER RECIPIENT"},"contactDetails":{"email":"JWARGO779@GMAIL.COM","addressLine1":"2176 YARDVILLE HAMILTON SQ RD","city":"HAMILTON SQ","state":"NJ","zipCode":"08690"},"idSet":{"personId":185569224,"subscriberSSN":"169485626","memberSSN":"169485626","subscriberID":"00169485626","alternateId":"930689393","xrefId":"0030018120","xrefPartitionNumber":"00000"},"populationDetails":{},"reportingAttributes":{"maritalStatus":"M","countryCode":"US","familyId":"17132514"},"coverageDetails":{"recordType":"HEALTH_COVERAGE","employeeStatus":"R","contractNumber":"0197944","eligibilitySourceSystem":"CS","planVariation":"0367","reportingCode":"0367","customerName":"PORT AUTH. TRANS-HUDSON CORP.","coverageType":"M","coverageEffectiveDate":"2020-01-01T00:00:00Z","hireDate":"1985-10-28T00:00:00Z","stateOfIssue":"NY","marketSite":"0029523"},"productDetails":{"product":[]}}]}} ';
       ADBMPEResponseWrapper.parse(val);
        test.stopTest();
    }
    @isTest static void  testADBHealthAssessmentServiceReqWrapper(){
        test.startTest();
        ADBHealthAssessmentServiceRequestWrapper hsrw = new ADBHealthAssessmentServiceRequestWrapper();
        hsrw.responseCode = '';
        hsrw.responseMsg = '';
        hsrw.hra = null; 
        test.stopTest();
    }
}