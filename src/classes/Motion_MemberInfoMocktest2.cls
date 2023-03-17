@isTest
global class Motion_MemberInfoMocktest2 implements HttpCalloutMock {

    global HTTPResponse respond(HTTPRequest req) {
        HttpResponse res = new HttpResponse();
        res.setHeader('Content-Type', 'application/json');
        res.setBody('{"medicalWaivers":[{"Status":"Active","Type":"Medical","StartDate":"2020-06-08T00:00:00","EndDate":"2020-06-08T00:00:00","EnteredBy":"AARON ABBOTT","DateEntered":"2020-06-08T10:34:08.8732464","ClientAdminNotes":"Test"}],"pagination":{"TotalPages":1,"NumberOfRecordsPerPage":25,"CurrentPageNumber":1,"TotalRecordsCount":1,"LastPageFlag":false}}');
        res.setStatusCode(200);
        return res;
    }
}