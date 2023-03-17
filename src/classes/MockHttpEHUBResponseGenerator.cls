@isTest
public class MockHttpEHUBResponseGenerator implements HttpCalloutMock {

    public Integer statusCode{get;set;}
    public String serviceType{get;set;}
    public MockHttpEHUBResponseGenerator(Integer statusCode,String serviceType)
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
        String resp=responseJSONSR.Body.toString();
        resp=resp.replaceAll('200', statusCode+'');
        System.debug('resp='+resp);
        res.setBody(resp);
        res.setStatusCode(statusCode);
        return res;
    }
}