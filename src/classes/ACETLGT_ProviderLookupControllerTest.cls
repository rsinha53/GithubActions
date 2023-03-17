@IsTest
public class ACETLGT_ProviderLookupControllerTest {
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
    public static final String bundleId = '11958418';
    public static final String enrollerSRK = '740970884';
    public static final String surrogateKey ='740970865';
    public static final String startDate = '01/01/2021';
    public static final String endDate = '12/31/2021';
    public static final String coverageTypes ='';
    public static final String groupNumber = '1013629';
    public static final String accumAsOf = '';
    public static final String memId = '13690586900';
   	public static final String situsState = 'CT';
    public static final String planId = 'M030000189';
    public static final String customerPurchaseId = '';
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
    static void testGetSearchResults(){
        test.startTest();
        ACETLGT_ProviderLookupController.getSearchResults(surrogateKey, bundleId, enrollerSRK, startDate, endDate, coverageTypes, groupNumber, accumAsOf, situsState, planId, customerPurchaseId);
        MockHttpCalloutResponseGenerator.MockHttpResponse mockResponse = new MockHttpCalloutResponseGenerator.MockHttpResponse(statusCode200, status200, nimbusGetSSBResponse);        
        mockResponse.TokenExpired = false;        
        MockHttpCalloutResponseGenerator mockHttpRes = new MockHttpCalloutResponseGenerator(null, mockResponse);
        Test.setMock(HttpCalloutMock.class, mockHttpRes);
		ACETLGT_ProviderLookupController.getSearchResults(surrogateKey, bundleId, enrollerSRK, startDate, endDate, coverageTypes, groupNumber, accumAsOf, situsState, planId, customerPurchaseId);
        MockHttpCalloutResponseGenerator.MockHttpResponse mockResponse1 = new MockHttpCalloutResponseGenerator.MockHttpResponse(statusCode400, status400, nimbusGetSSBBadResponse);        
        mockResponse1.TokenExpired = false;        
        MockHttpCalloutResponseGenerator mockHttpRes1 = new MockHttpCalloutResponseGenerator(null, mockResponse1);
        Test.setMock(HttpCalloutMock.class, mockHttpRes1);
		ACETLGT_ProviderLookupController.getSearchResults(surrogateKey, bundleId, enrollerSRK, startDate, endDate, coverageTypes, groupNumber, accumAsOf, situsState, planId, customerPurchaseId);
        MockHttpCalloutResponseGenerator.MockHttpResponse mockResponse2 = new MockHttpCalloutResponseGenerator.MockHttpResponse(statusCode500, status500, nimbusGetSSBBadResponse);        
        mockResponse2.TokenExpired = false;        
        MockHttpCalloutResponseGenerator mockHttpRes2 = new MockHttpCalloutResponseGenerator(null, mockResponse2);
        Test.setMock(HttpCalloutMock.class, mockHttpRes2);
		ACETLGT_ProviderLookupController.getSearchResults(surrogateKey, bundleId, enrollerSRK, startDate, endDate, coverageTypes, groupNumber, accumAsOf, situsState, planId, customerPurchaseId);
        MockHttpCalloutResponseGenerator.MockHttpResponse mockResponse3 = new MockHttpCalloutResponseGenerator.MockHttpResponse(statusCode404, status404, nimbusGetSSBBadResponse);        
        mockResponse3.TokenExpired = false;        
        MockHttpCalloutResponseGenerator mockHttpRes3 = new MockHttpCalloutResponseGenerator(null, mockResponse3);
        Test.setMock(HttpCalloutMock.class, mockHttpRes3);
		ACETLGT_ProviderLookupController.getSearchResults(surrogateKey, bundleId, enrollerSRK, startDate, endDate, coverageTypes, groupNumber, accumAsOf, situsState, planId, customerPurchaseId);
        MockHttpCalloutResponseGenerator.MockHttpResponse mockResponse4 = new MockHttpCalloutResponseGenerator.MockHttpResponse(statusCode504, status504, nimbusGetSSBBadResponse);
        mockResponse4.TokenExpired = false;        
        MockHttpCalloutResponseGenerator mockHttpRes4 = new MockHttpCalloutResponseGenerator(null, mockResponse4);
        Test.setMock(HttpCalloutMock.class, mockHttpRes4);
		ACETLGT_ProviderLookupController.getSearchResults(surrogateKey, bundleId, enrollerSRK, startDate, endDate, coverageTypes, groupNumber, accumAsOf, situsState, planId, customerPurchaseId);
        MockHttpCalloutResponseGenerator.MockHttpResponse mockResponse5 = new MockHttpCalloutResponseGenerator.MockHttpResponse(statusCode999, status999, nimbusGetSSBBadResponse);
        mockResponse4.TokenExpired = false;        
        MockHttpCalloutResponseGenerator mockHttpRes5 = new MockHttpCalloutResponseGenerator(null, mockResponse5);
        Test.setMock(HttpCalloutMock.class, mockHttpRes5);
		ACETLGT_ProviderLookupController.getSearchResults(surrogateKey, bundleId, enrollerSRK, startDate, endDate, coverageTypes, groupNumber, accumAsOf, situsState, planId, customerPurchaseId);
        test.stopTest();
    }
    @IsTest
    Public static void providerLookupControllerTestmethodForPhysician()
    {  
       ACETLGT_ProviderLookupController.getClassifications('Physician');
       Map<String,set<String>> calisificationByProvider = new Map<String,set<String>>();
       Set<String> classifications = new Set<String>(); 
       classifications.add('Dentist');
       classifications.add('All');
       calisificationByProvider.put('Physician',classifications); 
       ACETLGT_ProviderLookupController.getLanguagescmdt();
       ACETLGT_ProviderLookupController.getSpecilities('Physician','Podiatrist');
       map<string,set<string>> specialityByProviderAndClasification = new map<string,set<string>>();
       Set<String> specialties = new Set<String>();
       specialties.add('Sports Medicine');
       specialityByProviderAndClasification.put('PhysicianPodiatrist',specialties);
       ACETLGT_ProviderLookupController.getNetworks();
       StaticResource ResponseJSONSR = [SELECT Body FROM StaticResource WHERE Name = 'ACETFindMedicalHCPResponseJSON'];
       String ResponseJSON = ResponseJSONSR.Body.toString(); 
       ACETLGT_FindHCPJSON2Apex jsonAPex = ACETLGT_FindHCPJSON2Apex.parse(ResponseJSON);
       MockHttpCalloutResponseGenerator.MockHttpResponse OILResponse =  new MockHttpCalloutResponseGenerator.MockHttpResponse(200, 'OK', ResponseJSON); //ACETTestDataUtility.GetMemberSearchJSON()
       OILResponse.TokenExpired = false;        
       MockHttpCalloutResponseGenerator MockHttpRes = new MockHttpCalloutResponseGenerator(null, OILResponse);
       Test.setMock(HttpCalloutMock.class, MockHttpRes);   
       Test.startTest();
       ACETLGT_ProviderLookupController.getProviderLookupResults('959245382093360560','1316273071','263520640','AGGARWAL','MAYANK ','M','Podiatrist','Sports Medicine','40444721','06708','1',' WATERBURY','CT','','9','OXFORD_TRI_STATE','In/Out of Srvc Area','Medical','Y','US','Physician','','true','','','2019-12-31','');
       ACETLGT_FindHCPWebservice hcpws = new ACETLGT_FindHCPWebservice();
       hcpws.Init('23423434234','2342342','2342342','', '', '', '', '', '', '', '', '', '1111111111','7@6', '', '', '', '', '', 'Physician','','true','Active','true');
       hcpws.FindHCP('123445555', '', '345345345454', '', '', '1111111111', 'Physician', '', '', '', '', '', '', '', '', '', '', '','');
       hcpws.queryPaginatedData(0,5,0);
       ACETLGT_FindHCPJSON2Apex.contract AFHPC = new ACETLGT_FindHCPJSON2Apex.contract();
       AFHPC.contractStatusCode ='A';
       AFHPC.businessSegmentCode ='E&I';
       AFHPC.networkIds = new List<String>{'1008476'};
       AFHPC.contractClaimTypes = new List<String>{'Medical'};
       Test.stopTest();
    }
    
    @IsTest
    Public static void providerLookupControllerTestmethodForPhysicianFailure()
    {
        String ResponseJSON = '{"findMedicalHealthcareProfessionalsResponse":{"errors":[{"code":"W008","name":"No records returned",';
        ResponseJSON += '"severity":"low","origin":"Consumer","description":"Consumer has requested a query for which no records have been found.';
        ResponseJSON += '"}],"pagination":{"pageNumber":"0","pageSize":"2","recordCount":"0","totalCount":"0","totalPages":"0"}}}}'; 
        MockHttpCalloutResponseGenerator.MockHttpResponse OILTestResponse = new MockHttpCalloutResponseGenerator.MockHttpResponse(200, 'OK', ResponseJSON);
        OILTestResponse.TokenExpired = false;
        Test.startTest();
        MockHttpCalloutResponseGenerator MockHttpResponse = new MockHttpCalloutResponseGenerator(null, OILTestResponse);
        Test.setMock(HttpCalloutMock.class, MockHttpResponse);
        ACETLGT_FindHCPWebservice hcpws = new ACETLGT_FindHCPWebservice();
        hcpws.Init('23423434234','2342342','2342342','', '', '', '', '', '', '', '', '', '1111111111','7@6', '', '', '', '', '', 'Physician','','true','Active','true');
        hcpws.queryPaginatedData(0,5,0);
        Test.stopTest();
    }
    @IsTest
    Public static void providerLookupControllerTestmethodForFacility()
    {
       StaticResource ResponseJSONSR = [SELECT Body FROM StaticResource WHERE Name = 'ACETFindMedicalHCOResponseJSON'];
       String ResponseJSON = ResponseJSONSR.Body.toString(); 
       MockHttpCalloutResponseGenerator.MockHttpResponse OILResponse =  new MockHttpCalloutResponseGenerator.MockHttpResponse(200, 'OK', ResponseJSON); //ACETTestDataUtility.GetMemberSearchJSON()
       OILResponse.TokenExpired = false;        
       MockHttpCalloutResponseGenerator MockHttpRes = new MockHttpCalloutResponseGenerator(null, OILResponse);
       Test.setMock(HttpCalloutMock.class, MockHttpRes);  
       Test.startTest();
       ACETLGT_ProviderLookupController.getProviderLookupResults('959245382093360560','1316273071','263520640','AGGARWAL','MAYANK ','M','Podiatrist','Sports Medicine','40444721','06708','1',' WATERBURY','CT','','9','OXFORD_TRI_STATE','In/Out of Srvc Area','Medical','Y','US','Facility','','true','','','','');
       ACETLGT_FindHCOWebservice hcows = new ACETLGT_FindHCOWebservice();
       hcows.Init('23423434234','2342342','2342342','', '', '', '', '', '', '', '', '', '1111111111','7@6', '', '', '', '', '', 'Facility','','true','Active','true','');
       hcows.FindHCO('123445555', '', '345345345454', '', '', '1111111111', 'Facility', '', '', '', '', '', '', '', '', '', '', '','');
       hcows.queryPaginatedData(0,5,0);
       ACETLGT_FindHCOJSON2Apex.contract AFHOC = new ACETLGT_FindHCOJSON2Apex.contract();
       AFHOC.contractStatusCode ='A';
       AFHOC.businessSegmentCode ='E&I';
       AFHOC.networkIds = new List<String>{'1008476'};
       AFHOC.contractClaimTypes = new List<String>{'Medical'};
       Test.stopTest();
    }
    @IsTest
    Public static void providerLookupControllerTestmethodForFacilityFailure()
    {
        String ResponseJSON = '{"findMedicalHealthcareOrganizationsResult":{"findMedicalHealthcareOrganizationsResponseType":{"errors":[{"code":"W008","name":"No records returned",';
        ResponseJSON += '"severity":"low","origin":"Consumer","description":"Consumer has requested a query for which no records have been found.';
        ResponseJSON += '"}],"pagination":{"pageNumber":"0","pageSize":"2","recordCount":"0","totalCount":"0","totalPages":"0"}}}}'; 
        MockHttpCalloutResponseGenerator.MockHttpResponse OILTestResponse = new MockHttpCalloutResponseGenerator.MockHttpResponse(200, 'OK', ResponseJSON);
        OILTestResponse.TokenExpired = false;
        Test.startTest();
        MockHttpCalloutResponseGenerator MockHttpResponse = new MockHttpCalloutResponseGenerator(null, OILTestResponse);
        Test.setMock(HttpCalloutMock.class, MockHttpResponse);
        ACETLGT_FindHCOWebservice hcows = new ACETLGT_FindHCOWebservice();
        hcows.Init('23423434234','2342342','2342342','', '', '', '', '', '', '', '', '', '1111111111','7@6', '', '', '', '', '', 'Facility','','true','Active','true','');
        hcows.queryPaginatedData(0,5,0);
        Test.stopTest();
    }
    @IsTest
    Public static void providerLookupControllerTestmethodForCG()
    {
       StaticResource ResponseJSONSR = [SELECT Body FROM StaticResource WHERE Name = 'ACETFindMedicalProvidersResponseJSON'];
       String ResponseJSON = ResponseJSONSR.Body.toString();
       MockHttpCalloutResponseGenerator.MockHttpResponse OILResponse =  new MockHttpCalloutResponseGenerator.MockHttpResponse(200, 'OK', ResponseJSON); //ACETTestDataUtility.GetMemberSearchJSON()
       OILResponse.TokenExpired = false;        
       MockHttpCalloutResponseGenerator MockHttpRes = new MockHttpCalloutResponseGenerator(null, OILResponse);
       Test.setMock(HttpCalloutMock.class, MockHttpRes);  
       Test.startTest();
       ACETLGT_ProviderLookupController.getProviderLookupResults('959245382093360560','1316273071','263520640','AGGARWAL','MAYANK ','M','Podiatrist','Sports Medicine','40444721','06708','1',' WATERBURY','CT','','9','OXFORD_TRI_STATE','In/Out of Srvc Area','Medical','Y','US','','','true','','','2019-12-31','');
       ACETLGT_ProviderLookupResult providerResult = new ACETLGT_ProviderLookupResult();
       providerResult.networkSchedule = 'Freedom';
       providerResult.languageSchedule = 'US';
       providerResult.status = 'A';
       providerResult.NPI = '1316273071';
       providerResult.OperationHours = '0001-01-01';
       providerResult.PatientAgeRange= '0-99';
       providerResult.radius = '10';
       providerResult.Code = 'MD';
       providerResult.typeDescription = 'Family Medicine~';
       ACETLGT_FindProviderLookupWebservice findProviderLookupWebservice = new ACETLGT_FindProviderLookupWebservice();
        findProviderLookupWebservice.init('256745246538825040','','810477845','A BILLEDEAUX','','Male','','24545519','','','GLENDIVE','','4063458901','','','','','','','','','true','true','');
       findProviderLookupWebservice.queryPaginatedData(0,5,0);
       ACETLGT_FindMedicalProviderJSON2Apex.contract contract= new ACETLGT_FindMedicalProviderJSON2Apex.contract();
       contract.contractStatusCode ='A';
       contract.businessSegmentCode ='E&I';
       contract.networkIds = new List<String>{'1008476'};
       contract.contractClaimTypes = new List<String>{'Medical'};
       ACETLGT_FindMedicalProviderJSON2Apex.Address address = new ACETLGT_FindMedicalProviderJSON2Apex.Address();
       address.benefitServiceAreas = new List<String>{'OXFORD_TRI_STATE','OXFORD_CT'};
       address.countyCode = '009';
       address.effectiveDate = '2015-01-01';
       address.cancelDate = '9999-12-31';
       address.primaryIndicator = 'N';
       address.handicapAccessibleIndicator = 'Y';
       address.countryCode  = '009';
       address.countryDescription  = 'Y';
       ACETLGT_FindMedicalProviderJSON2Apex.premiumDesignation premiumDesignation= new ACETLGT_FindMedicalProviderJSON2Apex.premiumDesignation();
       premiumDesignation.qualityTypeCode = 'Q02';
       premiumDesignation.efficiencyTypeCode = 'E97';
       premiumDesignation.qualityTypeDescription  = 'Q02';
       premiumDesignation.efficiencyTypeDescription  = 'E97';
       ACETLGT_FindMedicalProviderJSON2Apex.qualityTier qualityTier = new ACETLGT_FindMedicalProviderJSON2Apex.qualityTier();
       qualityTier.networkId = '1008476';
       qualityTier.ruleId = '1008476';
       qualityTier.level = 'HIGH';
       qualityTier.reasonCode = 'N';
       qualityTier.directoryDisplayIndicator = 'Y';
       ACETLGT_FindMedicalProviderJSON2Apex.labType  labType  = new ACETLGT_FindMedicalProviderJSON2Apex.labType();
       labType.code  = '1008476';
       labType.description  = 'k';
       labType.effectiveDate  = '2015-01-01';
       labType.cancelDate  = '9999-12-31';
       labType.statusCode  = 'Y';
       ACETLGT_FindMedicalProviderJSON2Apex.ElectronicCommunication ElectronicCommunication  = new ACETLGT_FindMedicalProviderJSON2Apex.ElectronicCommunication ();
       ElectronicCommunication.communicationTypeCode   = '1008476';
       ElectronicCommunication.message   = 'k';
       Test.stopTest();
    }
     @IsTest
    Public static void providerLookupControllerTestmethodForCGFailure()
    {
        String ResponseJSON = '{"findMedicalProvidersResponse":{"errors":[{"code":"W008","name":"No records returned",';
        ResponseJSON += '"severity":"low","origin":"Consumer","description":"Consumer has requested a query for which no records have been found.';
        ResponseJSON += '"}],"pagination":{"pageNumber":"0","pageSize":"2","recordCount":"0","totalCount":"0","totalPages":"0"}}}}'; 
        MockHttpCalloutResponseGenerator.MockHttpResponse OILTestResponse = new MockHttpCalloutResponseGenerator.MockHttpResponse(200, 'OK', ResponseJSON);
        OILTestResponse.TokenExpired = false;
        Test.startTest();
        MockHttpCalloutResponseGenerator MockHttpResponse = new MockHttpCalloutResponseGenerator(null, OILTestResponse);
        Test.setMock(HttpCalloutMock.class, MockHttpResponse);
        ACETLGT_FindProviderLookupWebservice findProviderLookupWebservice = new ACETLGT_FindProviderLookupWebservice();
        findProviderLookupWebservice.init('256745246538825040','','810477845','A BILLEDEAUX','','Male','','24545519','','','GLENDIVE','','4063458901','','','','','','','','','true','true','');
        findProviderLookupWebservice.queryPaginatedData(0,5,0);
        Test.stopTest();
    }
    @IsTest
    Public static void providerLookupControllerTestmethodForSubscription()
    {
         MockHttpCalloutResponseGenerator.MockHttpResponse oilResponse =  new MockHttpCalloutResponseGenerator.MockHttpResponse(statusCode200, status200, nimbusGetSSBResponse);        
         OILResponse.TokenExpired = false;        
         MockHttpCalloutResponseGenerator mockHttpRes = new MockHttpCalloutResponseGenerator(null, oilResponse);
         Test.setMock(HttpCalloutMock.class, mockHttpRes); 
         ACETLGT_NimbusGetSSBAPI ssbWebservice = new ACETLGT_NimbusGetSSBAPI();
         System.debug(ssbWebservice);
         Test.startTest();
         ACETLGT_ProviderLookupController.getSearchResults(surrogateKey, bundleId, enrollerSRK, startDate, endDate, coverageTypes, groupNumber, accumAsOf, situsState, planId, customerPurchaseId);
        Test.stopTest();
    }
	@IsTest 
    Public static void testGetNetworkVal (){
        String netVal = 'CHOICEPLUS_1';
        test.startTest();
        ACETLGT_ProviderLookupController.getNetworkVal(netVal);
        test.stopTest(); 
    } 
}