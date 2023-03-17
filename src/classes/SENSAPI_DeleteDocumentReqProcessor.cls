public without sharing class SENSAPI_DeleteDocumentReqProcessor implements IRestRequestProcessor {
 public SENSAPI_DeleteDocumentRequest request;
    public SENSAPI_DeleteDocumentResponse responseDetails;
    //process request and return response
    public IRestResponseWrapper process(String requestStructure){
        Savepoint sp = Database.setSavepoint();            
        try{   
            initProcessor(requestStructure);
            System.debug('requestStructure***:'+requestStructure);
            System.debug('request***:'+request);
            responseDetails = new SENSAPI_DeleteDocumentResponse();
            if(String.isNotBlank(request.documentId)){
                List<contentDocument> cdocsList = new list<contentDocument>();
                List<contentDocument> cdoc = [SELECT id from contentDocument where id=:request.documentId];
                if(cdoc.size()>0){
                    for(contentDocument cd : cdoc){
                        cdocsList.add(cd);
                    }
                    delete cdocsList;
                    responseDetails.status = new SENSAPI_DeleteDocumentResponse.API_Status(200,true);
                }
                else{
                   responseDetails.status = new SENSAPI_DeleteDocumentResponse.API_Status(400,false,SENSAPI_Constant.NO_DOCUMENTS_FOUND);  
                }
            }
            else{
              responseDetails.status = new SENSAPI_DeleteDocumentResponse.API_Status(400,false,SENSAPI_Constant.REQUIREDFIELD_MISSING);  
            } 
        }
        catch(Exception ex) {
            system.debug('enter catch exception'+ex.getMessage());
            responseDetails.status = new SENSAPI_DeleteDocumentResponse.API_Status(500, false, ex.getMessage() + ex.getStackTraceString());            
        }  
        RestContext.response.statusCode = responseDetails.status.responseCode;
        return responseDetails;
    }
    private void initProcessor(String requestStructure) {
        try{
            request = SENSAPI_DeleteDocumentRequest.parse(requestStructure);
        }catch(Exception e){
            system.debug('enter catch exception'+e.getMessage());
        }        
    }
}