@isTest
global class Motion_MemberInfoMockTest4 implements HttpCalloutMock{
    
    /* global HTTPResponse respond(HTTPRequest req) {
        HttpResponse res = new HttpResponse();
        res.setHeader('Content-Type', 'application/json');
        res.setBody('{"IntType":"Phone Call","FirstName":"Mary","LastName":"John","BirthDate":"1980-01-01T00:00:00","ReqPage":"1"}');
        res.setStatusCode(200);
        return res;
    } */
    
    global HTTPResponse respond(HTTPRequest req) {
        HttpResponse res = new HttpResponse();
        res.setHeader('Content-Type', 'application/json');
        res.setBody('{"IntType":"Phone Call","FirstName":"Mary","LastName":"John","BirthDate":"1980-01-01T00:00:00","EmailAddress":"mary.john@gmail.com","RegisteredMemberID":"123456","GroupName":"ST961","Status":"Active","TransactionID":"454848","ReqPage":"1"}');
        res.setStatusCode(200);
        return res;
    }
}