public class ACETLGT_FindLetterWebservice extends ACETWebservice {

   public ACETLGT_FindLetterWebservice(){
    super('Stargate');
   }
    
    public List<String> SearchParameters ;
    
    public override void GetEndpoint(){
        GetEndpointDetail('FindLetter');
    }
    private void GetRequestBody(){
        RequestBody = GetRequestBody('FindLetterRequest',SearchParameters);
        //RequestBody = '{"FindLetterRequest":{"letterRequest":{"letterId":"61552"},"filter":"LIS"}}';//500
    }
    
    public override void GetMethod(){
        Method = 'POST';
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
        Headers.put('Content-Type', 'application/json;charset=UTF-8');
        system.debug('OAuthConfig.Value__c is '+OAuthConfig.Value__c);
        Headers.put('authorization', 'Bearer ' + OAuthConfig.Value__c);
    }
    
    public ACETWSCalloutResult FindLetterWS(String workItemId){
        SearchParameters = new String[] {workItemId};
            ACETWSCalloutResult oACETWSCalloutResult = new ACETWSCalloutResult();
        try{
            GetEndpoint();
            GetRequestBody();
            GetMethod();
            HttpResponse Response = Send(OAuthConfig);
            if (Response.getStatusCode() == 200){
                                if(ErrorLogEnabled){
                        createAppErrorLog('ACET', ServiceName,RelativeURL, Response.getStatus(), Response.getStatusCode(),RequestBody,Response.getBody());
                                }  String responsebody = Response.getBody();
                responsebody = responsebody.replace('Content-ID', 'ContentID');
                responsebody = responsebody.replace('Content-Type', 'ContentType');
                responsebody = responsebody.replace('object', 'object_Z');
                responsebody = responsebody.replace('date', 'dates');
                //responsebody = responsebody.replace('type', 'type_Z');
                //responsebody = responsebody.replace('subtype_Z', 'subtype');
                system.debug('responsebody is '+responsebody);
                ACETFindLetterJSON2Apex FLjson2apex = (ACETFindLetterJSON2Apex)JSON.deserializeStrict (responsebody, ACETFindLetterJSON2Apex.class);
                system.debug('FLjson2apex is '+FLjson2apex);
                ACETFindLetterResult result = new ACETFindLetterResult();
                result.Status = FLjson2apex.MultipartBody.rootAttachment.object_Z.workItems.letterWorkItem[0].status;
                oACETWSCalloutResult.Success = true;
                oACETWSCalloutResult.Message = result.Status;
            }
            else if(Response.getStatusCode() == 500 || Response.getStatusCode() == 404){
                oACETWSCalloutResult.Success = false;
                oACETWSCalloutResult.Message = system.Label.ACETUnexpectedErrorMessage;
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
        catch(Exception ex){
            system.debug(LoggingLevel.INFO, 'Exception in Find Letter Webservice. Details: ' + ex+'line '+ex.getLineNumber()); 
            oACETWSCalloutResult.Success = false;
            oACETWSCalloutResult.Message = 'Exception in Find Letter Webservice. Details: '+ex.getMessage();
            oACETWSCalloutResult.MessageSeverity = ApexPages.Severity.ERROR;
        }
        system.debug('oACETWSCalloutResult-->'+oACETWSCalloutResult);
        return oACETWSCalloutResult;
    }
}