public with sharing class ACET_BenefitDetailsHelper 
{
    // Response Classes
    public class BenefitResponse
    {
        @AuraEnabled public String categoryName;
        @AuraEnabled public String benefitId;
    }

    public class ACET_BenefitSummaryResponse {
        public Boolean newBenefits;
        public List<Benefits> benefits;   
    }

    public class Children {
        public String categoryName;
        public String benefitId;
    }

    public class Benefits {
        public String categoryName;
        public List<Children> children;
    }

    public static ACET_BenefitSummaryResponse parseResonse(String json) {
        return (ACET_BenefitSummaryResponse) System.JSON.deserialize(json, ACET_BenefitSummaryResponse.class);
    }

    public static List<BenefitResponse> getBenefitSummary(String transactionId){
        List<BenefitResponse> returnResponse = new List<BenefitResponse>();
        try {
            Map < String, String > requestParamsMap = new Map < String, String > ();
            requestParamsMap.put('transactionId', String.isNotBlank(transactionId) ? transactionId : '');
            requestParamsMap.put('isB360Call', 'true');
            requestParamsMap.put('isCsr', 'true');

            HttpResponse httpResponse = getWebServiceObject(requestParamsMap, 'LinkBenefitSummary');

            if(httpResponse.getStatusCode() == 200){
                ACET_BenefitSummaryResponse serverResponse = parseResonse(httpResponse.getBody());
                for(ACET_BenefitDetailsHelper.Benefits resp : serverResponse.benefits){
                    for (ACET_BenefitDetailsHelper.Children child : resp.children) {
                        ACET_BenefitDetailsHelper.BenefitResponse benResp = new ACET_BenefitDetailsHelper.BenefitResponse();
                        benResp.categoryName = child.categoryName;
                        benResp.benefitId = child.benefitId;
                        returnResponse.add(benResp);
                    }
                }
            }
        } catch (Exception e) {
            System.debug('Exception in ACET_BenefitDetailsHelper - Line ' + e.getLineNumber());
            System.debug('Exception in ACET_BenefitDetailsHelper - Message ' + e.getMessage());
        }       
        
        return returnResponse;
    }

    // US3125215 - Thanish - 22nd Dec 2020
    public class BenefitSearchResult {
        public String benefitId;
	    public String benefitName;
    }

    public static List<BenefitSearchResult> parseBenefitSearchResult(String json) {
		return (List<BenefitSearchResult>) System.JSON.deserialize(json, List<BenefitSearchResult>.class);
	}

    // US3304569 - Thanish - 17th Mar 2021
    public static SearchBenefitWrapper searchBenefit(String transactionId, String searchPhrase){
        SearchBenefitWrapper returnResponse = new SearchBenefitWrapper();
        List<BenefitResponse> benefitList = new List<BenefitResponse>();
        try {
            Map < String, String > requestParamsMap = new Map < String, String > ();
            requestParamsMap.put('transactionId', String.isNotBlank(transactionId) ? transactionId : '');
            requestParamsMap.put('isB360Call', 'true');
            requestParamsMap.put('searchPhrase', searchPhrase);
            requestParamsMap.put('isCsr', 'true');

            HttpResponse httpResponse = getWebServiceObject(requestParamsMap, 'LinkBenefitSearch');
            returnResponse.statusCode = httpResponse.getStatusCode();
            if(httpResponse.getStatusCode() == 200){
                List<BenefitSearchResult> resultList = parseBenefitSearchResult(httpResponse.getBody());
                for(BenefitSearchResult result : resultList){
                    BenefitResponse resp = new BenefitResponse();
                    resp.benefitId = result.benefitId;
                    resp.categoryName = result.benefitName;
                    benefitList.add(resp);
                }
            }
            
        } catch (Exception e) {
            returnResponse.statusCode = 999;
            System.debug('Exception in ACET_BenefitDetailsHelper - Line ' + e.getLineNumber());
            System.debug('Exception in ACET_BenefitDetailsHelper - Message ' + e.getMessage());
        }  
        returnResponse.benefitList = benefitList;
        return returnResponse;
    }

    // US3304569 - Thanish - 17th Mar 2021
    public class SearchBenefitWrapper {
        @AuraEnabled public List<BenefitResponse> benefitList;
        @AuraEnabled public Integer statusCode;
    }

    // US3304569 - Thanish - 17th Mar 2021
    public class BenefitLanguageDetails {
        public Boolean newBenefits;
        public List<Benefit> benefit;
        public Integer statusCode;
    }

    public class LimitsAndExceptions {
        public String description;
        public String details;
    }

    public class BenefitNetworkSection {
        public String costs;
        public List<String> networkStatus;
    }

    public class Benefit {
        public String benefitName;
        public String benefitDetails;
        public List<BenefitNetworkSection> benefitNetworkSection;
        public List<LimitsAndExceptions> limitsAndExceptions;
    }

    public static BenefitLanguageDetails parseBenefitLanguageResult(String json) {
		return (BenefitLanguageDetails) System.JSON.deserialize(json, BenefitLanguageDetails.class);
	}

    public static BenefitLanguageDetails getBenefitLanguage(String transactionId, String benefitCode){
        BenefitLanguageDetails returnResponse = new BenefitLanguageDetails();
        try{
            Map < String, String > requestParamsMap = new Map < String, String > ();
            requestParamsMap.put('transactionId', String.isNotBlank(transactionId) ? transactionId : '');
            requestParamsMap.put('isB360Call', 'true');
            requestParamsMap.put('benefitCode', benefitCode);
            requestParamsMap.put('isCsr', 'true');

            HttpResponse httpResponse = getWebServiceObject(requestParamsMap, 'LinkBenefitLanguage');
            if(httpResponse.getStatusCode() == 200){
                returnResponse = parseBenefitLanguageResult(httpResponse.getBody());
            }
            returnResponse.statusCode = httpResponse.getStatusCode();// US3304569 - Thanish - 17th Mar 2021

        } catch (Exception e){
            returnResponse.statusCode = 999;// US3304569 - Thanish - 17th Mar 2021
            System.debug('Exception in ACET_BenefitDetailsHelper - Line ' + e.getLineNumber());
            System.debug('Exception in ACET_BenefitDetailsHelper - Message ' + e.getMessage());
        }
        return returnResponse;
    }

    public static HttpResponse getWebServiceObject(Map<String, String> requestParamsMap, String serviceName)
    {
        ACET_WebserviceCalloutFramework wsCallOutFW = new ACET_WebserviceCalloutFramework();
        wsCallOutFW.serviceName = serviceName;
        wsCallOutFW.requestParamsMap = requestParamsMap;
        wsCallOutFW.encodeURLParameters = true;
        HttpResponse httpResponse = wsCallOutFW.getResponse();

        return httpResponse;
    }

}