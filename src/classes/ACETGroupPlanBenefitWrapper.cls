global with sharing class ACETGroupPlanBenefitWrapper {
   
   public Map<String,String> benefitMapping {get; set;}
   public Map<String,String> hippaServiceMap {get; set;}
   public Map<String,List<ACETGroupPlanBenefitWrapper.Accumulator>> benefitAccumulatorMap {get; set;}
   public string hippakeyStr {get; set;}
    
   //Provider Lookup Page
   public map<string,string> tierDescMap {get;set;} 
   public set<string> claimTypeList {get;set;} 
   public Map<string,string> sAreaType {get;set;} 
    //public map<string,List<ACETGetSubscriptionRedesignJSON2APEX.network>> networkMap {get;set;}
    public map<string,List<String>> networkMap {get;set;}
    public set<string> benefitServiceSet {get;set;}
    public list<string> carId {get;set;}
    
   // Benefit Section
    public List<BenefitWrapper> benefitWrapperList {get; set;}
    public Map<String, String> benefitCodeKeyMap {get; set;}
    public Map<String, List<String>> benefitCodeKeyMapList{get; set;}
    //public Map<String,BenefitDetailsWrapper> benefitRedesignWrapperList {get; set;}
    public Map<String, String> OONReimbursementMap {get; set;}
    public Map<String, Map<String, List<BenefitSubSection>>> benefitRedesignWrapperList {get; set;}
    public string hippaBenefitCodeJSON {get; set;}
    public string benefitCodeMapJSON {get; set;}
    public Map<String, String> coPayingMap {get; set;}
    public Map<String, String> varriableCoverageMap {get; set;}
    public Map<String, String> existsOnRiderPlanMap {get; set;}
    public string tierDescProdlkp {get;set;} 
    public string qualityProviderTierRuleID {get; set;}
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
        public String Benefit {get; set;}
        // US824989 - Changes Start by Abhinav Balla 
        public String BenefitCode {get; set;}
        public String BenefitType {get; set;}
        /*public String BenefitFrom {get; set;}
        public String BenefitThru {get; set;}*/
        public String riderCoverageType {get; set;}
        public String riderBenefitPlanId {get; set;}
        public String riderGated {get; set;}
        public String riderCarrierName {get; set;}
        public String riderProductName {get; set;}
        public String riderProductId {get; set;}
        public String riderPlanTypeCode {get; set;}
        public String riderPlanName {get; set;}
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
    
    public List<OONReimbursement> OONReimbursementList {get; set;}
    public class OONReimbursement {
        public string Percentile {get; set;}
        public string OONPricingType {get; set;}
        
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
    public List<PlanInformationWrapper> planInfoWrapperList {get; set;}
    
    
    public Class PlanInformationWrapper {
        public String coverageType {get;set;}
        public String riderOnlyFlag {get;set;}
        public String PlanId {get;set;}
        public String PolicyNumber {get;set;}
        public String administeredByName {get;set;}
        public String PlanName {get;set;}
        public string PlanType {get;set;}
        public String Accumulator {get;set;}
        public String Gated {get;set;}
        public String PCP {get;set;}
        public String Network {get;set;}
        public String productId {get;set;}
        public String planTypeCode {get;set;}
        public String timePeriodQualifier {get;set;}
        public String gatedProductIndicator {get;set;}
        public String pcpRequiredIndicator {get;set;}
        public String planMetallicLevel {get;set;}
        Public String qualityProviderTierRuleID{get;set;}
        public List<networkScheduleIds> networkSchedules {get;set;}
        
        public String EffectiveDate {get;set;}
        public String EndDate {get;set;}
        public String ExpirationDate{get;set;}
        public String RevisionDate {get;set;}
        public String GroupName {get;set;}
        public String GroupId {get;set;}   
        
        public String benefitBundleOptionId {get;set;}
        public String enrolleeType {get;set;}
        public String enrolleeIdentifier {get;set;}   
        public String legalSubsidiary {get;set;}
        public String eHBIndicator {get;set;}
        public PlanInformationWrapper(){
            networkSchedules = new List<networkScheduleIds>();
        }           
    }     
    
    public class networkScheduleIds {
        public String networkSchId {get;set;}
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
        public List<AccumulatorP> accumulatorList {get; set;}
    public class AccumulatorP implements Comparable {
        public String Section { get ; set; }            //Individual or Familty
        public String TypeCode { get ; set; }           //INN or OON
        public String MaxDeductible { get ; set; }
        public string MaxDed {get;set;}
        public String YTDDeductible { get ; set; }
        public String YTDDed { get ; set; }
        public String RemDeductible { get ; set; }
        public integer coinsurance {get;set;}
        public String MaxOOP { get ; set; }
        public String MaxOutofPoc { get ; set; }
        public String YTDOutofPoc { get ; set; }
        public String YTDOOP { get ; set; }
        public String RemOOP { get ; set; }
        public string primaryAccumDeduct {get;set;}
        public string primaryAccumDescOOP {get;set;}
        public string GroupMaxOOP {get;set;}
        public String GroupMaxDed {get;set;}
        
        
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