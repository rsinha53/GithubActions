public class ACETLGT_MemberSearchCoveragesResult implements Comparable{
    //Code Added By Ranjit
    @AuraEnabled Public String intType {get; set;}
    @AuraEnabled public set<string> IDs {get;set;}
    @AuraEnabled Public String SFrecId {get; set;}
    @AuraEnabled Public String Id {get; set;}
    @AuraEnabled Public String parentPEOId {get; set;}
    @AuraEnabled public string individualIdentifier{get;set;}
    @AuraEnabled public String lastName {get;set;}
    @AuraEnabled public String firstName {get;set;}  
    @AuraEnabled public String middleInitial {get;set;}
    @AuraEnabled public String middleName {get;set;}
    @AuraEnabled public String suffix {get;set;}
    @AuraEnabled public String fullName{get;set;}
    @AuraEnabled public String gender {get;set;}
    @AuraEnabled public String dob {get;set;}
    @AuraEnabled public String SCRId {get;set;}
    @AuraEnabled public String SSNum {get;set;}
    @AuraEnabled public String SSN {get;set;}
    @AuraEnabled public String address {get;set;}
    @AuraEnabled public String city {get;set;}
    @AuraEnabled public String state {get;set;}
    @AuraEnabled public String zip {get;set;}
    @AuraEnabled public String SurrogateKey {get;set;} 
    @AuraEnabled public Set<String> SurrogateKeys {get;set;}
    @AuraEnabled public String SurrogateKeysStr {get;set;}
    @AuraEnabled public String SourceCode {get;set;}
    @AuraEnabled public List<CoverageLine> CoverageLines {get;set;}
    @AuraEnabled public List<CoverageLine> MedicalCoverageLines {get;set;}
    @AuraEnabled public List<CoverageLine> PharmacyCoverageLines {get;set;}
    @AuraEnabled public String strCoverageLines {get;set;}
    @AuraEnabled public String EID{get;set;}
    @AuraEnabled public String CPTIN{get;set;}
    @AuraEnabled public String fullCPTIN{get;set;}
    @AuraEnabled public String selectedMemberId {get;set;}  //US:US1871358
    @AuraEnabled public String planType {get;set;}  //US2141411
    @AuraEnabled public List<SpecialtyBenefits> specialtyBenefits {get;set;} //Added by Abhinav - US3358395 Speciality Benefits
    //Added by Abhinav - US3358395 Speciality Benefits
    public class SpecialtyBenefits{
        @AuraEnabled public Boolean isActive{get;set;}  
        @AuraEnabled public Boolean isFuture{get;set;}  
        @AuraEnabled public Boolean isTermed{get;set;}  
        @AuraEnabled public String contractOptionTypeCode{get;set;}  
        @AuraEnabled public String planOptionID{get;set;}
        @AuraEnabled public String contractOptionStartDate{get;set;}  
        @AuraEnabled public String contractOptionEndDate{get;set;}  
    }
    public static String SortBy = 'LastName';
    public static String SortOrder = 'Asc';
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
    public String QMSCOIndicator {get;set;}
    @AuraEnabled
    public Boolean AffiliationIndicator {get;set;}  //US1840846
    @AuraEnabled
    public Boolean isServiceError {get;set;}
    
    
    @AuraEnabled
    public String MemberId {get;set;}
    
    
    @AuraEnabled
    public String RelationShip {get;set;}
    @AuraEnabled
    public String RelationShipCode {get;set;}
    @AuraEnabled
    public String OriginatorRelationship {get;set;}
    
    
    @AuraEnabled
    public String Age {get;set;}
    
    
    @AuraEnabled
    public String FullSSN {get;set;}
    @AuraEnabled
    public String SpokenLanguage {get;set;}
    @AuraEnabled
    public String WrittenLanguage {get;set;}
    @AuraEnabled public String Email {get;set;}
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
    Public String migrationSourceSystem {get;set;} //US2884153
    @AuraEnabled
    public String EffectiveDate {get;set;}
    //US2874415 Start
    @AuraEnabled
    public String parentGroup {get;set;}
    @AuraEnabled
    public String alphaParentGroup {get;set;}
    //US2874415 End
    @AuraEnabled
    public String EndDate {get;set;}
    @AuraEnabled
    public String Product {get;set;}
    @AuraEnabled
    public String ProductType {get;set;}
    
    @AuraEnabled
    public String BundleOptionID {get;set;}
    @AuraEnabled
    public String hsaAvailable {get;set;}
    
     //Rama:Added to get the coverage level from getMembeship
    @AuraEnabled
    public String CoverageLevelCode {get;set;}  
    @AuraEnabled 
    public String disability {get;set;} //US1074007
    @AuraEnabled 
    public List<DependentDisability> disabilityInfo {get;set;} //US1074007 
    @AuraEnabled
    public CoverageLine PreferredCoverage {get;set;}
    @AuraEnabled
    public CoverageLine PreferredCoverageInfo {get;set;}
    // getEmp V3 changes start
    @AuraEnabled
    public Map<string, List<string>> languageMap{get;set;}
    @AuraEnabled
    public string coverageGroupContractOptionFilterStatus{get;set;}
    @AuraEnabled
    public string GroupSize{get;set;}
    @AuraEnabled
    public string enrollmentMethod{get;set;}
    @AuraEnabled
    public CoverageGroupInfo coverageGroupInfo {get;set;}
    @AuraEnabled
    public String bookOfBusinessTypeCode{get;set;} //US3584878 : Added By Manish
    @AuraEnabled
    public String bookOfBusinessTypeDesc; //US3584878 : Added By Manish
    public class CoverageGroupInfo{
        @AuraEnabled public String coverageGroupContractOptionId{get;set;}  
        @AuraEnabled public String coverageGroupContractOptionEffDate{get;set;}  
        @AuraEnabled public String coverageGroupContractOptionStatus{get;set;}  
        @AuraEnabled public String coverageGroupContractOptionFilterStatus{get;set;}  
        @AuraEnabled public String exchangeType{get;set;}  
        @AuraEnabled public String exchangeState{get;set;}  
        @AuraEnabled public boolean hasPopulation{get;set;} 
        @AuraEnabled public String onshoreRestrictionCode{get;set;}  
        @AuraEnabled public String OnshoreRestrictionVerbiage{get;set;} 
        @AuraEnabled public Boolean onshoreRestrictionError{get;set;} 
        
        @AuraEnabled public boolean isRestrict{get;set;}  
        
        @AuraEnabled public String contractOptionPopulations{get;set;}  
        // Coverage Details
        @AuraEnabled public String SitusState {get;set;}                                         
        @AuraEnabled public String FundingArragement {get;set;}
        @AuraEnabled public String GroupSize {get;set;}
        @AuraEnabled public String enrollmentMethod {get;set;}
        @AuraEnabled public String gatedPlanIndicator {get;set;} 
        @AuraEnabled public String migrationSourceSystem {get;set;} ////US2884153
        @AuraEnabled public String parentGroup {get;set;} //US2874415
        @AuraEnabled public String alphaParentGroup {get;set;} //US2874415
        @AuraEnabled public String onshoreRestriction{get;set;}
        @AuraEnabled public String onshoreRestrictionDisp{get;set;}
        
        //Eligibility Details
        @AuraEnabled public String benefitAdmin{get;set;}         
        @AuraEnabled public String benefitAdminPhone{get;set;}   
        @AuraEnabled public String responsibilityType{get;set;}            
        @AuraEnabled public String continuationType{get;set;}              
        @AuraEnabled public string cobraAdministrativeIndicator{get;set;}
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
   
   // public String MembershipSurrogateKey {get;set;} 
    
    @AuraEnabled
    public String EnrolleeSurrogateKey {get;set;}
    @AuraEnabled
    public string onshore{get;set;}
    @AuraEnabled
    public List<CoverageLineHistory> lstCoverageLineHistory {get;set;}
    
    
    
    
    public ACETLGT_MemberSearchCoveragesResult () {
        SurrogateKeys = new Set<String>(); 
        Ids = new Set<String>();     
    }
     
        
    public Integer compareTo(Object objToCompare){
        ACETLGT_MemberSearchCoveragesResult memberToCompare = (ACETLGT_MemberSearchCoveragesResult )objToCompare;
                
        if(memberToCompare == null) return 1;
        
        Integer compareResult = 0;
        if(SortBy == 'ID'){
            compareResult = (ID == null? -1 : (ID.compareTo(memberToCompare.ID)));          
        }else if(sortBy == 'LastName'){
            compareResult = (LastName == null? -1 : (LastName.compareTo(memberToCompare.LastName)));            
        }else if(sortBy == 'FirstName'){
            compareResult = (FirstName == null? -1 : (FirstName.compareTo(memberToCompare.FirstName)));         
        }else if(sortBy == 'MiddleInitial'){
            compareResult = (MiddleInitial == null? -1 : (MiddleInitial.compareTo(memberToCompare.MiddleInitial)));         
        }else if(sortBy == 'Gender'){
            compareResult = (Gender == null? -1 : (Gender.compareTo(memberToCompare.Gender)));          
        }else if(sortBy == 'DOB'){
            compareResult = (DOB == null? -1 : (DOB.compareTo(memberToCompare.DOB)));           
        }else if(sortBy == 'SSN'){
            compareResult = (SSN == null? -1 : (SSN.compareTo(memberToCompare.SSN)));           
        }else if(sortBy == 'Address'){
            compareResult = (Address == null? -1 : (Address.compareTo(memberToCompare.Address)));           
        }else if(sortBy == 'City'){
            compareResult = (City == null? -1 : (City.compareTo(memberToCompare.City)));            
        }else if(sortBy == 'State'){
            compareResult = (State == null? -1 : (State.compareTo(memberToCompare.State)));         
        }else if(sortBy == 'Zip'){
            compareResult = (Zip == null? -1 : (Zip.compareTo(memberToCompare.Zip)));           
        }else if(sortBy == 'Coverages'){
            if( memberToCompare.CoverageLines != null && memberToCompare.CoverageLines.size() > 0){
                for(CoverageLine cov : memberToCompare.CoverageLines) {
                    //compareResult = (CoverageLine.CoverageType == null? -1 : (CoverageLine.CoverageType.compareTo(cov.CoverageType)));
                }
                /**for(CoverageLine cov : memberToCompare.CoverageLines) {
                    compareResult = (cov.EffectiveDate == null? -1 : (EffectiveDate.compareTo(memberToCompare.EffectiveDate)));
                }
                for(CoverageLine cov : memberToCompare.CoverageLines) {
                    compareResult = (cov.EndDate == null? -1 : (EndDate.compareTo(memberToCompare.EndDate)));
                }**/
            }else
                 compareResult = -1;
        }
        
        if(SortOrder != 'Asc') compareResult = compareResult * -1;
        return compareResult;
    }
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
        //US3806899 Start
        @AuraEnabled
        public String assignmentLevel {get;set;}
        @AuraEnabled
        public String organizationName {get;set;}
        @AuraEnabled
        public String organizationId {get;set;}
        //US3806899 End
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
            Date objEffectiveDate;
            Date objEndDate;
            if(EffectiveDate != null)
            objEffectiveDate = Date.newInstance(Integer.valueOf(EffectiveDate.split('/')[2]), Integer.valueOf(EffectiveDate.split('/')[0]), Integer.valueOf(EffectiveDate.split('/')[1]));
            
            if(EndDate != null)
            objEndDate = Date.newInstance(Integer.valueOf(EndDate.split('/')[2]), Integer.valueOf(EndDate.split('/')[0]), Integer.valueOf(EndDate.split('/')[1]));
            
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
        public String relationshipType {get;set;}
        @AuraEnabled
        public String Type {get;set;}
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
        public String fullName {get;set;}
        @AuraEnabled
        public String SFrecId {get;set;}
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
        public String ESRK{get;set;}
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
        @AuraEnabled
        public string accountid {get;set;}   
    
        @AuraEnabled
        public string srk {get;set;} 
        @AuraEnabled
        public string Relationshiplabel {get;set;} 
    }
    
    public class CoverageLine implements Comparable{
        @AuraEnabled public boolean isTermed {get;set;}
        @AuraEnabled public string accumAsOfDate  {get;set;}
        @AuraEnabled public boolean isFuture {get;set;}
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
        public String LatestCOStartDate {get;set;}
        @AuraEnabled
        public String LatestCOEndDate {get;set;}
        @AuraEnabled
        public String BenEffectiveDate {get;set;}
        @AuraEnabled
        public String BenEndDate {get;set;}
         @AuraEnabled
        public String SourceCode {get;set;}
        @AuraEnabled
        public String CoverageLevel {get;set;}
        @AuraEnabled
        public String CoverageLevelCode {get;set;}
        @AuraEnabled
        public String FundingArrangement {get;set;}
        @AuraEnabled
        public String BenefitPlanId {get;set;}
        @AuraEnabled
        public String benefitPlanName {get;set;}   
        @AuraEnabled
        public String planOptionID {get;set;}
        @AuraEnabled
        public String riderOnlyIndicator {get;set;}
        @AuraEnabled
        public ActiveCPVersions activeCPVersions{get;set;}
        @AuraEnabled
        public String pharmacyIndicator {get;set;}
        @AuraEnabled
        public String customerPurchaseId {get;set;}
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
        public boolean isEnrollee {get;set;} //Code Added By Chandan -US1365690
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
        
        @AuraEnabled
        public String benefitBundleOptionId{get;set;}           // getEmp V3 changes    
        @AuraEnabled
        public String memberId {get;set;}
        @AuraEnabled
        public String subscriberId {get;set;}
        @AuraEnabled
        public String memberStatus {get;set;}
        @AuraEnabled
        public String DOB {get;set;}
        @AuraEnabled
        public String Age {get;set;}
        @AuraEnabled
        public String subjectId {get;set;}
        @AuraEnabled
        public String originatorId {get;set;}
        //  US2265866 : Subject/Originator relationship
        @AuraEnabled
        public String subjectRelation {get;set;}
        @AuraEnabled
        public String subjectRelationCode {get;set;}
        @AuraEnabled
        public String hsaPlan {get;set;}
        @AuraEnabled
        public String bookOfBusinessTypeCode{get;set;}
		@AuraEnabled
        Public String ContractOptionStartDate {get;set;}
        @AuraEnabled
        Public String ContractOptionEndDate {get;set;}
		@AuraEnabled
        Public List<ActiveCPVersions> activeCPs{get;set;}			
        
        public CoverageLine(){
            GUID = ACETGUIDUtil.newGuid();
            system.debug('SSSGUID' + GUID);
        }  
        
        public Integer compareTo(Object objToCompare){
            CoverageLine covToCompare = (CoverageLine)objToCompare;
                    
            if(covToCompare == null || covToCompare.CoverageType == null) return 1;
            
            system.debug('======>>'+this.CoverageType);
            system.debug('======>>'+covToCompare);
            system.debug('======>>'+covToCompare.CoverageType);
            Integer compareResult;
            if(this.CoverageType != null)
                compareResult = this.CoverageType.compareTo(covToCompare.CoverageType);
            
            if (compareResult != 0) {
                return compareResult;
            } else {
                //return this.daysGap.compareTo(covToCompare.daysGap);
                if (this.daysGap == covToCompare.daysGap) return 0;
                if (this.daysGap > covToCompare.daysGap) return 1;
                return -1;
            }
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
            Date objEffectiveDate;
            if(EffectiveDate != null)
             objEffectiveDate = Date.newInstance(Integer.valueOf(EffectiveDate.split('/')[2]), Integer.valueOf(EffectiveDate.split('/')[0]), Integer.valueOf(EffectiveDate.split('/')[1]));
            else
              objEffectiveDate = null;  
            Date objEndDate ;
            
            if(objEndDate != null)
                objEndDate = EndDate != null && EndDate != '' ? Date.newInstance(Integer.valueOf(EndDate.split('/')[2]), Integer.valueOf(EndDate.split('/')[0]), Integer.valueOf(EndDate.split('/')[1])): null;
            else
                objEndDate = null;
            
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
    
     public class ActiveCPVersions{
        @AuraEnabled
          public String customerPurchaseId{get;set;}
        @AuraEnabled
          public String contractOptionStartDate{get;set;}
        @AuraEnabled
          public String contractOptionEndDate{get;set;}
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
    public String EligibilityStatus{get;set;} 
    @AuraEnabled  
    public String TerminationDate{get;set;} 
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
	@AuraEnabled
    public List<CustomerPurchase> customerPurchase{get;set;}
    
    
    public class CustomerPurchase {
        @AuraEnabled
        public String coverageStartDate{get;set;}
        @AuraEnabled
        public String coverageExpirationDate{get;set;}
        @AuraEnabled
        public String benefitBundleOptionID{get;set;}
        @AuraEnabled
        public String memberGroupContractPlanOptionID{get;set;}
        @AuraEnabled
        public List<lineOfBussiness> lineOfBussiness{get;set;} //US3584878 : Added By Suresh
        @AuraEnabled
        public String bookOfBusinessTypeDescription{get;set;} //US3584878 : Added By Suresh
        @AuraEnabled
        public String bookOfBusinessTypeCode{get;set;} //US3584878 : Added By Suresh
    }
    public class lineOfBussiness { //US3584878 : Added By Suresh
        @AuraEnabled
        public String name{get;set;}
        @AuraEnabled
        public String description{get;set;}
    }
              
}