@isTest
public class ACETLinkMockResponse implements HttpCalloutMock {

    public Integer statusCode{get;set;}
    public String serviceType{get;set;}

    public ACETLinkMockResponse(Integer statusCode,String serviceType)
    {
        this.statusCode = statusCode;
        this.serviceType=serviceType;
    }

    
    public HTTPresponse respond(HttpRequest req){
        //System.assertEquals('https://api-gateway-stage.linkhealth.com/elink-services/api/eligibility', req.getEndpoint());
        System.assertEquals('GET', req.getMethod());
        
        StaticResource responseJSONSR = null;
        if(serviceType=='LinkEligibilityAPI')
         responseJSONSR = [SELECT Body FROM StaticResource WHERE Name = 'ACETLinkEligibilityResponseMock'];
        else if(serviceType=='LinkExtendedCoverageAPI')
          responseJSONSR = [SELECT Body FROM StaticResource WHERE Name = 'ACETLinkExtendedResponseMock'];

        HttpResponse res = new HttpResponse();
        res.setHeader('Content-Type', 'application/json');
        res.setBody(responseJSONSR.Body.toString());
        res.setStatusCode(statusCode);
        return res;
    }
}