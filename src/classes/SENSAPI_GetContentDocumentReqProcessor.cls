/*------------------------------------------------------------
Author:         Tushar Kaore
Description:    Processor class for "GET Content Document" API
User Story:   Used in US4942396

Test Class:    SENSAPI_GetContentDocumentReqProcTest
History
Date            Author              Comments
-------------------------------------------------------------
11-04-2022      Tushar Kaore        Created
------------------------------------------------------------*/
public without sharing class SENSAPI_GetContentDocumentReqProcessor implements IRestRequestProcessor {
    SENSAPI_GetContentDocumentRequest request;
    SENSAPI_GetContentDocumentResponse responseDetails;
    
  
    //process request and return response
    public IRestResponseWrapper process(String jsonRequest){
        Savepoint sp = Database.setSavepoint();
        
        try{
            responseDetails = new SENSAPI_GetContentDocumentResponse();
            initProcessor(jsonRequest);
            if(validateRequest()){ //validate request here 
                List<ContentDocument> contentDocuments = SENSAPI_Utility.getContentDocuments(request.documentIds);
                List<SENSAPI_GetContentDocumentResponse.Document> documents = populateDocumentDetails(contentDocuments);
                if(documents != null && documents.size() > 0){
                    responseDetails.status = new SENSAPI_StatusResponse(true,200);
                    responseDetails.document = documents;
                }else{
                    responseDetails.status = new SENSAPI_StatusResponse(false,400, SENSAPI_Constant.NO_DOCUMENTS_FOUND);
                }
                
            }
        }
        catch(Exception ex) {
            Database.rollback(sp);            
            responseDetails.status = new SENSAPI_StatusResponse(false,500,ex.getMessage() +  ' : ' + ex.getStackTraceString());
        }
        RestContext.response.statusCode = responseDetails.status.responseCode;
        return responseDetails;
    }
  
    //Validating the request parameters
    private Boolean validateRequest(){
        Boolean isValid = true;
        List<String> errorMessages = new List<String>(); 
            
        if(request.documentIds == null || (request.documentIds != null && request.documentIds.size() == 0)){
            isValid = false;
            errorMessages.add(SENSAPI_Constant.REQUIREDFIELD_MISSING);
        }
         
        if(!isValid){
            responseDetails.status = new SENSAPI_StatusResponse(false,400,errorMessages);
        }
        return isValid;
    }
    
    
    private void initProcessor(String requestStructure) {
        try{
            request = SENSAPI_GetContentDocumentRequest.parse(requestStructure);
        }catch(Exception e){
            throw new SENSAPI_Exception( SENSAPI_Constant.JSON_PARSER_ERROR + e.getMessage());
        }  
    }


  // Method to populate Content Document to wrapper class
  public static List<SENSAPI_GetContentDocumentResponse.Document> populateDocumentDetails(List<ContentDocument> contentDocs){
        List<SENSAPI_GetContentDocumentResponse.Document> documents = new List<SENSAPI_GetContentDocumentResponse.Document>();
        for(ContentDocument cd : contentDocs){
            SENSAPI_GetContentDocumentResponse.Document doc = new SENSAPI_GetContentDocumentResponse.Document();
            doc.documentId = cd.Id;
            doc.title = cd.Title;
            doc.ownerSensId = cd.OwnerId;
            doc.lastModifiedDate = cd.LastModifiedDate;
            doc.docType = cd.FileExtension;
            doc.contentSize = cd.ContentSize;
            doc.createddate = cd.CreatedDate;
            if(cd.ContentDistributions != null && cd.ContentDistributions.size() > 0){
                doc.downloadURL = cd.ContentDistributions[0].ContentDownloadUrl;
            }
            documents.add(doc);
        }
        return documents;
    }
}