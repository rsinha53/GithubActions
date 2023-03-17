public class ACETFinfFulfillmentHistoryWebservice extends ACETWebservice {
    
    public List<ACETCommunicationHistoryResult> Commhistory{get;set;}
    
    public override void GetEndpoint()
    {
        GetEndpointDetail('FindFulfillmentHistoryv3');
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
    
    public void GetRequestBody(String documentId){
        RequestBody = '{' +
                        '"findFulfillmentHistory": {' +
                            '"findFulfillmentHistoryRequest": {' +
                                '"searchSourceID": "ACET",' +
                                '"documentID": "' + documentId + '"' +
                              '}' +
                         '}' + 
                       '}';
        
        //RequestBody = GetRequestFormatByName('FindFulfillmentHistory_HardcodedRequest');
        system.debug('RequestBody is '+RequestBody);
    }
    
    public ACETWSCalloutResult FindFulfillmentHistoryWS(String documentId){
        ACETWSCalloutResult oACETWSCalloutResult = new ACETWSCalloutResult();
        oACETWSCalloutResult.Response = new List<ACETCommunicationHistoryResult>();
        
        try{
            GetEndpoint();
            GetRequestBody(documentId);
            GetMethod();
            HttpResponse Response = Send(OAuthConfig);
            system.debug('Status code is '+Response.getStatusCode()+'body is '+Response.getBody());
            
            Commhistory = new List<ACETCommunicationHistoryResult>();
            if (Response.getStatusCode() == 200){
                String jsonstring = Response.getBody();
                system.debug('--->jsonstring'+jsonstring);
                if(jsonstring.containsIgnoreCase('responseExceptionDetail')){
                    JSONParser parse = JSON.createParser(jsonstring);
                    system.debug('--->parse'+parse);
                    system.debug('--->parse.nextToken()'+parse.nextToken());                    
                    while(parse.nextToken() != null) {
                        if((parse.getCurrentToken() == JSONToken.FIELD_NAME)){
                            String fieldName = parse.getText();
                            parse.nextToken();
                            if(fieldName == 'message') {
                                if(parse.getText() != null){
                                    oACETWSCalloutResult.Success = true;
                                    oACETWSCalloutResult.Message = parse.getText();                                    
                                }
                                break;
                            }
                        }
                    }                                        
                }
                else{
                    ACETFindFulfillmentHistoryJSON2Apex FFHjson2apex = (ACETFindFulfillmentHistoryJSON2Apex)JSON.deserializeStrict (Response.getBody(), ACETFindFulfillmentHistoryJSON2Apex.class);
                    system.debug('FFHjson2apex is '+FFHjson2apex);
                    
                    if(FFHjson2apex.findFulfillmentHistoryResult.findFulfillmentHistoryResponse.searchResultSet.size() >0)
                    {
                        for(ACETFindFulfillmentHistoryJSON2Apex.SearchResultSet str: FFHjson2apex.findFulfillmentHistoryResult.findFulfillmentHistoryResponse.searchResultSet)
                        {
                            ACETCommunicationHistoryResult result = new ACETCommunicationHistoryResult();
                            result.requestdate = ACETWebserviceHelper.formatDatetimeFromDashToSlash(str.responseRequestHeader.requestDate);
                            result.status = str.responseCurrentEventLog.statuscode;
                            
                            ACETFindFulfillmentHistoryJSON2Apex.Person person = str.responseRequestDetail.responseTransactionalRequestDetail.responseRecipient[0].person;
                            
                            result.Name = (person.prefix == null ? '' : (person.prefix + ' ')) + (person.firstName == null ? '' : (person.firstName + ' ')) + (person.middleName == null ? '' : (person.middleName + ' ')) + (person.lastName == null ? '' :(person.lastName + ' ')) + (person.suffix == null ? '' : person.lastName);
                            result.add1 = str.responseRequestDetail.responseTransactionalRequestDetail.responseRecipient[0].MailToAddress.Address1;
                            result.add2 = str.responseRequestDetail.responseTransactionalRequestDetail.responseRecipient[0].MailToAddress.Address2;
                            result.dmethod = str.responseRequestDetail.responseTransactionalRequestDetail.responseRecipient[0].deliveryMethod1;
                            result.sntdate = ACETWebserviceHelper.formatDatetimeFromDashToSlash(str.responseCurrentEventLog.dispatchedDate);
                            result.source = str.responseRequestHeader.sourceIDName;
                            result.city = str.responseRequestDetail.responseTransactionalRequestDetail.responseRecipient[0].MailToAddress.city;
                            result.state = str.responseRequestDetail.responseTransactionalRequestDetail.responseRecipient[0].MailToAddress.State;
                            result.zip = str.responseRequestDetail.responseTransactionalRequestDetail.responseRecipient[0].MailToAddress.Zip;
                            result.email = str.responseRequestDetail.responseTransactionalRequestDetail.responseRecipient[0].emailAddress;
                            result.fax = str.responseRequestDetail.responseTransactionalRequestDetail.responseRecipient[0].faxNumber;
                            Commhistory.add(result);
                            
                        }
                    }
                    
                    if(Commhistory.size()>0){
                        oACETWSCalloutResult.Success = true;
                        oACETWSCalloutResult.Message = '';
                        oACETWSCalloutResult.Response = Commhistory;
                    }
                }
            }
            else{
                oACETWSCalloutResult.Success = false;
                oACETWSCalloutResult.Message = 'Problem with FindFulfillmentHistory Webservice';
                oACETWSCalloutResult.MessageSeverity = ApexPages.Severity.ERROR;
            }
            
        }
        catch(Exception ex){
            system.debug(LoggingLevel.INFO, 'Exception in FindFulfillmentHistory Webservice,Message: ' + ex.getMessage()+'at line '+ex.getLineNumber()); 
            oACETWSCalloutResult.Success = false;
            oACETWSCalloutResult.Message = 'Problem with FindFulfillmentHistory Webservice';
            oACETWSCalloutResult.MessageSeverity = ApexPages.Severity.ERROR;
        }
        system.debug('oACETWSCalloutResult-->'+oACETWSCalloutResult);
        return oACETWSCalloutResult;
    }
}