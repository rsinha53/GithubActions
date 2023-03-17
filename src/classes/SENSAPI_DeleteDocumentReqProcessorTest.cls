@isTest
public class SENSAPI_DeleteDocumentReqProcessorTest {
    
    static testMethod void deleteDocWithValidParam(){
        ContentVersion contentVersion = new ContentVersion(
            Title          = 'a picture',
            PathOnClient   = 'Pic.jpg',
            VersionData    = Blob.valueOf('Test Content'),
            IsMajorVersion = true);
        insert contentVersion;
        ContentVersion contentVersion_2 = [SELECT Id, Title, ContentDocumentId FROM ContentVersion WHERE Id = :contentVersion.Id LIMIT 1];
        List<ContentDocument> documents = [SELECT Id, Title, LatestPublishedVersionId FROM ContentDocument];
        string requestStructure = '{"documentId": "'+documents[0].Id+'"}';
        
        test.startTest();
        RestRequest req = new RestRequest();
        RestResponse res = new RestResponse();
        req.requestBody = Blob.valueof(requestStructure);
        RestContext.request = req;
        RestContext.response= res;
        string jsonValue = RestContext.request.requestBody.toString();
        SENSAPI_DeleteDocumentReqProcessor reqprocessor = new SENSAPI_DeleteDocumentReqProcessor();
        IRestResponseWrapper responseWrapper = reqprocessor.process(jsonValue);
        test.stopTest();
    }
    
    static testMethod void testProcessReqNoDocsFound() {
        RestRequest req = new RestRequest(); 
        RestResponse res = new RestResponse();
        string requestStructure = '{"documentId": "abc4"}';
        req.requestBody = Blob.valueof(requestStructure);
        RestContext.request = req;
        RestContext.response= res;
        string jsonValue = RestContext.request.requestBody.toString();
        Test.startTest(); 
        SENSAPI_DeleteDocumentReqProcessor reqprocess = new SENSAPI_DeleteDocumentReqProcessor();
        IRestResponseWrapper responseWrapper = reqprocess.process(jsonValue);  
        Test.stopTest();
    }
    
    static testMethod void testProcessReqWithRequiredMissing() {
        RestRequest req = new RestRequest(); 
        RestResponse res = new RestResponse();
        string requestStructure = '{"documentId": ""}';
        req.requestBody = Blob.valueof(requestStructure);
        RestContext.request = req;
        RestContext.response= res;
        string jsonValue = RestContext.request.requestBody.toString();
        Test.startTest(); 
        SENSAPI_DeleteDocumentReqProcessor reqprocess = new SENSAPI_DeleteDocumentReqProcessor();
        IRestResponseWrapper responseWrapper = reqprocess.process(jsonValue);  
        Test.stopTest();
    }
    
    static testMethod void testProcessReqWithCatchBlock() {
        RestRequest req = new RestRequest(); 
        RestResponse res = new RestResponse();
        string requestStructure = '{"documentId": }';
        req.requestBody = Blob.valueof(requestStructure);
        RestContext.request = req;
        RestContext.response= res;
        string jsonValue = RestContext.request.requestBody.toString();
        Test.startTest(); 
        SENSAPI_DeleteDocumentReqProcessor reqprocess = new SENSAPI_DeleteDocumentReqProcessor();
        IRestResponseWrapper responseWrapper = reqprocess.process(jsonValue);  
        Test.stopTest();
    }
}