public with sharing class ACETMemberDetail {
    
    //Code Added By Chandan-start
    public String CoverageTypeValue  { get; set; }
    public set<String> CoverageTypeSet { get; set; }
    public String groupNameValue  { get; set; }
    public set<String> groupNameSet { get; set; }
    public Date effectiveDateValue  { get; set; }
    public Date endDateValue  { get; set; }
    public String groupNumberValue  { get; set; }
    public set<String> groupNumberSet { get; set; }
    public String sourceCodeValue   { get; set; }
    public set<String> sourceCodeSet { get; set; }
    public boolean searchOnLoad { get; set; }
    public boolean isAdvanceSearched { get; set; }
    public list<cobAttestation> groupSettings {get;set;} //US1699536
    public List<SpecialtyBenefits_CoverageLine> specialityBenefits {get;set;}
    Public list <customerPurchaseinfo > listcustinfo {get;set;}
    public List<customerPurchaseinfo> membershipCustInfoList{get;set;} //DE469102 : Added By Manish
    //Code Added By Chandan-End
    
    public String EID{get;set;}//Added by Nirvana
    public String QMSCOIndicator {get;set;}
    public Boolean AffiliationIndicator {get;set;}
    public Boolean isServiceError {get;set;}
    public String FirstName {get;set;}
    public String LastName {get;set;}
    public String MemberId {get;set;}
    public String SCRId {get;set;}
    public String DOB {get;set;}
    public String RelationShip {get;set;}
    public String RelationShipCode {get;set;}
    public String OriginatorRelationship {get;set;}
    public String MiddleInitial {get;set;}
    public String Gender {get;set;}
    public String Age {get;set;}
    public String SSN {get;set;}
    public String CPTIN {get;set;}
    public String FullSSN {get;set;}
    public String SpokenLanguage {get;set;}
     public String WrittenLanguage {get;set;}
    public String Email {get;set;}
    public String AsianInitiativeIndicator {get;set;}
    public String MigrationDate {get;set;}
    public String OriginalEffectiveDate {get;set;}
    public String DeceasedDate {get;set;}
    public String PCPRequired {get;set;}
    public String PCPAssignment {get;set;}
    public String SitusState {get;set;}
    public String PolicyNumber {get;set;}
    public String FundingArragement {get;set;}
    public String BenefitPlanId {get;set;}
    public String PlanType {get;set;}
    public String FundingArragementCode {get;set;}
    public String MemberStatus {get;set;}
    public String TerminationReason {get;set;}
    public String HoldReason{get;set;}
    public List<holdCodeInfo> holdCodeList{get;set;}
    public String Network {get;set;}      
    public String gatedPlanIndicator {get;set;} // US1354260 added by Avish on 10/09/2018
    Public String migrationSourceSystem {get;set;} // US2884153 
    public String parentGroup{get;set;}                     // US2874415
    public String alphaParentGroup{get;set;}                 // US2874415
    public String EffectiveDate {get;set;}
    public String EndDate {get;set;}
    public String Product {get;set;}
    public String ProductType {get;set;}
    public String Suffix {get;set;}
    public String BundleOptionID {get;set;}
    public String hsaAvailable {get;set;}
    public String exchangeType {get;set;} //US1744309
    public String exchangeState{get;set;} //US1744309
     //Rama:Added to get the coverage level from getMembeship
    public String CoverageLevelCode {get;set;}  
    public String benefitAdmin{get;set;}         //US1053027
    public String benefitAdminPhone{get;set;}    //US1053027
     public String disability {get;set;} //US1074007
     public List<DependentDisability> disabilityInfo {get;set;} //US1074007 
    public CoverageLine PreferredCoverage {get;set;}
    public String accTypes{get;set;}
    public String serviceGrp{get;set;}
    Public customerPurchaseinfo custPurchaseinfo{get;set;}//US2962032
    public String GroupSize {get;set;}
    // getEmp V3 changes start
    public String responsibilityType{get;set;}            
    public String continuationType{get;set;}              
    public String enrollmentMethod{get;set;}              
    public String coverageGroupContractOptionId{get;set;}  
    public String coverageGroupContractOptionEffDate{get;set;}  
    public String coverageGroupContractOptionStatus{get;set;}  
    public String coverageGroupContractOptionFilterStatus{get;set;}  
    public String contractOptionPopulations {get;set;}
    public boolean hasPopulation{get;set;}                 
    public String cobraAdministrativeIndicator{get;set;}   
    public String onshoreRestriction{get;set;}             
    // getEmp V3 changes end
    public List<Address> Addresses {get;set;}
    public List<Phone> Phones {get;set;}
    public List<PCPAssignment> PCPAssignments {get;set;}
    public List<FamilyMember> FamilyMembers {get;set;}
    public List<CoverageLine> CoverageLines {get;set;}
    public MemberEligibilityCoverage EligibilityCoverage {get;set;}
    //added by Ranjit for ROI Section in the member Detail Page
    public List<otherContact> ROIcontacts {get;set;}
    public List<statusLog> MemberStatusLogs{get;set;}
    public Map<String,String> GroupVsOnshoreIndicator {get;set;}
     //added by Khoushik on 09/28/2016 for User Story - US378010
    public List<COB> lstCOB {get;set;}
    //added by Khoushik for Surrogate Id related Stories
    //added by Khoushik for Surrogate Id User Stories
    public String SurrogateKey {get;set;} 
   // public String MembershipSurrogateKey {get;set;} 
    public Set<String> SurrogateKeys {get;set;}
    public String EnrolleeSurrogateKey {get;set;}
    public string onshore{get;set;}
    public List<CoverageLineHistory> lstCoverageLineHistory {get;set;}
    public String bookOfBusinessTypeCode{get;set;} // US3584877 : Added By Manish
    public String bookOfBusinessTypeDesc{get;set;} // US3584877 : Added By Manish
    public ACETMemberDetail() {
        SurrogateKeys = new Set<String>();  
    }
     public boolean isMemberEligibility {get;set;}
    public class MemberEligibilityCoverage{
      public String coverageType {get;set;}
      public String groupNumber {get;set;}
      public String benefitPlanId {get;set;}
      public String effectivedate {get;set;}
      public String endDate {get;set;}
    }
    
    public class customerPurchaseinfo{//US2962032
        public Integer groupNumber{get;set;}
        public String planOptionId{get;set;}
        public String customerPurchaseIdentifier{get;set;}
        public Integer customerPurchaseVersionId{get;set;}
        public String contractOptionEffectiveDate{get;set;}
        public String contractOptionExpiryDate{get;set;}
        Public String benefitEffectivedate{get;set;}
        Public String benefitEnddate{get;set;}
        public String benefitBundleOptionId{get;set;}
        Public String benefitPlanId{get;set;}
    }
    //US1074007 starts
    public class DependentDisability {
        public String disabilityType {get;set;}
        public String diagnosisCode {get;set;}
        public String diagnosisCodeType {get;set;}
        public String diagnosisDesc{get;set;}
        public String effectiveDate {get;set;}
        public String endDate {get;set;}
    }
    //US1074007 ends
    
    public class CoverageLineHistory{ 
            public string covLevelCode {get;set;}
            public string covLevelDesc {get;set;}
            public Date covLevelEffDate {get;set;}
            public Date covLevelExpDate {get;set;} 
    }
      Public Class SpecialtyBenefits_CoverageLine{
        Public String ContractOptionType {get;set;}
        Public String planOptionID{get;set;}
        Public String ContractOptionStartDate {get;set;}
        Public String ContractOptionEndDate {get;set;}
        Public String isActive {get;set;}
        Public String customerPurchaseId {get;set;}
    }
    public class holdCodeInfo{
        public String holdCode{get;set;}
        public String holdDescription{get;set;}
        public String effectiveDate{get;set;}
        public String expirationDate{get;set;}
        public String holdNote{get;set;}
        public List<String> holdRestriction{get;set;}
        public String holdLevel{get;set;}
    }
    
    public class Address {
        public String AddressLine1 {get;set;}
        public String AddressLine2 {get;set;}
        public String City {get;set;}
        public String State {get;set;}
        public String Zip {get;set;} 
        public String AddressType {get;set;}  
        public string countryCode {get;set;}      
    }
    
    public class Phone {
        public String PhoneNumber {get;set;}
        public String PhoneNumberType {get;set;}  
        public String primaryIndicator {get;set;}
        public String WorkExt {get;set;} 
    }   
    //US1699536 starts
    public class cobAttestation{
        public String cobAttestationFrequency{get;set;}                 
        public String cobAttestationDenyGracePeriod{get;set;}           
        public String effectiveDate{get;set;}                           
        public String expirationDate{get;set;}                          
        public String religiousExemptionTypeDescription{get;set;}     
    }
    //US1699536 ends
    public class PCPAssignment {
        public Boolean isChecked{get;set;}
        public Boolean isActive{get;set;}
        public String FirstName {get;set;}
        public String LastName {get;set;}   
        public String pcpAssignmentType {get;set;}
        public string endDate{get;set;}
        public string effectiveDate {get;set;} 
        public String id {get;set;} 
        public String identifiertype {get;set;} 
        public String locationAffiliationID {get;set;}
        //Added this code snippet as part of user story US966923 to display future pcp and image - Rahul on 20/02/2017
            public Boolean getIsActive(){
            if(String.isEmpty(EffectiveDate) || String.isEmpty(EndDate)) return false; 
            
            Date objEffectiveDate = Date.newInstance(Integer.valueOf(EffectiveDate.split('/')[2]), Integer.valueOf(EffectiveDate.split('/')[0]), Integer.valueOf(EffectiveDate.split('/')[1]));
            Date objEndDate = Date.newInstance(Integer.valueOf(EndDate.split('/')[2]), Integer.valueOf(EndDate.split('/')[0]), Integer.valueOf(EndDate.split('/')[1]));
            
            return (Date.today() >= objEffectiveDate) && (Date.today() <= objEndDate);
        }  
        
        
        public String getImage(){ 
            String pcpStatus = '';
            Date objEffectiveDate = Date.newInstance(Integer.valueOf(EffectiveDate.split('/')[2]), Integer.valueOf(EffectiveDate.split('/')[0]), Integer.valueOf(EffectiveDate.split('/')[1]));
            Date objEndDate = Date.newInstance(Integer.valueOf(EndDate.split('/')[2]), Integer.valueOf(EndDate.split('/')[0]), Integer.valueOf(EndDate.split('/')[1]));
            
            if(Date.today() < objEffectiveDate) {
                pcpStatus = 'Blue';
            }
            else if(Date.today() >= objEffectiveDate && Date.today() <= objEndDate) {
                pcpStatus = 'active';
            }
            else if(Date.today() > objEffectiveDate && Date.today() > objEndDate) {
                pcpStatus= 'inactive';
            }
            return pcpStatus;
        }         
    }   
    public class otherContact{
        public boolean ContactStatus {get;set;}
        public String FirstName {get;set;}
        public String LastName {get;set;}   
        public String MiddleName {get;set;}
        public String effectiveDate {get;set;}
        public String terminationDate {get;set;}
        public string docLink {get;set;}          
    }
      public class statusLog{
        public boolean StatusAction{get;set;}
        public Date EffectiveDate{get;set;}
        public Date ChangedOn{get;set;}   
        public String Changedby{get;set;}
        public String Reason{get;set;}
        public String OperationInitiatedby{get;set;}
                 
    }

    public class FamilyMember {
        public String FirstName {get;set;}
        public String LastName {get;set;}
        public String MiddleInitial {get;set;}
        public String Relationship {get;set;}
        public String Gender {get;set;}     
        public String DOB {get;set;}   
        public String suffix {get;set;}     
        //added by Swetha//
        public String EID {get;set;}  
        public String Age {get;set;} //calculated from DOB 
        public String FamilyId {get;set;}
        public String subscriberIndividualId{get;set;}
        //Added by Rupsa to select table rows in Termination Enrollment, Reinstatement pages
        public Boolean selected {get; set;}
        public Date effectiveDate {get; set;}
        public Date termDate {get; set;}
        public String termDateStr {get; set;}
        public Date reinstDate {get; set;}
        public String CoverageStatus{get;set;}
        public List<Address> Addresses {get;set;}
        public String memberStatus {get;set;}
        public FamilyMember(){
            selected = false;
        }
        public string groupNumber{get;set;}
        public string benefitBundleOptionId {get;set;} 
        public string memberId{get;set;}  
    }
    
    public class CoverageLine {
        Public String GUID {get;set;} //manually generated
        public String CoverageType {get;set;}
        public String CoverageTypeCode {get;set;}
        public String PolicyNumber {get;set;}
        public String GroupName {get;set;}
        public String GroupNumber {get;set;}
        public String Product {get;set;}
        public String ProductType {get;set;}
        public String Network {get;set;}
        public String EffectiveDate {get;set;}
        public String EndDate {get;set;}
        public String COEffectiveDate {get;set;}
        public String COEndDate {get;set;}
        public String SourceCode {get;set;}
        public String CoverageLevel {get;set;}
        public String FundingArrangement {get;set;}
        public String BenefitPlanId {get;set;}
        public String PlanSitusState {get;set;}
        public String SurrogateKey {get;set;}
        public boolean OnshoreRestrictionError{get;set;} // onshore restriction enhancement
        public String OnshoreRestriction {get;set;}
        public String OnshoreRestrictionVerbiage {get;set;}
        public String EnrolleeSurrogateKey {get;set;}
        public String bookOfBusinessTypeCode{get;set;}
        public String onshoreRestrictionCode {get; set;}//added by divya: to determine onshore/offshore restriction code
        public String relationShipCode {get;set;} //Code Added By Chandan -US1365690 //Need to check whether its required.
        public boolean isAdvanceSearched {get;set;}//Code Added By Chandan
        public boolean isSubscriber {get;set;} //Code Added By Chandan -US1365690
        public String coverageMemberId{get;set;}
        public String subscriberID{get;set;}
        
        public boolean isPreferred {get;set;}//bhanu:optimised
        public boolean isActive {get;set;}//bhanu:optimised
        public Integer daysGap {get;set;}
        Public string customerPurchaseIdsliststring{get;set;}
        Public String customerPurchaseId{get;set;}
        Public String contractOptionId{get;set;}                    // getEmp V3 changes
        public String continuationResponsibilityType{get;set;}      // getEmp V3 changes    
        public String insuranceContinuationType{get;set;}           // getEmp V3 changes    
        Public list <customerPurchaseinfo > listcustinfo {get;set;} // US3584877 : Added By Manish
        Public customerPurchaseinfo custPurchaseinfo{get;set;}	    // US3584877 : Added By Manish
        public CoverageLine(){
            GUID = ACETGUIDUtil.newGuid();  
        }  
                        
        public Boolean getIsActive(){
            if(String.isEmpty(EffectiveDate) || String.isEmpty(EndDate)) return false; 
            
            Date objEffectiveDate = Date.newInstance(Integer.valueOf(EffectiveDate.split('/')[2]), Integer.valueOf(EffectiveDate.split('/')[0]), Integer.valueOf(EffectiveDate.split('/')[1]));
            Date objEndDate = Date.newInstance(Integer.valueOf(EndDate.split('/')[2]), Integer.valueOf(EndDate.split('/')[0]), Integer.valueOf(EndDate.split('/')[1]));
            
            return (Date.today() >= objEffectiveDate) && (Date.today() <= objEndDate);
        }  
        
        //Added this code snippet as part of user story US808419 to display future coverages also - Avish on 11/07/2017
        public String getImage(){ 
            String coverageStatus = '';
            Date objEffectiveDate = Date.newInstance(Integer.valueOf(EffectiveDate.split('/')[2]), Integer.valueOf(EffectiveDate.split('/')[0]), Integer.valueOf(EffectiveDate.split('/')[1]));
            Date objEndDate = Date.newInstance(Integer.valueOf(EndDate.split('/')[2]), Integer.valueOf(EndDate.split('/')[0]), Integer.valueOf(EndDate.split('/')[1]));
            
            if(Date.today() < objEffectiveDate) {
                coverageStatus = 'Blue';
            }
            else if(Date.today() >= objEffectiveDate && Date.today() <= objEndDate) {
                coverageStatus = 'active';
            }
            else if(Date.today() > objEffectiveDate && Date.today() > objEndDate) {
                coverageStatus= 'inactive';
            }
            return coverageStatus;
        }                                
        
    }
     //added by Khoushik on 09/28/2016 for User Story - US378010
      public class COB {
        public String Name {get;set;}
        public String Relationship {get;set;}
        public String DateOfBirth {get;set;}
        public String InsuranceType {get;set;}
        public String medicareEntitlementType {get;set;}
        public String OtherInsuranceCarrierName {get;set;}
        public String COBTypeDesc {get;set;}// will map to coverage type desc
        public String IsOtherInsurancePrimary {get;set;}
        public Date Startdt {get;set;}
        public Date Enddt {get;set;}
        public Date LastUpdate {get;set;}
        public String MedicareType {get;set;} 
        public String IsMedicarePrimary {get;set;}     
        public String EntitlementReason {get;set;}
        public Date PartAStart {get;set;}
        public Date PartBStart {get;set;}
        public Date PartDStart {get;set;}
        public Date PartAEnd {get;set;}
        public Date PartBEnd {get;set;}
        public Date PartDEnd {get;set;}
        public String Age {get;set;}
        public string otherInsuranceCardholderId {get;set;}
        public String CoverageTypeCode {get;set;} 
        public String OrderOfBenefit {get;set;}
        public String BenefitType {get;set;} 
        public String MemberId {get;set;}             
      }
      public String MiddleName {get;set;} 
      public String EligibilityStatus{get;set;} 
      public Date TerminationDate{get;set;} 
      public Date DateOfEmployment{get;set;} 
      public String EmploymentStatus{get;set;} 
      public String CoverageLevel{get;set;} 
      public String GroupName{get;set;} 
      public String EmploymentStartDate{get;set;}
      
    public String ClaimAddressline1 {get;set;} 
    public String ClaimAddressline2 {get;set;} 
    public String ClaimAddresscity {get;set;} 
    public String ClaimAddressstate {get;set;} 
    public String ClaimAddresspostalCode {get;set;} 
    public String ClaimAddresscountyCode {get;set;} 
    
    public String parentPEOId{get;set;}
    public Boolean isChildPEO{get;set;}
              
}