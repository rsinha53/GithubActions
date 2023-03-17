@isTest
public class ADBMedicalClaimsDetailControllerTest {
    @testSetup static void setup() {
        Test.startTest();
        List<WebserviceConfigurations__c> configs = new List<WebserviceConfigurations__c>{
            new WebserviceConfigurations__c(Name = 'ADBMedicalClaimsEndpoint',recordtypeText__c = 'Token_API', Method__c = 'POST', Timeout__c = 10000)
                };
                    insert configs;
        
        List<OrgSpecificConfigurations__c> orgConfigs = new List<OrgSpecificConfigurations__c>{
            new OrgSpecificConfigurations__c(WebserviceConfigurations__c = configs[0].Id,recordtypeText__c = 'TokenAPI',Name = 'QA',EndpointDomain__c = 'https://gateway-stage.optum.com')
                };
                    insert orgConfigs;
        
        Organization_Properties__c property = new Organization_Properties__c(OrganizationName__c = 'QA');
        insert property;
        Test.stopTest();
    }
    @isTest static void testMedicalClaims (){
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
        ADBMedicalClaimsDetailController.getMedicalClaims(userId, memberId, policy, firstName, relationship, consumerApplication);
        
        test.stopTest(); 
    }
        
    @isTest static void testMedicalClaimsError (){
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
        ADBMedicalClaimsDetailController.getMedicalClaims(userId, memberId, policy, firstName, relationship, consumerApplication);
        test.stopTest(); 
    }
    
    @isTest static void  testADBMedicalClaimResponseWrapper(){
        test.startTest();
       	String val = '{"searchResult": { "searchOutput": { "claims": [{ "firstServiceDate": "2021-01-13", "lastServiceDate": "2021-01-13", "claimType": "PHYSICIAN", "providerTaxId": "390806261", "providerName": "KERI S CHANEY", "providerTier": "I", "totalPatientResponsibility": "255.72", "providerSpecialty": "D" } ] } } } }';
        ADBMedicalClaimResponseWrapper.parse(val);
    	test.stopTest();
    }
}