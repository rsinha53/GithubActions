@isTest
public class ADBClaimsSearchControllerTest {
    @testSetup static void setup() {
        Test.startTest();
        List<WebserviceConfigurations__c> configs = new List<WebserviceConfigurations__c>{
            new WebserviceConfigurations__c(Name = 'ADBMemberSearchEndpoint',recordtypeText__c = 'Token_API',Method__c = 'POST',Timeout__c = 10000),
            new WebserviceConfigurations__c(Name = 'ADBClaimSearchEndpoint', recordtypeText__c = 'Token_API',Method__c = 'POST', Timeout__c = 10000)
                };
                    insert configs;
        
        List<OrgSpecificConfigurations__c> orgConfigs = new List<OrgSpecificConfigurations__c>{
            new OrgSpecificConfigurations__c(WebserviceConfigurations__c = configs[0].Id,recordtypeText__c = 'TokenAPI',Name = 'QA',EndpointDomain__c = 'https://orxapi-stage.optum.com/api/stage/cel/members/search/v2.0'),
            new OrgSpecificConfigurations__c(WebserviceConfigurations__c = configs[1].Id,recordtypeText__c = 'TokenAPI',Name = 'QA',EndpointDomain__c = 'https://orxapi-stage.optum.com/api/stage/clm/claims/search/v2.0')
                };
                    insert orgConfigs;
        
        Organization_Properties__c property = new Organization_Properties__c(OrganizationName__c = 'QA');
        insert property;
        Test.stopTest();
    }
    
        @isTest static void testMemberSearchResponse(){
        String firstName = 'RACHEL QQ'; 
        String lastName = 'SEVICK'; 
        String memDob = '20040923';
        String memberId  = ''; 
        String timestamp = '123654789';
        ADBMemberDetailWrapper res = ADBClaimsSearchController.getMemberSearch(memberId, memDob, firstName, lastName, timestamp);
        System.assert(res.memberId == null);
        test.startTest();
        StaticResourceCalloutMock mock = new StaticResourceCalloutMock();
        mock.setStaticResource('ADBMemberSearchMockResponse');
        mock.setStatusCode(200);
        // Set the mock callout mode
        Test.setMock(HttpCalloutMock.class, mock);
        res = ADBClaimsSearchController.getMemberSearch(memberId, memDob, firstName, lastName, timestamp);
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
        ADBClaimsSearchController.getClaimsSearch(carrierID, accountId, groupId, rxMemberId, instanceId, timestamp, fillDateThru, fillDateFrom);
        
        test.stopTest(); 
    }
    @isTest static void  testADBClaimsSearchResponseWrapper(){
        test.startTest();
        String val = '{"searchOutputMetaData": { "respCode": "200", "correlationID": "ACETDASHBOARD-1593596901-486", "respMessage": ["Success"] }, "claimSearchResponse": { "pagination": { "maxResults": 2, "maxResultsIndicator": false }, "claimSearchV2ServiceItem": [ { "claimStatus": "P", "fillDate": "20180201", "productNameAbbreviation": "LEVOTHYROXIN TAB 100MCG", "pharmacyName": "CVS PHARMACY #03083 03083", "daysSupply": "30" } ] } }';
        ADBClaimsSearchResponseWrapper.parse(val);
        test.stopTest();
    }
}