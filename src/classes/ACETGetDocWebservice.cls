public class ACETGetDocWebservice extends ACETWebservice{
    public String docKeysStr;
    public override void GetEndpoint()
    {
        GetEndpointDetail('getDocument');
    }
    public ACETGetDocWebservice() {
        super('Stargate');
    }
    
    public override void GetMethod(){
        Method = 'POST';
    }
    
    public override void GetHeaders(ISL_Webservice_Config__c OAuthConfig){
        
        Headers.put('accept','multipart/form-data' );
        
        if (WSConfigurations.containsKey('OILHttpHeaderScope')){
            Headers.put('scope', WSConfigurations.get('OILHttpHeaderScope').Value__c);
        }
        if (WSConfigurations.containsKey('OILHttpHeaderActor')){
            Headers.put('actor', WSConfigurations.get('OILHttpHeaderActor').Value__c);
        }
        Headers.put('Content-Type', 'application/json;charset=UTF-8');
        
        //Headers.put('userName', 'oil_docu_1');
        String userFederationId = ACETProviderUtility.getFederationIDByUserID();
        if(!String.isEmpty(userFederationId)){
            Headers.put('userName', userFederationId);  
        }
        
        system.debug('OAuthConfig.Value__c is '+OAuthConfig.Value__c);
        Headers.put('authorization', 'Bearer ' + OAuthConfig.Value__c);
    }
    
    public void GetRequestBody(){
        RequestBody = GetRequestFormatByName('getDocumentpdf_HardcodedRequest');
        system.debug('RequestBody is '+RequestBody);
    }
    
      public void GetRequestBody(String repositoryId, String documentId){
        RequestBody = '';
        RequestBody += '{';
        RequestBody +=    '"getDocumentRequest": {';
        RequestBody +=        '"getDocumentRequestType": {';
        RequestBody +=             '"repositoryId": "' + repositoryId + '",';
        RequestBody +=             '"documentId": "' + documentId + '"';
        RequestBody +=        '}';
        RequestBody +=    '}';
        RequestBody += '}';
    }
    public void GetRequestBody(String repositoryId, String documentId, String docKeysStr){
        RequestBody = '';
        RequestBody += '{';
        RequestBody +=    '"getDocumentRequest": {';
        RequestBody +=        '"getDocumentRequestType": {';
        RequestBody +=             '"repositoryId": "' + repositoryId + '",';
        RequestBody +=             '"documentId": "' + documentId + '",';
        RequestBody +=             '' + docKeysStr + '';
        RequestBody +=        '}';
        RequestBody +=    '}';
        RequestBody += '}';
    }    
    public ACETWSCalloutResult fetchDocument(String repositoryId, String documentId){        
        ACETWSCalloutResult result = new ACETWSCalloutResult();
        try{
            GetEndpoint();
            if(repositoryId == 'FiServ')
            {   
                    docKeysStr = '"documentKeys": {"nameVal":[ { "name": "outputFileType","value": "PDF"  },{"name": "statementPortion","value": "CLIPALLSIDES"  },{"name": "clipallsidesoutputtype","value": "PDFSAMEPAGE"}]}';
                    GetRequestBody(repositoryId, documentId, docKeysStr);
            }
            else
            {
                GetRequestBody(repositoryId, documentId);
            }
            GetMethod();
            HttpResponse Response = Send(OAuthConfig);
            
            if(Response.getStatusCode() == 200){
                result.Success = true;
                result.Message = '';                
                result.Attach = new Attachment();
                result.Attach.body = Response.getBodyAsBlob();
            }else if(Response.getStatusCode() == 404){
                result.Success = false;
                result.Message = 'Document Not found';  
                result.MessageSeverity = ApexPages.Severity.ERROR;
            }else{
                result.Success = false;
                result.Message = 'Exception in getDocument Webservice';  
                result.MessageSeverity = ApexPages.Severity.ERROR;  
            }
            
        }
        catch(Exception ex){
            system.debug(LoggingLevel.INFO, 'Exception in getDocument Webservice,Message: ' + ex.getMessage()+'at line '+ex.getLineNumber()); 
            result.Success = false;
            result.Message = 'Exception in getDocument Webservice ' + ex.getMessage();  
            result.MessageSeverity = ApexPages.Severity.ERROR;
        }
        return result;
    }       
}