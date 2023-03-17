public class ACET_SearchBenefitsService {

    
    public String getRequestBody(String benefitPlanId,string searchPhrase,String dateOfService, String sessionId){
        
        String requestBody ;
        ACET_SearchBenefitsRequestWrapper submitRequestWrapper = new ACET_SearchBenefitsRequestWrapper();
        submitRequestWrapper.benefitPlanIDs = new List<ACET_SearchBenefitsRequestWrapper.BenefitPlanIDs>();
        ACET_SearchBenefitsRequestWrapper.BenefitPlanIDs benefitPlan = new ACET_SearchBenefitsRequestWrapper.BenefitPlanIDs();
        benefitPlan.benefitPlanID = benefitPlanId;
        benefitPlan.benefitPlanPlatform = 'USP';
        submitRequestWrapper.benefitPlanIDs.add(benefitPlan);
        submitRequestWrapper.clientId = 'acet';
  		submitRequestWrapper.dateOfService = dateOfService;
        List<String> docTypes = new List<String>();
        docTypes.add('dbd');
        submitRequestWrapper.docType = docTypes;
        submitRequestWrapper.language = 'English';
  		submitRequestWrapper.searchPhrase = searchPhrase;
  		submitRequestWrapper.session = sessionId;
  		submitRequestWrapper.userType = 'Member';
       	system.debug('request'+JSON.serialize(submitRequestWrapper));
        requestBody = JSON.serialize(submitRequestWrapper);
        return requestBody;
    }
    
    public ACETWSCalloutResult searchBenefits(String benefitPlanId,string searchPhrase,String dateOfService, String sessionId){
        
        ACETWSCalloutResult calloutResult = new ACETWSCalloutResult();
        
        ACET_WebserviceCalloutFramework wsCallOutFW = new ACET_WebserviceCalloutFramework();
        wsCallOutFW.serviceName = 'B360SearchBenefitsAPI';
        wsCallOutFW.requestBody = GetRequestBody( benefitPlanId, searchPhrase,dateOfService, sessionId); 
        HttpResponse response  = wsCallOutFW.getResponse();
        system.debug('response ---->'+response.getBody());
        
        system.debug('response status code'+response.getStatusCode());
        if(response != null && response.getStatusCode() == 200){
            ACET_SearchBenefitsResponseJSON searchBenefitsResponse = (ACET_SearchBenefitsResponseJSON)JSON.deserialize(response.getBody(), ACET_SearchBenefitsResponseJSON.class);
            system.debug('response wrapper'+searchBenefitsResponse);
            calloutResult.Success = true;
            calloutResult.Message = '';
            calloutResult.Response = searchBenefitsResponse.result.benefit;
        }else
        {
            calloutResult.Success = false;
            calloutResult.Message = '';
            calloutResult.Response = 'Web Service or External System is temporarily unavailable.';
			calloutResult.statusCode = response.getStatusCode();
        }
        
        return calloutResult;   
    
    } 
    
  
}