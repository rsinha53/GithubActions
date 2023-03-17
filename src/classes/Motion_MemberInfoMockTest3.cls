@isTest
global class Motion_MemberInfoMockTest3 implements HttpCalloutMock{
      
	global HTTPResponse respond(HTTPRequest req) {
        HttpResponse res = new HttpResponse();
        res.setHeader('Content-Type', 'application/json');
        res.setBody('{"RegisteredMemberID":null,"EligibleMemberID":440304,"FirstName":"st9611","LastName":"modelaccount","EmailAddress":"st9611@tst2.com","BirthDate":"1980-01-01T00:00:00","SSN":null,"Gender":"F","Phone":"11111111111111","Address":"address 1","City":"address city","State":"SC","ZipCode":"90210","Role":null,"GroupName":"ST961","LookupRuleGroupID":8136,"ClientName":"ST961","Height":"","Weight":111.00,"Status":"Preloaded","ProgramStartDate":"2020-09-17T00:00:00","CancelledDateTime":null,"DependentCode":"P","PlanType":"","MaxDailyEarnings":9,"TimeZone":"Hong Kong, Manila, Philippines (UTC+8:00)","MonthlyEmail":"true","WeeklyEMail":"true","OptOutAllEmails":"false","SyncFrequency":60,"FraudTier":"false","FraudLockout":"true","DoNotLockAccount":"false","AlternateActivityEligible":"","AlternateActivityOptInStatus":""}');
        res.setStatusCode(200);
        return res;
    }
}