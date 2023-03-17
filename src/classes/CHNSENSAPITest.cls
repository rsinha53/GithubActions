/*------------------------------------------------------------
Author:        Tushar Kaore
Description:   Test class for CHNSENSAPI  

Test Class:   CHNSENSAPITest
History
Date            Author              Comments
-------------------------------------------------------------
6th Dec, 2022	Tushar Kaore		Created
------------------------------------------------------------*/

@isTest
public class CHNSENSAPITest {

    
    private static final String memberId = '00001234567'; 
     
    @testSetup static void setup() { 
        
        Id recordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Family').getRecordTypeId();
        Account ac = new Account();
        ac.Member_ID__c = memberId;
        ac.Policy_ID__c = '0070145';
        ac.Name =   'SampleTEstFLAcc1';
        ac.RecordTypeId = recordTypeId;
        insert ac;
   
    }
    
    /**
     * Testing success scearnio with existing subscriber id
     */ 
    @istest private static void processRequestSuccess(){
        
        RestRequest req = new RestRequest(); 
        RestResponse res = new RestResponse();
        RestContext.request = req;
        RestContext.response= res;
        
        req.requestURI = '/services/apexrest/CHNSENSAPI/';  //Request URL
        req.httpMethod = 'POST'; //HTTP Request Type
        req.addHeader('svcName', 'getAdvisor');
        req.addHeader('source', 'League');
        
        Map<String,Object> requestMap = new Map<String,Object>();
        requestMap.put('subscriberId', memberId);
        req.requestBody = Blob.valueof(JSON.serialize(requestMap));
        
       CHNSENSAPI.doPost();
       system.assert(RestContext.response.statusCode  == 200, 'Error processing request');
    }
    
    /**
     * Testing error with no service name and source
     */ 
    @istest private static void processNoSvcNoSource(){
        
        RestRequest req = new RestRequest(); 
        RestResponse res = new RestResponse();
        RestContext.request = req;
        RestContext.response= res;
        
        req.requestURI = '/services/apexrest/CHNSENSAPI/';  //Request URL
        req.httpMethod = 'POST'; //HTTP Request Type
        
        Map<String,Object> requestMap = new Map<String,Object>();
        requestMap.put('subscriberId', memberId);
        req.requestBody = Blob.valueof(JSON.serialize(requestMap));
        
       CHNSENSAPI.doPost();
        system.assert(RestContext.response.statusCode  == 400, 'Error validating service name and source');
    }
    
    
    /**
     * Testing with invalid source name
     */ 
    @istest private static void requestWithInvalidSource(){
        
        RestRequest req = new RestRequest(); 
        RestResponse res = new RestResponse();
        RestContext.request = req;
        RestContext.response= res;
        
        req.requestURI = '/services/apexrest/CHNSENSAPI/';  //Request URL
        req.httpMethod = 'POST'; //HTTP Request Type
        req.addHeader('svcName', 'getAdvisor');
        req.addHeader('source', 'Test');
        
        Map<String,Object> requestMap = new Map<String,Object>();
        requestMap.put('subscriberId', memberId);
        req.requestBody = Blob.valueof(JSON.serialize(requestMap));
        
       CHNSENSAPI.doPost();
        system.assert(RestContext.response.statusCode  == 400, 'Error validating service name and source');
    }

    /**
     * Testing with invalid source name
     */ 
    @istest private static void testExceptionHandling(){
        
        RestRequest req = new RestRequest(); 
        RestResponse res = new RestResponse();
        RestContext.request = req;
        RestContext.response= res;
        
        req.requestURI = '/services/apexrest/CHNSENSAPI/';  //Request URL
        req.httpMethod = 'POST'; //HTTP Request Type
        req.addHeader('svcName', 'getAdvisor');
        req.addHeader('source', 'League');
        
        Map<String,Object> requestMap = new Map<String,Object>();
        requestMap.put('subscriberId', memberId);
        req.requestBody = Blob.valueof(JSON.serialize(requestMap));
        
       CHNSENSAPI.testClassException = true;
       CHNSENSAPI.doPost();
        system.assert(RestContext.response.statusCode  == 500, 'Error handling exception');
    }
    
}