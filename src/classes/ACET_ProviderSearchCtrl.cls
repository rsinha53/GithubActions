public without sharing class ACET_ProviderSearchCtrl {
    static final string COMMON_ERROR_MESSAGE = 'Unexpected Error Occurred with Provider Results. Please try again. If problem persists please contact the help desk.';

    @AuraEnabled
    public static ACET_SAECalloutResult getProviderSearchResults(ProviderDetails providerDetails) {
        System.debug('@@ ACET_ProviderSearchCtrl: getProviderSearchResults: providerDetails: ' + providerDetails);
        ACET_SAECalloutResult calloutResult = new ACET_SAECalloutResult();
        Map < String, String > requestParamsMap = new Map < String, String > ();
        requestParamsMap.put('app-nm', 'acet');
        requestParamsMap.put('start', '0');
        requestParamsMap.put('count', '50');
        requestParamsMap.put('active-ind', providerDetails.practicingStatus == 'Active' ? 'ACTIVE' : 'BOTH');
        //Old Code
        //Map < String, ACETOrgInstanceURLToOrgNameMap__c > OrgInstance2OrgNameMap = ACETOrgInstanceURLToOrgNameMap__c.getAll();
        // String orgName = Test.isRunningTest() ? 'dev' : ACETUtility.GetOrgName(OrgInstance2OrgNameMap);
        //Map < String, ISL_Webservice_Config__c > islWebserviceData = ISL_Webservice_Config__c.getAll();
        // String endPoint = islWebserviceData.get(orgName + '_PESProviderSearch').Value__c;
        // String requestParameters = '?app-nm=acet&start=0&count=50';
        if (String.isNotBlank(providerDetails.taxId)) {
            requestParamsMap.put('tax-id-nbr', providerDetails.taxId);
            //requestParameters = requestParameters + '&tax-id-nbr=' + providerDetails.taxId;
        } else if (String.isNotBlank(providerDetails.npi)) {
            requestParamsMap.put('npi-id', providerDetails.npi);
            //requestParameters = requestParameters + '&npi-id=' + providerDetails.npi;
        }
        if (String.isNotBlank(providerDetails.lastName)) {
            requestParamsMap.put('prof-last-nm', providerDetails.lastName);
            //requestParameters = requestParameters + '&prof-last-nm=' +EncodingUtil.urlEncode(providerDetails.lastName, 'UTF-8');
        }
        if (providerDetails.isAdvancedSearch) {
            if (String.isNotBlank(providerDetails.firstName)) {
                requestParamsMap.put('prof-first-nm', providerDetails.firstName);
                //requestParameters = requestParameters + '&prof-first-nm=' + EncodingUtil.urlEncode(providerDetails.firstName, 'UTF-8');
            }
            if (String.isNotBlank(providerDetails.filterType) && providerDetails.filterType == 'Physician') {
                requestParamsMap.put('provider-type', 'P');
                //requestParameters = requestParameters + '&provider-type=' + 'P';
            } else if (String.isNotBlank(providerDetails.filterType) && providerDetails.filterType == 'Facility') {
                requestParamsMap.put('provider-type', 'O');
                //requestParameters = requestParameters + '&provider-type=' + 'O';
            }
            if (String.isNotBlank(providerDetails.state)) {
                requestParamsMap.put('st-cd', providerDetails.state);
                //requestParameters = requestParameters + '&st-cd=' + providerDetails.state;
            }
            if (String.isNotBlank(providerDetails.zip)) {
                requestParamsMap.put('zip', providerDetails.zip);
                //requestParameters = requestParameters + '&zip=' + providerDetails.zip;
            }
        }
        requestParamsMap.put('tax-id-type-cd', 'T');
        requestParamsMap.put('attribute-set', 'summary_0002');
        //requestParameters = requestParameters + '&tax-id-type-cd=T&attribute-set=summary_0002';
        try {
            //calling webservice
            ACET_WebserviceCalloutFramework wsCallOutFW = new ACET_WebserviceCalloutFramework();
            wsCallOutFW.serviceName = 'FastProviderSearch';
            wsCallOutFW.requestParamsMap = requestParamsMap;
            wsCallOutFW.encodeURLParameters = true;
            HttpResponse httpResponse = wsCallOutFW.getResponse();
            /*Http h = new Http();
            HttpRequest httpRequest = new HttpRequest();
            HttpResponse httpResponse = new HttpResponse();
            String url = endpoint + requestParameters;
            httpRequest.setEndpoint(url);
            httpRequest.setMethod('POST');
            httpRequest.setHeader('Authorization', 'Bearer ' + getAuthToken());
            httpRequest.setHeader('Content-Type', 'application/x-www-form-urlencoded');
            httpRequest.setHeader('Accept', 'application/json');
            httpRequest.setTimeout(12000);
            httpResponse = h.send(httpRequest);*/

            Integer statusCode = httpResponse.getStatusCode();
            System.debug('@@ ACET_ProviderSearchCtrl: getProviderSearchResults: statusCode: ' + statusCode);
            //String status = httpResponse.getStatus();
            calloutResult.statusCode = statusCode;
            String message = '';
            if (statusCode == 200) {
                calloutResult.isSuccess = true;
                String responseBody = httpResponse.getBody();
                System.debug('@@ ACET_ProviderSearchCtrl: getProviderSearchResults: responseBody: ' + responseBody);
                ACET_ProviderSearchResultsWrapper providerSearchResponse = ACET_ProviderSearchResultsWrapper.parse(responseBody);
                calloutResult.response = providerSearchResponse;
            } else {
                /*if (statusCode == 400) {
                    message = SAEMemberProviderWS.getErrorMessage(SAEConstants.GN400);
                } else if (statusCode == 404) {
                    message = SAEMemberProviderWS.getErrorMessage(SAEConstants.GN404);
                } else if (statusCode == 500) {
                    message = SAEMemberProviderWS.getErrorMessage(SAEConstants.GN500A);
                } else if (statusCode == 100) {
                    message = SAEMemberProviderWS.getErrorMessage(SAEConstants.GN100);
                }*/
                //message = status;
                calloutResult.isSuccess = true;
                calloutResult.statusCode = statusCode;
                calloutResult.message = COMMON_ERROR_MESSAGE;
            }
        } catch (System.CalloutException coe) {
            calloutResult.isSuccess = false;
            calloutResult.message = COMMON_ERROR_MESSAGE;
            System.debug('@@ ACET_ProviderSearchCtrl: getProviderSearchResults: callout exception caught: ' + coe);
        } catch (System.Exception e) {
            calloutResult.isSuccess = false;
            calloutResult.message = COMMON_ERROR_MESSAGE;
            System.debug('@@ ACET_ProviderSearchCtrl: getProviderSearchResults: exception caught: ' + e);
        }
        System.debug('@@ ACET_ProviderSearchCtrl: getProviderSearchResults: calloutResult: ' + calloutResult);
        return calloutResult;
    }

    public static String getAuthToken() {
        if (Organization_Properties__c.getInstance(UserInfo.getProfileId()).callProductionEndpoints__c) {
            return ISL_Webservice_Config__c.getInstance('SAEAPIAccessToken').Value__c;
        }
        return ISL_Webservice_Config__c.getInstance('SNIAPIAccessToken').Value__c;
    }

	public class ProviderDetails {
		@AuraEnabled public Boolean isValidProvider {get;set;}
		@AuraEnabled public Boolean isProviderNotFound {get;set;}
		@AuraEnabled public Boolean isNoProviderToSearch {get;set;}
		@AuraEnabled public Boolean isOther {get;set;}
		@AuraEnabled public Boolean isAdvancedSearch {get;set;}
		@AuraEnabled public Boolean isPysician {get;set;}
		@AuraEnabled public String interactionType {get;set;}
		@AuraEnabled public String providerUniqueId {get;set;}
		@AuraEnabled public String providerId {get;set;}
		@AuraEnabled public String firstName {get;set;}
		@AuraEnabled public String lastName {get;set;}
		@AuraEnabled public String taxId {get;set;}
		@AuraEnabled public String npi {get;set;}
		@AuraEnabled public String filterType {get;set;}
		@AuraEnabled public String practicingStatus {get;set;}
		@AuraEnabled public String state {get;set;}
		@AuraEnabled public String zip{get;set;}
		@AuraEnabled public String phoneNumber{get;set;}
		@AuraEnabled public String contactType{get;set;}
        @AuraEnabled public String corpMPIN{get;set;}
        @AuraEnabled public Boolean isNiceProvider {get;set;}
		@AuraEnabled public String tpsmIndicator{get;set;}
        @AuraEnabled public String addressLine1{get;set;}
        @AuraEnabled public String addressLine2{get;set;}
        @AuraEnabled public String degreeCode{get;set;}
        @AuraEnabled public String EffectivePhoneNumber{get;set;}//US2784325
        @AuraEnabled public string AddressCity{get;set;}//US2784325
	}
	
}