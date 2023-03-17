@isTest
global class ACET_WebserviceCalloutFramework_Test {

    public static WebserviceConfigurations__c createTokenWSConfigs (String serviceName) {
        WebserviceConfigurations__c tokenAPIWSConfig = new WebserviceConfigurations__c(
            Name = serviceName,
            RecordTypeId = Schema.SObjectType.WebserviceConfigurations__c.getRecordTypeInfosByName().get('Token API').getRecordTypeId(),
            Method__c = 'POST',
            Headers__c = '[{"key":"Content-Type","value":"application/x-www-form-urlencoded"}]',
            EndpointPath__c = '/testpath',
            AuthorizationToken__c = '',
            GrantType__c = 'client_credentials',
            Timeout__c = 1000
        );
        Insert tokenAPIWSConfig;
        return tokenAPIWSConfig;
    }

    public static OrgSpecificConfigurations__c createTokenOrgWSConfigs (Id wsConfigId) {
        OrgSpecificConfigurations__c tokenAPIOrgSpecificConfigs = new OrgSpecificConfigurations__c(
            WebserviceConfigurations__c = wsConfigId,
            Name = 'QA',
            RecordTypeId = Schema.SObjectType.OrgSpecificConfigurations__c.getRecordTypeInfosByName().get('Token API').getRecordTypeId(),
            EndpointDomain__c = 'https://www.test.com',
            EnableLogs__c = 'All Logs'
        );
        Insert tokenAPIOrgSpecificConfigs;
        return tokenAPIOrgSpecificConfigs;
    }

    public static WebserviceConfigurations__c createAuthTokenWSConfig (String serviceName) {
        WebserviceConfigurations__c authTokenWSConfig = new WebserviceConfigurations__c(
            Name = serviceName + 'Token',
            RecordTypeId = Schema.SObjectType.WebserviceConfigurations__c.getRecordTypeInfosByName().get('Authorization Token').getRecordTypeId(),
            AuthorizationToken__c = 'testToken'
        );
        Insert authTokenWSConfig;
        return authTokenWSConfig;
    }
    
    public static WebserviceConfigurations__c createJwtTokenWSConfig (String serviceName) {
        WebserviceConfigurations__c jwtTokenWSConfig = new WebserviceConfigurations__c(
            Name = serviceName + 'Token',
            RecordTypeId = Schema.SObjectType.WebserviceConfigurations__c.getRecordTypeInfosByName().get('Token API').getRecordTypeId(),
            AuthorizationToken__c = 'testToken',
            Is_JWT_Token__c = true
        );
        Insert jwtTokenWSConfig;
        return jwtTokenWSConfig;
    }
    
    public static WebserviceConfigurations__c createWSConfig (String serviceName, Id authTokenWSConfigId) {
        WebserviceConfigurations__c wsConfig = new WebserviceConfigurations__c(
            Name = serviceName,
            RecordTypeId = Schema.SObjectType.WebserviceConfigurations__c.getRecordTypeInfosByName().get('Service API').getRecordTypeId(),
            Method__c = 'POST',
            Headers__c = '[{"key":"Authorization","value":"Bearer AUTH_TOKEN"},{"key":"Content-Type","value":"application/x-www-form-urlencoded"},{"key":"Accept","value":"application/json"}]',
            EndpointPath__c = '/testpath',
            Timeout__c = 1000,
            ProfileOrgMappings__c='{"Provider Service":"qa","System Administrator":"stg"}',            
            TokenAPI__c = authTokenWSConfigId
        );
        Insert wsConfig;
        return wsConfig;
    }

    public static OrgSpecificConfigurations__c createOrgWSConfigsByOrg (Id wsConfigId, String orgName) {
        OrgSpecificConfigurations__c orgSpecificConfigs = new OrgSpecificConfigurations__c(
            WebserviceConfigurations__c = wsConfigId,
            Name = orgName,
            RecordTypeId = Schema.SObjectType.OrgSpecificConfigurations__c.getRecordTypeInfosByName().get('Service API').getRecordTypeId(),
            EndpointDomain__c = 'https://www.test.com',
            EnableLogs__c = 'All Logs'
        );
        Insert orgSpecificConfigs;
        return orgSpecificConfigs;
    }
    
    public static OrgSpecificConfigurations__c createOrgWSConfigs (Id wsConfigId) {
        OrgSpecificConfigurations__c orgSpecificConfigs = new OrgSpecificConfigurations__c(
            WebserviceConfigurations__c = wsConfigId,
            Name = 'QA',
            RecordTypeId = Schema.SObjectType.OrgSpecificConfigurations__c.getRecordTypeInfosByName().get('Service API').getRecordTypeId(),
            EndpointDomain__c = 'https://www.test.com',
            EnableLogs__c = 'All Logs'
        );
        Insert orgSpecificConfigs;
        return orgSpecificConfigs;
    }

    @testSetup static void testSetupMethod() {
        Organization_Properties__c orgProps = Organization_Properties__c.getOrgDefaults();
        orgProps.OrganizationName__c = 'QA';
        orgProps.EnableProfileBasedEndpoint__c = true;
        Upsert orgProps;
        // Token API data
        WebserviceConfigurations__c tokenAPIWSConfig = createTokenWSConfigs('StarGateTokenAPI');
        OrgSpecificConfigurations__c tokenAPIOrgSpecificConfigs = createTokenOrgWSConfigs(tokenAPIWSConfig.Id);
        WebserviceConfigurations__c authTokenWSConfig = createAuthTokenWSConfig('StarGateTokenAPI');
        WebserviceConfigurations__c jwtTokenWSConfig = createJwtTokenWSConfig('StarGateTokenAPI');
        // Service API data
        WebserviceConfigurations__c wsConfig = createWSConfig('StarGateProviderSearch', tokenAPIWSConfig.Id);
        OrgSpecificConfigurations__c orgSpecificConfigs = createOrgWSConfigsByOrg(wsConfig.Id,'QA');
        OrgSpecificConfigurations__c orgSpecificConfigsSTG = createOrgWSConfigsByOrg(wsConfig.Id,'stg');
    }
    
    @isTest static void getAuthToken_Test() {
        Test.startTest();
        Test.setMock(HttpCalloutMock.class, new WebservicecalloutFrameworkMock(200));
        ACET_WebserviceCalloutFramework wsCallOut = new ACET_WebserviceCalloutFramework();
        Set<String> tokenAPINames = new Set<String>();
        tokenAPINames.add('StarGateTokenAPI');
        wsCallOut.getAuthToken(tokenAPINames);

        // Authorization exception
        Test.setMock(HttpCalloutMock.class, new WebservicecalloutFrameworkMock(401));
        wsCallOut.getAuthToken(tokenAPINames);

        Test.stopTest();
    }

    @isTest static void getResponse_Test() {
        Test.startTest();
        Test.setMock(HttpCalloutMock.class, new WebservicecalloutFrameworkMock(401));
        ACET_WebserviceCalloutFramework wsCallOutFW = new ACET_WebserviceCalloutFramework();
        wsCallOutFW.serviceName = 'StarGateProviderSearch';
        Map<String, String> requestParamsMap = new Map<String, String>();
        requestParamsMap.put('q', 'test');
        wsCallOutFW.requestParamsMap = requestParamsMap;
        HttpResponse httpResponse = wsCallOutFW.getResponse();

        // Authorization exception
        Test.setMock(HttpCalloutMock.class, new WebservicecalloutFrameworkMock(401));
        wsCallOutFW.serviceName = 'StarGateProviderSearch';
        wsCallOutFW.requestParamsMap = requestParamsMap;
        HttpResponse httpResponse2 = wsCallOutFW.getResponse();
        Test.stopTest();
    }

    global class WebservicecalloutFrameworkMock implements HttpCalloutMock {
        public Integer statusCode;
        
        public WebservicecalloutFrameworkMock(Integer statusCode) {
            this.statusCode = statusCode;
        }
        global HTTPResponse respond(HTTPRequest request) {
            HttpResponse response = new HttpResponse();
            response.setHeader('Content-Type', 'application/json');
            response.setBody('{"att1": "1"}');
            response.setStatusCode(statusCode);
            response.setStatus('status');
            return response; 
        }
    }
    //this method is to cover the mock class _Vishnu
    @isTest static void getMock() {
      	Map<String,String> requestParamsMapVal = new Map<String,String>{'searchOption' => 'MemberIDDateOfBirth',
                                                'memberId' => '929394959',
                                                'firstName' => 'CALEB',
                                                'lastName' => 'GALLECO',
                                                'groupNumber' => '',
                                                'dateOfBirth' => '1960-01-02',
                                                'transactionId'=>'123qawerfvcdrtyhbwefghjhgfdfghjkjhgfddfghjklkjhgfdssdfvc',
                                                'claimNumber'=>'12345678',
                                                'tin'=>'123456',
                                                'unet-contract-id'=>'UNTS_123'
            								};
    	Map<String, Object> wsConfigMap=new Map<String, Object>();
        List<String> serviceNameList=new List<String>{'LinkEligibilityMemberSearch','LinkExtendedCoverage','LinkClaimSearch','LinkClaimSearchByMember','LinkTimelyFiling','LinkContractorID','LinkClaimDetail'};

        Test.startTest();
        WebserviceConfigurations__c tokenAPIWSConfig = createTokenWSConfigs('LinkEligibilityMemberSearch');
        Mock_Response_Details__c mocResData=new Mock_Response_Details__c();
        mocResData.FileName__c='Eligibility_V2_CalebGalleco';
        mocResData.SearchParameter__c='929394959_1960-01-02';
        mocResData.Status_Code__c='200';
        mocResData.WebserviceConfigurations__c=tokenAPIWSConfig.id;
        Insert mocResData;
                for(String str:serviceNameList)
                {
                    HttpResponse res=ACET_WebserviceMockFramework.getMockResponse(str,requestParamsMapVal,'',wsConfigMap);
                    System.assert(res.getStatusCode()!=null);
                    if(str=='LinkEligibilityMemberSearch')
                    {
                        System.assert(res.getBody()!=null);
                    }
                }
        Test.stopTest();
    }
    @isTest static void ACET_GetCachedAuthTokensBatchn_Test() {
        Test.startTest();
        Test.setMock(HttpCalloutMock.class, new WebservicecalloutFrameworkMock(200));
		Set < String > orgList = new Set < String > ();
		Map<String, HttpResponse> mapWSOrgHttpRes;
		Map<String, set<String>> mWSOrgList = new Map<String, set<String>>();
		mWSOrgList.put('StarGateTokenAPI',orgList);
        System.scheduleBatch(new ACET_GetCachedAuthTokensBatch(mWSOrgList,false), 'Access Token Job', 1, 1);

        Test.stopTest();
    }
    @isTest static void ACET_GetJWTToken_Test() {
        Test.startTest();
        Test.setMock(HttpCalloutMock.class, new WebservicecalloutFrameworkMock(200));
        ACET_WebserviceCalloutFramework wsCallOut = new ACET_WebserviceCalloutFramework();
        Set<String> tokenAPINames = new Set<String>();
        tokenAPINames.add('StargateJWTTokenAPI');
        wsCallOut.getjwToken(tokenAPINames);
        // Authorization exception
        Test.setMock(HttpCalloutMock.class, new WebservicecalloutFrameworkMock(401));
        wsCallOut.getjwToken(tokenAPINames);
        
        Test.stopTest();
    }
    @isTest static void ACET_GetAuthJWTTokenBatchScheduler_Test() {
        Test.startTest();
        WebserviceConfigurations__c wb = new WebserviceConfigurations__c();
        wb.name = 'StargateDashboardJWTTokenAPI';
        wb.RecordTypeText__c  = 'Token_API';
        insert wb;
        Test.setMock(HttpCalloutMock.class, new WebservicecalloutFrameworkMock(200));
        ACET_GetAuthJWTTokenBatchScheduler jwtScheduler = new ACET_GetAuthJWTTokenBatchScheduler(); 
        String sch ='0 30 * * * ?'; 
        System.schedule('Schedule to run jwt token', sch,jwtScheduler);
        Test.stopTest();
    }

    @isTest static void validateResponse_html_Test() {
        HttpResponse res = new HttpResponse();
        res.setHeader('Content-Type', 'application/json');
        res.setBody('<html><head></head><body><h1>ORS Create issue microservice</h1></body></html>');
        res.setStatusCode(200);
        ACET_WebserviceCalloutFramework.validateResponse(res,'ORSCreateIssueMicroService');
    }

    @isTest static void validateResponse_JSON_Test() {
        HttpResponse res = new HttpResponse();
        //res.setHeader('Content-Type', 'application/json');
        res.setBody('{"meta":{"warnings":[]},"data":{"createIssueOutput"{"contactId":"D02731018067671","issueId":"D02731018067671"}}}');
        res.setStatusCode(200);
        ACET_WebserviceCalloutFramework.validateResponse(res,'ORSCreateIssueMicroService');
    }
}