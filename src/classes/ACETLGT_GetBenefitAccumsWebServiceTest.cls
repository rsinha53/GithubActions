@isTest
public class ACETLGT_GetBenefitAccumsWebServiceTest {
    
    static final string apiResponse = '{"getBenefitAccumulatorResponse":{"benefitAccumulator":{"benefitPlan":[{"benefitPlanId":"MR00001412","benefitCode":[{"benefitCodeEffectiveDate":"2021-01-01","benefitCodeExpirationDate":"9999-12-31","benefitCostShare":[{"costShareType":"Benefit Maximum"}]}]}]}}}';
    static final string mr12 = 'MR12-=""true';
    static final string dt1 = '2019-12-31';
    static final string mr_12 = 'MR12=""true';
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
        ACETLGT_GetBAServiceWrapper getBAServiceWrapper = new ACETLGT_GetBAServiceWrapper();
        ACETLGT_GetBenefitAccumsWebService lgtAccums = new ACETLGT_GetBenefitAccumsWebService();
        getBAServiceWrapper.enrollerSRK = '1';
        getBAServiceWrapper.surrogateKey = '2';
        getBAServiceWrapper.EffectiveStartDate = dt1;
        getBAServiceWrapper.EffectiveEndDate = dt1;
        getBAServiceWrapper.BenefitCode = 'MR12';
        getBAServiceWrapper.accumAsOf = dt1;
        getBAServiceWrapper.GroupNumber = '1248502';
        getBAServiceWrapper.SubscriptionServiceResponse = ok_done;
        getBAServiceWrapper.MembershipDuration = 'ok';
        getBAServiceWrapper.SubscriptionResponse = ok_done;
        //getBAServiceWrapper.benefitRiderList = new List<String>{mr12,mr_12};
        getBAServiceWrapper.BenefitBundleOptId = '1248502';
        
        lgtAccums.getAccumulatorBenefits(getBAServiceWrapper);
        lgtAccums.getDurationCodeMap();
        lgtAccums.ChangeDateFormatForOIL('2019/12/31');
        Test.stopTest();
    }
    @isTest
    static void  testGetAccumulatorBenefits_404() {
        Test.startTest();
        String ResponseJSON = apiResponse;
        MockHttpCalloutResponseGenerator.MockHttpResponse OILResponse = new MockHttpCalloutResponseGenerator.MockHttpResponse(404, 'OK', ResponseJSON);
        OILResponse.TokenExpired = false;
        MockHttpCalloutResponseGenerator MockHttpRes = new MockHttpCalloutResponseGenerator(null, OILResponse);
        Test.setMock(HttpCalloutMock.class, MockHttpRes); 
        ACETLGT_GetBAServiceWrapper getBAServiceWrapper = new ACETLGT_GetBAServiceWrapper();
        
        getBAServiceWrapper.enrollerSRK = '1';
        getBAServiceWrapper.surrogateKey = '2';
        getBAServiceWrapper.EffectiveStartDate = dt1;
        getBAServiceWrapper.EffectiveEndDate = dt1;
        getBAServiceWrapper.BenefitCode = 'MR12';
        getBAServiceWrapper.accumAsOf = dt1;
        getBAServiceWrapper.GroupNumber = '1248502';
        getBAServiceWrapper.SubscriptionServiceResponse = ok_done;
        getBAServiceWrapper.MembershipDuration = 'ok';
        getBAServiceWrapper.SubscriptionResponse = ok_done;
       // getBAServiceWrapper.benefitRiderList = new List<String>{mr12,mr_12};
        getBAServiceWrapper.BenefitBundleOptId = '1248502';
        ACETLGT_GetBenefitAccumsWebService lgtAccums = new ACETLGT_GetBenefitAccumsWebService();
        lgtAccums.getAccumulatorBenefits(getBAServiceWrapper);
        Test.stopTest();
    }
    @isTest
    static void  testGetAccumulatorBenefits_400() {
        Test.startTest();
        String ResponseJSON = apiResponse;
        MockHttpCalloutResponseGenerator.MockHttpResponse OILResponse = new MockHttpCalloutResponseGenerator.MockHttpResponse(400, 'OK', ResponseJSON);
        OILResponse.TokenExpired = false;
        MockHttpCalloutResponseGenerator MockHttpRes = new MockHttpCalloutResponseGenerator(null, OILResponse);
        Test.setMock(HttpCalloutMock.class, MockHttpRes); 
        ACETLGT_GetBAServiceWrapper getBAServiceWrapper = new ACETLGT_GetBAServiceWrapper();
        
        getBAServiceWrapper.enrollerSRK = '1';
        getBAServiceWrapper.surrogateKey = '2';
        getBAServiceWrapper.EffectiveStartDate = dt1;
        getBAServiceWrapper.EffectiveEndDate = dt1;
        getBAServiceWrapper.BenefitCode = 'MR12';
        getBAServiceWrapper.accumAsOf = dt1;
        getBAServiceWrapper.GroupNumber = '1248502';
        getBAServiceWrapper.SubscriptionServiceResponse = ok_done;
        getBAServiceWrapper.MembershipDuration = 'ok';
        getBAServiceWrapper.SubscriptionResponse = ok_done;
       // getBAServiceWrapper.benefitRiderList = new List<String>{mr12,mr_12};
        getBAServiceWrapper.BenefitBundleOptId = '1248502';
        
        ACETLGT_GetBenefitAccumsWebService lgtAccums = new ACETLGT_GetBenefitAccumsWebService();
        lgtAccums.getAccumulatorBenefits(getBAServiceWrapper);
        Test.stopTest();
    }
    @isTest
    static void Wrapper(){
        Test.startTest();
        ACETLGT_GetBenefitAccumsResponseWrapper wrpr = new ACETLGT_GetBenefitAccumsResponseWrapper();
        
        List<ACETLGT_GetBenefitAccumsResponseWrapper.BenefitCode> bfcList = new List<ACETLGT_GetBenefitAccumsResponseWrapper.BenefitCode>();
        ACETLGT_GetBenefitAccumsResponseWrapper.BenefitCode bfc = new ACETLGT_GetBenefitAccumsResponseWrapper.BenefitCode();
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
        
        List<ACETLGT_GetBenefitAccumsResponseWrapper.BenefitPlan> bpList = new List<ACETLGT_GetBenefitAccumsResponseWrapper.BenefitPlan>();
        ACETLGT_GetBenefitAccumsResponseWrapper.BenefitPlan bp = new ACETLGT_GetBenefitAccumsResponseWrapper.BenefitPlan();
        bp.benefitPlanId = 'M000001412';
        bp.benefitCode = bfcList;
        bpList.add(bp);
        
        ACETLGT_GetBenefitAccumsResponseWrapper.BenefitAccumulator ba = new ACETLGT_GetBenefitAccumsResponseWrapper.BenefitAccumulator();
        ba.benefitPlan = bpList;
        
        ACETLGT_GetBenefitAccumsResponseWrapper.GetBenefitAccumulatorResponse gbar = new ACETLGT_GetBenefitAccumsResponseWrapper.GetBenefitAccumulatorResponse();
        gbar.benefitAccumulator = ba;
        
        wrpr.getBenefitAccumulatorResponse = gbar;
        
        Test.stopTest();
    }
    @isTest
    static  void aCETLGT_GetBenefitAccumsResponseWrapper_1(){ 
        String json = apiResponse; 
        RestRequest req = new RestRequest();
        req.requestBody =Blob.valueof(json);
        RestContext.request = req;
    }
   /* @isTest
    static  void aCETLGT_GetBenefitAccumsResponseWrapper_2(){ 
        String ResponseJSON = '{"getBenefitAccumulatorResponse":{"errors":[{}],"benefitAccumulator":{"benefitPlan":[{"benefitPlanId":"MR00001412","benefitCode":[{"benefitName":"Infertility Services Basic Prof Comp","benefitCode":"INFERTILITY_SERVICES_BASIC_PROF_COMP","benefitTier":"6","benefitLevel":"3","benefitVersion":"1","providerDesignation":"All Other Prov Des","benefitCodeEffectiveDate":"2021-01-01","benefitCodeExpirationDate":"9999-12-31","placeOfServices":[{"placeOfService":"Office"}],"outOfCountryIndicator":"false","coveredIndicator":"false","deductibleAppliesIndicator":"false","ageLimitBeginningRangeValue":"0","ageLimitBeginningRangeUnit":"D","ageLimitEndingRangeValue":"999","ageLimitEndingRangeUnit":"Y","occurrenceLimitBeginningRangeValue":"All Genders","occurrenceLimitEndingRangeValue":"0","occurrenceLimitForEveryValue":"0","consecutiveDaysLimitBeginningRangeValue":"0","consecutiveDaysLimitEndingRangeValue":"0","maxConsecutiveDays":"0","maxCopayments":"0","maxCopaymentForEveryValue":"0","dollarLimitPerEveryValue":"0","rxRefills":"0","rxPreventativeIndicator":"false","qualityProviderIndicator":"false","placeOfServiceDifferentialIndicator":"false","BenefitOverride":[{"benefitOverrideIndicator":"false"}],"benefitCostShare":[{"coverageLevel":"Individual","costShareType":"Benefit Maximum","benefitMaximumValue":"0.00","benefitMaximumUnit":"Dollar","primaryCostShareIndicator":"","benefitYTDValue":"","benefitRemainingValue":"","costShareId":"","limitAccumulatorBenefitPeriodDurationCount":"","limitAccumulatorBenefitPeriodDurationCode":""}]}]}]}}}';
        ACETLGT_GetBenefitAccumsResponseWrapper json = (ACETLGT_GetBenefitAccumsResponseWrapper) System.JSON.deserialize(ResponseJSON, ACETLGT_GetBenefitAccumsResponseWrapper.class);
    }*/
}