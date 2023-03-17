public class ACET_ClaimRelatedDocumentWS {
    static final String READ_AUTH_COMMON_ERROR_MSG = 'Web Service or External System is temporarily unavailable.';
	 public ACETWSCalloutResult getClaimRelatedDocumentWS(string indexName,string docInputs){
        String responseStr = '';
        ACETWSCalloutResult calloutResult = new ACETWSCalloutResult();
        List<ACET_ClaimRelatedDocument_JSON2Apex.recordsList> ResponseArray = new List<ACET_ClaimRelatedDocument_JSON2Apex.recordsList>();
        try{
            ACET_WebserviceCalloutFramework wsCallOut = new ACET_WebserviceCalloutFramework();
            wsCallOut.serviceName = 'LinkRelatedDocuments';
            wsCallOut.requestBody = getAttachmentsRequestBody(indexName,docInputs);
            HttpResponse response = wscallout.getResponse();
            responseStr = response.getBody();
            system.debug('ResponseBody** ' + responseStr);
            if(response.getStatusCode() == 200){
                if(responseStr != null && String.isNotBlank(responseStr)){
                    calloutResult.statusCode= response.getStatusCode();
                    ACET_ClaimRelatedDocument_JSON2Apex responseObj = ACET_ClaimRelatedDocument_JSON2Apex.parse(responseStr);
                    System.debug('### ACET_ClaimRelatedDocumentWS - Deserialized responseObj:'+responseObj);
                    if(responseObj != null) {
                        System.debug('###ACET_ClaimRelatedDocumentWS@@@@@');
                        calloutResult.Response = responseObj;
                        calloutResult.Success = true;
                    }else {
                        calloutResult.Success = false;
                        System.debug('### ERROR: ACET_ClaimRelatedDocumentWS - EMPTY CLAIMS');
                    }

                }

            }else{
                if (SAEConstants.viewAuthStatusCodeErrorMSG.containsKey(response.getStatusCode())) {
                    calloutResult.MessageSeverity = ApexPages.Severity.INFO;
                    calloutResult.Success = false;
                    calloutResult.statusCode = response.getStatusCode();
                    calloutResult.Message = SAEConstants.viewAuthStatusCodeErrorMSG.get(response.getStatusCode());
                }else {
                    calloutResult.Message = READ_AUTH_COMMON_ERROR_MSG;
                    calloutResult.statusCode = response.getStatusCode();
                    calloutResult.Success = false;
                }
            }
        }Catch(Exception e){
            system.debug(e.getStackTraceString());
            calloutResult.MessageSeverity = ApexPages.Severity.ERROR;
            calloutResult.Success = false;
            calloutResult.Message = READ_AUTH_COMMON_ERROR_MSG;
            calloutResult.statusCode=999;
        }
        return calloutResult;
    }

    //create request body
    public String getAttachmentsRequestBody(string indexName,string docInputs)
    {
        String requestBody='';
        ACET_ClaimrelatedRequest claimdocRequest = new ACET_ClaimrelatedRequest();
        claimdocRequest.indexName=indexName;
        list<ACET_ClaimrelatedRequest.FilterClauses> filtercluselist = new list<ACET_ClaimrelatedRequest.FilterClauses>();
        list<ACET_Claims_Docs_Mapping__mdt> claimsDocList = [Select ACET_Attribute__c,Doc360_Attribute__c From ACET_Claims_Docs_Mapping__mdt
                                                             Where Doc_class_Name__c=:indexName];
        Map<string,string> filterMapping = new Map<string,string>();
        for(ACET_Claims_Docs_Mapping__mdt filters : claimsDocList){
            filterMapping.put(filters.ACET_Attribute__c,filters.Doc360_Attribute__c);
        }
        //string docinput = json.serialize(docInputs);
        map<string,object> claimrelateddocinput = (map<string,object>)json.deserializeUntyped(docInputs);
        for(string att : claimrelateddocinput.keyset()){
            if(filterMapping.containsKey(att)){
                ACET_ClaimrelatedRequest.filterClauses filterClauses = new ACET_ClaimrelatedRequest.filterClauses();
                filterClauses.type_Z = 'equal';
                filterClauses.name = filterMapping.get(att);
                filterClauses.value = (string)claimrelateddocinput.get(att);
                filtercluselist.add(filterClauses);
            }
        }
        ACET_ClaimrelatedRequest.criteria criteria = new ACET_ClaimrelatedRequest.criteria();
        criteria.filterClauses = filtercluselist;
        claimdocRequest.criteria=criteria;
        object objResponse = claimdocRequest;
        requestBody = JSON.serialize(objResponse);
        requestBody=requestBody.replace('type_Z','type');
        system.debug('reqBody:: '+requestBody);
        ACET_ClaimrelatedRequest reqbody = ACET_ClaimrelatedRequest.parse(requestBody);
        system.debug('reqBody:: '+reqbody.criteria);
        return requestBody;
    }
}