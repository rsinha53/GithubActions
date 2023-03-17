@isTest
private class ACETLGT_PharmacyInquiryControllerTest {
	public static final Integer statusCode200 = 200;
    public static final String status200 = 'OK';
    public static final String nimbusGetSSBResponse = '{"getSubscriptionServiceBenefitResponse":{"serviceBenefit":{"memberGroup":{"groupNumber":"1013629","groupName":"E2E_Rivervally_group 20210702035146"},"memberGroupContractPlanOption":{"benefitBundleOptionId":"11958418","planMetallicLevel":"Gold","oonPricingType":"CMS Based","mnrpPercentile":"110.00","ucrPercentile":"80.00","fallThruPercent":"20.00","bookOfBusinessTypeCode":"UH","bookOfBusinessTypeDescription":"UnitedHealthcare Insurance Company","lineOfBusinessId":"2","lineOfBusinessName":"Small Business","lineOfBusinessDescription":"Small Business  (UHC definition = 2 to 50, and Sole Prop)","benefitPlan":[{"membership":[{"subscriberIdentifier":{"type":"SRK","id":"740970865"},"enrolleeIdentifier":{"type":"SRK","id":"740970884"},"coverageStartDate":"2021-01-01","coverageEndDate":"9999-12-31","timePeriodQualifier":"Calendar","contractOptionStartDate":"2021-01-01","contractOptionEndDate":"2021-12-31"}],"benefitPlanId":"M030000189","coverageType":"MEDICAL","carrierId":"36","legalEntityName":"UnitedHealthcare Insurance Company","networkScheduleIds":[{"networkScheduleId":"CHOICEPLUS_1"}],"gatedProductIndicator":"false","pcpRequiredIndicator":"false","productName":"UHC POS Non-Gated INN/OON","productId":"PM00000048","planTypeCode":"POS","timelyFilingLimitDuration":"365","timelyFilingLimitType":"Days","customerFacingPlanName":"UHC Choice Plus Gold 1500-4","riderOnlyFlag":"false","planTier":[{"tierIdentifier":"1","tierDescription":"Core Benefits","tierTypeCode":"INN","tierTypeDescription":"In Network","gatedPlanIndicator":"false","primaryCoInsurance":"80","accumulatorAmounts":[{"accumLevel":"PLAN","individualDeductibleMaximum":"1500.00","familyDeductibleMaximum":"3000.00","individualOOPMaximum":"6900.00","familyOOPMaximum":"13800.00","individualDeductibleYTD":"0.00","familyDeductibleYTD":"0.00","individualOOPYTD":"0.00","familyOOPYTD":"0.00","familyAccumulationTypeDescriptionDeductible":"Embedded Accum","familyAccumulationTypeDescriptionOOP":"Embedded Accum","deductibleCarryOverIndicator":"false","shareBasePlanAccumulatorIndicatorOOP":"false","shareBasePlanAccumulatorIndicatorDeductible":"false"}],"pcpCopay":["35.00"],"specialistCopay":["70.00"],"urgentCareCopay":["75.00"],"inPatientCopay":["0.00"],"serviceAreaType":"In/Out of Srvc Area","planDelegation":[{"delegationIndicator":"false"}],"primaryOopComposition":{"costShareType":["Deductible","Copay","Coinsurance"]},"networkAccessTypeCode":"2","networkAccessTypeDescription":"Open Access - All Networks","network":[{"id":"network_id1","description":"Core Benefit Network"}]},{"tierIdentifier":"2","tierDescription":"OON Benefits","tierTypeCode":"OON","tierTypeDescription":"Out of Network","gatedPlanIndicator":"false","primaryCoInsurance":"50","accumulatorAmounts":[{"accumLevel":"PLAN","individualDeductibleMaximum":"2550.00","familyDeductibleMaximum":"5100.00","individualOOPMaximum":"15800.00","familyOOPMaximum":"31600.00","individualDeductibleYTD":"0.00","familyDeductibleYTD":"0.00","individualOOPYTD":"0.00","familyOOPYTD":"0.00","familyAccumulationTypeDescriptionDeductible":"Embedded Accum","familyAccumulationTypeDescriptionOOP":"Embedded Accum","deductibleCarryOverIndicator":"false","shareBasePlanAccumulatorIndicatorOOP":"false","shareBasePlanAccumulatorIndicatorDeductible":"false"}],"virtualVisitsCopay":["0.00"],"urgentCareCopay":["0.00"],"inPatientCopay":["0.00"],"serviceAreaType":"In/Out of Srvc Area","planDelegation":[{"delegationIndicator":"false"}],"primaryOopComposition":{"costShareType":["Deductible","Copay","Coinsurance"]}}],"benefitCode":[{"benefitName":"Vision Services","benefitCode":"VISION_SERVICES","benefitDisplay":"Vision Services","benefitTier":["1","2"],"benefitType":"M","primaryOOPOnlyFlag":"false","primaryDeductibleOnlyFlag":"false","visitLimitsApplies":"false","copayApplies":"false","variableCoverage":"true","existsOnRiderPlan":"false","hipaaServiceTypes":[{"serviceTypeCode":"AL","serviceTypeDescription":"Vision (Optometry)"}]},{"benefitName":"Infertility Services - Artificial Insemination","benefitCode":"INFERTILITY_SERVICES_AI","benefitDisplay":"Infertility Services - Artificial Insemination","benefitTier":["2","1"],"benefitType":"M","primaryOOPOnlyFlag":"false","primaryDeductibleOnlyFlag":"false","visitLimitsApplies":"false","copayApplies":"false","variableCoverage":"true","existsOnRiderPlan":"false","hipaaServiceTypes":[{"categoryCode":"01","categoryCodeDescription":"Medical Care","serviceTypeCode":"83","serviceTypeDescription":"Infertility"}]}],"eHBIndicator":"true","externalIds":[{"entityId":"EMBDENT","externalPlanId":"CD4Y"}],"qualityProviderTierRuleID":"","placeOfServiceDifferentialIndicator":"false","fundingArrangementCode":"01","fundingArrangementDescription":"Fully Insured","revenueArrangementCode":"01","revenueArrangementDescription":"FI","carrierBusinessId":"36"}]}}}}';
    
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
    @isTest static void testGetCarrierId() {
        ACETLanguageCTIndicator__c languageCTIndicator = new ACETLanguageCTIndicator__c();
        languageCTIndicator.Benefit_Code__c = 'Allergy_Treatment';
        List<ACETLanguageCTIndicator__c> lstLanguageCTIndicator = new List<ACETLanguageCTIndicator__c>();
        lstLanguageCTIndicator.add(languageCTIndicator);
        ACETLGT_PlanBenefitController.getBenefitLanguageIndicatormdt();
        MockHttpCalloutResponseGenerator.MockHttpResponse oilResponse =  new MockHttpCalloutResponseGenerator.MockHttpResponse(statusCode200, status200, nimbusGetSSBResponse);
        OILResponse.TokenExpired = false; 
        MockHttpCalloutResponseGenerator mockHttpRes = new MockHttpCalloutResponseGenerator(null, oilResponse);
        Test.setMock(HttpCalloutMock.class, mockHttpRes);
        
        Test.startTest();
        String carId = ACETLGT_PharmacyInquiryController.getCarrierId('642322404','1248502','642322404','7/1/2019','12/31/2019','','1275777','','CT','');
        System.debug('test carId : ' + carId);
        Test.stopTest();
    }
    
    @isTest static void testGetISETURL() {
        ACETOrgNameToSwivelEndpointMap__c ISETURLTemplate = ACETTestDataUtility.createORGNameToSwivelData('dev_ISETWrap', '/idp/login?app=0sp21000000CaSt&RelayState=http://iset-dev.uhc.com/HAPortlet/acet_token.jsp?applicationSource=ACET&carrierID=UHCOXFD01&memberID={0}&firstName={1}&lastName={2}&dob={3}&gender={4}');
        insert ISETURLTemplate;
        
        ACETWrapEncryptionKey__c ISETEncryptionKey = new ACETWrapEncryptionKey__c(Name='dev_ISETEncryptionKey', Key__c='tbC2KA36qE1psxs9mozyfOmy7GdrI3I9', Algorithm_Name__c='AES256');
        insert ISETEncryptionKey;
        
        Test.startTest();
        String isetURL = ACETLGT_PharmacyInquiryController.getISETURL('642322404', '1248502', '1111111', 'F', 'Joe', 'Root',
                                                                      '7/1/1978', '5');
        System.debug('ISET URL' + isetURL);
        
        Test.stopTest();
    }
    @isTest
    static void testGetCSRFURL()
    {
        ACETLGT_PharmacyInquiryController.getCSRFURL();
    }
    @isTest
    static void testGetProfileUser()
    {
        ACETLGT_PharmacyInquiryController.getProfileUser();
    }
    
}