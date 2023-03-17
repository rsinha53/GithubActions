/* Class Name: ACETLGT_SearchBenefitsRequestWrapper
* Author: Sai Kolluru
* Created Date: 07/19/2021
* Description: JSON2APEX Class for response from B360 Search Benefits API
*/
public class ACETLGT_GetBenefitSectionService {

    public static final string CLIENT_ID = 'acet';
    public static final string LANGUAGE = 'English';
    public static final string VALUE = 'value';
    public static final string VARIABLE = 'variable';
    public static final string  SESSION = '3nopmolkgjanbe2x2ddttlua';
    public static final string USER_TYPE = 'csr';
    
    
    public String getRequestBody(String benefitId, String sessionId){
        
        String requestBody ;
        ACETLGT_GetBenefitSectionRequestWrapper submitRequestWrapper = new ACETLGT_GetBenefitSectionRequestWrapper();
        submitRequestWrapper.benefitId = benefitId;
	 	submitRequestWrapper.clientId = CLIENT_ID;	
	 	submitRequestWrapper.language = LANGUAGE;	
		submitRequestWrapper.Personalization = new List<ACETLGT_GetBenefitSectionRequestWrapper.Personalization>();
        ACETLGT_GetBenefitSectionRequestWrapper.Personalization personalization = new ACETLGT_GetBenefitSectionRequestWrapper.Personalization();
        personalization.value = VALUE;
        personalization.variable = VARIABLE;
        submitRequestWrapper.Personalization.add(personalization);
	 	submitRequestWrapper.session = String.isNotBlank(sessionId) ? sessionId : SESSION;
	 	submitRequestWrapper.userType = USER_TYPE;	
        requestBody = JSON.serialize(submitRequestWrapper);
        system.debug('requestBody: ' + requestBody);
        return requestBody;
       
    }
    
    public ACETWSCalloutResult searchBenefitsSection(String benefitId, String sessionId){
        
        ACETWSCalloutResult calloutResult = new ACETWSCalloutResult();
        
        ACET_WebserviceCalloutFramework wsCallOutFW = new ACET_WebserviceCalloutFramework();
        wsCallOutFW.serviceName = 'B360GetBenefitsSectionAPI';
        wsCallOutFW.requestBody = GetRequestBody(benefitId, sessionId); 
        HttpResponse response  = wsCallOutFW.getResponse();
        system.debug('response ---->'+response.getBody());
        
        system.debug('response status code'+response.getStatusCode());
        if(response != null && response.getStatusCode() == 200){
            ACETLGT_GetBenefitSectionResponseJSON searchBenefitsResponse = (ACETLGT_GetBenefitSectionResponseJSON)JSON.deserialize(response.getBody(), ACETLGT_GetBenefitSectionResponseJSON.class);
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