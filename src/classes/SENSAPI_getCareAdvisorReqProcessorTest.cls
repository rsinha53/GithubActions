/*------------------------------------------------------------
Author:        Harshini Thotakura
Description:   Test class for SENSAPI_GetCareAdvisorReqProcessor  

Test Class:    SENSAPI_GetCareAdvisorReqProcessorTest
History
Date           Author               Comments
-------------------------------------------------------------
27-10-2022     Harshini Thotakura	Created
------------------------------------------------------------*/
@isTest
private class SENSAPI_getCareAdvisorReqProcessorTest {
    
    private static final String memberId = '00001234567'; 
     
    @testSetup static void setup() { 
        
        Id recordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Family').getRecordTypeId();
        Account ac = new Account();
        ac.Member_ID__c = memberId;
        ac.Policy_ID__c = '0070145';
        ac.Name =   'SampleTEstFLAcc1';
        ac.RecordTypeId = recordTypeId;
        insert ac;
   
        
        Family_Overview__c familyOverview = new Family_Overview__c();
        familyOverview.Account__c = ac.Id;
        insert familyOverview;
        
    }
    
    /**
     * Testing success scearnio with existing subscriber id
     */ 
    @istest private static void processRequestSuccess(){
        
        RestRequest req = new RestRequest(); 
        RestResponse res = new RestResponse();
        
        RestContext.request = req;
        RestContext.response= res;
        
        Map<String,Object> requestMap = new Map<String,Object>();
        requestMap.put('subscriberId', memberId);
        
        SENSAPI_getCareAdvisorReqProcessor processor = new SENSAPI_getCareAdvisorReqProcessor();
        processor.process(JSON.serialize(requestMap));
    }
    
    /**
     * Testing failure scearnio with non-existing subscriber id
     */ 
    @istest private static void processRequestInvalidSubId(){
        
        RestRequest req = new RestRequest(); 
        RestResponse res = new RestResponse();
        
        RestContext.request = req;
        RestContext.response= res;
        
        Map<String,Object> requestMap = new Map<String,Object>();
        requestMap.put('subscriberId', 'noexisting');
        
        SENSAPI_getCareAdvisorReqProcessor processor = new SENSAPI_getCareAdvisorReqProcessor();
        processor.process(JSON.serialize(requestMap));
    }
    
    /**
     * Testing error scearnio without subscriber id
     */ 
    @istest private static void withoutSubId(){
        
        RestRequest req = new RestRequest(); 
        RestResponse res = new RestResponse();
        
        RestContext.request = req;
        RestContext.response= res;
        
        Map<String,Object> requestMap = new Map<String,Object>();
        requestMap.put('subscriberId', '');
        
        SENSAPI_getCareAdvisorReqProcessor processor = new SENSAPI_getCareAdvisorReqProcessor();
        processor.process(JSON.serialize(requestMap));
    }
    
    
    /**
     * Testing error scearnio invalid JSON
     */ 
    @isTest private static void testingWithInvalidJSON(){
        
        RestContext.request = new RestRequest(); 
        RestContext.response= new RestResponse();
        
        
        SENSAPI_getCareAdvisorReqProcessor processor = new SENSAPI_getCareAdvisorReqProcessor();
        processor.process('Invalid JSON');
    }
    
    
}