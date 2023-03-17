@isTest
public class ACETLGT_PlanBenefitDetailControllerTest {
    
    public static final Integer statusCode200 = 200;
    public static final String status200 = 'OK';
    public static final Integer statusCode400 = 400;
    public static final String status400 = 'Bad Request';
    
	public static final String nimbusGetSSBResponse = '{"getSubscriptionServiceBenefitResponse":{"serviceBenefit":{"memberGroup":{"groupNumber":"1013629","groupName":"E2E_Rivervally_group 20210702035146"},"memberGroupContractPlanOption":{"benefitBundleOptionId":"11958418","planMetallicLevel":"Gold","oonPricingType":"CMS Based","mnrpPercentile":"110.00","ucrPercentile":"80.00","fallThruPercent":"20.00","bookOfBusinessTypeCode":"UH","bookOfBusinessTypeDescription":"UnitedHealthcare Insurance Company","lineOfBusinessId":"2","lineOfBusinessName":"Small Business","lineOfBusinessDescription":"Small Business  (UHC definition = 2 to 50, and Sole Prop)","benefitPlan":[{"membership":[{"subscriberIdentifier":{"type":"SRK","id":"740970865"},"enrolleeIdentifier":{"type":"SRK","id":"740970884"},"coverageStartDate":"2021-01-01","coverageEndDate":"9999-12-31","timePeriodQualifier":"Calendar","contractOptionStartDate":"2021-01-01","contractOptionEndDate":"2021-12-31"}],"benefitPlanId":"M030000189","coverageType":"MEDICAL","carrierId":"36","legalEntityName":"UnitedHealthcare Insurance Company","networkScheduleIds":[{"networkScheduleId":"CHOICEPLUS_1"}],"gatedProductIndicator":"false","pcpRequiredIndicator":"false","productName":"UHC POS Non-Gated INN/OON","productId":"PM00000048","planTypeCode":"POS","timelyFilingLimitDuration":"365","timelyFilingLimitType":"Days","customerFacingPlanName":"UHC Choice Plus Gold 1500-4","riderOnlyFlag":"false","planTier":[{"tierIdentifier":"1","tierDescription":"Core Benefits","tierTypeCode":"INN","tierTypeDescription":"In Network","gatedPlanIndicator":"false","primaryCoInsurance":"80","accumulatorAmounts":[{"accumLevel":"PLAN","individualDeductibleMaximum":"1500.00","familyDeductibleMaximum":"3000.00","individualOOPMaximum":"6900.00","familyOOPMaximum":"13800.00","individualDeductibleYTD":"0.00","familyDeductibleYTD":"0.00","individualOOPYTD":"0.00","familyOOPYTD":"0.00","familyAccumulationTypeDescriptionDeductible":"Embedded Accum","familyAccumulationTypeDescriptionOOP":"Embedded Accum","deductibleCarryOverIndicator":"false","shareBasePlanAccumulatorIndicatorOOP":"false","shareBasePlanAccumulatorIndicatorDeductible":"false"}],"pcpCopay":["35.00"],"specialistCopay":["70.00"],"urgentCareCopay":["75.00"],"inPatientCopay":["0.00"],"serviceAreaType":"In/Out of Srvc Area","planDelegation":[{"delegationIndicator":"false"}],"primaryOopComposition":{"costShareType":["Deductible","Copay","Coinsurance"]},"networkAccessTypeCode":"2","networkAccessTypeDescription":"Open Access - All Networks","network":[{"id":"network_id1","description":"Core Benefit Network"}]},{"tierIdentifier":"2","tierDescription":"OON Benefits","tierTypeCode":"OON","tierTypeDescription":"Out of Network","gatedPlanIndicator":"false","primaryCoInsurance":"50","accumulatorAmounts":[{"accumLevel":"PLAN","individualDeductibleMaximum":"2550.00","familyDeductibleMaximum":"5100.00","individualOOPMaximum":"15800.00","familyOOPMaximum":"31600.00","individualDeductibleYTD":"0.00","familyDeductibleYTD":"0.00","individualOOPYTD":"0.00","familyOOPYTD":"0.00","familyAccumulationTypeDescriptionDeductible":"Embedded Accum","familyAccumulationTypeDescriptionOOP":"Embedded Accum","deductibleCarryOverIndicator":"false","shareBasePlanAccumulatorIndicatorOOP":"false","shareBasePlanAccumulatorIndicatorDeductible":"false"}],"virtualVisitsCopay":["0.00"],"urgentCareCopay":["0.00"],"inPatientCopay":["0.00"],"serviceAreaType":"In/Out of Srvc Area","planDelegation":[{"delegationIndicator":"false"}],"primaryOopComposition":{"costShareType":["Deductible","Copay","Coinsurance"]}}],"benefitCode":[{"benefitName":"Vision Services","benefitCode":"VISION_SERVICES","benefitDisplay":"Vision Services","benefitTier":["1","2"],"benefitType":"M","primaryOOPOnlyFlag":"false","primaryDeductibleOnlyFlag":"false","visitLimitsApplies":"false","copayApplies":"false","variableCoverage":"true","existsOnRiderPlan":"false","hipaaServiceTypes":[{"serviceTypeCode":"AL","serviceTypeDescription":"Vision (Optometry)"}]},{"benefitName":"Infertility Services - Artificial Insemination","benefitCode":"INFERTILITY_SERVICES_AI","benefitDisplay":"Infertility Services - Artificial Insemination","benefitTier":["2","1"],"benefitType":"M","primaryOOPOnlyFlag":"false","primaryDeductibleOnlyFlag":"false","visitLimitsApplies":"false","copayApplies":"false","variableCoverage":"true","existsOnRiderPlan":"false","hipaaServiceTypes":[{"categoryCode":"01","categoryCodeDescription":"Medical Care","serviceTypeCode":"83","serviceTypeDescription":"Infertility"}]}],"eHBIndicator":"true","externalIds":[{"entityId":"EMBDENT","externalPlanId":"CD4Y"}],"qualityProviderTierRuleID":"","placeOfServiceDifferentialIndicator":"false","fundingArrangementCode":"01","fundingArrangementDescription":"Fully Insured","revenueArrangementCode":"01","revenueArrangementDescription":"FI","carrierBusinessId":"36"}]}}}}';
    public static final String nimbusGetSSBBadResponse = '{"getSubscriptionServiceBenefitResponse":{"transactionId":"fdd36afa-a4db-42ec-89cb-d4450fd6909e","errors":[{"code":400,"name":"InvalidRequest","severity":"FAULT","origin":"cirrus","description":"getSubscriptionServiceBenefitRequest : Validation Failed for Member Search required fields missing","uri":"/api/nebula/v1.0/benefits/read"}]}}';
   
    
	@testSetup static void setup() {
       List<ISL_Webservice_Config__c> webConfigList=new List<ISL_Webservice_Config__c>(); 
        ISL_Webservice_Config__c webORSUpdateConfig = new ISL_Webservice_Config__c();
        webORSUpdateConfig.Name = 'dev_getSubscriptionBenefitSearch';
        webORSUpdateConfig.ACET_Common_Name__c = 'getSubscriptionBenefitSearch';
        webORSUpdateConfig.Value__c = '/api/alpha/eisl/benefits/servicebenefit/v6.0/read';
        webConfigList.add(webORSUpdateConfig);
        
        ISL_Webservice_Config__c topsConfig1 = new ISL_Webservice_Config__c();
        topsConfig1.Name = 'StargateConAccessToken';
        topsConfig1.ACET_Common_Name__c = 'StargateConAccessToken';
        topsConfig1.Value__c = 'e9b3f2b1-8863-49ec-9ff8-40da25961ef5';
        webConfigList.add(topsConfig1);
        
        ISL_Webservice_Config__c topsConfig2 = new ISL_Webservice_Config__c();
        topsConfig2.Name = 'qa_StargateOAuthEndpoint';
        topsConfig2.ACET_Common_Name__c = 'StargateOAuthEndpoint';
        topsConfig2.Value__c = '/auth/oauth/v2/token';
        webConfigList.add(topsConfig2);
        
        ISL_Webservice_Config__c topsConfig3 = new ISL_Webservice_Config__c();
        topsConfig3.Name = 'dev_ISLOAuthEndpoint';
        topsConfig3.ACET_Common_Name__c = 'dev_StargateOAuthEndpoint';//dev_StargateOAuthEndpoint
        topsConfig3.Value__c = '/auth/oauth/v2/token';
        webConfigList.add(topsConfig3);
        
        ISL_Webservice_Config__c topsConfig4 = new ISL_Webservice_Config__c();
        topsConfig4.Name = 'StargateTimeout';
        topsConfig4.Value__c = '3000';
        webConfigList.add(topsConfig4);
        
        ISL_Webservice_Config__c topsConfig5 = new ISL_Webservice_Config__c();
        topsConfig5.Name = 'SRKCounter';
        topsConfig5.Value__c = '1';
        webConfigList.add(topsConfig5);
       
        ISL_Webservice_Config__c topsConfig6 = new ISL_Webservice_Config__c();
        topsConfig6.Name = 'ISLOAuthContentType';
        topsConfig6.Value__c = 'application/x-www-form-urlencoded';
        webConfigList.add(topsConfig6);
        
        ISL_Webservice_Config__c topsConfig7 = new ISL_Webservice_Config__c();
        topsConfig7.Name = 'OILHttpHeaderAccept';
        topsConfig7.Value__c = 'application/json;charset=UTF-8';
        webConfigList.add(topsConfig7);
        
        ISL_Webservice_Config__c topsConfig8 = new ISL_Webservice_Config__c();
        topsConfig8.Name = 'OILHttpHeaderActor';
        topsConfig8.Value__c = 'ACET';
        webConfigList.add(topsConfig8);
        
        ISL_Webservice_Config__c topsConfig9 = new ISL_Webservice_Config__c();
        topsConfig9.Name = 'OILHttpHeaderScope';
        topsConfig9.Value__c = 'read';
        webConfigList.add(topsConfig9);
                
        
        insert webConfigList;
        
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
    public static void getSearchResults_Test1(){
    	String surrogateKey ='2342342'; 
    	String bundleId ='34234243'; 
    	String enrollerSRK ='dfefwe'; 
    	String startDate ='02/12/2010';
    	String endDate ='12/12/2010'; 
    	String coverageTypes ='test'; 
    	String groupNumber ='234234'; 
    	String accumsDate ='12/12/2010'; 
    	String accumAsOf ='12/12/2010'; 
    	Boolean isActive = true; 
    	Boolean isTermed = true;
        String customerPurchaseId = '2342423';
        String resBody =  '{}';
        Test.startTest();
        MockHttpCalloutResponseGenerator.MockHttpResponse oilResponse =  new MockHttpCalloutResponseGenerator.MockHttpResponse(statusCode200, status200, nimbusGetSSBResponse);
        OILResponse.TokenExpired = false; 
        MockHttpCalloutResponseGenerator mockHttpRes = new MockHttpCalloutResponseGenerator(null, oilResponse);
        Test.setMock(HttpCalloutMock.class, mockHttpRes);
        ACETLGT_PlanBenefitDetailController.getSearchResults(surrogateKey, bundleId, enrollerSRK, startDate, endDate, coverageTypes, groupNumber, accumsDate, accumAsOf, isActive, isTermed,customerPurchaseId);
       	Test.stopTest();
       
    }
    @isTest
   public static void getSearchResults_Test2(){
    	String surrogateKey ='2342342'; 
    	String bundleId ='34234243'; 
    	String enrollerSRK ='dfefwe'; 
    	String startDate ='02/12/2010';
    	String endDate ='12/12/2010'; 
    	String coverageTypes ='test'; 
    	String groupNumber ='234234'; 
    	String accumsDate ='12/12/2010'; 
    	String accumAsOf ='12/12/2010'; 
    	Boolean isActive = true; 
    	Boolean isTermed = true;
        String customerPurchaseId = '2342423';
        String resBody =  '{}';
      
       	Test.startTest();
		ACETLGT_PlanBenefitDetailController.getSearchResults(surrogateKey, bundleId, enrollerSRK, startDate, endDate, coverageTypes, groupNumber, accumsDate, accumAsOf, isActive, isTermed,customerPurchaseId);
       
       	MockHttpCalloutResponseGenerator.MockHttpResponse oilResponse =  new MockHttpCalloutResponseGenerator.MockHttpResponse(statusCode400, status400, nimbusGetSSBBadResponse);
        OILResponse.TokenExpired = false; 
        MockHttpCalloutResponseGenerator mockHttpRes = new MockHttpCalloutResponseGenerator(null, oilResponse);
        Test.setMock(HttpCalloutMock.class, mockHttpRes);
        ACETLGT_PlanBenefitDetailController.getSearchResults(surrogateKey, bundleId, enrollerSRK, startDate, endDate, coverageTypes, groupNumber, accumsDate, accumAsOf, isActive, isTermed,customerPurchaseId);
       	Test.stopTest();
       
    }
   
    
   
    
}