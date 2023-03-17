@isTest
public class ACETPlanBenefitDetailRedesignCtrlTest{
    public static final Integer statusCode200 = 200;
    public static final String status200 = 'OK';
    public static final String nimbusGetSSBResponse = '{"getSubscriptionServiceBenefitResponse":{"serviceBenefit":{"memberGroup":{"groupNumber":"1013629","groupName":"E2E_Rivervally_group 20210702035146"},"memberGroupContractPlanOption":{"benefitBundleOptionId":"11958418","planMetallicLevel":"Gold","oonPricingType":"CMS Based","mnrpPercentile":"110.00","ucrPercentile":"80.00","fallThruPercent":"20.00","bookOfBusinessTypeCode":"UH","bookOfBusinessTypeDescription":"UnitedHealthcare Insurance Company","lineOfBusinessId":"2","lineOfBusinessName":"Small Business","lineOfBusinessDescription":"Small Business  (UHC definition = 2 to 50, and Sole Prop)","benefitPlan":[{"membership":[{"subscriberIdentifier":{"type":"SRK","id":"740970865"},"enrolleeIdentifier":{"type":"SRK","id":"740970884"},"coverageStartDate":"2021-01-01","coverageEndDate":"9999-12-31","timePeriodQualifier":"Calendar","contractOptionStartDate":"2021-01-01","contractOptionEndDate":"2021-12-31"}],"benefitPlanId":"M030000189","coverageType":"MEDICAL","carrierId":"36","legalEntityName":"UnitedHealthcare Insurance Company","networkScheduleIds":[{"networkScheduleId":"CHOICEPLUS_1"}],"gatedProductIndicator":"false","pcpRequiredIndicator":"false","productName":"UHC POS Non-Gated INN/OON","productId":"PM00000048","planTypeCode":"POS","timelyFilingLimitDuration":"365","timelyFilingLimitType":"Days","customerFacingPlanName":"UHC Choice Plus Gold 1500-4","riderOnlyFlag":"false","planTier":[{"tierIdentifier":"1","tierDescription":"Core Benefits","tierTypeCode":"INN","tierTypeDescription":"In Network","gatedPlanIndicator":"false","primaryCoInsurance":"80","accumulatorAmounts":[{"accumLevel":"PLAN","individualDeductibleMaximum":"1500.00","familyDeductibleMaximum":"3000.00","individualOOPMaximum":"6900.00","familyOOPMaximum":"13800.00","individualDeductibleYTD":"0.00","familyDeductibleYTD":"0.00","individualOOPYTD":"0.00","familyOOPYTD":"0.00","familyAccumulationTypeDescriptionDeductible":"Embedded Accum","familyAccumulationTypeDescriptionOOP":"Embedded Accum","deductibleCarryOverIndicator":"false","shareBasePlanAccumulatorIndicatorOOP":"false","shareBasePlanAccumulatorIndicatorDeductible":"false"}],"pcpCopay":["35.00"],"specialistCopay":["70.00"],"urgentCareCopay":["75.00"],"inPatientCopay":["0.00"],"serviceAreaType":"In/Out of Srvc Area","planDelegation":[{"delegationIndicator":"false"}],"primaryOopComposition":{"costShareType":["Deductible","Copay","Coinsurance"]},"networkAccessTypeCode":"2","networkAccessTypeDescription":"Open Access - All Networks","network":[{"id":"network_id1","description":"Core Benefit Network"}]},{"tierIdentifier":"2","tierDescription":"OON Benefits","tierTypeCode":"OON","tierTypeDescription":"Out of Network","gatedPlanIndicator":"false","primaryCoInsurance":"50","accumulatorAmounts":[{"accumLevel":"PLAN","individualDeductibleMaximum":"2550.00","familyDeductibleMaximum":"5100.00","individualOOPMaximum":"15800.00","familyOOPMaximum":"31600.00","individualDeductibleYTD":"0.00","familyDeductibleYTD":"0.00","individualOOPYTD":"0.00","familyOOPYTD":"0.00","familyAccumulationTypeDescriptionDeductible":"Embedded Accum","familyAccumulationTypeDescriptionOOP":"Embedded Accum","deductibleCarryOverIndicator":"false","shareBasePlanAccumulatorIndicatorOOP":"false","shareBasePlanAccumulatorIndicatorDeductible":"false"}],"virtualVisitsCopay":["0.00"],"urgentCareCopay":["0.00"],"inPatientCopay":["0.00"],"serviceAreaType":"In/Out of Srvc Area","planDelegation":[{"delegationIndicator":"false"}],"primaryOopComposition":{"costShareType":["Deductible","Copay","Coinsurance"]}}],"benefitCode":[{"benefitName":"Vision Services","benefitCode":"VISION_SERVICES","benefitDisplay":"Vision Services","benefitTier":["1","2"],"benefitType":"M","primaryOOPOnlyFlag":"false","primaryDeductibleOnlyFlag":"false","visitLimitsApplies":"false","copayApplies":"false","variableCoverage":"true","existsOnRiderPlan":"false","hipaaServiceTypes":[{"serviceTypeCode":"AL","serviceTypeDescription":"Vision (Optometry)"}]},{"benefitName":"Infertility Services - Artificial Insemination","benefitCode":"INFERTILITY_SERVICES_AI","benefitDisplay":"Infertility Services - Artificial Insemination","benefitTier":["2","1"],"benefitType":"M","primaryOOPOnlyFlag":"false","primaryDeductibleOnlyFlag":"false","visitLimitsApplies":"false","copayApplies":"false","variableCoverage":"true","existsOnRiderPlan":"false","hipaaServiceTypes":[{"categoryCode":"01","categoryCodeDescription":"Medical Care","serviceTypeCode":"83","serviceTypeDescription":"Infertility"}]}],"eHBIndicator":"true","externalIds":[{"entityId":"EMBDENT","externalPlanId":"CD4Y"}],"qualityProviderTierRuleID":"","placeOfServiceDifferentialIndicator":"false","fundingArrangementCode":"01","fundingArrangementDescription":"Fully Insured","revenueArrangementCode":"01","revenueArrangementDescription":"FI","carrierBusinessId":"36"}]}}}}';
	public static final String nimbusGetSSBBadResponse = '{"getSubscriptionServiceBenefitResponse":{"transactionId":"fdd36afa-a4db-42ec-89cb-d4450fd6909e","errors":[{"code":400,"name":"InvalidRequest","severity":"FAULT","origin":"cirrus","description":"getSubscriptionServiceBenefitRequest : Validation Failed for Member Search required fields missing","uri":"/api/nebula/v1.0/benefits/read"}]}}';
    public static final String bundleID = '11958418';
    public static final String srkID = '740970884';
    public static final String subSRKID ='740970865';
    public static final String effectiveDate = '2021-01-01';
    public static final String endDate = '2021-12-31';
    public static final String coverageType ='';
    public static final String groupNumber = '1013629';
    public static final String accumsDate = '';
    public static final String accumAsOf = '';
    public static final String memberId = '13690586900';
    public static final String parStatusType='';
    public static final String customerPurchaseId='';
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
static testMethod void ACETPlanBenefitDetailRedesignCtrlTestMethod1() {
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
        Test.startTest();
            
            MockHttpCalloutResponseGenerator.MockHttpResponse oilResponse = new MockHttpCalloutResponseGenerator.MockHttpResponse(statusCode200, status200, ACETTestDataUtility.getSubscriptionBenefitResponse());
            OILResponse.TokenExpired = false;
    
            MockHttpCalloutResponseGenerator mockHttpRes = new MockHttpCalloutResponseGenerator(null, oilResponse);
            Test.setMock(HttpCalloutMock.class, mockHttpRes);
            
            String jsonResponse = ACETTestDataUtility.getSubscriptionBenefitResponse();
    		System.debug(jsonResponse);
    		
    	    ACETNimbusGetSSBAPI webserviceCall = new ACETNimbusGetSSBAPI();
            webserviceCall.getSubscriptionBenefitSearch( bundleID, memberId, srkID, subSRKID, effectiveDate, endDate, coverageType, groupNumber, parStatusType, accumAsOf, customerPurchaseId);
            webserviceCall.getTierCode();
            webserviceCall.getValidString('test');
            webserviceCall.getCoverageTypeDescripMap();
            webserviceCall.getDurationCodeMap();
            webserviceCall.ChangeDateFormatForOIL('10/02/2017');
            webserviceCall.getPlanTypeCode();
            webserviceCall.getGatedPCPCode();
            webserviceCall.ProcessResponse('Test','CT');
            PageReference ACETPlanBenefitDetailRedesign= Page.ACETPlanBenefitDetailRedesign;
            ACETPlanBenefitDetailRedesign.getParameters().put('cvrlevel', 'FAM');
            Test.setCurrentPage(ACETPlanBenefitDetailRedesign); 
            ACETPlanBenefitDetailRedesignControllerr  redesignctrl = new ACETPlanBenefitDetailRedesignControllerr();
            string str='IND';
            List<String> lstr= new List<String>();
            redesignctrl.networklist = lstr;
            redesignctrl.serializeWrapper='test';
            redesignctrl.ACETSubscriptionServices='GET';
            redesignctrl.dateSearchresults();
            redesignctrl.CallWSOnPageLoad_New();
            redesignctrl.CallWSOnPageLoadCallback();
            redesignctrl.makePlanBenefitLanguageCallout();
            redesignctrl.makePlanBenefitAccCallout();
            redesignctrl.ChangeDateFormatForOIL('10/02/2017');
            redesignctrl.GroupID= '1234';
            ACETPlanBenefitDetailRedesignControllerr.Accumulator InnAcc = new ACETPlanBenefitDetailRedesignControllerr.Accumulator();
            InnAcc.Section='test';
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
         InnAcc.compareTo(InnAcc);
    
    	 redesignctrl.policies = null;
    
    	 ACETPlanBenefitDetailRedesignControllerr.PolicyOverviewWrapper polOverview = new ACETPlanBenefitDetailRedesignControllerr.PolicyOverviewWrapper();
    	 System.debug(polOverview.isSelected);
    	 System.debug(polOverview.PlanId);
    	 System.debug(polOverview.PlanName);
    	 System.debug(polOverview.productName);
    	 System.debug(polOverview.ProductId);
    	 System.debug(polOverview.PlanType);
    	 System.debug(polOverview.FundingArrangement);
    	 System.debug(polOverview.Accumulator);
    	 System.debug(polOverview.Gated);
    	 System.debug(polOverview.PCP);
    	 System.debug(polOverview.GoverningStatePolicy);
    	 System.debug(polOverview.Network);
    	 System.debug(polOverview.Resolved);
    	
         Test.stopTest();
  }   
  
  static testMethod void PlanDetailContiWebServiceMethod() {
        Map<String, String> mapISLWSConfigs = new Map<String, String>(); 
        mapISLWSConfigs.put('ISLConAccessToken', 'e9b3f2b1-8863-49ec-9ff8-40da25961ef5');
        mapISLWSConfigs.put('OILHttpHeaderAccept', 'application/json;charset=UTF-8');
        mapISLWSConfigs.put('OILHttpHeaderActor', 'ACET');
        mapISLWSConfigs.put('OILHttpHeaderScope', 'read');
        mapISLWSConfigs.put('dev_ISLOAuthEndpoint', 'https://api-stg.optum.com:8443');
        mapISLWSConfigs.put('dev_getSubscriptionBenefitSearch', '/api/bravo/eisl/benefits/servicebenefit/v2.0/read');
        mapISLWSConfigs.put('OILTimeout', '3000');
        List<ISL_Webservice_Config__c> lstISLWSConfigs = ACETTestDataUtility.CreateISLWebserviceConfigurations(mapISLWSConfigs);
        insert lstISLWSConfigs;

        String ResponseJSON = ACETTestDataUtility.getSubscriptionBenefitJSON();  
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
        
        ACETHighlightsPanelAdditionalInfo AdditionalInfo = new ACETHighlightsPanelAdditionalInfo();
        AdditionalInfo.PolicyNumber = 'TestPolicyNumber';
          
        Test.startTest();
            
        PageReference ACETPlanBenefitDetailRedesign= Page.ACETPlanBenefitDetailRedesign;
        ACETPlanBenefitDetailRedesign.getParameters().put('interactionId', oInteraction.Id);
        ACETPlanBenefitDetailRedesign.getParameters().put('bundleOptionId', '1018999');
        ACETPlanBenefitDetailRedesign.getParameters().put('cvrlevel', 'EMP');
        ACETPlanBenefitDetailRedesign.getParameters().put('Net', 'test');
        Test.setCurrentPage(ACETPlanBenefitDetailRedesign);
        
        ACETPlanBenefitDetailRedesignControllerr  PlanDetailContr = new ACETPlanBenefitDetailRedesignControllerr(); 
        PlanDetailContr.ChangeDateFormatForOIL('2/02/2017');
        Continuation conti = (Continuation)PlanDetailContr.CallWSOnPageLoad();     
        Map<String, HttpRequest> requests = conti.getRequests();
   //     system.assertEquals(2, requests.size());
        
        HttpResponse response;
        HttpRequest request;
        
        for(String RequestLabel: requests.keyset()){
            request = requests.get(RequestLabel);
            response = new HttpResponse();
            response.setStatusCode(200);
            response.setStatus('OK');
            if (request.getEndpoint().contains('/api/bravo/eisl/benefits/servicebenefit/v2.0/read')) {
                response.setBody(nimbusGetSSBResponse);
            }      
            else {
                response.setBody(nimbusGetSSBBadResponse);
            }     
            Test.setContinuationResponse(RequestLabel, response); 
        }
        Object result = Test.invokeContinuationMethod(PlanDetailContr, conti); 
        Test.stopTest();
    }    
}