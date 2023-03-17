/**
* Author: Sunil Vennam
* Description : Test class for the unit test.
* Date Created: 9/19/2019
*/
@isTest
public class ADBOpportunityControllerTest {
    
	 @testSetup static void setup() {
        // create test data for custom setting
        List<ISL_Webservice_Config__c> webUrl = new List<ISL_Webservice_Config__c>{
            new ISL_Webservice_Config__c(name='dev_ADBOppsEndPoint', value__c='https://gateway-stage.optum.com/api/stage/ben/nba-member/offers/v1/search'),
                new ISL_Webservice_Config__c(name='dev_ADBSaveLeadInteractions', value__c='https://gateway-stage.optum.com/api/stage/ben/nba-member/dispositions/v1'),
                new ISL_Webservice_Config__c(name='dev_ADBICUEEngagementEducation', value__c='https://icue.uhc.com/icue/engagementEducation.uhg'),
                new ISL_Webservice_Config__c(name='dev_EligibilityelinkService', value__c='	https://api-gateway-stage.linkhealth.com/elink-services/api/eligibility/v2.0'),
                new ISL_Webservice_Config__c(name='dev_ADBICUEEngagementHeader', value__c='https://icue.uhc.com/icue/engagementHeader.uhg'),
                new ISL_Webservice_Config__c(name='dev_LinkEligibilityAPI', value__c='https://api-gateway-stage.linkhealth.com/elink-services/api/eligibility/v2.0'),
                new ISL_Webservice_Config__c(name='dev_LinkExtendedCoverageAPI', value__c='https://api-gateway-stage.linkhealth.com/elink-extended/api/coverageAttributes/v2.0')
                
                };
                    insert webUrl;
        // create test data for custom setting
        List<WebserviceConfigurations__c> configs = new List<WebserviceConfigurations__c>{
            new WebserviceConfigurations__c(Name = 'ADBFunctionalRoleEndpoint',recordtypeText__c = 'Token_API',Method__c = 'POST',Timeout__c = 10000),
                new WebserviceConfigurations__c(Name = 'LinkEligibilityMemberSearch',recordtypeText__c = 'Token_API', Method__c = 'POST', Timeout__c = 10000),
                new WebserviceConfigurations__c(Name = 'LinkExtendedCoverage',recordtypeText__c = 'Token_API', Method__c = 'POST', Timeout__c = 10000),
                new WebserviceConfigurations__c(Name = 'ADBOpportunityService',recordtypeText__c = 'Token_API', Method__c = 'POST', Timeout__c = 10000)
                };                
                    insert configs;
        
        String baseUrl = 'https://gateway-stage.optum.com'; 
        List<OrgSpecificConfigurations__c> orgConfigs = new List<OrgSpecificConfigurations__c>{
            new OrgSpecificConfigurations__c(WebserviceConfigurations__c = configs[0].Id,recordtypeText__c = 'TokenAPI',Name = 'QA',EndpointDomain__c = 'https://gateway-stage.optum.com/api/bravo/clin/icue/member-details/v2/getUserDetails'),
                new OrgSpecificConfigurations__c(WebserviceConfigurations__c = configs[1].Id,recordtypeText__c = 'TokenAPI', Name = 'QA', EndpointDomain__c = baseUrl+'/api/bravo/clin/icue/memberdetails/v2.0/getMemberContactsBySourceID'),
                new OrgSpecificConfigurations__c(WebserviceConfigurations__c = configs[2].Id,recordtypeText__c = 'TokenAPI', Name = 'QA', EndpointDomain__c = 'https://api-gateway-stage.linkhealth.com/elink-services/api/eligibility/v2.0'),
                new OrgSpecificConfigurations__c(WebserviceConfigurations__c = configs[3].Id,recordtypeText__c = 'TokenAPI', Name = 'QA', EndpointDomain__c = 'https://gateway-stage.optum.com/api/stage/ben/nba-member/offers/v1/search')
                
                };
                    insert orgConfigs;
        Organization_Properties__c property = new Organization_Properties__c(OrganizationName__c = 'QA');
        insert property;
    }
	
    @isTest static void testADBACETOpportunityController() {        
        String memberId = '085624450';
        test.startTest();
        StaticResourceCalloutMock mock = new StaticResourceCalloutMock();
        mock.setStaticResource('ADBOppContrTestData');
        mock.setStatusCode(200);
        // Set the mock callout mode
        Test.setMock(HttpCalloutMock.class, mock);
        ISL_Webservice_Config__c web = [SELECT id, name, value__c from ISL_Webservice_Config__c LIMIT 1];
        system.assertEquals(true, web.Value__c != null);
        // Call the method that performs the callout 
        String memberTypeId = 'CDB_XREF_ID'; 
        integer noOfOffers = 10;
        string roleType = 'CN|string';
        String functionRole = 'BHN';
        String userId = 'svennam3';
        ADBOpportunityController.getOpportunities(userId, memberId, memberTypeId, noOfOffers, functionRole,true);
        test.stopTest(); 
    }
    @isTest static void testADBACETOpportunityController1() {        
        String memberId = '085624450';
        test.startTest();
        // Use StaticResourceCalloutMock built-in class to
        // specify fake response and include response body 
        // in a static resource.
        StaticResourceCalloutMock mock = new StaticResourceCalloutMock();
        mock.setStatusCode(500);
        mock.setStatus('');
        // Set the mock callout mode
        Test.setMock(HttpCalloutMock.class, mock);
        // Call the method that performs the callout 
        String memberTypeId = 'CDB_XREF_ID'; 
        integer noOfOffers = 10;
        string roleType = 'CN|string';
        String functionRole = 'BHN';
		String userId = 'svennam3';
        ADBOpportunityController.getOpportunities(userId, memberId, memberTypeId, noOfOffers, functionRole,true);
        test.stopTest(); 
    }
    //  test ADBJWTGenerator specific flows which won't be tested from Opportunity web service actual business flows
    @isTest static void testADBJWTGenerator() {
        map<string,string> clms = new map<string,string>();
        clms.put('sun', 'san');        
        ADBJWTGenerator ajwtGen = new ADBJWTGenerator('HS256');
        ajwtGen.iss = '1234567890';
        ajwtGen.aud='';
        ajwtGen.cert='';
        ajwtGen.exp='';
        ajwtGen.sub='';
        ajwtGen.iat='';
        ajwtGen.pkcs8='';
        ajwtGen.claims = clms;
        //  NONE flow
        ADBJWTGenerator ajwtGen1 = new ADBJWTGenerator('NONE');
        ajwtGen1.iss = '1234567890';
        ajwtGen1.issue();        
    }
    @isTest static void testWrapperAttributes() {
        ADBOpportunity opp = new ADBOpportunity();
        opp.offerCategory = '';
        opp.callerAccept = true;
        opp.callerConsidering = true;
        opp.callerNotInterested = false;
        opp.description = 'this is a test';
        opp.descriptionHoverOver = 'hover test';
        opp.event = 'BN';
        opp.removeOpportunityComments = 'test comment';
        opp.statusCode = 200;
        opp.statusMessage = 'OK';
        opp.todo = 'to do is';
        opp.removeOpportunity = false;
        
        opp.eventDesc = 'Shoulder Pain';
        opp.statusCode = 200;
        opp.statusMessage = 'Success';                
    }
    @isTest static void testResponseWrapper() {        
        ADBOpportunitySaveResponseWrapper respW = new ADBOpportunitySaveResponseWrapper();
        respW.responseMsg='test response msg';
        respW.responseCode= String.valueOf(200);
        respW.responseDetailMsg = 'detail test msg';
        respW.todoLink = '';
        respW.redirectionUrl = '';        
    }
    // Test method for SLI service
    @isTest static void testADBACETOpportunitysaveController() {        
        String memberId = '085624450';
        ADBOpportunity offerResponseList = new ADBOpportunity();
        String evntName =  'Maybe_Later';
        test.startTest();
        StaticResourceCalloutMock mock = new StaticResourceCalloutMock();
        mock.setStaticResource('ADBOppContrTestData');
        mock.setStatusCode(200);
        // Set the mock callout mode
        Test.setMock(HttpCalloutMock.class, mock);
        String method = 'POST';
        String todoLink='DECISION_SUPPORT';
        String firstName = 'Terri';
        string lastName= 'Anderson';
        String DOB='1955-08-23';
        String userId='skollur6';
        string subscriberId = '474706605';
        String nbaParentId = '';
        String blacklistDays = '';
        String userComments ='';
        // Call the method that performs the callout        
        ADBOpportunityController.getSaveOpportunities(memberId, offerResponseList, evntName,todoLink,firstName,lastName,DOB,userId,subscriberId,nbaParentId, blacklistDays, userComments);                        
        test.stopTest(); 
    }
    @isTest static void testgetEnddatefromV2Service(){
        String memberId = '567353078';
        String memberDob = '1961-12-13';
		String firstName='PEGGY';
        String lastName='BROGAN';
        String groupNumber = '0226310';						 
        test.startTest();       
        ADBOpportunityController.launchConsumerDashboard('memberId', 'fName', 'lName', 'MM/DD/YYYY', '12233', 'SEY');
        test.stopTest();
    }
    //test ADBFunctionalRoleService if record is empty: US2620797 - sunil vennam
    @isTest static void testADBCheckAgentExists() {    
        test.startTest();
        StaticResourceCalloutMock mock = new StaticResourceCalloutMock();
        mock.setStaticResource('ADBFunctionalRoleServiceData');
        mock.setStatusCode(200);
        // Set the mock callout mode
        Test.setMock(HttpCalloutMock.class, mock);
        String userID = 'svennam3';
        String role = ADBFunctionalRoleService.checkAgentDataExists(userID);
        system.assertEquals('BHN', role);
        test.stopTest(); 
    }
    @isTest static void testFunctionRole() {    
        test.startTest();
        StaticResourceCalloutMock mock = new StaticResourceCalloutMock();
        mock.setStaticResource('ADBFunctionalRoleServiceData');
        mock.setStatusCode(200);
        // Set the mock callout mode
        Test.setMock(HttpCalloutMock.class, mock);
        String userId = 'svennam3';
        Boolean isIntegration = true;
        String role = ADBOpportunityController.getfunctionalRole(userId, isIntegration);
        system.assertEquals('BHN', role);
        test.stopTest(); 
    }
    //test ADBFunctionalRoleService if record is empty: US2620797 - sunil vennam
    @isTest static void testADBCheckAgentExistsTrue() { 
        Agent_Information__c a = new Agent_Information__c();
        a.Agent_MSID__c = 'svennam3';
        a.ICUE_Functional_Role__c = 'BHN';
        insert a;
        test.startTest();
        StaticResourceCalloutMock mock = new StaticResourceCalloutMock();
        mock.setStaticResource('ADBFunctionalRoleServiceData');
        mock.setStatusCode(200);
        // Set the mock callout mode
        Test.setMock(HttpCalloutMock.class, mock);
        String userID = 'svennam3';
        String role = ADBFunctionalRoleService.checkAgentDataExists(userID);
        system.assertEquals('BHN', role);
        test.stopTest(); 
    }
    // Test method for SLI service
    @isTest static void testADBACETOpportunitysaveController1() {        
        String memberId = '085624450';
        ADBOpportunity offerResponseList = new ADBOpportunity();
        String evntName =  'Maybe_Later';
        test.startTest();
        StaticResourceCalloutMock mock = new StaticResourceCalloutMock();
        mock.setStaticResource('ADBOppContrTestData');
        mock.setStatusCode(200);
        // Set the mock callout mode
        Test.setMock(HttpCalloutMock.class, mock);
        String todoLink='REFRESH_DASHBOARD';
        String firstName = 'Terri';
        string lastName= 'Anderson';
        String dob='1955-08-23';
        String userId='skollur6';
        string subscriberId = '474706605';
        String nbaParentId = '';
        String blacklistDays = '';
        String userComments ='';
        // Call the method that performs the callout        
        ADBOpportunityController.getSaveOpportunities(memberId, offerResponseList, evntName,todoLink,firstName,lastName,dob,userId,subscriberId,nbaParentId, blacklistDays, userComments);                        
        test.stopTest(); 
    }
    @isTest static void testgetEnddatefromV2Service1(){
        String memberId = '567353078';
        String memberDob = '1961-12-13';
		String firstName='PEGGY';
        String lastName='BROGAN';
        String groupNumber = '0226310';						 
        test.startTest();       
        ADBOpportunityController.launchConsumerDashboard('memberId', 'fName', 'lName', 'MM/DD/YYYY', '12233', 'SEY');
        test.stopTest();
    }    
    @isTest static void testFunctionRole1() {    
        test.startTest();
        StaticResourceCalloutMock mock = new StaticResourceCalloutMock();
        mock.setStaticResource('ADBFunctionalRoleServiceData');
        mock.setStatusCode(200);
        // Set the mock callout mode
        Test.setMock(HttpCalloutMock.class, mock);
        String userId = 'svennam3';
        Boolean isIntegration = false;
        ADBOpportunityController.getfunctionalRole(userId, isIntegration);
        test.stopTest(); 
    }
	
	@isTest static void testcoverWrapperFunction(){
        test.startTest();
        ADBOpportunityCardWrapper wrap = new ADBOpportunityCardWrapper();
        wrap.statusCode = 401;
        wrap.statusMessage = 'Unauthorized'; 
        wrap.responseMessage = 'Offer Information cannot be retrieved. Open a Help Desk ticket.';
        wrap.pharmacyCount = null;
        wrap.financialCount = null;
        wrap.healthCount = null;
        wrap.clinicalCount = null;
        wrap.totalCount = null;
        wrap.Role = 'BHN';
        wrap.offers = null;
        test.stopTest(); 
    }
}