public class ACETLGT_IdCardRequestController extends ACETErrorHandler{

    public class familyMembsResultWrapper{
        @AuraEnabled public ACETLGT_MemberDetail resultWrapper {get;set;}
        @AuraEnabled public String ErrorMessage {get;set;}
    }
    public class findDocWrapper{
        @AuraEnabled public String documentId {get;set;}
        @AuraEnabled public String ErrorMessage {get;set;}
    }
    public class SubmitOrderResponse {
        @AuraEnabled public Map<String, String> tokenMap{get;set;}
        @AuraEnabled public String trackingId{get;set;}
        @AuraEnabled public String ErrorMessage{get;set;}
    }
    
    public class FormHistoryResultMapWrapper{
        @AuraEnabled public Map<String, List<ACETLGT_FormsHistoryResult>> formHistoryResultMap{get;set;}
        @AuraEnabled public Map<String, Object> responseValueMap {get;set;}
        @AuraEnabled public String ErrorMessage{get;set;}
    }
    @AuraEnabled 
    public static familyMembsResultWrapper getFamilyMembershipResults(String srk, string groupNumber, String effectiveDate, string memberId){
    
    try{
        ACETLGT_MemberDetail resultwrap = new ACETLGT_MemberDetail(); 
        ACETLGT_MemberDetail memberDetail = new ACETLGT_MemberDetail();
        ACETLGT_GetFamilyMemberWebService getFamMemService = new ACETLGT_GetFamilyMemberWebService();
        ACETWSCalloutResult CalloutResult = null;
        
             memberDetail.SurrogateKey = srk;
             memberDetail.PreferredCoverage = new ACETLGT_MemberDetail.CoverageLine();
             memberDetail.PreferredCoverage.groupNumber = groupNumber;
             memberDetail.PreferredCoverage.effectiveDate = effectiveDate;
             memberDetail.PreferredCoverage.SurrogateKey = srk;         
      
        
        CalloutResult = getFamMemService.getFamilyMembers(memberId, memberdetail);
        system.debug('~~~After callout'+CalloutResult);
        
        if (CalloutResult != null && CalloutResult.Success == true){   
            resultwrap= (ACETLGT_MemberDetail)CalloutResult.Response;

            familyMembsResultWrapper detWrap = new familyMembsResultWrapper();
            detWrap.resultWrapper = resultwrap;
        return detWrap;
        }else{
            familyMembsResultWrapper detWrap = new familyMembsResultWrapper();
            detWrap.resultWrapper = new ACETLGT_MemberDetail();
            if(CalloutResult.statusCode == 400)
            	detWrap.ErrorMessage = setLightningErrorMsg('GN400B'); 
            else
            	detWrap.ErrorMessage = setLightningErrorMsg('GN'+CalloutResult.statusCode );
            system.debug('Val res::: '+detWrap );
    
            return detWrap;
        } 
               
        
    }catch(exception e){
        familyMembsResultWrapper detWrap = new familyMembsResultWrapper();
        detWrap.resultWrapper = new ACETLGT_MemberDetail();
        detWrap.ErrorMessage = setLightningErrorMsg('MGD997');
        system.debug('final res::: '+detWrap );
        
        return detWrap;
    } 
    }

    @AuraEnabled 
    public static FormHistoryResultMapWrapper getFamilyMemberHistory(string ordHistStartdate, string ordHistEnddate, string selectedFamilyId){
        FormHistoryResultMapWrapper formHistoryResultMap = new FormHistoryResultMapWrapper();
    try{    
        ordHistEnddate = ACETWebserviceHelper.formatDateFromDashToSlash(ordHistEnddate);
        ordHistStartdate = ACETWebserviceHelper.formatDateFromDashToSlash(ordHistStartdate);
        ACETLGT_FormsHistoryWebService formsHistoryWebService = new ACETLGT_FormsHistoryWebService();
        system.debug('-----ordHistStartdate.tst_Date_Field__c-----'+string.valueof(ordHistStartdate));
        system.debug('-----ordHistEnddate-----'+string.valueof(ordHistEnddate));
                
		formsHistoryWebService.init('ACET',Integer.ValueOf(label.ACETIDCardDocumentType),cleanDate(String.valueOf(AcetUtility.format(Date.parse(ordHistStartdate)))),cleanDate(String.valueOf(AcetUtility.format(Date.parse(ordHistEnddate)))),String.valueOf(selectedFamilyId),'MemberID');
        //formsHistoryWebService.init('ACET',Integer.ValueOf(label.ACETIDCardDocumentType),cleanDate(String.valueOf(Date.parse(ordHistStartdate).format())),cleanDate(String.valueOf(Date.parse(ordHistEnddate).format())),'34040135100','MemberID');
            
            ACETWSCalloutResult searchResult =  formsHistoryWebService.queryPaginatedData(1,1,1);
            
            if(searchResult != null && searchResult.Message == '') {
                
                Map<String, Object> responseValueMap = new Map<String, Object>();
                responseValueMap.put(selectedFamilyId, searchResult.Response);
                
                formHistoryResultMap.responseValueMap = responseValueMap;
            } else {
                Map<String, Object> responseValueMap = new Map<String, Object>();
                formHistoryResultMap.responseValueMap = responseValueMap;
                if(searchResult.statusCode == 400) {
                    formHistoryResultMap.ErrorMessage = setLightningErrorMsg('GN400B');
                } else {
                    formHistoryResultMap.ErrorMessage = setLightningErrorMsg('GN' + searchResult.statusCode);
                }
            }
            return formHistoryResultMap;
        }catch(exception e){
            formHistoryResultMap = new FormHistoryResultMapWrapper();
            Map<String, Object> responseValueMap = new Map<String, Object>();
            formHistoryResultMap.ErrorMessage = setLightningErrorMsg('MGD997');                        
            formHistoryResultMap.responseValueMap = responseValueMap;
            
            return formHistoryResultMap;
        }    
    }

    public static String cleanDate(String theDate){
        String [] s = theDate.split('/');
        String newDate= '';
        String newMonth= '';
        String newDay= '';
        if(s[0].length() == 1){
            newMonth = '0'+s[0];
        }else{
            newMonth = s[0];
        }
        if(s[1].length() == 1){
            newDay = '0'+s[1];
        }else{
            newDay = s[1];
        }
        newDate = newMonth+'/'+newDay+'/'+s[2];
        return newDate;
    }
    
    @AuraEnabled
    public static SubmitOrderResponse submitOrder(String memberEid, String selectedGroupId, String benefitBundleId) {
        SubmitOrderResponse response = new SubmitOrderResponse();
        try{
        ACETLGT_SubmitFulfillmentRequest submitRequestWS = new ACETLGT_SubmitFulfillmentRequest();
        ACETWSCalloutResult WSResponse = submitRequestWS.submitFulfillmentRequest(memberEid,selectedGroupId, benefitBundleId);
        Map<String, String> memberTokenMap = new Map<String, String>();
        String currentTrackingId;
        
        if (WSResponse != null && WSResponse.Success == true){      
            system.debug('Inside success response');
            memberTokenMap.put(memberEid, String.valueOf(WSResponse.Response));
            currentTrackingId = String.valueOf(WSResponse.Response);
            response.errorMessage = '';
            response.tokenMap = memberTokenMap;
            response.trackingId = currentTrackingId;
            
        } else {
           
           if(WSResponse.statusCode==429){
             	response.ErrorMessage = setLightningErrorMsg('MGD'+WSResponse.statusCode );
           }else if(WSResponse.statusCode==400||WSResponse.statusCode==422){
           	response.ErrorMessage = setLightningErrorMsg('GN'+'400B');
           }else{
             	response.ErrorMessage = setLightningErrorMsg('GN500');
           }
        }
            
        }catch(exception e){
            response.ErrorMessage = setLightningErrorMsg('MGD997');
        }
        
        return response;
    }
    
     @AuraEnabled
    public static findDocWrapper findDocument(String params) { return findDocument(params,null); }
    
    @AuraEnabled
    public static findDocWrapper findDocument(String params,String reqDate) {
        String documentType = 'IDCARDS';
        System.debug('DynamicParams is '+params);
        List<String> keyparams = (List<String>)JSON.deserialize(params, List<String>.class);
        System.debug('keyparams is '+keyparams[0]);
        ACETLGT_FindDocWebservice.documentKey key;
        findDocWrapper detWrap = new findDocWrapper();
        List<ACETLGT_FindDocWebservice.documentKey> findDocKeys = new List<ACETLGT_FindDocWebservice.documentKey>();
        String documentId;
        for(String par: keyparams){
            String [] str = par.split(',');
            key = new ACETLGT_FindDocWebservice.documentKey();
            key.name = str[0];
            key.value = str[1];
            System.debug('!!!keys '+key);
            findDocKeys.add(key);            
        }
        ACETLGT_FindDocWebservice findDocService = new ACETLGT_FindDocWebservice();
        findDocService.init(documentType,findDocKeys);                           
        ACETWSCalloutResult oACETWSCalloutResult = new ACETWSCalloutResult();
        oACETWSCalloutResult = findDocService.queryPaginatedData(1, 1, 1);
        System.debug('resp : ' + oACETWSCalloutResult);

        if (oACETWSCalloutResult != null && oACETWSCalloutResult.Success == true){         
            List<Map<String,String>> documents = new List<Map<String,String>>();
            documents = (List<Map<String,String>>)oACETWSCalloutResult.Response;
            System.debug('!!!@@@ document'+documents[0]);
            String requiredDocumentId = '';
            for(Map<String,String> document : documents){
                if(requiredDocumentId==''){
                    for(String checkData:document.keySet()) {
                        if(checkData.endsWith('RUNDATE')) {
                            String dateReq = document.get(checkData);
                            dateReq = Integer.valueOf(dateReq.split('-')[1])+'/'+Integer.valueOf(dateReq.split('-')[2])+'/'+Integer.valueOf(dateReq.split('-')[0]);
                            if(reqDate==dateReq){
                            String documentNumber = checkData.replace('RUNDATE','');
                            requiredDocumentId = document.get(documentNumber+'DocumentId');
                            break;
                            }
                        }
                        
                    }
                }
            }
        	detWrap.documentId = requiredDocumentId;
        }else{
            if(oACETWSCalloutResult.statusCode == 403) {
            	detWrap.ErrorMessage = setLightningErrorMsg('GN'+'500');
            } else if(oACETWSCalloutResult.statusCode == 400) {
             	detWrap.ErrorMessage = setLightningErrorMsg('GN'+'400B');
            } else {
              	detWrap.ErrorMessage = setLightningErrorMsg('GN'+oACETWSCalloutResult.statusCode);
            }

        }
        return detWrap;
    }
}