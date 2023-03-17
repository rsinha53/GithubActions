@isTest(SeeAllData=false)
global class ACETProviderLookupControllerTest { 
    public static final Integer statusCode200 = 200;
    public static final String status200 = 'OK';
    public static final Integer statusCode400 = 400;
    public static final String status400 = 'Bad Request';
    public static final Integer statusCode404 = 404;
	public static final String status404 = 'Not Found';
    public static final Integer statusCode500 = 500;
    public static final String status500 = 'Internal Server Error';
    public static final Integer statusCode504 = 504;
    public static final String status504 = 'Time Out';
    public static final Integer statusCode999 = 999;
    public static final String status999 = 'Unexpected Error';
    
	public static final String nimbusGetSSBResponse = '{"getSubscriptionServiceBenefitResponse":{"serviceBenefit":{"memberGroup":{"groupNumber":"1013629","groupName":"E2E_Rivervally_group 20210702035146"},"memberGroupContractPlanOption":{"benefitBundleOptionId":"11958418","planMetallicLevel":"Gold","oonPricingType":"CMS Based","mnrpPercentile":"110.00","ucrPercentile":"80.00","fallThruPercent":"20.00","bookOfBusinessTypeCode":"UH","bookOfBusinessTypeDescription":"UnitedHealthcare Insurance Company","lineOfBusinessId":"2","lineOfBusinessName":"Small Business","lineOfBusinessDescription":"Small Business  (UHC definition = 2 to 50, and Sole Prop)","benefitPlan":[{"membership":[{"subscriberIdentifier":{"type":"SRK","id":"740970865"},"enrolleeIdentifier":{"type":"SRK","id":"740970884"},"coverageStartDate":"2021-01-01","coverageEndDate":"9999-12-31","timePeriodQualifier":"Calendar","contractOptionStartDate":"2021-01-01","contractOptionEndDate":"2021-12-31"}],"benefitPlanId":"M030000189","coverageType":"MEDICAL","carrierId":"36","legalEntityName":"UnitedHealthcare Insurance Company","networkScheduleIds":[{"networkScheduleId":"CHOICEPLUS_1"}],"gatedProductIndicator":"false","pcpRequiredIndicator":"false","productName":"UHC POS Non-Gated INN/OON","productId":"PM00000048","planTypeCode":"POS","timelyFilingLimitDuration":"365","timelyFilingLimitType":"Days","customerFacingPlanName":"UHC Choice Plus Gold 1500-4","riderOnlyFlag":"false","planTier":[{"tierIdentifier":"1","tierDescription":"Core Benefits","tierTypeCode":"INN","tierTypeDescription":"In Network","gatedPlanIndicator":"false","primaryCoInsurance":"80","accumulatorAmounts":[{"accumLevel":"PLAN","individualDeductibleMaximum":"1500.00","familyDeductibleMaximum":"3000.00","individualOOPMaximum":"6900.00","familyOOPMaximum":"13800.00","individualDeductibleYTD":"0.00","familyDeductibleYTD":"0.00","individualOOPYTD":"0.00","familyOOPYTD":"0.00","familyAccumulationTypeDescriptionDeductible":"Embedded Accum","familyAccumulationTypeDescriptionOOP":"Embedded Accum","deductibleCarryOverIndicator":"false","shareBasePlanAccumulatorIndicatorOOP":"false","shareBasePlanAccumulatorIndicatorDeductible":"false"}],"pcpCopay":["35.00"],"specialistCopay":["70.00"],"urgentCareCopay":["75.00"],"inPatientCopay":["0.00"],"serviceAreaType":"In/Out of Srvc Area","planDelegation":[{"delegationIndicator":"false"}],"primaryOopComposition":{"costShareType":["Deductible","Copay","Coinsurance"]},"networkAccessTypeCode":"2","networkAccessTypeDescription":"Open Access - All Networks","network":[{"id":"network_id1","description":"Core Benefit Network"}]},{"tierIdentifier":"2","tierDescription":"OON Benefits","tierTypeCode":"OON","tierTypeDescription":"Out of Network","gatedPlanIndicator":"false","primaryCoInsurance":"50","accumulatorAmounts":[{"accumLevel":"PLAN","individualDeductibleMaximum":"2550.00","familyDeductibleMaximum":"5100.00","individualOOPMaximum":"15800.00","familyOOPMaximum":"31600.00","individualDeductibleYTD":"0.00","familyDeductibleYTD":"0.00","individualOOPYTD":"0.00","familyOOPYTD":"0.00","familyAccumulationTypeDescriptionDeductible":"Embedded Accum","familyAccumulationTypeDescriptionOOP":"Embedded Accum","deductibleCarryOverIndicator":"false","shareBasePlanAccumulatorIndicatorOOP":"false","shareBasePlanAccumulatorIndicatorDeductible":"false"}],"virtualVisitsCopay":["0.00"],"urgentCareCopay":["0.00"],"inPatientCopay":["0.00"],"serviceAreaType":"In/Out of Srvc Area","planDelegation":[{"delegationIndicator":"false"}],"primaryOopComposition":{"costShareType":["Deductible","Copay","Coinsurance"]}}],"benefitCode":[{"benefitName":"Vision Services","benefitCode":"VISION_SERVICES","benefitDisplay":"Vision Services","benefitTier":["1","2"],"benefitType":"M","primaryOOPOnlyFlag":"false","primaryDeductibleOnlyFlag":"false","visitLimitsApplies":"false","copayApplies":"false","variableCoverage":"true","existsOnRiderPlan":"false","hipaaServiceTypes":[{"serviceTypeCode":"AL","serviceTypeDescription":"Vision (Optometry)"}]},{"benefitName":"Infertility Services - Artificial Insemination","benefitCode":"INFERTILITY_SERVICES_AI","benefitDisplay":"Infertility Services - Artificial Insemination","benefitTier":["2","1"],"benefitType":"M","primaryOOPOnlyFlag":"false","primaryDeductibleOnlyFlag":"false","visitLimitsApplies":"false","copayApplies":"false","variableCoverage":"true","existsOnRiderPlan":"false","hipaaServiceTypes":[{"categoryCode":"01","categoryCodeDescription":"Medical Care","serviceTypeCode":"83","serviceTypeDescription":"Infertility"}]}],"eHBIndicator":"true","externalIds":[{"entityId":"EMBDENT","externalPlanId":"CD4Y"}],"qualityProviderTierRuleID":"","placeOfServiceDifferentialIndicator":"false","fundingArrangementCode":"01","fundingArrangementDescription":"Fully Insured","revenueArrangementCode":"01","revenueArrangementDescription":"FI","carrierBusinessId":"36"}]}}}}';
    public static final String nimbusGetSSBBadResponse = '{"getSubscriptionServiceBenefitResponse":{"transactionId":"fdd36afa-a4db-42ec-89cb-d4450fd6909e","errors":[{"code":400,"name":"InvalidRequest","severity":"FAULT","origin":"cirrus","description":"getSubscriptionServiceBenefitRequest : Validation Failed for Member Search required fields missing","uri":"/api/nebula/v1.0/benefits/read"}]}}';
    public static final String bundleOptionId = '11958418';
    public static final String surrogateKey = '740970884';
    public static final String subscriberSRKID ='740970865';
    public static final String effectiveDate = '2021-01-01';
    public static final String endDateSSB = '2021-12-31';
    public static final String coverageTypes ='';
    public static final String groupNum = '1013629';
    public static final String accumsDate = '';
    public static final String accumAsOf = '';
    public static final String memId = '13690586900';
   
    @testsetup
    static void prepareData(){
        Organization_Properties__c orgProps = Organization_Properties__c.getOrgDefaults();
        orgProps.OrganizationName__c = 'QA';
        Upsert orgProps;
        // Token API data
        WebserviceConfigurations__c tokenAPIWSConfig = ACET_WebserviceCalloutFramework_Test.createTokenWSConfigs('StarGateTokenAPI');
        OrgSpecificConfigurations__c tokenAPIOrgSpecificConfigs = ACET_WebserviceCalloutFramework_Test.createTokenOrgWSConfigs(tokenAPIWSConfig.Id);
		System.debug(tokenAPIOrgSpecificConfigs);
        // Service API data
        WebserviceConfigurations__c wsConfig1 = ACET_WebserviceCalloutFramework_Test.createWSConfig('NimbusGetSSBService', tokenAPIWSConfig.Id);
        OrgSpecificConfigurations__c orgSpecificConfigs1 = ACET_WebserviceCalloutFramework_Test.createOrgWSConfigs(wsConfig1.Id);
        System.debug(orgSpecificConfigs1);
    }
   	@isTest
    static void testGetBenefitTiers(){
        test.startTest();
        ACETProviderLookupController.getBenefitTiers(bundleOptionId, surrogateKey,  subscriberSRKID ,  effectiveDate , endDateSSB, coverageTypes, groupNum, accumsDate, accumAsOf, memId);
        
        MockHttpCalloutResponseGenerator.MockHttpResponse mockResponse = new MockHttpCalloutResponseGenerator.MockHttpResponse(statusCode200, status200, nimbusGetSSBResponse);        
        mockResponse.TokenExpired = false;        
        MockHttpCalloutResponseGenerator mockHttpRes = new MockHttpCalloutResponseGenerator(null, mockResponse);
        Test.setMock(HttpCalloutMock.class, mockHttpRes);
		ACETProviderLookupController.getBenefitTiers(bundleOptionId, surrogateKey,  subscriberSRKID ,  effectiveDate , endDateSSB, coverageTypes, groupNum, accumsDate, accumAsOf, memId);
        
        
        MockHttpCalloutResponseGenerator.MockHttpResponse mockResponse1 = new MockHttpCalloutResponseGenerator.MockHttpResponse(statusCode400, status400, nimbusGetSSBBadResponse);        
        mockResponse1.TokenExpired = false;        
        MockHttpCalloutResponseGenerator mockHttpRes1 = new MockHttpCalloutResponseGenerator(null, mockResponse1);
        Test.setMock(HttpCalloutMock.class, mockHttpRes1);
		ACETProviderLookupController.getBenefitTiers(bundleOptionId, surrogateKey,  subscriberSRKID ,  effectiveDate , endDateSSB, coverageTypes, groupNum, accumsDate, accumAsOf, memId);
        
        MockHttpCalloutResponseGenerator.MockHttpResponse mockResponse2 = new MockHttpCalloutResponseGenerator.MockHttpResponse(statusCode500, status500, nimbusGetSSBBadResponse);        
        mockResponse2.TokenExpired = false;        
        MockHttpCalloutResponseGenerator mockHttpRes2 = new MockHttpCalloutResponseGenerator(null, mockResponse2);
        Test.setMock(HttpCalloutMock.class, mockHttpRes2);
		ACETProviderLookupController.getBenefitTiers(bundleOptionId, surrogateKey,  subscriberSRKID ,  effectiveDate , endDateSSB, coverageTypes, groupNum, accumsDate, accumAsOf, memId);
        
        MockHttpCalloutResponseGenerator.MockHttpResponse mockResponse3 = new MockHttpCalloutResponseGenerator.MockHttpResponse(statusCode404, status404, nimbusGetSSBBadResponse);        
        mockResponse3.TokenExpired = false;        
        MockHttpCalloutResponseGenerator mockHttpRes3 = new MockHttpCalloutResponseGenerator(null, mockResponse3);
        Test.setMock(HttpCalloutMock.class, mockHttpRes3);
		ACETProviderLookupController.getBenefitTiers(bundleOptionId, surrogateKey,  subscriberSRKID ,  effectiveDate , endDateSSB, coverageTypes, groupNum, accumsDate, accumAsOf, memId);
        
        MockHttpCalloutResponseGenerator.MockHttpResponse mockResponse4 = new MockHttpCalloutResponseGenerator.MockHttpResponse(statusCode504, status504, nimbusGetSSBBadResponse);
        mockResponse4.TokenExpired = false;        
        MockHttpCalloutResponseGenerator mockHttpRes4 = new MockHttpCalloutResponseGenerator(null, mockResponse4);
        Test.setMock(HttpCalloutMock.class, mockHttpRes4);
		ACETProviderLookupController.getBenefitTiers(bundleOptionId, surrogateKey,  subscriberSRKID ,  effectiveDate , endDateSSB, coverageTypes, groupNum, accumsDate, accumAsOf, memId);
        
         MockHttpCalloutResponseGenerator.MockHttpResponse mockResponse5 = new MockHttpCalloutResponseGenerator.MockHttpResponse(statusCode999, status999, nimbusGetSSBBadResponse);
        mockResponse4.TokenExpired = false;        
        MockHttpCalloutResponseGenerator mockHttpRes5 = new MockHttpCalloutResponseGenerator(null, mockResponse5);
        Test.setMock(HttpCalloutMock.class, mockHttpRes5);
		ACETProviderLookupController.getBenefitTiers(bundleOptionId, surrogateKey,  subscriberSRKID ,  effectiveDate , endDateSSB, coverageTypes, groupNum, accumsDate, accumAsOf, memId);
        
        test.stopTest();
    }
    static testMethod void ACETProviderLookupControllerTestMethodPhysician(){
        
          Map<String, String> mapISLWSConfigs = new Map<String, String>(); 
        mapISLWSConfigs.put('ISLConAccessToken', 'dfb379c2-06b7-46c4-8c6f-bbc390d1b854');
        mapISLWSConfigs.put('OILHttpHeaderAccept', 'application/json;charset=UTF-8');
        mapISLWSConfigs.put('OILHttpHeaderActor', 'ACET');
        mapISLWSConfigs.put('OILHttpHeaderScope', 'read'); 
        mapISLWSConfigs.put('ISLOAuthContentType', 'application/x-www-form-urlencoded');
        mapISLWSConfigs.put('ISLOAuthGrantType', 'client_credentials');
        mapISLWSConfigs.put('dev_ISLOAuthClientId', 'ISLStageConClientId');
        mapISLWSConfigs.put('dev_ISLOAuthClientSecret', 'ISLStageConClientSecret');
        mapISLWSConfigs.put('dev_ISLOAuthEndpoint', 'https://api-stg.optum.com:8443');
        mapISLWSConfigs.put('dev_findHCPEndpoint', '/api/alpha/eisl/providers/medicalhealthcareprofessionals/v1/search');
        mapISLWSConfigs.put('dev_ISLOAuthTokenEndpoint', '/auth/oauth/v2/token');
        mapISLWSConfigs.put('OILTimeout', '3000'); 
        List<ISL_Webservice_Config__c> lstISLWSConfigs = ACETTestDataUtility.CreateISLWebserviceConfigurations(mapISLWSConfigs);
        insert lstISLWSConfigs;
       
        Test.startTest();//
        
         
       
        
        string jsonResp = ACETTestDataUtility.findHCPAdapterJSON();
       
        AcetfindHCPJSON2Apex jsonAPex = AcetfindHCPJSON2Apex.parse(jsonResp);
        
        //interaction and highlight panel       
        Interaction__c InteractionId = ACETProviderSearchController.RedirectToProviderDetail('Phone Call', 'Contact Name', '1', '999999999', '9999999999', 'Group Name', 'Facility/Group','1452423968971','12345','60005');
 
        MockHttpCalloutResponseGenerator.MockHttpResponse OILResponse = new MockHttpCalloutResponseGenerator.MockHttpResponse(200, 'OK', jsonResp);
        OILResponse.TokenExpired = false;
        
        MockHttpCalloutResponseGenerator MockHttpRes = new MockHttpCalloutResponseGenerator(null, OILResponse);
               
        // Set mock callout class 
        Test.setMock(HttpCalloutMock.class, MockHttpRes);
        ACETProviderLookUpDetailController ACETlkpdtl = new ACETProviderLookUpDetailController();
       
        ACETlkpdtl.providerType = 'Facility';
        ACETlkpdtl.CallFindMedicalProvider();
        ACETFindHCPWebservice hcpws = new ACETFindHCPWebservice();
        hcpws.Init('23423434234', '2342342', '2342342', '', '', '', '', '', '', '', '', '', '7@6', '', '', '', '', '', '', 'Physician','','true','','true');
        hcpws.queryPaginatedData(0,5,0);
        
        // Call method to test.                
        PageReference ACETPDPage = Page.ACETProviderLookup;
        ApexPages.currentPage().getParameters().put('InteractionId',InteractionId.Id);
        ACETPDPage.getParameters().put('Id', InteractionId.Id);
        ACETProviderLookupController Acetlkpctrl = new ACETProviderLookupController();
        Acetlkpctrl.providerType = 'Physician'; 
        Acetlkpctrl.NewpatientsInd = true;
        Acetlkpctrl.existingpatientsInd = true;
        Acetlkpctrl.FreeStandingFacl = true;
        Acetlkpctrl.TaxId = '363149933';
        Acetlkpctrl.memId = '95548810402';
        Acetlkpctrl.searchProviderId = '256745246538825040';
        Acetlkpctrl.NPI = '1336158930';
        Acetlkpctrl.searchPcpOBGYNId = '27046590';
        hcpws.FindHCP('123445555', '', '345345345454', '', '', '', 'Physician', '', '', '', '', '', '', '', '', '', '', '','');
        Acetlkpctrl.searchResults();
       
       
        ACETProviderLookupController.ChangeDateFormatForOIL('08/30/18');
        ACETProviderLookupController.getProviders();
        ACETProviderLookupController.getClasifications();
        ACETProviderLookupController.getSpecilities();
        Acetlkpctrl.callOutErrorMessage= 'Unexpected Error Oil could not connect';
        Acetlkpctrl.addErrorMessage();
        MockHttpCalloutResponseGenerator.MockHttpResponse OILResponse1 = new MockHttpCalloutResponseGenerator.MockHttpResponse(200, 'OK', ACETTestDataUtility.getSubscriptionBenefitResponse());
        OILResponse1.TokenExpired = false;
        
        MockHttpCalloutResponseGenerator MockHttpRes1 = new MockHttpCalloutResponseGenerator(null, OILResponse1);
        Test.setMock(HttpCalloutMock.class, MockHttpRes1);
       
        Test.stopTest();
    }


    static testMethod void ACETProviderLookupControllerTestMethodFacility(){
        
         Map<String, String> mapISLWSConfigs = new Map<String, String>(); 
        mapISLWSConfigs.put('ISLConAccessToken', 'dfb379c2-06b7-46c4-8c6f-bbc390d1b854');
        mapISLWSConfigs.put('OILHttpHeaderAccept', 'application/json;charset=UTF-8');
        mapISLWSConfigs.put('OILHttpHeaderActor', 'ACET');
        mapISLWSConfigs.put('OILHttpHeaderScope', 'read');
        mapISLWSConfigs.put('ISLOAuthContentType', 'application/x-www-form-urlencoded');
        mapISLWSConfigs.put('ISLOAuthGrantType', 'client_credentials');
        mapISLWSConfigs.put('dev_ISLOAuthClientId', 'ISLStageConClientId');
        mapISLWSConfigs.put('dev_ISLOAuthClientSecret', 'ISLStageConClientSecret');
        mapISLWSConfigs.put('dev_ISLOAuthEndpoint', 'https://api-stg.optum.com:8443');
        mapISLWSConfigs.put('dev_findHCPEndpoint', '/api/alpha/eisl/providers/medicalhealthcareprofessionals/v1/search');
        mapISLWSConfigs.put('dev_ISLOAuthTokenEndpoint', '/auth/oauth/v2/token');
        mapISLWSConfigs.put('OILTimeout', '3000'); 
        List<ISL_Webservice_Config__c> lstISLWSConfigs = ACETTestDataUtility.CreateISLWebserviceConfigurations(mapISLWSConfigs);
        insert lstISLWSConfigs;
       
        
        //interaction and highlight panel       
        Interaction__c InteractionId = ACETProviderSearchController.RedirectToProviderDetail('Phone Call', 'Contact Name', '1', '999999999', '9999999999', 'Group Name', 'Facility/Group','1452423968971','12345','60005');
 
        MockHttpCalloutResponseGenerator.MockHttpResponse OILResponse = new MockHttpCalloutResponseGenerator.MockHttpResponse(200, 'OK', ACETTestDataUtility.findHCOAdapterJSON());
        OILResponse.TokenExpired = false;
                
        Test.startTest();//
        
        MockHttpCalloutResponseGenerator MockHttpRes = new MockHttpCalloutResponseGenerator(null, OILResponse);
               
        // Set mock callout class 
        Test.setMock(HttpCalloutMock.class, MockHttpRes);
        // Call method to test.                
        PageReference ACETPDPage = Page.ACETProviderLookup;
        ApexPages.currentPage().getParameters().put('InteractionId',InteractionId.Id);
        ACETPDPage.getParameters().put('Id', InteractionId.Id);
        ACETProviderLookupController Acetlkpctrl = new ACETProviderLookupController();
        Acetlkpctrl.providerType = 'Facility'; 
        Acetlkpctrl.NewpatientsInd = false;
        Acetlkpctrl.existingpatientsInd = false;
        Acetlkpctrl.FreeStandingFacl = false;
        Acetlkpctrl.TaxId = '363149933';
        Acetlkpctrl.searchResults();  
        Test.stopTest();
    }
    

    static testMethod void ACETProviderLookupControllerTestMethodCG(){
        
         Map<String, String> mapISLWSConfigs = new Map<String, String>(); 
        mapISLWSConfigs.put('ISLConAccessToken', 'dfb379c2-06b7-46c4-8c6f-bbc390d1b854');
        mapISLWSConfigs.put('OILHttpHeaderAccept', 'application/json;charset=UTF-8');
        mapISLWSConfigs.put('OILHttpHeaderActor', 'ACET');
        mapISLWSConfigs.put('OILHttpHeaderScope', 'read');
        mapISLWSConfigs.put('ISLOAuthContentType', 'application/x-www-form-urlencoded');
        mapISLWSConfigs.put('ISLOAuthGrantType', 'client_credentials');
        mapISLWSConfigs.put('dev_ISLOAuthClientId', 'ISLStageConClientId');
        mapISLWSConfigs.put('dev_ISLOAuthClientSecret', 'ISLStageConClientSecret');
        mapISLWSConfigs.put('dev_ISLOAuthEndpoint', 'https://api-stg.optum.com:8443');
        mapISLWSConfigs.put('dev_findHCPEndpoint', '/api/alpha/eisl/providers/medicalhealthcareprofessionals/v1/search');
        mapISLWSConfigs.put('dev_ISLOAuthTokenEndpoint', '/auth/oauth/v2/token');
        mapISLWSConfigs.put('OILTimeout', '3000'); 
        List<ISL_Webservice_Config__c> lstISLWSConfigs = ACETTestDataUtility.CreateISLWebserviceConfigurations(mapISLWSConfigs);
        insert lstISLWSConfigs;
       
        
        //interaction and highlight panel       
        Interaction__c InteractionId = ACETProviderSearchController.RedirectToProviderDetail('Phone Call', 'Contact Name', '1', '999999999', '9999999999', 'Group Name', 'Facility/Group','1452423968971','12345','60005');
 
        MockHttpCalloutResponseGenerator.MockHttpResponse OILResponse = new MockHttpCalloutResponseGenerator.MockHttpResponse(200, 'OK', ACETTestDataUtility.findMedicalProviderAdapterJSON());
       // MockHttpCalloutResponseGenerator.MockHttpResponse OILResponse = new MockHttpCalloutResponseGenerator.MockHttpResponse(200, 'OK','');
        OILResponse.TokenExpired = false;
                
        Test.startTest();//
        
        MockHttpCalloutResponseGenerator MockHttpRes = new MockHttpCalloutResponseGenerator(null, OILResponse);
               
        // Set mock callout class 
        Test.setMock(HttpCalloutMock.class, MockHttpRes);
        // Call method to test.                
        PageReference ACETPDPage = Page.ACETProviderLookup;
        ApexPages.currentPage().getParameters().put('InteractionId',InteractionId.Id);
        ACETPDPage.getParameters().put('Id', InteractionId.Id);
        ACETProviderLookupController Acetlkpctrl = new ACETProviderLookupController();
        Acetlkpctrl.providerType = 'other'; 
        Acetlkpctrl.NewpatientsInd = false;
        Acetlkpctrl.existingpatientsInd = false;
        Acetlkpctrl.FreeStandingFacl = false;
        Acetlkpctrl.TaxId = '363149933';
        Acetlkpctrl.searchResults();
        Acetlkpctrl.isErrorMessageAdded = false;
        ACETProviderLookupController.ProviderLookupResult providerResults = new ACETProviderLookupController.ProviderLookupResult();
        providerResults.benefitPlanId ='test';
        Test.stopTest();
  
    }    
    
    static testMethod void ACETProviderLookupControllerTestMethodEmpty(){
         Map<String, String> mapISLWSConfigs = new Map<String, String>(); 
        mapISLWSConfigs.put('ISLConAccessToken', 'dfb379c2-06b7-46c4-8c6f-bbc390d1b854');
        mapISLWSConfigs.put('OILHttpHeaderAccept', 'application/json;charset=UTF-8');
        mapISLWSConfigs.put('OILHttpHeaderActor', 'ACET');
        mapISLWSConfigs.put('OILHttpHeaderScope', 'read');
        mapISLWSConfigs.put('ISLOAuthContentType', 'application/x-www-form-urlencoded');
        mapISLWSConfigs.put('ISLOAuthGrantType', 'client_credentials');
        mapISLWSConfigs.put('dev_ISLOAuthClientId', 'ISLStageConClientId');
        mapISLWSConfigs.put('dev_ISLOAuthClientSecret', 'ISLStageConClientSecret');
        mapISLWSConfigs.put('dev_ISLOAuthEndpoint', 'https://api-stg.optum.com:8443');
        mapISLWSConfigs.put('dev_findHCPEndpoint', '/api/alpha/eisl/providers/medicalhealthcareprofessionals/v1/search');
        mapISLWSConfigs.put('dev_ISLOAuthTokenEndpoint', '/auth/oauth/v2/token');
        mapISLWSConfigs.put('OILTimeout', '3000'); 
        List<ISL_Webservice_Config__c> lstISLWSConfigs = ACETTestDataUtility.CreateISLWebserviceConfigurations(mapISLWSConfigs);
        insert lstISLWSConfigs;
        
        //interaction and highlight panel       
        Interaction__c InteractionId = ACETProviderSearchController.RedirectToProviderDetail('Phone Call', 'Contact Name', '1', '999999999', '9999999999', 'Group Name', 'Facility/Group','1452423968971','12345','60005');
 
        MockHttpCalloutResponseGenerator.MockHttpResponse OILResponse = new MockHttpCalloutResponseGenerator.MockHttpResponse(500, 'OK','');
        OILResponse.TokenExpired = false;
                
        Test.startTest();//
        
        MockHttpCalloutResponseGenerator MockHttpRes = new MockHttpCalloutResponseGenerator(null, OILResponse);
               
        // Set mock callout class 
        Test.setMock(HttpCalloutMock.class, MockHttpRes);
        //AcetProviderlookupController.StartDate();
        ACETProviderLookupController Acetlkpctrl1 = new ACETProviderLookupController();
          Acetlkpctrl1.isErrorMessageAdded=false;
          Acetlkpctrl1.conObj=null;
        
          
           Acetlkpctrl1.NewpatientsInd = false;
           Acetlkpctrl1.existingpatientsInd = false;
           Acetlkpctrl1.FreeStandingFacl = false;
           Acetlkpctrl1.TaxId = '';
           Acetlkpctrl1.searchResults(); 
           List<SelectOption> languagecmdt = Acetlkpctrl1.languagescmdt;
           //Acetlkpctrl1.providertypechange();
           Acetlkpctrl1.providerType = 'other'; 
           //Acetlkpctrl1.getSpecialities();
           Acetlkpctrl1.clearResults(); 
           //Acetlkpctrl1.getClassifications();
          
           Acetlkpctrl1.selectedSpeciality='sample';
           Acetlkpctrl1.hpAdditionInfoStr='Stest';
           Acetlkpctrl1.searchResults();
           Acetlkpctrl1.radious='RTest';
           ACETProviderLookupController.ProviderLookupResult providerResults = new ACETProviderLookupController.ProviderLookupResult();
           providerResults.networkSchedule = 'Now';
           providerResults.languageSchedule = 'English';
           providerResults.status = 'Ready';
           providerResults.ssn = '2390843204324';
           providerResults.SelSpecialityCodes = 'PHY';
           providerResults.NPI = '1234567890';
           providerResults.street = 'AMG';
           providerResults.gender = 'Male';
           providerResults.network = 'Test';
           providerResults.affiliation = 'Test';
           providerResults.uphd = 'Test';
           providerResults.acceptNewPatient = 'Test';
           providerResults.platinum = 'Test';
           providerResults.radius = 'Test';
           providerResults.ProviderName = 'Test';
           providerResults.typeDescription = 'Test';
           providerResults.phone = 'Test';
           providerResults.Code = 'Test';
           providerResults.providerTINStatusCode = 'Test';
           providerResults.benefitPlanId = 'Test';
           providerResults.County = 'Test';
           providerResults.Fax = 'Test';
           providerResults.Email = 'Test';
           providerResults.OperationHours = 'Test';
           providerResults.PatientAgeRange = 'Test';
           providerResults.owner = 'Test';
           providerResults.hcoTypeCode = 'Test';
           providerResults.firstName = 'Ruby';
           providerResults.lastName = 'Kelly';
           providerResults.middleName = 'test';
           providerResults.suffix = 'Mr';
           case obj=new case();
           //case.startDate;
           //case.endDate;
           
           
           Test.stopTest();
    }
    
    //Success response for FindMedicalProviders, number of records found is greater than zero
    static testMethod void ACETAAProviderLookupControllerTest1() {
        
        Map<String, String> TestISLWSConfigs = new Map<String, String>(); 
        TestISLWSConfigs.put('ISLConAccessToken', 'dfb379c2-06b7-46c4-8c6f-bbc390d1b854');
        TestISLWSConfigs.put('ISLOAuthContentType', 'application/x-www-form-urlencoded');
        TestISLWSConfigs.put('ISLOAuthGrantType', 'client_credentials');
        TestISLWSConfigs.put('OILHttpHeaderAccept', 'application/json;charset=UTF-8');
        TestISLWSConfigs.put('OILHttpHeaderActor', 'ACET');
        TestISLWSConfigs.put('OILHttpHeaderScope', 'read');
        TestISLWSConfigs.put('OILTimeout', '3000');
        TestISLWSConfigs.put('dev_ISLOAuthEndpoint', 'https://api-stg.optum.com:8443');
        TestISLWSConfigs.put('dev_findMedicalProviderAdapterEndpoint', '/api/alpha/eisl/providers/medicalproviders/v2.0/search');
        List<ISL_Webservice_Config__c> lstISLWSConfigs = ACETTestDataUtility.CreateISLWebserviceConfigurations(TestISLWSConfigs);
        insert lstISLWSConfigs;
        
        StaticResource ResponseJSONSR = [SELECT Body FROM StaticResource WHERE Name = 'ACETFindMedicalProvidersResponseJSON'];
        String ResponseJSON = ResponseJSONSR.Body.toString(); 
        system.debug(LoggingLevel.INFO, 'Response JSON: ' + ResponseJSON);
        
       /* Account oAccount = ACETTestDataUtility.CreateAccount('Test Account', 'TstTaxID1', 'TestEID1');
        insert oAccount;
        Contact oContact = ACETTestDataUtility.CreateContact(oAccount.Id, 'Test Contact LN', 'Test Contact FN', 'TstTaxID1', 'TestEID1', 'TestNPI1');
        insert oContact;*/
         RecordType newRecord = [SELECT Id FROM RecordType WHERE Name = 'Person Account' and SObjectType = 'Account'];
        
        Account accountTest = new Account();
        accountTest.FirstName = 'Test Contact FN1';
        accountTest.LastName = 'Test Contact LN1';
        accountTest.EID__c = 'TestEID1';
        accountTest.EID__pc = 'TestEID1';
        accountTest.RecordTypeId = newRecord.Id;
        insert accountTest;

    Account oAccount = [SELECT Id,personcontactid from Account where Id=:accountTest.Id];
        Contact oContact = [SELECT Id,LastName,FirstName,EID__c,AccountId from Contact where Id=:oAccount.personcontactid];
        
            
        Interaction__c oInteraction = ACETTestDataUtility.CreateInteraction(oContact.Id, 'Phone', 'Member', oContact.LastName);
        insert oInteraction;
        
        ACETHighlightsPanelAdditionalInfo AdditionalInfo = new ACETHighlightsPanelAdditionalInfo();
        AdditionalInfo.PolicyNumber = 'TestPolicyNumber';
        
        MockHttpCalloutResponseGenerator.MockHttpResponse OILTestResponse = new MockHttpCalloutResponseGenerator.MockHttpResponse(200, 'OK', ResponseJSON);
        OILTestResponse.TokenExpired = false;
        
        Test.startTest();
        
        MockHttpCalloutResponseGenerator MockHttpResponse = new MockHttpCalloutResponseGenerator(null, OILTestResponse);
        Test.setMock(HttpCalloutMock.class, MockHttpResponse);
        
        PageReference ACETPL = Page.ACETProviderLookup;
        ACETPL.getParameters().put('interactionId', oInteraction.Id);
        ACETPL.getParameters().put('benefitPlanId', 'BenefitPlanId1');
        ACETPL.getParameters().put('contactId', oContact.Id);
        ACETPL.getParameters().put('additionalInfo', JSON.serialize(AdditionalInfo));
        Test.setCurrentPageReference(ACETPL);
        
        ACETProviderLookupController ACETPLCtrl = new ACETProviderLookupController();
        ACETPLCtrl.NewpatientsInd = true;
        ACETPLCtrl.existingpatientsInd = true;
        ACETPLCtrl.FreeStandingFacl = true;
        ACETPLCtrl.phoneNumber = '1111111111';
        ACETPLCtrl.networkval = 'Freedom';
        ACETPLCtrl.LanguageVal = 'American Sign Language';
        ACETPLCtrl.showNonParChckBox = false;
		ACETPLCtrl.isDDP = true;						
        List<SelectOption> languagecmdt = ACETPLCtrl.languagescmdt;
        ACETFindProviderLookupWebservice findProviderLookupWebservice = new ACETFindProviderLookupWebservice();
        findProviderLookupWebservice.init('256745246538825040','','810477845','A BILLEDEAUX','','Male','','24545519','','','GLENDIVE','','4063458901','','','','','','','','','','true','true','');
        ACETPLCtrl.searchResults();
        ACETFindProviderLookupWebservice ACETFPLWS = (ACETFindProviderLookupWebservice)JSON.deserialize(ACETPLCtrl.PLDTWrapper.Service.replace('&#x27;', '\''), ACETFindProviderLookupWebservice.class);
        ACETFPLWS.queryPaginatedData(0, 5, 0);
        
        Test.stopTest();
    }
    
    //Success response for FindMedicalProviders, number of records found is zero
    static testMethod void ACETAAProviderLookupControllerTest2() {
        
        Map<String, String> TestISLWSConfigs = new Map<String, String>(); 
        TestISLWSConfigs.put('ISLConAccessToken', 'dfb379c2-06b7-46c4-8c6f-bbc390d1b854');
        TestISLWSConfigs.put('ISLOAuthContentType', 'application/x-www-form-urlencoded');
        TestISLWSConfigs.put('ISLOAuthGrantType', 'client_credentials');
        TestISLWSConfigs.put('OILHttpHeaderAccept', 'application/json;charset=UTF-8');
        TestISLWSConfigs.put('OILHttpHeaderActor', 'ACET');
        TestISLWSConfigs.put('OILHttpHeaderScope', 'read');
        TestISLWSConfigs.put('OILTimeout', '3000');
        TestISLWSConfigs.put('dev_ISLOAuthEndpoint', 'https://api-stg.optum.com:8443');
        TestISLWSConfigs.put('dev_findMedicalProviderAdapterEndpoint', '/api/alpha/eisl/providers/medicalproviders/v2.0/search');
        List<ISL_Webservice_Config__c> lstISLWSConfigs = ACETTestDataUtility.CreateISLWebserviceConfigurations(TestISLWSConfigs);
        insert lstISLWSConfigs;
        
        String ResponseJSON = '{"findMedicalProvidersResponse":{"errors":[{"code":"W008","name":"No records returned",';
        ResponseJSON += '"severity":"low","origin":"Consumer","description":"Consumer has requested a query for which no records have been found.';
        ResponseJSON += '"}],"pagination":{"pageNumber":"0","pageSize":"2","recordCount":"0","totalCount":"0","totalPages":"0"}}}}'; 
        
        system.debug(LoggingLevel.INFO, 'Response JSON: ' + ResponseJSON);
        
      /*  Account oAccount = ACETTestDataUtility.CreateAccount('Test Account', 'TstTaxID1', 'TestEID1');
        insert oAccount;
        Contact oContact = ACETTestDataUtility.CreateContact(oAccount.Id, 'Test Contact LN', 'Test Contact FN', 'TstTaxID1', 'TestEID1', 'TestNPI1');
        insert oContact;*/
         RecordType newRecord = [SELECT Id FROM RecordType WHERE Name = 'Person Account' and SObjectType = 'Account'];
        
        Account accountTest = new Account();
        accountTest.FirstName = 'Test Contact FN1';
        accountTest.LastName = 'Test Contact LN1';
        accountTest.EID__c = 'TestEID1';
        accountTest.EID__pc = 'TestEID1';
        accountTest.RecordTypeId = newRecord.Id;
        insert accountTest;

    Account oAccount = [SELECT Id,personcontactid from Account where Id=:accountTest.Id];
        Contact oContact = [SELECT Id,LastName,FirstName,EID__c,AccountId from Contact where Id=:oAccount.personcontactid];
        
            
        Interaction__c oInteraction = ACETTestDataUtility.CreateInteraction(oContact.Id, 'Phone', 'Member', oContact.LastName);
        insert oInteraction;
        
        ACETHighlightsPanelAdditionalInfo AdditionalInfo = new ACETHighlightsPanelAdditionalInfo();
        AdditionalInfo.PolicyNumber = 'TestPolicyNumber';
        
        MockHttpCalloutResponseGenerator.MockHttpResponse OILTestResponse = new MockHttpCalloutResponseGenerator.MockHttpResponse(200, 'OK', ResponseJSON);
        OILTestResponse.TokenExpired = false;
        
        Test.startTest();
        
        MockHttpCalloutResponseGenerator MockHttpResponse = new MockHttpCalloutResponseGenerator(null, OILTestResponse);
        Test.setMock(HttpCalloutMock.class, MockHttpResponse);
        
        PageReference ACETPL = Page.ACETProviderLookup;
        ACETPL.getParameters().put('interactionId', oInteraction.Id);
        ACETPL.getParameters().put('benefitPlanId', 'BenefitPlanId1');
        ACETPL.getParameters().put('contactId', oContact.Id);
        ACETPL.getParameters().put('additionalInfo', JSON.serialize(AdditionalInfo));
        Test.setCurrentPageReference(ACETPL);
        
        ACETProviderLookupController ACETPLCtrl = new ACETProviderLookupController();
        ACETPLCtrl.NewpatientsInd = false;
        ACETPLCtrl.existingpatientsInd = false;
        ACETPLCtrl.FreeStandingFacl = false;
        ACETPLCtrl.phoneNumber = '1111111111';
        ACETPLCtrl.showNonParChckBox = true;
        ACETPLCtrl.selectedSpeciality = 'Acupuncturist';
        ACETPLCtrl.searchResults();
        
        ACETFindProviderLookupWebservice ACETFPLWS = (ACETFindProviderLookupWebservice)JSON.deserialize(ACETPLCtrl.PLDTWrapper.Service.replace('&#x27;', '\''), ACETFindProviderLookupWebservice.class);
        ACETFPLWS.queryPaginatedData(0, 5, 0);
        
        Test.stopTest();
    }
    
    //Error response for FindMedicalProviders
    static testMethod void ACETAAProviderLookupControllerTest3() {
        
        Map<String, String> TestISLWSConfigs = new Map<String, String>(); 
        TestISLWSConfigs.put('ISLConAccessToken', 'dfb379c2-06b7-46c4-8c6f-bbc390d1b854');
        TestISLWSConfigs.put('ISLOAuthContentType', 'application/x-www-form-urlencoded');
        TestISLWSConfigs.put('ISLOAuthGrantType', 'client_credentials');
        TestISLWSConfigs.put('OILHttpHeaderAccept', 'application/json;charset=UTF-8');
        TestISLWSConfigs.put('OILHttpHeaderActor', 'ACET');
        TestISLWSConfigs.put('OILHttpHeaderScope', 'read');
        TestISLWSConfigs.put('OILTimeout', '3000');
        TestISLWSConfigs.put('dev_ISLOAuthEndpoint', 'https://api-stg.optum.com:8443');
        TestISLWSConfigs.put('dev_findMedicalProviderAdapterEndpoint', '/api/alpha/eisl/providers/medicalproviders/v2.0/search');
        List<ISL_Webservice_Config__c> lstISLWSConfigs = ACETTestDataUtility.CreateISLWebserviceConfigurations(TestISLWSConfigs);
        insert lstISLWSConfigs;
        
        String ResponseJSON = '{"findMedicalProvidersResponse":{"errors":[{"code":"W008","name":"No records returned","severity":"low",';
        ResponseJSON += '"origin":"Consumer","description":"Consumer has requested a query for which no records have been found."}]}}'; 
        
        system.debug(LoggingLevel.INFO, 'Response JSON: ' + ResponseJSON);
        
      /*  Account oAccount = ACETTestDataUtility.CreateAccount('Test Account', 'TstTaxID1', 'TestEID1');
        insert oAccount;
        Contact oContact = ACETTestDataUtility.CreateContact(oAccount.Id, 'Test Contact LN', 'Test Contact FN', 'TstTaxID1', 'TestEID1', 'TestNPI1');
        insert oContact;*/
         RecordType newRecord = [SELECT Id FROM RecordType WHERE Name = 'Person Account' and SObjectType = 'Account'];
        
        Account accountTest = new Account();
        accountTest.FirstName = 'Test Contact FN1';
        accountTest.LastName = 'Test Contact LN1';
        accountTest.EID__c = 'TestEID1';
        accountTest.EID__pc = 'TestEID1';
        accountTest.RecordTypeId = newRecord.Id;
        insert accountTest;

    Account oAccount = [SELECT Id,personcontactid from Account where Id=:accountTest.Id];
        Contact oContact = [SELECT Id,LastName,FirstName,EID__c,AccountId from Contact where Id=:oAccount.personcontactid];
        
        
        Interaction__c oInteraction = ACETTestDataUtility.CreateInteraction(oContact.Id, 'Phone', 'Member', oContact.LastName);
        insert oInteraction;
        
        ACETHighlightsPanelAdditionalInfo AdditionalInfo = new ACETHighlightsPanelAdditionalInfo();
        AdditionalInfo.PolicyNumber = 'TestPolicyNumber';
        
        MockHttpCalloutResponseGenerator.MockHttpResponse oilTestResponse = new MockHttpCalloutResponseGenerator.MockHttpResponse(500, status500, ResponseJSON);
        oilTestResponse.TokenExpired = false;
        
        Test.startTest();
        
        MockHttpCalloutResponseGenerator mockHttpResponse = new MockHttpCalloutResponseGenerator(null, oilTestResponse);
        Test.setMock(HttpCalloutMock.class, mockHttpResponse);
        
        PageReference ACETPL = Page.ACETProviderLookup;
        ACETPL.getParameters().put('interactionId', oInteraction.Id);
        ACETPL.getParameters().put('benefitPlanId', 'BenefitPlanId1');
        ACETPL.getParameters().put('contactId', oContact.Id);
        ACETPL.getParameters().put('additionalInfo', JSON.serialize(AdditionalInfo));
        Test.setCurrentPageReference(ACETPL);
        
        ACETProviderLookupController ACETPLCtrl = new ACETProviderLookupController();
        ACETPLCtrl.NewpatientsInd = true;
        ACETPLCtrl.existingpatientsInd = true;
        ACETPLCtrl.FreeStandingFacl = true;
        ACETPLCtrl.phoneNumber = '1111111111';
        ACETPLCtrl.searchResults();
        
        ACETFindProviderLookupWebservice ACETFPLWS = (ACETFindProviderLookupWebservice)JSON.deserialize(ACETPLCtrl.PLDTWrapper.Service.replace('&#x27;', '\''), ACETFindProviderLookupWebservice.class);
        ACETFPLWS.queryPaginatedData(0, 5, 0);
        
        Test.stopTest();
    }
    
    //Exception because of invalid JSON in response for FindMedicalProviders
    static testMethod void ACETAAProviderLookupControllerTest4() {
        
        Map<String, String> TestISLWSConfigs = new Map<String, String>(); 
        TestISLWSConfigs.put('ISLConAccessToken', 'dfb379c2-06b7-46c4-8c6f-bbc390d1b854');
        TestISLWSConfigs.put('ISLOAuthContentType', 'application/x-www-form-urlencoded');
        TestISLWSConfigs.put('ISLOAuthGrantType', 'client_credentials');
        TestISLWSConfigs.put('OILHttpHeaderAccept', 'application/json;charset=UTF-8');
        TestISLWSConfigs.put('OILHttpHeaderActor', 'ACET');
        TestISLWSConfigs.put('OILHttpHeaderScope', 'read');
        TestISLWSConfigs.put('OILTimeout', '3000');
        TestISLWSConfigs.put('dev_ISLOAuthEndpoint', 'https://api-stg.optum.com:8443');
        TestISLWSConfigs.put('dev_findMedicalProviderAdapterEndpoint', '/api/alpha/eisl/providers/medicalproviders/v2.0/search');
        List<ISL_Webservice_Config__c> lstISLWSConfigs = ACETTestDataUtility.CreateISLWebserviceConfigurations(TestISLWSConfigs);
        insert lstISLWSConfigs;
        
        String ResponseJSON = '{"findMedicalProvidersResponse":{"errors":[{"code":"W008","name":"No records returned","severity":"low",';
        ResponseJSON += '"origin":"Consumer","description":"Consumer has requested a query for which no records have been found."}]';
        system.debug(LoggingLevel.INFO, 'Response JSON: ' + ResponseJSON);
        
     /*   Account oAccount = ACETTestDataUtility.CreateAccount('Test Account', 'TstTaxID1', 'TestEID1');
        insert oAccount;
        Contact oContact = ACETTestDataUtility.CreateContact(oAccount.Id, 'Test Contact LN', 'Test Contact FN', 'TstTaxID1', 'TestEID1', 'TestNPI1');
        insert oContact;*/
         RecordType newRecord = [SELECT Id FROM RecordType WHERE Name = 'Person Account' and SObjectType = 'Account'];
        
        Account accountTest = new Account();
        accountTest.FirstName = 'Test Contact FN1';
        accountTest.LastName = 'Test Contact LN1';
        accountTest.EID__c = 'TestEID1';
        accountTest.EID__pc = 'TestEID1';
        accountTest.RecordTypeId = newRecord.Id;
        insert accountTest;

    Account oAccount = [SELECT Id,personcontactid from Account where Id=:accountTest.Id];
        Contact oContact = [SELECT Id,LastName,FirstName,EID__c,AccountId from Contact where Id=:oAccount.personcontactid];
        
        
        Interaction__c oInteraction = ACETTestDataUtility.CreateInteraction(oContact.Id, 'Phone', 'Member', oContact.LastName);
        insert oInteraction;
        
        ACETHighlightsPanelAdditionalInfo AdditionalInfo = new ACETHighlightsPanelAdditionalInfo();
        AdditionalInfo.PolicyNumber = 'TestPolicyNumber';
        
        MockHttpCalloutResponseGenerator.MockHttpResponse OILTestResponse = new MockHttpCalloutResponseGenerator.MockHttpResponse(200, 'OK', ResponseJSON);
        OILTestResponse.TokenExpired = false;
        
        Test.startTest();
        
        MockHttpCalloutResponseGenerator MockHttpResponse = new MockHttpCalloutResponseGenerator(null, OILTestResponse);
        Test.setMock(HttpCalloutMock.class, MockHttpResponse);
        
        PageReference ACETPL = Page.ACETProviderLookup;
        ACETPL.getParameters().put('interactionId', oInteraction.Id);
        ACETPL.getParameters().put('benefitPlanId', 'BenefitPlanId1');
        ACETPL.getParameters().put('contactId', oContact.Id);
        ACETPL.getParameters().put('additionalInfo', JSON.serialize(AdditionalInfo));
        Test.setCurrentPageReference(ACETPL);
        
        ACETProviderLookupController ACETPLCtrl = new ACETProviderLookupController();
        ACETPLCtrl.NewpatientsInd = true;
        ACETPLCtrl.existingpatientsInd = true;
        ACETPLCtrl.FreeStandingFacl = false;
        ACETPLCtrl.phoneNumber = '1111111111';
        ACETPLCtrl.searchResults();
        
        ACETFindProviderLookupWebservice ACETFPLWS = (ACETFindProviderLookupWebservice)JSON.deserialize(ACETPLCtrl.PLDTWrapper.Service.replace('&#x27;', '\''), ACETFindProviderLookupWebservice.class);
        ACETFPLWS.queryPaginatedData(0, 5, 0);
        
        Test.stopTest();
    }
    
    //Success response for FindHCP, number of records found is greater than zero
    static testMethod void ACETAAProviderLookupControllerTest5() {
        
        Map<String, String> TestISLWSConfigs = new Map<String, String>(); 
        TestISLWSConfigs.put('ISLConAccessToken', 'dfb379c2-06b7-46c4-8c6f-bbc390d1b854');
        TestISLWSConfigs.put('ISLOAuthContentType', 'application/x-www-form-urlencoded');
        TestISLWSConfigs.put('ISLOAuthGrantType', 'client_credentials');
        TestISLWSConfigs.put('OILHttpHeaderAccept', 'application/json;charset=UTF-8');
        TestISLWSConfigs.put('OILHttpHeaderActor', 'ACET');
        TestISLWSConfigs.put('OILHttpHeaderScope', 'read');
        TestISLWSConfigs.put('OILTimeout', '3000');
        TestISLWSConfigs.put('dev_ISLOAuthEndpoint', 'https://api-stg.optum.com:8443');
        TestISLWSConfigs.put('dev_findMedicalProviderAdapterEndpoint', '/api/alpha/eisl/providers/medicalproviders/v2.0/search');
        List<ISL_Webservice_Config__c> lstISLWSConfigs = ACETTestDataUtility.CreateISLWebserviceConfigurations(TestISLWSConfigs);
        insert lstISLWSConfigs;
        
        StaticResource ResponseJSONSR = [SELECT Body FROM StaticResource WHERE Name = 'ACETFindMedicalHCPResponseJSON'];
        String ResponseJSON = ResponseJSONSR.Body.toString(); 
        system.debug(LoggingLevel.INFO, 'Response JSON: ' + ResponseJSON);
        
       /* Account oAccount = ACETTestDataUtility.CreateAccount('Test Account', 'TstTaxID1', 'TestEID1');
        insert oAccount;
        Contact oContact = ACETTestDataUtility.CreateContact(oAccount.Id, 'Test Contact LN', 'Test Contact FN', 'TstTaxID1', 'TestEID1', 'TestNPI1');
        insert oContact;*/
         RecordType newRecord = [SELECT Id FROM RecordType WHERE Name = 'Person Account' and SObjectType = 'Account'];
        
        Account accountTest = new Account();
        accountTest.FirstName = 'Test Contact FN1';
        accountTest.LastName = 'Test Contact LN1';
        accountTest.EID__c = 'TestEID1';
        accountTest.EID__pc = 'TestEID1';
        accountTest.RecordTypeId = newRecord.Id;
        insert accountTest;

    Account oAccount = [SELECT Id,personcontactid from Account where Id=:accountTest.Id];
        Contact oContact = [SELECT Id,LastName,FirstName,EID__c,AccountId from Contact where Id=:oAccount.personcontactid];
        
        
        Interaction__c oInteraction = ACETTestDataUtility.CreateInteraction(oContact.Id, 'Phone', 'Member', oContact.LastName);
        insert oInteraction;
        
        ACETHighlightsPanelAdditionalInfo AdditionalInfo = new ACETHighlightsPanelAdditionalInfo();
        AdditionalInfo.PolicyNumber = 'TestPolicyNumber';
        
        MockHttpCalloutResponseGenerator.MockHttpResponse OILTestResponse = new MockHttpCalloutResponseGenerator.MockHttpResponse(200, 'OK', ResponseJSON);
        OILTestResponse.TokenExpired = false;
        
        Test.startTest();
        
        MockHttpCalloutResponseGenerator MockHttpResponse = new MockHttpCalloutResponseGenerator(null, OILTestResponse);
        Test.setMock(HttpCalloutMock.class, MockHttpResponse);
        
        PageReference ACETPL = Page.ACETProviderLookup;
        ACETPL.getParameters().put('interactionId', oInteraction.Id);
        ACETPL.getParameters().put('benefitPlanId', 'BenefitPlanId1');
        ACETPL.getParameters().put('contactId', oContact.Id);
        ACETPL.getParameters().put('additionalInfo', JSON.serialize(AdditionalInfo));
        Test.setCurrentPageReference(ACETPL);
        
        ACETProviderLookupController ACETPLCtrl = new ACETProviderLookupController();
        ACETPLCtrl.NewpatientsInd = true;
        ACETPLCtrl.existingpatientsInd = true;
        ACETPLCtrl.FreeStandingFacl = false;
        ACETPLCtrl.phoneNumber = '1111111111';
        ACETPLCtrl.networkval = 'Freedom';
        ACETPLCtrl.LanguageVal = 'American Sign Language';
        ACETPLCtrl.showNonParChckBox = false;
        ACETPLCtrl.providerType = 'Physician';
        List<SelectOption> languagecmdt = ACETPLCtrl.languagescmdt;
        ACETPLCtrl.searchResults();
        
        ACETFindHCPWebservice ACETFPLWS = (ACETFindHCPWebservice)JSON.deserialize(ACETPLCtrl.PLDTWrapper.Service.replace('&#x27;', '\''), ACETFindHCPWebservice.class);
        ACETFPLWS.queryPaginatedData(0, 5, 0);
        
        Test.stopTest();
    }
    
    //Success response for FindHCP, number of records found is zero
    static testMethod void ACETAAProviderLookupControllerTest6() {
        
        Map<String, String> TestISLWSConfigs = new Map<String, String>(); 
        TestISLWSConfigs.put('ISLConAccessToken', 'dfb379c2-06b7-46c4-8c6f-bbc390d1b854');
        TestISLWSConfigs.put('ISLOAuthContentType', 'application/x-www-form-urlencoded');
        TestISLWSConfigs.put('ISLOAuthGrantType', 'client_credentials');
        TestISLWSConfigs.put('OILHttpHeaderAccept', 'application/json;charset=UTF-8');
        TestISLWSConfigs.put('OILHttpHeaderActor', 'ACET');
        TestISLWSConfigs.put('OILHttpHeaderScope', 'read');
        TestISLWSConfigs.put('OILTimeout', '3000');
        TestISLWSConfigs.put('dev_ISLOAuthEndpoint', 'https://api-stg.optum.com:8443');
        TestISLWSConfigs.put('dev_findMedicalProviderAdapterEndpoint', '/api/alpha/eisl/providers/medicalproviders/v2.0/search');
        List<ISL_Webservice_Config__c> lstISLWSConfigs = ACETTestDataUtility.CreateISLWebserviceConfigurations(TestISLWSConfigs);
        insert lstISLWSConfigs;
        
        String ResponseJSON = '{"findMedicalHealthcareProfessionalsResponse":{"errors":[{"code":"W008","name":"No records returned",';
        ResponseJSON += '"severity":"low","origin":"Consumer","description":"Consumer has requested a query for which no records have been found.';
        ResponseJSON += '"}],"pagination":{"pageNumber":"0","pageSize":"2","recordCount":"0","totalCount":"0","totalPages":"0"}}}}'; 
        
        system.debug(LoggingLevel.INFO, 'Response JSON: ' + ResponseJSON);
        
      /*  Account oAccount = ACETTestDataUtility.CreateAccount('Test Account', 'TstTaxID1', 'TestEID1');
        insert oAccount;
        Contact oContact = ACETTestDataUtility.CreateContact(oAccount.Id, 'Test Contact LN', 'Test Contact FN', 'TstTaxID1', 'TestEID1', 'TestNPI1');
        insert oContact;*/
         RecordType newRecord = [SELECT Id FROM RecordType WHERE Name = 'Person Account' and SObjectType = 'Account'];
        
        Account accountTest = new Account();
        accountTest.FirstName = 'Test Contact FN1';
        accountTest.LastName = 'Test Contact LN1';
        accountTest.EID__c = 'TestEID1';
        accountTest.EID__pc = 'TestEID1';
        accountTest.RecordTypeId = newRecord.Id;
        insert accountTest;

    Account oAccount = [SELECT Id,personcontactid from Account where Id=:accountTest.Id];
        Contact oContact = [SELECT Id,LastName,FirstName,EID__c,AccountId from Contact where Id=:oAccount.personcontactid];
        
        
        Interaction__c oInteraction = ACETTestDataUtility.CreateInteraction(oContact.Id, 'Phone', 'Member', oContact.LastName);
        insert oInteraction;
        
        ACETHighlightsPanelAdditionalInfo AdditionalInfo = new ACETHighlightsPanelAdditionalInfo();
        AdditionalInfo.PolicyNumber = 'TestPolicyNumber';
        
        MockHttpCalloutResponseGenerator.MockHttpResponse OILTestResponse = new MockHttpCalloutResponseGenerator.MockHttpResponse(200, 'OK', ResponseJSON);
        OILTestResponse.TokenExpired = false;
        
        Test.startTest();
        
        MockHttpCalloutResponseGenerator MockHttpResponse = new MockHttpCalloutResponseGenerator(null, OILTestResponse);
        Test.setMock(HttpCalloutMock.class, MockHttpResponse);
        
        PageReference ACETPL = Page.ACETProviderLookup;
        ACETPL.getParameters().put('interactionId', oInteraction.Id);
        ACETPL.getParameters().put('benefitPlanId', 'BenefitPlanId1');
        ACETPL.getParameters().put('contactId', oContact.Id);
        ACETPL.getParameters().put('additionalInfo', JSON.serialize(AdditionalInfo));
        Test.setCurrentPageReference(ACETPL);
        
        ACETProviderLookupController ACETPLCtrl = new ACETProviderLookupController();
        ACETPLCtrl.NewpatientsInd = false;
        ACETPLCtrl.existingpatientsInd = false;
        ACETPLCtrl.FreeStandingFacl = false;
        ACETPLCtrl.phoneNumber = '1111111111';
        ACETPLCtrl.showNonParChckBox = true;
        ACETPLCtrl.selectedSpeciality = 'Acupuncturist';
        ACETPLCtrl.providerType = 'Physician';
        ACETPLCtrl.searchResults();
        
        ACETFindHCPWebservice ACETFPLWS = (ACETFindHCPWebservice)JSON.deserialize(ACETPLCtrl.PLDTWrapper.Service.replace('&#x27;', '\''), ACETFindHCPWebservice.class);
        ACETFPLWS.queryPaginatedData(0, 5, 0);
        
        Test.stopTest();
    }
    
    //Error response for FindHCP
    static testMethod void ACETAAProviderLookupControllerTest7() {
        
        Map<String, String> TestISLWSConfigs = new Map<String, String>(); 
        TestISLWSConfigs.put('ISLConAccessToken', 'dfb379c2-06b7-46c4-8c6f-bbc390d1b854');
        TestISLWSConfigs.put('ISLOAuthContentType', 'application/x-www-form-urlencoded');
        TestISLWSConfigs.put('ISLOAuthGrantType', 'client_credentials');
        TestISLWSConfigs.put('OILHttpHeaderAccept', 'application/json;charset=UTF-8');
        TestISLWSConfigs.put('OILHttpHeaderActor', 'ACET');
        TestISLWSConfigs.put('OILHttpHeaderScope', 'read');
        TestISLWSConfigs.put('OILTimeout', '3000');
        TestISLWSConfigs.put('dev_ISLOAuthEndpoint', 'https://api-stg.optum.com:8443');
        TestISLWSConfigs.put('dev_findMedicalProviderAdapterEndpoint', '/api/alpha/eisl/providers/medicalproviders/v2.0/search');
        List<ISL_Webservice_Config__c> lstISLWSConfigs = ACETTestDataUtility.CreateISLWebserviceConfigurations(TestISLWSConfigs);
        insert lstISLWSConfigs;
        
        String ResponseJSON = '{"findMedicalHealthcareProfessionalsResult":{"errors":[{"code":"W008","name":"No records returned","severity":"low",';
        ResponseJSON += '"origin":"Consumer","description":"Consumer has requested a query for which no records have been found."}]}}'; 
        
        system.debug(LoggingLevel.INFO, 'Response JSON: ' + ResponseJSON);
        
        /*Account oAccount = ACETTestDataUtility.CreateAccount('Test Account', 'TstTaxID1', 'TestEID1');
        insert oAccount;
        Contact oContact = ACETTestDataUtility.CreateContact(oAccount.Id, 'Test Contact LN', 'Test Contact FN', 'TstTaxID1', 'TestEID1', 'TestNPI1');
        insert oContact;*/
         RecordType newRecord = [SELECT Id FROM RecordType WHERE Name = 'Person Account' and SObjectType = 'Account'];
        
        Account accountTest = new Account();
        accountTest.FirstName = 'Test Contact FN1';
        accountTest.LastName = 'Test Contact LN1';
        accountTest.EID__c = 'TestEID1';
        accountTest.EID__pc = 'TestEID1';
        accountTest.RecordTypeId = newRecord.Id;
        insert accountTest;

    Account oAccount = [SELECT Id,personcontactid from Account where Id=:accountTest.Id];
        Contact oContact = [SELECT Id,LastName,FirstName,EID__c,AccountId from Contact where Id=:oAccount.personcontactid];
        
        
        Interaction__c oInteraction = ACETTestDataUtility.CreateInteraction(oContact.Id, 'Phone', 'Member', oContact.LastName);
        insert oInteraction;
        
        ACETHighlightsPanelAdditionalInfo AdditionalInfo = new ACETHighlightsPanelAdditionalInfo();
        AdditionalInfo.PolicyNumber = 'TestPolicyNumber';
        
        MockHttpCalloutResponseGenerator.MockHttpResponse oilTestResponse = new MockHttpCalloutResponseGenerator.MockHttpResponse(500, status500, ResponseJSON);
        oilTestResponse.TokenExpired = false;
        
        Test.startTest();
        
        MockHttpCalloutResponseGenerator mockHttpResponse = new MockHttpCalloutResponseGenerator(null, oilTestResponse);
        Test.setMock(HttpCalloutMock.class, mockHttpResponse);
        
        PageReference ACETPL = Page.ACETProviderLookup;
        ACETPL.getParameters().put('interactionId', oInteraction.Id);
        ACETPL.getParameters().put('benefitPlanId', 'BenefitPlanId1');
        ACETPL.getParameters().put('contactId', oContact.Id);
        ACETPL.getParameters().put('additionalInfo', JSON.serialize(AdditionalInfo));
        Test.setCurrentPageReference(ACETPL);
        
        ACETProviderLookupController ACETPLCtrl = new ACETProviderLookupController();
        ACETPLCtrl.NewpatientsInd = true;
        ACETPLCtrl.existingpatientsInd = true;
        ACETPLCtrl.FreeStandingFacl = true;
        ACETPLCtrl.phoneNumber = '1111111111';
        ACETPLCtrl.providerType = 'Physician';
        ACETPLCtrl.searchResults();
        
        ACETFindHCPWebservice ACETFPLWS = (ACETFindHCPWebservice)JSON.deserialize(ACETPLCtrl.PLDTWrapper.Service.replace('&#x27;', '\''), ACETFindHCPWebservice.class);
        ACETFPLWS.queryPaginatedData(0, 5, 0);
        
        Test.stopTest();
    }
    
    //Exception because of invalid JSON in response for FindHCP
    static testMethod void ACETAAProviderLookupControllerTest8() {
        
        Map<String, String> TestISLWSConfigs = new Map<String, String>(); 
        TestISLWSConfigs.put('ISLConAccessToken', 'dfb379c2-06b7-46c4-8c6f-bbc390d1b854');
        TestISLWSConfigs.put('ISLOAuthContentType', 'application/x-www-form-urlencoded');
        TestISLWSConfigs.put('ISLOAuthGrantType', 'client_credentials');
        TestISLWSConfigs.put('OILHttpHeaderAccept', 'application/json;charset=UTF-8');
        TestISLWSConfigs.put('OILHttpHeaderActor', 'ACET');
        TestISLWSConfigs.put('OILHttpHeaderScope', 'read');
        TestISLWSConfigs.put('OILTimeout', '3000');
        TestISLWSConfigs.put('dev_ISLOAuthEndpoint', 'https://api-stg.optum.com:8443');
        TestISLWSConfigs.put('dev_findMedicalProviderAdapterEndpoint', '/api/alpha/eisl/providers/medicalproviders/v2.0/search');
        List<ISL_Webservice_Config__c> lstISLWSConfigs = ACETTestDataUtility.CreateISLWebserviceConfigurations(TestISLWSConfigs);
        insert lstISLWSConfigs;
        
        String ResponseJSON = '{"findMedicalHealthcareProfessionalsResult":{"errors":[{"code":"W008","name":"No records returned","severity":"low",';
        ResponseJSON += '"origin":"Consumer","description":"Consumer has requested a query for which no records have been found."}]';
        system.debug(LoggingLevel.INFO, 'Response JSON: ' + ResponseJSON);
        
       /* Account oAccount = ACETTestDataUtility.CreateAccount('Test Account', 'TstTaxID1', 'TestEID1');
        insert oAccount;
        Contact oContact = ACETTestDataUtility.CreateContact(oAccount.Id, 'Test Contact LN', 'Test Contact FN', 'TstTaxID1', 'TestEID1', 'TestNPI1');
        insert oContact;*/
         RecordType newRecord = [SELECT Id FROM RecordType WHERE Name = 'Person Account' and SObjectType = 'Account'];
        
        Account accountTest = new Account();
        accountTest.FirstName = 'Test Contact FN1';
        accountTest.LastName = 'Test Contact LN1';
        accountTest.EID__c = 'TestEID1';
        accountTest.EID__pc = 'TestEID1';
        accountTest.RecordTypeId = newRecord.Id;
        insert accountTest;

    Account oAccount = [SELECT Id,personcontactid from Account where Id=:accountTest.Id];
        Contact oContact = [SELECT Id,LastName,FirstName,EID__c,AccountId from Contact where Id=:oAccount.personcontactid];
        
        
        Interaction__c oInteraction = ACETTestDataUtility.CreateInteraction(oContact.Id, 'Phone', 'Member', oContact.LastName);
        insert oInteraction;
        
        ACETHighlightsPanelAdditionalInfo AdditionalInfo = new ACETHighlightsPanelAdditionalInfo();
        AdditionalInfo.PolicyNumber = 'TestPolicyNumber';
        
        MockHttpCalloutResponseGenerator.MockHttpResponse OILTestResponse = new MockHttpCalloutResponseGenerator.MockHttpResponse(200, 'OK', ResponseJSON);
        OILTestResponse.TokenExpired = false;
        
        Test.startTest();
        
        MockHttpCalloutResponseGenerator MockHttpResponse = new MockHttpCalloutResponseGenerator(null, OILTestResponse);
        Test.setMock(HttpCalloutMock.class, MockHttpResponse);
        
        PageReference ACETPL = Page.ACETProviderLookup;
        ACETPL.getParameters().put('interactionId', oInteraction.Id);
        ACETPL.getParameters().put('benefitPlanId', 'BenefitPlanId1');
        ACETPL.getParameters().put('contactId', oContact.Id);
        ACETPL.getParameters().put('additionalInfo', JSON.serialize(AdditionalInfo));
        Test.setCurrentPageReference(ACETPL);
        
        ACETProviderLookupController ACETPLCtrl = new ACETProviderLookupController();
        ACETPLCtrl.NewpatientsInd = true;
        ACETPLCtrl.existingpatientsInd = true;
        ACETPLCtrl.FreeStandingFacl = true;
        ACETPLCtrl.phoneNumber = '1111111111';
        ACETPLCtrl.providerType = 'Physician';
        ACETPLCtrl.searchResults();
        
        ACETFindHCPWebservice ACETFPLWS = (ACETFindHCPWebservice)JSON.deserialize(ACETPLCtrl.PLDTWrapper.Service.replace('&#x27;', '\''), ACETFindHCPWebservice.class);
        ACETFPLWS.queryPaginatedData(0, 5, 0);
        
        Test.stopTest();
    }
    
    //Success response for FindHCO, number of records found is greater than zero
    static testMethod void ACETAAProviderLookupControllerTest9() {
        
        Map<String, String> TestISLWSConfigs = new Map<String, String>(); 
        TestISLWSConfigs.put('ISLConAccessToken', 'dfb379c2-06b7-46c4-8c6f-bbc390d1b854');
        TestISLWSConfigs.put('ISLOAuthContentType', 'application/x-www-form-urlencoded');
        TestISLWSConfigs.put('ISLOAuthGrantType', 'client_credentials');
        TestISLWSConfigs.put('OILHttpHeaderAccept', 'application/json;charset=UTF-8');
        TestISLWSConfigs.put('OILHttpHeaderActor', 'ACET');
        TestISLWSConfigs.put('OILHttpHeaderScope', 'read');
        TestISLWSConfigs.put('OILTimeout', '3000');
        TestISLWSConfigs.put('dev_ISLOAuthEndpoint', 'https://api-stg.optum.com:8443');
        TestISLWSConfigs.put('dev_findMedicalProviderAdapterEndpoint', '/api/alpha/eisl/providers/medicalproviders/v2.0/search');
        List<ISL_Webservice_Config__c> lstISLWSConfigs = ACETTestDataUtility.CreateISLWebserviceConfigurations(TestISLWSConfigs);
        insert lstISLWSConfigs;
        
        StaticResource ResponseJSONSR = [SELECT Body FROM StaticResource WHERE Name = 'ACETFindMedicalHCOResponseJSON'];
        String ResponseJSON = ResponseJSONSR.Body.toString(); 
        system.debug(LoggingLevel.INFO, 'Response JSON: ' + ResponseJSON);
        
      /*  Account oAccount = ACETTestDataUtility.CreateAccount('Test Account', 'TstTaxID1', 'TestEID1');
        insert oAccount;
        Contact oContact = ACETTestDataUtility.CreateContact(oAccount.Id, 'Test Contact LN', 'Test Contact FN', 'TstTaxID1', 'TestEID1', 'TestNPI1');
        insert oContact;*/
         RecordType newRecord = [SELECT Id FROM RecordType WHERE Name = 'Person Account' and SObjectType = 'Account'];
        
        Account accountTest = new Account();
        accountTest.FirstName = 'Test Contact FN1';
        accountTest.LastName = 'Test Contact LN1';
        accountTest.EID__c = 'TestEID1';
        accountTest.EID__pc = 'TestEID1';
        accountTest.RecordTypeId = newRecord.Id;
        insert accountTest;

    Account oAccount = [SELECT Id,personcontactid from Account where Id=:accountTest.Id];
        Contact oContact = [SELECT Id,LastName,FirstName,EID__c,AccountId from Contact where Id=:oAccount.personcontactid];
        
        
        Interaction__c oInteraction = ACETTestDataUtility.CreateInteraction(oContact.Id, 'Phone', 'Member', oContact.LastName);
        insert oInteraction;
        
        ACETHighlightsPanelAdditionalInfo AdditionalInfo = new ACETHighlightsPanelAdditionalInfo();
        AdditionalInfo.PolicyNumber = 'TestPolicyNumber';
        
        MockHttpCalloutResponseGenerator.MockHttpResponse OILTestResponse = new MockHttpCalloutResponseGenerator.MockHttpResponse(200, 'OK', ResponseJSON);
        OILTestResponse.TokenExpired = false;
        
        Test.startTest();
        
        MockHttpCalloutResponseGenerator MockHttpResponse = new MockHttpCalloutResponseGenerator(null, OILTestResponse);
        Test.setMock(HttpCalloutMock.class, MockHttpResponse);
        
        PageReference ACETPL = Page.ACETProviderLookup;
        ACETPL.getParameters().put('interactionId', oInteraction.Id);
        ACETPL.getParameters().put('benefitPlanId', 'BenefitPlanId1');
        ACETPL.getParameters().put('contactId', oContact.Id);
        ACETPL.getParameters().put('additionalInfo', JSON.serialize(AdditionalInfo));
        Test.setCurrentPageReference(ACETPL);
        
        ACETProviderLookupController ACETPLCtrl = new ACETProviderLookupController();
        ACETPLCtrl.NewpatientsInd = true;
        ACETPLCtrl.existingpatientsInd = true;
        ACETPLCtrl.FreeStandingFacl = true;
        ACETPLCtrl.phoneNumber = '1111111111';
        ACETPLCtrl.networkval = 'Freedom';
        ACETPLCtrl.LanguageVal = 'American Sign Language';
        ACETPLCtrl.showNonParChckBox = false;
        ACETPLCtrl.providerType = 'Facility';
		ACETPLCtrl.isDDP = true;						
        List<SelectOption> laguagecmdt = ACETPLCtrl.languagescmdt;
        ACETPLCtrl.searchResults();
        
        ACETFindHCOWebservice ACETFPLWS = (ACETFindHCOWebservice)JSON.deserialize(ACETPLCtrl.PLDTWrapper.Service.replace('&#x27;', '\''), ACETFindHCOWebservice.class);
        ACETFPLWS.queryPaginatedData(0, 5, 0);
        
        Test.stopTest();
    }
    
    //Success response for FindHCO, number of records found is zero
    static testMethod void ACETAAProviderLookupControllerTest10() {
        
        Map<String, String> TestISLWSConfigs = new Map<String, String>(); 
        TestISLWSConfigs.put('ISLConAccessToken', 'dfb379c2-06b7-46c4-8c6f-bbc390d1b854');
        TestISLWSConfigs.put('ISLOAuthContentType', 'application/x-www-form-urlencoded');
        TestISLWSConfigs.put('ISLOAuthGrantType', 'client_credentials');
        TestISLWSConfigs.put('OILHttpHeaderAccept', 'application/json;charset=UTF-8');
        TestISLWSConfigs.put('OILHttpHeaderActor', 'ACET');
        TestISLWSConfigs.put('OILHttpHeaderScope', 'read');
        TestISLWSConfigs.put('OILTimeout', '3000');
        TestISLWSConfigs.put('dev_ISLOAuthEndpoint', 'https://api-stg.optum.com:8443');
        TestISLWSConfigs.put('dev_findMedicalProviderAdapterEndpoint', '/api/alpha/eisl/providers/medicalproviders/v2.0/search');
        List<ISL_Webservice_Config__c> lstISLWSConfigs = ACETTestDataUtility.CreateISLWebserviceConfigurations(TestISLWSConfigs);
        insert lstISLWSConfigs;
        
        String ResponseJSON = '{"findMedicalHealthcareOrganizationsResult":{"findMedicalHealthcareOrganizationsResponseType":{"errors":[{"code":"W008","name":"No records returned",';
        ResponseJSON += '"severity":"low","origin":"Consumer","description":"Consumer has requested a query for which no records have been found.';
        ResponseJSON += '"}],"pagination":{"pageNumber":"0","pageSize":"2","recordCount":"0","totalCount":"0","totalPages":"0"}}}}'; 
        
        system.debug(LoggingLevel.INFO, 'Response JSON: ' + ResponseJSON);
        
      /*  Account oAccount = ACETTestDataUtility.CreateAccount('Test Account', 'TstTaxID1', 'TestEID1');
        insert oAccount;
        Contact oContact = ACETTestDataUtility.CreateContact(oAccount.Id, 'Test Contact LN', 'Test Contact FN', 'TstTaxID1', 'TestEID1', 'TestNPI1');
        insert oContact;*/
         RecordType newRecord = [SELECT Id FROM RecordType WHERE Name = 'Person Account' and SObjectType = 'Account'];
        
        Account accountTest = new Account();
        accountTest.FirstName = 'Test Contact FN1';
        accountTest.LastName = 'Test Contact LN1';
        accountTest.EID__c = 'TestEID1';
        accountTest.EID__pc = 'TestEID1';
        accountTest.RecordTypeId = newRecord.Id;
        insert accountTest;

    Account oAccount = [SELECT Id,personcontactid from Account where Id=:accountTest.Id];
        Contact oContact = [SELECT Id,LastName,FirstName,EID__c,AccountId from Contact where Id=:oAccount.personcontactid];
        
        
        Interaction__c oInteraction = ACETTestDataUtility.CreateInteraction(oContact.Id, 'Phone', 'Member', oContact.LastName);
        insert oInteraction;
        
        ACETHighlightsPanelAdditionalInfo AdditionalInfo = new ACETHighlightsPanelAdditionalInfo();
        AdditionalInfo.PolicyNumber = 'TestPolicyNumber';
        
        MockHttpCalloutResponseGenerator.MockHttpResponse OILTestResponse = new MockHttpCalloutResponseGenerator.MockHttpResponse(200, 'OK', ResponseJSON);
        OILTestResponse.TokenExpired = false;
        
        Test.startTest();
        
        MockHttpCalloutResponseGenerator MockHttpResponse = new MockHttpCalloutResponseGenerator(null, OILTestResponse);
        Test.setMock(HttpCalloutMock.class, MockHttpResponse);
        
        PageReference ACETPL = Page.ACETProviderLookup;
        ACETPL.getParameters().put('interactionId', oInteraction.Id);
        ACETPL.getParameters().put('benefitPlanId', 'BenefitPlanId1');
        ACETPL.getParameters().put('contactId', oContact.Id);
        ACETPL.getParameters().put('additionalInfo', JSON.serialize(AdditionalInfo));
        Test.setCurrentPageReference(ACETPL);
        
        ACETProviderLookupController ACETPLCtrl = new ACETProviderLookupController();
        ACETPLCtrl.NewpatientsInd = false;
        ACETPLCtrl.existingpatientsInd = false;
        ACETPLCtrl.FreeStandingFacl = false;
        ACETPLCtrl.phoneNumber = '1111111111';
        ACETPLCtrl.showNonParChckBox = true;
        ACETPLCtrl.selectedSpeciality = 'Acupuncturist';
        ACETPLCtrl.providerType = 'Facility';
        ACETPLCtrl.searchResults();
        
        ACETFindHCOWebservice ACETFPLWS = (ACETFindHCOWebservice)JSON.deserialize(ACETPLCtrl.PLDTWrapper.Service.replace('&#x27;', '\''), ACETFindHCOWebservice.class);
        ACETFPLWS.queryPaginatedData(0, 5, 0);
        
        Test.stopTest();
    }
    
    //Success response for FindHCO, number of records found is zero
    static testMethod void ACETAAProviderLookupControllerTest11() {
        
        Map<String, String> TestISLWSConfigs = new Map<String, String>(); 
        TestISLWSConfigs.put('ISLConAccessToken', 'dfb379c2-06b7-46c4-8c6f-bbc390d1b854');
        TestISLWSConfigs.put('ISLOAuthContentType', 'application/x-www-form-urlencoded');
        TestISLWSConfigs.put('ISLOAuthGrantType', 'client_credentials');
        TestISLWSConfigs.put('OILHttpHeaderAccept', 'application/json;charset=UTF-8');
        TestISLWSConfigs.put('OILHttpHeaderActor', 'ACET');
        TestISLWSConfigs.put('OILHttpHeaderScope', 'read');
        TestISLWSConfigs.put('OILTimeout', '3000');
        TestISLWSConfigs.put('dev_ISLOAuthEndpoint', 'https://api-stg.optum.com:8443');
        TestISLWSConfigs.put('dev_findMedicalProviderAdapterEndpoint', '/api/alpha/eisl/providers/medicalproviders/v2.0/search');
        List<ISL_Webservice_Config__c> lstISLWSConfigs = ACETTestDataUtility.CreateISLWebserviceConfigurations(TestISLWSConfigs);
        insert lstISLWSConfigs;
        
        String ResponseJSON = '{"findMedicalHealthcareOrganizationsResponse":{"errors":[{"code":"W008","name":"No records returned",';
        ResponseJSON += '"severity":"low","origin":"Consumer","description":"Consumer has requested a query for which no records have been found.';
        ResponseJSON += '"}, {"code":"W008","name":"No records returned", "severity":"low","origin":"Consumer","description":"Consumer has ';
        ResponseJSON += 'requested a query for which no records have been found."}],"pagination":{"pageNumber":"0","pageSize":"2","recordCount":"0","totalCount":"0","totalPages":"0"}}}'; 
        ResponseJSON =  ACETTestDataUtility.findHCOAdapterJSON();
        system.debug(LoggingLevel.INFO, 'Response JSON: ' + ResponseJSON);
        
      /*  Account oAccount = ACETTestDataUtility.CreateAccount('Test Account', 'TstTaxID1', 'TestEID1');
        insert oAccount;
        Contact oContact = ACETTestDataUtility.CreateContact(oAccount.Id, 'Test Contact LN', 'Test Contact FN', 'TstTaxID1', 'TestEID1', 'TestNPI1');
        insert oContact;*/
         RecordType newRecord = [SELECT Id FROM RecordType WHERE Name = 'Person Account' and SObjectType = 'Account'];
        
        Account accountTest = new Account();
        accountTest.FirstName = 'Test Contact FN1';
        accountTest.LastName = 'Test Contact LN1';
        accountTest.EID__c = 'TestEID1';
        accountTest.EID__pc = 'TestEID1';
        accountTest.RecordTypeId = newRecord.Id;
        insert accountTest;

    Account oAccount = [SELECT Id,personcontactid from Account where Id=:accountTest.Id];
        Contact oContact = [SELECT Id,LastName,FirstName,EID__c,AccountId from Contact where Id=:oAccount.personcontactid];
        
        
        Interaction__c oInteraction = ACETTestDataUtility.CreateInteraction(oContact.Id, 'Phone', 'Member', oContact.LastName);
        insert oInteraction;
        
        ACETHighlightsPanelAdditionalInfo AdditionalInfo = new ACETHighlightsPanelAdditionalInfo();
        AdditionalInfo.PolicyNumber = 'TestPolicyNumber';
        
        MockHttpCalloutResponseGenerator.MockHttpResponse OILTestResponse = new MockHttpCalloutResponseGenerator.MockHttpResponse(200, 'OK', ResponseJSON);
        OILTestResponse.TokenExpired = false;
        
		MockHttpCalloutResponseGenerator.MockHttpResponse OAuthResponse = new MockHttpCalloutResponseGenerator.MockHttpResponse(200, 'OK', ResponseJSON);
        OAuthResponse.TokenExpired = false;
        Test.startTest();
        
        MockHttpCalloutResponseGenerator MockHttpResponse = new MockHttpCalloutResponseGenerator(OAuthResponse, OILTestResponse);
        Test.setMock(HttpCalloutMock.class, MockHttpResponse);
        
        PageReference ACETPL = Page.ACETProviderLookup;
        ACETPL.getParameters().put('interactionId', oInteraction.Id);
        ACETPL.getParameters().put('benefitPlanId', 'BenefitPlanId1');
        ACETPL.getParameters().put('contactId', oContact.Id);
        ACETPL.getParameters().put('additionalInfo', JSON.serialize(AdditionalInfo));
        Test.setCurrentPageReference(ACETPL);
        
        ACETProviderLookupController ACETPLCtrl = new ACETProviderLookupController();
        ACETPLCtrl.NewpatientsInd = false;
        ACETPLCtrl.existingpatientsInd = false;
        ACETPLCtrl.FreeStandingFacl = false;
        ACETPLCtrl.phoneNumber = '1111111111';
        ACETPLCtrl.showNonParChckBox = true;
        ACETPLCtrl.selectedSpeciality = 'Acupuncturist';
        ACETPLCtrl.providerType = 'Facility';
		ACETPLCtrl.isDDP = true;
        ACETPLCtrl.searchResults();
        
        ACETFindHCOWebservice ACETFPLWS = (ACETFindHCOWebservice)JSON.deserialize(ACETPLCtrl.PLDTWrapper.Service.replace('&#x27;', '\''), ACETFindHCOWebservice.class);
        ACETFPLWS.queryPaginatedData(0, 5, 0);
        
        Test.stopTest();
    }
    
    static testMethod void ACETAAProviderLookupControllerTest12() {
        
        Map<String, String> TestISLWSConfigs = new Map<String, String>(); 
        TestISLWSConfigs.put('ISLConAccessToken', 'dfb379c2-06b7-46c4-8c6f-bbc390d1b854');
        TestISLWSConfigs.put('ISLOAuthContentType', 'application/x-www-form-urlencoded');
        TestISLWSConfigs.put('ISLOAuthGrantType', 'client_credentials');
        TestISLWSConfigs.put('OILHttpHeaderAccept', 'application/json;charset=UTF-8');
        TestISLWSConfigs.put('OILHttpHeaderActor', 'ACET');
        TestISLWSConfigs.put('OILHttpHeaderScope', 'read');
        TestISLWSConfigs.put('OILTimeout', '3000');
        TestISLWSConfigs.put('dev_ISLOAuthEndpoint', 'https://api-stg.optum.com:8443');
        TestISLWSConfigs.put('dev_findMedicalProviderAdapterEndpoint', '/api/alpha/eisl/providers/medicalproviders/v2.0/search');
        List<ISL_Webservice_Config__c> lstISLWSConfigs = ACETTestDataUtility.CreateISLWebserviceConfigurations(TestISLWSConfigs);
        insert lstISLWSConfigs;
        
        String ResponseJSON = '{"findMedicalHealthcareOrganizationsResponse":{"errors":[{"code":"W008","name":"No records returned",';
        ResponseJSON += '"severity":"low","origin":"Consumer","description":"Consumer has requested a query for which no records have been found.';
        ResponseJSON += '"}, {"code":"W008","name":"No records returned", "severity":"low","origin":"Consumer","description":"Consumer has ';
        ResponseJSON += 'requested a query for which no records have been found."},{"code":"W008","name":"No records returned", "severity":"low",';
        ResponseJSON += '"origin":"Consumer","description":"Consumer has requested a query for which no records have been found."},{"code":"W008",';
        ResponseJSON += '"name":"No records returned", "severity":"low","origin":"Consumer","description":"Consumer has requested a query for which ';
        ResponseJSON += 'no records have been found."}],"pagination":{"pageNumber":"0","pageSize":"2","recordCount":"0","totalCount":"0","totalPages":"0"}}}'; 
        
        system.debug(LoggingLevel.INFO, 'Response JSON: ' + ResponseJSON);
        
       /* Account oAccount = ACETTestDataUtility.CreateAccount('Test Account', 'TstTaxID1', 'TestEID1');
        insert oAccount;
        Contact oContact = ACETTestDataUtility.CreateContact(oAccount.Id, 'Test Contact LN', 'Test Contact FN', 'TstTaxID1', 'TestEID1', 'TestNPI1');
        insert oContact;*/
         RecordType newRecord = [SELECT Id FROM RecordType WHERE Name = 'Person Account' and SObjectType = 'Account'];
        
        Account accountTest = new Account();
        accountTest.FirstName = 'Test Contact FN1';
        accountTest.LastName = 'Test Contact LN1';
        accountTest.EID__c = 'TestEID1';
        accountTest.EID__pc = 'TestEID1';
        accountTest.RecordTypeId = newRecord.Id;
        insert accountTest;

    Account oAccount = [SELECT Id,personcontactid from Account where Id=:accountTest.Id];
        Contact oContact = [SELECT Id,LastName,FirstName,EID__c,AccountId from Contact where Id=:oAccount.personcontactid];
        
        
        Interaction__c oInteraction = ACETTestDataUtility.CreateInteraction(oContact.Id, 'Phone', 'Member', oContact.LastName);
        insert oInteraction;
        
        ACETHighlightsPanelAdditionalInfo AdditionalInfo = new ACETHighlightsPanelAdditionalInfo();
        AdditionalInfo.PolicyNumber = 'TestPolicyNumber';
        
        MockHttpCalloutResponseGenerator.MockHttpResponse OILTestResponse = new MockHttpCalloutResponseGenerator.MockHttpResponse(200, 'OK', ResponseJSON);
        OILTestResponse.TokenExpired = false;
        
        Test.startTest();
        
        MockHttpCalloutResponseGenerator MockHttpResponse = new MockHttpCalloutResponseGenerator(null, OILTestResponse);
        Test.setMock(HttpCalloutMock.class, MockHttpResponse);
        
        PageReference ACETPL = Page.ACETProviderLookup;
        ACETPL.getParameters().put('interactionId', oInteraction.Id);
        ACETPL.getParameters().put('benefitPlanId', 'BenefitPlanId1');
        ACETPL.getParameters().put('contactId', oContact.Id);
        ACETPL.getParameters().put('additionalInfo', JSON.serialize(AdditionalInfo));
        Test.setCurrentPageReference(ACETPL);
        
        ACETProviderLookupController ACETPLCtrl = new ACETProviderLookupController();
        ACETPLCtrl.NewpatientsInd = false;
        ACETPLCtrl.existingpatientsInd = false;
        ACETPLCtrl.FreeStandingFacl = false;
        ACETPLCtrl.phoneNumber = '1111111111';
        ACETPLCtrl.showNonParChckBox = true;
        ACETPLCtrl.selectedSpeciality = 'Acupuncturist';
        ACETPLCtrl.providerType = 'Facility';
        ACETPLCtrl.searchResults();
        
        ACETFindHCOWebservice ACETFPLWS = (ACETFindHCOWebservice)JSON.deserialize(ACETPLCtrl.PLDTWrapper.Service.replace('&#x27;', '\''), ACETFindHCOWebservice.class);
        ACETFPLWS.queryPaginatedData(0, 5, 0);
        
        Test.stopTest();
    }
    
    //Error response for FindHCO
    static testMethod void ACETAAProviderLookupControllerTest13() {
        
        Map<String, String> TestISLWSConfigs = new Map<String, String>(); 
        TestISLWSConfigs.put('ISLConAccessToken', 'dfb379c2-06b7-46c4-8c6f-bbc390d1b854');
        TestISLWSConfigs.put('ISLOAuthContentType', 'application/x-www-form-urlencoded');
        TestISLWSConfigs.put('ISLOAuthGrantType', 'client_credentials');
        TestISLWSConfigs.put('OILHttpHeaderAccept', 'application/json;charset=UTF-8');
        TestISLWSConfigs.put('OILHttpHeaderActor', 'ACET');
        TestISLWSConfigs.put('OILHttpHeaderScope', 'read');
        TestISLWSConfigs.put('OILTimeout', '3000');
        TestISLWSConfigs.put('dev_ISLOAuthEndpoint', 'https://api-stg.optum.com:8443');
        TestISLWSConfigs.put('dev_findMedicalProviderAdapterEndpoint', '/api/alpha/eisl/providers/medicalproviders/v2.0/search');
        List<ISL_Webservice_Config__c> lstISLWSConfigs = ACETTestDataUtility.CreateISLWebserviceConfigurations(TestISLWSConfigs);
        insert lstISLWSConfigs;
        
        String ResponseJSON = '{"findMedicalHealthcareOrganizationsResult":{"errors":[{"code":"W008","name":"No records returned","severity":"low",';
        ResponseJSON += '"origin":"Consumer","description":"Consumer has requested a query for which no records have been found."}]}}'; 
        
        system.debug(LoggingLevel.INFO, 'Response JSON: ' + ResponseJSON);
        
       /* Account oAccount = ACETTestDataUtility.CreateAccount('Test Account', 'TstTaxID1', 'TestEID1');
        insert oAccount;
        Contact oContact = ACETTestDataUtility.CreateContact(oAccount.Id, 'Test Contact LN', 'Test Contact FN', 'TstTaxID1', 'TestEID1', 'TestNPI1');
        insert oContact;*/
         RecordType newRecord = [SELECT Id FROM RecordType WHERE Name = 'Person Account' and SObjectType = 'Account'];
        
        Account accountTest = new Account();
        accountTest.FirstName = 'Test Contact FN1';
        accountTest.LastName = 'Test Contact LN1';
        accountTest.EID__c = 'TestEID1';
        accountTest.EID__pc = 'TestEID1';
        accountTest.RecordTypeId = newRecord.Id;
        insert accountTest;

    Account oAccount = [SELECT Id,personcontactid from Account where Id=:accountTest.Id];
        Contact oContact = [SELECT Id,LastName,FirstName,EID__c,AccountId from Contact where Id=:oAccount.personcontactid];
        
        
        Interaction__c oInteraction = ACETTestDataUtility.CreateInteraction(oContact.Id, 'Phone', 'Member', oContact.LastName);
        insert oInteraction;
        
        ACETHighlightsPanelAdditionalInfo AdditionalInfo = new ACETHighlightsPanelAdditionalInfo();
        AdditionalInfo.PolicyNumber = 'TestPolicyNumber';
        
        MockHttpCalloutResponseGenerator.MockHttpResponse oilTestResponse = new MockHttpCalloutResponseGenerator.MockHttpResponse(500, status500, ResponseJSON);
        oilTestResponse.TokenExpired = false;
        
        Test.startTest();
        
        MockHttpCalloutResponseGenerator mockHttpResponse = new MockHttpCalloutResponseGenerator(null, oilTestResponse);
        Test.setMock(HttpCalloutMock.class, mockHttpResponse);
        
        PageReference ACETPL = Page.ACETProviderLookup;
        ACETPL.getParameters().put('interactionId', oInteraction.Id);
        ACETPL.getParameters().put('benefitPlanId', 'BenefitPlanId1');
        ACETPL.getParameters().put('contactId', oContact.Id);
        ACETPL.getParameters().put('additionalInfo', JSON.serialize(AdditionalInfo));
        Test.setCurrentPageReference(ACETPL);
        
        ACETProviderLookupController ACETPLCtrl = new ACETProviderLookupController();
        ACETPLCtrl.NewpatientsInd = true;
        ACETPLCtrl.existingpatientsInd = true;
        ACETPLCtrl.FreeStandingFacl = false;
        ACETPLCtrl.phoneNumber = '1111111111';
        ACETPLCtrl.providerType = 'Facility';
        ACETPLCtrl.searchResults();
        
        ACETFindHCOWebservice ACETFPLWS = (ACETFindHCOWebservice)JSON.deserialize(ACETPLCtrl.PLDTWrapper.Service.replace('&#x27;', '\''), ACETFindHCOWebservice.class);
        ACETFPLWS.queryPaginatedData(0, 5, 0);
        
        Test.stopTest();
    }
    
    //Error response for FindHCO
    static testMethod void ACETAAProviderLookupControllerTest14() {
        
        Map<String, String> TestISLWSConfigs = new Map<String, String>(); 
        TestISLWSConfigs.put('ISLConAccessToken', 'dfb379c2-06b7-46c4-8c6f-bbc390d1b854');
        TestISLWSConfigs.put('ISLOAuthContentType', 'application/x-www-form-urlencoded');
        TestISLWSConfigs.put('ISLOAuthGrantType', 'client_credentials');
        TestISLWSConfigs.put('OILHttpHeaderAccept', 'application/json;charset=UTF-8');
        TestISLWSConfigs.put('OILHttpHeaderActor', 'ACET');
        TestISLWSConfigs.put('OILHttpHeaderScope', 'read');
        TestISLWSConfigs.put('OILTimeout', '3000');
        TestISLWSConfigs.put('dev_ISLOAuthEndpoint', 'https://api-stg.optum.com:8443');
        TestISLWSConfigs.put('dev_findMedicalProviderAdapterEndpoint', '/api/alpha/eisl/providers/medicalproviders/v2.0/search');
        List<ISL_Webservice_Config__c> lstISLWSConfigs = ACETTestDataUtility.CreateISLWebserviceConfigurations(TestISLWSConfigs);
        insert lstISLWSConfigs;
        
        String ResponseJSON = '{"findMedicalHealthcareOrganizationsResponse":{"errors":[{"code":"W008","name":"No records returned","severity":"low",';
        ResponseJSON += '"origin":"Consumer","description":"Consumer has requested a query for which no records have been found."}, {"code":"W008",';
        ResponseJSON += '"name":"No records returned","severity":"low",';
        ResponseJSON += '"origin":"Consumer","description":"Consumer has requested a query for which no records have been found."}]}}'; 
        
        system.debug(LoggingLevel.INFO, 'Response JSON: ' + ResponseJSON);
        
       /* Account oAccount = ACETTestDataUtility.CreateAccount('Test Account', 'TstTaxID1', 'TestEID1');
        insert oAccount;
        Contact oContact = ACETTestDataUtility.CreateContact(oAccount.Id, 'Test Contact LN', 'Test Contact FN', 'TstTaxID1', 'TestEID1', 'TestNPI1');
        insert oContact;*/
         RecordType newRecord = [SELECT Id FROM RecordType WHERE Name = 'Person Account' and SObjectType = 'Account'];
        
        Account accountTest = new Account();
        accountTest.FirstName = 'Test Contact FN1';
        accountTest.LastName = 'Test Contact LN1';
        accountTest.EID__c = 'TestEID1';
        accountTest.EID__pc = 'TestEID1';
        accountTest.RecordTypeId = newRecord.Id;
        insert accountTest;

    Account oAccount = [SELECT Id,personcontactid from Account where Id=:accountTest.Id];
        Contact oContact = [SELECT Id,LastName,FirstName,EID__c,AccountId from Contact where Id=:oAccount.personcontactid];
        
        
        Interaction__c oInteraction = ACETTestDataUtility.CreateInteraction(oContact.Id, 'Phone', 'Member', oContact.LastName);
        insert oInteraction;
        
        ACETHighlightsPanelAdditionalInfo AdditionalInfo = new ACETHighlightsPanelAdditionalInfo();
        AdditionalInfo.PolicyNumber = 'TestPolicyNumber';
        
        MockHttpCalloutResponseGenerator.MockHttpResponse oilTestResponse = new MockHttpCalloutResponseGenerator.MockHttpResponse(500, status500, ResponseJSON);
        oilTestResponse.TokenExpired = false;
        
        Test.startTest();
        
        MockHttpCalloutResponseGenerator mockHttpResponse = new MockHttpCalloutResponseGenerator(null, oilTestResponse);
        Test.setMock(HttpCalloutMock.class, mockHttpResponse);
        
        PageReference ACETPL = Page.ACETProviderLookup;
        ACETPL.getParameters().put('interactionId', oInteraction.Id);
        ACETPL.getParameters().put('benefitPlanId', 'BenefitPlanId1');
        ACETPL.getParameters().put('contactId', oContact.Id);
        ACETPL.getParameters().put('additionalInfo', JSON.serialize(AdditionalInfo));
        Test.setCurrentPageReference(ACETPL);
        
        ACETProviderLookupController ACETPLCtrl = new ACETProviderLookupController();
        ACETPLCtrl.NewpatientsInd = true;
        ACETPLCtrl.existingpatientsInd = true;
        ACETPLCtrl.FreeStandingFacl = true;
        ACETPLCtrl.phoneNumber = '1111111111';
        ACETPLCtrl.providerType = 'Facility';
        ACETPLCtrl.searchResults();
        
        ACETFindHCOWebservice ACETFPLWS = (ACETFindHCOWebservice)JSON.deserialize(ACETPLCtrl.PLDTWrapper.Service.replace('&#x27;', '\''), ACETFindHCOWebservice.class);
        ACETFPLWS.queryPaginatedData(0, 5, 0);
        
        Test.stopTest();
    }
    
    //Error response for FindHCO
    static testMethod void ACETAAProviderLookupControllerTest15() {
        
        Map<String, String> TestISLWSConfigs = new Map<String, String>(); 
        TestISLWSConfigs.put('ISLConAccessToken', 'dfb379c2-06b7-46c4-8c6f-bbc390d1b854');
        TestISLWSConfigs.put('ISLOAuthContentType', 'application/x-www-form-urlencoded');
        TestISLWSConfigs.put('ISLOAuthGrantType', 'client_credentials');
        TestISLWSConfigs.put('OILHttpHeaderAccept', 'application/json;charset=UTF-8');
        TestISLWSConfigs.put('OILHttpHeaderActor', 'ACET');
        TestISLWSConfigs.put('OILHttpHeaderScope', 'read');
        TestISLWSConfigs.put('OILTimeout', '3000');
        TestISLWSConfigs.put('dev_ISLOAuthEndpoint', 'https://api-stg.optum.com:8443');
        TestISLWSConfigs.put('dev_findMedicalProviderAdapterEndpoint', '/api/alpha/eisl/providers/medicalproviders/v2.0/search');
        List<ISL_Webservice_Config__c> lstISLWSConfigs = ACETTestDataUtility.CreateISLWebserviceConfigurations(TestISLWSConfigs);
        insert lstISLWSConfigs;
        
        String ResponseJSON = '{"findMedicalHealthcareOrganizationsResult":{"findMedicalHealthcareOrganizationsResponseType":{"errors":[{"code":"W008","name":"No records returned",';
        ResponseJSON += '"severity":"low","origin":"Consumer","description":"Consumer has requested a query for which no records have been found.';
        ResponseJSON += '"}, {"code":"W008","name":"No records returned", "severity":"low","origin":"Consumer","description":"Consumer has ';
        ResponseJSON += 'requested a query for which no records have been found."},{"code":"W008","name":"No records returned", "severity":"low",';
        ResponseJSON += '"origin":"Consumer","description":"Consumer has requested a query for which no records have been found."},{"code":"W008",';
        ResponseJSON += '"name":"No records returned", "severity":"low","origin":"Consumer","description":"Consumer has requested a query for which ';
        ResponseJSON += 'no records have been found."}],"pagination":{"pageNumber":"0","pageSize":"2","recordCount":"0","totalCount":"0","totalPages":"0"}}}}'; 
        
        system.debug(LoggingLevel.INFO, 'Response JSON: ' + ResponseJSON);
        
      /*  Account oAccount = ACETTestDataUtility.CreateAccount('Test Account', 'TstTaxID1', 'TestEID1');
        insert oAccount;
        Contact oContact = ACETTestDataUtility.CreateContact(oAccount.Id, 'Test Contact LN', 'Test Contact FN', 'TstTaxID1', 'TestEID1', 'TestNPI1');
        insert oContact;*/
         RecordType newRecord = [SELECT Id FROM RecordType WHERE Name = 'Person Account' and SObjectType = 'Account'];
        
        Account accountTest = new Account();
        accountTest.FirstName = 'Test Contact FN1';
        accountTest.LastName = 'Test Contact LN1';
        accountTest.EID__c = 'TestEID1';
        accountTest.EID__pc = 'TestEID1';
        accountTest.RecordTypeId = newRecord.Id;
        insert accountTest;

    Account oAccount = [SELECT Id,personcontactid from Account where Id=:accountTest.Id];
        Contact oContact = [SELECT Id,LastName,FirstName,EID__c,AccountId from Contact where Id=:oAccount.personcontactid];
        
        
        Interaction__c oInteraction = ACETTestDataUtility.CreateInteraction(oContact.Id, 'Phone', 'Member', oContact.LastName);
        insert oInteraction;
        
        ACETHighlightsPanelAdditionalInfo AdditionalInfo = new ACETHighlightsPanelAdditionalInfo();
        AdditionalInfo.PolicyNumber = 'TestPolicyNumber';
        
        MockHttpCalloutResponseGenerator.MockHttpResponse oilTestResponse = new MockHttpCalloutResponseGenerator.MockHttpResponse(500, status500, ResponseJSON);
        oilTestResponse.TokenExpired = false;
        
        Test.startTest();
        
        MockHttpCalloutResponseGenerator mockHttpResponse = new MockHttpCalloutResponseGenerator(null, oilTestResponse);
        Test.setMock(HttpCalloutMock.class, mockHttpResponse);
        
        PageReference ACETPL = Page.ACETProviderLookup;
        ACETPL.getParameters().put('interactionId', oInteraction.Id);
        ACETPL.getParameters().put('benefitPlanId', 'BenefitPlanId1');
        ACETPL.getParameters().put('contactId', oContact.Id);
        ACETPL.getParameters().put('additionalInfo', JSON.serialize(AdditionalInfo));
        Test.setCurrentPageReference(ACETPL);
        
        ACETProviderLookupController ACETPLCtrl = new ACETProviderLookupController();
        ACETPLCtrl.NewpatientsInd = true;
        ACETPLCtrl.existingpatientsInd = true;
        ACETPLCtrl.FreeStandingFacl = true;
        ACETPLCtrl.phoneNumber = '1111111111';
        ACETPLCtrl.providerType = 'Facility';
        ACETPLCtrl.searchResults();
        
        ACETFindHCOWebservice ACETFPLWS = (ACETFindHCOWebservice)JSON.deserialize(ACETPLCtrl.PLDTWrapper.Service.replace('&#x27;', '\''), ACETFindHCOWebservice.class);
        ACETFPLWS.queryPaginatedData(0, 5, 0);
        Test.stopTest();
    }
    
    //Exception because of invalid JSON in response for FindHCO
    static testMethod void ACETAAProviderLookupControllerTest16() {
        
        Map<String, String> TestISLWSConfigs = new Map<String, String>(); 
        TestISLWSConfigs.put('ISLConAccessToken', 'dfb379c2-06b7-46c4-8c6f-bbc390d1b854');
        TestISLWSConfigs.put('ISLOAuthContentType', 'application/x-www-form-urlencoded');
        TestISLWSConfigs.put('ISLOAuthGrantType', 'client_credentials');
        TestISLWSConfigs.put('OILHttpHeaderAccept', 'application/json;charset=UTF-8');
        TestISLWSConfigs.put('OILHttpHeaderActor', 'ACET');
        TestISLWSConfigs.put('OILHttpHeaderScope', 'read');
        TestISLWSConfigs.put('OILTimeout', '3000');
        TestISLWSConfigs.put('dev_ISLOAuthEndpoint', 'https://api-stg.optum.com:8443');
        TestISLWSConfigs.put('dev_findMedicalProviderAdapterEndpoint', '/api/alpha/eisl/providers/medicalproviders/v2.0/search');
        List<ISL_Webservice_Config__c> lstISLWSConfigs = ACETTestDataUtility.CreateISLWebserviceConfigurations(TestISLWSConfigs);
        insert lstISLWSConfigs;
        
        String ResponseJSON = ACETTestDataUtility.findHCPAdapterJSON();  //'{"findMedicalHealthcareOrganizationsResult":{"errors":[{"code":"W008","name":"No records returned","severity":"low",';
       // ResponseJSON += '"origin":"Consumer","description":"Consumer has requested a query for which no records have been found."}]';
        //system.debug(LoggingLevel.INFO, 'Response JSON: ' + ResponseJSON);
        
/*        Account oAccount = ACETTestDataUtility.CreateAccount('Test Account', 'TstTaxID1', 'TestEID1');
        insert oAccount;
        Contact oContact = ACETTestDataUtility.CreateContact(oAccount.Id, 'Test Contact LN', 'Test Contact FN', 'TstTaxID1', 'TestEID1', 'TestNPI1');
        insert oContact;*/
         RecordType newRecord = [SELECT Id FROM RecordType WHERE Name = 'Person Account' and SObjectType = 'Account'];
        
        Account accountTest = new Account();
        accountTest.FirstName = 'Test Contact FN1';
        accountTest.LastName = 'Test Contact LN1';
        accountTest.EID__c = 'TestEID1';
        accountTest.EID__pc = 'TestEID1';
        accountTest.RecordTypeId = newRecord.Id;
        insert accountTest;

    Account oAccount = [SELECT Id,personcontactid from Account where Id=:accountTest.Id];
        Contact oContact = [SELECT Id,LastName,FirstName,EID__c,AccountId from Contact where Id=:oAccount.personcontactid];
        
        
        Interaction__c oInteraction = ACETTestDataUtility.CreateInteraction(oContact.Id, 'Phone', 'Member', oContact.LastName);
        insert oInteraction;
        
        ACETHighlightsPanelAdditionalInfo AdditionalInfo = new ACETHighlightsPanelAdditionalInfo();
        AdditionalInfo.PolicyNumber = 'TestPolicyNumber';
        
        MockHttpCalloutResponseGenerator.MockHttpResponse OILTestResponse = new MockHttpCalloutResponseGenerator.MockHttpResponse(200, 'OK', ResponseJSON);
        OILTestResponse.TokenExpired = false;
        
        Test.startTest();
        
        MockHttpCalloutResponseGenerator MockHttpResponse = new MockHttpCalloutResponseGenerator(null, OILTestResponse);
        Test.setMock(HttpCalloutMock.class, MockHttpResponse);
        
        PageReference ACETPL = Page.ACETProviderLookup;
        ACETPL.getParameters().put('interactionId', oInteraction.Id);
        ACETPL.getParameters().put('benefitPlanId', 'BenefitPlanId1');
        ACETPL.getParameters().put('contactId', oContact.Id);
        ACETPL.getParameters().put('additionalInfo', JSON.serialize(AdditionalInfo));
        Test.setCurrentPageReference(ACETPL);
        
        ACETProviderLookupController ACETPLCtrl = new ACETProviderLookupController();
        ACETPLCtrl.NewpatientsInd = true;
        ACETPLCtrl.existingpatientsInd = true;
        ACETPLCtrl.FreeStandingFacl = true;
        ACETPLCtrl.phoneNumber = '1111111111';
        ACETPLCtrl.providerType = 'Facility';
        ACETPLCtrl.searchResults();
        ACETFindHCOWebservice hcows = new ACETFindHCOWebservice();
        hcows.specialityCheck = '207Q00000X';
        hcows.providerType = 'Facility';
        hcows.FindHCO('353453453', '', '', 'Freedom Benefit', '', '', 'Facility', '', '', '234234', '', '', '', '', '', '', '', '', '');
        ACETFindHCOWebservice ACETFPLWS = (ACETFindHCOWebservice)JSON.deserialize(ACETPLCtrl.PLDTWrapper.Service.replace('&#x27;', '\''), ACETFindHCOWebservice.class);
        ACETFPLWS.queryPaginatedData(0, 5, 0);
        
        ACETFindMedclProvidrLookupSrvceJSON2Apex.Address  AFPLS = new ACETFindMedclProvidrLookupSrvceJSON2Apex.Address();
        AFPLS.countryCode='US';
        AFPLS.countryDescription='USA';
        AFPLS.countyCode='US';
        AFPLS.stateCode='CT';
        AFPLS.effectiveDate='10-10-2017';
        AFPLS.cancelDate='11-10-2017';
        AFPLS.primaryIndicator='yes'; 
        AFPLS.handicapAccessibleIndicator='no';
        ACETFindMedclProvidrLookupSrvceJSON2Apex.role AFPLSRole = new ACETFindMedclProvidrLookupSrvceJSON2Apex.role();
        AFPLSRole.code='IS';
        AFPLSRole.description='TEST';
        ACETFindMedclProvidrLookupSrvceJSON2Apex.Phone  AFPLSPHN = NEW ACETFindMedclProvidrLookupSrvceJSON2Apex.Phone();
        AFPLSPHN.phoneTypeCode='TEST';
        AFPLSPHN.phoneCountryCode='001';
        AFPLSPHN.areaCode='001';
        AFPLSPHN.phoneNumber='9090909090';
        AFPLSPHN.phoneExtensionNumber='2345';
        AFPLSPHN.primaryPhoneIndicator='YES';
        AFPLSPHN.statusCode='ACTIVE';
        ACETFindMedclProvidrLookupSrvceJSON2Apex.HealthcareProvider AFPLHCP = new ACETFindMedclProvidrLookupSrvceJSON2Apex.HealthcareProvider();
        AFPLHCP.name = 'Louis';
        AFPLHCP.providerFirstName='Test';
        AFPLHCP.providerMiddleName='Test Middle';
        AFPLHCP.providerNameSuffix='Mr';
        ACETFindMedclProvidrLookupSrvceJSON2Apex.premiumDesignation AFPLPD = new ACETFindMedclProvidrLookupSrvceJSON2Apex.premiumDesignation();
        AFPLPD.qualityTypeCode='TC';
        AFPLPD.efficiencyTypeCode='ETC'; 
        AFPLPD.qualityTypeDescription='Quality Desc';
        AFPLPD.efficiencyTypeDescription='Eff Type';
        ACETFindHCOJSON2Apex.contract AFHOC = new ACETFindHCOJSON2Apex.contract();
        AFHOC.contractStatusCode ='A';
        AFHOC.businessSegmentCode ='E&I';
        AFHOC.networkIds = new List<String>{'1008476'};
        AFHOC.contractClaimTypes = new List<String>{'Medical'};
        ACETFindHCPJSON2Apex.contract AFHPC = new ACETFindHCPJSON2Apex.contract();
        AFHPC.contractStatusCode ='A';
        AFHPC.businessSegmentCode ='E&I';
        AFHPC.networkIds = new List<String>{'1008476'};
        AFHPC.contractClaimTypes = new List<String>{'Medical'};
        Test.stopTest();
    }
    
    static testMethod void ACETAAProviderLookupControllerTest17() {    
        
        ACETProviderLookupController.ProviderLookupResult plkpresult = new ACETProviderLookupController.ProviderLookupResult();
        plkpresult.address = '';
        plkpresult.city = 'New Jersy';
        plkpresult.state = 'NY';
        plkpresult.zipCode = '01234';
        plkpresult.providerTypeCode = '';
        plkpresult.phoneNumber = '';
        plkpresult.speciality = '';
        plkpresult.PCPRole = '';
        plkpresult.radious = '';
        plkpresult.providerTINTypeCode = '';
        plkpresult.addressId = '';
        plkpresult.addressTypeCode = '';
        plkpresult.addressLine1 = '';
        plkpresult.addressLine2 = '';
        plkpresult.networkId= '89989890';
        plkpresult.cliamType= 'IN/Out Service Area';
        plkpresult.addressStatusCode= '';
        plkpresult.postalPrefixCode= '';
        plkpresult.postalSuffixCode= '';
        plkpresult.addressCountyDesc= '';
        
        ACETProviderLookupController lkpcontr = new ACETProviderLookupController();
  
    }
    
    static testMethod void testOILErrorsMethod(){
        ACETOILError errors = new ACETOILError();
        errors.code = '500';
        errors.name = 'UnExpected Error, Pease contact system Admin';
        errors.severity = 'test';
        errors.origin = 'test';
        errors.description = 'Unexpcted Error';
        system.assertEquals(errors.code, '500');
    }
	static testMethod void testGetNetworkVal (){
        String netVal = 'CHOICEPLUS_1';
        test.startTest();
        ACETProviderLookupController.getNetworkVal(netVal);
        test.stopTest(); 
    }
  
}