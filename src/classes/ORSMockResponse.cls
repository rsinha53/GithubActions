@isTest
global class ORSMockResponse implements HttpCalloutMock {
    // Implement this interface method
    global HTTPResponse respond(HTTPRequest req) {        
        // Create a fake response
        HttpResponse res = new HttpResponse();
        res.setHeader('Content-Type', 'application/json');
        res.setBody('{"postResult":{"postOutput":{"contactId":"D00860706583119","issueId":"D00860706583119"}}}');
        res.setStatusCode(200);
        return res;
    }
}