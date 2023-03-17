@isTest
public class ACETLinkCoveragesResultTest {
    static testmethod void test1() {
        Test.startTest();
        ACETLinkCoveragesResult linkCov = new ACETLinkCoveragesResult();
        //CoverageLine cl = new CoverageLine();
        //Boolean result = cl.getIsActive();
        //linkCov.ACETLinkCoveragesResult();
        
        ACETLinkCoveragesResult linkCov1 = new ACETLinkCoveragesResult();
        linkCov1.MemberId = 'test';
        linkCov1.fullName = 'test';
        linkCov1.gender = 'test';
        
        ACETLinkCoveragesResult.CoverageLine covLine = new ACETLinkCoveragesResult.CoverageLine();
        covLine.isFuture = true;
        covLine.isAdvanceSearched = true;
        covLine.isSubscriber = true;
        covLine.isPreferred = true;
        covLine.nonMedicalPolicyBoolean = true;
        covLine.highlightedPolicy = true;
        covLine.ITEhighlightedPolicyId = true;
        covLine.isActive = true;
        covLine.CoverageTypeCode = 'test';
        covLine.CoverageType = 'test';
        covLine.eligibleDates = 'test';
        covLine.referral = 'test';
        covLine.planStatus = 'test';
        covLine.PolicyNumber = 'test';
        covLine.PolicyName = 'test';
        covLine.GroupNumber = 'test';
        covLine.GroupName = 'test';
        covLine.Product = 'test';
        covLine.ProductType = 'test';
        covLine.Network = 'test';
        covLine.EffectiveDate = '06/05/2011';
        covLine.EndDate = '06/05/2012';
        covLine.SourceCode = 'test';
        covLine.CoverageLevel = 'test';
        covLine.FundingArrangement = 'test';
        covLine.BenefitPlanId = 'test';
        covLine.SurrogateKey = 'test';
        covLine.OnshoreRestriction = 'test';
        covLine.OnshoreRestrictionVerbiage = 'test';
        covLine.EnrolleeSurrogateKey = 'test';
        covLine.onshoreRestrictionCode = 'test';
        covLine.relationShipCode = 'test';
        covLine.daysGap = 1;
        covLine.contractOptionId= 'test';
        covLine.continuationResponsibilityType= 'test';
        covLine.insuranceContinuationType= 'test';
        covLine.transactionId = 'test';
        covLine.concatAddress = 'test';
        covLine.addressLine1 = 'test';
        covLine.city = 'test';
        covLine.state = 'test';
        covLine.zip = 'test';
        covLine.PlanSitusState = 'test';
        
        covLine.getIsActive();
        Test.stopTest();
    }
    
}