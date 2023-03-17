@isTest(SeeAllData=false)
private class ACETPlanBenefitSearchRedesignCtrlTest{
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
    
    public static final String nimbusGetSSBResponse = '{"getSubscriptionServiceBenefitResponse":{"serviceBenefit":{"memberGroup":{"groupNumber":"1013629","groupName":"E2E_Rivervally_group 20210702035146"},"memberGroupContractPlanOption":{"benefitBundleOptionId":"11958418","planMetallicLevel":"Gold","oonPricingType":"CMS Based","mnrpPercentile":"110.00","ucrPercentile":"80.00","fallThruPercent":"20.00","bookOfBusinessTypeCode":"UH","bookOfBusinessTypeDescription":"UnitedHealthcare Insurance Company","lineOfBusinessId":"2","lineOfBusinessName":"Small Business","lineOfBusinessDescription":"Small Business  (UHC definition = 2 to 50, and Sole Prop)","benefitPlan":[{"membership":[{"subscriberIdentifier":{"type":"SRK","id":"740970865"},"enrolleeIdentifier":{"type":"SRK","id":"740970884"},"coverageStartDate":"2021-01-01","coverageEndDate":"9999-12-31","timePeriodQualifier":"Calendar","contractOptionStartDate":"2021-01-01","contractOptionEndDate":"2021-12-31"}],"benefitPlanId":"M030000189","coverageType":"MEDICAL","carrierId":"36","legalEntityName":"UnitedHealthcare Insurance Company","networkScheduleIds":[{"networkScheduleId":"CHOICEPLUS_1"}],"gatedProductIndicator":"false","pcpRequiredIndicator":"false","productName":"UHC POS Non-Gated INN/OON","productId":"PM00000048","planTypeCode":"POS","timelyFilingLimitDuration":"365","timelyFilingLimitType":"Days","customerFacingPlanName":"UHC Choice Plus Gold 1500-4","riderOnlyFlag":"false","planTier":[{"tierIdentifier":"1","tierDescription":"Core Benefits","tierTypeCode":"INN","tierTypeDescription":"In Network","gatedPlanIndicator":"false","primaryCoInsurance":"80","accumulatorAmounts":[{"accumLevel":"PLAN","individualDeductibleMaximum":"1500.00","familyDeductibleMaximum":"3000.00","individualOOPMaximum":"6900.00","familyOOPMaximum":"13800.00","individualDeductibleYTD":"0.00","familyDeductibleYTD":"0.00","individualOOPYTD":"0.00","familyOOPYTD":"0.00","familyAccumulationTypeDescriptionDeductible":"Embedded Accum","familyAccumulationTypeDescriptionOOP":"Embedded Accum","deductibleCarryOverIndicator":"false","shareBasePlanAccumulatorIndicatorOOP":"false","shareBasePlanAccumulatorIndicatorDeductible":"false"}],"pcpCopay":["35.00"],"specialistCopay":["70.00"],"urgentCareCopay":["75.00"],"inPatientCopay":["0.00"],"serviceAreaType":"In/Out of Srvc Area","planDelegation":[{"delegationIndicator":"false"}],"primaryOopComposition":{"costShareType":["Deductible","Copay","Coinsurance"]},"networkAccessTypeCode":"2","networkAccessTypeDescription":"Open Access - All Networks","network":[{"id":"network_id1","description":"Core Benefit Network"}]},{"tierIdentifier":"2","tierDescription":"OON Benefits","tierTypeCode":"OON","tierTypeDescription":"Out of Network","gatedPlanIndicator":"false","primaryCoInsurance":"50","accumulatorAmounts":[{"accumLevel":"PLAN","individualDeductibleMaximum":"2550.00","familyDeductibleMaximum":"5100.00","individualOOPMaximum":"15800.00","familyOOPMaximum":"31600.00","individualDeductibleYTD":"0.00","familyDeductibleYTD":"0.00","individualOOPYTD":"0.00","familyOOPYTD":"0.00","familyAccumulationTypeDescriptionDeductible":"Embedded Accum","familyAccumulationTypeDescriptionOOP":"Embedded Accum","deductibleCarryOverIndicator":"false","shareBasePlanAccumulatorIndicatorOOP":"false","shareBasePlanAccumulatorIndicatorDeductible":"false"}],"virtualVisitsCopay":["0.00"],"urgentCareCopay":["0.00"],"inPatientCopay":["0.00"],"serviceAreaType":"In/Out of Srvc Area","planDelegation":[{"delegationIndicator":"false"}],"primaryOopComposition":{"costShareType":["Deductible","Copay","Coinsurance"]}}],"benefitCode":[{"benefitName":"Vision Services","benefitCode":"VISION_SERVICES","benefitDisplay":"Vision Services","benefitTier":["1","2"],"benefitType":"M","primaryOOPOnlyFlag":"false","primaryDeductibleOnlyFlag":"false","visitLimitsApplies":"false","copayApplies":"false","variableCoverage":"true","existsOnRiderPlan":"false","hipaaServiceTypes":[{"serviceTypeCode":"AL","serviceTypeDescription":"Vision (Optometry)"}]},{"benefitName":"Infertility Services - Artificial Insemination","benefitCode":"INFERTILITY_SERVICES_AI","benefitDisplay":"Infertility Services - Artificial Insemination","benefitTier":["2","1"],"benefitType":"M","primaryOOPOnlyFlag":"false","primaryDeductibleOnlyFlag":"false","visitLimitsApplies":"false","copayApplies":"false","variableCoverage":"true","existsOnRiderPlan":"false","hipaaServiceTypes":[{"categoryCode":"01","categoryCodeDescription":"Medical Care","serviceTypeCode":"83","serviceTypeDescription":"Infertility"}]}],"eHBIndicator":"true","externalIds":[{"entityId":"EMBDENT","externalPlanId":"CD4Y"}],"qualityProviderTierRuleID":"","placeOfServiceDifferentialIndicator":"false","fundingArrangementCode":"01","fundingArrangementDescription":"Fully Insured","revenueArrangementCode":"01","revenueArrangementDescription":"FI","carrierBusinessId":"36"},{"membership":[{"subscriberIdentifier":{"type":"SRK","id":"740970865"},"enrolleeIdentifier":{"type":"SRK","id":"740970884"},"coverageStartDate":"2021-01-01","coverageEndDate":"9999-12-31","timePeriodQualifier":"Calendar","contractOptionStartDate":"2021-01-01","contractOptionEndDate":"2021-12-31"}],"benefitPlanId":"RX03000033","coverageType":"PHARMACY","carrierId":"36","legalEntityName":"UnitedHealthcare Insurance Company","networkScheduleIds":[{"networkScheduleId":"CHOICEPLUS_1"}],"gatedProductIndicator":"false","pcpRequiredIndicator":"false","productName":"Pharmacy","productId":"PR00000001","planTypeCode":"Indemnity","timelyFilingLimitDuration":"365","timelyFilingLimitType":"Days","customerFacingPlanName":"UHC_SD_$10/$50/$100/$250_0D","administeredByName":"GX","riderOnlyFlag":"true","planRiderType":"Non-Dup of Base Bene","planTier":[{"tierIdentifier":"1","tierDescription":"UHC Rx","tierTypeCode":"INN","tierTypeDescription":"In Network","gatedPlanIndicator":"false","accumulatorAmounts":[{"accumLevel":"PLAN","deductibleCarryOverIndicator":"false","shareBasePlanAccumulatorIndicatorOOP":"true","shareBasePlanAccumulatorIndicatorDeductible":"false"}],"serviceAreaType":"In/Out of Srvc Area","planDelegation":[{"delegationIndicator":"false"}],"networkAccessTypeCode":"2","networkAccessTypeDescription":"Open Access - All Networks"}],"benefitCode":[{"benefitName":"Prescription Drug Tier 4","benefitCode":"RX_TIER_4","benefitDisplay":"Prescription Drug Tier 4","benefitTier":["1"],"benefitType":"RX","primaryOOPOnlyFlag":"true","primaryDeductibleOnlyFlag":"false","visitLimitsApplies":"false","copayApplies":"true","variableCoverage":"false","existsOnRiderPlan":"true","hipaaServiceTypes":[{"serviceTypeCode":"RXT4","serviceTypeDescription":"RX Rider Plan Tier 4"},{"serviceTypeCode":"88","serviceTypeDescription":"Pharmacy"}]},{"benefitName":"Prescription Drug Tier 3","benefitCode":"RX_TIER_3","benefitDisplay":"Prescription Drug Tier 3","benefitTier":["1"],"benefitType":"RX","primaryOOPOnlyFlag":"true","primaryDeductibleOnlyFlag":"false","visitLimitsApplies":"false","copayApplies":"true","variableCoverage":"false","existsOnRiderPlan":"true","hipaaServiceTypes":[{"serviceTypeCode":"88","serviceTypeDescription":"Pharmacy"},{"serviceTypeCode":"RXT3","serviceTypeDescription":"RX Rider Plan Tier 3"}]},{"benefitName":"Prescription Drug Tier 2","benefitCode":"RX_TIER_2","benefitDisplay":"Prescription Drug Tier 2","benefitTier":["1"],"benefitType":"RX","primaryOOPOnlyFlag":"true","primaryDeductibleOnlyFlag":"false","visitLimitsApplies":"false","copayApplies":"true","variableCoverage":"false","existsOnRiderPlan":"true","hipaaServiceTypes":[{"serviceTypeCode":"88","serviceTypeDescription":"Pharmacy"},{"serviceTypeCode":"RXT2","serviceTypeDescription":"RX Rider Plan Tier 2"}]},{"benefitName":"Prescription Drug Tier 1","benefitCode":"RX_TIER_1","benefitDisplay":"Prescription Drug Tier 1","benefitTier":["1"],"benefitType":"RX","primaryOOPOnlyFlag":"true","primaryDeductibleOnlyFlag":"false","visitLimitsApplies":"false","copayApplies":"true","variableCoverage":"false","existsOnRiderPlan":"true","hipaaServiceTypes":[{"serviceTypeCode":"88","serviceTypeDescription":"Pharmacy"},{"serviceTypeCode":"RXT1","serviceTypeDescription":"RX Rider Plan Tier 1"}]}],"eHBIndicator":"true","externalIds":[{"entityId":"MEDRXDEDTYPE","externalPlanId":"SEPARATE"},{"entityId":"UHCBENEFITID","externalPlanId":"642"},{"entityId":"PDL","externalPlanId":"ADVANTAGE"}],"placeOfServiceDifferentialIndicator":"false","fundingArrangementCode":"01","fundingArrangementDescription":"Fully Insured","revenueArrangementCode":"01","revenueArrangementDescription":"FI","carrierBusinessId":"36"}]}}}}';
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
    public static final String customerPurchaseId = '356203-1249148-32587615-PO100001';
    
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
    static void testNimbusGetSSBRespnse(){
        ACETNimbusGetSSBResponse response = new ACETNimbusGetSSBResponse();
        response.getSubscriptionServiceBenefitResponse = null;
        System.debug(JSON.serialize(response));
        
        ACETNimbusGetSSBResponse.GetSubscriptionServiceBenefitResponse getSubscriptionServiceBenefitResponse = new ACETNimbusGetSSBResponse.GetSubscriptionServiceBenefitResponse();
		getSubscriptionServiceBenefitResponse.serviceBenefit = null;
        System.debug(JSON.serialize(getSubscriptionServiceBenefitResponse));
        
        ACETNimbusGetSSBResponse.ServiceBenefit serviceBenefit = new ACETNimbusGetSSBResponse.ServiceBenefit();
		serviceBenefit.memberGroup = null;
		serviceBenefit.memberGroupContractPlanOption = null;
        System.debug(JSON.serialize(serviceBenefit));
        
        ACETNimbusGetSSBResponse.MemberGroup memberGroup = new ACETNimbusGetSSBResponse.MemberGroup();
		memberGroup.groupNumber = '';
		memberGroup.groupName = '';
        System.debug(JSON.serialize(memberGroup));
        
        ACETNimbusGetSSBResponse.MemberGroupContractPlanOption memberGroupContractPlanOption = new ACETNimbusGetSSBResponse.MemberGroupContractPlanOption();
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
        
        ACETNimbusGetSSBResponse.BenefitPlan benefitPlan = new ACETNimbusGetSSBResponse.BenefitPlan();
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
        
        ACETNimbusGetSSBResponse.Membership membership = new ACETNimbusGetSSBResponse.Membership();
		membership.subscriberIdentifier = null;
		membership.enrolleeIdentifier = null;
		membership.coverageStartDate = '';
		membership.coverageEndDate = '';
		membership.timePeriodQualifier = '';
		membership.contractOptionStartDate = '';
		membership.contractOptionEndDate = '';
        System.debug(JSON.serialize(membership));
        
        ACETNimbusGetSSBResponse.NetworkScheduleIds networkScheduleIds = new ACETNimbusGetSSBResponse.NetworkScheduleIds();
		networkScheduleIds.networkScheduleId = '';
        System.debug(JSON.serialize(networkScheduleIds));
        
        ACETNimbusGetSSBResponse.PlanTier planTier =  new  ACETNimbusGetSSBResponse.PlanTier();
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
        
        ACETNimbusGetSSBResponse.BenefitCode benefitCode = new ACETNimbusGetSSBResponse.BenefitCode();
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
        
        ACETNimbusGetSSBResponse.ExternalIds externalIds = new ACETNimbusGetSSBResponse.ExternalIds();
		externalIds.entityId = '';
		externalIds.externalPlanId = '';
        System.debug(JSON.serialize(externalIds));
        
        ACETNimbusGetSSBResponse.AttribSchedule attribSchedule = new ACETNimbusGetSSBResponse.AttribSchedule();
		attribSchedule.attribScheduleID = '';
		attribSchedule.attribScheduleDesc = '';
		attribSchedule.attribScheduleType = '';
		attribSchedule.attribScheduleTypeDisplay = '';
		attribSchedule.attribScheduleEffectiveDate = '';
		attribSchedule.attribScheduleExpirationDate = '';
		attribSchedule.nameValue = null;
        System.debug(JSON.serialize(attribSchedule));
        
        ACETNimbusGetSSBResponse.Identifier identifier = new ACETNimbusGetSSBResponse.Identifier();
		identifier.type = '';
		identifier.id = '';
        System.debug(JSON.serialize(identifier));
        
        ACETNimbusGetSSBResponse.AccumulatorAmount accumulatorAmount = new ACETNimbusGetSSBResponse.AccumulatorAmount();
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
        
        ACETNimbusGetSSBResponse.Network network = new ACETNimbusGetSSBResponse.Network();
        network.id = '';
        network.description = '';
        System.debug(JSON.serialize(network));
        
        ACETNimbusGetSSBResponse.PlanDelegation planDelegation = new ACETNimbusGetSSBResponse.PlanDelegation();
        planDelegation.delegationIndicator = '';
        planDelegation.delegationIdentifier = '';
        planDelegation.delegationName = '';
        System.debug(JSON.serialize(planDelegation));
        
        ACETNimbusGetSSBResponse.PrimaryOopComposition primaryOopComposition = new ACETNimbusGetSSBResponse.PrimaryOopComposition();
    	primaryOopComposition.costShareType = null;
        System.debug(JSON.serialize(primaryOopComposition));
        
        ACETNimbusGetSSBResponse.TierLevelServiceProvider tierLevelServiceProvider = new ACETNimbusGetSSBResponse.TierLevelServiceProvider();
        tierLevelServiceProvider.providerAssignmentTypeCode = '';
        tierLevelServiceProvider.providerAssignmentTypeDescription = '';
        tierLevelServiceProvider.providerSelectionOptionalIndicator = '';
        tierLevelServiceProvider.referralConditionTypeCode = '';
        tierLevelServiceProvider.referralConditionTypeDescription = '';
        tierLevelServiceProvider.providerAssignmentLevel = '';
        tierLevelServiceProvider.providerAssignmentLevelDesc = '';
        System.debug(JSON.serialize(tierLevelServiceProvider));
        
        ACETNimbusGetSSBResponse.HipaaServiceTypes hipaaServiceTypes = new ACETNimbusGetSSBResponse.HipaaServiceTypes();
        hipaaServiceTypes.categoryCode = '';
        hipaaServiceTypes.categoryCodeDescription = '';
        hipaaServiceTypes.serviceTypeCode = '';
        hipaaServiceTypes.serviceTypeDescription = '';
        System.debug(JSON.serialize(hipaaServiceTypes));
        
        ACETNimbusGetSSBResponse.NameValue nameValue= new ACETNimbusGetSSBResponse.NameValue();
        nameValue.name = '';
        nameValue.value = '';
        nameValue.effectiveDate = '';
        nameValue.expirationDate = '';
        System.debug(JSON.serialize(NameValue)); 
    }
    @isTest
    static void testNimbusGetSSB(){
        Test.startTest();
        ACETNimbusGetSSBAPI ssbAPI = new ACETNimbusGetSSBAPI();
        ssbAPI.getRequestBody(bundleOptionId, groupNum, accumAsOf);
        ssbAPI.StartRequest(bundleOptionId, 'true','CallbackMethodName', null);
        Test.stopTest();
    }
    @isTest
    static void testCallGetSubscriptionBenefitWS(){
        test.startTest();
        PageReference myVfPage = Page.ACETPlanBenefitSearchRedesign;
    	Test.setCurrentPageReference(myVfPage); // use setCurrentPageReference, 
        ApexPages.currentPage().getParameters().put('bundleOptionIdparam',bundleOptionId);
        ApexPages.currentPage().getParameters().put('benefitEffectivedateparam',effectiveDate);
        ApexPages.currentPage().getParameters().put('benefitEnddateparam',endDateSSB);
        ApexPages.currentPage().getParameters().put('groupNumberparam',groupNum);
        ApexPages.currentPage().getParameters().put('customerPurchaseidparam',customerPurchaseId);    
        ACETPlanBenefitSearchRedesignController planBenController = new ACETPlanBenefitSearchRedesignController();
        planBenController.MemberId = memId;
        planBenController.SRKID = surrogateKey;
        planBenController.SubSRKID = subscriberSRKID;
        planBenController.CoverageType = coverageTypes;
        
        planBenController.CallGetSubscriptionBenefitWS();
        
        MockHttpCalloutResponseGenerator.MockHttpResponse mockResponse = new MockHttpCalloutResponseGenerator.MockHttpResponse(statusCode200, status200, nimbusGetSSBResponse);        
        mockResponse.TokenExpired = false;        
        MockHttpCalloutResponseGenerator mockHttpRes = new MockHttpCalloutResponseGenerator(null, mockResponse);
        Test.setMock(HttpCalloutMock.class, mockHttpRes);
		planBenController.CallGetSubscriptionBenefitWS();
        
        
        MockHttpCalloutResponseGenerator.MockHttpResponse mockResponse1 = new MockHttpCalloutResponseGenerator.MockHttpResponse(statusCode400, status400, nimbusGetSSBBadResponse);        
        mockResponse1.TokenExpired = false;        
        MockHttpCalloutResponseGenerator mockHttpRes1 = new MockHttpCalloutResponseGenerator(null, mockResponse1);
        Test.setMock(HttpCalloutMock.class, mockHttpRes1);
		planBenController.CallGetSubscriptionBenefitWS();
        
        MockHttpCalloutResponseGenerator.MockHttpResponse mockResponse2 = new MockHttpCalloutResponseGenerator.MockHttpResponse(statusCode500, status500, nimbusGetSSBBadResponse);        
        mockResponse2.TokenExpired = false;        
        MockHttpCalloutResponseGenerator mockHttpRes2 = new MockHttpCalloutResponseGenerator(null, mockResponse2);
        Test.setMock(HttpCalloutMock.class, mockHttpRes2);
		planBenController.CallGetSubscriptionBenefitWS();
        
        MockHttpCalloutResponseGenerator.MockHttpResponse mockResponse3 = new MockHttpCalloutResponseGenerator.MockHttpResponse(statusCode404, status404, nimbusGetSSBBadResponse);        
        mockResponse3.TokenExpired = false;        
        MockHttpCalloutResponseGenerator mockHttpRes3 = new MockHttpCalloutResponseGenerator(null, mockResponse3);
        Test.setMock(HttpCalloutMock.class, mockHttpRes3);
		planBenController.CallGetSubscriptionBenefitWS();
        
        MockHttpCalloutResponseGenerator.MockHttpResponse mockResponse4 = new MockHttpCalloutResponseGenerator.MockHttpResponse(statusCode504, status504, nimbusGetSSBBadResponse);
        mockResponse4.TokenExpired = false;        
        MockHttpCalloutResponseGenerator mockHttpRes4 = new MockHttpCalloutResponseGenerator(null, mockResponse4);
        Test.setMock(HttpCalloutMock.class, mockHttpRes4);
		planBenController.CallGetSubscriptionBenefitWS();
        
        MockHttpCalloutResponseGenerator.MockHttpResponse mockResponse5 = new MockHttpCalloutResponseGenerator.MockHttpResponse(statusCode999, status999, nimbusGetSSBBadResponse);
        mockResponse4.TokenExpired = false;        
        MockHttpCalloutResponseGenerator mockHttpRes5 = new MockHttpCalloutResponseGenerator(null, mockResponse5);
        Test.setMock(HttpCalloutMock.class, mockHttpRes5);
		planBenController.CallGetSubscriptionBenefitWS();
        
        test.stopTest();
        
    }
    @isTest
    static void testSortTable(){
        test.startTest();
        ACETPlanBenefitSearchRedesignController planBenController = new ACETPlanBenefitSearchRedesignController();
        planBenController.SortBy = 'Asc';
        planBenController.LastSortBy = 'Desc';
        planBenController.sortTable();
        planBenController.LastSortBy = 'Asc';
        planBenController.sortTable();
        test.stopTest();
    }
         static testMethod void ACETBenefitCoverageOverviewControllerTest() {
             
              
             
              ACETGroupPlanBenefitWrapper.AccumulatorP InnAcc1 = new ACETGroupPlanBenefitWrapper.AccumulatorP();
        list<ACETGroupPlanBenefitWrapper.AccumulatorP> inList = new list<ACETGroupPlanBenefitWrapper.AccumulatorP>();
        InnAcc1.Section='Family';
        InnAcc1.TypeCode ='INN';           //INN or OON
        InnAcc1.MaxDeductible ='20';
        InnAcc1.YTDDeductible ='30';
        InnAcc1.RemDeductible ='50';
        InnAcc1.coinsurance=10;
        InnAcc1.MaxOOP ='100';
        InnAcc1.YTDOOP ='25';
        InnAcc1.RemOOP ='30';
        InnAcc1.primaryAccumDeduct ='44';
        InnAcc1.primaryAccumDescOOP ='22';
        inList.add(InnAcc1);
             
             
             ACETGroupPlanBenefitWrapper grpwrap = new  ACETGroupPlanBenefitWrapper();
        map<string,string> mapdata = new map<string,string>();
        mapdata.put('12','UCR');
        grpwrap.accumulatorList = inList;
        grpwrap.hippakeyStr = 'test';
        grpwrap.coPayingMap = mapdata;
        grpwrap.OONReimbursementMap = mapdata;
       ACETGroupPlanBenefitWrapper ACETPlanBenefitSearchResults = new ACETGroupPlanBenefitWrapper();
        Map<String, String> coPayingMap1 = new Map<String, String>();
        coPayingMap1.put('test','test');
        ACETPlanBenefitSearchResults.coPayingMap=coPayingMap1;
             
             
          
       
             
             
             
        ACETBenefitCoverageOverviewController bcoctrl = new ACETBenefitCoverageOverviewController();
             List<ACETGroupPlanBenefitWrapper.coPayWrapper> coWrapplst= new List<ACETGroupPlanBenefitWrapper.coPayWrapper>();
        ACETGroupPlanBenefitWrapper.coPayWrapper coWrapp= new ACETGroupPlanBenefitWrapper.coPayWrapper();
        coWrapp.label='test';
        coWrapp.value ='50';
        coWrapplst.add(coWrapp);
        bcoctrl.EffectiveDate='04/04/2017';
        bcoctrl.EndDate='04/12/2017'; 
        bcoctrl.covrgLevel='covrgLevel';
        bcoctrl.CoverageEndDate=system.today();
        bcoctrl.PlanType='PlanType';
        bcoctrl.accumsDateSearch='04/04/2017';
        bcoctrl.getCoPayList();
        bcoctrl.populateDate();
        bcoctrl.accumasOfDate();
        ACETAccumAsOfWrapper accumWrap = new  ACETAccumAsOfWrapper();
        accumWrap.accumAsofDate = '2018/01/01';
         bcoctrl.dateSearch = accumWrap;
               bcoctrl.ACETPlanBenefitSearchResults = grpwrap;
        List<ACETGroupPlanBenefitWrapper.OONReimbursement> oonlist = bcoctrl.OONReimbursementList;
          List<ACETGroupPlanBenefitWrapper.AccumulatorP> accmp =   bcoctrl.IndividualAccs;
        List<ACETGroupPlanBenefitWrapper.AccumulatorP> accmpfam =   bcoctrl.FamilyAccs;
        bcoctrl.getGroupFamilyAccs();
        bcoctrl.getGroupIndividualAccs();             
         }
    //RiderFlag != 1, Success response for FindMedicalProviders, number of records found is greater than zero
    static testMethod void ACETPlanBenefitSearchControllerTest1() {
        Map<String, String> TestISLWSConfigs = new Map<String, String>(); 
        TestISLWSConfigs.put('ISLConAccessToken', 'dfb379c2-06b7-46c4-8c6f-bbc390d1b854');
        TestISLWSConfigs.put('ISLOAuthContentType', 'application/x-www-form-urlencoded');
        TestISLWSConfigs.put('OILHttpHeaderAccept', 'application/json;charset=UTF-8');
        TestISLWSConfigs.put('OILHttpHeaderActor', 'ACET');
        TestISLWSConfigs.put('OILHttpHeaderScope', 'read');
        TestISLWSConfigs.put('OILTimeout', '3000');
        TestISLWSConfigs.put('dev_ISLOAuthEndpoint', 'https://api-stg.optum.com:8443');
        TestISLWSConfigs.put('dev_getSubscriptionBenefitSearch', '/api/alpha/eisl/benefits/servicebenefit/v2.0/read');
        //TestISLWSConfigs.put('dev_getSubscriptionBenefitSearch', '/api/bravo/eisl/benefits/servicebenefit/v2.0/read');
        
        List<ISL_Webservice_Config__c> lstISLWSConfigs = ACETTestDataUtility.CreateISLWebserviceConfigurations(TestISLWSConfigs);
        insert lstISLWSConfigs;
        
        /**  Account oAccount = ACETTestDataUtility.CreateAccount('Test Account', 'TstTaxID1', 'TestEID1');
insert oAccount;
Contact oContact = ACETTestDataUtility.CreateContact(oAccount.Id, 'Test Contact LN1', 'Test Contact FN1', 'TstTaxID1', 'TestEID1', 'TestNPI1');
insert oContact;
Interaction__c oInteraction = ACETTestDataUtility.CreateInteraction(oContact.Id, 'Phone', 'Member', oContact.LastName);
insert oInteraction;
***/ 
        RecordType newRecord = [SELECT Id FROM RecordType WHERE Name = 'Person Account' and SObjectType = 'Account'];
        
        Account accountTest = new Account();
        accountTest.FirstName = 'Test Contact FN';
        accountTest.LastName = 'Test Contact LN';
        accountTest.EID__c = 'TestEID1';
        accountTest.EID__pc = 'TestEID1';
        accountTest.RecordTypeId = newRecord.Id;
        insert accountTest;

    Account acc = [SELECT Id,personcontactid from Account where Id=:accountTest.Id];
        Contact oContact = [SELECT Id,LastName,FirstName,EID__c,AccountId from Contact where Id=:acc.personcontactid];
        oContact.Tax_ID__c = 'TstTaxID1';
        oContact.NPI__c = 'TestNPI1';
        String JSONStr = '{"UHCBS":"","GroupN":"Test Group Name","GroupStatus":"Active","ServiceTeam":"NY Large","EffectiveStartDate":"3/1/2016","RiskManagement":"Rating Method","RatingMethod":"","RenewalDate":"3/1/2016","RelationshipType":"Mother","groupSName":"Test GroupName"}';
        Interaction__c InteractionId = new Interaction__c();
        InteractionId.Contact_Name__c = 'Text Iname';
        InteractionId.Originator__c = oContact.id;
        InteractionId.Originator_Type__c = 'Member';
        InteractionId.Highlight_Panel_GroupInfo__c = JSONStr;
        insert InteractionId;
        /*   StaticResource ResponseJSONSR = [SELECT Body FROM StaticResource WHERE Name = 'ACETGetSubscrBenefitResponseJSON0'];
String ResponseJSON = ResponseJSONSR.Body.toString();
system.debug(LoggingLevel.INFO, 'Response JSON: ' + ResponseJSON); */
        
       MockHttpCalloutResponseGenerator.MockHttpResponse OILResponse = new MockHttpCalloutResponseGenerator.MockHttpResponse(200, 'OK', ACETTestDataUtility.getSubscriptionBenefitResponse());
        OILResponse.TokenExpired = false;
    
        MockHttpCalloutResponseGenerator MockHttpRes = new MockHttpCalloutResponseGenerator(null, OILResponse);
        Test.setMock(HttpCalloutMock.class, MockHttpRes);
            
        String jsonResponse = ACETTestDataUtility.getSubscriptionBenefitResponse();
        ACETNimbusGetSSBResponse json2ApexTest = (ACETNimbusGetSSBResponse)JSON.deserialize(jsonResponse, ACETNimbusGetSSBResponse.class);
        ACETNimbusGetSSBAPI webserviceCall1 = new ACETNimbusGetSSBAPI();
        System.debug(webserviceCall1);
        System.debug(json2ApexTest);
        
        //webserviceCall1.getSubscriptionBenefitSearch('7100123','55870592000',null,'10/10/2017','12/12/9999','pcp','1388476','','');
        //webserviceCall1.getTierCode();
        //webserviceCall1.getValidString('test');
        //webserviceCall1.getCoverageTypeDescripMap();
        //webserviceCall1.getDurationCodeMap();
        //webserviceCall1.ChangeDateFormatForOIL('10/02/2017');
        //webserviceCall1.getPlanTypeCode();
        //webserviceCall1.getGatedPCPCode();
        //webserviceCall1.ProcessResponse('Test');
        //webserviceCall1.StartRequest();
        
          MockHttpCalloutResponseGenerator.MockHttpResponse OILTestResponse1 =  new MockHttpCalloutResponseGenerator.MockHttpResponse(200, 'OK', ACETTestDataUtility.getFindEmployerGroupNameJson());
        OILResponse.TokenExpired = false;        
        MockHttpCalloutResponseGenerator MockHttpResponse = new MockHttpCalloutResponseGenerator(null, OILTestResponse1);
        
        Test.setMock(HttpCalloutMock.class, MockHttpResponse);  
        
        /**MockHttpCalloutResponseGenerator.MockHttpResponse OILTestRespons1 = new MockHttpCalloutResponseGenerator.MockHttpResponse(200, 'OK',ACETTestDataUtility.getEmployerGroupDetailJson());
        OILTestResponse1.TokenExpired = false;
        
        MockHttpCalloutResponseGenerator MockHttpResponse1 = new MockHttpCalloutResponseGenerator(null, OILTestRespons1);
        Test.setMock(HttpCalloutMock.class, MockHttpResponse1);*/
        
        
        Test.startTest();
       
        PageReference ACETPBS = Page.ACETPlanBenefitSearchRedesign;
        ACETPBS.getParameters().put('interactionId', InteractionId.Id);
        ACETPBS.getParameters().put('contactId', oContact.Id);
        ACETPBS.getParameters().put('sourceOriginator', 'Phone Call');
        ACETPBS.getParameters().put('additionalInfo', '{"Relationship":"Self","Product":"Gated INN only","OriginatorRelationship":"Self","MemberId":"36781823800","LastName":"Baker","isMember":" true","GroupNumber":"1118476","Gender":"M","FirstName":"Wayne","EndDate":"12/31/9999","EffectiveDate":"1/1/2015","DOB":"11/7/1966","BenefitPlanId":"M000000010"}');
        ACETPBS.getParameters().put('memberId', '36781823800');
        ACETPBS.getParameters().put('SRK', '');
        ACETPBS.getParameters().put('DOB', '11/7/1966');
        ACETPBS.getParameters().put('SitusState', '');
        ACETPBS.getParameters().put('vccdParams', '');
        ACETPBS.getParameters().put('bundleOptionId', '0');
        ACETPBS.getParameters().put('CoverageType', 'MEDICAL');
        ACETPBS.getParameters().put('EffectiveDate', '1/1/2015');
        ACETPBS.getParameters().put('EndDate', '12/31/9999');
        ACETPBS.getParameters().put('SRK', '1234568');
        Test.setCurrentPageReference(ACETPBS);
        
        ACETCallTopicsDataWrapper datawrpr = new ACETCallTopicsDataWrapper();
        ACETPlanBenefitSearchRedesignController ACETPBSCtrl = new ACETPlanBenefitSearchRedesignController();
        ACETPBSCtrl.MemberId='100001';
        ACETPBSCtrl.FirstName='TestName';
        ACETPBSCtrl.LastName='TestlName';
        ACETPBSCtrl.ZipCode='500073';
        ACETPBSCtrl.SourceOriginator='Sample3';
        ACETPBSCtrl.groupNumber='45678';
        ACETPBSCtrl.LastSortBy='Test';
        ACETPBSCtrl.SortBy='Asc';
        ACETPBSCtrl.CallGetSubscriptionBenefitWS();
        ACETPBSCtrl.PolicyNumber = '';
        ACETPBSCtrl.groupName = '';
        ACETPBSCtrl.GroupInfos = null;
        ACETPBSCtrl.ReplaceKeywords('desc');
        ACETPBSCtrl.hpAdditionInfoStr = 'Test';
        ACETPBSCtrl.CallGetSubscriptionBenefitWS();
        ACETPBSCtrl.selectedActiveAndAll = 'activate';
        ACETPlanBenefitSearchRedesignController.PlanInfo ACETPBSPI=new ACETPlanBenefitSearchRedesignController.PlanInfo();
        ACETPBSPI.PolicyNumber  ='12121';
        ACETPBSPI.PlanId ='783232';
        ACETPBSPI.Product ='test';
        ACETPBSPI.EffectiveDate ='1/1/2015';
        ACETPBSPI.EndDate ='2/1/2015';
        ACETPBSPI.ExpirationDate='1/31/2015';
        ACETPBSPI.RevisionDate ='1/10/2015';
        ACETPBSPI.GroupName ='test2';
        
        ACETPlanBenefitSearchRedesignController.GroupInfo ACETPBSGI=new ACETPlanBenefitSearchRedesignController.GroupInfo();
        ACETPBSGI.groupName='sample' ;
        ACETPBSGI.address='Teststreet';
        ACETPBSGI.city ='TestCountry';
        ACETPBSGI.status ='pending';
        ACETPBSGI.state ='TestState';
        ACETPBSGI.zip='7777';
        ACETPBSGI.phoneNumber='12345678';
        Test.stopTest();
    }
    
    //RiderFlag = 1, Success response for FindMedicalProviders, number of records found is greater than zero
    static testMethod void ACETPlanBenefitSearchControllerTest2() {
        Map<String, String> TestISLWSConfigs = new Map<String, String>(); 
        TestISLWSConfigs.put('ISLConAccessToken', 'dfb379c2-06b7-46c4-8c6f-bbc390d1b854');
        TestISLWSConfigs.put('ISLOAuthContentType', 'application/x-www-form-urlencoded');
        TestISLWSConfigs.put('OILHttpHeaderAccept', 'application/json;charset=UTF-8');
        TestISLWSConfigs.put('OILHttpHeaderActor', 'ACET');
        TestISLWSConfigs.put('OILHttpHeaderScope', 'read');
        TestISLWSConfigs.put('OILTimeout', '3000');
        TestISLWSConfigs.put('dev_ISLOAuthEndpoint', 'https://api-stg.optum.com:8443');
        TestISLWSConfigs.put('dev_getSubscriptionBenefitSearch', '/api/alpha/eisl/benefits/servicebenefit/v2.0/read');
        List<ISL_Webservice_Config__c> lstISLWSConfigs = ACETTestDataUtility.CreateISLWebserviceConfigurations(TestISLWSConfigs);
        insert lstISLWSConfigs;
        
        RecordType newRecord = [SELECT Id FROM RecordType WHERE Name = 'Person Account' and SObjectType = 'Account'];
        
        Account accountTest = new Account();
        accountTest.FirstName = 'Test Contact FN';
        accountTest.LastName = 'Test Contact LN';
        accountTest.EID__c = 'TestEID1';
        accountTest.EID__pc = 'TestEID1';
        accountTest.RecordTypeId = newRecord.Id;
        insert accountTest;

    Account acc = [SELECT Id,personcontactid from Account where Id=:accountTest.Id];
        Contact oContact = [SELECT Id,LastName,FirstName,EID__c,AccountId from Contact where Id=:acc.personcontactid];
        oContact.Tax_ID__c = 'TstTaxID1';
        oContact.NPI__c = 'TestNPI1';
        Interaction__c oInteraction = ACETTestDataUtility.CreateInteraction(oContact.Id, 'Phone', 'Member', oContact.LastName);
        insert oInteraction;
        
        /*     StaticResource ResponseJSONSR = [SELECT Body FROM StaticResource WHERE Name = 'ACETGetSubscrBenefitResponseJSON1'];
String ResponseJSON = ResponseJSONSR.Body.toString();
system.debug(LoggingLevel.INFO, 'Response JSON: ' + ResponseJSON); */
        
        MockHttpCalloutResponseGenerator.MockHttpResponse OILTestResponse = new MockHttpCalloutResponseGenerator.MockHttpResponse(200, 'OK', ACETTestDataUtility.getBenefitLanguageJSON());
        OILTestResponse.TokenExpired = false;
        
        Test.startTest();
        
        MockHttpCalloutResponseGenerator MockHttpResponse = new MockHttpCalloutResponseGenerator(null, OILTestResponse);
        Test.setMock(HttpCalloutMock.class, MockHttpResponse);
        
        PageReference ACETPBS = Page.ACETPlanBenefitSearchRedesign;
        ACETPBS.getParameters().put('interactionId', oInteraction.Id);
        ACETPBS.getParameters().put('contactId', oContact.Id);
        ACETPBS.getParameters().put('sourceOriginator', 'Phone Call');
        ACETPBS.getParameters().put('additionalInfo', '{"Relationship":"Self","Product":"Gated INN only","OriginatorRelationship":"Self","MemberId":"36781823800","LastName":"Baker","isMember":" true","GroupNumber":"1118476","Gender":"M","FirstName":"Wayne","EndDate":"12/31/9999","EffectiveDate":"1/1/2015","DOB":"11/7/1966","BenefitPlanId":"M000000010"}');
        ACETPBS.getParameters().put('memberId', '36781823800');
        ACETPBS.getParameters().put('SRK', '');
        ACETPBS.getParameters().put('DOB', '11/7/1966');
        ACETPBS.getParameters().put('SitusState', '');
        ACETPBS.getParameters().put('vccdParams', '');
        ACETPBS.getParameters().put('bundleOptionId', '0');
        ACETPBS.getParameters().put('CoverageType', 'MEDICAL');
        ACETPBS.getParameters().put('EffectiveDate', '1/1/2015');
        ACETPBS.getParameters().put('EndDate', '12/31/9999');
        Test.setCurrentPageReference(ACETPBS);
        
       // ACETPlanBenefitSearchController ACETPBSCtrl = new ACETPlanBenefitSearchController();
       // ACETPBSCtrl.CallGetSubscriptionBenefitWS();
        
        
        Test.stopTest();
    }
    
    //Error response
    static testMethod void ACETPlanBenefitSearchControllerTest3() {
        Map<String, String> TestISLWSConfigs = new Map<String, String>(); 
        TestISLWSConfigs.put('ISLConAccessToken', 'dfb379c2-06b7-46c4-8c6f-bbc390d1b854');
        TestISLWSConfigs.put('ISLOAuthContentType', 'application/x-www-form-urlencoded');
        TestISLWSConfigs.put('OILHttpHeaderAccept', 'application/json;charset=UTF-8');
        TestISLWSConfigs.put('OILHttpHeaderActor', 'ACET');
        TestISLWSConfigs.put('OILHttpHeaderScope', 'read');
        TestISLWSConfigs.put('OILTimeout', '3000');
        TestISLWSConfigs.put('dev_ISLOAuthEndpoint', 'https://api-stg.optum.com:8443');
        TestISLWSConfigs.put('dev_getSubscriptionBenefitSearch', '/api/alpha/eisl/benefits/servicebenefit/v2.0/read');
        List<ISL_Webservice_Config__c> lstISLWSConfigs = ACETTestDataUtility.CreateISLWebserviceConfigurations(TestISLWSConfigs);
        insert lstISLWSConfigs;
        
        RecordType newRecord = [SELECT Id FROM RecordType WHERE Name = 'Person Account' and SObjectType = 'Account'];
        
        Account accountTest = new Account();
        accountTest.FirstName = 'Test Contact FN';
        accountTest.LastName = 'Test Contact LN';
        accountTest.EID__c = 'TestEID1';
        accountTest.EID__pc = 'TestEID1';
        accountTest.RecordTypeId = newRecord.Id;
        insert accountTest;

    Account acc = [SELECT Id,personcontactid from Account where Id=:accountTest.Id];
        Contact oContact = [SELECT Id,LastName,FirstName,EID__c,AccountId from Contact where Id=:acc.personcontactid];
        oContact.Tax_ID__c = 'TstTaxID1';
        oContact.NPI__c = 'TestNPI1';
        Interaction__c oInteraction = ACETTestDataUtility.CreateInteraction(oContact.Id, 'Phone', 'Member', oContact.LastName);
        insert oInteraction;
        
        //StaticResource ResponseJSONSR = [SELECT Body FROM StaticResource WHERE Name = 'ACETFindMedicalProvidersResponseJSON'];
        String ResponseJSON = '{"getSubscriptionServiceBenefit":{"errors":[{"code":"W008","name":"No records returned","severity":"low",';
        ResponseJSON += '"origin":"Consumer","description":"Consumer has requested a query for which no records have been found."}]}}';
        system.debug(LoggingLevel.INFO, 'Response JSON: ' + ResponseJSON);
        
        MockHttpCalloutResponseGenerator.MockHttpResponse OILTestResponse = new MockHttpCalloutResponseGenerator.MockHttpResponse(500, 'Internal Server Error', ResponseJSON);
        OILTestResponse.TokenExpired = false;
        
        Test.startTest();
        
        MockHttpCalloutResponseGenerator MockHttpResponse = new MockHttpCalloutResponseGenerator(null, OILTestResponse);
        Test.setMock(HttpCalloutMock.class, MockHttpResponse);
        
        PageReference ACETPBS = Page.ACETPlanBenefitSearchRedesign;
        ACETPBS.getParameters().put('interactionId', oInteraction.Id);
        ACETPBS.getParameters().put('contactId', oContact.Id);
        ACETPBS.getParameters().put('sourceOriginator', 'Phone Call');
        ACETPBS.getParameters().put('additionalInfo', '{"Relationship":"Self","Product":"Gated INN only","OriginatorRelationship":"Self","MemberId":"36781823800","LastName":"Baker","isMember":" true","GroupNumber":"1118476","Gender":"M","FirstName":"Wayne","EndDate":"12/31/9999","EffectiveDate":"1/1/2015","DOB":"11/7/1966","BenefitPlanId":"M000000010"}');
        ACETPBS.getParameters().put('memberId', '36781823800');
        ACETPBS.getParameters().put('SRK', '');
        ACETPBS.getParameters().put('DOB', '11/7/1966');
        ACETPBS.getParameters().put('SitusState', '');
        ACETPBS.getParameters().put('vccdParams', '');
        ACETPBS.getParameters().put('bundleOptionId', '0');
        ACETPBS.getParameters().put('CoverageType', 'MEDICAL');
        ACETPBS.getParameters().put('EffectiveDate', '1/1/2015');
        ACETPBS.getParameters().put('EndDate', '12/31/9999');
        Test.setCurrentPageReference(ACETPBS);
        
      //  ACETPlanBenefitSearchController ACETPBSCtrl = new ACETPlanBenefitSearchController();
      //  ACETPBSCtrl.CallGetSubscriptionBenefitWS();
        
        
        Test.stopTest();
    }
    
    //Invalid json in response
    static testMethod void ACETPlanBenefitSearchControllerTest4() {
        Map<String, String> TestISLWSConfigs = new Map<String, String>(); 
        TestISLWSConfigs.put('ISLConAccessToken', 'dfb379c2-06b7-46c4-8c6f-bbc390d1b854');
        TestISLWSConfigs.put('ISLOAuthContentType', 'application/x-www-form-urlencoded');
        TestISLWSConfigs.put('OILHttpHeaderAccept', 'application/json;charset=UTF-8');
        TestISLWSConfigs.put('OILHttpHeaderActor', 'ACET');
        TestISLWSConfigs.put('OILHttpHeaderScope', 'read');
        TestISLWSConfigs.put('OILTimeout', '3000');
        TestISLWSConfigs.put('dev_ISLOAuthEndpoint', 'https://api-stg.optum.com:8443');
        TestISLWSConfigs.put('dev_getSubscriptionBenefitSearch', '/api/alpha/eisl/benefits/servicebenefit/v2.0/read');
        List<ISL_Webservice_Config__c> lstISLWSConfigs = ACETTestDataUtility.CreateISLWebserviceConfigurations(TestISLWSConfigs);
        insert lstISLWSConfigs;
        
        RecordType newRecord = [SELECT Id FROM RecordType WHERE Name = 'Person Account' and SObjectType = 'Account'];
        
        Account accountTest = new Account();
        accountTest.FirstName = 'Test Contact FN';
        accountTest.LastName = 'Test Contact LN';
        accountTest.EID__c = 'TestEID1';
        accountTest.EID__pc = 'TestEID1';
        accountTest.RecordTypeId = newRecord.Id;
        insert accountTest;

    Account acc = [SELECT Id,personcontactid from Account where Id=:accountTest.Id];
        Contact oContact = [SELECT Id,LastName,FirstName,EID__c,AccountId from Contact where Id=:acc.personcontactid];
        oContact.Tax_ID__c = 'TstTaxID1';
        oContact.NPI__c = 'TestNPI1';
        Interaction__c oInteraction = ACETTestDataUtility.CreateInteraction(oContact.Id, 'Phone', 'Member', oContact.LastName);
        insert oInteraction;
        
        
        String ResponseJSON = '{"getSubscriptionServiceBenefit":{"errors":[{"code":"W008","name":"No records returned","severity":"low",';
        ResponseJSON += '"origin":"Consumer","description":"Consumer has requested a query for which no ';
        system.debug(LoggingLevel.INFO, 'Response JSON: ' +'@@'+ ResponseJSON);
        
        MockHttpCalloutResponseGenerator.MockHttpResponse OILTestResponse = new MockHttpCalloutResponseGenerator.MockHttpResponse(200, 'OK', ACETTestDataUtility.getBenefitLanguageJSON());
        OILTestResponse.TokenExpired = false;
        
        Test.startTest();
        
        MockHttpCalloutResponseGenerator MockHttpResponse = new MockHttpCalloutResponseGenerator(null, OILTestResponse);
        Test.setMock(HttpCalloutMock.class, MockHttpResponse);
        
        ACETGetBenefitLanguageRedesignWebService BLRWS = new ACETGetBenefitLanguageRedesignWebService();
        BLRWS.GetEndpoint();
        BLRWS.getValidString('Test');
        BLRWS.ChangeDateFormatForOIL('07/07/2017');
        list<string> lstbenefitCodes = new list<string>();
        lstbenefitCodes.add('ABDOMINAL_AORTIC_SCREENING_OUTPATIENT');
        BLRWS.getPlanBenefitLanguage('35345345', '2014-01-01', '72015543500',lstbenefitCodes , null, null, '2014-01-01','12345');
        BLRWS.getPlanBenefitLanguageNew('M000000059','2014-01-01','72015543500',lstbenefitCodes,'2014-01-01','12345',null,true,'2014-01-01');
    
        
        PageReference ACETPBS = Page.ACETPlanBenefitSearchRedesign;
        ACETPBS.getParameters().put('interactionId', oInteraction.Id);
        ACETPBS.getParameters().put('contactId', oContact.Id);
        ACETPBS.getParameters().put('sourceOriginator', 'Phone Call');
        ACETPBS.getParameters().put('additionalInfo', '{"Relationship":"Self","Product":"Gated INN only","OriginatorRelationship":"Self","MemberId":"36781823800","LastName":"Baker","isMember":" true","GroupNumber":"1118476","Gender":"M","FirstName":"Wayne","EndDate":"12/31/9999","EffectiveDate":"1/1/2015","DOB":"11/7/1966","BenefitPlanId":"M000000010"}');
        ACETPBS.getParameters().put('memberId', '36781823800');
        ACETPBS.getParameters().put('SRK', '');
        ACETPBS.getParameters().put('DOB', '11/7/1966');
        ACETPBS.getParameters().put('SitusState', '');
        ACETPBS.getParameters().put('vccdParams', '');
        ACETPBS.getParameters().put('bundleOptionId', '0');
        ACETPBS.getParameters().put('CoverageType', 'MEDICAL');
        ACETPBS.getParameters().put('EffectiveDate', '1/1/2015');
        ACETPBS.getParameters().put('EndDate', '12/31/9999');
        Test.setCurrentPageReference(ACETPBS);
        
       /* ACETPlanBenefitSearchController ACETPBSCtrl = new ACETPlanBenefitSearchController();
        ACETPBSCtrl.CallGetSubscriptionBenefitWS();
        ACETPBSCtrl.Interaction = oInteraction;
        ACETPBSCtrl.subject=oContact;
        ACETPBSCtrl.LastSortBy='Test';
        ACETPBSCtrl.SortBy='Test';
        ACETPBSCtrl.State='CT';
        ACETPBSCtrl.groupName='1098477';
        ACETPBSCtrl.searchGroupName ='1098477';
        ACETPBSCtrl.sortTable();
        ACETPBSCtrl.IsShowActiveBenefitsOnly=true; */
        ACETGroupPlanBenefitWrapper AGPBW = NEW ACETGroupPlanBenefitWrapper();
        ACETGroupPlanBenefitWrapper.PlanInformationWrapper  AGPBW1 = NEW ACETGroupPlanBenefitWrapper.PlanInformationWrapper();
       // ACETPBSCtrl.planInfoWrapper = AGPBW;
        List<ACETGroupPlanBenefitWrapper.PlanInformationWrapper> AGPBWLST = new List<ACETGroupPlanBenefitWrapper.PlanInformationWrapper>();
        AGPBWLST.add(AGPBW1);
       // ACETPBSCtrl.planInfoList = AGPBWLST;
        //   public List<ACETGroupPlanBenefitWrapper.PlanInformationWrapper> planInfoList {get; set;}
        //   public ACETGroupPlanBenefitWrapper planInfoWrapper {get; set;} 
       // ACETPBSCtrl.searchPlans();
        Test.stopTest();
    } 
    
    //Invalid json in response
    static testMethod void ACETPlanBenefitSearchControllerTest5() {
        Map<String, String> TestISLWSConfigs = new Map<String, String>(); 
        TestISLWSConfigs.put('ISLConAccessToken', 'dfb379c2-06b7-46c4-8c6f-bbc390d1b854');
        TestISLWSConfigs.put('ISLOAuthContentType', 'application/x-www-form-urlencoded');
        TestISLWSConfigs.put('OILHttpHeaderAccept', 'application/json;charset=UTF-8');
        TestISLWSConfigs.put('OILHttpHeaderActor', 'ACET');
        TestISLWSConfigs.put('OILHttpHeaderScope', 'read');
        TestISLWSConfigs.put('OILTimeout', '3000');
        TestISLWSConfigs.put('dev_ISLOAuthEndpoint', 'https://api-stg.optum.com:8443');
        TestISLWSConfigs.put('dev_getSubscriptionBenefitSearch', '/api/alpha/eisl/benefits/servicebenefit/v2.0/read');
        List<ISL_Webservice_Config__c> lstISLWSConfigs = ACETTestDataUtility.CreateISLWebserviceConfigurations(TestISLWSConfigs);
        insert lstISLWSConfigs;
        
        RecordType newRecord = [SELECT Id FROM RecordType WHERE Name = 'Person Account' and SObjectType = 'Account'];
        
        Account accountTest = new Account();
        accountTest.FirstName = 'Test Contact FN';
        accountTest.LastName = 'Test Contact LN';
        accountTest.EID__c = 'TestEID1';
        accountTest.EID__pc = 'TestEID1';
        accountTest.RecordTypeId = newRecord.Id;
        insert accountTest;

    Account acc = [SELECT Id,personcontactid from Account where Id=:accountTest.Id];
        Contact oContact = [SELECT Id,LastName,FirstName,EID__c,AccountId from Contact where Id=:acc.personcontactid];
        oContact.Tax_ID__c = 'TstTaxID1';
        oContact.NPI__c = 'TestNPI1';
        Interaction__c oInteraction = ACETTestDataUtility.CreateInteraction(oContact.Id, 'Phone', 'Member', oContact.LastName);
        insert oInteraction;
        
        
        String ResponseJSON = '{"getBenefitLanguageResponse":{"errors":[{"code":"W008","name":"No records returned","severity":"low",';
        ResponseJSON += '"origin":"Consumer","description":"Consumer has requested a query for which no ';
        system.debug(LoggingLevel.INFO, 'Response JSON: ' +'@@'+ ResponseJSON);
        
        MockHttpCalloutResponseGenerator.MockHttpResponse OILTestResponse = new MockHttpCalloutResponseGenerator.MockHttpResponse(404, 'OK', ACETTestDataUtility.getBenefitLanguageJSON());
        OILTestResponse.TokenExpired = false;
        
        Test.startTest();
        
        MockHttpCalloutResponseGenerator MockHttpResponse = new MockHttpCalloutResponseGenerator(null, OILTestResponse);
        Test.setMock(HttpCalloutMock.class, MockHttpResponse);
        
        ACETGetBenefitLanguageRedesignWebService BLRWS = new ACETGetBenefitLanguageRedesignWebService();
        BLRWS.getValidString('');
        list<string> lstbenefitCodes = new list<string>();
        lstbenefitCodes.add('ABORTION_ELECTIVE_OFFICE');
       // BLRWS.getPlanBenefitLanguageNew('M000000059','2014-01-01','72015543500',lstbenefitCodes,null,'2014-01-01');
        
        
        Test.stopTest();
    } 
    
    
    
    /*static testMethod void ACETPlanBenefitDetailRedesignWebServiceMethod() {
        Map<String, String> mapISLWSConfigs = new Map<String, String>(); 
        mapISLWSConfigs.put('ISLConAccessToken', 'e9b3f2b1-8863-49ec-9ff8-40da25961ef5');
        mapISLWSConfigs.put('OILHttpHeaderAccept', 'application/json;charset=UTF-8');
        mapISLWSConfigs.put('OILHttpHeaderActor', 'ACET');
        mapISLWSConfigs.put('OILHttpHeaderScope', 'read');
        mapISLWSConfigs.put('ISLOAuthContentType', 'application/x-www-form-urlencoded');
        mapISLWSConfigs.put('ISLOAuthGrantType', 'client_credentials');
        mapISLWSConfigs.put('dev_ISLOAuthClientId', 'ISLStageConClientId');
        mapISLWSConfigs.put('dev_ISLOAuthClientSecret', 'ISLStageConClientSecret');
        mapISLWSConfigs.put('dev_ISLOAuthEndpoint', 'https://gateway-stage.optum.com');
        mapISLWSConfigs.put('dev_GetServiceBenefit', '/api/alpha/ben/cirrus/service-benefits/v6.0/read');
        mapISLWSConfigs.put('dev_ISLOAuthTokenEndpoint', '/auth/oauth/v2/token');
        mapISLWSConfigs.put('OILTimeout', '3000');
        
        List<ISL_Webservice_Config__c> lstISLWSConfigs = ACETTestDataUtility.CreateISLWebserviceConfigurations(mapISLWSConfigs);
        insert lstISLWSConfigs;
        
        
        String JSONStr = '{"UHCBS":"","GroupN":"Test Group Name","GroupStatus":"Active","ServiceTeam":"NY Large","EffectiveStartDate":"3/1/2016","RiskManagement":"Rating Method","RatingMethod":"","RenewalDate":"3/1/2016","RelationshipType":"Mother","groupSName":"Test GroupName"}';
        PageReference ACETGroupPlan = Page.ACETGroupPlanBenefitDetailRedesign;
        RecordType newRecord = [SELECT Id FROM RecordType WHERE Name = 'Person Account' and SObjectType = 'Account'];
        
        Account accountTest = new Account();
        accountTest.FirstName = 'Test Contact FN';
        accountTest.LastName = 'Test Contact LN';
        accountTest.EID__c = 'TestEID1';
        accountTest.EID__pc = 'TestEID1';
        accountTest.RecordTypeId = newRecord.Id;
        insert accountTest;

    Account acc = [SELECT Id,personcontactid from Account where Id=:accountTest.Id];
        Contact cont = [SELECT Id,LastName,FirstName,EID__c,AccountId from Contact where Id=:acc.personcontactid];
        cont.Tax_ID__c = 'TstTaxID1';
        cont.NPI__c = 'TestNPI1';
        Interaction__c InteractionId = new Interaction__c();
        InteractionId.Contact_Name__c = 'Text Iname';
        InteractionId.Originator__c = cont.id;
        InteractionId.Originator_Type__c = 'Member';
        InteractionId.Highlight_Panel_GroupInfo__c = JSONStr;
        insert InteractionId;
        ACETGroupPlan.getParameters().put('interactionId', InteractionId.Id);
        ACETGroupPlan.getParameters().put('groupId', 'dh191015');
        ACETGroupPlan.getParameters().put('policyNo', '1910005');
        ACETGroupPlan.getParameters().put('serviceTeam1', 'NJ');
        Test.setCurrentPage(ACETGroupPlan);
        
        Test.startTest();
        
        MockHttpCalloutResponseGenerator.MockHttpResponse OILResponse = new MockHttpCalloutResponseGenerator.MockHttpResponse(200, 'OK', ACETTestDataUtility.getSubscriptionBenefitResponse());
        OILResponse.TokenExpired = false;
        
        MockHttpCalloutResponseGenerator MockHttpRes = new MockHttpCalloutResponseGenerator(null, OILResponse);
        Test.setMock(HttpCalloutMock.class, MockHttpRes);
        
        String jsonResponse = ACETTestDataUtility.getSubscriptionBenefitResponse();
        ACETGetSubscriptionRedesignJSON2APEX Json2ApexTest = ACETGetSubscriptionRedesignJSON2APEX.parse(jsonResponse);
        ACETGetSubscriptionRedesignWebservice webserviceCall = new ACETGetSubscriptionRedesignWebservice();
        webserviceCall.getSubscriptionBenefitSearch('7100123',null,null,null,null,null,null,null,null,null);
        webserviceCall.getTierCode();
        webserviceCall.getValidString('test');
        webserviceCall.getCoverageTypeDescripMap();
        webserviceCall.getDurationCodeMap();
        webserviceCall.ChangeDateFormatForOIL('10/02/2017');
        webserviceCall.getPlanTypeCode();
        webserviceCall.getGatedPCPCode();
        webserviceCall.ProcessResponse('Test','CT');
        
        ACETPlanBenefitDetailRedesignControllerr  redesignctrl = new ACETPlanBenefitDetailRedesignControllerr();
        redesignctrl.dateSearchresults();
        redesignctrl.CallWSOnPageLoad_New();
        redesignctrl.CallWSOnPageLoadCallback();
        redesignctrl.makePlanBenefitLanguageCallout();
        redesignctrl.makePlanBenefitAccCallout();
        redesignctrl.ChangeDateFormatForOIL('10/02/2017');
        ACETPlanBenefitDetailRedesignControllerr.PolicyOverviewWrapper polovr = new ACETPlanBenefitDetailRedesignControllerr.PolicyOverviewWrapper();
       // polovr.isSelected = false;
       // polovr.Network = 'Freedom Network';
      //  polovr.productName = 'new Product';
        ACETPlanBenefitDetailRedesignControllerr.Accumulator InnAcc = new ACETPlanBenefitDetailRedesignControllerr.Accumulator();
        redesignctrl.Network = '[freedom]';
        redesignctrl.covrgLevel = 'EMP';
        InnAcc.Section='Family';
        InnAcc.TypeCode ='INN';           //INN or OON
        InnAcc.MaxDeductible ='20';
        InnAcc.YTDDeductible ='30';
        InnAcc.RemDeductible ='50';
        InnAcc.coinsurance=10;
        InnAcc.MaxOOP ='100';
        InnAcc.YTDOOP ='25';
        InnAcc.RemOOP ='30';
        InnAcc.covrgLevel ='test';
        InnAcc.primaryAccumDeduct ='44';
        InnAcc.primaryAccumDescOOP ='22';
        ACETPlanBenefitOveriewRedesignController  OvrReCtrl = new ACETPlanBenefitOveriewRedesignController();
        OvrReCtrl.MemberId ='72015543500';
        //OvrReCtrl.tempBenefitKey='TestKey';
        OvrReCtrl.IsPlanBenefit=true;
        //   OvrReCtrl.benefitCodeMap='';
        OvrReCtrl.BenefitBundleOptionId ='M00000007';
        OvrReCtrl.accumAsOf='02/04/2017';
        OvrReCtrl.failureMessage ='ERROR';
        OvrReCtrl.isVal =true;
        OvrReCtrl.dateRange ='04/04/2018';
        OvrReCtrl.hippaBenefitCodeJSON ='Hippa';
        OvrReCtrl.ccc ='Test';
        OvrReCtrl.bundleOptionId ='M00007';                
        OvrReCtrl.CoverageType ='INN';
        OvrReCtrl.EffectiveDate ='04/06/2018';
        OvrReCtrl.EndDate ='12/31/9999';    
        OvrReCtrl.SRKID ='SRKTEST';
        OvrReCtrl.benefitDateSearch ='14/12/2017';
        OvrReCtrl.currentDate ='04/13/2017';    
        OvrReCtrl.currentDateBenefits ='phy';
        OvrReCtrl.benefitKeys ='TST';
        List<String> bKeyslst = new List<String>();
        bKeyslst.add('TST');
       // OvrReCtrl.benefitKeysList= bKeyslst;
        OvrReCtrl.groupId='412239026';
        OvrReCtrl.renewalDate='04/13/2019';
        OvrReCtrl.groupEffectiveDate='04/10/2018';
        
        //  Continuation conti = (Continuation)OvrReCtrl.makePlanBenefitLanguageCallout2();
       // OvrReCtrl.makePlanBenefitLanguageCallout();
        //     OvrReCtrl.makePlanBenefitLanguageCallout1();
        //   OvrReCtrl.prepareBenefitCodeMap();
        //   OvrReCtrl.passBenefitKeysToControllerMethod();
        // OvrReCtrl.callIndividualBenefitResponse();
        OvrReCtrl.ChangeDateFormatForOIL('04/02/2018');
        
        ACETBenefitCoverageOverviewController bcoctrl = new ACETBenefitCoverageOverviewController();
        bcoctrl.EffectiveDate='04/04/2017';
        bcoctrl.EndDate='04/12/2017'; 
        bcoctrl.accumsDateSearch='04/04/2017';
        bcoctrl.populateDate();
        bcoctrl.accumasOfDate();
       
        bcoctrl.getGroupFamilyAccs();
        bcoctrl.getGroupIndividualAccs();
        
        ACETGroupPlanBenefitWrapper.AccumulatorP InnAcc1 = new ACETGroupPlanBenefitWrapper.AccumulatorP();
        list<ACETGroupPlanBenefitWrapper.AccumulatorP> inList = new list<ACETGroupPlanBenefitWrapper.AccumulatorP>();
        InnAcc1.Section='Family';
        InnAcc1.TypeCode ='INN';           //INN or OON
        InnAcc1.MaxDeductible ='20';
        InnAcc1.YTDDeductible ='30';
        InnAcc1.RemDeductible ='50';
        InnAcc1.coinsurance=10;
        InnAcc1.MaxOOP ='100';
        InnAcc1.YTDOOP ='25';
        InnAcc1.RemOOP ='30';
        InnAcc1.primaryAccumDeduct ='44';
        InnAcc1.primaryAccumDescOOP ='22';
        inList.add(InnAcc1);
        
        ACETGroupPlanBenefitWrapper grpwrap = new  ACETGroupPlanBenefitWrapper();
        map<string,string> mapdata = new map<string,string>();
        mapdata.put('12','UCR');
        grpwrap.accumulatorList = inList;
        grpwrap.hippakeyStr = 'test';
        grpwrap.coPayingMap = mapdata;
        grpwrap.OONReimbursementMap = mapdata;
        bcoctrl.ACETPlanBenefitSearchResults = grpwrap;
        bcoctrl.getCoPayList();
        
        List<ACETGroupPlanBenefitWrapper.OONReimbursement> oonlist = bcoctrl.OONReimbursementList;
        List<ACETGroupPlanBenefitWrapper.AccumulatorP> accmp =   bcoctrl.IndividualAccs;
        List<ACETGroupPlanBenefitWrapper.AccumulatorP> accmpfam =   bcoctrl.FamilyAccs;
        
        ACETAccumAsOfWrapper accumWrap = new  ACETAccumAsOfWrapper();
        accumWrap.accumAsofDate = '2018/01/01';
        bcoctrl.dateSearch = accumWrap;
        bcoctrl.accumasOfDate();
        
        List<ACETGroupPlanBenefitWrapper.coPayWrapper> coWrapplst= new List<ACETGroupPlanBenefitWrapper.coPayWrapper>();
        ACETGroupPlanBenefitWrapper.coPayWrapper coWrapp= new ACETGroupPlanBenefitWrapper.coPayWrapper();
        coWrapp.label='test';
        coWrapp.value ='50';
        coWrapplst.add(coWrapp);
        
        
        
        ACETGroupPlanBenefitWrapper ACETPlanBenefitSearchResults = new ACETGroupPlanBenefitWrapper();
        Map<String, String> coPayingMap1 = new Map<String, String>();
        coPayingMap1.put('test','test');
        ACETPlanBenefitSearchResults.coPayingMap=coPayingMap1;
        
        
        ACETGroupPlanBenefitWrapper.coPayWrapper bdw= new ACETGroupPlanBenefitWrapper.coPayWrapper ();
        bdw.value='ABDOMINAL_AORTIC_SCREENING_OUTPATIENT';
        bdw.label = 'test';
        
        
        string getBenfAccumJR = AcetTestDataUtility.getBenefitAccumJson();
        ACETGetAccumulatorRedesignWebservice NewGetAcc = new ACETGetAccumulatorRedesignWebservice();        
        NewGetAcc.GetEndpoint();
        // NewGetAcc.getAccumulatorBenefitsRedesign('M000000059','Test','100001','09/09/2017','01/01/2020','inn','phy','ABDOMINAL_AORTIC_SCREENING_OUTPATIENT','07/07/2017',getBenfAccumJR);
        // NewGetAcc.getAccumulatorBenefitsRedesign('111111',null,null,null,null,null,null,null,null);
        NewGetAcc.getDurationCodeMap();
        NewGetAcc.ChangeDateFormatForOIL('09/09/2017');
        NewGetAcc.getValidString('Test');
        // Continuation oContinuation = new Continuation();
        //  NewGetAcc.StartRequest('1111111','oon','', 'id','test','test','test','test','test','test',,'test');
        
        ACETGetBenefitLanguageRedesignWebService BLRWS = new ACETGetBenefitLanguageRedesignWebService();
        BLRWS.GetEndpoint();
        BLRWS.getValidString('Test');
        BLRWS.ChangeDateFormatForOIL('07/07/2017');
        list<string> lstbenefitCodes = new list<string>();
        lstbenefitCodes.add('ABORTION_ELECTIVE_OFFICE');
        BLRWS.getPlanBenefitLanguage('35345345', '2014-01-01', '72015543500',lstbenefitCodes , null, null, '2014-01-01','12345');
      //  BLRWS.getPlanBenefitLanguageNew('M000000059','2014-01-01','72015543500',lstbenefitCodes,null,'2014-01-01');
        
        
        Test.stopTest();
    } */
    
  /*  static testMethod void ACETProviderLookUpDetailControllerTestMethod3() {   
        Map<String, String> mapISLWSConfigs = new Map<String, String>(); 
        mapISLWSConfigs.put('ISLConAccessToken', 'e9b3f2b1-8863-49ec-9ff8-40da25961ef5');
        mapISLWSConfigs.put('OILHttpHeaderAccept', 'application/json;charset=UTF-8');
        mapISLWSConfigs.put('OILHttpHeaderActor', 'ACET');
        mapISLWSConfigs.put('OILHttpHeaderScope', 'read');
        mapISLWSConfigs.put('dev_ISLOAuthEndpoint', 'https://api-stg.optum.com:8443');
        mapISLWSConfigs.put('dev_getHCOEndpoint', '/api/bravo/eisl/benefits/getHCOEndpoint/v2.0/read');
        mapISLWSConfigs.put('dev_getHCPAdapterEndpoint', '/api/bravo/eisl/benefits/getHCPAdaptorEndpoint/v2.0/read');
        mapISLWSConfigs.put('OILTimeout', '3000');
        List<ISL_Webservice_Config__c> lstISLWSConfigs = ACETTestDataUtility.CreateISLWebserviceConfigurations(mapISLWSConfigs);
        insert lstISLWSConfigs;
        Account oAccount = ACETTestDataUtility.CreateAccount('Test Account', 'TstTaxID1', 'TestEID1');
        insert oAccount;
        Contact oContact = ACETTestDataUtility.CreateContact(oAccount.Id, 'Test Contact LN', 'Test Contact FN', 'TstTaxID1', 'TestEID1', 'TestNPI1');
        insert oContact;
        String JSONStr = '{"UHCBS":"","GroupN":"Test Group Name","GroupStatus":"Active","ServiceTeam":"NY Large","EffectiveStartDate":"3/1/2016","RiskManagement":"Rating Method","RatingMethod":"","RenewalDate":"3/1/2016","RelationshipType":"Mother","groupSName":"Test GroupName"}';
        Contact cont = TestDataFactory.createContact();
        Interaction__c InteractionId = ACETProviderSearchController.RedirectToProviderDetail('Phone Call', 'Contact Name', '1', '999999999', '9999999999', 'Group Name', 'Facility/Group','1452423968971','12345','60005');
        
        ACETHighlightsPanelAdditionalInfo AdditionalInfo = new ACETHighlightsPanelAdditionalInfo();
        AdditionalInfo.DOB = '12/27/2009';
        AdditionalInfo.SitusState = '12/27/2009';
        AdditionalInfo.EffectiveDate = '12/27/2009';
        AdditionalInfo.EndDate = '12/27/2009';
        AdditionalInfo.groupName  = 'Test';
        AdditionalInfo.Network    = 'Test';
        AdditionalInfo.OriginatorRelationship  = 'Test';
        AdditionalInfo.PolicyNumber  = 'UHC1234';
        AdditionalInfo.Product  = 'Product Test';
        AdditionalInfo.productType  = 'Care Service';
        AdditionalInfo.Relationship  = 'Primary'; 
        Test.startTest();
        PageReference ACETPDPage = Page.ACETPlanBenefitDetailRedesign;
        String IntId = InteractionId.Id;
        ACETPDPage.getParameters().put('Id', IntId);
        //ACETPDPage.getParameters().put('additionalInfo', 'PolicyNumber');
        ACETPDPage.getParameters().put('additionalInfo', JSON.serialize(AdditionalInfo));
        ApexPages.currentPage().getParameters().put('interactionId',InteractionId.id); 
        ApexPages.currentPage().getParameters().put('Id','88358551100');
        ApexPages.currentPage().getParameters().put('SRK','894666785'); //894666785
        Apexpages.StandardController ACETPDStdCtrl = new Apexpages.standardController(InteractionId);
        ACETPDPage.getParameters().put('CheckNumber', '1123');
        ACETPDPage.getParameters().put('SeriesDesignator ', 'Test');             
        ACETPDPage.getParameters().put('contactId', oContact.Id); 
        ACETPDPage.getParameters().put('strType', 'Active');
        ACETPDPage.getParameters().put('providerType', 'Physician'); 
        //Test.setCurrentPage(ACETPDPage);
        ACETPlanBenefitDetailRedesignControllerr ACETPBDRC1 = new ACETPlanBenefitDetailRedesignControllerr(); 
        // ACETPBDRC1.additionalInfo = AdditionalInfo;
        // ACETPBDRC1.providerType = 'Facility';
        ACETMemberDetail ACETmemdet = new ACETMemberDetail();
        List<ACETMemberDetail.PCPAssignment> PCPAssignmentList = new List<ACETMemberDetail.PCPAssignment>();
        ACETMemberDetail.PCPAssignment PCPAssignment = new  ACETMemberDetail.PCPAssignment();
        PCPAssignment.FirstName = 'Test FirstName';
        PCPAssignment.LastName = 'Test LastName';
        PCPAssignment.pcpAssignmentType = 'Type';
        PCPAssignmentList.add(PCPAssignment);
        ACETmemdet.PCPAssignments = PCPAssignmentList;
        ACETPBDRC1.CallWSOnPageLoad();
        // ACETPBDRC1.UpdatePCPOBGYN();
        Continuation conti = (Continuation)ACETPBDRC1.CallWSOnPageLoad();     
        Map<String, HttpRequest> requests = conti.getRequests();
        // system.assertEquals(2, requests.size());
        
        HttpResponse response;
        HttpRequest request;
        
        for(String RequestLabel: requests.keyset()){
            request = requests.get(RequestLabel);
            response = new HttpResponse();
            response.setStatusCode(200);
            response.setStatus('OK');
            response.setBody(ACETTestDataUtility.getSubscriptionBenefitJSON());     
            Test.setContinuationResponse(RequestLabel, response); 
        }
        Object result = Test.invokeContinuationMethod(ACETPBDRC1, conti); 
        ACETGetSubscriptionRedesignWebservice ssbService = new ACETGetSubscriptionRedesignWebservice();
        ssbService.init('8978989', '7878790900', '12/31/2017', '12/31/2099', '', '', '', '');
        ssbService.getSubscriptionBenefitSearch('8978989', '7878790900', '7878790900','12/31/2017', '12/31/2099', '', '', '', '');
        ssbService.StartRequest('8978989','', null, null);
        ssbService.providerStartRequest('8978989', '', '234343','12/31/2017', '12/31/2099', '', '', '', '', '', '', null, null, '');
        //  ssbService.ProcessResponse(oContinuation);
        ssbService.getTierCode();
        ssbService.getDurationCodeMap();
        Test.stopTest();
    } */
    
  /*  static testMethod void SSBServiceCallPrvdlkp() {
        Test.startTest();
        Map<String, String> TestISLWSConfigs = new Map<String, String>(); 
        TestISLWSConfigs.put('ISLConAccessToken', 'dfb379c2-06b7-46c4-8c6f-bbc390d1b854');
        TestISLWSConfigs.put('ISLOAuthContentType', 'application/x-www-form-urlencoded');
        TestISLWSConfigs.put('ISLOAuthGrantType', 'client_credentials');
        TestISLWSConfigs.put('OILHttpHeaderAccept', 'application/json;charset=UTF-8');
        TestISLWSConfigs.put('OILHttpHeaderActor', 'ACET');
        TestISLWSConfigs.put('OILHttpHeaderScope', 'read');
        TestISLWSConfigs.put('OILTimeout', '3000');
        TestISLWSConfigs.put('dev_ISLOAuthEndpoint', 'https://api-stg.optum.com:8443');
        TestISLWSConfigs.put('dev_getSubscriptionBenefitSearch', '/api/alpha/eisl/providers/medicalproviders/v2.0/search');
        List<ISL_Webservice_Config__c> lstISLWSConfigs = ACETTestDataUtility.CreateISLWebserviceConfigurations(TestISLWSConfigs);
        insert lstISLWSConfigs;
        
        String ResponseJSON = '{"ACETGetSubscriptionRedesignRequest":{"errors":[{"code":"W008","name":"No records returned","severity":"low",';
        ResponseJSON += '"origin":"Consumer","description":"Consumer has requested a query for which no records have been found."}]}}'; 
        
        
        ACETHighlightsPanelAdditionalInfo AdditionalInfo = new ACETHighlightsPanelAdditionalInfo();
        AdditionalInfo.PolicyNumber = 'TestPolicyNumber';
        
        MockHttpCalloutResponseGenerator.MockHttpResponse OILTestResponse = new MockHttpCalloutResponseGenerator.MockHttpResponse(500, 'Internal Server Error', ResponseJSON);
        OILTestResponse.TokenExpired = false;
        
        
        
        MockHttpCalloutResponseGenerator MockHttpResponse = new MockHttpCalloutResponseGenerator(null, OILTestResponse);
        Test.setMock(HttpCalloutMock.class, MockHttpResponse);
        
        
        ACETGetSubscriptionRedesignWebservice ssbService = new ACETGetSubscriptionRedesignWebservice();
        ssbService.init('8978989', '7878790900', '12/31/2017', '12/31/2099', '', '', '', '');
        ssbService.getSubscriptionBenefitSearch('8978989', '7878790900', '7878790900','12/31/2017', '12/31/2099', '', '', '', '');
        ssbService.StartRequest('8978989','', null, null);
        ssbService.providerStartRequest('8978989', '', '234343','12/31/2017', '12/31/2099', '', '', '', '', '', '', null, null, '');
        //  ssbService.ProcessResponse(oContinuation);
        ssbService.getTierCode();
        ssbService.getDurationCodeMap();
        Test.stopTest();
    } */
    
    /*static testMethod void ACETProviderLookUpDetailControllerTestMethod6() {   
        Map<String, String> mapISLWSConfigs = new Map<String, String>(); 
        mapISLWSConfigs.put('ISLConAccessToken', 'e9b3f2b1-8863-49ec-9ff8-40da25961ef5');
        mapISLWSConfigs.put('OILHttpHeaderAccept', 'application/json;charset=UTF-8');
        mapISLWSConfigs.put('OILHttpHeaderActor', 'ACET');
        mapISLWSConfigs.put('OILHttpHeaderScope', 'read');
        mapISLWSConfigs.put('dev_ISLOAuthEndpoint', 'https://gateway-stage.optum.com/');
        mapISLWSConfigs.put('dev_getHCOEndpoint', '/api/bravo/eisl/benefits/getHCOEndpoint/v2.0/read');
        mapISLWSConfigs.put('dev_getHCPAdapterEndpoint', '/api/bravo/eisl/benefits/getHCPAdaptorEndpoint/v2.0/read');
        mapISLWSConfigs.put('OILTimeout', '3000');
        List<ISL_Webservice_Config__c> lstISLWSConfigs = ACETTestDataUtility.CreateISLWebserviceConfigurations(mapISLWSConfigs);
        insert lstISLWSConfigs;
        RecordType newRecord = [SELECT Id FROM RecordType WHERE Name = 'Person Account' and SObjectType = 'Account'];
        
        Account accountTest = new Account();
        accountTest.FirstName = 'Test Contact FN';
        accountTest.LastName = 'Test Contact LN';
        accountTest.EID__c = 'TestEID1';
        accountTest.EID__pc = 'TestEID1';
        accountTest.RecordTypeId = newRecord.Id;
        insert accountTest;

    Account acc = [SELECT Id,personcontactid from Account where Id=:accountTest.Id];
        Contact oContact = [SELECT Id,LastName,FirstName,EID__c,AccountId from Contact where Id=:acc.personcontactid];
        oContact.Tax_ID__c = 'TstTaxID1';
        oContact.NPI__c = 'TestNPI1';
        String JSONStr = '{"UHCBS":"","GroupN":"Test Group Name","GroupStatus":"Active","ServiceTeam":"NY Large","EffectiveStartDate":"3/1/2016","RiskManagement":"Rating Method","RatingMethod":"","RenewalDate":"3/1/2016","RelationshipType":"Mother","groupSName":"Test GroupName"}';
        Interaction__c InteractionId = ACETProviderSearchController.RedirectToProviderDetail('Phone Call', 'Contact Name', '1', '999999999', '9999999999', 'Group Name', 'Facility/Group','1452423968971','12345','60005');
        
        MockHttpCalloutResponseGenerator.MockHttpResponse OILResponse1 = new MockHttpCalloutResponseGenerator.MockHttpResponse(200, 'OK', ACETTestDataUtility.getSubscriptionBenefitResponse());
        OILResponse1.TokenExpired = false;
    
        MockHttpCalloutResponseGenerator MockHttpRes1 = new MockHttpCalloutResponseGenerator(null, OILResponse1);
        Test.setMock(HttpCalloutMock.class, MockHttpRes1);
        MockHttpCalloutResponseGenerator.MockHttpResponse OILResponse = new MockHttpCalloutResponseGenerator.MockHttpResponse(200, 'OK', ACETTestDataUtility.getBenefitAccumJson());
        OILResponse.TokenExpired = false;
        
        MockHttpCalloutResponseGenerator MockHttpRes = new MockHttpCalloutResponseGenerator(null, OILResponse);
        Test.setMock(HttpCalloutMock.class, MockHttpRes);
        
        Test.startTest();
        PageReference ACETPDPage = Page.ACETPlanBenefitDetailRedesign;
        String IntId = InteractionId.Id;
        ACETPDPage.getParameters().put('Id', IntId);
        //ACETPDPage.getParameters().put('additionalInfo', 'PolicyNumber');
        
        ApexPages.currentPage().getParameters().put('interactionId',InteractionId.id); 
        ApexPages.currentPage().getParameters().put('Id','88358551100');
        ApexPages.currentPage().getParameters().put('SRK','894666785'); //894666785
        Apexpages.StandardController ACETPDStdCtrl = new Apexpages.standardController(InteractionId);
        ACETPDPage.getParameters().put('CheckNumber', '1123');
        ApexPages.currentPage().getParameters().put('benefitKeys','"[Test]","[123]"');
        ACETPDPage.getParameters().put('SeriesDesignator ', 'Test');             
        ACETPDPage.getParameters().put('contactId', oContact.Id); 
        ACETPDPage.getParameters().put('strType', 'Active');
        ACETPDPage.getParameters().put('providerType', 'Physician'); 
        //Test.setCurrentPage(ACETPDPage);
        ACETPlanBenefitDetailRedesignControllerr ACETPBDRC1 = new ACETPlanBenefitDetailRedesignControllerr(); 
        // ACETPBDRC1.additionalInfo = AdditionalInfo;
        // ACETPBDRC1.providerType = 'Facility';
        ACETMemberDetail ACETmemdet = new ACETMemberDetail();
        List<ACETMemberDetail.PCPAssignment> PCPAssignmentList = new List<ACETMemberDetail.PCPAssignment>();
        ACETMemberDetail.PCPAssignment PCPAssignment = new  ACETMemberDetail.PCPAssignment();
        PCPAssignment.FirstName = 'Test FirstName';
        PCPAssignment.LastName = 'Test LastName';
        PCPAssignment.pcpAssignmentType = 'Type';
        PCPAssignmentList.add(PCPAssignment);
        ACETmemdet.PCPAssignments = PCPAssignmentList;
        ACETPBDRC1.CallWSOnPageLoad();
        ACETGroupPlanBenefitWrapper wrp = new ACETGroupPlanBenefitWrapper();
         wrp.hippaBenefitCodeJSON  = 'Hippa';
        apexpages.currentpage().getparameters().put('benefitKeys','test,test1');
        ACETPlanBenefitOveriewRedesignController planBenovrContr = new ACETPlanBenefitOveriewRedesignController();
        //map<string, string> tempmap = planBenovrContr.benefitCodeMap;
        planBenovrContr.selectedBenefit = wrp.hippaBenefitCodeJSON;
       // planBenovrContr.passBenefitKeysToControllerMethod();
        //planBenovrContr.callIndividualBenefitResponse();
        //planBenovrContr.makePlanBenefitLanguageCallout1();
        
       
        ACETGroupPlanBenefitWrapper gplawrap = new ACETGroupPlanBenefitWrapper();
         
        ACETPlanBenefitOveriewRedesignController  OvrReCtrl = new ACETPlanBenefitOveriewRedesignController();
        ACETPlanBenefitOveriewRedesignController.getAccumRedesign('12345','2018/01/01','12345888','','','','','2018/02/02','','','','','','','M000000006-5,M000000006-2,M000000006-4,M000000006-6,M000000006-1,M000000006-3','Calendar year','01-INN,02-INN,03-INN,04-INN,05-INN,06-INN,07-INN,08-00N,09-OON');
        ACETGetSubscriptionRedesignWebservice ssbService = new ACETGetSubscriptionRedesignWebservice();
        ssbService.providerStartRequest('8978989', '', '','234343','','12/31/2017', '12/31/2099', '', '', '', '', '', '', null, null, '');
        
        // ACETPBDRC1.UpdatePCPOBGYN();
        
        ACETGetAccumulatorRedesignWebservice NewGetAcc = new ACETGetAccumulatorRedesignWebservice();
        ACETGetAccumulatorRedesignJSON2APEX.benefitCostShare benfitCostShareObj = new ACETGetAccumulatorRedesignJSON2APEX.benefitCostShare();
        benfitCostShareObj.coverageLevel = 'Individual';
        benfitCostShareObj.primaryCostShareIndicator = 'false';
        Test.stopTest();
    }*/
    
    static testMethod void ACETProviderLookUpDetailControllerTestMethod8() {   
        Map<String, String> mapISLWSConfigs = new Map<String, String>(); 
        mapISLWSConfigs.put('ISLConAccessToken', 'e9b3f2b1-8863-49ec-9ff8-40da25961ef5');
        mapISLWSConfigs.put('OILHttpHeaderAccept', 'application/json;charset=UTF-8');
        mapISLWSConfigs.put('OILHttpHeaderActor', 'ACET');
        mapISLWSConfigs.put('OILHttpHeaderScope', 'read');
        mapISLWSConfigs.put('dev_ISLOAuthEndpoint', 'https://api-stg.optum.com:8443');
        mapISLWSConfigs.put('dev_getHCOEndpoint', '/api/bravo/eisl/benefits/getHCOEndpoint/v2.0/read');
        mapISLWSConfigs.put('dev_getHCPAdapterEndpoint', '/api/bravo/eisl/benefits/getHCPAdaptorEndpoint/v2.0/read');
        mapISLWSConfigs.put('OILTimeout', '3000');
        List<ISL_Webservice_Config__c> lstISLWSConfigs = ACETTestDataUtility.CreateISLWebserviceConfigurations(mapISLWSConfigs);
        insert lstISLWSConfigs;
        RecordType newRecord = [SELECT Id FROM RecordType WHERE Name = 'Person Account' and SObjectType = 'Account'];
        
        Account accountTest = new Account();
        accountTest.FirstName = 'Test Contact FN';
        accountTest.LastName = 'Test Contact LN';
        accountTest.EID__c = 'TestEID1';
        accountTest.EID__pc = 'TestEID1';
        accountTest.RecordTypeId = newRecord.Id;
        insert accountTest;

        String JSONStr = '{"UHCBS":"","GroupN":"Test Group Name","GroupStatus":"Active","ServiceTeam":"NY Large","EffectiveStartDate":"3/1/2016","RiskManagement":"Rating Method","RatingMethod":"","RenewalDate":"3/1/2016","RelationshipType":"Mother","groupSName":"Test GroupName"}';
        Interaction__c InteractionId = ACETProviderSearchController.RedirectToProviderDetail('Phone Call', 'Contact Name', '1', '999999999', '9999999999', 'Group Name', 'Facility/Group','1452423968971','12345','60005');
        
        MockHttpCalloutResponseGenerator.MockHttpResponse OILResponse = new MockHttpCalloutResponseGenerator.MockHttpResponse(404, 'OK', ACETTestDataUtility.getBenefitAccumJson());
        OILResponse.TokenExpired = false;
        
        MockHttpCalloutResponseGenerator MockHttpRes = new MockHttpCalloutResponseGenerator(null, OILResponse);
        Test.setMock(HttpCalloutMock.class, MockHttpRes);
        Test.startTest();
        
        
        list<string>  strlsttest = new list<string>();
        ACETPlanBenefitOveriewRedesignController  OvrReCtrl = new ACETPlanBenefitOveriewRedesignController();
        ACETPlanBenefitOveriewRedesignController.getAccumRedesign('12345','2018/01/01','12345888','','','','','2018/02/02','','','','','','','M000000006-5,M000000006-2,M000000006-4,M000000006-6,M000000006-1,M000000006-3','Calendar year','01-INN,02-INN,03-INN,04-INN,05-INN,06-INN,07-INN,08-00N,09-OON',strlsttest);
        
        Test.stopTest();
    }
    
    static testMethod void ACETProviderLookUpDetailControllerTestMethod9() {   
        Map<String, String> mapISLWSConfigs = new Map<String, String>(); 
        mapISLWSConfigs.put('ISLConAccessToken', 'e9b3f2b1-8863-49ec-9ff8-40da25961ef5');
        mapISLWSConfigs.put('OILHttpHeaderAccept', 'application/json;charset=UTF-8');
        mapISLWSConfigs.put('OILHttpHeaderActor', 'ACET');
        mapISLWSConfigs.put('OILHttpHeaderScope', 'read');
        mapISLWSConfigs.put('dev_ISLOAuthEndpoint', 'https://api-stg.optum.com:8443');
        mapISLWSConfigs.put('dev_getHCOEndpoint', '/api/bravo/eisl/benefits/getHCOEndpoint/v2.0/read');
        mapISLWSConfigs.put('dev_getHCPAdapterEndpoint', '/api/bravo/eisl/benefits/getHCPAdaptorEndpoint/v2.0/read');
        mapISLWSConfigs.put('OILTimeout', '3000');
        List<ISL_Webservice_Config__c> lstISLWSConfigs = ACETTestDataUtility.CreateISLWebserviceConfigurations(mapISLWSConfigs);
        insert lstISLWSConfigs;
        RecordType newRecord = [SELECT Id FROM RecordType WHERE Name = 'Person Account' and SObjectType = 'Account'];
        
        Account accountTest = new Account();
        accountTest.FirstName = 'Test Contact FN';
        accountTest.LastName = 'Test Contact LN';
        accountTest.EID__c = 'TestEID1';
        accountTest.EID__pc = 'TestEID1';
        accountTest.RecordTypeId = newRecord.Id;
        insert accountTest;

        String JSONStr = '{"UHCBS":"","GroupN":"Test Group Name","GroupStatus":"Active","ServiceTeam":"NY Large","EffectiveStartDate":"3/1/2016","RiskManagement":"Rating Method","RatingMethod":"","RenewalDate":"3/1/2016","RelationshipType":"Mother","groupSName":"Test GroupName"}';
        Interaction__c InteractionId = ACETProviderSearchController.RedirectToProviderDetail('Phone Call', 'Contact Name', '1', '999999999', '9999999999', 'Group Name', 'Facility/Group','1452423968971','12345','60005');
        
        String ResponseJSON = '{"getBenefitLanguageResponse":{"errors":[{"code":"W008","name":"No records returned","severity":"low",';
        ResponseJSON += '"origin":"Consumer","description":"Consumer has requested a query for which no records have been found."}]}}'; 
        
        MockHttpCalloutResponseGenerator.MockHttpResponse OILResponse = new MockHttpCalloutResponseGenerator.MockHttpResponse(404, 'Resource Not Found', ResponseJSON);
        OILResponse.TokenExpired = false;
        
        MockHttpCalloutResponseGenerator MockHttpRes = new MockHttpCalloutResponseGenerator(null, OILResponse);
        Test.setMock(HttpCalloutMock.class, MockHttpRes);
      
        Test.startTest();
        
        ACETPlanBenefitOveriewRedesignController  OvrReCtrl = new ACETPlanBenefitOveriewRedesignController();
        ACETBenefitsRedesignDetails act = new ACETBenefitsRedesignDetails();
        //OvrReCtrl.benefitDetailwrapper = act; 
        ACETGroupPlanBenefitWrapper.BenefitDetailsWrapper bdf = new ACETGroupPlanBenefitWrapper.BenefitDetailsWrapper();
        //ACETBenefitsRedesignDetails.BenefitSubSection bdfs = new ACETBenefitsRedesignDetails.BenefitSubSection();
        List<ACETGroupPlanBenefitWrapper.BenefitSubSection> bdfs = new List<ACETGroupPlanBenefitWrapper.BenefitSubSection>();
        bdf.BenefitCode ='12344';
        bdf.BenefitType = 'test';
        bdf.BenefitSubSection = bdfs;
        String SubscriptionServiceResponse = 'M000000007-1,M000000007-5,M000000007-4,M000000007-9,M000000007-6,M000000007-3,M000000007-7,M000000007-8,M000000007-2';
        String SubscriptionResponse = '1-INN,5-INN,4-INN,9-OON,6-INN,3-INN,7-INN,8-OON,2-INN';
                list<string>  strlsttest = new list<string>();

        ACETPlanBenefitOveriewRedesignController.getAccumRedesign('12345','2018/01/01','12345888','','','','','2018/02/02','','','','','','','M000000006-5,M000000006-2,M000000006-4,M000000006-6,M000000006-1,M000000006-3','Calendar year','01-INN,02-INN,03-INN,04-INN,05-INN,06-INN,07-INN,08-00N,09-OON',strlsttest );
        ACETPlanBenefitOveriewRedesignController.getBenefitLanguage('12345','2018/01/01','1234567689','','','','2018/01/01','2018/01/01','','','','','',true);
       
         ACETAccumAsOfWrapper accumwrapper = new ACETAccumAsOfWrapper();
        accumwrapper.accumAsofDate = '2018/01/01';
        
        
        ACETPlanBenefitLanguageWrapper benflangwrap = new ACETPlanBenefitLanguageWrapper();
        ACETPlanBenefitLanguageWrapper.BenefitWrapper benwrap = new ACETPlanBenefitLanguageWrapper.BenefitWrapper();
        benwrap.description = 'Langauge details';
        
        List<ACETPlanBenefitLanguageWrapper.BenefitWrapper> accumList = new List<ACETPlanBenefitLanguageWrapper.BenefitWrapper>(); 
        accumList.add(benwrap);
        ACETPlanBenefitLanguageWrapper.AccumulatorCode accumcode1 = new ACETPlanBenefitLanguageWrapper.AccumulatorCode();
        accumcode1.coverageLevel = 'Family';
        accumcode1.compareTo(accumcode1);
          
        Test.stopTest();
    }
    
    static testMethod void ACETProviderLookUpDetailControllerTestMethod10() {   
        ACETBenefitsRedesignDetails abrd = new ACETBenefitsRedesignDetails();
        abrd.hippaBenefitCodeJSON = 'hippa';
        ACETBenefitsRedesignDetails.LanguageSubSectionWrapper ls = new ACETBenefitsRedesignDetails.LanguageSubSectionWrapper();
        ls.benefitLevel = '1234';
        ls.benefitLevelDescription = '1234';
        ls.benefitCodeGeneralLanguage = '1234';
        ls.benefitVersion = '1234';
        ls.ageFrom = '1234';
        ls.ageFromDuration = '1234';
        ls.ageThrough = '1234';
        ls.ageThroughDuration = '1234';
        ls.benefitCodeLanguage = '1234';
        ls.CompareTo(ls);
        ACETBenefitsRedesignDetails.accumulatorWrapperSection awp= new ACETBenefitsRedesignDetails.accumulatorWrapperSection();
        awp.dateVersion = 'teetr';
    }
    
    static testMethod void testParse() {
        String json = ACETTestDataUtility.getBenefitLanguageJSON();
        ACETPlanBenefitRedesignLanguageJson2Apex obj = ACETPlanBenefitRedesignLanguageJson2Apex.parse(json);
        System.assert(obj != null);
        
        string json1 = ACETTestDataUtility.getBenefitAccumJson();
        ACETGetAccumulatorRedesignJSON2APEX obj1 = ACETGetAccumulatorRedesignJSON2APEX.parse(json1);
        System.assert(obj1 != null);
    }
    
    static testMethod void ACETplanBenefitSearchCtrlTestMethod11() 
    {
         //Setup records in custom setting
        Map<String, String> mapISLWSConfigs = new Map<String, String>(); 
        mapISLWSConfigs.put('ISLConAccessToken', 'e9b3f2b1-8863-49ec-9ff8-40da25961ef5');
        mapISLWSConfigs.put('OILHttpHeaderAccept', 'application/json;charset=UTF-8');
        mapISLWSConfigs.put('OILHttpHeaderActor', 'ACET');
        mapISLWSConfigs.put('OILHttpHeaderScope', 'read');
        mapISLWSConfigs.put('ISLOAuthContentType', 'application/x-www-form-urlencoded');
        mapISLWSConfigs.put('ISLOAuthGrantType', 'client_credentials');
        mapISLWSConfigs.put('dev_ISLOAuthClientId', 'ISLStageConClientId');
        mapISLWSConfigs.put('dev_ISLOAuthClientSecret', 'ISLStageConClientSecret');
        mapISLWSConfigs.put('dev_ISLOAuthEndpoint', 'https://api-stg.optum.com:8443');
        mapISLWSConfigs.put('dev_GetMedicalProviderEndpoint', '/api/test/eisl/providers/v1.0/medicalprovider/read');
        mapISLWSConfigs.put('dev_ISLOAuthTokenEndpoint', '/auth/oauth/v2/token');
        mapISLWSConfigs.put('OILTimeout', '3000');
        
        List<ISL_Webservice_Config__c> lstISLWSConfigs = ACETTestDataUtility.CreateISLWebserviceConfigurations(mapISLWSConfigs);
        insert lstISLWSConfigs;
        
        
        Map<String, Integer> mapOnshoreVerbgs = new Map<String, Integer>(); 
        mapOnshoreVerbgs.put('All Services Offshore',1);
        List<ACETOnshoreIndicatorVerbiage__c> lstOnshoreVerbgs = ACETTestDataUtility.CreateOnshoreVerbiages(mapOnshoreVerbgs);
        insert lstOnshoreVerbgs;
        
        Interaction__c ProviderTestInteraction =  TestDataFactory.createInteraction();
        Test.startTest();
        PageReference ACETEGPage = Page.ACETViewEmployerGroup;
        ACETEGPage.getParameters().put('InteractionId', ProviderTestInteraction.Id);
        ACETEGPage.getParameters().put('contactType', 'Primary Billing Administrator');            
        ACETEGPage.getParameters().put('selectedVal','thirdPartId');
        ACETEGPage.getParameters().put('additionalInfo','{"Zip":null,"UHCBS":null,"surrogatekey":null,"State":null,"SitusState":null,'+
        '"ServiceTeam":null,"RiskManagement":null,"RenewalDate":null,"RelationshipType":"Broker","Relationship":null,"RatingMethod":null,'+
        '"providerType":null,"ProductType":null,"Product":null,"producerSubject":"","producerOriginator":"C MCDERMOTT","producerName":"testings",'+
        '"producerId":"006342","PolicyNumber":null,"PhoneNumber":null,"OriginatorRelationship":"Broker","Network":null,"MemberId":null,'+
        '"LastName":null,"isMember":null,"isGroup":"false","GroupStatus":null,"groupSName":null,"GroupNumber":null,"GroupName":null,'+
        '"GroupN":null,"Gender":null,"FirstName":null,"EndDate":null,"EmployerName":null,"EffectiveStartDate":null,'+
        '"EffectiveDate":null,"DOB":null,"contactName":null,"ConsumerAccountIndicator":null,"BenefitPlanId":null}');
        ACETEGPage.getParameters().put('gnf', '1');
        ACETEGPage.getParameters().put('ContactName', 'test');
        test.setCurrentPage(ACETEGPage);
        
       
        /**StaticResource GetDummyResp = [SELECT Body FROM StaticResource WHERE Name = 'Test_GetEmpResponse'];
        String GetEmpGrpRes = GetDummyResp.Body.toString();
        System.debug('%%%%%%% test' + GetEmpGrpRes);
        MockHttpCalloutResponseGenerator.MockHttpResponse OILResponse = new MockHttpCalloutResponseGenerator.MockHttpResponse(200, 'OK', GetEmpGrpRes);
        OILResponse.TokenExpired = false;
        MockHttpCalloutResponseGenerator MockHttpRes = new MockHttpCalloutResponseGenerator(null, OILResponse);*/
        
        MockHttpCalloutResponseGenerator.MockHttpResponse OILTestResponse1 = new MockHttpCalloutResponseGenerator.MockHttpResponse(200, 'OK',ACETTestDataUtility.getEmployerGroupDetailJson());
        OILTestResponse1.TokenExpired = false;
        
        MockHttpCalloutResponseGenerator MockHttpResponse1 = new MockHttpCalloutResponseGenerator(null, OILTestResponse1);
        Test.setMock(HttpCalloutMock.class, MockHttpResponse1);
        
        
        
        
        ACETPlanBenefitSearchRedesignController planBenfSrctrl = new ACETPlanBenefitSearchRedesignController();
        planBenfSrctrl.callwebservice('1278550');
        ACETGroupDetail gd = new ACETGroupDetail();
        AcetGroupDetail.PolicyContract polcontract = new AcetGroupDetail.PolicyContract();
        polcontract.policyConId = '234234';
        polcontract.policyStatus = 'Active';
        polcontract.effectiveDate = '04/09/2018';
        polcontract.endDate = '31/09/2018';
        
        List<AcetGroupDetail.PolicyContract> policyContractList = new List<AcetGroupDetail.PolicyContract>();
        policyContractList.add(polcontract);
        planBenfSrctrl.GroupPolicyResultsList = policyContractList;
        
        planBenfSrctrl.policyStatusSelected = 'Active';
        planBenfSrctrl.polStatus = 'Active';
        planBenfSrctrl.selectedActiveAndAll = 'Active';
        planBenfSrctrl.poleffectDate ='04/09/2018';
        planBenfSrctrl.polendDate = '31/09/2018';
        planBenfSrctrl.isActive= 'isActive';
        planBenfSrctrl.IsShowActiveBenefitsOnly = false;
        planBenfSrctrl.polContractId = '234234';
        Test.stopTest();        
    } 
    
   static testMethod void planBenefitOveriewTestMethod() {
        Map<String, String> mapISLWSConfigs = new Map<String, String>(); 
        mapISLWSConfigs.put('ISLConAccessToken', 'e9b3f2b1-8863-49ec-9ff8-40da25961ef5');
        mapISLWSConfigs.put('OILHttpHeaderAccept', 'application/json;charset=UTF-8');
        mapISLWSConfigs.put('OILHttpHeaderActor', 'ACET');
        mapISLWSConfigs.put('OILHttpHeaderScope', 'read');
        mapISLWSConfigs.put('dev_ISLOAuthEndpoint', 'https://api-stg.optum.com:8443');
        mapISLWSConfigs.put('dev_getHCOEndpoint', '/api/bravo/eisl/benefits/getHCOEndpoint/v2.0/read');
        mapISLWSConfigs.put('dev_getHCPAdapterEndpoint', '/api/bravo/eisl/benefits/getHCPAdaptorEndpoint/v2.0/read');
        mapISLWSConfigs.put('OILTimeout', '3000');
        List<ISL_Webservice_Config__c> lstISLWSConfigs = ACETTestDataUtility.CreateISLWebserviceConfigurations(mapISLWSConfigs);
        insert lstISLWSConfigs;
        RecordType newRecord = [SELECT Id FROM RecordType WHERE Name = 'Person Account' and SObjectType = 'Account'];
        
        Account accountTest = new Account();
        accountTest.FirstName = 'Test Contact FN';
        accountTest.LastName = 'Test Contact LN';
        accountTest.EID__c = 'TestEID1';
        accountTest.EID__pc = 'TestEID1';
        accountTest.RecordTypeId = newRecord.Id;
        insert accountTest;

        String JSONStr = '{"UHCBS":"","GroupN":"Test Group Name","GroupStatus":"Active","ServiceTeam":"NY Large","EffectiveStartDate":"3/1/2016","RiskManagement":"Rating Method","RatingMethod":"","RenewalDate":"3/1/2016","RelationshipType":"Mother","groupSName":"Test GroupName"}';
        Interaction__c InteractionId = ACETProviderSearchController.RedirectToProviderDetail('Phone Call', 'Contact Name', '1', '999999999', '9999999999', 'Group Name', 'Facility/Group','1452423968971','12345','60005');
        
        Test.startTest();
        String ResponseJSON = '{"ACETGetSubscriptionRedesignRequest":{"errors":[{"code":"W008","name":"No records returned","severity":"low",';
        ResponseJSON += '"origin":"Consumer","description":"Consumer has requested a query for which no records have been found."}]}}'; 
        
        MockHttpCalloutResponseGenerator.MockHttpResponse OILResponse = new MockHttpCalloutResponseGenerator.MockHttpResponse(500, 'OK', ResponseJSON);
        OILResponse.TokenExpired = false;
        
        MockHttpCalloutResponseGenerator MockHttpRes = new MockHttpCalloutResponseGenerator(null, OILResponse);
        Test.setMock(HttpCalloutMock.class, MockHttpRes);
        list<string> strlsttest = new list<string>();
        ACETPlanBenefitOveriewRedesignController.getAccumRedesign('12345','2018/01/01','12345888','','','','','2018/02/02','','','','','','','M000000006-5,M000000006-2,M000000006-4,M000000006-6,M000000006-1,M000000006-3','Calendar year','01-INN,02-INN,03-INN,04-INN,05-INN,06-INN,07-INN,08-00N,09-OON',strlsttest );
        ACETPlanBenefitOveriewRedesignController.getBenefitLanguage('12345','2018/01/01','1234567689','','','','2018/01/01','2018/01/01','','','','','',true);
       
        ACETPlanBenefitOveriewRedesignController  OvrReCtrl = new ACETPlanBenefitOveriewRedesignController();
        OvrReCtrl.dateRange = '01/31/2017 - 01/31/2018';
        OvrReCtrl.MemberId ='72015543500';
        OvrReCtrl.IsPlanBenefit=true;
        OvrReCtrl.BenefitBundleOptionId ='M00000007';
         OvrReCtrl.accumAsOf='02/04/2017';
        OvrReCtrl.failureMessage ='ERROR';
        OvrReCtrl.isVal =true;
        OvrReCtrl.dateRange ='04/04/2018';
        OvrReCtrl.hippaBenefitCodeJSON ='Hippa';
        OvrReCtrl.ccc ='Test';
        OvrReCtrl.bundleOptionId ='M00007';                
        OvrReCtrl.CoverageType ='INN';
        OvrReCtrl.EffectiveDate ='04/06/2018';
        OvrReCtrl.EndDate ='12/31/9999';    
        OvrReCtrl.SRKID ='SRKTEST';
        OvrReCtrl.benefitDateSearch ='14/12/2017';
        OvrReCtrl.currentDate ='04/13/2017';    
        OvrReCtrl.currentDateBenefits ='phy';
        OvrReCtrl.benefitKeys ='TST';
        List<String> bKeyslst = new List<String>();
        bKeyslst.add('TST');
       // OvrReCtrl.benefitKeysList= bKeyslst;
        OvrReCtrl.groupId='412239026';
        OvrReCtrl.renewalDate='04/13/2019';
        OvrReCtrl.groupEffectiveDate='04/10/2018';
        ACETGroupPlanBenefitWrapper groupPlanWrap = new ACETGroupPlanBenefitWrapper();
        groupPlanWrap.benefitRedesignWrapperList = new Map<String,Map<String,List<ACETGroupPlanBenefitWrapper.BenefitSubSection>>>();
        ACETGroupPlanBenefitWrapper.BenefitSubSection BenefitSection1 = new ACETGroupPlanBenefitWrapper.BenefitSubSection();
        BenefitSection1.benefitLevel ='TEst';
        BenefitSection1.benefitLevelDescription ='Desc';
        BenefitSection1.benefitCodeGeneralLanguage ='ENG';
        BenefitSection1.benefitCodeLanguage ='EN'; 
        BenefitSection1.benefitVersion ='v2'; 
        BenefitSection1.ageFrom ='25'; 
        BenefitSection1.ageFromDuration ='11/11/2007';   
        BenefitSection1.ageThrough ='04/04/2018';    
        BenefitSection1.ageThroughDuration ='04/04/2018';   
        BenefitSection1.networkId  ='typw';  
        BenefitSection1.relationshipCode  ='REL';  
        BenefitSection1.coverageIndicator  ='CI';
        List<ACETGroupPlanBenefitWrapper.BenefitSubSection> benefitSectionList = new List<ACETGroupPlanBenefitWrapper.BenefitSubSection>();
        benefitSectionList.add(BenefitSection1);
        Map<String,List<ACETGroupPlanBenefitWrapper.BenefitSubSection>> benefitSectionMap = new Map<String,List<ACETGroupPlanBenefitWrapper.BenefitSubSection>>();
        benefitSectionMap.put('DURABLE_MEDICAL_EQUIPMENT_OUTPATIENT',benefitSectionList);
        groupPlanWrap.benefitRedesignWrapperList.put('DURABLE_MEDICAL_EQUIPMENT_OUTPATIENT',benefitSectionMap);
        Map<String,String> benefitCodeMap = OvrReCtrl.benefitCodeMap;
        List<String> allbenefitCodes = OvrReCtrl.allbenefitCodes;
        Test.stopTest();
    }
    
 }