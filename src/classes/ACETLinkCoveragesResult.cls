public class ACETLinkCoveragesResult {
    
    public ACETLinkCoveragesResult () {
        SurrogateKeys = new Set<String>();
        Ids = new Set<String>();    
    }
    
    @AuraEnabled public String MemberId {get;set;}    
    @AuraEnabled public String fullName{get;set;}
    @AuraEnabled public String gender {get;set;}
    @AuraEnabled public String dob {get;set;}
    @AuraEnabled public String Age {get;set;}       
    @AuraEnabled public set<string> IDs {get;set;}
    @AuraEnabled public Set<String> SurrogateKeys {get;set;}
    @AuraEnabled public List<CoverageLine> CoverageLines {get;set;}
    @AuraEnabled public List<Address> Addresses {get;set;}
     public class CoverageLine {
        @AuraEnabled public boolean isFuture {get;set;}
        @AuraEnabled Public String GUID {get;set;} //manually generated
        @AuraEnabled public String CoverageType {get;set;}
        @AuraEnabled public String CoverageTypeCode {get;set;}
        @AuraEnabled public String eligibleDates {get;set;}  
        @AuraEnabled public String planStatus {get;set;}
        @AuraEnabled public String referral {get;set;}
        @AuraEnabled public String PolicyName {get;set;}        
        @AuraEnabled public String PolicyNumber {get;set;}
        @AuraEnabled public String GroupName {get;set;}
        @AuraEnabled public String GroupNumber {get;set;}
        @AuraEnabled public String Product {get;set;}
        @AuraEnabled public String ProductType {get;set;}
        @AuraEnabled public String Network {get;set;}
        @AuraEnabled public String EffectiveDate {get;set;}
        @AuraEnabled public String EndDate {get;set;}
        @AuraEnabled public String SourceCode {get;set;}
        @AuraEnabled public String CoverageLevel {get;set;}
        @AuraEnabled public String FundingArrangement {get;set;}
        @AuraEnabled public String BenefitPlanId {get;set;}
        @AuraEnabled public String PlanSitusState {get;set;}
        @AuraEnabled public String SurrogateKey {get;set;}
        @AuraEnabled public String OnshoreRestriction {get;set;}
        @AuraEnabled public String OnshoreRestrictionVerbiage {get;set;}
        @AuraEnabled public String EnrolleeSurrogateKey {get;set;}
        @AuraEnabled public String onshoreRestrictionCode {get; set;}
        @AuraEnabled public String relationShipCode {get;set;} 
        @AuraEnabled public boolean isAdvanceSearched {get;set;}
        @AuraEnabled public boolean isSubscriber {get;set;} 
        @AuraEnabled public boolean isPreferred {get;set;}
        @AuraEnabled public boolean isActive {get;set;}
        @AuraEnabled public Integer daysGap {get;set;}
        @AuraEnabled Public String contractOptionId{get;set;}                    
        @AuraEnabled public String continuationResponsibilityType{get;set;}       
        @AuraEnabled public String insuranceContinuationType{get;set;}     
        @AuraEnabled public Boolean nonMedicalPolicyBoolean {get;set;}
        @AuraEnabled public Boolean highlightedPolicy {get;set;}
        @AuraEnabled public Boolean ITEhighlightedPolicyId {get;set;}// Added By Chandan for ITE
        @AuraEnabled public String transactionId {get;set;}
        @AuraEnabled public String concatAddress {get;set;}
        @AuraEnabled public String addressLine1 {get;set;}
        @AuraEnabled public String city {get;set;}
        @AuraEnabled public String state {get;set;}
        @AuraEnabled public String zip {get;set;}
        
        
        public CoverageLine(){
            GUID = ACETGUIDUtil.newGuid(); 
        } 
                        
        public Boolean getIsActive(){
            if(String.isEmpty(EffectiveDate) || String.isEmpty(EndDate)) return false;
            
            Date objEffectiveDate = Date.newInstance(Integer.valueOf(EffectiveDate.split('/')[2]), Integer.valueOf(EffectiveDate.split('/')[0]), Integer.valueOf(EffectiveDate.split('/')[1]));
            Date objEndDate = Date.newInstance(Integer.valueOf(EndDate.split('/')[2]), Integer.valueOf(EndDate.split('/')[0]), Integer.valueOf(EndDate.split('/')[1]));
           
            return (Date.today() >= objEffectiveDate) && (Date.today() <= objEndDate);
        } 

    }
     public class Address {
        @AuraEnabled
        public String AddressLine1 {get;set;}
        @AuraEnabled
        public String AddressLine2 {get;set;}
        @AuraEnabled
        public String City {get;set;}
        @AuraEnabled
        public String State {get;set;}
        @AuraEnabled
        public String Zip {get;set;}
        @AuraEnabled
        public String AddressType {get;set;} 
        @AuraEnabled
        public string countryCode {get;set;}     
    }

}