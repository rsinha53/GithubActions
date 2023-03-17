/*
 * @Desc: US2974834 - Test Class for ACET_BenefitCheckController  
 * @Date: 06-01-2021
 * @Dev: Kavinda
 */
@isTest
public with sharing class ACET_BenefitCheckControllerTest {

    @testSetup
    static void setupData() {
        // this is to add token for testing  (SAE_ProviderCardCtrl.getAuthToken())
        ISL_Webservice_Config__c islWebserviceConfig = new ISL_Webservice_Config__c();
        islWebserviceConfig.Name = 'SNIAPIAccessToken';
        islWebserviceConfig.Value__c = 'i9AvxmVh9vBMfvkOCBfIfG45y3Nb07vT';
        insert islWebserviceConfig;

        // US3314837

        Organization_Properties__c orgProps = Organization_Properties__c.getOrgDefaults();
        orgProps.OrganizationName__c = 'QA';
        Upsert orgProps;

        // Token API data
        WebserviceConfigurations__c tokenAPIWSConfig = ACET_WebserviceCalloutFramework_Test.createTokenWSConfigs('LinkPriorAuthInquiry');
        OrgSpecificConfigurations__c tokenAPIOrgSpecificConfigs = ACET_WebserviceCalloutFramework_Test.createTokenOrgWSConfigs(tokenAPIWSConfig.Id);


        WebserviceConfigurations__c  webConRelatedDocuments = new WebserviceConfigurations__c ();
        webConRelatedDocuments.GrantType__c  = 'client_credentials';
        webConRelatedDocuments.Headers__c  = '[{"key":"Authorization","value":"Bearer <:AUTH_TOKEN:>"},{"key":"Content-Type","value":"application/json"},{"key":"actor","value":"ACET"}]';
        webConRelatedDocuments.Method__c  = 'GET';
        webConRelatedDocuments.Name  = 'LinkPriorAuthInquiry';
        webConRelatedDocuments.Timeout__c = 10000;
        RecordType recTypeWebExtendedServiceAPI = [SELECT Id FROM RecordType WHERE DeveloperName = 'Service_API' and SObjectType = 'WebserviceConfigurations__c'];
        webConRelatedDocuments.RecordTypeId  = recTypeWebExtendedServiceAPI.id;
        INSERT webConRelatedDocuments;

        Mock_Response_Details__c mockResponseRec = new Mock_Response_Details__c();
        mockResponseRec.Status_Code__c='200';
        mockResponseRec.FileName__c='PriorAuth_Response';
        mockResponseRec.SearchParameter__c='999999999_11000_K21.01';
        mockResponseRec.WebserviceConfigurations__c = webConRelatedDocuments.Id;
        INSERT mockResponseRec;

    }

    @isTest static void testBenefitCheck() {
        
        StaticResourceCalloutMock mock = new StaticResourceCalloutMock();
        mock.setStaticResource('ACET_BenefitCheck_Response');
        mock.setStatusCode(200);
        mock.setHeader('Content-Type', 'application/json');
        Test.setMock(HttpCalloutMock.class, mock);
        StaticResource response = [SELECT Id, Body FROM StaticResource WHERE Name = 'ACET_BenefitCheck_Request' LIMIT 1];
        ACET_BenefitCheckController.BenefitResultWrapper benefitResp = ACET_BenefitCheckController.benefitCheck(response.body.toString());	
        System.assertNotEquals(null, benefitResp);  
        SAEPolicyDetailsController.RCEDResponseWrap res =  SAEPolicyDetailsController.call_RCED_API('380984646','05F7360','CS');
        ACET_BenefitCheckController.getRCEDres('380984646','05F7360','CS');
        // ACET_BenefitCheckController.getPriorAuthInquiryRes('{"procedureCodes":"11000","diagnosisCode":"K21.01","taxIdNumber":"999999999","stateOfIssueCode":"IA","planTypeCode":"HN"}');

    }

    @isTest
    static void test_get_RCED_MockData() {
        String searchparameter = 'test';
        HttpResponse response = SAEUtils.getResponse(searchparameter);
        SAEPolicyDetailsController.get_RCED_MockData(response);
        response.setStatusCode(200);
        response.setBody('{}');
        SAEPolicyDetailsController.get_RCED_MockData(response);
        response.setBody('{"readResult":{"readOutput":{"eligibilities":[]}}}');
        SAEPolicyDetailsController.get_RCED_MockData(response);
        response.setBody('{"readResult":{"readOutput":{"eligibilities":[{"subscriberDetail":{"eligibility":{"demographics":{"cesCustomerName":""}}},"vendors":[]}]}}}');
        SAEPolicyDetailsController.get_RCED_MockData(response);
        response.setBody('');
        response.setStatusCode(404);
        SAEPolicyDetailsController.get_RCED_MockData(response);
        response.setBody('');
        response.setStatusCode(400);
        SAEPolicyDetailsController.get_RCED_MockData(response);
    }

    @isTest
    static void testGetAllContractsData() {
        System.runAs(ACET_TestDataFactory.getUser('Provider Service')) {
            Test.startTest();
            ACET_BenefitCheckController.ConditionType cond=new ACET_BenefitCheckController.ConditionType();
            cond.conditionName='Sample';
            cond.conditionDetail='Sample';

            ACET_BenefitCheckController.SiteOfService sso=new ACET_BenefitCheckController.SiteOfService();
            sso.decisionCode='Sample';
            sso.decisionDescription='Sample';
            sso.siteOfServiceType='Sample';
            sso.siteOfServiceDescription='Sample';

            StaticResourceCalloutMock mock = new StaticResourceCalloutMock();
            mock.setStaticResource('ACET_ProviderContractSummary_getAllContractsResponse');
            mock.setStatusCode(200);
            mock.setHeader('Content-Type', 'application/x-www-form-urlencoded');
            mock.setHeader('Accept', 'application/json');
            Test.setMock(HttpCalloutMock.class, mock);
            ACET_BenefitCheckController.getPESres('000012763', '131623978', '001663941');
            mock.setStaticResource('ACET_ProviderContractSummary_EmptyResponse');
            Test.setMock(HttpCalloutMock.class, mock);
            ACET_BenefitCheckController.getPESres('000012763', '131623978', '001663941');
            Test.stopTest();
        }
    }

    // US3314837
    @isTest static void testGetPriorAuthInquiry() {
        StaticResourceCalloutMock mock = new StaticResourceCalloutMock();
        mock.setStaticResource('ACET_BenefitCheck_Response');
        mock.setStatusCode(200);
        mock.setHeader('Content-Type', 'application/json');
        Test.setMock(HttpCalloutMock.class, mock);
        StaticResource req = [SELECT Id, Body FROM StaticResource WHERE Name = 'ACET_Benefit_PriorAuth_Request' LIMIT 1];
        Object obj = ACET_BenefitCheckController.getPriorAuthInquiry(req.body.toString());
        System.assertNotEquals(null, obj);
    }

    // US3314837
    @isTest static void testGeneratePriorAuthInquiryResponse() {
        Map<String, Object> priorAuthMap = (Map<String, Object>)JSON.deserializeUntyped('{"codesMap":"{\\"K21.01\\":\\"11000,\\"}","taxIdNumber":"\\"999999999\\"","stateOfIssueCode":"IA","planTypeCode":"HN"}');
        Map<String, Object> codesMap = (Map<String, Object>)JSON.deserializeUntyped(String.valueOf(priorAuthMap.get('codesMap')));
        List<String> lstKeys = new List<String>(codesMap.keySet());
        ACET_WebserviceCalloutFramework wsCallOutFW = ACET_BenefitCheckController.generatePriorAuthInquiryRequests(priorAuthMap, codesMap, lstKeys, 0);
        HttpResponse response = ACET_WebserviceMockFramework.getMockResponse(wsCallOutFW.serviceName, wsCallOutFW.requestParamsMap, '', null);
        response.setStatusCode(200);
        Object obj = ACET_BenefitCheckController.generatePriorAuthInquiryResponse(response, wsCallOutFW, 1);
        response.setStatusCode(500);
        obj = ACET_BenefitCheckController.generatePriorAuthInquiryResponse(response, wsCallOutFW, 1);
        System.assertNotEquals(null, obj);
    }

    @isTest static void testCheckWrappers() {
        ACET_BenefitCheckController.PriorAuthInquiryWrap wrap1 = new ACET_BenefitCheckController.PriorAuthInquiryWrap();
        wrap1.disclaimerText = 'Test';
        wrap1.preliminaryDetermination = null;
        System.assertNotEquals(null, wrap1);
        ACET_BenefitCheckController.PreliminaryDetermination wrap2 = new ACET_BenefitCheckController.PreliminaryDetermination();
        wrap2.decisionSummaryText = 'Test';
        wrap2.procedureCode = 'Test';
        wrap2.siteOfService = null;
        System.assertNotEquals(null, wrap2);
        ACET_BenefitCheckController.SiteOfService wrap3 = new ACET_BenefitCheckController.SiteOfService();
        wrap3.conditionType = null;
        System.assertNotEquals(null, wrap3);
        ACET_BenefitCheckResponseWrap wrap4 = new ACET_BenefitCheckResponseWrap();
        List<ACET_BenefitCheckResponseWrap.ServiceLines> lstSerLines = new  List<ACET_BenefitCheckResponseWrap.ServiceLines>();
        ACET_BenefitCheckResponseWrap.ServiceLines serLines = new ACET_BenefitCheckResponseWrap.ServiceLines();
        serLines.procedureCode = 'PA';
        serLines.status = 'PA';
        serLines.reasonCode = 'PA';
        serLines.procedureIndex = '1';
        lstSerLines.add(serLines);
        wrap4.serviceLines = lstSerLines;
        wrap4.serviceStatusCode = 'PA';
        wrap4.serviceStatusDescription = 'PA-DESC';
        wrap4.rtaID = 'PA';
        wrap4.transID = 'PA';
        wrap4.icn = 'PA';
        System.assertNotEquals(null, wrap4);
        System.assertNotEquals(null, serLines);
    }

    @isTest static void testProcessResponse() {
        System.assertNotEquals(null, ACET_BenefitCheckController.processResponse(new List<String>(), null));
    }

    @isTest static void getKLDataTest() {
        List<KL_Data__c> KLList = new List<KL_Data__c>();
        KLList.add(new KL_Data__c(Name='11000',Code_Type__c='CPT',Code_Description__c='test',Description__c='test',Code_Indicator_Type__c='',Value__c=''));
        KLList.add(new KL_Data__c(Name='11000',Code_Type__c='CPT',Code_Description__c='test desc',Description__c='test desc',Code_Indicator_Type__c='',Value__c=''));
        KLList.add(new KL_Data__c(Name='N95.8',Code_Type__c='ICD10 Diagnosis',Code_Description__c='test',Description__c='test',Code_Indicator_Type__c='',Value__c=''));
        //ICD10 Diagnosis
        insert KLList;
        String KLInput ='{\"procedureCodes\":\"11000\",\"diagnosisCode\":\"N95.8\"}';
        System.assertNotEquals(null, ACET_BenefitCheckController.getKLData(KLInput));
        KLInput ='{\"procedureCodes\":\"11000\",\"diagnosisCode\":\"N95.8\"';
        System.assertNotEquals(null, ACET_BenefitCheckController.getKLData(KLInput));
    }

}