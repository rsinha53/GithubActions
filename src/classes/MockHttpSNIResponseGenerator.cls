@isTest
public class MockHttpSNIResponseGenerator implements HttpCalloutMock {

    public Integer statusCode{get;set;}
    public MockHttpSNIResponseGenerator(Integer statusCode,String serviceType)
    {
        this.statusCode = statusCode;
    }
    public HTTPresponse respond(HttpRequest req){
        
       // System.assertEquals('PUT', req.getMethod());
        StaticResource responseJSONSR = null;
        responseJSONSR = [SELECT Body FROM StaticResource WHERE Name = 'ACETSNIMockResponse'];
        HttpResponse res = new HttpResponse();
        res.setHeader('Content-Type', 'application/json');
        res.setBody(responseJSONSR.Body.toString());
        res.setStatusCode(statusCode);
        return res;
    }
}