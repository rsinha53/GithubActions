public class SAE_ProviderCardCtrl {
    
    @AuraEnabled
    public static List<State__mdt> getStateValues() {
        List<State__mdt> stateList = [SELECT Id, DeveloperName, MasterLabel FROM State__mdt ORDER BY DeveloperName asc];
        return stateList;
    }
    
    @AuraEnabled
    public static Map < String, Object > getProviderSearchResponse(ProviderDetails providerDetails, Boolean isAdvancedSearch) {
        Map < String, Object > responseMap = new Map < String, Object > ();
        System.debug('@@ providerDetails: ' + providerDetails);
        System.debug('@@ isAdvancedSearch: ' + isAdvancedSearch);
        /*String mockJSONString = mockJSON.Body.toString(); 
		responseMap.put('providerResponseJSON', mockJSONString);*/
        //String endPoint = 'https://gateway-stage.optum.com/api/alpha/pdr/pes/physicians-and-facilities/v4.0/search';
        Map < String, ACETOrgInstanceURLToOrgNameMap__c > OrgInstance2OrgNameMap = ACETOrgInstanceURLToOrgNameMap__c.getAll();
        String orgName = Test.isRunningTest() ? 'dev' : ACETUtility.GetOrgName(OrgInstance2OrgNameMap);
        Map < String, ISL_Webservice_Config__c > islWebserviceData = ISL_Webservice_Config__c.getAll();
        String endPoint = islWebserviceData.get(orgName + '_PESProviderSearch').Value__c;
        //String requestParameters = '?app-nm=acet&start=0&count=50';
        String requestParameters = '&app-nm=acet&start=0&count=50';

        if (providerDetails.practicingStatus == 'Active') {
            requestParameters = requestParameters + '&active-ind=ACTIVE';
        } else {
            requestParameters = requestParameters + '&active-ind=BOTH';
        }

        if (providerDetails.taxIdOrNPI != null && providerDetails.taxIdOrNPI != '') {
            if (providerDetails.taxIdOrNPI.length() == 9) {
                requestParameters = requestParameters + '&tax-id-nbr=' + providerDetails.taxIdOrNPI;
            } else if (providerDetails.taxIdOrNPI.length() == 10) {
                requestParameters = requestParameters + '&npi-id=' + providerDetails.taxIdOrNPI;
            }
        }
        if (isAdvancedSearch) {
            if (providerDetails.firstName != null && providerDetails.firstName != '') {
                requestParameters = requestParameters + '&prof-first-nm=' + providerDetails.firstName;
            }
            if (providerDetails.lastName != null && providerDetails.lastName != '') {
                requestParameters = requestParameters + '&prof-last-nm=' + providerDetails.lastName;
            }
        }
        if (isAdvancedSearch) {
            if (providerDetails.filterType != null && providerDetails.filterType == 'Physician') {
                requestParameters = requestParameters + '&provider-type=' + 'P'; // Thanish - 18th Sept 2019 - added 'i' in '&provder-type=' so that the filter works properly.
            } else if (providerDetails.filterType != null && providerDetails.filterType == 'Facility') {
                requestParameters = requestParameters + '&provider-type=' + 'O'; // Thanish - 18th Sept 2019 - added 'i' in '&provder-type=' so that the filter works properly.
            }
        }
        if (isAdvancedSearch) {
            if (providerDetails.state != null && providerDetails.state != '') {
                requestParameters = requestParameters + '&st-cd=' + providerDetails.state;
            }
        }
        if (isAdvancedSearch) {
            if (providerDetails.zip != null && providerDetails.zip != '') {
                requestParameters = requestParameters + '&zip=' + providerDetails.zip;
            }
        }
        requestParameters = requestParameters + '&tax-id-type-cd=T&attribute-set=summary_0002';

        //US1816890 - Sanka
        if (providerDetails.IsSnapshot != null && providerDetails.IsSnapshot) {
            requestParameters = providerDetails.SnapshotParameters;
        }



        /*Http h = new Http();
        HttpRequest httpRequest = new HttpRequest();
        
       
        String url = endpoint + requestParameters;
        httpRequest.setEndpoint(url);
        httpRequest.setMethod('POST');
        httpRequest.setHeader('Authorization', 'Bearer ' + getAuthToken()); //got token from postman OAuth
        httpRequest.setHeader('Content-Type', 'application/x-www-form-urlencoded');
        httpRequest.setHeader('Accept', 'application/json');
        httpRequest.setTimeout(12000);
        system.debug ('RequestBody' + url);*/

        System.debug('SAE_ProviderCardCtrl: requestParameters: ' + requestParameters);

        utils.convertReqURLToReqParamMap(requestParameters);
        HttpResponse httpResponse = new HttpResponse();
        ACET_WebserviceCalloutFramework wsCallOutFW = new ACET_WebserviceCalloutFramework();
        wsCallOutFW.serviceName = 'FastProviderSearch';
        System.debug('@@ SAE_ProviderCardCtrl: getProviderSearchResponse: requestParamsMap: ' + Utils.convertReqURLToReqParamMap(requestParameters));
        wsCallOutFW.requestParamsMap = Utils.convertReqURLToReqParamMap(requestParameters);
        wsCallOutFW.encodeURLParameters = true;
        httpResponse = wsCallOutFW.getResponse();
        Integer sCode = httpResponse.getStatusCode();
        responseMap.put('statusCode', sCode);
        string message = '';
        if (sCode == 200) {
            String Response = httpResponse.getBody();
            System.debug('statusCode: ' + httpResponse.getStatusCode());
            System.debug('@ SAE_ProviderCardCtrl: httpResponse body: ' + httpResponse.getBody());
            responseMap.put('success', true);
            responseMap.put('providerResponseJSON', httpResponse.getBody());
        } else {
            /*if (sCode == 400) {
                message = SAEMemberProviderWS.getErrorMessage(SAEConstants.GN400);
            } else if (sCode == 404) {
                message = SAEMemberProviderWS.getErrorMessage(SAEConstants.GN404);
            } else if (sCode == 500) {
                message = SAEMemberProviderWS.getErrorMessage(SAEConstants.GN500A);
            } else if (sCode == 100) {
                message = SAEMemberProviderWS.getErrorMessage(SAEConstants.GN100);
            }*/
            message = 'Unexpected Error Occurred in the Provider Lookup Results card. Please try again. If problem persists please contact the help desk.';
            responseMap.put('Success', false);
            responseMap.put('statusCode', sCode);
            responseMap.put('Response', new ProviderDetails());
            responseMap.put('Message', message);
            system.debug('responseMap' + responseMap);
        }
        /*} catch(System.CalloutException e) {
			System.debug('@@@ SAE_ProviderCardCtrl: getTest: exception caught: ' + e);
		}*/
        return responseMap;
    }
    
    /*@AuraEnabled
	public static Map<String, Object> makeCallOut(){
		Map<String, Object> responseMap = new Map<String, Object>();
		String endPoint = 'https://gateway-stage.optum.com/api/alpha/pdr/pes/physicians-and-facilities/v4.0/search';
		String requestParameters = '?app-nm=acet&active-ind=BOTH&start=0&count=50&tax-id-nbr=061330992&tax-id-type-cd=T&attribute-set=summary_0002';
		Http h = new Http();
		HttpRequest httpRequest = new HttpRequest();
		HttpResponse httpResponse = new HttpResponse();
		String url = endpoint + requestParameters;
		httpRequest.setEndpoint(url);
		httpRequest.setMethod('POST');
		httpRequest.setBody('Body');
		httpRequest.setHeader('Authorization', 'Bearer ' + getAuthToken()); //got token from postman OAuth
		httpRequest.setHeader('Content-Type', 'application/x-www-form-urlencoded');
		httpRequest.setHeader('Accept', 'application/json');
		httpRequest.setTimeout(12000);
		httpResponse = h.send(httpRequest);
		responseMap.put('statusCode', httpResponse.getStatusCode());
		if(httpResponse.getStatusCode() == 200){
			System.debug('@ SAE_ProviderCardCtrl: httpResponse body: ' + httpResponse.getBody());
			responseMap.put('success', true);
		}
		return responseMap;
	}*/
    
    public static String getAuthToken() {
        return ISL_Webservice_Config__c.getInstance('SNIAPIAccessToken').Value__c;
    }
    
    public class ProviderDetails {
        @AuraEnabled public string taxIdOrNPI {get;set;}
        @AuraEnabled public string contactName {get;set;}
        @AuraEnabled public string filterType {get;set;}
        @AuraEnabled public string firstName {get;set;}
        @AuraEnabled public string lastName {get;set;}
        @AuraEnabled public string zip {get;set;}
        @AuraEnabled public string phone {get;set;}
        @AuraEnabled public string state {get;set;}
        @AuraEnabled public string searchOption {get;set;}
        @AuraEnabled public string practicingStatus {get;set;}
        
        //US1816890 - Sanka
        @AuraEnabled public Boolean IsSnapshot{get;set;}
        @AuraEnabled public String SnapshotParameters{get;set;}
    }
    
}