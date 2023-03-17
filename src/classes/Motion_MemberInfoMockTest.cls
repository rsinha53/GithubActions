@isTest
global class Motion_MemberInfoMockTest implements HttpCalloutMock{
    
 /*   HttpResponse[] responses = new HttpResponse[0];
    
    public void addResponse(HttpResponse response) {
        responses.add(response);
    }
    public HttpResponse respond(HttpRequest request) {
        return responses.remove(0);
    } */
    
	global HTTPResponse respond(HTTPRequest req) {
        HttpResponse res = new HttpResponse();
        res.setHeader('Content-Type', 'application/json');
        res.setBody('{"RegisteredMemberID":330203,"EligibleMemberID":null,"FirstName":"st9611","LastName":"modelaccount","EmailAddress":"st9611@tst2.com","BirthDate":"1980-01-01T00:00:00","SSN":null,"Gender":"F","Phone":"11111111111111","Address":"address 1","City":"address city","State":"SC","ZipCode":"90210","Role":null,"GroupName":"ST961","LookupRuleGroupID":8136,"ClientName":"ST961","Height":72.00,"Weight":111.00,"Status":"Preloaded","ProgramStartDate":"2020-09-17T00:00:00","CancelledDateTime":null,"DependentCode":"P","PlanType":"","MaxDailyEarnings":9,"TimeZone":"Hong Kong, Manila, Philippines (UTC+8:00)","MonthlyEmail":"true","WeeklyEMail":"true","OptOutAllEmails":"true","SyncFrequency":60,"FraudTier":"false","FraudLockout":"true","DoNotLockAccount":"false","AlternateActivityEligible":"false","AlternateActivityOptInStatus":"false"}');
        res.setStatusCode(200);
        return res;
    }
    
   /* global HTTPResponse respond2(HTTPRequest req) {
        HttpResponse res = new HttpResponse();
        res.setHeader('Content-Type', 'application/json');
        res.setBody('{"DeviceModelPaired":"TrioMotion_PE932_BLE","LastSyncStepDateTime": "1980-01-01T00:30","LastSyncAppVersion":"UHC Motion 4.3.2.4","FirmwareVersion":3.9,"SyncFrequency":60,"TimeZone":"Hong Kong, Malina"}');
        res.setStatusCode(200);
        return res;
   } 
    
    global HTTPResponse respond(HTTPRequest req) {
        HttpResponse res = new HttpResponse();
        res.setHeader('Content-Type', 'application/json');
        res.setBody('{"RegisteredMemberID":330203,"EligibleMemberID":null,"FirstName":"st9611","LastName":"modelaccount","EmailAddress":"st9611@tst2.com","BirthDate":"1980-01-01T00:00:00","SSN":null,"Gender":"F","Phone":"11111111111111","Address":"address 1","City":"address city","State":"SC","ZipCode":"90210","Role":null,"GroupName":"ST961","LookupRuleGroupID":8136,"ClientName":"ST961","Height":72.00,"Weight":111.00,"Status":"Preloaded","ProgramStartDate":"2020-09-17T00:00:00","CancelledDateTime":null,"DependentCode":"P","PlanType":"","MaxDailyEarnings":9,"TimeZone":"Hong Kong, Manila, Philippines (UTC+8:00)","MonthlyEmail":"true","WeeklyEMail":"true","OptOutAllEmails":"true","SyncFrequency":60,"FraudTier":"false","FraudLockout":"true","DoNotLockAccount":"false","AlternateActivityEligible":"false","AlternateActivityOptInStatus":"false"}');
        res.setStatusCode(500);
        return res;
    }*/
}