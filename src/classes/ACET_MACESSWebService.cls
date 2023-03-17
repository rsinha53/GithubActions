public class ACET_MACESSWebService {
    //US3182780
    @AuraEnabled
    public static ACET_SAECalloutResult createMACESSCase(string strMACESSCreateReq, string strCaseId,string strFacetsId){
        ACET_SAECalloutResult calloutResult = new ACET_SAECalloutResult();
        try{
            HttpResponse response = new HttpResponse();
            response = (HttpResponse) createMACESSCase(strMACESSCreateReq);
            Integer respCode = response.getStatusCode();
            String respBody = response.getBody();
            if(respCode == 201 && string.isNotBlank(respBody)){
                Map<String,Object> mapResponse = (Map<String,Object>) JSON.deserializeUntyped(respBody);
                string PIQ = mapResponse.get('ticketNumber') != NULL ? (string) mapResponse.get('ticketNumber') : '';
                calloutResult.isSuccess = true;
                calloutResult.Message = 'Success';
                calloutResult.statusCode = respCode;
                calloutResult.Response = PIQ; 
                if(String.isNotBlank(strCaseId) && string.isNotBlank(PIQ)) {
                    updateSFCase(strCaseId,strFacetsId,PIQ);                    
                }
            }
            else{
                system.debug('@Error@' + respBody);
                calloutResult.MessageSeverity = ApexPages.Severity.INFO;
                calloutResult.isSuccess = false; 
                calloutResult.statusCode = respCode;
                calloutResult.Message = respBody;
            }
            
        }
        Catch(Exception e){
            system.debug('@e@'+e.getStackTraceString());
            system.debug('@em'+e.getMessage());
            calloutResult.MessageSeverity = ApexPages.Severity.ERROR;
            calloutResult.isSuccess = false;
            calloutResult.Message = 'Web Service or External System is temporarily unavailable.';
            calloutResult.statusCode=999;
        }
        system.debug('@calloutResult@'+calloutResult);
        return calloutResult;
    }
    //US3182780
    public static void updateSFCase(string sfCaseId,string strFacetsId, string strMacessId){
        List<Case> caseRecord = [Select Id,MACESSPIQ__c,Facets_Issue_ID__c from Case where Id =: sfCaseId];
        if(caseRecord != null && !caseRecord.isEmpty()){
            Case updateCase = new Case(Id = caseRecord[0].Id);
            if(string.isNotBlank(strMacessId)){
                if(String.isNotBlank(caseRecord[0].MACESSPIQ__c))  updateCase.MACESSPIQ__c = caseRecord[0].MACESSPIQ__c+','+strMacessId;
                else  updateCase.MACESSPIQ__c =  strMacessId; 
            }
            
            if(string.isNotBlank(strFacetsId)){
                if(String.isBlank(caseRecord[0].Facets_Issue_ID__c)){
                    updateCase.Facets_Issue_ID__c = strFacetsId;   
                }
                else updateCase.Facets_Issue_ID__c = caseRecord[0].Facets_Issue_ID__c+','+strFacetsId;
            }
            upsert updateCase;
        }
        
    }
    //US3182780
    @AuraEnabled
    public static Object createMACESSCase(String requestBody) {
        HttpResponse response = new HttpResponse();
        ACET_WebserviceCalloutFramework wsCallOutFW = new ACET_WebserviceCalloutFramework();
        wsCallOutFW.serviceName = 'MACESSCaseCreation';
        wsCallOutFW.requestBody = requestBody;
        response = wsCallOutFW.getResponse();
        system.debug('@resCode@'+response.getStatusCode());
        system.debug('@resBody@'+response.getBody());
        return response;
    }
    

    
    @AuraEnabled
    public static Object updateMACESSCase(string strMACESSCreateReq, string strCaseId){
        ACET_SAECalloutResult calloutResult = new ACET_SAECalloutResult();
        try{
            HttpResponse response = new HttpResponse();
            response = (HttpResponse) updateMACESSCase(strMACESSCreateReq);
            system.debug('response: '+response);
            Integer respCode = response.getStatusCode();
            String respBody = response.getBody();
            if(respCode == 201 && string.isNotBlank(respBody)){
                Map<String,Object> mapResponse = (Map<String,Object>) JSON.deserializeUntyped(respBody);
                string PIQ = mapResponse.get('ticketNumber') != NULL ? (string) mapResponse.get('ticketNumber') : '';
                string adjustmentNum = mapResponse.get('adjustmentNum') != NULL ? (string) mapResponse.get('adjustmentNum') : '';
                calloutResult.isSuccess = true;
                calloutResult.Message = 'Success';
                calloutResult.statusCode = respCode;
                calloutResult.Response = PIQ; 
                if(String.isNotBlank(strCaseId) && string.isNotBlank(PIQ)) {
                    List<Case> caseRecord = [Select Id,MACESSPIQ__c from Case where Id =: strCaseId];
                    if(caseRecord != null && !caseRecord.isEmpty()){
                        Case updateCase = new Case(Id = caseRecord[0].Id);
                        //if(String.isNotBlank(caseRecord[0].MACESSPIQ__c))
                            //updateCase.MACESSPIQ__c = caseRecord[0].MACESSPIQ__c+','+PIQ+';;'+adjustmentNum;
                        //else
                            //updateCase.MACESSPIQ__c =  PIQ+';;'+adjustmentNum; 
                        
                        upsert updateCase;
                        
                    }
                    
                }
            }
            else{
                system.debug('@Error@' + respBody);
                calloutResult.MessageSeverity = ApexPages.Severity.INFO;
                calloutResult.isSuccess = false; 
                calloutResult.statusCode = respCode;
                calloutResult.Message = respBody;
            }
            
        }
        Catch(Exception e){
            system.debug('@e@'+e.getStackTraceString());
            system.debug('@em'+e.getMessage());
            calloutResult.MessageSeverity = ApexPages.Severity.ERROR;
            calloutResult.isSuccess = false;
            calloutResult.Message = 'Web Service or External System is temporarily unavailable.';
            calloutResult.statusCode=999;
        }
        system.debug('@calloutResult@'+calloutResult);
        string strReturnType = JSON.serialize(calloutResult); 
        return strReturnType;
    }
    
    @AuraEnabled
    public static Object updateMACESSCase(String requestBody) {
        HttpResponse response = new HttpResponse();
        ACET_WebserviceCalloutFramework wsCallOutFW = new ACET_WebserviceCalloutFramework();
        wsCallOutFW.serviceName = 'MACESSCaseUpdate';
        wsCallOutFW.requestBody = requestBody;
        response = wsCallOutFW.getResponse();
        system.debug('@resCode@'+response.getStatusCode());
        system.debug('@resBody@'+response.getBody());
        return response;
    }
    
    @AuraEnabled
    public static ACET_SAECalloutResult  searchMACESSCase(Map<String,String> requestParamMap, string strCaseId){
        ACET_SAECalloutResult calloutResult = new ACET_SAECalloutResult();
        try{
            HttpResponse response = new HttpResponse();
            response = (HttpResponse) searchMACESSCase(requestParamMap);
            String piqNum = '';
            if(requestParamMap != null){
                if(requestParamMap.containsKey('searchValue')){
                    piqNum = requestParamMap.get('searchValue');
                }
            }
            system.debug('response: '+response);
            Integer respCode = response.getStatusCode();
            String respBody = response.getBody();
            if(respCode == 200 && string.isNotBlank(respBody)){
                String maccesNum = '';
                getApiResponse ticketBody = (getApiResponse) JSON.deserialize(respBody,getApiResponse.class);
                if(ticketBody != null){
                    maccesNum = ticketBody.ticketDetails.adjustmentNum;
                }
                calloutResult.isSuccess = true;
                calloutResult.Message = 'Success';
                calloutResult.statusCode = respCode;
                calloutResult.Response = maccesNum;
                if(String.isNotBlank(strCaseId) && string.isNotBlank(maccesNum)) {
                    List<Case> caseRecord = [Select Id,MACESSPIQ__c from Case where Id =: strCaseId];
                    if(caseRecord != null && !caseRecord.isEmpty()){
                        Case updateCase = new Case(Id = caseRecord[0].Id);
                        if(String.isNotBlank(caseRecord[0].MACESSPIQ__c)){
                            String maccesPiq = caseRecord[0].MACESSPIQ__c;
                            String replaceMaccesPiq = maccesPiq.replace(piqNum,piqNum+'--'+maccesNum);
                            updateCase.MACESSPIQ__c = replaceMaccesPiq;
                        }else
                            updateCase.MACESSPIQ__c =  piqNum+'--'+maccesNum;
                        
                        upsert updateCase;
                        
                    }
                    
                }
            }
            else{
                system.debug('@Error@' + respBody);
                calloutResult.MessageSeverity = ApexPages.Severity.INFO;
                calloutResult.isSuccess = false; 
                calloutResult.statusCode = respCode;
                calloutResult.Message = respBody;
            }
            
        }
        Catch(Exception e){
            system.debug('@e@'+e.getStackTraceString());
            system.debug('@em'+e.getMessage());
            calloutResult.MessageSeverity = ApexPages.Severity.ERROR;
            calloutResult.isSuccess = false;
            calloutResult.Message = 'Web Service or External System is temporarily unavailable.';
            calloutResult.statusCode=999;
        }
        //system.debug('@calloutResult@'+calloutResult);
        //string strReturnType = JSON.serialize(calloutResult);
        return calloutResult;
    }
    
    @AuraEnabled
    public static Object searchMACESSCase(Map<String,String> requestParamMap) {

        
        HttpResponse response = new HttpResponse();
        ACET_WebserviceCalloutFramework wsCallOutFW = new ACET_WebserviceCalloutFramework();
        wsCallOutFW.serviceName = 'MACESSCaseSearch';
        wsCallOutFW.requestParamsMap = requestParamMap;
        response = wsCallOutFW.getResponse();
        system.debug('@resCode@'+response.getStatusCode());
        system.debug('@resBody@'+response.getBody());
        return response;
    }

   //US3182829 - Sravan
    @AuraEnabled
    public static string frameRequest(String strCaseWrapper,String facetTrackingId,String caseId){
        String jsonReq = '';
        String requestOption = '';
        if(strCaseWrapper != null && String.isNotBlank(strCaseWrapper)){
            List<User> lstUsers = new List<User>();
            lstUsers = [Select id,FederationIdentifier from User Where Id=:Userinfo.getUserId()];
            SAETTSCaseWrapper caseWrapper = (SAETTSCaseWrapper) System.JSON.deserialize(strCaseWrapper,SAETTSCaseWrapper.class);
            List<String> codesList = new List<String>();
            codesList = getCodes(caseWrapper.issueId);
            if(codesList != null && !codesList.isEmpty()){
                requestOption = codesList[0] != null && String.isNotBlank(codesList[0]) ? codesList[0].trim() : '';
            }
            //Mapping the request
            ACET_MACESSCreateReq req = new ACET_MACESSCreateReq();
            if(caseWrapper.SubjectId != null && String.isNotBlank(caseWrapper.SubjectId)){
                req.subscriberId = caseWrapper.SubjectId;
            }
            else{
                req.subscriberId = '000000000';   
            }
            if(caseWrapper.CSPProviderId != null && String.isNotBlank(caseWrapper.CSPProviderId)){
                req.providerId = caseWrapper.CSPProviderId;
            }
            else{
                req.providerId = '000000000000';    
            }
            if (caseWrapper.OriginatorContactName != null && String.isNotBlank(caseWrapper.OriginatorContactName)) {
                List < String > originatorFullName = new List < String > ();
                originatorFullName = caseWrapper.OriginatorContactName.split(' ');
                if (originatorFullName.Size() > 1) {
                    req.contactFirstName = originatorFullName[0];
                    req.contactLastName = originatorFullName[1];
                } else if (originatorFullName.Size() == 1) {
                    req.contactLastName = originatorFullName[0];
                }
            }
            req.contactMiddleName = caseWrapper.middleInitial;
            if (String.isNotBlank(caseWrapper.contactNumber)) {
                String phoneFormat = caseWrapper.contactNumber;
                if (String.isNotBlank(caseWrapper.contactExt)) {
                    req.phone  = phoneFormat + '	Ext ' + caseWrapper.contactExt;
                } else {
                    req.phone  = phoneFormat;
                }
            }
            req.email = 'Noreply@uhc.com';
            if(caseWrapper.facetsReasonCategory == 'Enrollment Request'){
                req.subject = 'Enrollment Request';
                req.contactorType = 'P';
                req.enrollmentRequestCheckbox = 'TRUE';
                req.enrollmentRequestOption = requestOption;
                if(caseWrapper.SubjectGroupId != null && String.isNotBlank(caseWrapper.SubjectGroupId)){
                    req.relatedState = caseWrapper.SubjectGroupId != '--' ? caseWrapper.SubjectGroupId : null;
                }
            }
            else if(caseWrapper.facetsReasonCategory == 'COB Request'){
                req.subject = 'COB Request';
                req.contactorType = 'M';
                req.cobRequestCheckbox = 'TRUE';
                req.cobRequestOption = requestOption;
                if(caseWrapper.SubjectGroupId != null && String.isNotBlank(caseWrapper.SubjectGroupId)){
                    req.relatedState = caseWrapper.SubjectGroupId;
                }
            }
            else if(caseWrapper.facetsReasonCategory == 'Network Management'){
                req.subject = 'Network Management Request';
                req.contactorType = 'M';
                req.networkManagementRequestCheckbox = 'TRUE';
                req.networkManagementRequestOption = requestOption;
            }
            
            if(caseWrapper.requestResource != null && String.isNotBlank(caseWrapper.requestResource)){
                if(caseWrapper.requestResource == 'C-Call Center'){
                    req.requestSources = 'C';
                }
                else if(caseWrapper.requestResource == '3 - Provider 330 Request'){
                    req.requestSources = '3';
                }
            }
           /* else{
                 req.requestSources = 'C';
            }*/
            if(lstUsers != null && !lstUsers.isEmpty()){
                req.maccessUserAccountInformation = lstUsers[0].FederationIdentifier;
            }
            if(facetTrackingId != null && String.isNotBlank(facetTrackingId)){
                req.facetsTracking = facetTrackingId;
            }
            if(caseId != null && String.isNotBlank(caseId)){
                req.spireTrackingNum = caseId;
            }
            if(string.isNotBlank(caseWrapper.additionalRequestComments)){
                 req.comments = caseWrapper.additionalRequestComments.replace('\n',' ');
            }
           
           // req.comments = 'test';
            jsonReq = JSON.serialize(req);
            system.debug('Maccess Request'+ jsonReq);
        }
        return jsonReq;
    }

    @testVisible
    private static List<String> getCodes(String issueId){
        List<String> codesList = new List<String>();
        if(issueId != null && String.isNotBlank(issueId)){
            codesList = issueId.split('-');
        }
        return codesList;
    }

    public class getApiResponse{
        public  ticketDetail ticketDetails;
     }
     public class ticketDetail{
        public String adjustmentNum;
    }
}