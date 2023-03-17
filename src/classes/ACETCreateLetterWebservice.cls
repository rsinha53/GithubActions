Public Class ACETCreateLetterWebservice extends ACETWebservice{

    public ACETCreateLetterWebservice(){
    if(!Test.isRunningTest()){
    super('Stargate');
    }
    }
    
    private final static string Boundary = '1ff13444ed8140c7a32fc4e6451aa76d'; //This value would be same for all environments
    public String last4Bytes;  
    public override void GetEndpoint(){
        GetEndpointDetail('CreateLetter');
    }
    
    private void GetRequestBody(String templatename , String XMLattach){
        
        String testXML = '<?xml version="1.0" encoding="UTF-8" standalone="yes" ?><data><datum name="CaseID">00011122C</datum></data>';   
        Blob beforeblob = Blob.valueOf(XMLattach);
        Blob bodyBlob = null;
        String body = EncodingUtil.base64Encode(beforeblob);
        
        List<String> SearchParameters = new String[] {body,templatename};
            String header = '--'+boundary+'\nContent-Disposition: form-data; \nContent-Type: application/json';
        String footer = '--'+boundary+'--';             
        
        String headerEncoded = EncodingUtil.base64Encode(Blob.valueOf(header+'\r\n\r\n'));
        if(Test.isRunningTest())
        {
            headerEncoded+= '==';
        }
        while(headerEncoded.endsWith('=')){
            header+=' ';
            headerEncoded = EncodingUtil.base64Encode(Blob.valueOf(header+'\r\n\r\n'));
        }
        //String bodyEncoded = EncodingUtil.base64Encode(Blob.valueOf(GetRequestBody('CreateLetter_HardcodedRequest',SearchParameters)));
        String requestBodyStr = GetRequestBody('CreateLetter_HardcodedRequest',SearchParameters);
        //requestBodyStr = '{"CreateLetterReq":{"pushData":{"externalId":"","mapName":"ACETDataPushMap","mapSchemaXML":{"data":"PD94bWwgdmVyc2lvbj0iMS4wIiBlbmNvZGluZz0iVVRGLTgiIHN0YW5kYWxvbmU9InllcyIgPz4NCjxkYXRhPg0KPHRlbXBsYXRlPg0KCTxUZW1wbGF0ZUVmZmVjdGl2ZURhdGU+PC9UZW1wbGF0ZUVmZmVjdGl2ZURhdGU+DQogICAgICAgIDx0ZW1wbGF0ZU5hbWU+Rm9yZWlnbl9UcmF2ZWw8L3RlbXBsYXRlTmFtZT4NCjwvdGVtcGxhdGU+DQo8Y2FzZUluZm9ybWF0aW9uPg0KCTxjYXNlTnVtYmVyPjAwMDI1NjE5PC9jYXNlTnVtYmVyPg0KCTxEYXRlPjIwMTgtMDgtMDk8L0RhdGU+DQogICAgICAgIDxTaXR1c1N0YXRlPjwvU2l0dXNTdGF0ZT4NCjwvY2FzZUluZm9ybWF0aW9uPg0KPElEPg0KCTxlbmdhZ2VPbmVXb3JrSXRlbUlEPjwvZW5nYWdlT25lV29ya0l0ZW1JRD4NCgk8RkhVQnJlcXVlc3RJRD48L0ZIVUJyZXF1ZXN0SUQ+DQogICAgICAgIDxFeHRlcm5hbElEPjwvRXh0ZXJuYWxJRD4NCiAgICAgICAgPE1lbWJlcklkPjwvTWVtYmVySWQ+DQoJPFByb3ZpZGVyVGF4SWQ+PC9Qcm92aWRlclRheElkPg0KIDwvSUQ+DQoNCiA8VXNlckluZm8+DQoJPEZpcnN0TmFtZT5QYXZhbjwvRmlyc3ROYW1lPg0KCTxMYXN0TmFtZT5Nb2trYXBhdGk8L0xhc3ROYW1lPg0KIDwvVXNlckluZm8+DQogPERlbGl2ZXJ5TWV0aG9kSW5mbz4NCgk8ZGVsaXZlcnlNZXRob2QxPk1haWw8L2RlbGl2ZXJ5TWV0aG9kMT4NCgk8ZGVsaXZlcnlNZXRob2QyPjwvZGVsaXZlcnlNZXRob2QyPg0KCTxFbWFpbD48L0VtYWlsPg0KCTxGYXg+PC9GYXg+DQogPC9EZWxpdmVyeU1ldGhvZEluZm8+DQogPGxldHRlckRlbGl2ZXJ5T3B0aW9uPg0KICAgICAgICA8ZGVsaXZlcnlPcHRpb25OYW1lPkZIVUI8L2RlbGl2ZXJ5T3B0aW9uTmFtZT4NCiA8L2xldHRlckRlbGl2ZXJ5T3B0aW9uPg0KIDxSZWNpcGllbnQ+DQoJPHJlY2lwaWVudFR5cGU+TWVtYmVyPC9yZWNpcGllbnRUeXBlPg0KICAgICAgICA8cmVjaXBpZW50c3VidHlwZT5QZXJzb248L3JlY2lwaWVudHN1YnR5cGU+DQoJPEZhY2lsaXR5TmFtZT48L0ZhY2lsaXR5TmFtZT4NCgk8Rmlyc3ROYW1lPlRlc3Q8L0ZpcnN0TmFtZT4NCgk8UmVjaXBpZW50TWlkZGxlTmFtZT48L1JlY2lwaWVudE1pZGRsZU5hbWU+DQoJPExhc3ROYW1lPlRlc3QgTGFzdDwvTGFzdE5hbWU+DQoJPFN1ZmZpeD48L1N1ZmZpeD4NCjwvUmVjaXBpZW50Pg0KPC9kYXRhPg=="},"pushUserId":"","template":{"templateEffectiveDate":"2015-06-20T16:01:00-06:00","templateID":"","templateName":"Foreign_Travel"}},"letterDeliveryOption":{"deliveryOptionName":"FHUB"}}}';
        String bodyEncoded = '';
        if(Test.isRunningTest())
        {
            requestBodyStr = '{"Request":"Test"}';
        }
        if(String.isNotBlank(requestBodyStr)) {
            bodyEncoded = EncodingUtil.base64Encode(Blob.valueOf(requestBodyStr)); 
        }
        //String last4Bytes = bodyEncoded.substring(bodyEncoded.length()-4,bodyEncoded.length());
        last4Bytes = '';
        if(String.isNotBlank(bodyEncoded)) {
            last4Bytes = bodyEncoded.substring(bodyEncoded.length()-4,bodyEncoded.length());    
        }
        
        if(last4Bytes.endsWith('==')) {
            
            last4Bytes = last4Bytes.substring(0,2) + '0K';
            bodyEncoded = bodyEncoded.substring(0,bodyEncoded.length()-4) + last4Bytes;
            String footerEncoded = EncodingUtil.base64Encode(Blob.valueOf(footer));
            bodyBlob = EncodingUtil.base64Decode(headerEncoded+bodyEncoded+footerEncoded);
            
        } else if(last4Bytes.endsWith('=')) {
            
            last4Bytes = last4Bytes.substring(0,3) + 'N';
            bodyEncoded = bodyEncoded.substring(0,bodyEncoded.length()-4) + last4Bytes;
            footer = '\n' + footer;
            String footerEncoded = EncodingUtil.base64Encode(Blob.valueOf(footer));
            bodyBlob = EncodingUtil.base64Decode(headerEncoded+bodyEncoded+footerEncoded);              
            
        } else {
            
            footer = '\r\n' + footer;
            String footerEncoded = EncodingUtil.base64Encode(Blob.valueOf(footer));
            bodyBlob = EncodingUtil.base64Decode(headerEncoded+bodyEncoded+footerEncoded);  
        }
        System.debug(LoggingLevel.INFO, 'RequestBody ********' + RequestBody);
        RequestBody = bodyBlob.toString();
        // Debug added by Pavan
        System.debug(LoggingLevel.INFO, 'RequestBody ********' + RequestBody);
    }
    
    public override void GetMethod(){
        Method = 'PUT';
    }
    
    public override void GetHeaders(ISL_Webservice_Config__c OAuthConfig){
        if (WSConfigurations.containsKey('OILHttpHeaderAccept')){
            Headers.put('accept',WSConfigurations.get('OILHttpHeaderAccept').Value__c );
        }
        if (WSConfigurations.containsKey('OILHttpHeaderScope')){
            Headers.put('scope', WSConfigurations.get('OILHttpHeaderScope').Value__c);
        }
        if (WSConfigurations.containsKey('OILHttpHeaderActor')){
            Headers.put('actor', WSConfigurations.get('OILHttpHeaderActor').Value__c);
        }
        Headers.put('authorization', 'Bearer ' + OAuthConfig.Value__c);           
        Headers.put('mediatype', 'application/json');
        Headers.put('Content-Disposition', 'form-data; name="json"');
        Headers.put('Content-Type','multipart/form-data; charset="UTF-8"; boundary="' + Boundary + '"');
        Headers.put('MIME-Version','1.0');
        Headers.put('timestamp', String.valueOf(system.now().millisecond()));
    }
    
    public ACETWSCalloutResult CreateLetterWS(String attachXML,String templatename){
        // XMLattach = attachXML; 
        ACETWSCalloutResult oACETWSCalloutResult = new ACETWSCalloutResult();
        ACETCreateLetterResult letterInfo = new ACETCreateLetterResult();
        try{
            GetEndpoint();
            GetRequestBody(templatename , attachXML );
            GetMethod();
            HttpResponse Response = Send(OAuthConfig);
            system.debug(LoggingLevel.INFO, 'Respone--->'+Response.getBody());
            if (Response.getStatusCode() == 200){
                                if(ErrorLogEnabled){

            createAppErrorLog('ACET', ServiceName,RelativeURL, Response.getStatus(), Response.getStatusCode(),RequestBody,Response.getBody());
                                } if(Response.getBody() != null){
                    ACETCreateLetterJSON2Apex ACETCLJSON2Apex = (ACETCreateLetterJSON2Apex)JSON.deserialize(Response.getBody(), ACETCreateLetterJSON2Apex.class);
                    system.debug(LoggingLevel.INFO, 'ACETCLJSON2Apex ****'+ ACETCLJSON2Apex );
                    if(String.isNotBlank(String.valueof(ACETCLJSON2Apex.createLetterResult.letterId))){
                    letterInfo.resultLetterId  = String.valueof(ACETCLJSON2Apex.createLetterResult.letterId); 
                    
                    oACETWSCalloutResult.Success = true;
                    oACETWSCalloutResult.Message = '';
                    oACETWSCalloutResult.Response = letterInfo;
                    system.debug(LoggingLevel.INFO, 'letterInfo---->'+letterInfo);
                    }
                    else{
                        oACETWSCalloutResult.Success = false;
                        oACETWSCalloutResult.Message = system.Label.ACETLetterWorkItemIdErrorMessage;
                    }
                }
                else{
                    oACETWSCalloutResult.Success = false;
                    oACETWSCalloutResult.Message = system.Label.ACETLetterWorkItemIdErrorMessage;
                }
            }else if(Response.getStatusCode() == 500){
                oACETWSCalloutResult.Success = false;
                oACETWSCalloutResult.Message = system.Label.ACETUnexpectedErrorMessage;
            }
            else if(Response.getStatusCode() == 404){
                oACETWSCalloutResult.Success = false;
                oACETWSCalloutResult.Message = system.Label.ACETUnexpectedErrorMessage;
            }
            else if(Response.getStatusCode() == 400){
                String jsonstring = Response.getBody();
                system.debug('--->jsonstring'+jsonstring);
                JSONParser parse = JSON.createParser(jsonstring);
                system.debug('--->parse'+parse);
                system.debug('--->parse.nextToken()'+parse.nextToken());                    
                while(parse.nextToken() != null) {
                    if((parse.getCurrentToken() == JSONToken.FIELD_NAME)){
                        String fieldName = parse.getText();
                        system.debug('fieldName '+fieldName);
                        parse.nextToken();
                        if(fieldName == 'description') {
                            if(parse.getText() != null){
                                oACETWSCalloutResult.Success = false;
                                oACETWSCalloutResult.Message = parse.getText();  
                                oACETWSCalloutResult.responseBody = String.valueof(Response.getStatusCode());
                            }
                            break;
                        }
                    }
                }                                        
            }
            else{
                oACETWSCalloutResult = ParseFailureResponse(Response);
            }
        }
        Catch(Exception ex){
            system.debug(LoggingLevel.INFO, 'Exception in Create Letter Webservice. Details: ' + ex); 
            oACETWSCalloutResult.Success = false;
            oACETWSCalloutResult.Message = ex.getMessage();
            oACETWSCalloutResult.MessageSeverity = ApexPages.Severity.ERROR;
        }
        //system.debug('**oACETWSCalloutResult**'+oACETWSCalloutResult);
        return oACETWSCalloutResult;
    }
    
    
}