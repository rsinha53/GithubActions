public class ACETGroupPlanBenefitLEXWrapper {
    
    // IN NETWORK
    @AuraEnabled public String IIN_PLAN_MIN;
    @AuraEnabled public String IIN_PLAN_MAX;
    @AuraEnabled public String IIN_OOP_MIN;
    @AuraEnabled public String IIN_OOP_MAX;
    @AuraEnabled public String FIN_PLAN_MIN;
    @AuraEnabled public String FIN_PLAN_MAX;
    @AuraEnabled public String FIN_OOP_MIN;
    @AuraEnabled public String FIN_OOP_MAX;
    @AuraEnabled public String IIN_Primary_Accum_Deduct;
    @AuraEnabled public String IIN_Primary_Accum_OOP;
    @AuraEnabled public String FIN_Primary_Accum_Deduct;
    @AuraEnabled public String FIN_Primary_Accum_OOP;
    
    // OUT NETWORK
    @AuraEnabled public String ION_PLAN_MIN;
    @AuraEnabled public String ION_PLAN_MAX;
    @AuraEnabled public String ION_OOP_MIN;
    @AuraEnabled public String ION_OOP_MAX;
    @AuraEnabled public String FON_PLAN_MIN;
    @AuraEnabled public String FON_PLAN_MAX;
    @AuraEnabled public String FON_OOP_MIN;
    @AuraEnabled public String FON_OOP_MAX;
	@AuraEnabled public String ION_Primary_Accum_Deduct;
    @AuraEnabled public String ION_Primary_Accum_OOP;
    @AuraEnabled public String FON_Primary_Accum_Deduct;
    @AuraEnabled public String FON_Primary_Accum_OOP;
    
    // PROGRESSBAR VALUES
    @AuraEnabled public Double IIN_PLAN_PROGRESS;
    @AuraEnabled public Double IIN_OOP_PROGRESS;
    @AuraEnabled public Double FIN_PLAN_PROGRESS;
    @AuraEnabled public Double FIN_OOP_PROGRESS;
    @AuraEnabled public Double ION_PLAN_PROGRESS;
    @AuraEnabled public Double ION_OOP_PROGRESS;
    @AuraEnabled public Double FON_PLAN_PROGRESS;
    @AuraEnabled public Double FON_OOP_PROGRESS;
    
    //OTHER RELATED VALUES
    @AuraEnabled public String TIME_PERIOD_QUALIFIER;
    @AuraEnabled public String PLAN_CALENDAR_YEAR;
    @AuraEnabled public String AS_OF_DATE;
    

    public void initProgressBar(){
        IIN_PLAN_PROGRESS = calProgressBar(IIN_PLAN_MIN, IIN_PLAN_MAX);
        IIN_OOP_PROGRESS = calProgressBar(IIN_OOP_MIN, IIN_OOP_MAX);
        
        system.debug('IIN_OOP_PROGRESS:::'+IIN_OOP_PROGRESS);
        
        FIN_PLAN_PROGRESS = calProgressBar(FIN_PLAN_MIN, FIN_PLAN_MAX);
        FIN_OOP_PROGRESS = calProgressBar(FIN_OOP_MIN, FIN_OOP_MAX);
        ION_PLAN_PROGRESS = calProgressBar(ION_PLAN_MIN, ION_PLAN_MAX);
        ION_OOP_PROGRESS = calProgressBar(ION_OOP_MIN, ION_OOP_MAX);
        FON_PLAN_PROGRESS = calProgressBar(FON_PLAN_MIN, FON_PLAN_MAX);
        FON_OOP_PROGRESS = calProgressBar(FON_OOP_MIN, FON_OOP_MAX);
    }

    public String validateValue(String strVal){
        return ( (strVal == null || strVal == '') ? 'N/A' : strVal );
    }

    public Double calProgressBar(String strVal1, String strVal2){
        if(strVal1 == 'N/A' || strVal2 == 'N/A'){
            return 0;   
        }
        Double dVal1 = Double.valueOf(strVal1);
        Double dVal2 = Double.valueOf(strVal2);
        
        system.debug('::: Values ::: '+dVal1+' -- '+dVal2);
        system.debug((dVal1/(0 < dVal2 ? dVal2 : 1))*100);
        
        return ((dVal1/(0 < dVal2 ? dVal2 : 1))*100);
    }
    
    
    //Redesign : Added by Lahiru
   public Map<String,String> benefitMapping {get; set;}
   public Map<String,String> hippaServiceMap {get; set;}
   public Map<String,List<ACETGroupPlanBenefitLEXWrapper.Accumulator>> benefitAccumulatorMap {get; set;}
   public string hippakeyStr {get; set;}
    @AuraEnabled public string eHBIndicator {get;set;}
   //Provider Lookup Page
   @AuraEnabled public map<string,string> tierDescMap {get;set;} 
   public set<string> claimTypeList {get;set;} 
   @AuraEnabled public Map<string,string> sAreaType {get;set;} 
    //public map<string,List<ACETGetSubscriptionRedesignJSON2APEX.network>> networkMap {get;set;}
    @AuraEnabled public map<string,List<String>> networkMap {get;set;}
    @AuraEnabled  public set<string> benefitServiceSet {get;set;}
    public list<string> carId {get;set;}
    
   // Benefit Section
    @AuraEnabled public List<BenefitWrapper> benefitWrapperList {get; set;}
    @AuraEnabled public Map<String, String> benefitCodeKeyMap {get; set;}
    @AuraEnabled public Map<String, String> benefitCodeRiderPlanmap {get; set;}

    public List<String> tierTypeCode {get; set;}
    public List<String> tierTypeIdentifier {get; set;}
    public Map<String, List<String>> benefitCodeKeyMapList{get; set;}
    @AuraEnabled public String tierTypeCodeList {get;set;}
    @AuraEnabled public String tierTypeIdentifierList {get;set;}
    //public Map<String,BenefitDetailsWrapper> benefitRedesignWrapperList {get; set;}
    public Map<String, String> OONReimbursementMap {get; set;}
    public Map<String, Map<String, List<BenefitSubSection>>> benefitRedesignWrapperList {get; set;}
    public string hippaBenefitCodeJSON {get; set;}
    public string benefitCodeMapJSON {get; set;}
    public Map<String, String> coPayingMap {get; set;}
    @AuraEnabled public Map<String, String> varriableCoverageMap {get; set;}
    @AuraEnabled public Map<String, String> existsOnRiderPlanMap {get; set;}
    @AuraEnabled public Map<String, String> benefitDisplayMap {get; set;}
    @AuraEnabled public String qualityProviderTierRuleID {get; set;}
    public string tierDescProdlkp {get;set;} 
    public class BenefitDetailsWrapper {
        public String BenefitCode {get; set;}
        public String BenefitType {get; set;}
        public List<BenefitSubSection> BenefitSubSection {get; set;}
    }
    
    public class BenefitSubSection {
        public String benefitLevel {get; set;}
        public String benefitLevelDescription {get; set;}
        public String benefitCodeGeneralLanguage {get; set;}
        public String benefitCodeLanguage {get; set;} 
        public String benefitVersion {get; set;} 
        public String ageFrom {get; set;} 
        public String ageFromDuration {get; set;}   
        public String ageThrough {get; set;}    
        public String ageThroughDuration {get; set;}   
        public String networkId  {get; set;}  
        public String relationshipCode  {get; set;}  
        public String coverageIndicator  {get; set;}  
    }
    public Class BenefitWrapper {
       @AuraEnabled public String Benefit {get; set;}
        // US824989 - Changes Start by Abhinav Balla 
        @AuraEnabled public String BenefitCode {get; set;}
        @AuraEnabled public String BenefitType {get; set;}
        /*public String BenefitFrom {get; set;}
        public String BenefitThru {get; set;}*/
        @AuraEnabled public String riderCoverageType {get; set;}
        @AuraEnabled public String riderBenefitPlanId {get; set;}
        @AuraEnabled public String riderGated {get; set;}
        @AuraEnabled public String riderCarrierName {get; set;}
        @AuraEnabled public String riderProductName {get; set;}
        @AuraEnabled public String riderProductId {get; set;}
        @AuraEnabled public String riderPlanTypeCode {get; set;}
        @AuraEnabled public String riderPlanName {get; set;}
        // US824989 - Changes End by Abhinav Balla
    }
    
    public List<PlanBenefitRiderWrapper>  PlanBenefitRiderList {get; set;}
    public Class PlanBenefitRiderWrapper {
        public String riderCoverageType {get; set;}
        public String riderBenefitPlanId {get; set;}
        public String riderGated {get; set;}
        public String riderCarrierName {get; set;}
        public String riderProductName {get; set;}
        public String riderProductId {get; set;}
        public String riderPlanTypeCode {get; set;}
        public String riderPlanName {get; set;}
    }
    
    public List<coPayWrapper> coPayWrapperList {get; set;}
    public class coPayWrapper {
        public string label {get; set;}
        public string value {get; set;}
        
    }
    
    @AuraEnabled public List<OONReimbursement> OONReimbursementList {get; set;}
    public class OONReimbursement {
        @AuraEnabled public string Percentile {get; set;}
        @AuraEnabled public string OONPricingType {get; set;}
        
    }
    
    public List<individualBenefitWrapper> individualBenefitWrapperList {get; set;}
    public class individualBenefitWrapper implements Comparable {
        public string rowLabel {get; set;}
        public string dedLimit {get; set;}
        public string OOPLimit {get; set;}
        public integer coinsurance {get;set;}
        
        public Integer compareTo(Object ObjToCompare) {
            return rowLabel.CompareTo(((individualBenefitWrapper)ObjToCompare).rowLabel);
        }
    }
    
    public List<familyBenefitWrapper> familyBenefitWrapperList {get; set;}
    public class familyBenefitWrapper implements Comparable {
        public string rowLabel {get; set;}
        public string dedLimit {get; set;}
        public string OOPLimit {get; set;}
        public integer coinsurance {get;set;}
        
        public Integer compareTo(Object ObjToCompare) {
            return rowLabel.CompareTo(((familyBenefitWrapper)ObjToCompare).rowLabel);
        }
    }
    /*** Added by Avish as a part of Plan Information section display on 06012017 ***/
    //Plan Information
    @AuraEnabled public List<PlanInformationWrapper> planInfoWrapperList {get; set;}
    
    
    public Class PlanInformationWrapper {
        @AuraEnabled public String coverageType {get;set;}
        @AuraEnabled public String riderOnlyFlag {get;set;}
        @AuraEnabled public String PlanId {get;set;}
        @AuraEnabled public String PolicyNumber {get;set;}
        @AuraEnabled public String administeredByName {get;set;}
        @AuraEnabled public String PlanName {get;set;}
        @AuraEnabled public string PlanType {get;set;}
        @AuraEnabled public String Accumulator {get;set;}
        @AuraEnabled public String Gated {get;set;}
        @AuraEnabled public String PCP {get;set;}
        @AuraEnabled public String Network {get;set;}
        @AuraEnabled public String productId {get;set;}
        @AuraEnabled public String planTypeCode {get;set;}
        @AuraEnabled public String timePeriodQualifier {get;set;}
        @AuraEnabled public String gatedProductIndicator {get;set;}
        @AuraEnabled public String pcpRequiredIndicator {get;set;}
        @AuraEnabled public String planMetallicLevel {get;set;}
        @AuraEnabled public List<networkScheduleIds> networkSchedules {get;set;}
        
        @AuraEnabled public String EffectiveDate {get;set;}
        @AuraEnabled public String EndDate {get;set;}
        @AuraEnabled public String ExpirationDate{get;set;}
        @AuraEnabled public String RevisionDate {get;set;}
        @AuraEnabled public String GroupName {get;set;}
        @AuraEnabled public String GroupId {get;set;}   
        
        @AuraEnabled public String benefitBundleOptionId {get;set;}
        @AuraEnabled public String enrolleeType {get;set;}
        @AuraEnabled public String enrolleeIdentifier {get;set;}   
        @AuraEnabled public String legalSubsidiary {get;set;}
        @AuraEnabled Public String qualityProviderTierRuleID{get;set;}
        public PlanInformationWrapper(){
            networkSchedules = new List<networkScheduleIds>();
        }           
    }     
    
    public class networkScheduleIds {
        @AuraEnabled public String networkSchId {get;set;}
    }
    
    public List<Accumulator> accumsLst {get;set;}    
    public class Accumulator implements Comparable {
        public String coverageLevel  {get;set;}
        public String benefitVersion {get;set;}
        public String costShareType {get;set;}
        public String duration {get; set;}
        public String benefitMaximumValue {get;set;}
        public String benefitMaximumUnit {get;set;}
        public String benefitYTDValue {get;set;}
        public String benefitRemainingValue {get;set;}
        
        public Integer compareTo(Object ObjToCompare) {
            return coverageLevel.CompareTo(((Accumulator)ObjToCompare).coverageLevel);
        }
    } 
    public Map<String,String> mapDurationAccumulator {get; set;}
    public Map<String,DateRangeVersion> mapDateVersion {get;set;}
    public class DateRangeVersion {
        public String dateRange {get;set;}
        public string benefitVersion {get;set;}
        public Map<String,String> benefitCmpMap {get; set;}
        public DateRangeVersion(){
            
        }
    }
    
    public Map<String,List<string>> mapDateBenefitCode {get; set;}
    public Map<String,List<Accumulator>> mapDateAccumulator {get; set;}
    
    public Map<String,List<String>> mapBenefitPlanTierValues{get;set;} 
    public Map<String,List<planTier>> mapBenefitPlans {get; set;}
    public Map<String,List<planTier>> mapBenefitRiderPlans {get; set;}
     
    
      public class planTier {
        public String tierIdntifier;   //888999e
        public String tierTypeCode; //1
        public String tierTypeDescription;  //In-Network Providers
        public String gatedPlanIndicator;   //N
        public String primaryIndividualDeductibleMaximum;   //2500
        public String primaryFamilyDeductibleMaximum;   //5000
        public String primaryIndividualOOPMaximum;  //2500
        public String primaryFamilyOOPMaximum;  //5000
        public planDelegation[] planDelegation;
    }
    public class planDelegation {
        public String delegationIndicator;  //q
        public String delegationIdentifier; //902313
        public String delegationName;   //pdname
    }
    @AuraEnabled public List<AccumulatorP> accumulatorList {get; set;}
    public class AccumulatorP implements Comparable {
        @AuraEnabled public String Section { get ; set; }            //Individual or Familty
        @AuraEnabled public String TypeCode { get ; set; }           //INN or OON
        @AuraEnabled public String MaxDeductible { get ; set; }
        @AuraEnabled public string MaxDed {get;set;}
        @AuraEnabled public String YTDDeductible { get ; set; }
        @AuraEnabled public String YTDDed { get ; set; }
        @AuraEnabled public String RemDeductible { get ; set; }
        @AuraEnabled public integer coinsurance {get;set;}
        @AuraEnabled public String MaxOOP { get ; set; }
        @AuraEnabled public String MaxOutofPoc { get ; set; }
        @AuraEnabled public String YTDOutofPoc { get ; set; }
        @AuraEnabled public String YTDOOP { get ; set; }
        @AuraEnabled public String RemOOP { get ; set; }
        @AuraEnabled public string primaryAccumDeduct {get;set;}
        @AuraEnabled public string primaryAccumDescOOP {get;set;}
        @AuraEnabled public string GroupMaxOOP {get;set;}
        @AuraEnabled public String GroupMaxDed {get;set;}
        
        
        public Integer compareTo(Object ObjToCompare) {
            return TypeCode.CompareTo(((AccumulatorP)ObjToCompare).TypeCode);
        }
    }
    
    
    
    public List<AccumulatorRedesignWrapper> IndividualAccumulatorRedesignList {get; set;}
    public List<AccumulatorRedesignWrapper> FamilyAccumulatorRedesignList {get; set;}
    
    public class AccumulatorRedesignWrapper {
        public String TypeCode { get ; set; }  
        public string accumulatorDeductibleLimit {get; set;}
        public string accumulatorDeductibleSatisfied {get; set;}
        public string accumulatorDeductibleRemaining {get; set;}
        public string accumulatorOOPLimit {get; set;}
        public string accumulatorOOPSatisfied {get; set;}
        public string accumulatorOOPRemaining {get; set;}
        public integer coinsurance {get;set;}
        public string primaryAccumDeduct {get;set;}
        public string primaryAccumDescOOP {get;set;}
    }
    
    


}