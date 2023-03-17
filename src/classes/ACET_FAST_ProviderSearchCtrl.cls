public without sharing class ACET_FAST_ProviderSearchCtrl {

	@AuraEnabled
	public static ACET_FastCalloutResult getProviderSearchResults(ProviderDetails providerDetails) {
	System.debug('@@ ACET_FAST_ProviderSearchCtrl: getProviderSearchResults: providerDetails: ' +providerDetails);
     
       Map < String, String > requestParamsMap = new Map < String, String > ();
		ACET_FastCalloutResult calloutResult = new ACET_FastCalloutResult();
        
        String requestParameters = '?app-nm=acet&start=0&count=50';
        requestParamsMap=getParameters(providerDetails,requestParameters);		
       
        requestParamsMap.put('tax-id-type-cd','T');
        requestParamsMap.put('attribute-set','summary_0002'); 
        requestParamsMap.put('app-nm','acet');
        requestParamsMap.put('start','0');
        requestParamsMap.put('count','50');
		try {
              // calling webservice using webservice framework
                ACET_WebserviceCalloutFramework wsCallOutFW = new ACET_WebserviceCalloutFramework();
                wsCallOutFW.serviceName = 'FastProviderSearch';
                wsCallOutFW.requestParamsMap = requestParamsMap;
                wsCallOutFW.encodeURLParameters = true;
              
                HttpResponse frameWorkResponse = new HttpResponse();
                             frameWorkResponse=wsCallOutFW.getResponse();
     
			Integer statusCode = frameWorkResponse.getStatusCode();
			calloutResult.statusCode = statusCode;
			String message = '';
			if (statusCode == 200 ) {
				calloutResult =  successCallout(frameWorkResponse,calloutResult);               
			} else {
			   if (statusCode == 400) {
					message = SAEMemberProviderWS.getErrorMessage(SAEConstants.GN400);
				} else if (statusCode == 404) {
					message = SAEMemberProviderWS.getErrorMessage(SAEConstants.GN404);
				} else if (statusCode == 500) {
					message = SAEMemberProviderWS.getErrorMessage(SAEConstants.GN500A);
				} else if (statusCode == 100) {
					message = SAEMemberProviderWS.getErrorMessage(SAEConstants.GN100);
				}
				calloutResult.isSuccess = true;
				calloutResult.statusCode = statusCode;
				calloutResult.message = message;
			}
		} catch(System.CalloutException coe) {
			calloutResult.isSuccess = false;
			calloutResult.message = 'Something unexpected happened with request';
			return calloutResult;
		} catch(System.Exception e) {
			system.debug('Exception-->'+ e);
		}
		
            
      return calloutResult;
	}
    
    public static String getAuthToken() {
        return ISL_Webservice_Config__c.getInstance('SNIAPIAccessToken').Value__c;
	}
	
	public static ACET_FastCalloutResult successCallout(HttpResponse httpResponse,ACET_FastCalloutResult calloutResult){
        Map<string,String> mapProviderListWrapper=new  Map<string,string>();
        List<ProviderListWrapper> lstProviderListWrapper = new List<ProviderListWrapper>();
		calloutResult.isSuccess = true;
				String responseBody = httpResponse.getBody();
               ACET_ProviderSearchResultsWrapper providerSearchResponse = ACET_ProviderSearchResultsWrapper.parse(responseBody);
               calloutResult.metaData=providerSearchResponse.metadata;
               ACET_ProviderSearchResultsWrapper.ServiceFault eObj =new  ACET_ProviderSearchResultsWrapper.ServiceFault();
               calloutResult.ServiceFault=providerSearchResponse.ServiceFault<>null?providerSearchResponse.ServiceFault:eObj;
               calloutResult.apiResponse =providerSearchResponse;				
				                
                string taxidornpi;
               
                for(ACET_ProviderSearchResultsWrapper.PhysicianFacilitySummary0002Response facilityObj:providerSearchResponse.PhysicianFacilitySummary0002Response){
                    
                taxidornpi=facilityObj.PhysicianFacilityInformation.TaxId.taxId<>null?facilityObj.PhysicianFacilityInformation.TaxId.taxId:facilityObj.PhysicianFacilityInformation.npi[0].npi;
                    if(!mapProviderListWrapper.containsKey(facilityObj.PhysicianFacilityInformation.TaxId.corporateOwnerLastName+taxidornpi)&&
                      facilityObj.PhysicianFacilityInformation.TaxId.cancelDate=='9999-12-31'){
                    lstProviderListWrapper.add(new ProviderListWrapper(false,facilityObj.PhysicianFacilityInformation.firstName,
                                                                      facilityObj.PhysicianFacilityInformation.lastName,
                                                                      taxidornpi,
                                                                      facilityObj.PhysicianFacilityInformation.TaxId.corporateOwnerLastName,
                                                                      facilityObj.PhysicianFacilityInformation.TaxId.corpMPIN,
																	  facilityObj.PhysicianFacilityInformation.TaxId.payeeProviderId));
    mapProviderListWrapper.put(facilityObj.PhysicianFacilityInformation.TaxId.corporateOwnerLastName+taxidornpi,taxidornpi);
                    }
                    }
          
				calloutResult.response = lstProviderListWrapper;
				
				return calloutResult;
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
        @AuraEnabled public String effectivePhoneNumber{get;set;}//US2784325
        @AuraEnabled public string addressCity{get;set;}//US2784325
	}
    
        public class ProviderListWrapper {
        @AuraEnabled public boolean isChecked {get;set;}
             @AuraEnabled public string firstName {get;set;}
             @AuraEnabled public string lastName {get;set;}
             @AuraEnabled public string taxidornpi {get;set;}
             @AuraEnabled public string cwLastName {get;set;}
             @AuraEnabled public string corpMPIN {get;set;}
             @AuraEnabled public string payeeProviderId {get;set;}
        @AuraEnabled public  ACET_ProviderSearchResultsWrapper.PhysicianFacilitySummary0002Response physicianFacilityinfo{get;set;}
        public ProviderListWrapper(boolean isChecked, string firstName,string lastName,string taxidornpi,string cwLastName,string corpMPIN,String payeeProviderId){
            this.isChecked = isChecked;
            this.firstName = firstName; 
            this.lastName = lastName;
            this.taxidornpi = taxidornpi;
            this.cwLastName = cwLastName;
            this.corpMPIN=corpMPIN;
            this.payeeProviderId = payeeProviderId;
        }
    }
    
   public with sharing class ACET_FastCalloutResult {
    @AuraEnabled public ACET_ProviderSearchResultsWrapper.metadata metaData {get;set;} 
    @AuraEnabled public ACET_ProviderSearchResultsWrapper.ServiceFault serviceFault {get;set;} 
    @AuraEnabled public Object apiResponse {get;set;}
       
    @AuraEnabled public Boolean isSuccess {get;set;}
    @AuraEnabled public Integer statusCode {get;set;}
    @AuraEnabled public List<ProviderListWrapper> response {get;set;}
    @AuraEnabled public String message {get;set;}
    @AuraEnabled public ApexPages.Severity messageSeverity {get;set;}
}
  
    public static Map<string,String> getParameters(ProviderDetails providerDetails,string requestParameters){
            Map<string,String> providerRequestMap=new  Map<string,string>();
       if (String.isNotBlank(providerDetails.taxId)) {
		          providerRequestMap.put('tax-id-nbr',providerDetails.taxId);                    
		} else if (String.isNotBlank(providerDetails.npi)) {
		      providerRequestMap.put('npi-id',providerDetails.npi);
		}
		if (providerDetails.isAdvancedSearch) {
			providerRequestMap = getParametersAdv(providerDetails,providerRequestMap,requestParameters);
		}
        return providerRequestMap;
    }
    
    public static Map<string,String> getParametersAdv(ProviderDetails providerDetails,Map<string,String> providerRequestMap, string requestParameters){
        
        if (String.isNotBlank(providerDetails.firstName)) {
            providerRequestMap.put('prof-first-nm',EncodingUtil.urlEncode(providerDetails.firstName, 'UTF-8'));
        }
        if (String.isNotBlank(providerDetails.lastName)) {
             providerRequestMap.put('prof-last-nm',EncodingUtil.urlEncode(providerDetails.lastName, 'UTF-8'));
        }
        if (String.isNotBlank(providerDetails.filterType) && providerDetails.filterType == 'Physician') {
            providerRequestMap.put('provider-type','p');
        } else if (String.isNotBlank(providerDetails.filterType) && providerDetails.filterType == 'Facility') {
            providerRequestMap.put('provider-type','o');
        }
        if (String.isNotBlank(providerDetails.state)) {
            providerRequestMap.put('st-cd',providerDetails.state);
        }
        if (String.isNotBlank(providerDetails.zip)) {
            providerRequestMap.put('zip',providerDetails.zip);
        }

        return providerRequestMap;
    }
	
}