public class ACETProcessLetterWebservice extends ACETWebservice {
    
    public ACETProcessLetterWebservice(){
     if(!Test.isRunningTest()){
    super('Stargate');
    }
    }
    
    public override void GetEndpoint(){
        GetEndpointDetail('ProcessLetter');
    }
    private void GetRequestBody(){
        RequestBody = GetRequestBody('ProcessLetterRequest',RequestParameters);
        //RequestBody = '{"processLetterReq":{"letterId":"61556","notes":"","serviceFunction":"PUBLIS"}}';//400
        //RequestBody = '{"processLetterReq":{"letterId":"61556","notes":"","serviceFunction""Cancel"}}';//500
    }
    
    public ACETWSCalloutResult ProcessLetterWS(String workItemId, String processName){
        RequestParameters = new String[] {workItemId,processName};
         
        ACETWSCalloutResult oACETWSCalloutResult = new ACETWSCalloutResult();
        try{
            GetEndpoint();
            GetRequestBody();
            GetMethod();
            HttpResponse Response = Send(OAuthConfig);
            if (Response.getStatusCode() == 200){
                                if(ErrorLogEnabled){

              createAppErrorLog('ACET', ServiceName,RelativeURL, Response.getStatus(), Response.getStatusCode(),RequestBody,Response.getBody());
                                }  oACETWSCalloutResult.Success = true;
                oACETWSCalloutResult.Message = '';
            }else if(Response.getStatusCode() == 500||Response.getStatusCode() == 404){
                oACETWSCalloutResult.Success = false;
                oACETWSCalloutResult.Message = system.Label.ACETUnexpectedErrorMessage;
                
                //oACETWSCalloutResult = ParseFailureResponse(Response);
            }else if(Response.getStatusCode() == 400){
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
                                //oACETWSCalloutResult.Success = false;
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
        catch(Exception ex){
            system.debug(LoggingLevel.INFO, 'Exception in Process Letter Webservice. Details: ' + ex); 
            oACETWSCalloutResult.Success = false;
            oACETWSCalloutResult.Message = ex.getMessage();
            oACETWSCalloutResult.MessageSeverity = ApexPages.Severity.ERROR;
        }
        system.debug(LoggingLevel.INFO, 'oACETWSCalloutResult-->'+oACETWSCalloutResult);
        return oACETWSCalloutResult;
    }
    
}