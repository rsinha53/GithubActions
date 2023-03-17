@isTest(SeeAllData=false)
public class ACETGetLinkAPIAccessTokenSchedulerTest {
    public static testMethod void ACETGetLinkAPIAccessTokenSchedulerTest1() {
        Map<String, String> TestISLWSConfigs = new Map<String, String>(); 
        TestISLWSConfigs.put('ISLOAuthContentType', 'application/x-www-form-urlencoded');
        TestISLWSConfigs.put('dev_LinkApiGrantType', 'client_credentials');
        TestISLWSConfigs.put('ISLConAccessToken', 'Test');
        TestISLWSConfigs.put('dev_LinkApiOAuthClientId', 'TestClientId');
        TestISLWSConfigs.put('dev_LinkApiOAuthClientSecret', 'TestClientSecret');
        TestISLWSConfigs.put('LinkapiTimeout', '3000');
        TestISLWSConfigs.put('dev_LinkApiEndpoint', 'https://api-stg.optum.com:8443');
        List<ISL_Webservice_Config__c> lstISLWSConfigs = ACETTestDataUtility.CreateISLWebserviceConfigurations(TestISLWSConfigs);
        insert lstISLWSConfigs;
        
        String ResponseJSON = '{"access_token": "c92e92f8-0f13-43ee-be04-f2347370d7ad", "token_type": "Bearer", "expires_in": 3800, "scope": "read"}';
        MockHttpCalloutResponseGenerator.MockHttpResponse OILTestResponse = new MockHttpCalloutResponseGenerator.MockHttpResponse(200, 'OK', ResponseJSON);
        OILTestResponse.TokenExpired = false;
        
        test.startTest();
        
        MockHttpCalloutResponseGenerator MockHttpResponse = new MockHttpCalloutResponseGenerator(null, OILTestResponse);
        Test.setMock(HttpCalloutMock.class, MockHttpResponse);
        
        ACETGetAccessTokenScheduler ACETGATScheduler = new ACETGetAccessTokenScheduler();
        String HourCronExpr = '0 0 * * * ?';
        String HalfHourCronExpr = '0 30 * * * ?';
        System.schedule('Test ACET Get Access Token Hourly Job', HourCronExpr, ACETGATScheduler);
        System.schedule('Test ACET Get Access Token Half Hourly Job', HalfHourCronExpr, ACETGATScheduler);
        
        test.stopTest();
    }
    public static testMethod void ACETGetAccessTokenSchedulerTest2() {
        Map<String, String> TestISLWSConfigs = new Map<String, String>(); 
        TestISLWSConfigs.put('ISLOAuthContentType', 'application/x-www-form-urlencoded');
        TestISLWSConfigs.put('ISLOAuthGrantType', 'client_credentials');
        TestISLWSConfigs.put('dev_CISLOAuthClientId', 'TestClientIdCISL');
        TestISLWSConfigs.put('CISLConAccessToken', 'Test1');
        TestISLWSConfigs.put('dev_CISLOAuthClientSecret', 'TestClientSecretCISL');
        TestISLWSConfigs.put('CISLTimeout', '3000');
        TestISLWSConfigs.put('dev_CISLOAuthTokenEndpoint', 'https://api-stg.optum.com:8443');
        List<ISL_Webservice_Config__c> lstISLWSConfigs = ACETTestDataUtility.CreateISLWebserviceConfigurations(TestISLWSConfigs);
        insert lstISLWSConfigs;
        
        String ResponseJSON = '{"access_token": "c92e92f8-0f13-43ee-be04-f2347370d7ad", "token_type": "Bearer", "expires_in": 3900, "scope": "read"}';
        MockHttpCalloutResponseGenerator.MockHttpResponse OILTestResponse = new MockHttpCalloutResponseGenerator.MockHttpResponse(200, 'OK', ResponseJSON);
        OILTestResponse.TokenExpired = false;
        
        test.startTest();
        
        MockHttpCalloutResponseGenerator MockHttpResponse = new MockHttpCalloutResponseGenerator(null, OILTestResponse);
        Test.setMock(HttpCalloutMock.class, MockHttpResponse);
        
        ACETGetLinkAPIAccessTokenScheduler ITEGATScheduler = new ACETGetLinkAPIAccessTokenScheduler();
		String HourCronExpr = '0 0 * * * ?';
		String HalfHourCronExpr = '0 30 * * * ?';
		System.schedule('Get ACET LINK API Access Token Hourly Job Test', HourCronExpr, ITEGATScheduler);
		System.schedule('Get ACET LINK API Access Token Half Hourly Job Test', HalfHourCronExpr, ITEGATScheduler);
        ACETGetLinkApiAccessTokenBatch.sendmail(new String[]{'test@test.com'}, 'testSubject', 'testBody');
        test.stopTest();
    }
}