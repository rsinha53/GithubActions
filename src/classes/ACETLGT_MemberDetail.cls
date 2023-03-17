public with sharing class ACETLGT_MemberDetail {
 
    //Code Added By Chandan-start
    @AuraEnabled
    public String CoverageTypeValue  { get; set; }
    @AuraEnabled
    public set<String> CoverageTypeSet { get; set; }
    @AuraEnabled
    public String groupNameValue  { get; set; }
    @AuraEnabled
    public set<String> groupNameSet { get; set; }
    @AuraEnabled
    public Date effectiveDateValue  { get; set; }
    @AuraEnabled
    public Date endDateValue  { get; set; }
    @AuraEnabled
    public String groupNumberValue  { get; set; }
    @AuraEnabled
    public set<String> groupNumberSet { get; set; }
    @AuraEnabled
    public String sourceCodeValue   { get; set; }
    @AuraEnabled
    public set<String> sourceCodeSet { get; set; }
    @AuraEnabled
    public boolean searchOnLoad { get; set; }
    @AuraEnabled
    public boolean isAdvanceSearched { get; set; }
    //Code Added By Chandan-End
    @AuraEnabled
    public String EID{get;set;}//Added by Nirvana
    @AuraEnabled
    public String QMSCOIndicator {get;set;}
    @AuraEnabled
    public Boolean isServiceError {get;set;}
    @AuraEnabled
    public String FirstName {get;set;}
    @AuraEnabled
    public String LastName {get;set;}
    @AuraEnabled
    public String MemberId {get;set;}
    @AuraEnabled
    public String SCRId {get;set;}
    @AuraEnabled
    public String DOB {get;set;}
    @AuraEnabled
    public String RelationShip {get;set;}
    @AuraEnabled
    public String RelationShipCode {get;set;}
    @AuraEnabled
    public String OriginatorRelationship {get;set;}
    @AuraEnabled
    public String MiddleInitial {get;set;}
    @AuraEnabled
    public String Gender {get;set;}
    @AuraEnabled
    public String Age {get;set;}
    @AuraEnabled
    public String SSN {get;set;}
    @AuraEnabled
    public String CPTIN {get;set;}
    @AuraEnabled
    public String FullSSN {get;set;}
    @AuraEnabled
    public String SpokenLanguage {get;set;}
    @AuraEnabled
    public String WrittenLanguage {get;set;}
    @AuraEnabled
    public String Email {get;set;}
    @AuraEnabled
    public String AsianInitiativeIndicator {get;set;}
    @AuraEnabled
    public String MigrationDate {get;set;}
    @AuraEnabled
    public String OriginalEffectiveDate {get;set;}
    @AuraEnabled
    public String DeceasedDate {get;set;}
    @AuraEnabled
    public String PCPRequired {get;set;}
    @AuraEnabled
    public String PCPAssignment {get;set;}
    @AuraEnabled
    public String SitusState {get;set;}
    @AuraEnabled
    public String PolicyNumber {get;set;}
    @AuraEnabled
    public String FundingArragement {get;set;}
    @AuraEnabled
    public String BenefitPlanId {get;set;}
    @AuraEnabled
    public String FundingArragementCode {get;set;}
    @AuraEnabled
    public String MemberStatus {get;set;}
    @AuraEnabled
    public String TerminationReason {get;set;}
    @AuraEnabled
    public String HoldReason{get;set;}
    @AuraEnabled
    public List<holdCodeInfo> holdCodeList{get;set;}
    @AuraEnabled
    public String Network {get;set;}      
    @AuraEnabled
    public String gatedPlanIndicator {get;set;} // US1354260 added by Avish on 10/09/2018
    @AuraEnabled
    public String EffectiveDate {get;set;}
    @AuraEnabled
    public String EndDate {get;set;}
    @AuraEnabled
    public String Product {get;set;}
    @AuraEnabled
    public String ProductType {get;set;}
    @AuraEnabled
    public String Suffix {get;set;}
    @AuraEnabled
    public String BundleOptionID {get;set;}
    @AuraEnabled
    public String hsaAvailable {get;set;}
    
     //Rama:Added to get the coverage level from getMembeship
    @AuraEnabled
    public String CoverageLevelCode {get;set;}  
    @AuraEnabled
    public String benefitAdmin{get;set;}         //US1053027
    @AuraEnabled
    public String benefitAdminPhone{get;set;}    //US1053027
    @AuraEnabled 
    public String disability {get;set;} //US1074007
    @AuraEnabled 
    public List<DependentDisability> disabilityInfo {get;set;} //US1074007 
    @AuraEnabled
    public CoverageLine PreferredCoverage {get;set;}
    @AuraEnabled
    public String GroupSize {get;set;}
    // getEmp V3 changes start
    @AuraEnabled
    public String responsibilityType{get;set;}            
    @AuraEnabled
    public String continuationType{get;set;}              
    @AuraEnabled
    public String enrollmentMethod{get;set;}              
    @AuraEnabled
    public String coverageGroupContractOptionId{get;set;}  
    @AuraEnabled
    public String coverageGroupContractOptionEffDate{get;set;}  
    @AuraEnabled
    public String coverageGroupContractOptionStatus{get;set;}  
    @AuraEnabled
    public String coverageGroupContractOptionFilterStatus{get;set;}  
    @AuraEnabled
    public boolean hasPopulation{get;set;}                 
    @AuraEnabled
    public String cobraAdministrativeIndicator{get;set;}   
    @AuraEnabled
    public String onshoreRestriction{get;set;}  
    
    @AuraEnabled
    public CoverageGroupInfo coverageGroupInfo {get;set;}
    public class CoverageGroupInfo{
        @AuraEnabled public String coverageGroupContractOptionId{get;set;}  
        @AuraEnabled public String coverageGroupContractOptionEffDate{get;set;}  
        @AuraEnabled public String coverageGroupContractOptionStatus{get;set;}  
        @AuraEnabled public String coverageGroupContractOptionFilterStatus{get;set;}  
        @AuraEnabled public boolean hasPopulation{get;set;}                 
        
        // Coverage Details
        @AuraEnabled public String SitusState {get;set;}                                         
        @AuraEnabled public String FundingArragement {get;set;}
        @AuraEnabled public String GroupSize {get;set;}
        @AuraEnabled public String enrollmentMethod {get;set;}
        @AuraEnabled public String gatedPlanIndicator {get;set;} 
        @AuraEnabled public String onshoreRestriction{get;set;}
        
        //Eligibility Details
        @AuraEnabled public String benefitAdmin{get;set;}         
        @AuraEnabled public String benefitAdminPhone{get;set;}   
        @AuraEnabled public String responsibilityType{get;set;}            
        @AuraEnabled public String continuationType{get;set;}              
        
    }
    // getEmp V3 changes end
    @AuraEnabled
    public List<Address> Addresses {get;set;}
    @AuraEnabled
    public List<Phone> Phones {get;set;}
    @AuraEnabled
    public List<PCPAssignment> PCPAssignments {get;set;}
    @AuraEnabled
    public List<FamilyMember> FamilyMembers {get;set;}
    @AuraEnabled
    public List<CoverageLine> CoverageLines {get;set;}
    @AuraEnabled
    public MemberEligibilityCoverage EligibilityCoverage {get;set;}
    //added by Ranjit for ROI Section in the member Detail Page
    @AuraEnabled
    public List<otherContact> ROIcontacts {get;set;}
    @AuraEnabled
    public List<statusLog> MemberStatusLogs{get;set;}
    @AuraEnabled
    public Map<String,String> GroupVsOnshoreIndicator {get;set;}
     //added by Khoushik on 09/28/2016 for User Story - US378010
    @AuraEnabled
    public List<COB> lstCOB {get;set;}
    //added by Khoushik for Surrogate Id related Stories
    //added by Khoushik for Surrogate Id User Stories
    @AuraEnabled
    public String SurrogateKey {get;set;} 
   // public String MembershipSurrogateKey {get;set;} 
    @AuraEnabled
    public Set<String> SurrogateKeys {get;set;}
    @AuraEnabled
    public String EnrolleeSurrogateKey {get;set;}
    @AuraEnabled
    public string onshore{get;set;}
    @AuraEnabled
    public List<CoverageLineHistory> lstCoverageLineHistory {get;set;}
    
    public ACETLGT_MemberDetail() {
        SurrogateKeys = new Set<String>();  
    }
    @AuraEnabled
    public boolean isMemberEligibility {get;set;}
    
    public class MemberEligibilityCoverage{
      @AuraEnabled
      public String coverageType {get;set;}
      @AuraEnabled
      public String groupNumber {get;set;}
      @AuraEnabled
      public String benefitPlanId {get;set;}
      @AuraEnabled
      public String effectivedate {get;set;}
      @AuraEnabled
      public String endDate {get;set;}
    }
    
    //US1074007 starts
    public class DependentDisability {
        @AuraEnabled
        public String disabilityType {get;set;}
        @AuraEnabled
        public String diagnosisCode {get;set;}
        @AuraEnabled
        public String diagnosisCodeType {get;set;}
        @AuraEnabled
        public String diagnosisDesc{get;set;}
        @AuraEnabled
        public String effectiveDate {get;set;}
        @AuraEnabled
        public String endDate {get;set;}
    }
    //US1074007 ends
    
    public class CoverageLineHistory{ 
        @AuraEnabled    
        public string covLevelCode {get;set;}
        @AuraEnabled    
        public string covLevelDesc {get;set;}
        @AuraEnabled    
        public String covLevelEffDate {get;set;}
        @AuraEnabled    
        public String covLevelExpDate {get;set;} 
    }
    
    public class holdCodeInfo{
        @AuraEnabled
        public String holdCode{get;set;}
        @AuraEnabled
        public String holdDescription{get;set;}
        @AuraEnabled
        public String effectiveDate{get;set;}
        @AuraEnabled
        public String expirationDate{get;set;}
        @AuraEnabled
        public String holdNote{get;set;}
        @AuraEnabled
        public List<String> holdRestriction{get;set;}
        @AuraEnabled
        public String holdLevel{get;set;}
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
    public class Phone {
        @AuraEnabled
        public String PhoneNumber {get;set;}
        @AuraEnabled
        public String PhoneNumberType {get;set;}  
        @AuraEnabled
        public String primaryIndicator {get;set;}
        @AuraEnabled
        public String WorkExt {get;set;} 
    }   
    public class PCPAssignment {
        @AuraEnabled
        public Boolean isChecked{get;set;}
        @AuraEnabled
        public Boolean isActive{get;set;}
        @AuraEnabled
        public String FirstName {get;set;}
        @AuraEnabled
        public String LastName {get;set;}  
        @AuraEnabled
        public String pcpAssignmentType {get;set;}
        @AuraEnabled
        public string endDate{get;set;}
        @AuraEnabled
        public string effectiveDate {get;set;} 
        @AuraEnabled
        public String id {get;set;} 
        @AuraEnabled
        public String identifiertype {get;set;} 
        @AuraEnabled
        public String locationAffiliationID {get;set;}
        //Added this code snippet as part of user story US966923 to display future pcp and image - Rahul on 20/02/2017
           
        public Boolean getIsActive(){
            if(String.isEmpty(EffectiveDate) || String.isEmpty(EndDate)) return false; 
            
            Date objEffectiveDate = Date.newInstance(Integer.valueOf(EffectiveDate.split('/')[2]), Integer.valueOf(EffectiveDate.split('/')[0]), Integer.valueOf(EffectiveDate.split('/')[1]));
            Date objEndDate = Date.newInstance(Integer.valueOf(EndDate.split('/')[2]), Integer.valueOf(EndDate.split('/')[0]), Integer.valueOf(EndDate.split('/')[1]));
            
            return (Date.today() >= objEffectiveDate) && (Date.today() <= objEndDate);
        }  
        
        @AuraEnabled
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
        @AuraEnabled
        public boolean ContactStatus {get;set;}
        @AuraEnabled
        public String FirstName {get;set;}
        @AuraEnabled
        public String LastName {get;set;}   
        @AuraEnabled
        public String MiddleName {get;set;}
        @AuraEnabled
        public String effectiveDate {get;set;}
        @AuraEnabled
        public String terminationDate {get;set;}
        @AuraEnabled
        public string docLink {get;set;}          
    }
    public class statusLog{
        @AuraEnabled
        public boolean StatusAction{get;set;}
        @AuraEnabled
        public Date EffectiveDate{get;set;}
        @AuraEnabled
        public Date ChangedOn{get;set;}   
        @AuraEnabled
        public String Changedby{get;set;}
        @AuraEnabled
        public String Reason{get;set;}
        @AuraEnabled
        public String OperationInitiatedby{get;set;}
                 
    }

    public class FamilyMember {
        @AuraEnabled
        public String FirstName {get;set;}
        @AuraEnabled
        public String LastName {get;set;}
        @AuraEnabled
        public String MiddleInitial {get;set;}
        @AuraEnabled
        public String Relationship {get;set;}
        @AuraEnabled
        public String Gender {get;set;}     
        @AuraEnabled
        public String DOB {get;set;}   
        @AuraEnabled
        public String suffix {get;set;}     
        //added by Swetha//
        @AuraEnabled
        public String EID {get;set;}  
        @AuraEnabled
        public String Age {get;set;} //calculated from DOB 
        @AuraEnabled
        public String FamilyId {get;set;}
        @AuraEnabled
        public String subscriberIndividualId{get;set;}
        //Added by Rupsa to select table rows in Termination Enrollment, Reinstatement pages
        @AuraEnabled
        public Boolean selected {get; set;}
        @AuraEnabled
        public Date effectiveDate {get; set;}
        @AuraEnabled
        public Date termDate {get; set;}
        @AuraEnabled
        public Date reinstDate {get; set;}
        @AuraEnabled
        public String CoverageStatus{get;set;}
        @AuraEnabled
        public List<Address> Addresses {get;set;}
        @AuraEnabled
        public String memberStatus {get;set;}
        
        public FamilyMember(){
            selected = false;
        }
        @AuraEnabled
        public string groupNumber{get;set;}
        @AuraEnabled
        public string benefitBundleOptionId {get;set;}   
    }
    
    public class CoverageLine {
        @AuraEnabled
        Public String GUID {get;set;} //manually generated
        @AuraEnabled
        public String CoverageType {get;set;}
        @AuraEnabled
        public String CoverageTypeCode {get;set;}
        @AuraEnabled
        public String PolicyNumber {get;set;}
        @AuraEnabled
        public String GroupName {get;set;}
        @AuraEnabled
        public String GroupNumber {get;set;}
        @AuraEnabled
        public String Product {get;set;}
        @AuraEnabled
        public String ProductType {get;set;}
        @AuraEnabled
        public String Network {get;set;}
        @AuraEnabled
        public String EffectiveDate {get;set;}
        @AuraEnabled
        public String EndDate {get;set;}
        @AuraEnabled
        public String SourceCode {get;set;}
        @AuraEnabled
        public String CoverageLevel {get;set;}
        @AuraEnabled
        public String FundingArrangement {get;set;}
        @AuraEnabled
        public String BenefitPlanId {get;set;}
        @AuraEnabled
        public String PlanSitusState {get;set;}
        @AuraEnabled
        public String SurrogateKey {get;set;}
        @AuraEnabled
        public String OnshoreRestriction {get;set;}
        @AuraEnabled
        public String OnshoreRestrictionVerbiage {get;set;}
        @AuraEnabled
        public String EnrolleeSurrogateKey {get;set;}
        @AuraEnabled
        public String onshoreRestrictionCode {get; set;}//added by divya: to determine onshore/offshore restriction code
        @AuraEnabled
        public String relationShipCode {get;set;} //Code Added By Chandan -US1365690 //Need to check whether its required.
        @AuraEnabled
        public boolean isAdvanceSearched {get;set;}//Code Added By Chandan
        @AuraEnabled
        public boolean isSubscriber {get;set;} //Code Added By Chandan -US1365690
        @AuraEnabled
        public boolean isPreferred {get;set;}//bhanu:optimised
        @AuraEnabled
        public boolean isActive {get;set;}//bhanu:optimised
        @AuraEnabled
        public Integer daysGap {get;set;}
        @AuraEnabled
        Public String contractOptionId{get;set;}                    // getEmp V3 changes
        @AuraEnabled
        public String continuationResponsibilityType{get;set;}      // getEmp V3 changes    
        @AuraEnabled
        public String insuranceContinuationType{get;set;}           // getEmp V3 changes    
        
        
        public CoverageLine(){
            GUID = ACETGUIDUtil.newGuid(); 
            System.debug('SS GUID' + GUID);
            
        } 
        
        @AuraEnabled
        public String getGuidChanged()
        {
            CoverageLine obj = new CoverageLine();
            return obj.GUID;
        }
                        
        public Boolean getIsActive(){
            if(String.isEmpty(EffectiveDate) || String.isEmpty(EndDate)) return false; 
            
            Date objEffectiveDate = Date.newInstance(Integer.valueOf(EffectiveDate.split('/')[2]), Integer.valueOf(EffectiveDate.split('/')[0]), Integer.valueOf(EffectiveDate.split('/')[1]));
            Date objEndDate = Date.newInstance(Integer.valueOf(EndDate.split('/')[2]), Integer.valueOf(EndDate.split('/')[0]), Integer.valueOf(EndDate.split('/')[1]));
            
            return (Date.today() >= objEffectiveDate) && (Date.today() <= objEndDate);
        }  
        
        //Added this code snippet as part of user story US808419 to display future coverages also - Avish on 11/07/2017
        @AuraEnabled
        public String getImage(){ 
            String coverageStatus = '';
            if(EffectiveDate!=null && EndDate!=null){
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
           } 
            return coverageStatus;
        }                                
        
    }
     //added by Khoushik on 09/28/2016 for User Story - US378010
      public class COB {
        @AuraEnabled
        public String Name {get;set;}
        @AuraEnabled
          public String Relationship {get;set;}
        @AuraEnabled
          public String DateOfBirth {get;set;}
        @AuraEnabled
          public String InsuranceType {get;set;}
        @AuraEnabled
          public String medicareEntitlementType {get;set;}
        @AuraEnabled
          public String OtherInsuranceCarrierName {get;set;}
        @AuraEnabled
          public String COBTypeDesc {get;set;}// will map to coverage type desc
        @AuraEnabled
          public String IsOtherInsurancePrimary {get;set;}
        @AuraEnabled
          public String Startdt {get;set;}
        @AuraEnabled
          public String Enddt {get;set;}
        @AuraEnabled
          public String LastUpdate {get;set;}
        @AuraEnabled
          public String MedicareType {get;set;} 
        @AuraEnabled
          public String IsMedicarePrimary {get;set;}     
        @AuraEnabled
          public String EntitlementReason {get;set;}
        @AuraEnabled
          public Date PartAStart {get;set;}
        @AuraEnabled
          public Date PartBStart {get;set;}
        @AuraEnabled
          public Date PartDStart {get;set;}
        @AuraEnabled
          public Date PartAEnd {get;set;}
        @AuraEnabled
          public Date PartBEnd {get;set;}
        @AuraEnabled
          public Date PartDEnd {get;set;}
        @AuraEnabled
          public String Age {get;set;}
        @AuraEnabled
          public string otherInsuranceCardholderId {get;set;}
        @AuraEnabled
          public String CoverageTypeCode {get;set;} 
        @AuraEnabled
          public String OrderOfBenefit {get;set;}
        @AuraEnabled
          public String BenefitType {get;set;} 
        @AuraEnabled
          public String MemberId {get;set;}             
      }
    @AuraEnabled  
    public String MiddleName {get;set;} 
    @AuraEnabled  
    public String EligibilityStatus{get;set;} 
    @AuraEnabled  
    public Date TerminationDate{get;set;} 
    @AuraEnabled 
    public Date DateOfEmployment{get;set;} 
    @AuraEnabled  
    public String EmploymentStatus{get;set;} 
    @AuraEnabled  
    public String CoverageLevel{get;set;} 
    @AuraEnabled   
    public String GroupName{get;set;} 
    @AuraEnabled  
    public String EmploymentStartDate{get;set;}
    @AuraEnabled  
    public String ClaimAddressline1 {get;set;} 
    @AuraEnabled
    public String ClaimAddressline2 {get;set;} 
    @AuraEnabled
    public String ClaimAddresscity {get;set;} 
    @AuraEnabled
    public String ClaimAddressstate {get;set;} 
    @AuraEnabled
    public String ClaimAddresspostalCode {get;set;} 
    @AuraEnabled
    public String ClaimAddresscountyCode {get;set;} 
              

}