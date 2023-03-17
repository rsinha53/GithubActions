@isTest
public with sharing class ACET_CreateAuthCtrlTest {

    public static final String dateValue = '2018-11-01';

     @testSetup static void testSetupMethod() {
        Organization_Properties__c orgProps = Organization_Properties__c.getOrgDefaults();
        orgProps.OrganizationName__c = 'QA';
        Upsert orgProps;

        // Token API data
        WebserviceConfigurations__c tokenAPIWSConfig = ACET_WebserviceCalloutFramework_Test.createTokenWSConfigs('LinkTokenAPI');
        OrgSpecificConfigurations__c tokenAPIOrgSpecificConfigs = ACET_WebserviceCalloutFramework_Test.createTokenOrgWSConfigs(tokenAPIWSConfig.Id);
        WebserviceConfigurations__c authTokenWSConfig = ACET_WebserviceCalloutFramework_Test.createAuthTokenWSConfig('LinkTokenAPI');

        // CPS API API data
        WebserviceConfigurations__c wsConfig = ACET_WebserviceCalloutFramework_Test.createWSConfig('CaseProvidersSearch', tokenAPIWSConfig.Id);
        OrgSpecificConfigurations__c orgSpecificConfigs = ACET_WebserviceCalloutFramework_Test.createOrgWSConfigs(wsConfig.Id);

        // VAlidation API data
        WebserviceConfigurations__c wsConfigValidation = ACET_WebserviceCalloutFramework_Test.createWSConfig('CaseSubmitValidation', tokenAPIWSConfig.Id);
        OrgSpecificConfigurations__c orgSpecificConfigsValidation = ACET_WebserviceCalloutFramework_Test.createOrgWSConfigs(wsConfigValidation.Id);

         // TTAP API data
        WebserviceConfigurations__c wsConfigTtap = ACET_WebserviceCalloutFramework_Test.createWSConfig('TTAP', tokenAPIWSConfig.Id);
        OrgSpecificConfigurations__c orgSpecificConfigsTtap = ACET_WebserviceCalloutFramework_Test.createOrgWSConfigs(wsConfigTtap.Id);

         // CaseSubmit API API data
        WebserviceConfigurations__c wsConfigCase = ACET_WebserviceCalloutFramework_Test.createWSConfig('CaseSubmitPOCA', tokenAPIWSConfig.Id);
        OrgSpecificConfigurations__c orgSpecificConfigsCase = ACET_WebserviceCalloutFramework_Test.createOrgWSConfigs(wsConfigCase.Id);

    }

    //vishu for srn Auth
    @isTest static void testCreateSRN() {
		
        StaticResourceCalloutMock mock = new StaticResourceCalloutMock();
        mock.setStaticResource('AuthSRN_Response');
        //mock.setStatusCode(200);
        mock.setHeader('Content-Type', 'application/json');
        
        // Set the mock callout mode
        Test.setMock(HttpCalloutMock.class, mock);
        StaticResource response = [SELECT Id, Body FROM StaticResource WHERE Name = 'ACET_SampleSRN_Request' LIMIT 1];
		String req=response.body.toString();//test
         ACET_CreateAuthCtrl.InvocationContext invocationContext = new ACET_CreateAuthCtrl.InvocationContext();
        invocationContext.clientID = 'ACET';
        invocationContext.locationID = 'ACET';
        invocationContext.userID = '';
        invocationContext.userIDType = '';
        invocationContext.clientCorrelationID = '';
        invocationContext.serviceCorrelationID = '';
        ACET_CreateAuthCtrl.MetadataValue metaData = new ACET_CreateAuthCtrl.MetadataValue();
        metaData.clientGroup = 'ACET';
        metaData.clientBusiness = 'ACET';
        metaData.clientLocation = '';
        metaData.clientNPI = '';
        metaData.caseSubmissionTransactionID = '';
        ACET_CreateAuthCtrl.ACET_SRNResponseWrap srnw=new ACET_CreateAuthCtrl.ACET_SRNResponseWrap();
        srnw.invocationContext = invocationContext;
        srnw.metadata=metaData;
        srnw.primaryServiceReferenceNum='A2J1234567';
        srnw.responseCode='201';
        srnw.disclaimerText=(new List<String>());
		ACET_CreateAuthCtrl.ACET_SRNResponseWrap resp=ACET_CreateAuthCtrl.createSRN(req);
		StaticResource creatAuthReq = [SELECT Id, Body FROM StaticResource WHERE Name = 'CreatAuthResp' LIMIT 1];
        String respStr = creatAuthReq.Body.toString();
        System.assertNotEquals(null, ACET_CreateAuthRequest.parse(respStr));     
			
    }

     //For Validation API json2Apex
      static testMethod void validationAPI_JSON2APEX() {
        Test.startTest();
        StaticResource response = [SELECT Id, Body FROM StaticResource WHERE Name = 'Validation_Api_MockResponse' LIMIT 1];
        String respStr = response.Body.toString();
        System.assertNotEquals(null, ACET_ValidationApiResponceJSON2Apex.parse(respStr));
        Test.stopTest();
    }

    @isTest
    static void testCaseProviderWS() {
        Test.startTest();
        Test.setMock(HttpCalloutMock.class, new ACETCaseProviderSearchWebServiceMock());
        ACET_CaseProvidersReq.HscProvider provider = new ACET_CaseProvidersReq.HscProvider();
        List<ACET_CaseProvidersReq.HscProvider> providerDetails = new List<ACET_CaseProvidersReq.HscProvider>();
        provider.address1 = '10462 SELF ST';
        provider.businessName = 'MOSENTINE';
        provider.city = 'ANYWHERE';
        provider.firstName = 'ROBERT';
        provider.lastName = 'ROSE';
        provider.middleName = 'M';
        provider.providerCategory = 'P';
        provider.providerSeqNum = 'P';
        provider.state = 'P';
        provider.zip = 'P';
        provider.zipSuffix = 'P';
        provider.providerTerminationDate = dateValue;
        provider.providerEffectiveDate = dateValue;

        providerDetails.add(provider);

        ACET_CaseProvidersReq.Member member = new ACET_CaseProvidersReq.Member();
        member.xrefIdPartitionNumber = '929394959';
        member.xrefId = 'CALEB';
        member.tciTableNumber = 'M';
        member.subscriberID = 'GALLECO';
        member.stateOfIssueCode = '0006445';
        member.sourceId = '929394959';
        member.sourceCode = '929394959';
        member.sharedArrangementCode = '929394959';
        member.reportingCode = '929394959';
        member.productCode = '929394959';
        member.policyNumber = '929394959';
        member.platform = '929394959';
        member.obligorID = '929394959';
        member.middleName = '929394959';
        member.memberID = '929394959';
        member.mbi = '929394959';
        member.marketType = '929394959';
        member.marketSite = '929394959';
        member.lineOfBusiness = '929394959';
        member.lastName = '929394959';
        member.individualIdentifier = '929394959';
        member.groupPanelNumber = '929394959';
        member.governmentProgramCode = '929394959';
        member.genderCode = '929394959';
        member.firstName = '929394959';
        member.effectiveStartDate = dateValue;
        member.effectiveEndDate = dateValue;
        member.dob = dateValue;
        member.databaseMemberId = '929394959';
        member.coverageTypeCode = '929394959';
        member.cosmosDivision = '929394959';
        member.claimSourceSystemCode = '929394959';
        member.cirrusMCHID = '929394959';
        member.alternateId = '929394959';


        ACET_CreateAuthCtrl.ACET_CaseProviderSearchResponseWrapper response = ACET_CreateAuthCtrl.callCaseProviderSearch(providerDetails,member);
        System.assertNotEquals(null, response);
        Test.stopTest();
    }

    //For CPS Res
      static testMethod void cspRes() {
        Test.startTest();
        StaticResource response = [SELECT Id, Body FROM StaticResource WHERE Name = 'ACET_CPS_MockResponse' LIMIT 1];
        String respStr = response.Body.toString();
        System.assertNotEquals(null, ACET_CaseProvidersResp.parse(respStr));
        Test.stopTest();
    }




    @isTest
    static void testCreateAuthorizaton() {
        Test.startTest();
        Test.setMock(HttpCalloutMock.class, new ACETCaseSubmitApiMock());
        ACET_CreateAuthorizationRequest.CaseDetails caseDetails = new ACET_CreateAuthorizationRequest.CaseDetails();
        ACET_CreateAuthorizationRequest.HscProvider provider = new ACET_CreateAuthorizationRequest.HscProvider();
        ACET_CreateAuthorizationRequest.HscProviders providers = new ACET_CreateAuthorizationRequest.HscProviders();

        List<ACET_CreateAuthorizationRequest.HscProvider> providerDetails = new List<ACET_CreateAuthorizationRequest.HscProvider>();
        provider.address1 = '10462 SELF ST';
        provider.businessName = 'MOSENTINE';
        provider.city = 'ANYWHERE';
        provider.firstName = 'ROBERT';
        provider.lastName = 'ROSE';
        provider.middleName = 'M';
        provider.providerCategory = 'P';
        provider.state = 'P';
        provider.zip = 'P';
        provider.zipSuffix = 'P';


        ACET_CreateAuthorizationRequest.ProviderRole roleObj = new ACET_CreateAuthorizationRequest.ProviderRole();
        ACET_CreateAuthorizationRequest.ProviderRoles providerRoles = new ACET_CreateAuthorizationRequest.ProviderRoles();

        List<ACET_CreateAuthorizationRequest.ProviderRole> roles = new List<ACET_CreateAuthorizationRequest.ProviderRole>();
        roleObj.providerRole = 'SJ';
        roles.add(roleObj);
        providerRoles.providerRole = roles;
        provider.providerRoles = providerRoles;
        providerDetails.add(provider);
        providers.hscProvider = providerDetails;
        caseDetails.hscProviders = providers;

        StaticResource res = [SELECT Id, Body FROM StaticResource WHERE Name = 'ACET_CreateAuthSampleSrnData' LIMIT 1];
        String srnData = res.Body.toString();

        ACET_CreateAuthCtrl.ACET_SRNResponseWrap response = ACET_CreateAuthCtrl.createAuthorization(srnData,caseDetails);
        System.assertNotEquals(null, response);
        Test.stopTest();
    }



    public class ACETCaseProviderSearchWebServiceMock implements HttpCalloutMock{
        public HTTPResponse respond(HTTPRequest request) {
            	HttpResponse response = new HttpResponse();
                response.setHeader('Endpoint', 'https://gateway.optum.com/api/clin/emrpa/authorizations/v3/case-providers/search');
                response.setHeader('Method', 'POST');
                response.setBody(SAETestDataFactory.getStaticResourceResponse('ACET_CPS_MockResponse'));
                response.setStatusCode(200);
                return response;
        }
    }

    public class ACETCaseSubmitApiMock implements HttpCalloutMock{
        public HTTPResponse respond(HTTPRequest request) {
            	HttpResponse response = new HttpResponse();
                response.setHeader('Endpoint', 'https://gateway.optum.com/api/clin/emrpa/authorizations/v3/case-providers/search');
                response.setHeader('Method', 'POST');
                response.setBody(SAETestDataFactory.getStaticResourceResponse('CreatAuthResp'));
                response.setStatusCode(200);
                return response;
        }
    }


}