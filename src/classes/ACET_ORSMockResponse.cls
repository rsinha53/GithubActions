@isTest
global class ACET_ORSMockResponse implements HttpCalloutMock {
    
    public String responseBody{get;set;}
    public Integer statusCode{get;set;}
    
    public ACET_ORSMockResponse(String responseBody, Integer statusCode)
    {
        this.responseBody = responseBody;
        this.statusCode = statusCode;
    }
    
    // Implement this interface method
    global HTTPResponse respond(HTTPRequest req) {        
        // Create a fake response
        HttpResponse res = new HttpResponse();
        res.setHeader('Content-Type', 'application/json');
        //res.setBody('{"postResult":{"postOutput":{"contactId":"D00860706583119","issueId":"D00860706583119"}}}');
        res.setBody(responseBody);
        res.setStatusCode(statusCode);
        return res;
    }
}