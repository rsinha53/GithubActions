public class ACET_ICUELetterWS{
    
    // US3292019: Services Failed Messages (Authorization Details) - Krish
    static final String READ_AUTH_COMMON_ERROR_MSG = 'Unexpected Error Occurred with retrieving ICUE Letter(s) . Please try again. If problem persists please contact the help desk.';
    public static String businessFlow;
    public static ICUEDocRequest icueRequest;
    public static String indexName;
    public ACET_ICUELetterWS() {
           businessFlow = 'SAE';
           
    }
    public ACET_ICUELetterWS(String businessFlowType,ICUEDocRequest icueRequestType) {
        businessFlow = businessFlowType;
        icueRequest = icueRequestType;
    }
    public ACET_ICUELetterWS(String businessFlowType,String docIndexName) {
        businessFlow = businessFlowType;
        indexName = docIndexName;
    }
    //create request body
    public String getRequestBody(String srnNumber){
        
        ICUEDocRequest icueRequest = new ICUEDocRequest();

        icueRequest.indexName ='u_icue_nextgen';
        List<ICUEDocRequest.FilterClauses> FilterClausesLst = new List<ICUEDocRequest.FilterClauses>();

        ICUEDocRequest.FilterClauses FilterClauses = new ICUEDocRequest.FilterClauses();
        FilterClauses.type_Z = 'equal';
        FilterClauses.name = 'u_ntfy_nbr';
        FilterClauses.value = srnNumber;

        FilterClausesLst.add(FilterClauses);

        ICUEDocRequest.Criteria Criteria = new ICUEDocRequest.Criteria();
        Criteria.filterClauses = FilterClausesLst;

        icueRequest.Criteria = Criteria;

        object objResponse = icueRequest;
        String reqStr = JSON.serialize(objResponse);

        system.debug('reqBody:: '+reqStr);
        reqStr = reqStr.replace('type_Z', 'type');
        //RequestBody = reqStr;
        return reqStr;
    }
    
    public String getRequestBodyByParam(ICUEDocRequest icueRequestParam){
        object objResponse = icueRequestParam;
        String reqStr = JSON.serialize(objResponse);
        reqStr = reqStr.replace('type_Z', 'type');
        return reqStr;
    }
    
    public ACETWSCalloutResult findICUELetter(String srnNumber){
        
        ACETWSCalloutResult icueLetterResult = new ACETWSCalloutResult();
        ACET_ICUELetterResult returnResponse = new ACET_ICUELetterResult();
        String requestBody='';

        
        Acet_ICUEFindDocResponseWrapper resWrappeICUE = new Acet_ICUEFindDocResponseWrapper();
        String strResponse = null;
        List<ACET_ICUELetterResult.ResponseData> wrapRespToreturn = new List<ACET_ICUELetterResult.ResponseData>();
        try{
            /*
            isDocEndpoint = false;
            getEndpoint();
            getRequestBody(srnNumber);                          
            User userRec = [SELECT Id, FederationIdentifier FROM User where id =: UserInfo.getUserId()];
            HttpResponse response;  
            BaseURL = 'https://api.optum.com:8444';
            Headers.put('scope', 'search');
            Headers.put('username', userRec.FederationIdentifier); //userRec.FederationIdentifier - replace this with hardcoded value(vgoswam) once testing is done.                   
            String strResponse = null;*/
            HttpResponse response = new HttpResponse();
            Map < String, ACETOrgInstanceURLToOrgNameMap__c > OrgInstance2OrgNameMap = ACETOrgInstanceURLToOrgNameMap__c.getAll();
            String orgName = Test.isRunningTest() ? 'dev' : ACETUtility.GetOrgName(OrgInstance2OrgNameMap);
            Map < String, ISL_Webservice_Config__c > islWebserviceData = ISL_Webservice_Config__c.getAll();
            String endPoint = islWebserviceData.get(orgName + '_ICUELetterFind').Value__c;
            if(businessFlow == 'SAE') {
                requestBody = getRequestBody(srnNumber);
            }else if(businessFlow == 'CHS') {
                 requestBody = getRequestBodyByParam(icueRequest);
            }
            HttpRequest httpRequest = new HttpRequest();
            httpRequest.setEndpoint(endPoint);
            httpRequest.setMethod('POST');
            httpRequest.setHeader('Authorization', 'Bearer ' + ISL_Webservice_Config__c.getInstance('SNIAPIAccessToken').Value__c);
            httpRequest.setHeader('Content-Type', 'application/json');
            httpRequest.setHeader('actor', 'ACET');
            httpRequest.setBody(requestBody);
            
            ACET_WebserviceCalloutFramework wsCallOutFW = new ACET_WebserviceCalloutFramework();
            wsCallOutFW.serviceName = 'ICUEFindLetters';
            wsCallOutFW.requestBody = requestBody;
            response = wsCallOutFW.getResponse();
            /*
            if(!SAEUtils.getMockStatus()){
                
                response = h.send(httpRequest);
                
            } else {
                
                Boolean isStaticResponseChecked = false;
                isStaticResponseChecked = SAEUtils.getMockStatus();
                
                if(isStaticResponseChecked && !Test.isRunningTest()){
                    
                    String searchparameter = 'FindDoc_ICUE_'+srnNumber;
                    
                    response=SAEUtils.getResponse(searchparameter);
                    
                }else{
                    response = h.send(httpRequest);
                }

            }*/
            
            system.debug('response: '+response);
            
            Map<String, Object> mapJsonData = new Map<String, Object>();            
            
            if(response!=null){
                Integer statusCode = response.getStatusCode();
                icueLetterResult.statusCode=statusCode;       
                icueLetterResult.Success = true;
                icueLetterResult.Message = '';
                
                if(statusCode == 200){
                    strResponse = response.getBody();
                    if(!String.isEmpty(strResponse)){
                        resWrappeICUE = Acet_ICUEFindDocResponseWrapper.parse(strResponse);
                        for(Acet_ICUEFindDocResponseWrapper.recordsList res : resWrappeICUE.RecordsList){
                            ACET_ICUELetterResult.ResponseData resData = new ACET_ICUELetterResult.ResponseData();

                            //resData.securityGroup = 'INT';
                           	//resData.caseId = 'INT';
                            resData.title = res.objectId;

                            for(Acet_ICUEFindDocResponseWrapper.Attributes att : res.attributes){
                                if(att.labelName == 'u_orig_creation_date'){
                                    String val = att.value;
                                    DateTime docCreatedDate = DateTime.Valueof(val.replace('T', ' '));
                                    String createdDateDoc =String.valueOf(docCreatedDate.month())+'/'+String.valueOf(docCreatedDate.Day())+'/'+String.valueOf(docCreatedDate.Year());

                                    resData.createdDate = createdDateDoc;
                                }

                                if(att.labelName == 'u_gbl_doc_id'){
                                    resData.docId = att.value;
                                }
                                //Added mapping as part of WHAM team changes on work order ICUE letter
                                if(att.labelName == 'u_dlvr_typ'){ 
                                    resData.deliveryMethod = String.isNotBlank(att.value)? att.value :'';
                                }
                                if(att.labelName == 'u_proc_date'){ 
                                       resData.processDate = String.isNotBlank(att.value) ?formatDateTime(att.value) : '';  
                                }
                                if(att.labelName == 'u_elgs_ltr_gen_id'){ 
                                    resData.letterId = String.isNotBlank(att.value)? att.value :'';
                                }
                                if(att.labelName == 'u_sla_dt'){
                                        resData.mailDate =String.isNotBlank(att.value)?ACETWebserviceHelper.formatDateFromDashToSlash(att.value):'';
                                }
                                if(att.labelName == 'u_sbj_dob_dt'){ 
                                    resData.subjectDOB = String.isNotBlank(att.value)? att.value :'';
                                }
                                if(att.labelName == 'u_sbj_fst_nm'){ 
                                    resData.subjectFname = String.isNotBlank(att.value)? att.value :'';
                                }
                                if(att.labelName == 'u_sbj_lst_nm'){ 
                                    resData.subjectLname = String.isNotBlank(att.value)? att.value :'';
                                }
                                if(att.labelName == 'u_pub_sts'){ 
                                    resData.status = String.isNotBlank(att.value)? att.value :'';
                                }
                                if(att.labelName == 'u_rcip_typ'){ 
                                    resData.recipientType = String.isNotBlank(att.value)? att.value :'';
                                }
                                //End Of Wham team changes    
                            }
                            resData.fileSize = res.contentSize;
                            wrapRespToreturn.add(resData);
                        }
                    }
                    returnResponse.icueletterResLst = wrapRespToreturn;
                    icueLetterResult.Response = returnResponse; 
                }else{
                    /*if(statusCode == 400){
                        icueLetterResult.Message = 'Unexpected Error Occurred with retrieving ICUE Letter(s) . Please try again. If problem persists please contact the help desk. Error Code: ' + String.valueOf(statusCode);
                        icueLetterResult.statusCode = statusCode;
                        icueLetterResult.Success = false;
                     } else if(statusCode==404){
                        icueLetterResult.Message = 'Unexpected Error Occurred with retrieving ICUE Letter(s) . Please try again. If problem persists please contact the help desk. Error Code: ' + String.valueOf(statusCode);
                        icueLetterResult.statusCode = statusCode;
                        icueLetterResult.Success = false;
                     } else if(statusCode ==500){
                        icueLetterResult.Message = 'Unexpected Error Occurred with retrieving ICUE Letter(s) . Please try again. If problem persists please contact the help desk. Error Code: ' + String.valueOf(statusCode);
                        icueLetterResult.statusCode = statusCode;
                        icueLetterResult.Success = false;
                     } else {
                        icueLetterResult.Message = 'Unexpected Error Occurred with retrieving ICUE Letter(s) . Please try again. If problem persists please contact the help desk. Error Code: ' + String.valueOf(statusCode);
                        icueLetterResult.statusCode = statusCode;
                        icueLetterResult.Success = false;
                      }*/

                    // US3292019: Services Failed Messages (Authorization Details) - Krish
                    icueLetterResult.Message = READ_AUTH_COMMON_ERROR_MSG;
                    icueLetterResult.statusCode = statusCode;
                    icueLetterResult.Success = false;
                    /*if (SAEConstants.viewAuthStatusCodeErrorMSG.containsKey(statusCode)) {
                        icueLetterResult.Message = SAEConstants.viewAuthStatusCodeErrorMSG.get(statusCode);
                        icueLetterResult.statusCode = statusCode;
                        icueLetterResult.Success = false;
                    } else {
                        icueLetterResult.Message = 'Unexpected error while retrieving ICUE Letter details! Error Code: ' + String.valueOf(statusCode);
                        icueLetterResult.statusCode = statusCode;
                        icueLetterResult.Success = false;
                    }*/
                    icueLetterResult.Response = new ACET_ICUELetterResult();
                }                  
            }
        }catch(Exception e){
            
            System.debug('@@@ ACET_ICUELetterWS.findICUELetter():: EXception: '+e.getStackTraceString());
            icueLetterResult.Success = false;
            icueLetterResult.Message =  READ_AUTH_COMMON_ERROR_MSG; // US3292019: Services Failed Messages (Authorization Details) - Krish
            icueLetterResult.recordCount = '0';
            icueLetterResult.statusCode=999;       
            
        }
        return icueLetterResult;
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
    
    public ICUEDocResponse getICUELetter(String docId){
        ICUEDocResponse res = new ICUEDocResponse();
        HttpResponse response=new HttpResponse();
        response = getICUELetterWS(docId);
        
        res.responseBody = response.getBodyAsBlob();
        res.fileType = response.getHeader('Content-Type');
        res.fileName = response.getHeader('Content-Disposition');
        res.message = response.getStatusCode() == 200 ? 'Success' : 'Failure';
        res.statusCode = response.getStatusCode();
        system.debug('res: '+res);
        return res;
    }
    
    public HttpResponse getICUELetterWS(String docId){
        
        String responseStr;
        HttpResponse response = new HttpResponse();
        try{
            
            Map < String, ACETOrgInstanceURLToOrgNameMap__c > OrgInstance2OrgNameMap = ACETOrgInstanceURLToOrgNameMap__c.getAll();
            String orgName = Test.isRunningTest() ? 'dev' : ACETUtility.GetOrgName(OrgInstance2OrgNameMap);
            Map < String, ISL_Webservice_Config__c > islWebserviceData = ISL_Webservice_Config__c.getAll();
            String endPoint = islWebserviceData.get(orgName + '_ICUELetterGet').Value__c;

            HttpRequest httpRequest = new HttpRequest();

            httpRequest.setMethod('GET');
            httpRequest.setHeader('Authorization', 'Bearer ' + ISL_Webservice_Config__c.getInstance('SNIAPIAccessToken').Value__c);
            httpRequest.setHeader('Content-Type', 'application/json');
            //httpRequest.setHeader('actor', 'ACET');
            String encodedDocId = EncodingUtil.urlEncode(docId,'UTF-8');
            if(businessFlow == 'SAE') {
              endPoint = endPoint+encodedDocId+'?type-name=u_icue_nextgen';
            }else if(businessFlow == 'CHS') {
               endPoint = endPoint+encodedDocId+'?type-name='+indexName; 
            }
            String encodedURL = endPoint;

            httpRequest.setEndpoint(encodedURL);

            ACET_WebserviceCalloutFramework wsCallOutFW = new ACET_WebserviceCalloutFramework();
            wsCallOutFW.serviceName = 'ICUEGetLetters';
            if(businessFlow == 'SAE') {
               wsCallOutFW.endpointExtraPath = '/'+encodedDocId+'?type-name=u_icue_nextgen';
            }else if(businessFlow == 'CHS') {
               wsCallOutFW.endpointExtraPath = '/'+encodedDocId+'?type-name='+indexName; 
            }
            response = wsCallOutFW.getResponse();
            /*
            if(!SAEUtils.getMockStatus()){
                
               response = h.send(httpRequest);
                
            } else {
                List<AcetLinkStaticResponse__mdt> LinkEllStaticResList =[SELECT label,isAvailable__c,isDowntime__c,Error_Code__c,FileName__c FROM AcetLinkStaticResponse__mdt where label='ICUE_letter'];
                if(LinkEllStaticResList!=null && LinkEllStaticResList.size()==1){
                    AcetLinkStaticResponse__mdt LinkEllStaticRes=LinkEllStaticResList.get(0);
                    if(String.isNotBlank(LinkEllStaticRes.FileName__c) && (!LinkEllStaticRes.isDowntime__c))
                        //responseStr = SAEUtils.getStaticResponse(LinkEllStaticRes.FileName__c);
                        
                        system.debug('responseStr doc ==> '+LinkEllStaticRes.FileName__c);
                    StaticResource responseJSONSR = [SELECT Body FROM StaticResource WHERE Name = :LinkEllStaticRes.FileName__c limit 1];        
                    //String responseStrStatic = responseJSONSR !=null ? responseJSONSR.Body.toString():'';  
                    String responseStrStatic = EncodingUtil.Base64Encode(responseJSONSR.body);
                    system.debug('responseStr doc ==> '+responseStrStatic);
                    
                    if(String.isNotBlank(responseStrStatic)){
                        system.debug('responseStr doc ==> '+responseStrStatic);
                        //response.setBody(responseStrStatic);
                        response.setBodyAsBlob(responseJSONSR.body);
                        response.setStatusCode(200);
                        response.setHeader('Content-Type', 'application/pdf');
                        response.setHeader('Content-Disposition', 'Auth Letter');
                    }
                    
                }
            }*/
            
        }catch(Exception e)
        {
            System.debug(Logginglevel.ERROR, '### READ-AUTH-EXCEPTION:' + e.getStackTraceString() + ' - ' + e.getMessage());
            response.setStatusCode(900);
            response.setBody('Sample');
            
            return response;
        }
        return response;
    }
    
    public class ICUEDocResponse{
        @AuraEnabled public blob responseBody {get;set;}
        @AuraEnabled public string fileType {get;set;}
        @AuraEnabled public string fileName {get;set;}
        @AuraEnabled public string message {get;set;}
        @AuraEnabled public integer statusCode {get;set;}
    }
    public String formatDateTime(String processDate) {
        //sample datetime 2019-09-21T12:00:00:000Z -> 09/21/2019 12:00 AM
        String strDateTimeFormat;
        if(processDate.contains('T')) {
            List<String> dateParts = processDate.split('T');
            String dateWithSlash = ACETUtility.formatDateFromDashToSlash(dateParts[0]);
        	List<String> timeParts = dateParts[1].split(':');
        	Integer myHour = Integer.valueOf(timeParts[0]);
           	String strAMPM = myHour>=12?'PM':'AM';
            Integer myClockHour = 12;
            Integer myTime = myHour>12?myHour-myClockHour:myHour;
		    if(myTime == 0) {
    	      myTime = 12;
		     } 
            strDateTimeFormat = dateWithSlash+' '+myTime+':'+timeParts[1]+' '+strAMPM;
        }else {
            strDateTimeFormat = '';
        }
        return strDateTimeFormat; 
}
}