@IsTest
public class ACETBenefitCoverageOverviewTest {
    public static testmethod void test(){
        ACETBenefitCoverageOverviewController abcoc = new ACETBenefitCoverageOverviewController();
        abcoc.dateSearch = new ACETAccumAsOfWrapper();
        abcoc.accumasOfDate();
        abcoc.getGroupFamilyAccs();
        abcoc.ACETPlanBenefitSearchResults = new ACETGroupPlanBenefitWrapper();
        abcoc.ACETPlanBenefitSearchResults.coPayingMap = new Map<String,String>{'PCP'=>'PCP',
            'Specialist'=>'Specialist',
            'ER'=>'ER',
            'Urgent Care'=>'Urgent Care',
            'Virtual Visit'=>'Virtual Visit'};
        System.debug(abcoc.getCoPayList());
        abcoc.getGroupIndividualAccs();
        System.debug(abcoc.OONReimbursementList);
        System.debug(abcoc.FamilyAccs);
        System.debug(abcoc.covrgLevel);
        System.debug(abcoc.EffectiveDate);
        System.debug(abcoc.PlanType);
        System.debug(abcoc.CoverageEndDate);
        System.debug(abcoc.ACETdateSearchResults);  
        abcoc.EndDate = '12/27/2009';
        abcoc.EffectiveDate = '12/27/2007';      
        abcoc.populateDate(); 
        abcoc.EndDate = '12/27/2020';
        abcoc.EffectiveDate = '12/27/2018';      
        abcoc.populateDate(); 
        abcoc.EndDate = '12/27/2021';
        abcoc.EffectiveDate = '12/27/2020';      
        abcoc.populateDate();
        abcoc.ACETPlanBenefitSearchResults.accumulatorList = new List<ACETGroupPlanBenefitWrapper.AccumulatorP>{new ACETGroupPlanBenefitWrapper.AccumulatorP()};
        System.debug(abcoc.IndividualAccs);
    }
}