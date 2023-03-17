/*------------------------------------------------------------
Author:        Tushar Kaore
Description:   Test class for SENSAPI_GetContentDocumentReqProcessor  

Test Class:   SENSAPI_GetContentDocumentReqProcTest
History
Date            Author              Comments
-------------------------------------------------------------
11-04-2022      Tushar Kaore      		Created
------------------------------------------------------------*/
@isTest
private class SENSAPI_GetContentDocumentReqProcTest {
    
    /**
     * Test data setup
     */ 
    @testSetup static void setup() {
        ContentVersion contentVersion = new ContentVersion(
            Title = 'Test Doc',
            PathOnClient = 'Test Doc.txt',
            VersionData = Blob.valueOf('Test Content'),
            IsMajorVersion = true
        );
        insert contentVersion;    
    }
    
    /**
     * Testing success scearnio
     */ 
    @istest private static void processRequestSuccess(){
        
        
        RestRequest req = new RestRequest(); 
        RestResponse res = new RestResponse();
        
        RestContext.request = req;
        RestContext.response= res;
        
        ContentVersion cv = [SELECT Id, ContentDocumentId FROM ContentVersion WHERE Title = 'Test Doc' LIMIT 1];
        SENSAPI_GetContentDocumentRequest request = new SENSAPI_GetContentDocumentRequest();
        request.documentIds = new List<String>{cv.ContentDocumentId};
        
        
        SENSAPI_GetContentDocumentReqProcessor processor = new SENSAPI_GetContentDocumentReqProcessor();
        processor.process(JSON.serialize(request));
        
        system.assert(RestContext.response.statusCode  == 200, 'Error processing request');
    }
    
    /**
     * Testing error with no input
     */ 
    @istest private static void noDocumentIdPassedError(){
        
        
        RestRequest req = new RestRequest(); 
        RestResponse res = new RestResponse();
        
        RestContext.request = req;
        RestContext.response= res;
        
        ContentVersion cv = [SELECT Id, ContentDocumentId FROM ContentVersion WHERE Title = 'Test Doc' LIMIT 1];
        SENSAPI_GetContentDocumentRequest request = new SENSAPI_GetContentDocumentRequest();
        request.documentIds = new List<String>();
        
        
        SENSAPI_GetContentDocumentReqProcessor processor = new SENSAPI_GetContentDocumentReqProcessor();
        processor.process(JSON.serialize(request));
        
        system.assert(RestContext.response.statusCode  == 400, 'Error in request validation');
    }
    
     /**
     * Testing error with invalid document id
     */ 
    @istest private static void invalidDocumentIdError(){
        
        
        RestRequest req = new RestRequest(); 
        RestResponse res = new RestResponse();
        
        RestContext.request = req;
        RestContext.response= res;
        
        ContentVersion cv = [SELECT Id, ContentDocumentId FROM ContentVersion WHERE Title = 'Test Doc' LIMIT 1];
        SENSAPI_GetContentDocumentRequest request = new SENSAPI_GetContentDocumentRequest();
        request.documentIds = new List<String>{'InvalidDocId'};
        
        
        SENSAPI_GetContentDocumentReqProcessor processor = new SENSAPI_GetContentDocumentReqProcessor();
        processor.process(JSON.serialize(request));
        
        system.assert(RestContext.response.statusCode  == 400, 'Error in no documents');
    }
    
    /**
     * Testing error with invalid JSON
     */ 
    @istest private static void invalidJsonError(){
        
        
        RestRequest req = new RestRequest(); 
        RestResponse res = new RestResponse();
        
        RestContext.request = req;
        RestContext.response= res;
        
        
        SENSAPI_GetContentDocumentReqProcessor processor = new SENSAPI_GetContentDocumentReqProcessor();
        processor.process('invalid JSON');
        
        system.assert(RestContext.response.statusCode  == 500, 'Error in exception handling');
    }
    
    
      
}