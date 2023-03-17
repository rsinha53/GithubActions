public class ACET_ECAALetterWS extends ACETWebService{

    // US2445831
    // US3292019: Services Failed Messages (Authorization Details) - Krish
    static final String READ_AUTH_COMMON_ERROR_MSG = 'Unexpected Error Occurred with retrieving ECAA Document(s) . Please try again. If problem persists please contact the help desk.';

    public ACET_ECAALetterWS(){
        super(SAEConstants.STARGATE_STG_SERVICENAME);  
        if(Organization_Properties__c.getInstance(UserInfo.getProfileId()).callProductionEndpoints__c){
            this(SAEConstants.STARGATE_PRD_SERVICENAME);
        }
    }

    public ACET_ECAALetterWS(String serviceName) {
        super(serviceName);
    }
    
    public override void getEndpoint(){
        GetEndpointDetail('ECAALetterEndPoint');       
    }
    
    //create request body
    public void getRequestBody(String srnNumber){
        
        RequestBody =   '{'
                            +'"findDocumentsRequest": {'
                                +'"findDocumentsRequestType": {'
                                    +'"repositoryId": "PSEUDO1",'
                                    +'"repositoryName": "",'
                                    +'"documentClass": "u_clinical_docs",'
                                    +'"documentKeys": {'
                                        +'"documentKey": [{'
                                            +'"name": "u_cse_id",'
                                            +'"value": "'+srnNumber+'",'
                                            +'"dataTypeIndicator": "String",'
                                            +'"operator": "="'
                                        +'}]'
                                    +'},'
                                    +'"searchAllVersions": "false"' +','+
                                    +'"pagination": {'
                                        +'"maxRecords": "250",'
                                        +'"pageNumber": "1",' 
                                        +'"pageSize": "25"'            
                                    +'}'		
                                +'}' 
                            +'}'
                        +'}';
    }
    

    public ACETWSCalloutResult findECAALetter(String srnNumber){

        ACETWSCalloutResult ecaaLetterResult = new ACETWSCalloutResult();
        ACET_ECAALetterResult returnResponse = new ACET_ECAALetterResult();
        
        SAEMemberProviderWS MemberProviderService = new SAEMemberProviderWS();
        try{
            List<ACET_ECAALetterResult.ResponseData> wrapRespToreturn = new List<ACET_ECAALetterResult.ResponseData>();
             
            getEndpoint();
            getRequestBody(srnNumber);                          
            User userRec = [SELECT Id, FederationIdentifier FROM User where id =: UserInfo.getUserId()];
            HttpResponse response;  
            //BaseURL = 'https://gateway.optum.com';
            Headers.put('scope', 'search');
            Headers.put('username', userRec.FederationIdentifier); //userRec.FederationIdentifier - replace this with hardcoded value(vgoswam) once testing is done.                   
            String strResponse = null;

                
            if(!SAEUtils.getMockStatus()){

                response = Send(OAuthConfig);

            } else {

                Boolean isStaticResponseChecked = false;
                isStaticResponseChecked = SAEUtils.getMockStatus();

                if(isStaticResponseChecked && !Test.isRunningTest()){

                    String searchparameter = 'FindDoc_'+srnNumber;

                    response=SAEUtils.getResponse(searchparameter);

                }else{

                    //Runs the Production APIs on upper sandboxes
                    response = Send(OAuthConfig); 

                }
                }
            
                   
            Map<String, Object> mapJsonData = new Map<String, Object>();            

            if(response!=null){
                      
                ecaaLetterResult.Success = true;
                ecaaLetterResult.Message = '';
                Integer statusCode = response.getStatusCode(); 
                ecaaLetterResult.statusCode = statusCode; 
                
                if(statusCode == 200){
                    strResponse = response.getBody();
                    if(!String.isEmpty(strResponse)){
                        mapJsonData = (map<String, Object>)JSON.deserializeUntyped(strResponse);
                        if(mapJsonData != null){
                            Map<String, Object>  mapfindDoc = (map<String, Object>) mapJsonData.get('findDocumentsResponse');
                            
                            if(mapfindDoc != null){
                                Map<String, Object>  mapfindDocResType = (map<String, Object>) mapfindDoc.get('findDocumentsResponseType');
                                
                                if(mapfindDocResType != null){
                                    Map<String, Object>  mapfindList = (map<String, Object>) mapfindDocResType.get('documentList');
                                    
                                    if(mapfindList != null){
                                        List<Object> doclist = (List<Object>) mapfindList.get('document');
                                        
                                        for(Object docObj : doclist){
                                            ACET_ECAALetterResult.ResponseData resData = new ACET_ECAALetterResult.ResponseData();
                                            Map<String, Object> mapDoc = (Map<String, Object>) docObj;
                                            if(mapDoc != null){
                                                resData.docId = String.valueOf(mapDoc.get('documentId')); 
                                                Map<String, Object> mapDocKeys = (Map<String, Object>) mapDoc.get('documentKeys');
                                                
                                                if(mapDocKeys != null){
                                                    
                                                    List<Object> documentKeyList = (List<Object>) mapDocKeys.get('documentKey');
                                                    
                                                    for(Object docKeyObj : documentKeyList){
                                                        
                                                        Map<String, Object> mapProcessDockey = (Map<String, Object>) docKeyObj;
                                                        if(mapProcessDockey != null){
                                                            
                                                            if(mapProcessDockey.get('name') == 'u_ingestion_dt'){                                                                
                                                                String ingestionDt = String.valueOf(mapProcessDockey.get('value'));                                                                
                                                                if(!String.isEmpty(ingestionDt)){
                                                                    Date dt = Date.valueOf(ingestionDt);
                                                                    String splitStr = convertToDateFormat(ingestionDt);
                                                                    resData.createdDate = splitStr;
                                                                }                                                                
                                                            }
                                                            if(mapProcessDockey.get('name') == 'u_secur_grp'){
                                                                resData.securityGroup = String.valueOf(mapProcessDockey.get('value'));
                                                            }
                                                            if(mapProcessDockey.get('name') == 'u_cse_id'){
                                                                resData.caseId = String.valueOf(mapProcessDockey.get('value'));
                                                            } 
                                                            if(mapProcessDockey.get('name') == 'u_doc_titl'){
                                                                resData.title = String.valueOf(mapProcessDockey.get('value'));
                                                            }
                                                            if(mapProcessDockey.get('name') == 'r_content_size'){
                                                                resData.fileSize = String.valueOf(mapProcessDockey.get('value'));
                                                            }

                                                        }                                                                                                        
                                                    }
                                                }                                            
                                            }
                                            wrapRespToreturn.add(resData);
                                        }
                                    }
                                }
                                
                            }
                        }                                                
                    }
                    returnResponse.ecaaletterResLst = wrapRespToreturn;
                    ecaaLetterResult.Response = returnResponse; 
                }else{
                    /*
                    // US2445831 Assigning custom error message based on response status code _by kavinda
                    if (SAEConstants.viewAuthStatusCodeErrorMSG.containsKey(response.getStatusCode())) {
                        ecaaLetterResult.Message = SAEConstants.viewAuthStatusCodeErrorMSG.get(response.getStatusCode());
                        ecaaLetterResult.statusCode = response.getStatusCode();
                        ecaaLetterResult.Success = false;
                    }*/
                    // US3292019: Services Failed Messages (Authorization Details) - Krish
                    ecaaLetterResult.Message = READ_AUTH_COMMON_ERROR_MSG;
                    ecaaLetterResult.statusCode = statusCode;
                        ecaaLetterResult.Success = false;
                    ecaaLetterResult.Response = new ACET_ECAALetterResult();
                }                  
            }
        }catch(Exception e){
            System.debug('@@@ ACET_ECAALetterWS.findECAALetter() :: Exception: '+e.getStackTraceString());
            ecaaLetterResult.Success = false;
            ecaaLetterResult.Message =  READ_AUTH_COMMON_ERROR_MSG; // US3292019: Services Failed Messages (Authorization Details) - Krish
            ecaaLetterResult.recordCount = '0';
            ecaaLetterResult.statusCode=999;       
            
        }
        return ecaaLetterResult;
    }    

    
    public string convertToDateFormat(string str2DatetimeFormat){
        list<string> lstSplit = str2DatetimeFormat.split('-');
        list<string> lstSplitFormat = lstSplit[2].split('T'); 
        list<string> lsttimeformat = lstSplitFormat[1].split(':');
        
        string finalDateFormat = lstSplit[1]+'/'+lstSplitFormat[0]+'/'+lstSplit[0];
        return finalDateFormat;
    } 

    // Get Error messages from metadata records
    public static String getErrorMessage(String errorCode)
    {
        String errorMessage = '';
        AcetErrorMessage__mdt[] ErrorCodes = [SELECT DeveloperName, Label, Error_Message__c, Message_Type__c
                                              FROM AcetErrorMessage__mdt
                                              WHERE DeveloperName = :errorCode];
        
        if(ErrorCodes.size() > 0)
        {
            errorMessage = ErrorCodes[0].Error_Message__c;
        }
        
        return errorMessage;
    }
}