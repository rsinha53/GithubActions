@isTest
public with sharing class ACET_DocThreeSixtyServiceTest {
    @testsetup
    static void testsetupMethod() {
        Organization_Properties__c orgProps = Organization_Properties__c.getOrgDefaults();
        orgProps.OrganizationName__c = 'qa';
        Upsert orgProps;
        
        // Token API data
        WebserviceConfigurations__c tokenAPIWSConfig = ACET_WebserviceCalloutFramework_Test.createTokenWSConfigs('StarGateTokenAPI');
        WebserviceConfigurations__c tokenAPIWSConfigToken = ACET_WebserviceCalloutFramework_Test.createAuthTokenWSConfig('StarGateTokenAPI');
        OrgSpecificConfigurations__c tokenAPIOrgSpecificConfigs = ACET_WebserviceCalloutFramework_Test.createTokenOrgWSConfigs(tokenAPIWSConfig.Id);
        
        // Service API data
        WebserviceConfigurations__c wsConfig = ACET_WebserviceCalloutFramework_Test.createWSConfig('LinkRelatedDocuments', tokenAPIWSConfig.Id);
        OrgSpecificConfigurations__c orgSpecificConfigs = ACET_WebserviceCalloutFramework_Test.createOrgWSConfigs(wsConfig.Id);

        WebserviceConfigurations__c wsConfigPurged = ACET_WebserviceCalloutFramework_Test.createWSConfig('PurgedORSGetContent', tokenAPIWSConfig.Id);
        OrgSpecificConfigurations__c orgSpecificConfigsPurged = ACET_WebserviceCalloutFramework_Test.createOrgWSConfigs(wsConfigPurged.Id);
    }

    @IsTest
    static void searchDocumentsSuccess(){       
        StaticResourceCalloutMock mock = new StaticResourceCalloutMock();
        mock.setStaticResource('PurgedORSDoc360Results');
        mock.setStatusCode(200);
        mock.setHeader('Content-Type', 'application/json');
        Test.setMock(HttpCalloutMock.class, mock); 
        Test.startTest();
            ACET_SAECalloutResult result = ACET_DocThreeSixtyService.searchDocuments('1234', true);
            System.assertEquals(200, result.statusCode, 'Success');
        Test.stopTest();      
    }

    @IsTest
    static void searchDocumentsFail(){       
        StaticResourceCalloutMock mock = new StaticResourceCalloutMock();
        Test.startTest();
            ACET_SAECalloutResult result = ACET_DocThreeSixtyService.searchDocuments('1234', true);
            System.assertEquals(999, result.statusCode, 'Fail');
        Test.stopTest();      
    }

    @IsTest
    static void getContentSuccess(){       
        Test.setMock(HttpCalloutMock.class, new GetContentSuccess());
        Test.startTest();
            ACET_SAECalloutResult result = ACET_PurgedORSController.getPurgedDocument('123455');
            System.assertEquals(200, result.statusCode, 'Success');
        Test.stopTest();      
    }

    @IsTest
    static void getContentFailController(){
        Test.startTest();
            ACET_SAECalloutResult result = ACET_PurgedORSController.getPurgedDocument('123455');
            System.assertEquals(999, result.statusCode, 'Fail');
        Test.stopTest();      
    }

    @IsTest
    static void getContentFail(){       
        Test.setMock(HttpCalloutMock.class, new GetContentFail());
        Test.startTest();
            ACET_SAECalloutResult result = ACET_DocThreeSixtyService.getContent('1234');
            System.assertEquals(401, result.statusCode, 'Fail');
        Test.stopTest();      
    }

    public class GetContentSuccess implements HttpCalloutMock {
        public HTTPResponse respond(HTTPRequest request) {
            HttpResponse response = new HttpResponse();
            response.setBody('');
            response.setStatusCode(200);
            return response;
        }
    }

    public class GetContentFail implements HttpCalloutMock {
        public HTTPResponse respond(HTTPRequest request) {
            HttpResponse response = new HttpResponse();
            response.setBody('');
            response.setStatusCode(401);
            return response;
        }
    }
}