public class ACETSubmitfulfillmentrequest {

    public String getRequestBody(String memberId,string groupId, string bundleId){
        
        String requestBody ;
        ACETSubmitfulfillmentrequestWrapper submitRequestWrapper = new ACETSubmitfulfillmentrequestWrapper();
        requestBody = submitRequestWrapper.addSearchInput(memberId,groupId,bundleId);
        return requestBody;
    }
    
    public ACETWSCalloutResult submitFulfillmentRequest(String memberId, string groupId, string bundleId){
        
        ACETWSCalloutResult calloutResult = new ACETWSCalloutResult();
        ACET_WebserviceCalloutFramework wsCallOutFW = new ACET_WebserviceCalloutFramework();
        wsCallOutFW.serviceName = 'SubmitFulfillmentRequestService';
        wsCallOutFW.requestBody = GetRequestBody(memberId,groupId,bundleId); 
        HttpResponse response  = wsCallOutFW.getResponse();
        //Response.setStatusCode(501);
        calloutResult.statusCode=response!=null?response.getStatusCode():null;        
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
            calloutResult.Response = '';
            calloutResult.statusCode=response!=null?response.getStatusCode():null;
        }
        
        return calloutResult;   
    
    } 
    
    public class CorrelationIDWrapper
    {
        public string externalCorrelationID{get;set;}
    }
    
}