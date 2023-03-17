/*
Purpose:Mock class for covering API callouts from ERM_RequestController
Created Date: 26:07:2021
*/

@isTest
public class ERM_HttpMockTest implements HttpCalloutMock  {

    public HTTPResponse respond(HTTPRequest req) {
        HttpResponse res = new HttpResponse();
        res.setHeader('Content-Type', 'application/xml');
        res.setBody('{"status":"200"},{"returnMessage":"Success"}');
        res.setStatusCode(200);
        System.assertEquals('POST', req.getMethod());
      
        return res;
    }
    
    
    
}