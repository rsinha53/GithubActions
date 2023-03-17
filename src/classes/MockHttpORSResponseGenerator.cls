@isTest
public class MockHttpORSResponseGenerator implements HttpCalloutMock {

    public Integer statusCode{get;set;}
    public String serviceType{get;set;}
    public MockHttpORSResponseGenerator(Integer statusCode,String serviceType)
    {
        this.statusCode = statusCode;
        this.serviceType=serviceType;
    }
    public HTTPresponse respond(HttpRequest req){
        
       // System.assertEquals('PUT', req.getMethod());
        StaticResource responseJSONSR = null;
        responseJSONSR = [SELECT Body FROM StaticResource WHERE Name = :serviceType];
        HttpResponse res = new HttpResponse();
        res.setHeader('Content-Type', 'application/json');
        res.setBody(responseJSONSR.Body.toString());
        res.setStatusCode(statusCode);
        return res;
    }
}