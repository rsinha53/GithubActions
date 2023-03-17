public class ACET_FacetsGETProviderContractsService {
    
    /*public override void getEndpoint()  {
        GetEndpointDetail('FacetsGETProviderContracts');
    }*/
    
    public ACETWSCalloutResult getContractDetails(string CSPProviderId){
        //getEndpoint();
        ACETWSCalloutResult calloutResult = new ACETWSCalloutResult();
        try{
            //Http h = new Http();
            //HttpRequest httpRequest = new HttpRequest();
            HttpResponse httpResponse = new HttpResponse();
            /*string endpoint =RelativeURL+'/'+CSPProviderId;
            system.debug('RelativeURL::'+RelativeURL);
            system.debug('endpoint::'+endpoint);
            httpRequest.setMethod('GET');
            httpRequest.setEndpoint(endPoint);
            httpRequest.setHeader('Content-Type', 'application/json');
            httpRequest.setHeader('client-code', 'ACET');
            httpRequest.setTimeout(12000);
            httpRequest.setHeader('Authorization', 'Bearer ' + ISL_Webservice_Config__c.getInstance('SNIAPIAccessToken').Value__c);
            httpResponse= h.send(httpRequest);*/


            ACET_WebserviceCalloutFramework wsCallOutFW = new ACET_WebserviceCalloutFramework();
            wsCallOutFW.serviceName = 'FacetsGETProviderContracts';
            wsCallOutFW.endpointExtraPath = '/'+CSPProviderId;
            httpResponse = wsCallOutFW.getResponse();
            system.debug('=='+httpResponse.getStatusCode());
            system.debug('===res body '+httpResponse.getBody());
            
            // check response status
            if(httpResponse.getStatusCode() == 200) {
                // parse response
                ACET_FacetsGETProviderContractsResponse contractResponse = ACET_FacetsGETProviderContractsResponse.parse(httpResponse.getBody());
                //ACET_MAndRContractsResponse contractResponse = ACET_MAndRContractsResponse.parse(httpResponse.getBody());
                
                calloutResult.Success = true; calloutResult.Response = contractResponse; calloutResult.statusCode = httpResponse.getStatusCode();
                calloutResult.Message = httpResponse.getStatus(); calloutResult.MessageSeverity = ApexPages.Severity.CONFIRM;
                
                return calloutResult;
                
            } else {
                // send error details when response fails
                calloutResult.Success = false; calloutResult.statusCode = httpResponse.getStatusCode();
                calloutResult.Message = httpResponse.getStatus(); calloutResult.MessageSeverity = ApexPages.Severity.ERROR;
                
                return calloutResult;
            }
            
        }
        catch(Exception e){
            // send error details when there is an exception
            calloutResult.Success = false; calloutResult.statusCode = 999;
            calloutResult.Message = e.getMessage(); calloutResult.MessageSeverity = ApexPages.Severity.ERROR;
            return calloutResult;
        }
    }
    
}