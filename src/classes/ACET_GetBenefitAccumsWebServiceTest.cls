@isTest
public class ACET_GetBenefitAccumsWebServiceTest {
    
    static final string apiResponse = '{"getBenefitAccumulatorResponse":{"benefitAccumulator":{"benefitPlan":[{"benefitPlanId":"MR00001412","benefitCode":[{"benefitCodeEffectiveDate":"2021-01-01","benefitCodeExpirationDate":"9999-12-31","benefitCostShare":[{"costShareType":"Benefit Maximum"}]}]}]}}}';
   	static final string dt1 = '2019-12-31';
    static final string ok_done = '(ok-ok,done-done)';
    @testsetup
    static void prepareData(){
        Organization_Properties__c orgProps = Organization_Properties__c.getOrgDefaults();
        orgProps.OrganizationName__c = 'QA';
        Upsert orgProps;
        // Token API data
        WebserviceConfigurations__c tokenAPIWSConfig = ACET_WebserviceCalloutFramework_Test.createTokenWSConfigs('StarGateTokenAPI');
        OrgSpecificConfigurations__c tokenAPIOrgSpecificConfigs = ACET_WebserviceCalloutFramework_Test.createTokenOrgWSConfigs(tokenAPIWSConfig.Id);
        
        // Service API data
        WebserviceConfigurations__c wsConfig = ACET_WebserviceCalloutFramework_Test.createWSConfig('GetBenefitAccumulatorsAPI', tokenAPIWSConfig.Id);
        OrgSpecificConfigurations__c orgSpecificConfigs = ACET_WebserviceCalloutFramework_Test.createOrgWSConfigs(wsConfig.Id);
    }
    @isTest
    static void  testGetAccumulatorBenefits_200() {
        Test.startTest();
        String ResponseJSON = apiResponse;
        MockHttpCalloutResponseGenerator.MockHttpResponse OILResponse = new MockHttpCalloutResponseGenerator.MockHttpResponse(200, 'OK', ResponseJSON );
        OILResponse.TokenExpired = false;
        MockHttpCalloutResponseGenerator MockHttpRes = new MockHttpCalloutResponseGenerator(null, OILResponse);
        Test.setMock(HttpCalloutMock.class, MockHttpRes); 
        ACET_GetBAServiceWrapper bas = new ACET_GetBAServiceWrapper();
        bas.BenefitBundleOptId = '1248502';
			bas.EnrolleeIdentifierType ='1';
            bas.EnrolleeIdentifierId = '2';
            bas.SubscriberIdentifierId = '3'; 
            bas.EffectiveStartDate = dt1;
            bas.EffectiveEndDate = dt1; 
            bas.CoverageType = null; 
            bas.BenefitVerIndicator = null; 
            bas.BenefitCode = ''; 
            bas.accumAsOf = dt1;
            bas.GroupNumber = '1248502';
            bas.SubscriptionServiceResponse = ok_done;
            bas.MembershipDuration = 'ok';
            bas.SubscriptionResponse = ok_done;
        
        ACET_GetBenefitAccumsWebService Accums = new ACET_GetBenefitAccumsWebService();
        Accums.getAccumulatorBenefitsRedesign(bas);
        Accums.getDurationCodeMap();
        //Accums.StartRequest('1248502',null,null,null,dt1,dt1,'','','1248502','','',null,null);
        Test.stopTest();
    }
    @isTest
    static void  testGetAccumulatorBenefits_404() {
        Test.startTest();
        String ResponseJSON = apiResponse;
        MockHttpCalloutResponseGenerator.MockHttpResponse OILResponse = new MockHttpCalloutResponseGenerator.MockHttpResponse(404, 'OK', ResponseJSON );
        OILResponse.TokenExpired = false;
        MockHttpCalloutResponseGenerator MockHttpRes = new MockHttpCalloutResponseGenerator(null, OILResponse);
        Test.setMock(HttpCalloutMock.class, MockHttpRes); 
        ACET_GetBenefitAccumsWebService Accums = new ACET_GetBenefitAccumsWebService();
        ACET_GetBAServiceWrapper bas = new ACET_GetBAServiceWrapper();
        bas.BenefitBundleOptId = '1248502';
			bas.EnrolleeIdentifierType ='1';
            bas.EnrolleeIdentifierId = '2';
            bas.SubscriberIdentifierId = '3'; 
            bas.EffectiveStartDate = dt1;
            bas.EffectiveEndDate = dt1; 
            bas.CoverageType = null; 
            bas.BenefitVerIndicator = null; 
            bas.BenefitCode = ''; 
            bas.accumAsOf = dt1;
            bas.GroupNumber = '1248502';
            bas.SubscriptionServiceResponse = ok_done;
            bas.MembershipDuration = 'ok';
            bas.SubscriptionResponse = ok_done;
        
        
        Accums.getAccumulatorBenefitsRedesign(bas);
        Test.stopTest();
    }
    @isTest
    static void  testGetAccumulatorBenefits_400() {
        Test.startTest();
        String ResponseJSON =apiResponse ;
        MockHttpCalloutResponseGenerator.MockHttpResponse OILResponse = new MockHttpCalloutResponseGenerator.MockHttpResponse(400, 'OK', ResponseJSON );
        OILResponse.TokenExpired = false;
        MockHttpCalloutResponseGenerator MockHttpRes = new MockHttpCalloutResponseGenerator(null, OILResponse);
        Test.setMock(HttpCalloutMock.class, MockHttpRes); 
        ACET_GetBenefitAccumsWebService Accums = new ACET_GetBenefitAccumsWebService();
        ACET_GetBAServiceWrapper bas = new ACET_GetBAServiceWrapper();
        bas.BenefitBundleOptId = '1248502';
			bas.EnrolleeIdentifierType ='1';
            bas.EnrolleeIdentifierId = '2';
            bas.SubscriberIdentifierId = '3'; 
            bas.EffectiveStartDate = dt1;
            bas.EffectiveEndDate = dt1; 
            bas.CoverageType = null; 
            bas.BenefitVerIndicator = null; 
            bas.BenefitCode = ''; 
            bas.accumAsOf = dt1;
            bas.GroupNumber = '1248502';
            bas.SubscriptionServiceResponse = ok_done;
            bas.MembershipDuration = 'ok';
            bas.SubscriptionResponse = ok_done;
        
        
        Accums.getAccumulatorBenefitsRedesign(bas);
        Test.stopTest();
    }
    @isTest
    static void Wrapper(){
        Test.startTest();
        ACET_GetBenefitAccumsResponseWrapper wrpr = new ACET_GetBenefitAccumsResponseWrapper();
        
        List<ACET_GetBenefitAccumsResponseWrapper.BenefitCode> bfcList = new List<ACET_GetBenefitAccumsResponseWrapper.BenefitCode>();
        ACET_GetBenefitAccumsResponseWrapper.BenefitCode bfc = new ACET_GetBenefitAccumsResponseWrapper.BenefitCode();
        bfc.benefitName = 'Infertility Services Basic Prof Comp';
        bfc.benefitCode = 'INFERTILITY_SERVICES_BASIC_PROF_COMP';
        bfc.benefitTier = '6';
        bfc.benefitLevel = '3';
        bfc.benefitVersion = '1';
        bfc.providerDesignation = 'All Other Prov Des';
        bfc.benefitCodeEffectiveDate = '2021-01-01';
        bfc.benefitCodeExpirationDate = '9999-12-31';
        bfc.outOfCountryIndicator = 'false';
        bfc.coveredIndicator = 'false';
        bfc.deductibleAppliesIndicator = 'fals';
        bfc.ageLimitBeginningRangeValue = '0';
        bfc.ageLimitBeginningRangeUnit = 'D';
        bfc.ageLimitEndingRangeValue = '999';
        bfc.ageLimitEndingRangeUnit = 'Y';
        bfc.occurrenceLimitBeginningRangeValue = 'All Genders';
        bfc.occurrenceLimitEndingRangeValue = '0';
        bfc.occurrenceLimitForEveryValue = '0';
        bfc.consecutiveDaysLimitBeginningRangeValue = '0';
        bfc.consecutiveDaysLimitEndingRangeValue = '0';
        bfc.maxConsecutiveDays = '0';
        bfc.maxCopayments = '0';
        bfc.maxCopaymentForEveryValue = '0';
        bfc.dollarLimitPerEveryValue = '0';
        bfc.rxRefills = '0';
        bfc.rxPreventativeIndicator  = 'false';
        bfc.qualityProviderIndicator = 'false';
        bfc.placeOfServiceDifferentialIndicator = 'false';
        bfcList.add(bfc);
        
        List<ACET_GetBenefitAccumsResponseWrapper.BenefitPlan> bpList = new List<ACET_GetBenefitAccumsResponseWrapper.BenefitPlan>();
        ACET_GetBenefitAccumsResponseWrapper.BenefitPlan bp = new ACET_GetBenefitAccumsResponseWrapper.BenefitPlan();
        bp.benefitPlanId = 'M000001412';
        bp.benefitCode = bfcList;
        bpList.add(bp);
        
        ACET_GetBenefitAccumsResponseWrapper.BenefitAccumulator ba = new ACET_GetBenefitAccumsResponseWrapper.BenefitAccumulator();
        ba.benefitPlan = bpList;
        
        ACET_GetBenefitAccumsResponseWrapper.GetBenefitAccumulatorResponse gbar = new ACET_GetBenefitAccumsResponseWrapper.GetBenefitAccumulatorResponse();
        gbar.benefitAccumulator = ba;
        
        wrpr.getBenefitAccumulatorResponse = gbar;
        
        //String ResponseJSON = '{"getBenefitAccumulatorResponse":{"benefitAccumulator":{"benefitPlan":[{"benefitPlanId":"MR00001412","benefitCode":[{"benefitCodeEffectiveDate":"2021-01-01","benefitCodeExpirationDate":"9999-12-31","benefitCostShare":[{"costShareType":"Benefit Maximum"}]}]}]}}}';
        //ACETLGT_GetBenefitAccumsResponseWrapper json = (ACETLGT_GetBenefitAccumsResponseWrapper) System.JSON.deserialize(ResponseJSON, ACETLGT_GetBenefitAccumsResponseWrapper.class);
        Test.stopTest();
    }
}