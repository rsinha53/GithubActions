/* Class Name: ACETLGT_AreBenefitsAvailableAPI
* Author: Suresh
* Created Date: 07/16/2021
* Description: API Class to get B360 Are Benefit Available
*/
public class ACETLGT_AreBenefitsAvailableAPI {
    
    public string getRequestBody(String benefitPlanID,String dateOfService){
        String requestBody;
        ACETLGT_AreBenefitsAvailableRequest  areBenefitsAvailableRequest = new ACETLGT_AreBenefitsAvailableRequest();
        requestBody = areBenefitsAvailableRequest.addSearchInput(benefitPlanID, dateOfService);
        return requestBody;
    }
    
    public ACETWSCalloutResult getB360AreBenefitsAvailableService(String benefitPlanID,String dateOfService){
        ACETWSCalloutResult calloutResult = new ACETWSCalloutResult();
        Boolean isAvailable = false;
        try{
            ACET_WebserviceCalloutFramework wsCallOutFW = new ACET_WebserviceCalloutFramework();
            wsCallOutFW.serviceName = 'B360AreBenefitsAvailableService';
            wsCallOutFW.requestBody = getRequestBody(benefitPlanID,dateOfService); 
            HttpResponse httpResponse  = wsCallOutFW.getResponse();
            if(httpResponse != null && httpResponse.getStatusCode() == 200){
                calloutResult.statusCode = httpResponse.getStatusCode();
                String responseStr = httpresponse.getBody();
                    ACETLGT_BenefitsAvailableResponse response = (ACETLGT_BenefitsAvailableResponse) Json.deserialize(responseStr, ACETLGT_BenefitsAvailableResponse.class);
                    if (response!= null && response.result!= null && response.result.isAvailable!= null){ 
                        isAvailable = response.result.isAvailable;
                    }
                    calloutResult.Success = true;
                    calloutResult.Message = '';
                    calloutResult.Response = isAvailable;
                }
                else{
                    calloutResult.MessageSeverity = ApexPages.Severity.ERROR;
                    calloutResult.Success = false;
                calloutResult.statusCode = (httpResponse == null) ? 999 : httpResponse.getStatusCode();
                getErrorMessage(calloutResult);
            }
        }
        catch(Exception e){
            calloutResult.MessageSeverity = ApexPages.Severity.ERROR;
            calloutResult.Success = false;
            calloutResult.Message = ACETUtility.getErrorMessage('GN999');
            calloutResult.statusCode = 999;
        }
        return calloutResult;
    }
    
    public void getErrorMessage(ACETWSCalloutResult calloutResult){
            
        if(calloutResult.statusCode != null && calloutResult.statusCode == 400)
            calloutResult.Message = ACETUtility.getErrorMessage('GN400B'); 
        else if(calloutResult.statusCode != null && calloutResult.statusCode == 404)
            calloutResult.Message = ACETUtility.getErrorMessage('GN404');
        else if(calloutResult.statusCode != null && calloutResult.statusCode == 500)
            calloutResult.Message = ACETUtility.getErrorMessage('GN500'); 
        else if(calloutResult.statusCode != null && calloutResult.statusCode == 504)
            calloutResult.Message = ACETUtility.getErrorMessage('GN504'); 
        else
            calloutResult.Message = ACETUtility.getErrorMessage('GN999');
    }
}