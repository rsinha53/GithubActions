public class ACETLGT_SearchBenefitsService { //extends ACETWebService

    
    public String getRequestBody(String benefitPlanId,string searchPhrase,String dateOfService, String sessionId){
        
        String requestBody ;
        ACETLGT_SearchBenefitsRequestWrapper submitRequestWrapper = new ACETLGT_SearchBenefitsRequestWrapper();
        submitRequestWrapper.benefitPlanIDs = new List<ACETLGT_SearchBenefitsRequestWrapper.BenefitPlanIDs>();
        ACETLGT_SearchBenefitsRequestWrapper.BenefitPlanIDs benefitPlan = new ACETLGT_SearchBenefitsRequestWrapper.BenefitPlanIDs();
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
        requestBody = JSON.serialize(submitRequestWrapper);
       	system.debug('requestBody: ' + requestBody);
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
            ACETLGT_SearchBenefitsResponseJSON searchBenefitsResponse = (ACETLGT_SearchBenefitsResponseJSON)JSON.deserialize(response.getBody(), ACETLGT_SearchBenefitsResponseJSON.class);
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