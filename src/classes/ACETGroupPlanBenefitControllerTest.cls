@isTest
public class ACETGroupPlanBenefitControllerTest {
    public static testMethod void ACETGroupPlanBenefitControllerMethod1() {
        String JSONStr = '{"UHCBS":"","GroupN":"Test Group Name","GroupStatus":"Active","ServiceTeam":"NY Large","EffectiveStartDate":"3/1/2016","RiskManagement":"Rating Method","RatingMethod":"","RenewalDate":"3/1/2016","RelationshipType":"Mother","groupSName":"Test GroupName", "additionalInfo":"Testing"}';
        PageReference ACETGroupPlan = Page.ACETGroupPlanBenefit;
        Contact cont = TestDataFactory.createContact();
        Interaction__c InteractionId = new Interaction__c();
        InteractionId.Contact_Name__c = 'Text Iname';
        InteractionId.Originator__c = cont.id;
        InteractionId.Originator_Type__c = 'Member';
        InteractionId.Highlight_Panel_GroupInfo__c = JSONStr;
        insert InteractionId;
        ACETGroupPlan.getParameters().put('InteractionId', InteractionId.Id);
        ACETGroupPlan.getParameters().put('groupId', '1234567');
        Test.setCurrentPage(ACETGroupPlan);
        ACETGroupDetail groupDetail = new ACETGroupDetail();
        
        Test.startTest();
        ACETGroupPlanBenefitController groupPlanContr = new ACETGroupPlanBenefitController();
        groupPlanContr.IsShowActiveCoveragesOnly = true;
        groupPlanContr.groupDetails = groupDetail;
        groupPlanContr.toggleShowPlanBenefits();
        groupPlanContr.Subject = cont;
        boolean b = true;
        groupPlanContr.notResearchUser = b;
        ACETCallTopicsDataWrapper acetCallTopicDW = new ACETCallTopicsDataWrapper();
        acetCallTopicDW.saveCase();
        Test.stopTest();
    }
    
    public static testMethod void ACETCallTopicsDataWrapper1() {
        String JSONStr = '{"UHCBS":"","GroupN":"Test Group Name","GroupStatus":"Active","ServiceTeam":"NY Large","EffectiveStartDate":"3/1/2016","RiskManagement":"Rating Method","RatingMethod":"","RenewalDate":"3/1/2016","RelationshipType":"Mother","groupSName":"Test GroupName", "additionalInfo":"Testing"}';
        PageReference ACETGroupPlan = Page.ACETGroupPlanBenefit;
        Contact cont = TestDataFactory.createContact();
        Interaction__c InteractionId = new Interaction__c();
        InteractionId.Contact_Name__c = 'Text Iname';
        InteractionId.Originator__c = cont.id;
        InteractionId.Originator_Type__c = 'Group';
        InteractionId.Highlight_Panel_GroupInfo__c = JSONStr;
        insert InteractionId;
        ACETGroupPlan.getParameters().put('InteractionId', InteractionId.Id);
        ACETGroupPlan.getParameters().put('groupId', '1234567');
        ACETGroupPlan.getParameters().put('onshoreCode', '06');
        Test.setCurrentPage(ACETGroupPlan);
        ACETGroupDetail groupDetail = new ACETGroupDetail();
        
        Test.startTest();
        ACETGroupPlanBenefitController groupPlanContr = new ACETGroupPlanBenefitController();
        groupPlanContr.IsShowActiveCoveragesOnly = true;
        groupPlanContr.groupDetails = groupDetail;
        groupPlanContr.toggleShowPlanBenefits();
        groupPlanContr.Subject = cont;
        boolean b = true;
        groupPlanContr.notResearchUser = b;
        ACETCallTopicsDataWrapper acetCallTopicDW = new ACETCallTopicsDataWrapper();
        acetCallTopicDW.AutodocCaseItems = 'test1::test2';
        acetCallTopicDW.saveCase();
        Test.stopTest();
    }
        public static testMethod void ACETCallTopicsDataWrapper2() {
        String JSONStr = '{"UHCBS":"","GroupN":"Test Group Name","GroupStatus":"Active","ServiceTeam":"NY Large","EffectiveStartDate":"3/1/2016","RiskManagement":"Rating Method","RatingMethod":"","RenewalDate":"3/1/2016","RelationshipType":"Mother","groupSName":"Test GroupName", "additionalInfo":"Testing"}';
        PageReference ACETGroupPlan = Page.ACETGroupPlanBenefit;
        Contact cont = TestDataFactory.createContact();
        Interaction__c InteractionId = new Interaction__c();
        InteractionId.Contact_Name__c = 'Text Iname';
        InteractionId.Originator__c = cont.id;
        InteractionId.Originator_Type__c = 'Group';
        InteractionId.Highlight_Panel_GroupInfo__c = JSONStr;
        insert InteractionId;
        ACETGroupPlan.getParameters().put('InteractionId', InteractionId.Id);
        ACETGroupPlan.getParameters().put('groupId', '1234567');
        ACETGroupPlan.getParameters().put('onshoreCode', '04');
        Test.setCurrentPage(ACETGroupPlan);
        ACETGroupDetail groupDetail = new ACETGroupDetail();
        
        Test.startTest();
        ACETGroupPlanBenefitController groupPlanContr = new ACETGroupPlanBenefitController();
        groupPlanContr.IsShowActiveCoveragesOnly = true;
        groupPlanContr.groupDetails = groupDetail;
        groupPlanContr.toggleShowPlanBenefits();
        groupPlanContr.Subject = cont;
        boolean b = true;
        groupPlanContr.notResearchUser = b;
        ACETCallTopicsDataWrapper acetCallTopicDW = new ACETCallTopicsDataWrapper();
        acetCallTopicDW.saveCase();
        Test.stopTest();
    }
    public static testMethod void ACETGroupPlanWebServiceMethod() {
        ACETGroupPlanBenefitController groupPlanContr = new ACETGroupPlanBenefitController();   
        Contact cont = TestDataFactory.createContact();
        //MockHttpCalloutResponseGenerator.MockHttpResponse OILResponse = new MockHttpCalloutResponseGenerator.MockHttpResponse(200, 'OK', ACETTestDataUtility.getEmployerGroupDetailJson());
        StaticResource GetDummyResp = [SELECT Body FROM StaticResource WHERE Name = 'Test_GetEmpResponse'];
        String GetEmpGrpRes = GetDummyResp.Body.toString();
        System.debug('%%%%%%% test' + GetEmpGrpRes);
        MockHttpCalloutResponseGenerator.MockHttpResponse OILResponse = new MockHttpCalloutResponseGenerator.MockHttpResponse(200, 'OK', GetEmpGrpRes);
        OILResponse.TokenExpired = false;
        
        MockHttpCalloutResponseGenerator MockHttpRes = new MockHttpCalloutResponseGenerator(null, OILResponse);
        Test.setMock(HttpCalloutMock.class, MockHttpRes);
        
        // Set mock callout class 
        Test.setMock(HttpCalloutMock.class, MockHttpRes);
        ACETGroupDetail groupDetail = new ACETGroupDetail();
        ACETCallTopicsDataWrapper acetCallTopicDW = new ACETCallTopicsDataWrapper();
        Test.startTest();
            groupPlanContr.groupNumber='3797692017185927';
            groupPlanContr.init();
            groupPlanContr.IsShowActiveCoveragesOnly = true;
            groupPlanContr.groupDetails = groupDetail;
            groupPlanContr.toggleShowPlanBenefits();
            groupPlanContr.Subject = cont;
            ACETGroupDetail.GroupPlanWrapper grp = new ACETGroupDetail.GroupPlanWrapper();
            grp.PlanClass = 'terst';
            grp.stateOfIssueCode = 'test';
            list<ACETGroupDetail.GroupPlanWrapper> lst = new list<ACETGroupDetail.GroupPlanWrapper>();
        ACETGroupPlanBenefitController.GroupPlanSearchResults = new list<ACETGroupDetail.GroupPlanWrapper>{grp};
            acetCallTopicDW.saveCase(); 
        Test.stopTest();
        system.AssertNotEquals(acetCallTopicDW.caseObj.id, null);
    }
    
    public static testMethod void testMissingElementWrapper() {
        ACETGroupPlanBenefitWrapper wrap = new ACETGroupPlanBenefitWrapper();
        wrap.hippaServiceMap = new Map<String,String>();
        wrap.hippakeyStr = 'test';
        wrap.benefitCodeKeyMap = new Map<String,String>();
        wrap.OONReimbursementMap = new Map<String,String>();
        wrap.benefitRedesignWrapperList = new Map<String, Map<String, List<ACETGroupPlanBenefitWrapper.BenefitSubSection>>>();
        wrap.hippaBenefitCodeJSON = 'test';
        wrap.coPayingMap = new Map<String, String>();
        wrap.varriableCoverageMap = new Map<String, String>();
       ACETGroupPlanBenefitWrapper.BenefitDetailsWrapper samp = new ACETGroupPlanBenefitWrapper.BenefitDetailsWrapper();
        samp.BenefitCode ='test';
        samp.BenefitType ='test';
        samp.BenefitSubSection = new List<ACETGroupPlanBenefitWrapper.BenefitSubSection>();
        ACETGroupPlanBenefitWrapper.BenefitSubSection benfsub = new ACETGroupPlanBenefitWrapper.BenefitSubSection();
        benfsub.benefitLevel = 'test';
        benfsub.benefitCodeGeneralLanguage='';
        benfsub.benefitCodeLanguage ='';
        benfsub.benefitVersion='';
        benfsub.ageFrom='';
        benfsub.ageFromDuration='';
        benfsub.ageThrough='';
        benfsub.ageThroughDuration='';
        benfsub.networkId='';
        benfsub.relationshipCode ='';
        benfsub.coverageIndicator='';
        ACETGroupPlanBenefitWrapper.BenefitWrapper bwrap2 = new ACETGroupPlanBenefitWrapper.BenefitWrapper();
        bwrap2.Benefit='';
        bwrap2.BenefitCode='';
        bwrap2.BenefitType='';
        bwrap2.riderCoverageType='';
        bwrap2.riderBenefitPlanId='';
        bwrap2.riderGated='';
        bwrap2.riderCarrierName='';
        bwrap2.riderProductName='';
        bwrap2.riderProductId='';
        bwrap2.riderPlanTypeCode='';
        bwrap2.riderPlanName ='';
        ACETGroupPlanBenefitWrapper.PlanBenefitRiderWrapper wrap3 = new ACETGroupPlanBenefitWrapper.PlanBenefitRiderWrapper();
        wrap3.riderCoverageType='';
        wrap3.riderBenefitPlanId='';
        wrap3.riderGated='';
        wrap3.riderCarrierName='';
        wrap3.riderProductName='';
        wrap3.riderProductId='';
        wrap3.riderPlanTypeCode='';
        wrap3.riderPlanName ='';
        ACETGroupPlanBenefitWrapper.OONReimbursement wrap4 = new ACETGroupPlanBenefitWrapper.OONReimbursement();
        wrap4.OONPricingType='';
        wrap4.Percentile ='';
        wrap.IndividualAccumulatorRedesignList = new List<ACETGroupPlanBenefitWrapper.AccumulatorRedesignWrapper>();
        wrap.FamilyAccumulatorRedesignList = new List<ACETGroupPlanBenefitWrapper.AccumulatorRedesignWrapper>();
        ACETGroupPlanBenefitWrapper.AccumulatorRedesignWrapper wrap5 = new  ACETGroupPlanBenefitWrapper.AccumulatorRedesignWrapper();
        wrap5.accumulatorDeductibleLimit='';
        wrap5.accumulatorDeductibleRemaining='';
        wrap5.accumulatorDeductibleSatisfied='';
        wrap5.accumulatorOOPLimit='';
        wrap5.accumulatorOOPRemaining='';
        wrap5.accumulatorOOPSatisfied='';
        wrap5.coinsurance=0;
        wrap5.primaryAccumDeduct='';
        wrap5.primaryAccumDescOOP='';
        wrap5.TypeCode='';
    } 
}