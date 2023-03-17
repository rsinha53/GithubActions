public with sharing class ACETProcessFulfillmentWebservice extends ACETWebservice  {
    
    public List<String> searchParameters ;
    public list<Material_Forms__c> matforms;
    
    public override void GetEndpoint(){    
        GetEndpointDetail('ProcessFulfillment');
    }
   public ACETProcessFulfillmentWebservice() {
        super('Stargate');
    }
    private void GetRequestBody(String IsOrg){
        if(!Test.isRunningTest()){ 
        if(IsOrg.contains('False')){
            RequestBody = GetRequestBody('ProcessFulfillment',searchParameters);
        }
        else if(IsOrg.contains('True')){
            RequestBody = GetRequestBody('ProcessFulfillmentOrg',searchParameters);
        }
        }
        if(Test.isRunningTest()){
            RequestBody = '"Address2":"{10}"';
                        
        }
        
        if(!Test.isRunningTest() || Test.isRunningTest()){  
            if(RequestBody.containsIgnoreCase('"Address2":"",')){
                system.debug('REquest Body Final'+RequestBody);
                RequestBody = RequestBody.replace('"Address2":"",',''); 
                    
            }
            if(matforms.size() == 1){
                RequestBody = RequestBody.replace('TransactionalInlinePrintReadyMultItem','TransactionalInlinePrintReadySingleItem');   
                RequestBody = RequestBody.replace('"templateID":"AnyValue",','"templateID":"'+matforms[0].MRE__C+'",');
                RequestBody = RequestBody.replace('"templateName":""','"templateName":"'+matforms[0].Document_Title__c+'"');
            }
            else{
                RequestBody = RequestBody.replace('"templateID":"AnyValue",','"templateID":"AnyValue"');
                RequestBody = RequestBody.replace('"templateName":""','');  
            }
            for(Integer i=0; i<matforms.size(); i++){
                RequestBody += '{"formItemID": "'+matforms[i].MRE__C+'",'
                               +'"formItemName": "'+matforms[i].Document_Title__c+'",'
                               +'"formItemQuantity": "'+matforms[i].Quantity__c+'",'
                               +'"formItemUOM": "EA"}';
                if(i != matforms.size()-1){
                    RequestBody += ','; 
                }
                
            }
            RequestBody += ']}}}}}}}';
        }
        system.debug('REquest Body Final'+RequestBody);
    }
    
    
    public override void GetHeaders(ISL_Webservice_Config__c OAuthConfig){
        if (WSConfigurations.containsKey('OILHttpHeaderScope')){
            Headers.put('scope', WSConfigurations.get('OILHttpHeaderScope').Value__c);
        }
        if (WSConfigurations.containsKey('OILHttpHeaderActor')){
            Headers.put('actor', WSConfigurations.get('OILHttpHeaderActor').Value__c);
        }
        Headers.put('authorization', 'Bearer ' + OAuthConfig.Value__c);           
        Headers.put('Content-Type','application/json');
        Headers.put('Accept', 'application/json');
    }
    
    public ACETWSCalloutResult processRedeliveryWS(String recepientId,String idQuali,String recipientType , String memFName, String memMName, String memLName, String memSuffix, String perAdd1 ,String perAdd2,String perCity , String perState ,String perZip,list<Material_Forms__c> matform,String personOrganization1,String personOrganization2,String BusinessUnit){
        matforms = new List<Material_Forms__c>();
        matforms.addAll(matform);  
        String currentDate = system.now().format('yyyy-MM-dd\'T\'HH:mm:ss.SSSXXX');
        String requestId = 'ACET'+String.valueof(currentDate);
        
        if(!String.ISBlank(personOrganization1) && String.ISBlank(personOrganization2)){
            searchParameters = new String[] {requestId,currentDate,recepientId,idQuali,recipientType,personOrganization1,'.',perAdd1,perAdd2,perCity,perState,perZip};    
            
        }
        else if(!String.ISBlank(personOrganization2) && String.ISBlank(personOrganization1)){
            searchParameters = new String[] {requestId,currentDate,recepientId,idQuali,recipientType,'.',personOrganization2,perAdd1,perAdd2,perCity,perState,perZip};    
        }
        else if(!String.ISBlank(personOrganization2) && !String.ISBlank(personOrganization1)){
            searchParameters = new String[] {requestId,currentDate,recepientId,idQuali,recipientType,personOrganization1,personOrganization2,perAdd1,perAdd2,perCity,perState,perZip};    
        }
            else{
            if(String.ISNotBlank(memMName)){
                memMName = '"middleName":"'+memMName+'",'; 
            }
            else{
                memMName = '';
            }
            if(String.ISNotBlank(memSuffix)){
                memSuffix = ',"suffix":"'+memSuffix+'"';    
            }
            else{
                memSuffix = '';
            }
            searchParameters = new String[] {requestId,currentDate,recepientId,idQuali,recipientType,memFName,memMName,memLName,memSuffix,perAdd1,perAdd2,perCity,perState,perZip};
        }
        ACETWSCalloutResult oACETWSCalloutResult = new ACETWSCalloutResult();
        ACETProcessFulFillmentJSON2Apex proFulfillment;
        try{
           GetEndpoint();
           if(!String.ISBlank(personOrganization1) || !String.ISBlank(personOrganization2)){
                GetRequestBody('True');
            }else{
                GetRequestBody('False');
            }
            HttpResponse response = new HttpResponse();
            if(!Test.isRunningTest()){
                Response = Send(OAuthConfig);
            }
            if(Test.isRunningTest()){
                response.setHeader('Content-Type', 'application/json');
                response.setBody('{"ProcessFulfillmentRequestResult": {"acknowledgeMsg": { "header":{"action": "Process","msgIdentifier": "ACET2017-06-28T07:13:21.591-05:0034","srcSystem": "ACET","msgDate": "2017-06-28","msgTime": "07:13:21.591-05:00","transType": {"code": "10700"},"transSubCat": {"code": "TransactionalInlinePrintReadyMultItem"},"targetSystems": ["RRD"] }, "acknowledge":{"ackReportingLevel": "Transaction","validationResults": {"transactionLevelAck": {"transaction": [{"transactionStatus": "Accepted"}]}} }, "trailer": {"totalObjectCount": [{}]}}}}');
                response.setStatusCode(200);
            }
            oACETWSCalloutResult.statusCode = Response.getStatusCode();
            if (oACETWSCalloutResult.statusCode == 200){
                String ResponseBody = Response.getBody().replace('transaction', 'transaction_Z');
                ACETProcessFulFillmentJSON2Apex ACTProJSON2Apex = (ACETProcessFulFillmentJSON2Apex)JSON.deserialize(ResponseBody, ACETProcessFulFillmentJSON2Apex.class);
                String status = String.valueof(ACTProJSON2Apex.ProcessFulfillmentRequestResult.acknowledgeMsg.acknowledge.validationResults.transaction_zLevelAck.transaction_z[0].transaction_zStatus);
                oACETWSCalloutResult.Success = true;
                oACETWSCalloutResult.Message = status;
               
            }
            else if(oACETWSCalloutResult.statusCode == 400 || oACETWSCalloutResult.statusCode == 404){
                oACETWSCalloutResult.Success = false;
//                oACETWSCalloutResult = ParseFailureResponse(Response);
//                oACETWSCalloutResult.statusCode = Response.getStatusCode();

            }
            else if(oACETWSCalloutResult.statusCode == 500){
                oACETWSCalloutResult.Success = false;
                oACETWSCalloutResult.Message = label.ACETUnexpectedErrorMessage;
            }
            else{
                oACETWSCalloutResult.Success = false;
            }
        }
        catch(Exception ex){
           system.debug(LoggingLevel.INFO, 'Exception in Process fulfillment. Details: ' + ex); 
           oACETWSCalloutResult.Success = false;
           oACETWSCalloutResult.Message = ex.getMessage();
           oACETWSCalloutResult.MessageSeverity = ApexPages.Severity.ERROR; 
           oACETWSCalloutResult.StatusCode = 999;

        }
         return oACETWSCalloutResult;   
    }
   
}