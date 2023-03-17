@isTest(SeeAllData=false)
public class ACETGetAccessTokenSchedulerTest {
    public static testMethod void ACETGetAccessTokenSchedulerTest1() {
        Map<String, String> TestISLWSConfigs = new Map<String, String>(); 
        TestISLWSConfigs.put('ISLOAuthContentType', 'application/x-www-form-urlencoded');
        TestISLWSConfigs.put('ISLOAuthGrantType', 'client_credentials');
        TestISLWSConfigs.put('ISLConAccessToken', 'Test');
        TestISLWSConfigs.put('dev_ISLOAuthClientId', 'TestClientId');
        TestISLWSConfigs.put('dev_ISLOAuthClientSecret', 'TestClientSecret');
        TestISLWSConfigs.put('OILTimeout', '3000');
        TestISLWSConfigs.put('dev_ISLOAuthTokenEndpoint', 'https://api-stg.optum.com:8443');
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
        
        ACETGetAccessTokenScheduler ACETGATScheduler = new ACETGetAccessTokenScheduler();
        String HourCronExpr = '0 0 * * * ?';
        String HalfHourCronExpr = '0 30 * * * ?';
        System.schedule('Test ACET Get Access Token Hourly Job', HourCronExpr, ACETGATScheduler);
        System.schedule('Test ACET Get Access Token Half Hourly Job', HalfHourCronExpr, ACETGATScheduler);
        
        test.stopTest();
    }
    public static testMethod void ACETGetAccessTokenSchedulerTest3() {
        Map<String, String> TestISLWSConfigs = new Map<String, String>(); 
        TestISLWSConfigs.put('ISLOAuthContentType', 'application/x-www-form-urlencoded');
        TestISLWSConfigs.put('ISLOAuthGrantType', 'client_credentials');
        TestISLWSConfigs.put('dev_StargateOAuthClientId', 'TestClientIdCISL');
        TestISLWSConfigs.put('StargateConAccessToken', 'Test1');
        TestISLWSConfigs.put('dev_StargateOAuthClientSecret', 'TestClientSecretCISL');
        TestISLWSConfigs.put('StargateTimeout', '3000');
        TestISLWSConfigs.put('dev_StargateOAuthTokenEndpoint', 'https://gateway-stage.optum.com');
        List<ISL_Webservice_Config__c> lstISLWSConfigs = ACETTestDataUtility.CreateISLWebserviceConfigurations(TestISLWSConfigs);
        insert lstISLWSConfigs;
        
        String ResponseJSON = '{"token_type": "bearer","access_token": "6zT64yQi2vWeVoozf3Y2cvSN9k4swpEW","expires_in": 3600}';
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
    public static testMethod void ACETGetAccessTokenSchedulerTest4() {
        Map<String, String> TestISLWSConfigs = new Map<String, String>(); 
        TestISLWSConfigs.put('ISLOAuthContentType', 'application/x-www-form-urlencoded');
        TestISLWSConfigs.put('ISLOAuthGrantType', 'client_credentials');
        TestISLWSConfigs.put('dev_StargateOAuthClientId', 'TestClientIdCISL');
        TestISLWSConfigs.put('StargateORXConAccessToken', 'Test1');
        TestISLWSConfigs.put('dev_StargateOAuthClientSecret', 'TestClientSecretCISL');
        TestISLWSConfigs.put('StargateTimeout', '3000');
        TestISLWSConfigs.put('dev_StargateORXOAuthTokenEndpoint', 'https://orxapi-stage.optum.com');
        List<ISL_Webservice_Config__c> lstISLWSConfigs = ACETTestDataUtility.CreateISLWebserviceConfigurations(TestISLWSConfigs);
        insert lstISLWSConfigs;
        
        String ResponseJSON = '{"token_type": "bearer","access_token": "6zT64yQi2vWeVoozf3Y2cvSN9k4swpEW","expires_in": 3600}';
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
    public static testMethod void ACETGetAccessTokenSchedulerTest5() {
        /*Map<String, String> TestISLWSConfigs = new Map<String, String>(); 
        TestISLWSConfigs.put('ISLOAuthContentType', 'application/x-www-form-urlencoded');
        TestISLWSConfigs.put('ISLOAuthGrantType', 'client_credentials');
        TestISLWSConfigs.put('dev_StargateOAuthClientId', 'TestClientIdCISL');
        TestISLWSConfigs.put('StargateORXConAccessToken', 'Test1');
        TestISLWSConfigs.put('dev_StargateOAuthClientSecret', 'TestClientSecretCISL');
        TestISLWSConfigs.put('StargateTimeout', '3000');
        TestISLWSConfigs.put('dev_StargateORXOAuthTokenEndpoint', 'https://orxapi-stage.optum.com');
        List<ISL_Webservice_Config__c> lstISLWSConfigs = ACETTestDataUtility.CreateISLWebserviceConfigurations(TestISLWSConfigs);
        insert lstISLWSConfigs;
        
        String ResponseJSON = '{"token_type": "bearer","access_token": "6zT64yQi2vWeVoozf3Y2cvSN9k4swpEW","expires_in": 3600}';
        MockHttpCalloutResponseGenerator.MockHttpResponse OILTestResponse = new MockHttpCalloutResponseGenerator.MockHttpResponse(200, 'OK', ResponseJSON);
        OILTestResponse.TokenExpired = false;
        
        test.startTest();
        
        MockHttpCalloutResponseGenerator MockHttpResponse = new MockHttpCalloutResponseGenerator(null, OILTestResponse);
        Test.setMock(HttpCalloutMock.class, MockHttpResponse);*/
        
        ACETGetAccessTokenScheduler ACETGATScheduler = new ACETGetAccessTokenScheduler();
        String HourCronExpr = '0 0 * * * ?';
        String HalfHourCronExpr = '0 30 * * * ?';
        System.schedule('Test ACET Get Access Token Hourly Job', HourCronExpr, ACETGATScheduler);
        System.schedule('Test ACET Get Access Token Half Hourly Job', HalfHourCronExpr, ACETGATScheduler);
        ACETGetAccessTokenBatch actB = new ACETGetAccessTokenBatch();
        database.executeBatch(actB,10);
        //test.stopTest();
    }
}