@isTest
public class ACETGroupPlanDetailCtrlRedesignTest {
    public static String nimbusGetSSBResponse = '{"getSubscriptionServiceBenefitResponse":{"serviceBenefit":{"memberGroup":{"groupNumber":1048476,"groupName":"MILESTONES BEHAVIORAL SERVICES INC.LgAug19"},"memberGroupContractPlanOption":{"benefitBundleOptionId":"10740060","oonPricingType":"UCR","ucrPercentile":"90.00","fallThruPercent":"100.00","benefitPlan":[{"benefitPlanId":"M000000816","coverageType":"MEDICAL","carrierId":"6","legalEntityName":"Oxford Health Plans (CT), Inc.","networkScheduleIds":[{"networkScheduleId":"LIBERTY"}],"benefitServiceArea":"OXFORD_TRI_STATE","gatedProductIndicator":"true","pcpRequiredIndicator":"true","productName":"OHP Gated INN Only","productId":"PM00000001","planTypeCode":"HMO","timelyFilingLimitDuration":"999","timelyFilingLimitType":"Days","customerFacingPlanName":"CTLG LIBERTY HMO 100%/$50 ER200/OP&IPD&C","riderOnlyFlag":"false","planTier":[{"tierIdentifier":"1","tierDescription":"Virtual Visits","tierTypeCode":"INN","tierTypeDescription":"In Network","gatedPlanIndicator":"true","primaryCoInsurance":"100","accumulatorAmounts":[{"accumLevel":"PLAN","individualDeductibleMaximum":"3000.00","familyDeductibleMaximum":"6000.00","individualOOPMaximum":"6000.00","familyOOPMaximum":"12000.00","familyAccumulationTypeDescriptionDeductible":"Embedded Accum","familyAccumulationTypeDescriptionOOP":"Embedded Accum","deductibleCarryOverIndicator":"false","shareBasePlanAccumulatorIndicatorOOP":"false","shareBasePlanAccumulatorIndicatorDeductible":"false"}],"virtualVisitsCopay":["0.00"],"serviceAreaType":"In/Out of Srvc Area","networkTier":{"id":"1","description":"Virtual Visits"},"network":[{"id":"1088476","description":"Real Appeal"},{"id":"1038478","description":"Virtual Visit - Choice Plus"},{"id":"1038477","description":"Virtual Visit National Network"}],"planDelegation":[{"delegationIndicator":"true","delegationIdentifier":"OHP_DEL_SET_WO_ORTHONET","delegationName":"Oxford Optum Phy Health Chiro Delegation Schedule"}],"primaryOopComposition":{"costShareType":["Deductible","Copay","Coinsurance"]},"networkAccessTypeCode":"3","networkAccessTypeDescription":"Gated","tierLevelServiceProvider":[{"providerAssignmentTypeCode":"PCP","providerAssignmentTypeDescription":"PCP","providerSelectionOptionalIndicator":"false","referralConditionTypeCode":"2","referralConditionTypeDescription":"Bypass Covering Same","providerAssignmentLevel":"01","providerAssignmentLevelDesc":"Individual Provider"}]},{"tierIdentifier":"2","tierDescription":"Insulin Pumps Medtronic","tierTypeCode":"INN","tierTypeDescription":"In Network","gatedPlanIndicator":"true","primaryCoInsurance":"100","accumulatorAmounts":[{"accumLevel":"PLAN","individualDeductibleMaximum":"3000.00","familyDeductibleMaximum":"6000.00","individualOOPMaximum":"6000.00","familyOOPMaximum":"12000.00","familyAccumulationTypeDescriptionDeductible":"Embedded Accum","familyAccumulationTypeDescriptionOOP":"Embedded Accum","deductibleCarryOverIndicator":"false","shareBasePlanAccumulatorIndicatorOOP":"false","shareBasePlanAccumulatorIndicatorDeductible":"false"}],"serviceAreaType":"In/Out of Srvc Area","networkTier":{"id":"2","description":"Medtronic"},"network":[{"id":"1048477","description":"Medtronic Insulin Pump"}],"planDelegation":[{"delegationIndicator":"true","delegationIdentifier":"OHP_DEL_SET_WO_ORTHONET","delegationName":"Oxford Optum Phy Health Chiro Delegation Schedule"}],"primaryOopComposition":{"costShareType":["Deductible","Copay","Coinsurance"]},"networkAccessTypeCode":"3","networkAccessTypeDescription":"Gated","tierLevelServiceProvider":[{"providerAssignmentTypeCode":"PCP","providerAssignmentTypeDescription":"PCP","providerSelectionOptionalIndicator":"false","referralConditionTypeCode":"2","referralConditionTypeDescription":"Bypass Covering Same","providerAssignmentLevel":"01","providerAssignmentLevelDesc":"Individual Provider"}]},{"tierIdentifier":"3","tierDescription":"Insulin Pumps Byram","tierTypeCode":"INN","tierTypeDescription":"In Network","gatedPlanIndicator":"true","primaryCoInsurance":"100","accumulatorAmounts":[{"accumLevel":"PLAN","individualDeductibleMaximum":"3000.00","familyDeductibleMaximum":"6000.00","individualOOPMaximum":"6000.00","familyOOPMaximum":"12000.00","familyAccumulationTypeDescriptionDeductible":"Embedded Accum","familyAccumulationTypeDescriptionOOP":"Embedded Accum","deductibleCarryOverIndicator":"false","shareBasePlanAccumulatorIndicatorOOP":"false","shareBasePlanAccumulatorIndicatorDeductible":"false"}],"serviceAreaType":"In/Out of Srvc Area","networkTier":{"id":"3","description":"Byram"},"network":[{"id":"1048476","description":"Byram Insulin Pump"}],"planDelegation":[{"delegationIndicator":"true","delegationIdentifier":"OHP_DEL_SET_WO_ORTHONET","delegationName":"Oxford Optum Phy Health Chiro Delegation Schedule"}],"primaryOopComposition":{"costShareType":["Deductible","Copay","Coinsurance"]},"networkAccessTypeCode":"3","networkAccessTypeDescription":"Gated","tierLevelServiceProvider":[{"providerAssignmentTypeCode":"PCP","providerAssignmentTypeDescription":"PCP","providerSelectionOptionalIndicator":"false","referralConditionTypeCode":"2","referralConditionTypeDescription":"Bypass Covering Same","providerAssignmentLevel":"01","providerAssignmentLevelDesc":"Individual Provider"}]},{"tierIdentifier":"4","tierDescription":"Autism Benefits","tierTypeCode":"INN","tierTypeDescription":"In Network","gatedPlanIndicator":"true","primaryCoInsurance":"100","accumulatorAmounts":[{"accumLevel":"PLAN","individualDeductibleMaximum":"3000.00","familyDeductibleMaximum":"6000.00","individualOOPMaximum":"6000.00","familyOOPMaximum":"12000.00","familyAccumulationTypeDescriptionDeductible":"Embedded Accum","familyAccumulationTypeDescriptionOOP":"Embedded Accum","deductibleCarryOverIndicator":"false","shareBasePlanAccumulatorIndicatorOOP":"false","shareBasePlanAccumulatorIndicatorDeductible":"false"}],"serviceAreaType":"In/Out of Srvc Area","networkTier":{"id":"4","description":"ABA Autism Spec"},"network":[{"id":"1028500","description":"OHP UBH Autism Spec"}],"planDelegation":[{"delegationIndicator":"true","delegationIdentifier":"OHP_DEL_SET_WO_ORTHONET","delegationName":"Oxford Optum Phy Health Chiro Delegation Schedule"}],"primaryOopComposition":{"costShareType":["Deductible","Copay","Coinsurance"]},"networkAccessTypeCode":"3","networkAccessTypeDescription":"Gated","tierLevelServiceProvider":[{"providerAssignmentTypeCode":"PCP","providerAssignmentTypeDescription":"PCP","providerSelectionOptionalIndicator":"false","referralConditionTypeCode":"2","referralConditionTypeDescription":"Bypass Covering Same","providerAssignmentLevel":"01","providerAssignmentLevelDesc":"Individual Provider"}]},{"tierIdentifier":"5","tierDescription":"Core Benefits from Liberty","tierTypeCode":"INN","tierTypeDescription":"In Network","gatedPlanIndicator":"true","primaryCoInsurance":"100","accumulatorAmounts":[{"accumLevel":"PLAN","individualDeductibleMaximum":"3000.00","familyDeductibleMaximum":"6000.00","individualOOPMaximum":"6000.00","familyOOPMaximum":"12000.00","familyAccumulationTypeDescriptionDeductible":"Embedded Accum","familyAccumulationTypeDescriptionOOP":"Embedded Accum","deductibleCarryOverIndicator":"false","shareBasePlanAccumulatorIndicatorOOP":"false","shareBasePlanAccumulatorIndicatorDeductible":"false"}],"erCopay":["200.00"],"pcpCopay":["0.00"],"urgentCareCopay":["50.00"],"inPatientCopay":["0.00"],"serviceAreaType":"In/Out of Srvc Area","networkTier":{"id":"5","description":"All Other In Network Providers"},"network":[{"id":"1028498","description":"WRAPF - Pay Choice rate (same as Freedom)"},{"id":"1028497","description":"WRAPC - Pay Choice Plus rate (Different than Freedom)"},{"id":"1018476","description":"Optum Health Behavioral Services (OHBS)"},{"id":"6","description":"National Ancillary Choice Plus"},{"id":"1038476","description":"National Ancillary National Network"},{"id":"9","description":"Liberty Network"}],"planDelegation":[{"delegationIndicator":"true","delegationIdentifier":"OHP_DEL_SET_WO_ORTHONET","delegationName":"Oxford Optum Phy Health Chiro Delegation Schedule"}],"primaryOopComposition":{"costShareType":["Deductible","Copay","Coinsurance"]},"networkAccessTypeCode":"3","networkAccessTypeDescription":"Gated","tierLevelServiceProvider":[{"providerAssignmentTypeCode":"PCP","providerAssignmentTypeDescription":"PCP","providerSelectionOptionalIndicator":"false","referralConditionTypeCode":"2","referralConditionTypeDescription":"Bypass Covering Same","providerAssignmentLevel":"01","providerAssignmentLevelDesc":"Individual Provider"}]},{"tierIdentifier":"6","tierDescription":"Physical Health Benefits","tierTypeCode":"INN","tierTypeDescription":"In Network","gatedPlanIndicator":"true","primaryCoInsurance":"100","accumulatorAmounts":[{"accumLevel":"PLAN","individualDeductibleMaximum":"3000.00","familyDeductibleMaximum":"6000.00","individualOOPMaximum":"6000.00","familyOOPMaximum":"12000.00","familyAccumulationTypeDescriptionDeductible":"Embedded Accum","familyAccumulationTypeDescriptionOOP":"Embedded Accum","deductibleCarryOverIndicator":"false","shareBasePlanAccumulatorIndicatorOOP":"false","shareBasePlanAccumulatorIndicatorDeductible":"false"}],"serviceAreaType":"In/Out of Srvc Area","networkTier":{"id":"6","description":"Optum Physical Health"},"network":[{"id":"1","description":"OHPH Chiro"}],"planDelegation":[{"delegationIndicator":"true","delegationIdentifier":"OHP_DEL_SET_WO_ORTHONET","delegationName":"Oxford Optum Phy Health Chiro Delegation Schedule"}],"primaryOopComposition":{"costShareType":["Deductible","Copay","Coinsurance"]},"networkAccessTypeCode":"3","networkAccessTypeDescription":"Gated","tierLevelServiceProvider":[{"providerAssignmentTypeCode":"PCP","providerAssignmentTypeDescription":"PCP","providerSelectionOptionalIndicator":"false","referralConditionTypeCode":"2","referralConditionTypeDescription":"Bypass Covering Same","providerAssignmentLevel":"01","providerAssignmentLevelDesc":"Individual Provider"}]},{"tierIdentifier":"7","tierDescription":"OON - Non-Emergent","tierTypeCode":"OON","tierTypeDescription":"Out of Network","gatedPlanIndicator":"false","erCopay":["200.00"],"inPatientCopay":["0.00"],"serviceAreaType":"In/Out of Srvc Area","planDelegation":[{"delegationIndicator":"true","delegationIdentifier":"OHP_DEL_SET_WO_ORTHONET","delegationName":"Oxford Optum Phy Health Chiro Delegation Schedule"}]}],"benefitCode":[{"benefitName":"DME Insulin Pump Office","benefitCode":"DME_INSULIN_PUMP_OFFICE","benefitDisplay":"Insulin Pump","benefitTier":["3","5","6","2","7"],"benefitType":"M","primaryOOPOnlyFlag":"false","primaryDeductibleOnlyFlag":"false","visitLimitsApplies":"false","copayApplies":"false","variableCoverage":"true","existsOnRiderPlan":"false","hipaaServiceTypes":[{"serviceTypeCode":"FLTR","serviceTypeDescription":"Custom Filter Code"}]},{"benefitName":"Exercise Facility","benefitCode":"EXERCISE_FACILITY","benefitDisplay":"Exercise Facility","benefitTier":["7"],"benefitType":"M","primaryOOPOnlyFlag":"false","primaryDeductibleOnlyFlag":"false","visitLimitsApplies":"true","copayApplies":"false","variableCoverage":"true","existsOnRiderPlan":"false","hipaaServiceTypes":[{"serviceTypeCode":"FLTR","serviceTypeDescription":"Custom Filter Code"}]}],"eHBIndicator":"true","externalIds":[{"entityId":"IDCARDTEMPLATE","externalPlanId":"OXFN1"},{"entityId":"MKTNM","externalPlanId":"CT LIBERTY 0/50/3000/100 LIBERTY HMO"},{"entityId":"TRACKING ID","externalPlanId":"KACTOHPLIBERTY02"}],"placeOfServiceDifferentialIndicator":"false","fundingArrangementCode":"01","fundingArrangementDescription":"Fully Insured","revenueArrangementCode":"01","revenueArrangementDescription":"FI","carrierBusinessId":"6"}]}}}}';
    public static final String nimbusGetSSBBadResponse = '{"getSubscriptionServiceBenefitResponse":{"transactionId":"fdd36afa-a4db-42ec-89cb-d4450fd6909e","errors":[{"code":400,"name":"InvalidRequest","severity":"FAULT","origin":"cirrus","description":"getSubscriptionServiceBenefitRequest : Validation Failed for Member Search required fields missing","uri":"/api/nebula/v1.0/benefits/read"}]}}';
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
    static testMethod void ACETGroupPlanDetailWebServiceMethod() {
        
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
        mapISLWSConfigs.put('dev_GetEmployerGroupEndpoint', '/api/bravo/eisl/organizations/employergroups/v2/read');
        mapISLWSConfigs.put('dev_ISLOAuthTokenEndpoint', '/auth/oauth/v2/token');
        mapISLWSConfigs.put('OILTimeout', '3000');
        
        List<ISL_Webservice_Config__c> lstISLWSConfigs = ACETTestDataUtility.CreateISLWebserviceConfigurations(mapISLWSConfigs);
        insert lstISLWSConfigs;
        
        
        String JSONStr = '{"UHCBS":"","GroupN":"Test Group Name","GroupStatus":"Active","ServiceTeam":"NY Large","EffectiveStartDate":"3/1/2016","RiskManagement":"Rating Method","RatingMethod":"","RenewalDate":"3/1/2016","RelationshipType":"Mother","groupSName":"Test GroupName"}';
        PageReference ACETGroupPlan = Page.ACETGroupPlanBenefitDetailRedesign;
         RecordType newRecord = [SELECT Id FROM RecordType WHERE Name = 'Person Account' and SObjectType = 'Account'];
        
        Account accountTest = new Account();
        accountTest.FirstName = 'Test Contact FN1';
        accountTest.LastName = 'Test Contact LN1';
        accountTest.EID__c = 'TestEID1';
        accountTest.EID__pc = 'TestEID1';
        accountTest.RecordTypeId = newRecord.Id;
        insert accountTest;

    Account accountObj = [SELECT Id,personcontactid from Account where Id=:accountTest.Id];
        Contact cont = [SELECT Id,LastName,FirstName,EID__c,AccountId from Contact where Id=:accountObj.personcontactid];
        
            
       // Contact cont = TestDataFactory.createContact();
        Interaction__c InteractionId = new Interaction__c();
        InteractionId.Contact_Name__c = 'Text Iname';
        InteractionId.Originator__c = cont.id;
        InteractionId.Originator_Type__c = 'Member';
        InteractionId.Highlight_Panel_GroupInfo__c = JSONStr;
        
        System.debug('!!!before ' + JSONStr + 'after ' + InteractionId.Highlight_Panel_GroupInfo__c);
        insert InteractionId;
        ACETGroupPlan.getParameters().put('interactionId', InteractionId.Id);
        ACETGroupPlan.getParameters().put('serviceTeam1', 'CT');
        ACETGroupPlan.getParameters().put('additionalInfo',TestDataFactory.createACETHighlightsPanelAdditionalInfo() + JSONStr);
        Test.setCurrentPage(ACETGroupPlan);
        
        List<ACETGroupPlanBenefitWrapper.BenefitWrapper>  benefitwrapplst =new List<ACETGroupPlanBenefitWrapper.BenefitWrapper>();
        ACETGroupPlanBenefitWrapper.BenefitWrapper  benefitWrapp = new ACETGroupPlanBenefitWrapper.BenefitWrapper();
        benefitWrapp.Benefit ='testBenefit';
        benefitWrapp.BenefitCode='BC';
        benefitWrapp.BenefitType='Test Type';
       
        benefitwrapplst.add(benefitWrapp);
        
        List<ACETGroupPlanBenefitWrapper.Accumulator> acclst =new List<ACETGroupPlanBenefitWrapper.Accumulator>();
        ACETGroupPlanBenefitWrapper.Accumulator accWrapp = new ACETGroupPlanBenefitWrapper.Accumulator();
        accWrapp.coverageLevel = 'Test';
        accWrapp.benefitVersion = '12';
        accWrapp.costShareType = 'tets';
        accWrapp.benefitMaximumValue = '123';
        accWrapp.benefitMaximumUnit = '1234';
        accWrapp.benefitYTDValue = '01/31/2017';
        accWrapp.benefitRemainingValue = '1234';
        acclst.add(accWrapp);
        
        Map<String,ACETGroupPlanBenefitWrapper.DateRangeVersion> mapDateTest = new Map<String,ACETGroupPlanBenefitWrapper.DateRangeVersion>();
        ACETGroupPlanBenefitWrapper.DateRangeVersion mapdate = new ACETGroupPlanBenefitWrapper.DateRangeVersion();
        mapdate.dateRange = '01/31/2017 - 01/31/2018';
        mapdate.benefitVersion = '20';
        mapDateTest.put('test',mapdate);
        
        Map<String,List<ACETGroupPlanBenefitWrapper.planTier>> mapBenefitPlans = new Map<String,List<ACETGroupPlanBenefitWrapper.planTier>>();
        List<ACETGroupPlanBenefitWrapper.planTier> planTierLst = new List<ACETGroupPlanBenefitWrapper.planTier>();
        ACETGroupPlanBenefitWrapper.planTier planT = new ACETGroupPlanBenefitWrapper.planTier();
      //  planT.tierIdentifier = '88899';
        planT.tierTypeCode = '1';
        planT.tierTypeDescription = 'In-Network Providers';
        planT.gatedPlanIndicator = 'N';
        planT.primaryIndividualDeductibleMaximum = '2500';
        planT.primaryFamilyDeductibleMaximum = '5000';
        planT.primaryIndividualOOPMaximum = '2500';
        planT.primaryFamilyOOPMaximum = '5000';
        planTierLst.add(planT);
        mapBenefitPlans.put('Test',planTierLst);
        List<ACETGroupPlanBenefitWrapper.coPayWrapper> coWrapplst= new List<ACETGroupPlanBenefitWrapper.coPayWrapper>();
        ACETGroupPlanBenefitWrapper.coPayWrapper coWrapp= new ACETGroupPlanBenefitWrapper.coPayWrapper();
        coWrapp.label='test';
        coWrapp.value ='50';
        coWrapplst.add(coWrapp);
        List<ACETGroupPlanBenefitWrapper.individualBenefitWrapper> indWrapplst= new List<ACETGroupPlanBenefitWrapper.individualBenefitWrapper>();
        ACETGroupPlanBenefitWrapper.individualBenefitWrapper indWrapp= new ACETGroupPlanBenefitWrapper.individualBenefitWrapper();
        indWrapp.rowLabel = 'testrow';
        indWrapp.dedLimit = '10';
        indWrapp.OOPLimit = '50';
        List<ACETGroupPlanBenefitWrapper.familyBenefitWrapper> famWrapplst= new List<ACETGroupPlanBenefitWrapper.familyBenefitWrapper> ();
        ACETGroupPlanBenefitWrapper.familyBenefitWrapper famWrapp= new ACETGroupPlanBenefitWrapper.familyBenefitWrapper ();
        famWrapp.rowLabel = 'testrow';
        famWrapp.dedLimit = '10';
        famWrapp.OOPLimit = '50';
        ACETGroupPlanBenefitWrapper.PlanInformationWrapper planWrapp = new ACETGroupPlanBenefitWrapper.PlanInformationWrapper(); 
        planWrapp.PolicyNumber= '123456';
        planWrapp.PlanName= 'GroupPlanTest';
        planWrapp.PlanType= 'GroupPlan';
        planWrapp.Accumulator= 'test';
        planWrapp.Gated= 'test';
        planWrapp.PCP= 'test';
        planWrapp.Network='UHCP';
        planWrapp.timePeriodQualifier='test';
        planWrapp.EffectiveDate='01/01/2017';
        planWrapp.EndDate='01/31/2017';
        planWrapp.ExpirationDate='01/31/2017';
        planWrapp.RevisionDate='06/31/2017';
        planWrapp.GroupName='TetGroup';
        planWrapp.enrolleeType='TestType';
        planWrapp.enrolleeIdentifier='Copay';
        ACETGroupPlanBenefitWrapper.networkScheduleIds netIds= new ACETGroupPlanBenefitWrapper.networkScheduleIds();
        netIds.networkSchId = '1234567';
        List<ACETGroupDetail.GroupPlanWrapper> groupwrapplst=new List<ACETGroupDetail.GroupPlanWrapper>();
        ACETGroupDetail.GroupPlanWrapper groupwrapp=new ACETGroupDetail.GroupPlanWrapper();
        groupwrapp.bundleId='35567894';
        groupwrapplst.add(groupwrapp);
        StaticResource ResponseJSONSR = [SELECT Body FROM StaticResource WHERE Name = 'ACETBenefitsAgeBand'];
        String ResponseJSON = ResponseJSONSR.Body.toString();  
        Test.startTest();
            MockHttpCalloutResponseGenerator.MockHttpResponse OILResponse = new MockHttpCalloutResponseGenerator.MockHttpResponse(200, 'OK', ResponseJSON);
            OILResponse.TokenExpired = false;

            MockHttpCalloutResponseGenerator MockHttpRes = new MockHttpCalloutResponseGenerator(null, OILResponse);
            Test.setMock(HttpCalloutMock.class, MockHttpRes);
            ACETGroupPlanBenefitWrapper groupPlanWrapp=new ACETGroupPlanBenefitWrapper();
            groupPlanWrapp.coPayWrapperList=coWrapplst;
            ACETGroupPlanDetailControllerRedesign groupPlanDetailContr = new ACETGroupPlanDetailControllerRedesign();
                        
            groupPlanDetailContr.policyNo = '35567894';
            groupPlanDetailContr.groupNumber = '1278550';
            groupPlanDetailContr.stateName = 'CT';
            groupPlanDetailContr.subject=cont; 
            groupPlanDetailContr.riderList=benefitwrapplst;
            groupPlanDetailContr.coPayList=coWrapplst;
			groupPlanDetailContr.EffectiveDate = '01/01/2017';
            groupPlanDetailContr.EndDate = '01/01/2022';
            groupPlanDetailContr.getEmployerCallOutSearchResults=groupwrapplst;
            ACETCallTopicsDataWrapper acetCallTopicDW = new ACETCallTopicsDataWrapper();
            acetCallTopicDW.saveCase();
            ACETGroupPlanBenefitWrapper.coPayWrapper AGPBW1= new ACETGroupPlanBenefitWrapper.coPayWrapper();
            List<ACETGroupPlanBenefitWrapper.coPayWrapper> AGPBWLST = NEW  List<ACETGroupPlanBenefitWrapper.coPayWrapper>();
            AGPBWLST.ADD(AGPBW1);
            groupPlanDetailContr.coPaySearchResults = AGPBWLST;
            groupPlanDetailContr.getCoPayInfoSearchResults();
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
        List<ACETGroupPlanBenefitWrapper.BenefitSubSection> BenefitSectionlst = new List<ACETGroupPlanBenefitWrapper.BenefitSubSection>();
        BenefitSectionlst.add(BenefitSection1);
        
        ACETGroupPlanBenefitWrapper.PlanBenefitRiderWrapper RiderWrap = new ACETGroupPlanBenefitWrapper.PlanBenefitRiderWrapper();
        RiderWrap.riderCoverageType='phys';
        RiderWrap.riderBenefitPlanId='1111111';
        RiderWrap.riderGated='yes';
        RiderWrap.riderCarrierName='Ttest';
        RiderWrap.riderProductName='ins';
        RiderWrap.riderProductId='10101010';
        RiderWrap.riderPlanTypeCode='phy';
        RiderWrap.riderPlanName='Test';
        
        ACETGroupPlanBenefitWrapper.AccumulatorP WrapAccum = new ACETGroupPlanBenefitWrapper.AccumulatorP();
        WrapAccum.Section='IND';            //Individual or Familty
        WrapAccum.TypeCode='OON';           //INN or OON
        WrapAccum.MaxDeductible='20';
        WrapAccum.MaxDed ='22';
        WrapAccum.YTDDeductible='240';
        WrapAccum.YTDDed='222';
        WrapAccum.RemDeductible='11';
        WrapAccum.coinsurance =10;
        WrapAccum.MaxOOP='15';
        WrapAccum.MaxOutofPoc='12';
        WrapAccum.YTDOutofPoc='14';
        WrapAccum.YTDOOP='16';
        WrapAccum.RemOOP='18';
        WrapAccum.primaryAccumDeduct='20';
        WrapAccum.primaryAccumDescOOP='20';
        WrapAccum.GroupMaxOOP='11';
        WrapAccum.GroupMaxDed='25';
        
        ACETGroupPlanBenefitWrapper.AccumulatorRedesignWrapper redesignwrap = new ACETGroupPlanBenefitWrapper.AccumulatorRedesignWrapper();
        redesignwrap.TypeCode='INN';  
        redesignwrap.accumulatorDeductibleLimit='50';
        redesignwrap.accumulatorDeductibleSatisfied='75';
        redesignwrap.accumulatorDeductibleRemaining='25';
        redesignwrap.accumulatorOOPLimit='12';
        redesignwrap.accumulatorOOPSatisfied='12';
        redesignwrap.accumulatorOOPRemaining='12';
        redesignwrap.coinsurance=20;
        redesignwrap.primaryAccumDeduct='40';
        redesignwrap.primaryAccumDescOOP='40';    
        ACETGroupPlanBenefitWrapper.BenefitDetailsWrapper detwrap = new ACETGroupPlanBenefitWrapper.BenefitDetailsWrapper();
        detwrap.BenefitCode='INN';
        detwrap.BenefitType='phy';
        detwrap.BenefitSubSection=BenefitSectionlst;
        ACETGroupPlanBenefitWrapper.OONReimbursement OONReimb = new ACETGroupPlanBenefitWrapper.OONReimbursement();
        OONReimb.Percentile='22';
        OONReimb.OONPricingType='inn';
        List<ACETGroupPlanBenefitWrapper.OONReimbursement> ONNReimbLst = new  List<ACETGroupPlanBenefitWrapper.OONReimbursement>();
        ONNReimbLst.add(OONReimb);
        ACETGroupPlanBenefitWrapper BeneWrap = new ACETGroupPlanBenefitWrapper();
        BeneWrap.OONReimbursementList=ONNReimbLst;
        BeneWrap.hippakeyStr='test';
        BeneWrap.hippaBenefitCodeJSON='test';
        BeneWrap.benefitCodeMapJSON='JsonTest';
            

        Test.stopTest();
        system.AssertNotEquals(acetCallTopicDW.caseObj.id, null);
    }
    
    
    static testMethod void ACETGroupPlanDetailWebServiceMethod2() {
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
        mapISLWSConfigs.put('dev_GetServiceBenefit', '/api/alpha/eisl/benefits/servicebenefit/v2.0/read');
        mapISLWSConfigs.put('dev_ISLOAuthTokenEndpoint', '/auth/oauth/v2/token');
        mapISLWSConfigs.put('OILTimeout', '3000');
        
        List<ISL_Webservice_Config__c> lstISLWSConfigs = ACETTestDataUtility.CreateISLWebserviceConfigurations(mapISLWSConfigs);
        insert lstISLWSConfigs;
        
        
        String JSONStr = '{"UHCBS":"","GroupN":"Test Group Name","GroupStatus":"Active","ServiceTeam":"NY Large","EffectiveStartDate":"3/1/2016","RiskManagement":"Rating Method","RatingMethod":"","RenewalDate":"3/1/2016","RelationshipType":"Mother","groupSName":"Test GroupName"}';
        PageReference ACETGroupPlan = Page.ACETGroupPlanBenefitDetailRedesign;
        RecordType newRecord = [SELECT Id FROM RecordType WHERE Name = 'Person Account' and SObjectType = 'Account'];
        
        Account accountTest = new Account();
        accountTest.FirstName = 'JIM';
        accountTest.LastName = 'KEITH';
        accountTest.EID__c = 'PIN';
        accountTest.EID__pc = 'PIN';
        accountTest.RecordTypeId = newRecord.Id;
        insert accountTest;

        Account acc = [SELECT Id,personcontactid from Account where Id=:accountTest.Id];
        Contact cont = [SELECT Id,LastName,FirstName,EID__c,AccountId from Contact where Id=:acc.personcontactid];
        
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
           // ACETGetSubscriptionBeneJSON2APEX Json2ApexTest = ACETGetSubscriptionBeneJSON2APEX.parse(jsonResponse);
           // ACETGetSubscriptionBenefitWebservice webserviceCall = new ACETGetSubscriptionBenefitWebservice();
           // webserviceCall.getSubscriptionBenefitSearch('7100123',null,null,null,null,null,null,null);
          //  webserviceCall.getTierCode();
           
        Test.stopTest();
    }
    static testMethod void GroupPlanDetailContiWebServiceMethod() {
        Map<String, String> mapISLWSConfigs = new Map<String, String>(); 
        mapISLWSConfigs.put('ISLConAccessToken', 'e9b3f2b1-8863-49ec-9ff8-40da25961ef5');
        mapISLWSConfigs.put('OILHttpHeaderAccept', 'application/json;charset=UTF-8');
        mapISLWSConfigs.put('OILHttpHeaderActor', 'ACET');
        mapISLWSConfigs.put('OILHttpHeaderScope', 'read');
        mapISLWSConfigs.put('dev_ISLOAuthEndpoint', 'https://api-stg.optum.com:8443');
        mapISLWSConfigs.put('dev_getSubscriptionBenefitSearch', '/api/bravo/eisl/benefits/servicebenefit/v2.0/read');
        mapISLWSConfigs.put('dev_GetEmployerGroupEndpoint', '/api/bravo/eisl/organizations/employergroups/v2.0/read');
        mapISLWSConfigs.put('OILTimeout', '3000');
        List<ISL_Webservice_Config__c> lstISLWSConfigs = ACETTestDataUtility.CreateISLWebserviceConfigurations(mapISLWSConfigs);
        insert lstISLWSConfigs;
        
        StaticResource ResponseJSONSR = [SELECT Body FROM StaticResource WHERE Name = 'ACETBenefitsAgeBand'];
        String ResponseJSON = ResponseJSONSR.Body.toString();  
        
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
        oContact.Tax_Id__c = 'TstTaxID1';
        oContact.NPI__c = 'TestNPI1';
            
        Interaction__c oInteraction = ACETTestDataUtility.CreateInteraction(oContact.Id, 'Phone', 'Member', oContact.LastName);
        insert oInteraction;
        
        ACETHighlightsPanelAdditionalInfo AdditionalInfo = new ACETHighlightsPanelAdditionalInfo();
        AdditionalInfo.PolicyNumber = 'TestPolicyNumber';
          
        Test.startTest();
            
        PageReference ACETGroupPlan = Page.ACETGroupPlanBenefitDetailRedesign;
        ACETGroupPlan.getParameters().put('interactionId', oInteraction.Id);
        ACETGroupPlan.getParameters().put('groupId', '1278550');
        ACETGroupPlan.getParameters().put('policyNo', '1018479');
        ACETGroupPlan.getParameters().put('stateName', 'CT');
        Test.setCurrentPage(ACETGroupPlan);
        
        ACETGroupPlanDetailControllerRedesign groupPlanDetailContr = new ACETGroupPlanDetailControllerRedesign(); 

        Continuation conti = (Continuation)groupPlanDetailContr.CallWSonPageLoad();     
        Map<String, HttpRequest> requests = conti.getRequests();
        system.assertEquals(2, requests.size());
        
        HttpResponse response;
        HttpRequest request;
        
        for(String RequestLabel: requests.keyset()){
            request = requests.get(RequestLabel);
            response = new HttpResponse();
            response.setStatusCode(200);
            response.setStatus('OK');
            String jsonres=ResponseJSON;
            if (request.getEndpoint().contains('/api/bravo/eisl/benefits/servicebenefit/v2.0/read')) {
                response.setBody(nimbusGetSSBResponse);
            }      
            else {
                response.setBody(nimbusGetSSBBadResponse);
            }     
            Test.setContinuationResponse(RequestLabel, response); 
        }
        Object result = Test.invokeContinuationMethod(groupPlanDetailContr, conti); 
        Test.stopTest();
    }
    
    static testMethod void GroupPlanDetailContiWebServiceMethod1() {
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

    Account accountObj = [SELECT Id,personcontactid from Account where Id=:accountTest.Id];
        Contact contactObj = [SELECT Id,LastName,FirstName,EID__c,AccountId from Contact where Id=:accountObj.personcontactid];
        contactObj.Tax_Id__c = 'TstTaxID1';
        contactObj.NPI__c = 'TestNPI1';
        
            
        String JSONStr = '{"UHCBS":"","GroupN":"Test Group Name","GroupStatus":"Active","ServiceTeam":"NY Large","EffectiveStartDate":"3/1/2016","RiskManagement":"Rating Method","RatingMethod":"","RenewalDate":"3/1/2016","RelationshipType":"Mother","groupSName":"Test GroupName"}';
        
        Interaction__c InteractionId = new Interaction__c();
        InteractionId.Contact_Name__c = 'Text Iname';
        InteractionId.Originator__c = contactObj.id;
        InteractionId.Originator_Type__c = 'Member';
        InteractionId.Highlight_Panel_GroupInfo__c = JSONStr;
        insert InteractionId;
        
        Map<String,String> copayMapping = new Map<String,String>();
        copayMapping.put('PCP','34');
        copayMapping.put('Specialist','34');
        copayMapping.put('ER Visit','34');
        
        ACETHighlightsPanelAdditionalInfo AdditionalInfo = new ACETHighlightsPanelAdditionalInfo();
        AdditionalInfo.PolicyNumber = 'TestPolicyNumber';
          
        Test.startTest();
            
        PageReference ACETGroupPlan = Page.ACETGroupPlanBenefitDetailRedesign;
        ACETGroupPlan.getParameters().put('interactionId', InteractionId.Id);
        ACETGroupPlan.getParameters().put('policyNo', '1018479');
        ACETGroupPlan.getParameters().put('stateName', 'CT');
        Test.setCurrentPage(ACETGroupPlan);
        
        ACETGroupPlanDetailControllerRedesign groupPlanDetailContr = new ACETGroupPlanDetailControllerRedesign(); 
        groupPlanDetailContr.copayMapping = copayMapping;
        
       // Continuation conti = (Continuation)groupPlanDetailContr.CallWSOnBenefitsTabClick();     
      //  Map<String, HttpRequest> requests = conti.getRequests();
       // system.assertEquals(1, requests.size());
        
        HttpResponse response;
        HttpRequest request;
        
      /*  for(String RequestLabel: requests.keyset()){
            request = requests.get(RequestLabel);
            response = new HttpResponse();
            response.setStatusCode(200);
            response.setStatus('OK');
            if (request.getEndpoint().contains('/api/bravo/eisl/benefits/servicebenefit/v2.0/read')) {
                response.setBody(ACETTestDataUtility.getSubscriptionBenefitResponse());
            }       
            Test.setContinuationResponse(RequestLabel, response); 
        } */
       // Object result = Test.invokeContinuationMethod(groupPlanDetailContr, conti); 
        Test.stopTest();
    }
    static testMethod void GroupPlanDetailContiWebServiceMethod2() {
        Map<String, String> mapISLWSConfigs = new Map<String, String>(); 
        mapISLWSConfigs.put('ISLConAccessToken', 'e9b3f2b1-8863-49ec-9ff8-40da25961ef5');
        mapISLWSConfigs.put('OILHttpHeaderAccept', 'application/json;charset=UTF-8');
        mapISLWSConfigs.put('OILHttpHeaderActor', 'ACET');
        mapISLWSConfigs.put('OILHttpHeaderScope', 'read');
        mapISLWSConfigs.put('dev_ISLOAuthEndpoint', 'https://api-stg.optum.com:8443');
        mapISLWSConfigs.put('dev_getSubscriptionBenefitSearch', '/api/bravo/eisl/benefits/servicebenefit/v2.0/read');
        mapISLWSConfigs.put('dev_GetEmployerGroupEndpoint', '/api/bravo/eisl/organizations/employergroups/v2.0/read');
        mapISLWSConfigs.put('OILTimeout', '3000');
        List<ISL_Webservice_Config__c> lstISLWSConfigs = ACETTestDataUtility.CreateISLWebserviceConfigurations(mapISLWSConfigs);
        insert lstISLWSConfigs;
        
        StaticResource ResponseJSONSR = [SELECT Body FROM StaticResource WHERE Name = 'ACETBenefitFamilyBased'];
        String ResponseJSON = ResponseJSONSR.Body.toString();  
        
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
        oContact.Tax_Id__c = 'TstTaxID1';
        oContact.NPI__c = 'TestNPI1';
        
            
        Interaction__c oInteraction = ACETTestDataUtility.CreateInteraction(oContact.Id, 'Phone', 'Member', oContact.LastName);
        insert oInteraction;
        
        ACETHighlightsPanelAdditionalInfo AdditionalInfo = new ACETHighlightsPanelAdditionalInfo();
        AdditionalInfo.PolicyNumber = 'TestPolicyNumber';
          
        Test.startTest();
            
        PageReference ACETGroupPlan = Page.ACETGroupPlanBenefitDetailRedesign;
        ACETGroupPlan.getParameters().put('interactionId', oInteraction.Id);
        ACETGroupPlan.getParameters().put('groupId', '1188478');
        ACETGroupPlan.getParameters().put('policyNo', '1018482');
        ACETGroupPlan.getParameters().put('stateName', 'CT');
        Test.setCurrentPage(ACETGroupPlan);
        
        ACETGroupPlanDetailControllerRedesign groupPlanDetailContr = new ACETGroupPlanDetailControllerRedesign(); 

        Continuation conti = (Continuation)groupPlanDetailContr.CallWSonPageLoad();     
        Map<String, HttpRequest> requests = conti.getRequests();
        system.assertEquals(2, requests.size());
        
        HttpResponse response;
        HttpRequest request;
        
        for(String RequestLabel: requests.keyset()){
            request = requests.get(RequestLabel);
            response = new HttpResponse();
            response.setStatusCode(200);
            response.setStatus('OK');
            String jsonres=ResponseJSON;
            if (request.getEndpoint().contains('/api/bravo/eisl/benefits/servicebenefit/v2.0/read')) {
                response.setBody(ACETTestDataUtility.getSubscriptionBenefitResponse());
            }      
            else {
                response.setBody(ResponseJSON);
            }     
            Test.setContinuationResponse(RequestLabel, response); 
        }
        Object result = Test.invokeContinuationMethod(groupPlanDetailContr, conti); 
        Test.stopTest();
    }
    
    static testMethod void GroupPlanDetailContiWebServiceMethod3() {
        Map<String, String> mapISLWSConfigs = new Map<String, String>(); 
        mapISLWSConfigs.put('ISLConAccessToken', 'e9b3f2b1-8863-49ec-9ff8-40da25961ef5');
        mapISLWSConfigs.put('OILHttpHeaderAccept', 'application/json;charset=UTF-8');
        mapISLWSConfigs.put('OILHttpHeaderActor', 'ACET');
        mapISLWSConfigs.put('OILHttpHeaderScope', 'read');
        mapISLWSConfigs.put('dev_ISLOAuthEndpoint', 'https://api-stg.optum.com:8443');
        mapISLWSConfigs.put('dev_getSubscriptionBenefitSearch', '/api/bravo/eisl/benefits/servicebenefit/v2.0/read');
        mapISLWSConfigs.put('dev_GetEmployerGroupEndpoint', '/api/bravo/eisl/organizations/employergroups/v2.0/read');
        mapISLWSConfigs.put('OILTimeout', '3000');
        List<ISL_Webservice_Config__c> lstISLWSConfigs = ACETTestDataUtility.CreateISLWebserviceConfigurations(mapISLWSConfigs);
        insert lstISLWSConfigs;
        
        StaticResource ResponseJSONSR = [SELECT Body FROM StaticResource WHERE Name = 'ACETBenefitsAgeBandv3'];
        String ResponseJSON = ResponseJSONSR.Body.toString();  
        
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
        oContact.Tax_Id__c = 'TstTaxID1';
        oContact.NPI__c = 'TestNPI1';
        
        Interaction__c oInteraction = ACETTestDataUtility.CreateInteraction(oContact.Id, 'Phone', 'Member', oContact.LastName);
        insert oInteraction;
        
        ACETHighlightsPanelAdditionalInfo AdditionalInfo = new ACETHighlightsPanelAdditionalInfo();
        AdditionalInfo.PolicyNumber = 'TestPolicyNumber';
        
        ACETOnshoreIndicatorVerbiage__c verbiage = new ACETOnshoreIndicatorVerbiage__c();
        verbiage.Code__c = 123;
        verbiage.Code_Description__c = 'All Services Offshore';
        verbiage.Hover_Help_Description__c = 'All Services Offshore';
        verbiage.Name = 'All Services Offshore';
        insert verbiage;
          
        Test.startTest();
            
        PageReference ACETGroupPlan = Page.ACETGroupPlanBenefitDetailRedesign;
        ACETGroupPlan.getParameters().put('interactionId', oInteraction.Id);
        ACETGroupPlan.getParameters().put('groupId', '1188478');
        ACETGroupPlan.getParameters().put('policyNo', '1018480');
        ACETGroupPlan.getParameters().put('stateName', 'CT');
        ACETGroupPlan.getParameters().put('contractId', '654159');
        ACETGroupPlan.getParameters().put('status', 'Building');
        ACETGroupPlan.getParameters().put('effectDate', '1/1/2017');
        Test.setCurrentPage(ACETGroupPlan);
        
        ACETGroupPlanDetailControllerRedesign groupPlanDetailContr = new ACETGroupPlanDetailControllerRedesign(); 
        groupPlanDetailContr.CoverageType = 'test';

        Continuation conti = (Continuation)groupPlanDetailContr.CallWSonPageLoad();     
        Map<String, HttpRequest> requests = conti.getRequests();
        system.assertEquals(2, requests.size());
        
        HttpResponse response;
        HttpRequest request;
        
        for(String RequestLabel: requests.keyset()){
            request = requests.get(RequestLabel);
            response = new HttpResponse();
            response.setStatusCode(200);
            response.setStatus('OK');
            String jsonres=ResponseJSON;
            if (request.getEndpoint().contains('/api/bravo/eisl/benefits/servicebenefit/v2.0/read')) {
                response.setBody(ACETTestDataUtility.getSubscriptionBenefitResponse());
            }      
            else {
                response.setBody(ResponseJSON);
            }     
            Test.setContinuationResponse(RequestLabel, response); 
        }
        Object result = Test.invokeContinuationMethod(groupPlanDetailContr, conti); 
        Test.stopTest();
    }
    
    static testMethod void GroupPlanDetailContiWebServiceMethodPolContract() {
        Map<String, String> mapISLWSConfigs = new Map<String, String>(); 
        mapISLWSConfigs.put('ISLConAccessToken', 'e9b3f2b1-8863-49ec-9ff8-40da25961ef5');
        mapISLWSConfigs.put('OILHttpHeaderAccept', 'application/json;charset=UTF-8');
        mapISLWSConfigs.put('OILHttpHeaderActor', 'ACET');
        mapISLWSConfigs.put('OILHttpHeaderScope', 'read');
        mapISLWSConfigs.put('dev_ISLOAuthEndpoint', 'https://api-stg.optum.com:8443');
        mapISLWSConfigs.put('dev_getSubscriptionBenefitSearch', '/api/bravo/eisl/benefits/servicebenefit/v2.0/read');
        mapISLWSConfigs.put('dev_GetEmployerGroupEndpoint', '/api/bravo/eisl/organizations/employergroups/v2.0/read');
        mapISLWSConfigs.put('OILTimeout', '3000');
        List<ISL_Webservice_Config__c> lstISLWSConfigs = ACETTestDataUtility.CreateISLWebserviceConfigurations(mapISLWSConfigs);
        insert lstISLWSConfigs;
        
        StaticResource ResponseJSONSR = [SELECT Body FROM StaticResource WHERE Name = 'ACETBenefitsAgeBandv3'];
        String ResponseJSON = ResponseJSONSR.Body.toString();    
        
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
        oContact.Tax_Id__c = 'TstTaxID1';
        oContact.NPI__c = 'TestNPI1';
        
        Interaction__c oInteraction = ACETTestDataUtility.CreateInteraction(oContact.Id, 'Phone', 'Member', oContact.LastName);
        insert oInteraction;
        
        ACETHighlightsPanelAdditionalInfo AdditionalInfo = new ACETHighlightsPanelAdditionalInfo();
        AdditionalInfo.PolicyNumber = 'TestPolicyNumber';
          
        Test.startTest();
            
        PageReference ACETGroupPlan = Page.ACETGroupPlanBenefitDetailRedesign;
        ACETGroupPlan.getParameters().put('interactionId', oInteraction.Id);
        ACETGroupPlan.getParameters().put('groupId', '1278550');
        ACETGroupPlan.getParameters().put('policyNo', '1018481');
        ACETGroupPlan.getParameters().put('stateName', 'CT');
        ACETGroupPlan.getParameters().put('status', 'Active');
        ACETGroupPlan.getParameters().put('contractId', '602613');
        ACETGroupPlan.getParameters().put('effectDate', '1/1/2018');
        ACETGroupPlan.getParameters().put('endDate', '12/31/2018');
        Test.setCurrentPage(ACETGroupPlan);
        
        ACETGroupPlanDetailControllerRedesign groupPlanDetailContr = new ACETGroupPlanDetailControllerRedesign(); 

        Continuation conti = (Continuation)groupPlanDetailContr.CallWSonPageLoad();     
        Map<String, HttpRequest> requests = conti.getRequests();
        system.assertEquals(2, requests.size());
        
        HttpResponse response;
        HttpRequest request;
        
        for(String RequestLabel: requests.keyset()){
            request = requests.get(RequestLabel);
            response = new HttpResponse();
            response.setStatusCode(200);
            response.setStatus('OK');
            String jsonres=ResponseJSON;
            if (request.getEndpoint().contains('/api/bravo/eisl/benefits/servicebenefit/v2.0/read')) {
                response.setBody(ACETTestDataUtility.getSubscriptionBenefitResponse());
            }      
            else {
                response.setBody(ResponseJSON);
            }     
            Test.setContinuationResponse(RequestLabel, response); 
        }
        Object result = Test.invokeContinuationMethod(groupPlanDetailContr, conti); 
        Test.stopTest();
    }
    
    static testMethod void GroupPlanDetailContiWebServiceMethodPolContract2() {
        Map<String, String> mapISLWSConfigs = new Map<String, String>(); 
        mapISLWSConfigs.put('ISLConAccessToken', 'e9b3f2b1-8863-49ec-9ff8-40da25961ef5');
        mapISLWSConfigs.put('OILHttpHeaderAccept', 'application/json;charset=UTF-8');
        mapISLWSConfigs.put('OILHttpHeaderActor', 'ACET');
        mapISLWSConfigs.put('OILHttpHeaderScope', 'read');
        mapISLWSConfigs.put('dev_ISLOAuthEndpoint', 'https://api-stg.optum.com:8443');
        mapISLWSConfigs.put('dev_getSubscriptionBenefitSearch', '/api/bravo/eisl/benefits/servicebenefit/v2.0/read');
        mapISLWSConfigs.put('dev_GetEmployerGroupEndpoint', '/api/bravo/eisl/organizations/employergroups/v2.0/read');
        mapISLWSConfigs.put('OILTimeout', '3000');
        List<ISL_Webservice_Config__c> lstISLWSConfigs = ACETTestDataUtility.CreateISLWebserviceConfigurations(mapISLWSConfigs);
        insert lstISLWSConfigs;
        
        Map<String, Integer> mapOnshoreVerbgs = new Map<String, Integer>(); 
        mapOnshoreVerbgs.put('All Services Offshore',1);
        List<ACETOnshoreIndicatorVerbiage__c> lstOnshoreVerbgs = ACETTestDataUtility.CreateOnshoreVerbiages(mapOnshoreVerbgs);
        insert lstOnshoreVerbgs;
        
        StaticResource ResponseJSONSR = [SELECT Body FROM StaticResource WHERE Name = 'ACETGroupPlanPolContractAgeBand'];
        String ResponseJSON = ResponseJSONSR.Body.toString();    
        
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
        oContact.Tax_Id__c = 'TstTaxID1';
        oContact.NPI__c = 'TestNPI1';
        
        Interaction__c oInteraction = ACETTestDataUtility.CreateInteraction(oContact.Id, 'Phone', 'Member', oContact.LastName);
        insert oInteraction;
        
        ACETHighlightsPanelAdditionalInfo AdditionalInfo = new ACETHighlightsPanelAdditionalInfo();
        AdditionalInfo.PolicyNumber = 'TestPolicyNumber';
          
        Test.startTest();
            
        PageReference ACETGroupPlan = Page.ACETGroupPlanBenefitDetailRedesign;
        ACETGroupPlan.getParameters().put('interactionId', oInteraction.Id);
        ACETGroupPlan.getParameters().put('groupId', '1275392');
        ACETGroupPlan.getParameters().put('policyNo', '1018487');
        ACETGroupPlan.getParameters().put('stateName', 'NY');
        ACETGroupPlan.getParameters().put('status', 'Active');
        ACETGroupPlan.getParameters().put('contractId', '6514738');
        ACETGroupPlan.getParameters().put('effectDate', '1/1/2019');
        ACETGroupPlan.getParameters().put('endDate', '12/31/2019');
        Test.setCurrentPage(ACETGroupPlan);
        
        ACETGroupPlanDetailControllerRedesign groupPlanDetailContr = new ACETGroupPlanDetailControllerRedesign(); 

        Continuation conti = (Continuation)groupPlanDetailContr.CallWSonPageLoad();     
        Map<String, HttpRequest> requests = conti.getRequests();
        system.assertEquals(2, requests.size());
        
        HttpResponse response;
        HttpRequest request;
        
        for(String RequestLabel: requests.keyset()){
            request = requests.get(RequestLabel);
            response = new HttpResponse();
            response.setStatusCode(200);
            response.setStatus('OK');
            String jsonres=ResponseJSON;
            if (request.getEndpoint().contains('/api/bravo/eisl/benefits/servicebenefit/v2.0/read')) {
                response.setBody(ACETTestDataUtility.getSubscriptionBenefitResponse());
            }      
            else {
                response.setBody(ResponseJSON);
            }     
            Test.setContinuationResponse(RequestLabel, response); 
        }
        Object result = Test.invokeContinuationMethod(groupPlanDetailContr, conti); 
        Test.stopTest();
    }
    
    static testMethod void GroupPlanDetailContiWebServiceMethodPolContract3() {
        Map<String, String> mapISLWSConfigs = new Map<String, String>(); 
        mapISLWSConfigs.put('ISLConAccessToken', 'e9b3f2b1-8863-49ec-9ff8-40da25961ef5');
        mapISLWSConfigs.put('OILHttpHeaderAccept', 'application/json;charset=UTF-8');
        mapISLWSConfigs.put('OILHttpHeaderActor', 'ACET');
        mapISLWSConfigs.put('OILHttpHeaderScope', 'read');
        mapISLWSConfigs.put('dev_ISLOAuthEndpoint', 'https://api-stg.optum.com:8444');
        mapISLWSConfigs.put('dev_getSubscriptionBenefitSearch', '/api/bravo/eisl/benefits/servicebenefit/v2.0/read');
        mapISLWSConfigs.put('d1_GetEmployerGroupEndpoint', '/api/alpha/eisl/organizations/employergroups/v4.0/read');
        mapISLWSConfigs.put('OILTimeout', '3000');
        List<ISL_Webservice_Config__c> lstISLWSConfigs = ACETTestDataUtility.CreateISLWebserviceConfigurations(mapISLWSConfigs);
        insert lstISLWSConfigs;
        
        Map<String, Integer> mapOnshoreVerbgs = new Map<String, Integer>(); 
        mapOnshoreVerbgs.put('All Services Offshore',1);
        List<ACETOnshoreIndicatorVerbiage__c> lstOnshoreVerbgs = ACETTestDataUtility.CreateOnshoreVerbiages(mapOnshoreVerbgs);
        insert lstOnshoreVerbgs;
        
        StaticResource ResponseJSONSR = [SELECT Body FROM StaticResource WHERE Name = 'ACETGroupPlanPolContractAgeBand'];
        String ResponseJSON = ResponseJSONSR.Body.toString();    
        
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
        oContact.Tax_Id__c = 'TstTaxID1';
        oContact.NPI__c = 'TestNPI1';
        
        Interaction__c oInteraction = ACETTestDataUtility.CreateInteraction(oContact.Id, 'Phone', 'Member', oContact.LastName);
        insert oInteraction;
        
        ACETHighlightsPanelAdditionalInfo AdditionalInfo = new ACETHighlightsPanelAdditionalInfo();
        AdditionalInfo.PolicyNumber = 'TestPolicyNumber';
          
        Test.startTest();
            
        PageReference ACETGroupPlan = Page.ACETGroupPlanBenefitDetailRedesign;
        ACETGroupPlan.getParameters().put('interactionId', oInteraction.Id);
        ACETGroupPlan.getParameters().put('groupId', '1279552');
        ACETGroupPlan.getParameters().put('policyNo', '1018487');
        ACETGroupPlan.getParameters().put('stateName', 'NY');
        ACETGroupPlan.getParameters().put('status', 'Active');
        ACETGroupPlan.getParameters().put('contractId', '6514738');
        ACETGroupPlan.getParameters().put('effectDate', '1/1/2019');
        ACETGroupPlan.getParameters().put('endDate', '12/31/2019');
        Test.setCurrentPage(ACETGroupPlan);
        
        ACETGroupPlanDetailControllerRedesign groupPlanDetailContr = new ACETGroupPlanDetailControllerRedesign(); 

        Continuation conti = (Continuation)groupPlanDetailContr.CallWSonPageLoad();     
        Map<String, HttpRequest> requests = conti.getRequests();
        system.assertEquals(2, requests.size());
        
        HttpResponse response;
        HttpRequest request;
        
        for(String RequestLabel: requests.keyset()){
            request = requests.get(RequestLabel);
            response = new HttpResponse();
            response.setStatusCode(200);
            response.setStatus('OK');
            String jsonres=ResponseJSON;
            if (request.getEndpoint().contains('/api/bravo/eisl/benefits/servicebenefit/v2.0/read')) {
                response.setBody(ACETTestDataUtility.getSubscriptionBenefitResponse());
            }      
            else {
                response.setBody(ResponseJSON);
            }     
            Test.setContinuationResponse(RequestLabel, response); 
        }
        Object result = Test.invokeContinuationMethod(groupPlanDetailContr, conti); 
        Test.stopTest();
    }
    
      static testMethod void PlanBenefitsOverviewWebServiceMethod() {
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
        mapISLWSConfigs.put('dev_GetServiceBenefit', '/api/alpha/eisl/benefits/servicebenefit/v2.0/read');
        mapISLWSConfigs.put('dev_ISLOAuthTokenEndpoint', '/auth/oauth/v2/token');
        mapISLWSConfigs.put('OILTimeout', '3000');
        
        List<ISL_Webservice_Config__c> lstISLWSConfigs = ACETTestDataUtility.CreateISLWebserviceConfigurations(mapISLWSConfigs);
        insert lstISLWSConfigs;
              
        String JSONStr = '{"UHCBS":"","GroupN":"Test Group Name","GroupStatus":"Active","ServiceTeam":"NY Large","EffectiveStartDate":"3/1/2016","RiskManagement":"Rating Method","RatingMethod":"","RenewalDate":"3/1/2016","RelationshipType":"Mother","groupSName":"Test GroupName"}';
        PageReference ACETGroupPlan = Page.ACETGroupPlanBenefitDetailRedesign;
       // Contact cont = TestDataFactory.createContact();
           RecordType newRecord = [SELECT Id FROM RecordType WHERE Name = 'Person Account' and SObjectType = 'Account'];
        
        Account accountTest = new Account();
        accountTest.FirstName = 'Test Contact FN1';
        accountTest.LastName = 'Test Contact LN1';
        accountTest.EID__c = 'TestEID1';
        accountTest.EID__pc = 'TestEID1';
        accountTest.RecordTypeId = newRecord.Id;
        insert accountTest;

    Account oAccount = [SELECT Id,personcontactid from Account where Id=:accountTest.Id];
        Contact cont = [SELECT Id,LastName,FirstName,EID__c,AccountId from Contact where Id=:oAccount.personcontactid];
        
        Interaction__c InteractionId = new Interaction__c();
        InteractionId.Contact_Name__c = 'Text Iname';
        InteractionId.Originator__c = cont.id;
        InteractionId.Originator_Type__c = 'Member';
        InteractionId.Highlight_Panel_GroupInfo__c = JSONStr;
        insert InteractionId;
        StaticResource ResponseJSONSR = [SELECT Body FROM StaticResource WHERE Name = 'Test_GetEmpResponse'];
        String ResponseJSON = ResponseJSONSR.Body.toString();        
        Test.startTest();
            
            MockHttpCalloutResponseGenerator.MockHttpResponse OILResponse = new MockHttpCalloutResponseGenerator.MockHttpResponse(200, 'OK', ResponseJSON);
            OILResponse.TokenExpired = false;
    
            MockHttpCalloutResponseGenerator MockHttpRes = new MockHttpCalloutResponseGenerator(null, OILResponse);
            Test.setMock(HttpCalloutMock.class, MockHttpRes);
                        
           // ACETPlanBenefitsOveriewController planOverviewContr = new ACETPlanBenefitsOveriewController ();
           // planOverviewContr.failureMessage = 'Test Failure';
           // planOverviewContr.BenefitBundleOptionId = '1018479';
           // planOverviewContr.MemberId = ''; 
           // planOverviewContr.makePlanBenefitLanguageCallout();          
            
           // ACETGetSubscriptionBeneJSON2APEX.membership getSub = new ACETGetSubscriptionBeneJSON2APEX.membership();
           // ACETGetSubscriptionBeneJSON2APEX.SubscriberIdentifier subscriberIdentify = new ACETGetSubscriptionBeneJSON2APEX.SubscriberIdentifier();
           // subscriberIdentify.id = 'test if';
           // subscriberIdentify.type = 'test type';
           // getSub.subscriberIdentifier = subscriberIdentify;
          
           ACETGroupPlanBenefitWrapper accumlator = new ACETGroupPlanBenefitWrapper();
                 
        Test.stopTest();
    }
    
    static testMethod void PlanBenefitsOverviewWebServiceMethodd() {
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
        mapISLWSConfigs.put('dev_GetServiceBenefit', '/api/alpha/eisl/benefits/servicebenefit/v2.0/read');
        mapISLWSConfigs.put('dev_ISLOAuthTokenEndpoint', '/auth/oauth/v2/token');
        mapISLWSConfigs.put('OILTimeout', '3000');
        
        List<ISL_Webservice_Config__c> lstISLWSConfigs = ACETTestDataUtility.CreateISLWebserviceConfigurations(mapISLWSConfigs);
        insert lstISLWSConfigs;
              
        String JSONStr = '{"UHCBS":"","GroupN":"Test Group Name","GroupStatus":"Active","ServiceTeam":"NY Large","EffectiveStartDate":"3/1/2016","RiskManagement":"Rating Method","RatingMethod":"","RenewalDate":"3/1/2016","RelationshipType":"Mother","groupSName":"Test GroupName"}';
        PageReference ACETGroupPlan = Page.ACETGroupPlanBenefitDetailRedesign;
       // Contact cont = TestDataFactory.createContact();
         RecordType newRecord = [SELECT Id FROM RecordType WHERE Name = 'Person Account' and SObjectType = 'Account'];
        
        Account accountTest = new Account();
        accountTest.FirstName = 'Test Contact FN1';
        accountTest.LastName = 'Test Contact LN1';
        accountTest.EID__c = 'TestEID1';
        accountTest.EID__pc = 'TestEID1';
        accountTest.RecordTypeId = newRecord.Id;
        insert accountTest;

    Account accountObj = [SELECT Id,personcontactid from Account where Id=:accountTest.Id];
        Contact cont = [SELECT Id,LastName,FirstName,EID__c,AccountId from Contact where Id=:accountObj.personcontactid];
        
            
      
        Interaction__c InteractionId = new Interaction__c();
        InteractionId.Contact_Name__c = 'Text Iname';
        InteractionId.Originator__c = cont.id;
        InteractionId.Originator_Type__c = 'Member';
        InteractionId.Highlight_Panel_GroupInfo__c = JSONStr;
        insert InteractionId;
        StaticResource ResponseJSONSR = [SELECT Body FROM StaticResource WHERE Name = 'GetBenefitLanguageJSON_Bravo'];
        String ResponseJSON = ResponseJSONSR.Body.toString();      
        
          
        Test.startTest();
            
            MockHttpCalloutResponseGenerator.MockHttpResponse OILResponse = new MockHttpCalloutResponseGenerator.MockHttpResponse(200, 'OK', ResponseJSON);
            OILResponse.TokenExpired = false;
    
            MockHttpCalloutResponseGenerator MockHttpRes = new MockHttpCalloutResponseGenerator(null, OILResponse);
            Test.setMock(HttpCalloutMock.class, MockHttpRes);
                        
         //   ACETPlanBenefitsOveriewController planOverviewContr = new ACETPlanBenefitsOveriewController ();
         //   planOverviewContr.failureMessage = 'Test Failure';
        //    planOverviewContr.BenefitBundleOptionId = '12345';
         //   planOverviewContr.MemberId = ''; 
            
            
            ACETGroupPlanBenefitWrapper groupPlanWrap = new ACETGroupPlanBenefitWrapper();
            //Map<String,String> benefitMapping = new  Map<String,String>();
            
            //groupPlanWrap.benefitMapping.put('M000000739','BasePlan');
            groupPlanWrap.benefitMapping = new Map<String,String>();
            groupPlanWrap.benefitAccumulatorMap = new Map<String,List<ACETGroupPlanBenefitWrapper.Accumulator>>();
            groupPlanWrap.benefitMapping.put('M000000739','BasePlan');
            List<ACETGroupPlanBenefitWrapper.Accumulator> accList  = new List<ACETGroupPlanBenefitWrapper.Accumulator>();
            ACETGroupPlanBenefitWrapper.Accumulator acc = new ACETGroupPlanBenefitWrapper.Accumulator();
            acc.coverageLevel = '';
            acc.benefitVersion = '';
            acc.costShareType = '';
            acc.benefitMaximumValue = '';
            acc.benefitMaximumUnit = '';
            acc.benefitRemainingValue = '';
            accList.add(acc);
            groupPlanWrap.benefitAccumulatorMap.put('DURABLE_MEDICAL_EQUIPMENT_OUTPATIENT',accList); 
            groupPlanWrap.mapDateVersion = new Map<String,ACETGroupPlanBenefitWrapper.DateRangeVersion>();
            ACETGroupPlanBenefitWrapper.DateRangeVersion dateV = new ACETGroupPlanBenefitWrapper.DateRangeVersion();
            dateV.dateRange = '1/1/2014-12/12/19999';
            dateV.benefitVersion = '1';
            groupPlanWrap.mapDateVersion.put('DURABLE_MEDICAL_EQUIPMENT_OUTPATIENT',dateV);
            groupPlanWrap.mapDurationAccumulator = new Map<String,String>();
            groupPlanWrap.mapDurationAccumulator.put('DURABLE_MEDICAL_EQUIPMENT_OUTPATIENT','1Calendar Years');
          //  planOverviewContr.ACETPlanBenefitSubscriptionSection = groupPlanWrap;
          //  planOverviewContr.ACETPlanBenefitAccumulatorSection = groupPlanWrap;
          //  planOverviewContr.makePlanBenefitLanguageCallout();
                
            
         //   ACETPlanBenefitLanguageJson2Apex jsonResponse = new ACETPlanBenefitLanguageJson2Apex();
        //    ACETPlanBenefitLanguageJson2Apex.getBenefitLanguageResponse res = new ACETPlanBenefitLanguageJson2Apex.getBenefitLanguageResponse();
            
            Test.stopTest();
    }
    
    static testMethod void hardCodedData() {
        
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
        mapISLWSConfigs.put('dev_GetServiceBenefit', '/api/alpha/eisl/benefits/servicebenefit/v2.0/read');
        mapISLWSConfigs.put('dev_ISLOAuthTokenEndpoint', '/auth/oauth/v2/token');
        mapISLWSConfigs.put('OILTimeout', '3000');
        
        List<ISL_Webservice_Config__c> lstISLWSConfigs = ACETTestDataUtility.CreateISLWebserviceConfigurations(mapISLWSConfigs);
        insert lstISLWSConfigs;
              
        String JSONStr = '{"UHCBS":"","GroupN":"Test Group Name","GroupStatus":"Active","ServiceTeam":"NY Large","EffectiveStartDate":"3/1/2016","RiskManagement":"Rating Method","RatingMethod":"","RenewalDate":"3/1/2016","RelationshipType":"Mother","groupSName":"Test GroupName"}';
        PageReference ACETGroupPlan = Page.ACETGroupPlanBenefitDetailRedesign;
      //  Contact cont = TestDataFactory.createContact();
         RecordType newRecord = [SELECT Id FROM RecordType WHERE Name = 'Person Account' and SObjectType = 'Account'];
        
        Account accountTest = new Account();
        accountTest.FirstName = 'Test Contact FN1';
        accountTest.LastName = 'Test Contact LN1';
        accountTest.EID__c = 'TestEID1';
        accountTest.EID__pc = 'TestEID1';
        accountTest.RecordTypeId = newRecord.Id;
        insert accountTest;

    Account accountObj = [SELECT Id,personcontactid from Account where Id=:accountTest.Id];
        Contact cont = [SELECT Id,LastName,FirstName,EID__c,AccountId from Contact where Id=:accountObj.personcontactid];
        
            
      
        Interaction__c InteractionId = new Interaction__c();
        InteractionId.Contact_Name__c = 'Text Iname';
        InteractionId.Originator__c = cont.id;
        InteractionId.Originator_Type__c = 'Member';
        InteractionId.Highlight_Panel_GroupInfo__c = JSONStr;
        insert InteractionId;
        
        String ResponseJSON = '{"getBenefitLanguageResponse":{"getBenefitLanguageResponse":{"benefitSection":[{"benefitName":"","benefitCode":"","benefitTier":"","benefitLevel":"","benefitVersion":"","benefitTierDescription":"","hipaaService":[{"serviceTypeCode":"88","serviceTypeDescription":"Pharmacy"}],"benefitSubsection":[{"parStatusType":"","benefitCodeGeneralLanguage":"","benefitCodeLanguage":""}]}]}}}';
         
          
        Test.startTest();
            
            MockHttpCalloutResponseGenerator.MockHttpResponse OILResponse = new MockHttpCalloutResponseGenerator.MockHttpResponse(200, 'OK', ResponseJSON);
            OILResponse.TokenExpired = false;
    
            MockHttpCalloutResponseGenerator MockHttpRes = new MockHttpCalloutResponseGenerator(null, OILResponse);
            Test.setMock(HttpCalloutMock.class, MockHttpRes);
                        
           // ACETPlanBenefitsOveriewController planOverviewContr = new ACETPlanBenefitsOveriewController ();
          //  planOverviewContr.failureMessage = 'Test Failure';
          //  planOverviewContr.BenefitBundleOptionId = '12345';
         //   planOverviewContr.MemberId = ''; 
            
            
            ACETGroupPlanBenefitWrapper groupPlanWrap = new ACETGroupPlanBenefitWrapper();
            //Map<String,String> benefitMapping = new  Map<String,String>();
            
            //groupPlanWrap.benefitMapping.put('M000000739','BasePlan');
            groupPlanWrap.benefitMapping = new Map<String,String>();
            groupPlanWrap.benefitAccumulatorMap = new Map<String,List<ACETGroupPlanBenefitWrapper.Accumulator>>();
            groupPlanWrap.benefitMapping.put('M000000739','BasePlan');
            List<ACETGroupPlanBenefitWrapper.Accumulator> accList  = new List<ACETGroupPlanBenefitWrapper.Accumulator>();
            ACETGroupPlanBenefitWrapper.Accumulator acc = new ACETGroupPlanBenefitWrapper.Accumulator();
            acc.coverageLevel = '';
            acc.benefitVersion = '';
            acc.costShareType = '';
            acc.benefitMaximumValue = '';
            acc.benefitMaximumUnit = '';
            acc.benefitRemainingValue = '';
            accList.add(acc);
            groupPlanWrap.benefitAccumulatorMap.put('DURABLE_MEDICAL_EQUIPMENT_OUTPATIENT',accList); 
            groupPlanWrap.mapDateVersion = new Map<String,ACETGroupPlanBenefitWrapper.DateRangeVersion>();
            ACETGroupPlanBenefitWrapper.DateRangeVersion dateV = new ACETGroupPlanBenefitWrapper.DateRangeVersion();
            dateV.dateRange = '1/1/2014-12/12/19999';
            dateV.benefitVersion = '1';
            groupPlanWrap.mapDateVersion.put('DURABLE_MEDICAL_EQUIPMENT_OUTPATIENT',dateV);
            groupPlanWrap.mapDurationAccumulator = new Map<String,String>();
            groupPlanWrap.mapDurationAccumulator.put('DURABLE_MEDICAL_EQUIPMENT_OUTPATIENT','1Calendar Years');
           // planOverviewContr.ACETPlanBenefitSubscriptionSection = groupPlanWrap;
           // planOverviewContr.ACETPlanBenefitAccumulatorSection = groupPlanWrap;
           // planOverviewContr.makePlanBenefitLanguageCallout();
            
           // ACETPlanBenefitsOveriewController planbenovr = new ACETPlanBenefitsOveriewController();
          //  string dt = 'system.today()';
          //  planbenovr.dateRange = dt;
                
          //  ACETPlanBenefitLanguageJson2Apex jsonResponse = new ACETPlanBenefitLanguageJson2Apex();
           // ACETPlanBenefitLanguageJson2Apex.getBenefitLanguageResponse res = new ACETPlanBenefitLanguageJson2Apex.getBenefitLanguageResponse();
            
            Test.stopTest();
    }
    
    static testMethod void GroupPlanDetailExcelMethod() {
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
        oContact.Tax_Id__c = 'TstTaxID1';
        oContact.NPI__c = 'TestNPI1';
        String JSONStr = '{"UHCBS":"","GroupN":"Test Group Name","GroupStatus":"Active","ServiceTeam":"NY Large","EffectiveStartDate":"3/1/2016","RiskManagement":"Rating Method","RatingMethod":"","RenewalDate":"3/1/2016","RelationshipType":"Mother","groupSName":"Test GroupName"}';
        Interaction__c InteractionId = new Interaction__c();
        InteractionId.Contact_Name__c = 'Text Iname';
        InteractionId.Originator__c = oContact.id;
        InteractionId.Originator_Type__c = 'Member';
        InteractionId.Highlight_Panel_GroupInfo__c = JSONStr;
        insert InteractionId;
        
        Map<String,String> copayMapping = new Map<String,String>();
        copayMapping.put('PCP','34');
        copayMapping.put('Specialist','34');
        copayMapping.put('ER Visit','34');
        
        ACETHighlightsPanelAdditionalInfo AdditionalInfo = new ACETHighlightsPanelAdditionalInfo();
        AdditionalInfo.PolicyNumber = 'TestPolicyNumber';
        
    PageReference ACETPlanBenefitExcel = Page.ACETGroupPlanBenefitDetailExcel;
        ACETPlanBenefitExcel.getParameters().put('GroupName','4061351 - Best Buy');
        ACETPlanBenefitExcel.getParameters().put('bundleId','1018481');
        ACETPlanBenefitExcel.getParameters().put('contractId','602613');
        ACETPlanBenefitExcel.getParameters().put('groupNumber','4061351');
        ACETPlanBenefitExcel.getParameters().put('policyNo','1018481');
        ACETPlanBenefitExcel.getParameters().put('effectiveDate','1/1/2018');
        ACETPlanBenefitExcel.getParameters().put('endDate','12/31/2018');
        ACETPlanBenefitExcel.getParameters().put('groupIdName', '4061351 - Best Buy');
        ACETPlanBenefitExcel.getParameters().put('status','Active');
        Test.setCurrentPage(ACETPlanBenefitExcel);
        
        StaticResource ResponseJSONSR = [SELECT Body FROM StaticResource WHERE Name = 'ACETBenefitsAgeBandv3v4'];
        String ResponseJSON = ResponseJSONSR.Body.toString();  
        
        ACETOnshoreIndicatorVerbiage__c verbiage = new ACETOnshoreIndicatorVerbiage__c();
        verbiage.Code__c = 123;
        verbiage.Code_Description__c = 'Claim Transactions';
        verbiage.Hover_Help_Description__c = 'Claim Transactions';
        verbiage.Name = 'Claim Transactions';
        insert verbiage;
        verbiage = new ACETOnshoreIndicatorVerbiage__c();
        verbiage.Code__c = 124;
        verbiage.Code_Description__c = 'All Services Onshore';
        verbiage.Hover_Help_Description__c = 'All Services Onshore';
        verbiage.Name = 'All Services Onshore';
        insert verbiage;
        verbiage = new ACETOnshoreIndicatorVerbiage__c();
        verbiage.Code__c = 125;
        verbiage.Code_Description__c = 'All Services Offshore';
        verbiage.Hover_Help_Description__c = 'All Services Offshore';
        verbiage.Name = 'All Services Offshore';
        insert verbiage;
        
        Test.startTest();

        MockHttpCalloutResponseGenerator.MockHttpResponse OILResponse = new MockHttpCalloutResponseGenerator.MockHttpResponse(200, 'OK', ResponseJSON);
        OILResponse.TokenExpired = false;

        MockHttpCalloutResponseGenerator MockHttpRes = new MockHttpCalloutResponseGenerator(null, OILResponse);
        Test.setMock(HttpCalloutMock.class, MockHttpRes);    
        PageReference ACETGroupPlan = Page.ACETGroupPlanBenefitDetailRedesign;
        ACETGroupPlan.getParameters().put('interactionId', InteractionId.Id);
        ACETGroupPlan.getParameters().put('stateName', 'CT');
        ACETGroupPlan.getParameters().put('GroupName','4061351 - Best Buy');
        ACETGroupPlan.getParameters().put('bundleId','1018481');
        ACETGroupPlan.getParameters().put('contractId','602613');
        ACETGroupPlan.getParameters().put('groupNumber','4061351');
		ACETGroupPlan.getParameters().put('groupId','4061351');
        ACETGroupPlan.getParameters().put('policyNo','1018481');
        ACETGroupPlan.getParameters().put('effectiveDate','1/1/2018');
        ACETGroupPlan.getParameters().put('endDate','12/31/2018');
        ACETGroupPlan.getParameters().put('groupIdName', '4061351 - Best Buy');
        ACETGroupPlan.getParameters().put('status','Active');
        Test.setCurrentPage(ACETGroupPlan);
        
        ACETGroupPlanDetailControllerRedesign groupPlanDetailContr = new ACETGroupPlanDetailControllerRedesign(); 
        ACETGroupPlanBenefitExcelController groupPlanExcel = new ACETGroupPlanBenefitExcelController();
        groupPlanDetailContr.copayMapping = copayMapping;
        groupPlanExcel.CallWSOnPageLoad();

        groupPlanExcel.ChangeDateFormatForOIL('12/31/2018');

        
       // Continuation conti = (Continuation)groupPlanDetailContr.CallWSOnBenefitsTabClick();     
      //  Map<String, HttpRequest> requests = conti.getRequests();
       // system.assertEquals(1, requests.size());
        
        HttpResponse response;
        HttpRequest request;
        
      /*  for(String RequestLabel: requests.keyset()){
            request = requests.get(RequestLabel);
            response = new HttpResponse();
            response.setStatusCode(200);
            response.setStatus('OK');
            if (request.getEndpoint().contains('/api/bravo/eisl/benefits/servicebenefit/v2.0/read')) {
                response.setBody(ACETTestDataUtility.getSubscriptionBenefitResponse());
            }       
            Test.setContinuationResponse(RequestLabel, response); 
        } */
       // Object result = Test.invokeContinuationMethod(groupPlanDetailContr, conti); 
        Test.stopTest();
    }
    
    
    static testMethod void GroupPlanDetailExcelMethod2() {
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
        oContact.Tax_Id__c = 'TstTaxID1';
        oContact.NPI__c = 'TestNPI1';
        
        String JSONStr = '{"UHCBS":"","GroupN":"Test Group Name","GroupStatus":"Active","ServiceTeam":"NY Large","EffectiveStartDate":"3/1/2016","RiskManagement":"Rating Method","RatingMethod":"","RenewalDate":"3/1/2016","RelationshipType":"Mother","groupSName":"Test GroupName"}';
        Interaction__c InteractionId = new Interaction__c();
        InteractionId.Contact_Name__c = 'Text Iname';
        InteractionId.Originator__c = oContact.id;
        InteractionId.Originator_Type__c = 'Member';
        InteractionId.Highlight_Panel_GroupInfo__c = JSONStr;
        insert InteractionId;
        
        Map<String,String> copayMapping = new Map<String,String>();
        copayMapping.put('PCP','34');
        copayMapping.put('Specialist','34');
        copayMapping.put('ER Visit','34');
        
        ACETHighlightsPanelAdditionalInfo AdditionalInfo = new ACETHighlightsPanelAdditionalInfo();
        AdditionalInfo.PolicyNumber = 'TestPolicyNumber';
        
    PageReference ACETPlanBenefitExcel = Page.ACETGroupPlanBenefitDetailExcel;
        ACETPlanBenefitExcel.getParameters().put('GroupName','1068479 - INGERSOLL AUTO GROUP INC.');
        ACETPlanBenefitExcel.getParameters().put('bundleId','1018485');
        ACETPlanBenefitExcel.getParameters().put('contractId','602615');
        ACETPlanBenefitExcel.getParameters().put('groupNumber','1068479');
        ACETPlanBenefitExcel.getParameters().put('policyNo','1018485');
        ACETPlanBenefitExcel.getParameters().put('effectiveDate','1/1/2018');
        ACETPlanBenefitExcel.getParameters().put('endDate','12/31/2018');
        ACETPlanBenefitExcel.getParameters().put('groupIdName', '1068479 - INGERSOLL AUTO GROUP INC.');
        ACETPlanBenefitExcel.getParameters().put('status','Active');
        Test.setCurrentPage(ACETPlanBenefitExcel);
        
        StaticResource ResponseJSONSR = [SELECT Body FROM StaticResource WHERE Name = 'Test_GetEmpResponse'];
        String ResponseJSON = ResponseJSONSR.Body.toString();  
        
        ACETOnshoreIndicatorVerbiage__c verbiage = new ACETOnshoreIndicatorVerbiage__c();
        verbiage.Code__c = 123;
        verbiage.Code_Description__c = 'Claim Transactions';
        verbiage.Hover_Help_Description__c = 'Claim Transactions';
        verbiage.Name = 'Claim Transactions';
        insert verbiage;
        verbiage = new ACETOnshoreIndicatorVerbiage__c();
        verbiage.Code__c = 124;
        verbiage.Code_Description__c = 'All Services Onshore';
        verbiage.Hover_Help_Description__c = 'All Services Onshore';
        verbiage.Name = 'All Services Onshore';
        insert verbiage;
        verbiage = new ACETOnshoreIndicatorVerbiage__c();
        verbiage.Code__c = 125;
        verbiage.Code_Description__c = 'All Services Offshore';
        verbiage.Hover_Help_Description__c = 'All Services Offshore';
        verbiage.Name = 'All Services Offshore';
        insert verbiage;
        
        Test.startTest();

        MockHttpCalloutResponseGenerator.MockHttpResponse OILResponse = new MockHttpCalloutResponseGenerator.MockHttpResponse(200, 'OK', ResponseJSON);
        OILResponse.TokenExpired = false;

        MockHttpCalloutResponseGenerator MockHttpRes = new MockHttpCalloutResponseGenerator(null, OILResponse);
        Test.setMock(HttpCalloutMock.class, MockHttpRes);    
        PageReference ACETGroupPlan = Page.ACETGroupPlanBenefitDetailRedesign;
        ACETGroupPlan.getParameters().put('interactionId', InteractionId.Id);
        ACETGroupPlan.getParameters().put('stateName', 'CT');
        ACETGroupPlan.getParameters().put('GroupName','1068479 - INGERSOLL AUTO GROUP INC.');
        ACETGroupPlan.getParameters().put('bundleId','1018485');
        ACETGroupPlan.getParameters().put('contractId','602615');
        ACETGroupPlan.getParameters().put('groupNumber','1068479');
		ACETGroupPlan.getParameters().put('groupId','1068479');
        ACETGroupPlan.getParameters().put('policyNo','1018485');
        ACETGroupPlan.getParameters().put('effectiveDate','1/1/2018');
        ACETGroupPlan.getParameters().put('endDate','12/31/2018');
        ACETGroupPlan.getParameters().put('groupIdName', '1068479 - INGERSOLL AUTO GROUP INC.');
        ACETGroupPlan.getParameters().put('status','Active');
        Test.setCurrentPage(ACETGroupPlan);
        
        ACETGroupPlanDetailControllerRedesign groupPlanDetailContr = new ACETGroupPlanDetailControllerRedesign(); 
        ACETGroupPlanBenefitExcelController groupPlanExcel = new ACETGroupPlanBenefitExcelController();
        groupPlanDetailContr.copayMapping = copayMapping;
        groupPlanExcel.CallWSOnPageLoad();
        groupPlanExcel.ChangeDateFormatForOIL('12/31/2018');

        
       // Continuation conti = (Continuation)groupPlanDetailContr.CallWSOnBenefitsTabClick();     
      //  Map<String, HttpRequest> requests = conti.getRequests();
       // system.assertEquals(1, requests.size());
        
        HttpResponse response;
        HttpRequest request;
        
      /*  for(String RequestLabel: requests.keyset()){
            request = requests.get(RequestLabel);
            response = new HttpResponse();
            response.setStatusCode(200);
            response.setStatus('OK');
            if (request.getEndpoint().contains('/api/bravo/eisl/benefits/servicebenefit/v2.0/read')) {
                response.setBody(ACETTestDataUtility.getSubscriptionBenefitResponse());
            }       
            Test.setContinuationResponse(RequestLabel, response); 
        } */
       // Object result = Test.invokeContinuationMethod(groupPlanDetailContr, conti); 
        Test.stopTest();
    }
    static testMethod void GroupPlanDetailExcelMethod3() {
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
        oContact.Tax_Id__c = 'TstTaxID1';
        oContact.NPI__c = 'TestNPI1';
        String JSONStr = '{"UHCBS":"","GroupN":"Test Group Name","GroupStatus":"Active","ServiceTeam":"NY Large","EffectiveStartDate":"3/1/2016","RiskManagement":"Rating Method","RatingMethod":"","RenewalDate":"3/1/2016","RelationshipType":"Mother","groupSName":"Test GroupName"}';
        Interaction__c InteractionId = new Interaction__c();
        InteractionId.Contact_Name__c = 'Text Iname';
        InteractionId.Originator__c = oContact.id;
        InteractionId.Originator_Type__c = 'Member';
        InteractionId.Highlight_Panel_GroupInfo__c = JSONStr;
        insert InteractionId;
        
        Map<String,String> copayMapping = new Map<String,String>();
        copayMapping.put('PCP','34');
        copayMapping.put('Specialist','34');
        copayMapping.put('ER Visit','34');
        
        ACETHighlightsPanelAdditionalInfo AdditionalInfo = new ACETHighlightsPanelAdditionalInfo();
        AdditionalInfo.PolicyNumber = 'TestPolicyNumber';
        
    PageReference ACETPlanBenefitExcel = Page.ACETGroupPlanBenefitDetailExcel;
        ACETPlanBenefitExcel.getParameters().put('GroupName','4061351 - Best Buy');
        ACETPlanBenefitExcel.getParameters().put('bundleId','1018480');
        ACETPlanBenefitExcel.getParameters().put('contractId','602613');
        ACETPlanBenefitExcel.getParameters().put('groupNumber','4061351');
        ACETPlanBenefitExcel.getParameters().put('policyNo','1018480');
        ACETPlanBenefitExcel.getParameters().put('effectiveDate','1/1/2018');
        ACETPlanBenefitExcel.getParameters().put('endDate','12/31/2018');
        ACETPlanBenefitExcel.getParameters().put('groupIdName', '4061351 - Best Buy');
        ACETPlanBenefitExcel.getParameters().put('status','Active');
        Test.setCurrentPage(ACETPlanBenefitExcel);
        
        StaticResource ResponseJSONSR = [SELECT Body FROM StaticResource WHERE Name = 'ACETBenefitsAgeBandv3v4'];
        String ResponseJSON = ResponseJSONSR.Body.toString();  
        
        ACETOnshoreIndicatorVerbiage__c verbiage = new ACETOnshoreIndicatorVerbiage__c();
        verbiage.Code__c = 123;
        verbiage.Code_Description__c = 'Claim Transactions';
        verbiage.Hover_Help_Description__c = 'Claim Transactions';
        verbiage.Name = 'Claim Transactions';
        insert verbiage;
        verbiage = new ACETOnshoreIndicatorVerbiage__c();
        verbiage.Code__c = 124;
        verbiage.Code_Description__c = 'All Services Onshore';
        verbiage.Hover_Help_Description__c = 'All Services Onshore';
        verbiage.Name = 'All Services Onshore';
        insert verbiage;
        verbiage = new ACETOnshoreIndicatorVerbiage__c();
        verbiage.Code__c = 125;
        verbiage.Code_Description__c = 'All Services Offshore';
        verbiage.Hover_Help_Description__c = 'All Services Offshore';
        verbiage.Name = 'All Services Offshore';
        insert verbiage;
        
        Test.startTest();

        MockHttpCalloutResponseGenerator.MockHttpResponse OILResponse = new MockHttpCalloutResponseGenerator.MockHttpResponse(200, 'OK', ResponseJSON);
        OILResponse.TokenExpired = false;

        MockHttpCalloutResponseGenerator MockHttpRes = new MockHttpCalloutResponseGenerator(null, OILResponse);
        Test.setMock(HttpCalloutMock.class, MockHttpRes);    
        PageReference ACETGroupPlan = Page.ACETGroupPlanBenefitDetailRedesign;
        ACETGroupPlan.getParameters().put('interactionId', InteractionId.Id);
        ACETGroupPlan.getParameters().put('stateName', 'CT');
        ACETGroupPlan.getParameters().put('GroupName','4061351 - Best Buy');
        ACETGroupPlan.getParameters().put('bundleId','1018480');
        ACETGroupPlan.getParameters().put('contractId','612766');
        ACETGroupPlan.getParameters().put('groupNumber','4061351');
        ACETGroupPlan.getParameters().put('groupId','4061351');
        ACETGroupPlan.getParameters().put('policyNo','1018480');
        ACETGroupPlan.getParameters().put('effectiveDate','1/1/2021');
        ACETGroupPlan.getParameters().put('endDate','12/31/2022');
        ACETGroupPlan.getParameters().put('groupIdName', '4061351 - Best Buy');
        ACETGroupPlan.getParameters().put('status','Active');
        Test.setCurrentPage(ACETGroupPlan);
        
        ACETGroupPlanDetailControllerRedesign groupPlanDetailContr = new ACETGroupPlanDetailControllerRedesign(); 
        ACETGroupPlanBenefitExcelController groupPlanExcel = new ACETGroupPlanBenefitExcelController();
    groupPlanDetailContr.copayMapping = copayMapping;
        groupPlanExcel.CallWSOnPageLoad();
    groupPlanExcel.ChangeDateFormatForOIL('12/31/2018');

        
       // Continuation conti = (Continuation)groupPlanDetailContr.CallWSOnBenefitsTabClick();     
      //  Map<String, HttpRequest> requests = conti.getRequests();
       // system.assertEquals(1, requests.size());
        
        HttpResponse response;
        HttpRequest request;
        
      /*  for(String RequestLabel: requests.keyset()){
            request = requests.get(RequestLabel);
            response = new HttpResponse();
            response.setStatusCode(200);
            response.setStatus('OK');
            if (request.getEndpoint().contains('/api/bravo/eisl/benefits/servicebenefit/v2.0/read')) {
                response.setBody(ACETTestDataUtility.getSubscriptionBenefitResponse());
            }       
            Test.setContinuationResponse(RequestLabel, response); 
        } */
       // Object result = Test.invokeContinuationMethod(groupPlanDetailContr, conti); 
        Test.stopTest();
    }

}