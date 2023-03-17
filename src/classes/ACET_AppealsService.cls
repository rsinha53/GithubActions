public with sharing class ACET_AppealsService 
{
    public static ACET_SAECalloutResult getAppealResults(AppealRequest appealRequest)
    {
        ACET_SAECalloutResult returnRes = new ACET_SAECalloutResult();
        try{
            Map < String, String > requestParamsMap = processRequest(appealRequest);
            ACET_WebserviceCalloutFramework wsCallOutFW = new ACET_WebserviceCalloutFramework();
            wsCallOutFW.serviceName = 'LinkAppealSearch';
            wsCallOutFW.requestParamsMap = requestParamsMap;
            HttpResponse response = wsCallOutFW.getResponse();

            Integer statusCode = response.getStatusCode();
            String responseBody = response.getBody();

            if(statusCode == 200){
                returnRes.isSuccess = true;
                returnRes.statusCode = 200;
                returnRes.response = processResponse(responseBody);
            }else{
                returnRes.isSuccess = false;
                returnRes.statusCode = statusCode;
                returnRes.response = null;
            } 
        }catch(Exception e){
            returnRes.isSuccess = false;
            returnRes.statusCode = 999;
        }
        return returnRes;
    }

    public static ACET_SAECalloutResult getAppealDetails(String taxId, String appealId){
        ACET_SAECalloutResult returnRes = new ACET_SAECalloutResult();
        try{
            Map < String, String > requestParamsMap = new Map < String, String >();
            requestParamsMap.put('tin',taxId);
            requestParamsMap.put('appealId',appealId);
            ACET_WebserviceCalloutFramework wsCallOutFW = new ACET_WebserviceCalloutFramework();
            wsCallOutFW.serviceName = 'LinkAppealDetails';
            wsCallOutFW.requestParamsMap = requestParamsMap;
            HttpResponse response = wsCallOutFW.getResponse();

            Integer statusCode = response.getStatusCode();
            String responseBody = response.getBody();

            if(statusCode == 200){
                returnRes.isSuccess = true;
                returnRes.statusCode = 200;
                returnRes.response = processDetails(responseBody);
            }else{
                returnRes.isSuccess = false;
                returnRes.statusCode = statusCode;
            } 
        }catch(Exception e){
            returnRes.isSuccess = false;
            returnRes.statusCode = 999;
        }
        return returnRes;
    }

    private static Map<String, String> processRequest(AppealRequest appealRequest){
        Map < String, String > requestParamsMap = new Map < String, String > ();
        if(!String.isEmpty(appealRequest.tin)){
            requestParamsMap.put('tin',appealRequest.tin);
        }else if(String.isEmpty(appealRequest.tin)){
            requestParamsMap.put('tin','999999999');
        }
        if(!String.isEmpty(appealRequest.memberId)){
            requestParamsMap.put('memberId',appealRequest.memberId);
        }
        if(!String.isEmpty(appealRequest.patientFn)){
            requestParamsMap.put('patientFn',appealRequest.patientFn);
        }
        if(!String.isEmpty(appealRequest.patientLn)){
            requestParamsMap.put('patientLn',appealRequest.patientLn);
        }
        if(!String.isEmpty(appealRequest.appealId)){
            requestParamsMap.put('appealId',appealRequest.appealId.toUpperCase());
        }
        if(!String.isEmpty(appealRequest.claimNumber)){
            requestParamsMap.put('claimNumber',appealRequest.claimNumber.toUpperCase());
        }
        if(!String.isEmpty(appealRequest.firstSubmDt)){
            String reqDate = SAEUtils.formatDate(appealRequest.firstSubmDt);
            requestParamsMap.put('firstSubmDt',reqDate);
        }
        if(!String.isEmpty(appealRequest.lastSubmDt)){
            String reqDate = SAEUtils.formatDate(appealRequest.lastSubmDt);
            requestParamsMap.put('lastSubmDt',reqDate);
        }
        return requestParamsMap;
    }

    private static List<AppealResponse> processResponse(String response){
        List<AppealResponse> returnList = new List<AppealResponse>();
        List<AppealWrapper> responseList = (List<AppealWrapper>) JSON.deserialize(response, List<AppealWrapper>.class);        
        if(responseList != null && responseList.size() > 0){
            for(AppealWrapper aw : responseList){
                AppealResponse ar = new AppealResponse();
                ar.appealNo = checkString(aw.appealId);
                ar.memberName = checkString(aw.patientFn) + ' ' + checkString(aw.patientLn);
                ar.taxId = checkString(aw.providerInformation.taxId);
                ar.issueType = checkString(aw.caseType);
                ar.serviceType = checkString(aw.preOrPostServiceDesc);
                ar.received = checkString(aw.submDt);
                ar.status = checkString(aw.caseStatusDesc);
                ar.outcome = checkString(aw.caseOutcomeDesc);
                ar.claimNo = aw.claims != null && aw.claims.size() > 0 ? checkString(aw.claims[0].claimNumber) : '--';
                ar.srnNo = '--'; //Gap
                returnList.add(ar);
            }
        }
        return returnList;
    }

    private static ACET_AppealDetailsWrapper processDetails(String response){
        try{
            String regExp = '\bdate\b';
            ACET_AppealDetailsWrapper returnWrap = (ACET_AppealDetailsWrapper) JSON.deserialize(response.replaceAll(regExp,'date_Z'), ACET_AppealDetailsWrapper.class);
            system.debug(JSON.Serialize(returnWrap));
            return returnWrap;
        }catch(Exception e){
            return new ACET_AppealDetailsWrapper();
        }
    }

    private static String checkString(String val){
        return val != null ? val : '--';
    }

    private class AppealWrapper
    {
        private String appealId;
        private String patientFn;
        private String patientLn;
        private String caseType;
        private String preOrPostServiceDesc;
        private String submDt;
        private String caseStatusDesc;
        private String caseOutcomeDesc;
        private List<Claims> claims;
        private ProviderInformation providerInformation;
    }

    private class Claims {
		private String claimNumber;
    }
    
    private class ProviderInformation {
		private String taxId;
	}

    public class AppealRequest
    {
        @AuraEnabled public String tin{get;set;}
        @AuraEnabled public String memberId{get;set;}
        @AuraEnabled public String patientFn{get;set;}
        @AuraEnabled public String patientLn{get;set;}
        @AuraEnabled public String appealId{get;set;}
        @AuraEnabled public String claimNumber{get;set;}
        @AuraEnabled public String firstSubmDt{get;set;}
        @AuraEnabled public String lastSubmDt{get;set;}
    }

    public class AppealResponse
    {
        @AuraEnabled public String appealNo;
        @AuraEnabled public String memberName;
        @AuraEnabled public String taxId;
        @AuraEnabled public String issueType;
        @AuraEnabled public String serviceType;
        @AuraEnabled public String received;
        @AuraEnabled public String status;
        @AuraEnabled public String outcome;
        @AuraEnabled public String claimNo;
        @AuraEnabled public String srnNo;
    }
}