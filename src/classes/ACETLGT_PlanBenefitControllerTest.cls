@IsTest
public class ACETLGT_PlanBenefitControllerTest {
    
    public static final String benefitPlanId = '1008812_11958488';
    public static final String benefitDateSearch = '2021-01-01';
    public static final Boolean isBenefitAvailable = true;
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
    
    public static final String benAvailableRes1 = '{"result":{"isAvailable": true}}';
    public static final String benAvailableRes2 = '{"result":{"isAvailable": false}}';
    public static final String b360BadResponse = '{"applicationErrors":[{"applicationErrorCode":4000,"applicationErrorMessage":"Missing mandatory parameters : benefitPlanID"}]}';
    public static final String benCatResponse = '{"result":[{"categoryName":"Preventive Care ","children":[{"categoryName":"Annual Physical","benefitId":"6f9fb9a0-caa7-11eb-a3a4-93b47cfc5118#1008812_11958488#20210604T120500001#usp@dbd#2"}]}]}';
    public static final String b360BenefitCategoryStr1 = '{"benefitCategoryList":["Preventive Care"],"benefitCategoryChildrenMap":{"Preventive Care":[{"categoryName":"Annual Physical","benefitId":"6f9fb9a0-caa7-11eb-a3a4-93b47cfc5118#1008812_11958488#20210604T120500001#usp@dbd#2"}]}}';
    public static final String selectedCategory1 = 'Preventive Care';
    public static final String b360BenefitCategoryStr2 = '{"benefitCategoryList":["Preventive Care"]}';
    public static final String selectedCategory2 = 'Manish';
    public static final String searchedKeyword = 'Surgery';
    public static final String benSearchResponse1 = '{"result":{"matchingPhrases":[],"benefit":[{"benefitId":"742345f0-caa7-11eb-a3a4-93b47cfc5118#1008812_11958488#20210604T120500001#USP@dbd#3@101@f076e77e-8881-4e7e-bcd4-0f1a06be76ff","benefitName":"Surgery – Outpatient","benefitSummaryText":""}]}}';
    public static final String benSearchResponse2 = '{"result":{"matchingPhrases":[],"benefit":[]}}';
    public static final String benefitId = '74c6b1e0-caa7-11eb-a3a4-93b47cfc5118#9Z5466_3531451#20210604T120500001#USP@dbd#3@101@fdbe57c5-5545-4f04-8c10-0b52f01884f2';
    public static final String benSecResponse1 = '{"result":{"benefit":[{"benefitSectionName":"Lab, X-ray and Diagnostic Testing","benefitType":"Benefit","benefitName":"Minor Lab, X-Ray and Diagnostic - Outpatient","benefitLanguageDescription":" <b>What are diagnostic tests?</b>","benefitNetworkSection":[{"networkLanguageDescription":"<b>Lab Testing - Outpatient</b>","networkTypeDescription":["Your cost if you use Network benefits"]}],"benefitLimitAndException":[{"description":"General","details":"Limited to 18 Presumptive Drug Tests per year."}]},{"benefitSectionName":"Lab, X-ray and Diagnostic Testing","benefitType":"BenefitCSR","benefitName":"Authorization by Provider ","benefitNetworkSection":[{"networkLanguageDescription":" Member notification is not required","networkTypeDescription":["Plan Information"]}]}]}}';
    public static final String benSecResponse2 = '{"result":{"benefit":[]}}';
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
   	public static final String situsState = 'NY';
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
        WebserviceConfigurations__c wsConfig1 = ACET_WebserviceCalloutFramework_Test.createWSConfig('B360AreBenefitsAvailableService', tokenAPIWSConfig.Id);
        OrgSpecificConfigurations__c orgSpecificConfigs1 = ACET_WebserviceCalloutFramework_Test.createOrgWSConfigs(wsConfig1.Id);
        System.debug(orgSpecificConfigs1);
        // Service API data
        WebserviceConfigurations__c wsConfig2 = ACET_WebserviceCalloutFramework_Test.createWSConfig('B360GetBenefitCategoryService', tokenAPIWSConfig.Id);
        OrgSpecificConfigurations__c orgSpecificConfigs2 = ACET_WebserviceCalloutFramework_Test.createOrgWSConfigs(wsConfig2.Id);
        System.debug(orgSpecificConfigs2);
        // Service API data
        WebserviceConfigurations__c wsConfig3 = ACET_WebserviceCalloutFramework_Test.createWSConfig('B360SearchBenefitsAPI', tokenAPIWSConfig.Id);
        OrgSpecificConfigurations__c orgSpecificConfigs3 = ACET_WebserviceCalloutFramework_Test.createOrgWSConfigs(wsConfig3.Id);
        System.debug(orgSpecificConfigs3);
        // Service API data
        WebserviceConfigurations__c wsConfig4 = ACET_WebserviceCalloutFramework_Test.createWSConfig('B360GetBenefitsSectionAPI', tokenAPIWSConfig.Id);
        OrgSpecificConfigurations__c orgSpecificConfigs4 = ACET_WebserviceCalloutFramework_Test.createOrgWSConfigs(wsConfig4.Id);
        System.debug(orgSpecificConfigs4);
        // Service API data
        WebserviceConfigurations__c wsConfig5 = ACET_WebserviceCalloutFramework_Test.createWSConfig('NimbusGetSSBService', tokenAPIWSConfig.Id);
        OrgSpecificConfigurations__c orgSpecificConfigs5 = ACET_WebserviceCalloutFramework_Test.createOrgWSConfigs(wsConfig5.Id);
        System.debug(orgSpecificConfigs5);
    }
    @isTest
    static void testNimbusGetSSBRespnse(){
        ACETLGT_NimbusGetSSBResponse response = new ACETLGT_NimbusGetSSBResponse();
        response.getSubscriptionServiceBenefitResponse = null;
        System.debug(JSON.serialize(response));
        ACETLGT_NimbusGetSSBResponse.GetSubscriptionServiceBenefitResponse getSubscriptionServiceBenefitResponse = new ACETLGT_NimbusGetSSBResponse.GetSubscriptionServiceBenefitResponse();
		getSubscriptionServiceBenefitResponse.serviceBenefit = null;
        System.debug(JSON.serialize(getSubscriptionServiceBenefitResponse));
        ACETLGT_NimbusGetSSBResponse.ServiceBenefit serviceBenefit = new ACETLGT_NimbusGetSSBResponse.ServiceBenefit();
		serviceBenefit.memberGroup = null;
		serviceBenefit.memberGroupContractPlanOption = null;
        System.debug(JSON.serialize(serviceBenefit));
        ACETLGT_NimbusGetSSBResponse.MemberGroup memberGroup = new ACETLGT_NimbusGetSSBResponse.MemberGroup();
		memberGroup.groupNumber = '';
		memberGroup.groupName = '';
        System.debug(JSON.serialize(memberGroup));
        ACETLGT_NimbusGetSSBResponse.MemberGroupContractPlanOption memberGroupContractPlanOption = new ACETLGT_NimbusGetSSBResponse.MemberGroupContractPlanOption();
		memberGroupContractPlanOption.benefitBundleOptionId = '';
		memberGroupContractPlanOption.planMetallicLevel = '';
		memberGroupContractPlanOption.oonPricingType = '';
		memberGroupContractPlanOption.ucrPercentile = '';
		memberGroupContractPlanOption.mnrpPercentile = '';
		memberGroupContractPlanOption.fallThruPercent = '';
		memberGroupContractPlanOption.bookOfBusinessTypeCode = '';
		memberGroupContractPlanOption.bookOfBusinessTypeDescription = '';
		memberGroupContractPlanOption.lineOfBusinessId = '';
		memberGroupContractPlanOption.lineOfBusinessName = '';
		memberGroupContractPlanOption.lineOfBusinessDescription = '';
		memberGroupContractPlanOption.benefitPlan = null;
        System.debug(JSON.serialize(memberGroupContractPlanOption));
        ACETLGT_NimbusGetSSBResponse.BenefitPlan benefitPlan = new ACETLGT_NimbusGetSSBResponse.BenefitPlan();
		benefitPlan.membership = null;
		benefitPlan.benefitPlanId = '';
		benefitPlan.coverageType = '';
		benefitPlan.carrierId = '';
		benefitPlan.legalEntityName = '';
		benefitPlan.networkScheduleIds = null;
		benefitPlan.benefitServiceArea = '';
		benefitPlan.gatedProductIndicator = '';
		benefitPlan.pcpRequiredIndicator = '';
		benefitPlan.productName = '';
		benefitPlan.productId = '';
		benefitPlan.planTypeCode = '';
		benefitPlan.timelyFilingLimitDuration = '';
		benefitPlan.timelyFilingLimitType = '';
		benefitPlan.customerFacingPlanName = '';
		benefitPlan.administeredByName = '';
		benefitPlan.riderOnlyFlag = '';
		benefitPlan.planRiderType = '';
		benefitPlan.planTier = null;
		benefitPlan.benefitCode = null;
		benefitPlan.eHBIndicator = '';
		benefitPlan.externalIds = null;
		benefitPlan.qualityProviderTierRuleID = '';
		benefitPlan.placeOfServiceDifferentialIndicator = '';
		benefitPlan.fundingArrangementCode = '';
		benefitPlan.fundingArrangementDescription = '';
		benefitPlan.revenueArrangementCode = '';
		benefitPlan.revenueArrangementDescription = '';
		benefitPlan.carrierBusinessId = '';
		benefitPlan.memberEnrollServiceAreaType = '';
		benefitPlan.attribSchedule = null;
        System.debug(JSON.serialize(benefitPlan));
        ACETLGT_NimbusGetSSBResponse.Membership membership = new ACETLGT_NimbusGetSSBResponse.Membership();
		membership.subscriberIdentifier = null;
		membership.enrolleeIdentifier = null;
		membership.coverageStartDate = '';
		membership.coverageEndDate = '';
		membership.timePeriodQualifier = '';
		membership.contractOptionStartDate = '';
		membership.contractOptionEndDate = '';
        System.debug(JSON.serialize(membership));
        ACETLGT_NimbusGetSSBResponse.NetworkScheduleIds networkScheduleIds = new ACETLGT_NimbusGetSSBResponse.NetworkScheduleIds();
		networkScheduleIds.networkScheduleId = '';
        System.debug(JSON.serialize(networkScheduleIds));
        ACETLGT_NimbusGetSSBResponse.PlanTier planTier =  new  ACETLGT_NimbusGetSSBResponse.PlanTier();
		planTier.tierIdentifier = '';
		planTier.tierDescription = '';
		planTier.tierTypeCode = '';
		planTier.tierTypeDescription = '';
		planTier.gatedPlanIndicator = '';
		planTier.primaryCoInsurance = '';
		planTier.accumulatorAmounts = null;
		planTier.erCopay = null;
		planTier.pcpCopay = null;
		planTier.specialistCopay = null;
		planTier.virtualVisitsCopay = null;
		planTier.urgentCareCopay = null;
		planTier.outPatientCopay = null;
		planTier.inPatientCopay = null;
		planTier.serviceAreaType = '';
		planTier.networkTier = null;
		planTier.network = null;
		planTier.planDelegation = null;
		planTier.primaryOopComposition = null;
		planTier.networkAccessTypeCode = '';
		planTier.networkAccessTypeDescription = '';
		planTier.tierLevelServiceProvider = null;
		planTier.tier1Copay = null;
        System.debug(JSON.serialize(planTier));
        ACETLGT_NimbusGetSSBResponse.BenefitCode benefitCode = new ACETLGT_NimbusGetSSBResponse.BenefitCode();
		benefitCode.benefitName = '';
		benefitCode.benefitCode = '';
		benefitCode.benefitDisplay = '';
		benefitCode.benefitTier = null;
		benefitCode.benefitType = '';
		benefitCode.primaryOOPOnlyFlag = '';
		benefitCode.primaryDeductibleOnlyFlag = '';
		benefitCode.visitLimitsApplies = '';
		benefitCode.copayApplies = '';
		benefitCode.variableCoverage = '';
		benefitCode.existsOnRiderPlan = '';
		benefitCode.hipaaServiceTypes = null;
        System.debug(JSON.serialize(benefitCode));
        ACETLGT_NimbusGetSSBResponse.ExternalIds externalIds = new ACETLGT_NimbusGetSSBResponse.ExternalIds();
		externalIds.entityId = '';
		externalIds.externalPlanId = '';
        System.debug(JSON.serialize(externalIds));
        ACETLGT_NimbusGetSSBResponse.AttribSchedule attribSchedule = new ACETLGT_NimbusGetSSBResponse.AttribSchedule();
		attribSchedule.attribScheduleID = '';
		attribSchedule.attribScheduleDesc = '';
		attribSchedule.attribScheduleType = '';
		attribSchedule.attribScheduleTypeDisplay = '';
		attribSchedule.attribScheduleEffectiveDate = '';
		attribSchedule.attribScheduleExpirationDate = '';
		attribSchedule.nameValue = null;
        System.debug(JSON.serialize(attribSchedule));
        ACETLGT_NimbusGetSSBResponse.Identifier identifier = new ACETLGT_NimbusGetSSBResponse.Identifier();
		identifier.type = '';
		identifier.id = '';
        System.debug(JSON.serialize(identifier));
        ACETLGT_NimbusGetSSBResponse.AccumulatorAmount accumulatorAmount = new ACETLGT_NimbusGetSSBResponse.AccumulatorAmount();
        accumulatorAmount.accumLevel = '';
        accumulatorAmount.individualDeductibleMaximum = '';
        accumulatorAmount.familyDeductibleMaximum = '';
        accumulatorAmount.individualOOPMaximum = '';
        accumulatorAmount.familyOOPMaximum = '';
        accumulatorAmount.individualDeductibleYTD = '';
        accumulatorAmount.familyDeductibleYTD = '';
        accumulatorAmount.individualOOPYTD = '';
        accumulatorAmount.familyOOPYTD = '';
        accumulatorAmount.familyAccumulationTypeDescriptionDeductible = '';
        accumulatorAmount.familyAccumulationTypeDescriptionOOP = '';
        accumulatorAmount.deductibleCarryOverIndicator = '';
        accumulatorAmount.shareBasePlanAccumulatorIndicatorOOP = '';
        accumulatorAmount.shareBasePlanAccumulatorIndicatorDeductible = '';
        System.debug(JSON.serialize(accumulatorAmount));
        ACETLGT_NimbusGetSSBResponse.Network network = new ACETLGT_NimbusGetSSBResponse.Network();
        network.id = '';
        network.description = '';
        System.debug(JSON.serialize(network));
        ACETLGT_NimbusGetSSBResponse.PlanDelegation planDelegation = new ACETLGT_NimbusGetSSBResponse.PlanDelegation();
        planDelegation.delegationIndicator = '';
        planDelegation.delegationIdentifier = '';
        planDelegation.delegationName = '';
        System.debug(JSON.serialize(planDelegation));
        ACETLGT_NimbusGetSSBResponse.PrimaryOopComposition primaryOopComposition = new ACETLGT_NimbusGetSSBResponse.PrimaryOopComposition();
    	primaryOopComposition.costShareType = null;
        System.debug(JSON.serialize(primaryOopComposition));
        ACETLGT_NimbusGetSSBResponse.TierLevelServiceProvider tierLevelServiceProvider = new ACETLGT_NimbusGetSSBResponse.TierLevelServiceProvider();
        tierLevelServiceProvider.providerAssignmentTypeCode = '';
        tierLevelServiceProvider.providerAssignmentTypeDescription = '';
        tierLevelServiceProvider.providerSelectionOptionalIndicator = '';
        tierLevelServiceProvider.referralConditionTypeCode = '';
        tierLevelServiceProvider.referralConditionTypeDescription = '';
        tierLevelServiceProvider.providerAssignmentLevel = '';
        tierLevelServiceProvider.providerAssignmentLevelDesc = '';
        System.debug(JSON.serialize(tierLevelServiceProvider));
        ACETLGT_NimbusGetSSBResponse.HipaaServiceTypes hipaaServiceTypes = new ACETLGT_NimbusGetSSBResponse.HipaaServiceTypes();
        hipaaServiceTypes.categoryCode = '';
        hipaaServiceTypes.categoryCodeDescription = '';
        hipaaServiceTypes.serviceTypeCode = '';
        hipaaServiceTypes.serviceTypeDescription = '';
        System.debug(JSON.serialize(hipaaServiceTypes));
        ACETLGT_NimbusGetSSBResponse.NameValue nameValue= new ACETLGT_NimbusGetSSBResponse.NameValue();
        nameValue.name = '';
        nameValue.value = '';
        nameValue.effectiveDate = '';
        nameValue.expirationDate = '';
        System.debug(JSON.serialize(NameValue)); 
    }
    @isTest
    static void testGetSearchResults(){
        test.startTest();
        ACETLGT_PlanBenefitController.getSearchResults(surrogateKey, bundleId, enrollerSRK, startDate, endDate, coverageTypes, groupNumber, accumAsOf, situsState, customerPurchaseId);
        MockHttpCalloutResponseGenerator.MockHttpResponse mockResponse = new MockHttpCalloutResponseGenerator.MockHttpResponse(statusCode200, status200, nimbusGetSSBResponse);        
        mockResponse.TokenExpired = false;        
        MockHttpCalloutResponseGenerator mockHttpRes = new MockHttpCalloutResponseGenerator(null, mockResponse);
        Test.setMock(HttpCalloutMock.class, mockHttpRes);
		ACETLGT_PlanBenefitController.getSearchResults(surrogateKey, bundleId, enrollerSRK, startDate, endDate, coverageTypes, groupNumber, accumAsOf, situsState, customerPurchaseId);
        MockHttpCalloutResponseGenerator.MockHttpResponse mockResponse1 = new MockHttpCalloutResponseGenerator.MockHttpResponse(statusCode400, status400, nimbusGetSSBBadResponse);        
        mockResponse1.TokenExpired = false;        
        MockHttpCalloutResponseGenerator mockHttpRes1 = new MockHttpCalloutResponseGenerator(null, mockResponse1);
        Test.setMock(HttpCalloutMock.class, mockHttpRes1);
		ACETLGT_PlanBenefitController.getSearchResults(surrogateKey, bundleId, enrollerSRK, startDate, endDate, coverageTypes, groupNumber, accumAsOf, situsState, customerPurchaseId);
        MockHttpCalloutResponseGenerator.MockHttpResponse mockResponse2 = new MockHttpCalloutResponseGenerator.MockHttpResponse(statusCode500, status500, nimbusGetSSBBadResponse);        
        mockResponse2.TokenExpired = false;        
        MockHttpCalloutResponseGenerator mockHttpRes2 = new MockHttpCalloutResponseGenerator(null, mockResponse2);
        Test.setMock(HttpCalloutMock.class, mockHttpRes2);
		ACETLGT_PlanBenefitController.getSearchResults(surrogateKey, bundleId, enrollerSRK, startDate, endDate, coverageTypes, groupNumber, accumAsOf, situsState, customerPurchaseId);
        MockHttpCalloutResponseGenerator.MockHttpResponse mockResponse3 = new MockHttpCalloutResponseGenerator.MockHttpResponse(statusCode404, status404, nimbusGetSSBBadResponse);        
        mockResponse3.TokenExpired = false;        
        MockHttpCalloutResponseGenerator mockHttpRes3 = new MockHttpCalloutResponseGenerator(null, mockResponse3);
        Test.setMock(HttpCalloutMock.class, mockHttpRes3);
		ACETLGT_PlanBenefitController.getSearchResults(surrogateKey, bundleId, enrollerSRK, startDate, endDate, coverageTypes, groupNumber, accumAsOf, situsState, customerPurchaseId);
        MockHttpCalloutResponseGenerator.MockHttpResponse mockResponse4 = new MockHttpCalloutResponseGenerator.MockHttpResponse(statusCode504, status504, nimbusGetSSBBadResponse);
        mockResponse4.TokenExpired = false;        
        MockHttpCalloutResponseGenerator mockHttpRes4 = new MockHttpCalloutResponseGenerator(null, mockResponse4);
        Test.setMock(HttpCalloutMock.class, mockHttpRes4);
		ACETLGT_PlanBenefitController.getSearchResults(surrogateKey, bundleId, enrollerSRK, startDate, endDate, coverageTypes, groupNumber, accumAsOf, situsState, customerPurchaseId);
        MockHttpCalloutResponseGenerator.MockHttpResponse mockResponse5 = new MockHttpCalloutResponseGenerator.MockHttpResponse(statusCode999, status999, nimbusGetSSBBadResponse);
        mockResponse4.TokenExpired = false;        
        MockHttpCalloutResponseGenerator mockHttpRes5 = new MockHttpCalloutResponseGenerator(null, mockResponse5);
        Test.setMock(HttpCalloutMock.class, mockHttpRes5);
		ACETLGT_PlanBenefitController.getSearchResults(surrogateKey, bundleId, enrollerSRK, startDate, endDate, coverageTypes, groupNumber, accumAsOf, situsState, customerPurchaseId);
        test.stopTest();
    }
    @isTest
    static void testGetSearchAccumResults(){
        test.startTest();
        ACETLGT_PlanBenefitController.getSearchAccumResults(surrogateKey, bundleId, enrollerSRK, startDate, endDate, coverageTypes, groupNumber, accumAsOf, situsState);
        MockHttpCalloutResponseGenerator.MockHttpResponse mockResponse = new MockHttpCalloutResponseGenerator.MockHttpResponse(statusCode200, status200, nimbusGetSSBResponse);        
        mockResponse.TokenExpired = false;        
        MockHttpCalloutResponseGenerator mockHttpRes = new MockHttpCalloutResponseGenerator(null, mockResponse);
        Test.setMock(HttpCalloutMock.class, mockHttpRes);
		ACETLGT_PlanBenefitController.getSearchAccumResults(surrogateKey, bundleId, enrollerSRK, startDate, endDate, coverageTypes, groupNumber, accumAsOf, situsState);
        MockHttpCalloutResponseGenerator.MockHttpResponse mockResponse1 = new MockHttpCalloutResponseGenerator.MockHttpResponse(statusCode400, status400, nimbusGetSSBBadResponse);        
        mockResponse1.TokenExpired = false;        
        MockHttpCalloutResponseGenerator mockHttpRes1 = new MockHttpCalloutResponseGenerator(null, mockResponse1);
        Test.setMock(HttpCalloutMock.class, mockHttpRes1);
		ACETLGT_PlanBenefitController.getSearchAccumResults(surrogateKey, bundleId, enrollerSRK, startDate, endDate, coverageTypes, groupNumber, accumAsOf, situsState);
        MockHttpCalloutResponseGenerator.MockHttpResponse mockResponse2 = new MockHttpCalloutResponseGenerator.MockHttpResponse(statusCode500, status500, nimbusGetSSBBadResponse);        
        mockResponse2.TokenExpired = false;        
        MockHttpCalloutResponseGenerator mockHttpRes2 = new MockHttpCalloutResponseGenerator(null, mockResponse2);
        Test.setMock(HttpCalloutMock.class, mockHttpRes2);
		ACETLGT_PlanBenefitController.getSearchAccumResults(surrogateKey, bundleId, enrollerSRK, startDate, endDate, coverageTypes, groupNumber, accumAsOf, situsState);
        MockHttpCalloutResponseGenerator.MockHttpResponse mockResponse3 = new MockHttpCalloutResponseGenerator.MockHttpResponse(statusCode404, status404, nimbusGetSSBBadResponse);        
        mockResponse3.TokenExpired = false;        
        MockHttpCalloutResponseGenerator mockHttpRes3 = new MockHttpCalloutResponseGenerator(null, mockResponse3);
        Test.setMock(HttpCalloutMock.class, mockHttpRes3);
		ACETLGT_PlanBenefitController.getSearchAccumResults(surrogateKey, bundleId, enrollerSRK, startDate, endDate, coverageTypes, groupNumber, accumAsOf, situsState);
        MockHttpCalloutResponseGenerator.MockHttpResponse mockResponse4 = new MockHttpCalloutResponseGenerator.MockHttpResponse(statusCode504, status504, nimbusGetSSBBadResponse);
        mockResponse4.TokenExpired = false;        
        MockHttpCalloutResponseGenerator mockHttpRes4 = new MockHttpCalloutResponseGenerator(null, mockResponse4);
        Test.setMock(HttpCalloutMock.class, mockHttpRes4);
		ACETLGT_PlanBenefitController.getSearchAccumResults(surrogateKey, bundleId, enrollerSRK, startDate, endDate, coverageTypes, groupNumber, accumAsOf, situsState);
        MockHttpCalloutResponseGenerator.MockHttpResponse mockResponse5 = new MockHttpCalloutResponseGenerator.MockHttpResponse(statusCode999, status999, nimbusGetSSBBadResponse);
        mockResponse4.TokenExpired = false;        
        MockHttpCalloutResponseGenerator mockHttpRes5 = new MockHttpCalloutResponseGenerator(null, mockResponse5);
        Test.setMock(HttpCalloutMock.class, mockHttpRes5);
		ACETLGT_PlanBenefitController.getSearchAccumResults(surrogateKey, bundleId, enrollerSRK, startDate, endDate, coverageTypes, groupNumber, accumAsOf, situsState);
        test.stopTest();
    }
    @IsTest
    Public static void planBenefitControllerTestForSubscription()
    { 
       ACETLanguageCTIndicator__c languageCTIndicator = new ACETLanguageCTIndicator__c();
       languageCTIndicator.Benefit_Code__c = 'Allergy_Treatment';
       List<ACETLanguageCTIndicator__c> lstLanguageCTIndicator = new List<ACETLanguageCTIndicator__c>();
       lstLanguageCTIndicator.add(languageCTIndicator);
       ACETLGT_PlanBenefitController.getBenefitLanguageIndicatormdt();
       MockHttpCalloutResponseGenerator.MockHttpResponse oilResponse =  new MockHttpCalloutResponseGenerator.MockHttpResponse(statusCode200, status200, nimbusGetSSBResponse);
       OILResponse.TokenExpired = false; 
       MockHttpCalloutResponseGenerator mockHttpRes = new MockHttpCalloutResponseGenerator(null, oilResponse);
       Test.setMock(HttpCalloutMock.class, mockHttpRes);
       ACETLGT_NimbusGetSSBAPI ssbWebservice = new ACETLGT_NimbusGetSSBAPI();
       Test.startTest();
       ACETLGT_PlanBenefitController.getSearchResults('642322404','1248502','642322404','7/1/2019','12/31/2019','','1275777','','CT','cpid');
       ACETLGT_PlanBenefitController.getSearchAccumResults('642322404','1248502','642322404','7/1/2019','12/31/2019','','1275777','','CT');
       String jsonResponse = ([SELECT Id,Body FROM StaticResource Where Name='ACETGetSubscriptionRedesign'][0].Body).toString();
       System.debug(jsonResponse);
       ssbWebservice.parseSuccessAdapterResponse(nimbusGetSSBResponse,true,true);
       Test.stopTest();
    }
    @IsTest
    Public static void planBenefitControllerTestForLanguage()
    { 
       StaticResource ResponseJSONSR = [SELECT Body FROM StaticResource WHERE Name = 'ACETLGT_GetBenefitLanguageResponse'];
       String ResponseJSON = ResponseJSONSR.Body.toString(); 
       MockHttpCalloutResponseGenerator.MockHttpResponse OILResponse =  new MockHttpCalloutResponseGenerator.MockHttpResponse(200, 'OK', ResponseJSON); //ACETTestDataUtility.GetMemberSearchJSON()
       OILResponse.TokenExpired = false; 
       MockHttpCalloutResponseGenerator MockHttpRes = new MockHttpCalloutResponseGenerator(null, OILResponse);
       Test.setMock(HttpCalloutMock.class, MockHttpRes);  
       ACETLGT_GetBenefitLanguageWebService  languageWebservice= new ACETLGT_GetBenefitLanguageWebService();
       Test.startTest();
       String benefitDisplayString = '["RX_TIER_1!Prescription Drug Tier 1","RX_TIER_2!Prescription Drug Tier 2","RX_TIER_3!Prescription Drug Tier 3","ABORTION_ELECTIVE_FREESTANDING_FACILITY!Abortion Elective Freestanding Facility","ABORTION_ELECTIVE_OFFICE!Elective Abortion Office","ABORTION_ELECTIVE_OUTPATIENT!Elective Abortion Outpatient","ABORTION_THERAPEUTIC_FREESTANDING_FACILITY!Abortion Therapeutic Freestanding Facility","ABORTION_THERAPEUTIC_OFFICE!Therapeutic Abortion Office"]';
       String languageString = '["AMBULATORY_SURGERY_CENTER_REV","BEHAVIORAL_HEALTH_OFFICE"]';
       ACETLGT_PlanBenefitController.getBenefitLanguageResults('1248502','ALLERGY_TREATMENT_OFFICE','2019-12-31','1275777','',true,benefitDisplayString,languageString,'2019-12-31');
       List<String> benefitDisplayLst = new List<String>(); 
       if(benefitDisplayString != null && benefitDisplayString != ''){
                benefitDisplayLst = (List<String>) JSON.deserialize(benefitDisplayString, list<String>.class); 
       } 
       List<String> benefitLanguageIndicatorLst = new List<String>(); 
       if(languageString != null && languageString != ''){
                benefitLanguageIndicatorLst = (List<String>) JSON.deserialize(languageString, list<String>.class); 
       } 
       List<String> benefitCodeLst = new list<String>();
       String benefitcode = 'ALLERGY_TREATMENT_OFFICE';
       benefitCodeLst.add(benefitcode);
       Map<String,String> benefitDisplayMap = new Map<String,String>();
       benefitDisplayMap.put('RX_TIER_1','Prescription Drug Tier 1');
       languageWebservice.getPlanBenefitLanguageNew('1248502',benefitCodeLst,'2019-12-31','1275777','',true,benefitDisplayMap,benefitLanguageIndicatorLst,'2019-12-31');
       ACETLGT_PlanBenefitLanguageJson2Apex json2apex = ACETLGT_PlanBenefitLanguageJson2Apex.parse(ResponseJSON);
       Test.stopTest();
    }
    @IsTest
    Public static void planBenefitControllerTestForAccumulator()
    { 
       StaticResource ResponseJSONSR = [SELECT Body FROM StaticResource WHERE Name = 'ACETLGT_GetAccumulatorResponseJSON'];
       String ResponseJSON = ResponseJSONSR.Body.toString(); 
       MockHttpCalloutResponseGenerator.MockHttpResponse OILResponse =  new MockHttpCalloutResponseGenerator.MockHttpResponse(200, 'OK', ResponseJSON); //ACETTestDataUtility.GetMemberSearchJSON()
       OILResponse.TokenExpired = false; 
       MockHttpCalloutResponseGenerator MockHttpRes = new MockHttpCalloutResponseGenerator(null, OILResponse);
       Test.setMock(HttpCalloutMock.class, MockHttpRes);  
       ACETLGT_GetAccumulatorRedesignWebservice  accumuWebservice= new ACETLGT_GetAccumulatorRedesignWebservice();
       Test.startTest();
        ACETLGT_PlanBenefitController.getBenefitAccumulatorResults('642322404','1248502','642322404','7/1/2019','12/31/2019','1275777','ALLERGY_TREATMENT_OFFICE','2019-12-31','M000000785-5,M000000785-4,M000000785-6','Calendar year','4-INN,5-INN,6-INN','["RX_TIER_1 - Prescription Drug Tier 1=true","RX_TIER_2 - Prescription Drug Tier 2=true","RX_TIER_3 - Prescription Drug Tier 3=true","RX_TIER_4 - Prescription Drug Tier 4=true"]');
       accumuWebservice.getDurationCodeMap();
       accumuWebservice.ChangeDateFormatForOIL('09/09/2017');
       accumuWebservice.getValidString('Test');
       ACETLGT_GetAccumulatorRedesignJSON2APEX json2apex = ACETLGT_GetAccumulatorRedesignJSON2APEX.parse(ResponseJSON);
       ACETLGT_PlanBenefitLanguageWrapper benflangwrap = new ACETLGT_PlanBenefitLanguageWrapper();
       ACETLGT_PlanBenefitLanguageWrapper.BenefitWrapper benwrap = new ACETLGT_PlanBenefitLanguageWrapper.BenefitWrapper();
        benwrap.description = 'Langauge details';
        List<ACETLGT_PlanBenefitLanguageWrapper.BenefitWrapper> accumList = new List<ACETLGT_PlanBenefitLanguageWrapper.BenefitWrapper>(); 
        accumList.add(benwrap);
        ACETLGT_PlanBenefitLanguageWrapper.AccumulatorCode accumcode1 = new ACETLGT_PlanBenefitLanguageWrapper.AccumulatorCode();
        accumcode1.coverageLevel = 'Family';
        accumcode1.costShareType = 'Copayment';
        accumcode1.benefitMaximumValue = '0.00';
        accumcode1.benefitMaximumUnit = 'Dollar';
        accumcode1.benefitYTDValue = '0.00';
        accumcode1.benefitRemainingValue = '';
        accumcode1.costShareId = 'M01';
        accumcode1.compareTo(accumcode1);
       Test.stopTest();
    }
    @IsTest
    Public static void planBenefitControllerTestmethodForBenefitLanguageFailure()
    {
        String   ResponseJSON = '{"getBenefitLanguageResponse":{"errors":[{"code":"W008","name":"No records returned","severity":"low",';
        ResponseJSON += '"origin":"Consumer","description":"Consumer has requested a query for which no records have been found."}]}}';
        MockHttpCalloutResponseGenerator.MockHttpResponse OILTestResponse = new MockHttpCalloutResponseGenerator.MockHttpResponse(404, 'Resource Not Found', ResponseJSON);
        OILTestResponse.TokenExpired = false;
        Test.startTest();
        MockHttpCalloutResponseGenerator MockHttpResponse = new MockHttpCalloutResponseGenerator(null, OILTestResponse);
        Test.setMock(HttpCalloutMock.class, MockHttpResponse);
        String benefitDisplayString = '["RX_TIER_1!Prescription Drug Tier 1","RX_TIER_2!Prescription Drug Tier 2","RX_TIER_3!Prescription Drug Tier 3","ABORTION_ELECTIVE_FREESTANDING_FACILITY!Abortion Elective Freestanding Facility","ABORTION_ELECTIVE_OFFICE!Elective Abortion Office","ABORTION_ELECTIVE_OUTPATIENT!Elective Abortion Outpatient","ABORTION_THERAPEUTIC_FREESTANDING_FACILITY!Abortion Therapeutic Freestanding Facility","ABORTION_THERAPEUTIC_OFFICE!Therapeutic Abortion Office"]';
        String languageString = '["AMBULATORY_SURGERY_CENTER_REV","BEHAVIORAL_HEALTH_OFFICE"]';
        ACETLGT_PlanBenefitController.getBenefitLanguageResults('1248502','ALLERGY_TREATMENT_OFFICE','2019-12-31','1275777','',true,benefitDisplayString,languageString,'2019-12-31');
        List<String> benefitDisplayLst = new List<String>(); 
        Test.stopTest();
    }
    @IsTest
    Public static void planBenefitControllerTestForAccumulatorFailure()
    { 
       HttpResponse res = new HttpResponse();
       res.setHeader('Content-Type', 'application/json');
       res.setBody('{"getBenefitAccumulatorResponse":{"errors":[{"code":"W008","name":"No records returned","severity":"low","origin":"Consumer","description":"Consumer has requested a query for which no records have been found."}]}}');
       res.setStatusCode(404);
       String ResponseJSON = '{"getBenefitAccumulatorResponse":{"errors":[{"code":"W008","name":"No records returned","severity":"low",';
       ResponseJSON += '"origin":"Consumer","description":"Consumer has requested a query for which no records have been found."}]}}'; 
       ACETLGT_GetAccumulatorRedesignWebservice  accumuWebservice= new ACETLGT_GetAccumulatorRedesignWebservice();
       Test.startTest();
       accumuWebservice.ParseFailureResponseFromOil(res);
       ACETLGT_PlanBenefitController.getBenefitAccumulatorResults('642322404','1248502','642322404','7/1/2019','12/31/2019','1275777','ALLERGY_TREATMENT_OFFICE','2019-12-31','M000000785-5,M000000785-4,M000000785-6','Calendar year','04-INN,05-INN,06-INN','["RX_TIER_1 - Prescription Drug Tier 1=true","RX_TIER_2 - Prescription Drug Tier 2=true","RX_TIER_3 - Prescription Drug Tier 3=true","RX_TIER_4 - Prescription Drug Tier 4=true"]');
       Test.stopTest();
    }
    
    @isTest 
    static void testIsAvailableServiceCall() {
          
        test.startTest();
        MockHttpCalloutResponseGenerator.MockHttpResponse mockResponse5 = new MockHttpCalloutResponseGenerator.MockHttpResponse(statusCode200, status200, benAvailableRes1);        
        mockResponse5.TokenExpired = false;        
        MockHttpCalloutResponseGenerator mockHttpRes5 = new MockHttpCalloutResponseGenerator(null, mockResponse5);
        Test.setMock(HttpCalloutMock.class, mockHttpRes5);
        ACETLGT_PlanBenefitController.isAvailableServiceCall(benefitPlanId,benefitDateSearch);
        
        
        MockHttpCalloutResponseGenerator.MockHttpResponse mockResponse = new MockHttpCalloutResponseGenerator.MockHttpResponse(statusCode200, status200, benAvailableRes2);        
        mockResponse.TokenExpired = false;        
        MockHttpCalloutResponseGenerator mockHttpRes = new MockHttpCalloutResponseGenerator(null, mockResponse);
        Test.setMock(HttpCalloutMock.class, mockHttpRes);
		ACETLGT_PlanBenefitController.isAvailableServiceCall(benefitPlanId,benefitDateSearch);
        
        
        MockHttpCalloutResponseGenerator.MockHttpResponse mockResponse1 = new MockHttpCalloutResponseGenerator.MockHttpResponse(statusCode400, status400, b360BadResponse);        
        mockResponse1.TokenExpired = false;        
        MockHttpCalloutResponseGenerator mockHttpRes1 = new MockHttpCalloutResponseGenerator(null, mockResponse1);
        Test.setMock(HttpCalloutMock.class, mockHttpRes1);
		ACETLGT_PlanBenefitController.isAvailableServiceCall(benefitPlanId,benefitDateSearch);
        
        MockHttpCalloutResponseGenerator.MockHttpResponse mockResponse2 = new MockHttpCalloutResponseGenerator.MockHttpResponse(statusCode500, status500, b360BadResponse);
        mockResponse2.TokenExpired = false;        
        MockHttpCalloutResponseGenerator mockHttpRes2 = new MockHttpCalloutResponseGenerator(null, mockResponse2);
        Test.setMock(HttpCalloutMock.class, mockHttpRes2);
		ACETLGT_PlanBenefitController.isAvailableServiceCall(benefitPlanId,benefitDateSearch);
        
        MockHttpCalloutResponseGenerator.MockHttpResponse mockResponse3 = new MockHttpCalloutResponseGenerator.MockHttpResponse(statusCode404, status404, b360BadResponse);
        mockResponse3.TokenExpired = false;        
        MockHttpCalloutResponseGenerator mockHttpRes3 = new MockHttpCalloutResponseGenerator(null, mockResponse3);
        Test.setMock(HttpCalloutMock.class, mockHttpRes3);
		ACETLGT_PlanBenefitController.isAvailableServiceCall(benefitPlanId,benefitDateSearch);
        
        MockHttpCalloutResponseGenerator.MockHttpResponse mockResponse4 = new MockHttpCalloutResponseGenerator.MockHttpResponse(statusCode504, status504, b360BadResponse);
        mockResponse4.TokenExpired = false;        
        MockHttpCalloutResponseGenerator mockHttpRes4 = new MockHttpCalloutResponseGenerator(null, mockResponse4);
        Test.setMock(HttpCalloutMock.class, mockHttpRes4);
		ACETLGT_PlanBenefitController.isAvailableServiceCall(benefitPlanId,benefitDateSearch);
        
        test.stopTest();
	}
    
    @isTest 
    static void testGetB360BenefitCategory() {
        
        test.startTest();
        ACETLGT_PlanBenefitController.getB360BenefitCategory(benefitPlanId,benefitDateSearch);
        
        MockHttpCalloutResponseGenerator.MockHttpResponse mockResponse = new MockHttpCalloutResponseGenerator.MockHttpResponse(statusCode200, status200, benCatResponse);        
        mockResponse.TokenExpired = false;        
        MockHttpCalloutResponseGenerator mockHttpRes = new MockHttpCalloutResponseGenerator(null, mockResponse);
        Test.setMock(HttpCalloutMock.class, mockHttpRes);
		ACETLGT_PlanBenefitController.getB360BenefitCategory(benefitPlanId,benefitDateSearch);
        
        
        MockHttpCalloutResponseGenerator.MockHttpResponse mockResponse1 = new MockHttpCalloutResponseGenerator.MockHttpResponse(statusCode400, status400, b360BadResponse);        
        mockResponse1.TokenExpired = false;        
        MockHttpCalloutResponseGenerator mockHttpRes1 = new MockHttpCalloutResponseGenerator(null, mockResponse1);
        Test.setMock(HttpCalloutMock.class, mockHttpRes1);
		ACETLGT_PlanBenefitController.getB360BenefitCategory(benefitPlanId,benefitDateSearch);
        
        MockHttpCalloutResponseGenerator.MockHttpResponse mockResponse2 = new MockHttpCalloutResponseGenerator.MockHttpResponse(statusCode500, status500, b360BadResponse);        
        mockResponse2.TokenExpired = false;        
        MockHttpCalloutResponseGenerator mockHttpRes2 = new MockHttpCalloutResponseGenerator(null, mockResponse2);
        Test.setMock(HttpCalloutMock.class, mockHttpRes2);
		ACETLGT_PlanBenefitController.getB360BenefitCategory(benefitPlanId,benefitDateSearch);
        
        MockHttpCalloutResponseGenerator.MockHttpResponse mockResponse3 = new MockHttpCalloutResponseGenerator.MockHttpResponse(statusCode404, status404, b360BadResponse);        
        mockResponse3.TokenExpired = false;        
        MockHttpCalloutResponseGenerator mockHttpRes3 = new MockHttpCalloutResponseGenerator(null, mockResponse3);
        Test.setMock(HttpCalloutMock.class, mockHttpRes3);
		ACETLGT_PlanBenefitController.getB360BenefitCategory(benefitPlanId,benefitDateSearch);
        
        MockHttpCalloutResponseGenerator.MockHttpResponse mockResponse4 = new MockHttpCalloutResponseGenerator.MockHttpResponse(statusCode504, status504, b360BadResponse);
        mockResponse4.TokenExpired = false;        
        MockHttpCalloutResponseGenerator mockHttpRes4 = new MockHttpCalloutResponseGenerator(null, mockResponse4);
        Test.setMock(HttpCalloutMock.class, mockHttpRes4);
		ACETLGT_PlanBenefitController.getB360BenefitCategory(benefitPlanId,benefitDateSearch);
        
        test.stopTest();
	}
     
    @isTest 
    static void testSearchBenefitsByPhrase() {
        
        
        test.startTest();
        
        MockHttpCalloutResponseGenerator.MockHttpResponse mockResponse = new MockHttpCalloutResponseGenerator.MockHttpResponse(statusCode200, status200,benSearchResponse1);        
        mockResponse.TokenExpired = false;        
        MockHttpCalloutResponseGenerator mockHttpRes = new MockHttpCalloutResponseGenerator(null, mockResponse);
        Test.setMock(HttpCalloutMock.class, mockHttpRes);
		ACETLGT_PlanBenefitController.searchBenefitsByPhrase(benefitPlanId,searchedKeyword,benefitDateSearch);
        
        MockHttpCalloutResponseGenerator.MockHttpResponse mockResponse1 = new MockHttpCalloutResponseGenerator.MockHttpResponse(statusCode200, status200,benSearchResponse2);        
        mockResponse.TokenExpired = false;        
        MockHttpCalloutResponseGenerator mockHttpRes1 = new MockHttpCalloutResponseGenerator(null, mockResponse1);
        Test.setMock(HttpCalloutMock.class, mockHttpRes1);
		ACETLGT_PlanBenefitController.searchBenefitsByPhrase(benefitPlanId,searchedKeyword,benefitDateSearch);
        
        
        MockHttpCalloutResponseGenerator.MockHttpResponse mockResponse2 = new MockHttpCalloutResponseGenerator.MockHttpResponse(statusCode400, status400,b360BadResponse);        
        mockResponse1.TokenExpired = false;        
        MockHttpCalloutResponseGenerator mockHttpRes2 = new MockHttpCalloutResponseGenerator(null, mockResponse2);
        Test.setMock(HttpCalloutMock.class, mockHttpRes2);
		ACETLGT_PlanBenefitController.searchBenefitsByPhrase(benefitPlanId,searchedKeyword,benefitDateSearch);
        
        MockHttpCalloutResponseGenerator.MockHttpResponse mockResponse3 = new MockHttpCalloutResponseGenerator.MockHttpResponse(statusCode500, status500,b360BadResponse);        
        mockResponse2.TokenExpired = false;        
        MockHttpCalloutResponseGenerator mockHttpRes3 = new MockHttpCalloutResponseGenerator(null, mockResponse3);
        Test.setMock(HttpCalloutMock.class, mockHttpRes3);
		ACETLGT_PlanBenefitController.searchBenefitsByPhrase(benefitPlanId,searchedKeyword,benefitDateSearch);
        
        MockHttpCalloutResponseGenerator.MockHttpResponse mockResponse4 = new MockHttpCalloutResponseGenerator.MockHttpResponse(statusCode404, status404,b360BadResponse);        
        mockResponse3.TokenExpired = false;        
        MockHttpCalloutResponseGenerator mockHttpRes4 = new MockHttpCalloutResponseGenerator(null, mockResponse4);
        Test.setMock(HttpCalloutMock.class, mockHttpRes4);
		ACETLGT_PlanBenefitController.searchBenefitsByPhrase(benefitPlanId,searchedKeyword,benefitDateSearch);
        
        MockHttpCalloutResponseGenerator.MockHttpResponse mockResponse5 = new MockHttpCalloutResponseGenerator.MockHttpResponse(statusCode504, status504,b360BadResponse);        
        mockResponse4.TokenExpired = false;        
        MockHttpCalloutResponseGenerator mockHttpRes5 = new MockHttpCalloutResponseGenerator(null, mockResponse5);
        Test.setMock(HttpCalloutMock.class, mockHttpRes5);
		ACETLGT_PlanBenefitController.searchBenefitsByPhrase(benefitPlanId,searchedKeyword,benefitDateSearch);
        
        test.stopTest();
	}
    
    @isTest 
    static void testGetBenefitSection() {
        
        test.startTest();
        
        MockHttpCalloutResponseGenerator.MockHttpResponse mockResponse = new MockHttpCalloutResponseGenerator.MockHttpResponse(statusCode200, status200, benSecResponse1);        
        mockResponse.TokenExpired = false;        
        MockHttpCalloutResponseGenerator mockHttpRes = new MockHttpCalloutResponseGenerator(null, mockResponse);
        Test.setMock(HttpCalloutMock.class, mockHttpRes);
		ACETLGT_PlanBenefitController.getBenefitSection(benefitId);
        
        MockHttpCalloutResponseGenerator.MockHttpResponse mockResponse1 = new MockHttpCalloutResponseGenerator.MockHttpResponse(statusCode200, status200, benSecResponse2);
        mockResponse.TokenExpired = false;        
        MockHttpCalloutResponseGenerator mockHttpRes1 = new MockHttpCalloutResponseGenerator(null, mockResponse1);
        Test.setMock(HttpCalloutMock.class, mockHttpRes1);
		ACETLGT_PlanBenefitController.getBenefitSection(benefitId);
        
        
        MockHttpCalloutResponseGenerator.MockHttpResponse mockResponse2 = new MockHttpCalloutResponseGenerator.MockHttpResponse(statusCode400, status400, b360BadResponse); 
        mockResponse1.TokenExpired = false;        
        MockHttpCalloutResponseGenerator mockHttpRes2 = new MockHttpCalloutResponseGenerator(null, mockResponse2);
        Test.setMock(HttpCalloutMock.class, mockHttpRes2);
		ACETLGT_PlanBenefitController.getBenefitSection(benefitId);
        
        MockHttpCalloutResponseGenerator.MockHttpResponse mockResponse3 = new MockHttpCalloutResponseGenerator.MockHttpResponse(statusCode500, status500, b360BadResponse); 
        mockResponse2.TokenExpired = false;        
        MockHttpCalloutResponseGenerator mockHttpRes3 = new MockHttpCalloutResponseGenerator(null, mockResponse3);
        Test.setMock(HttpCalloutMock.class, mockHttpRes3);
		ACETLGT_PlanBenefitController.getBenefitSection(benefitId);
        
        MockHttpCalloutResponseGenerator.MockHttpResponse mockResponse4 = new MockHttpCalloutResponseGenerator.MockHttpResponse(statusCode404, status404, b360BadResponse); 
        mockResponse3.TokenExpired = false;        
        MockHttpCalloutResponseGenerator mockHttpRes4 = new MockHttpCalloutResponseGenerator(null, mockResponse4);
        Test.setMock(HttpCalloutMock.class, mockHttpRes4);
		ACETLGT_PlanBenefitController.getBenefitSection(benefitId);
        
        MockHttpCalloutResponseGenerator.MockHttpResponse mockResponse5 = new MockHttpCalloutResponseGenerator.MockHttpResponse(statusCode504, status504, b360BadResponse); 
        mockResponse4.TokenExpired = false;        
        MockHttpCalloutResponseGenerator mockHttpRes5 = new MockHttpCalloutResponseGenerator(null, mockResponse5);
        Test.setMock(HttpCalloutMock.class, mockHttpRes5);
		ACETLGT_PlanBenefitController.getBenefitSection(benefitId);
        
        test.stopTest();
	}
}