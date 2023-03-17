@isTest
public class SNI_FL_DigitalOnboardingControllerMock implements HttpCalloutMock {
    public Integer statusCode{get;set;}
    public String serviceType{get;set;}
    public String testType{get;set;}

    public SNI_FL_DigitalOnboardingControllerMock(Integer statusCode,String serviceType, String testType)
    {
        this.statusCode = statusCode;
        this.serviceType=serviceType;
        this.testType=testType;
    }
   
    public HTTPresponse respond(HttpRequest req){
        String endpoint = req.getEndpoint();
        StaticResource responseJSONSR = null;
        if(endpoint.contains('eligibilities/v5')){
            if(serviceType=='LinkEligibilityAPI'){
                if(testType == 'eligible'){
                    responseJSONSR = [SELECT Body FROM StaticResource WHERE Name = 'FamilyLinkDigitalOnboardingEligibleMock'];
                } else if(testType == 'not eligible'){
                    responseJSONSR = [SELECT Body FROM StaticResource WHERE Name = 'FamilyLinkDigitalOnboardingNotEligibleMock'];
                }
            }
        }
        
        if(endpoint.contains('eligibility/v2.0')){
            responseJSONSR = [SELECT Body FROM StaticResource WHERE Name = 'FLDigitalOnboardingLinkEligibilityResponse'];
        }
        if(endpoint.contains('elink-extended')){
            responseJSONSR = [SELECT Body FROM StaticResource WHERE Name = 'FLDigitalOnboardingLinkExtendedResponse'];
        }

        HttpResponse res = new HttpResponse();
        res.setHeader('Content-Type', 'application/json');
        res.setBody(responseJSONSR.Body.toString());
        res.setStatusCode(statusCode);
        return res;
    }
}