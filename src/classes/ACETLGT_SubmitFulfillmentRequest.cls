public class ACETLGT_SubmitFulfillmentRequest {

    public String getRequestBody(String memberId,string groupId, string bundleId){
        String requestBody ;
        ACETLGT_SubmitFulfillmentRequestWrapper submitRequestWrapper = new ACETLGT_SubmitFulfillmentRequestWrapper();
        requestBody = submitRequestWrapper.addSearchInput(memberId,groupId,bundleId);
        return requestBody;
    }
    
    public ACETWSCalloutResult submitFulfillmentRequest(String memberId, string groupId, string bundleId){
        
        ACETWSCalloutResult calloutResult = new ACETWSCalloutResult();
        ACET_WebserviceCalloutFramework wsCallOutFW = new ACET_WebserviceCalloutFramework();
        wsCallOutFW.serviceName = 'SubmitFulfillmentRequestService';
        wsCallOutFW.requestBody = GetRequestBody(memberId,groupId,bundleId); 
        HttpResponse response  = wsCallOutFW.getResponse();
        system.debug('response ---->'+response.getBody());
        if(response != null && response.getStatusCode() == 201){
            CorrelationIDWrapper correlationWrapper = (CorrelationIDWrapper)JSON.deserialize(response.getBody(), CorrelationIDWrapper.class);
            calloutResult.Success = true;
            calloutResult.Message = '';
            calloutResult.Response = correlationWrapper.externalCorrelationID;
        }else
        {
            calloutResult.Success = false;
            calloutResult.Message = '';
            calloutResult.Response = 'Web Service or External System is temporarily unavailable.';
			calloutResult.statusCode = response.getStatusCode();
        }
        
        return calloutResult;   
    
    } 
    
    public class CorrelationIDWrapper
    {
        public string externalCorrelationID{get;set;}
    }
    
}