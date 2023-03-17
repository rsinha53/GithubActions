public class SAEMemberProviderSearchCoveragesResult implements Comparable{
    
    @AuraEnabled Public String intType {get; set;}
    @AuraEnabled public set<string> IDs {get;set;}
    @AuraEnabled Public String Id {get; set;}
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
    @AuraEnabled public String ssn {get;set;}
    @AuraEnabled public String address {get;set;}
    @AuraEnabled public String city {get;set;}
    @AuraEnabled public String state {get;set;}
    @AuraEnabled public String zip {get;set;}
    @AuraEnabled public String SurrogateKey {get;set;}
    @AuraEnabled public Set<String> SurrogateKeys {get;set;}
    @AuraEnabled public String SurrogateKeysStr {get;set;}
    @AuraEnabled public String SourceCode {get;set;}
    @AuraEnabled public List<CoverageLine> CoverageLines {get;set;}
    @AuraEnabled public String strCoverageLines {get;set;}
    @AuraEnabled public String EID{get;set;}
    @AuraEnabled public String CPTIN{get;set;}
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
    @AuraEnabled
    public String QMSCOIndicator {get;set;}
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
    public String gatedPlanIndicator {get;set;}
    @AuraEnabled
    public String EffectiveDate {get;set;}
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
    @AuraEnabled
    public String CoverageLevelCode {get;set;}
    @AuraEnabled
    public String benefitAdmin{get;set;}
    @AuraEnabled
    public String benefitAdminPhone{get;set;}
    @AuraEnabled
    public String disability {get;set;}
    @AuraEnabled
    public List<DependentDisability> disabilityInfo {get;set;}
    @AuraEnabled
    public CoverageLine PreferredCoverage {get;set;}
    @AuraEnabled
    public String GroupSize {get;set;}
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
    public List<Address> Addresses {get;set;}
    @AuraEnabled
    public List<Phone> Phones {get;set;}
    @AuraEnabled
    public PCPAssignment PCPAssignments {get;set;}
    @AuraEnabled
    public List<FamilyMember> FamilyMembers {get;set;}
    
    @AuraEnabled
    public MemberEligibilityCoverage EligibilityCoverage {get;set;}
    
    @AuraEnabled
    public List<otherContact> ROIcontacts {get;set;}
    @AuraEnabled
    public List<statusLog> MemberStatusLogs{get;set;}
    @AuraEnabled
    public Map<String,String> GroupVsOnshoreIndicator {get;set;}
    @AuraEnabled
    public List<COB> lstCOB {get;set;}
    
    @AuraEnabled
    public String EnrolleeSurrogateKey {get;set;}
    @AuraEnabled
    public string onshore{get;set;}
    @AuraEnabled
    public List<CoverageLineHistory> lstCoverageLineHistory {get;set;}
    @AuraEnabled
    public MemberCard memberCardView {get;set;}
    //US2137922: Added by Ravindra
    public class PatientInfo {
        @AuraEnabled public String fullName;
        @AuraEnabled public String MemberId;
        @AuraEnabled public String dob;
        @AuraEnabled public String Age;
        @AuraEnabled public String gender;
        @AuraEnabled public String AddressLine1;
        @AuraEnabled public String AddressLine2;
        @AuraEnabled public String City;
        @AuraEnabled public String State;
        @AuraEnabled public String Zip;
        @AuraEnabled public String patientKey; // US1741780
        @AuraEnabled public String relationship; // US3089172 - Sarma

        // Policy Switching
        @AuraEnabled public String xRefId;
        @AuraEnabled public String xRefIdORS;
        @AuraEnabled public String dobVal;
        @AuraEnabled public String firstName;//US3814287
    }
    
    public class MemberCard{
        @AuraEnabled public String name {get;set;}
        @AuraEnabled public String memberId{get;set;}
        @AuraEnabled public String dob{get;set;}
        @AuraEnabled public String Age{get;set;}
        @AuraEnabled public String phone{get;set;}
        @AuraEnabled public String address{get;set;}
        @AuraEnabled public String gender{get;set;}
        @AuraEnabled public String pcpProvider{get;set;}
        @AuraEnabled public String pcpProviderhistory{get;set;}
    }
    
    public SAEMemberProviderSearchCoveragesResult () {
        SurrogateKeys = new Set<String>();
        Ids = new Set<String>();
    }
    
    public Integer compareTo(Object objToCompare){
        SAEMemberProviderSearchCoveragesResult memberToCompare = (SAEMemberProviderSearchCoveragesResult)objToCompare;
        
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
    
    public class CoverageLineHistory{
        @AuraEnabled
        public string covLevelCode {get;set;}
        @AuraEnabled
        public string covLevelDesc {get;set;}
        @AuraEnabled
        public Date covLevelEffDate {get;set;}
        @AuraEnabled
        public Date covLevelExpDate {get;set;}
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
        public Boolean NoPCPFlag{get;set;}
        @AuraEnabled
        public String providerPCP{get;set;}
        @AuraEnabled
        public String FirstName {get;set;}
        @AuraEnabled
        public String LastName {get;set;}
        // US2099074 - sanka
        @AuraEnabled
        public String State {get;set;}
        @AuraEnabled
        public String Street1 {get;set;}
        @AuraEnabled
        public String Street2 {get;set;}
        @AuraEnabled
        public String Zip {get;set;}
        // End
        
        @AuraEnabled
        public String middleName {get;set;}
        @AuraEnabled
        public String fullName {get;set;}
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
    
    public class DeductibleInfo {
        @AuraEnabled public Boolean found{get;set;}
        @AuraEnabled public Boolean nonMainPlan{get;set;}
        @AuraEnabled public Boolean inAndOutOfNetworkOnly{get;set;}
        @AuraEnabled public String message{get;set;}
        @AuraEnabled public Individual individual{get;set;}
        @AuraEnabled public Individual family{get;set;}
    }
    
    public class OutOfPocketInfo {
        @AuraEnabled public Boolean found{get;set;}
        @AuraEnabled public Boolean nonMainPlan{get;set;}
        @AuraEnabled public Boolean inAndOutOfNetworkOnly{get;set;}
        @AuraEnabled public String message{get;set;}
        @AuraEnabled public Individual individual{get;set;}
        @AuraEnabled public Individual family{get;set;}
    }
    
    public class Individual {
        @AuraEnabled public Boolean found{get;set;}
        @AuraEnabled public InNetwork inNetwork{get;set;}
        @AuraEnabled public InNetwork outOfNetwork{get;set;}
        @AuraEnabled public InNetwork inNetworkTier1{get;set;}
    }
    
    public class InNetwork {
        @AuraEnabled public Boolean found{get;set;}
        @AuraEnabled public Boolean customerNetworkTier1{get;set;}
        @AuraEnabled public String planAmount{get;set;}
        @AuraEnabled public String planAmountFrequency{get;set;}
        @AuraEnabled public String remainingAmount{get;set;}
        @AuraEnabled public String metYtdAmount{get;set;}
    }
    
    public class CoverageLine {
        //US2137922: Added by Ravindra
        @AuraEnabled public PatientInfo patientInfo {get;set;}
        @AuraEnabled public DeductibleInfo deductibleInfo {get;set;}
        @AuraEnabled public  OutOfPocketInfo outOfPocketInfo{get;set;}
        @AuraEnabled public PCPAssignment pcpAssignment {get;set;}
        //US2611720 _vishnu
                    @AuraEnabled public FinanciDeOutalFlags finDeOutFlgs {get;set;}
        @AuraEnabled public boolean isFuture {get;set;}
        @AuraEnabled
        Public String GUID {get;set;} //manually generated
        @AuraEnabled
        public String CoverageType {get;set;}
        @AuraEnabled
        public String actualCoverageType {get;set;} // US2356238 - new val for create Auth
        @AuraEnabled
        public String CoverageTypeCode {get;set;}
        @AuraEnabled
        public String insuranceTypeCode {get;set;}
        @AuraEnabled
		public String lineOfBusiness {get;set;}//US3116511 TTAP Vishnu
        @AuraEnabled
        public Boolean administeredByUhc {get;set;}
        @AuraEnabled
        public String paidThroughDate {get;set;}
        @AuraEnabled
        public String eligibleDates {get;set;}
        @AuraEnabled
        public String planStatus {get;set;}
        @AuraEnabled
        public String referral {get;set;}
        @AuraEnabled
        public String cosmosDelegatedEntity {get;set;} //US3584388
        @AuraEnabled
        public String PolicyName {get;set;}
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
        public boolean termedFlag {get;set;} //US2061732 - Added by Avish
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
        public String onshoreRestrictionCode {get; set;}
        @AuraEnabled
        public String relationShipCode {get;set;}
        @AuraEnabled
        public boolean isAdvanceSearched {get;set;}
        @AuraEnabled
        public boolean isSubscriber {get;set;}
        @AuraEnabled
        public boolean isPreferred {get;set;}
        @AuraEnabled
        public boolean isActive {get;set;}
        @AuraEnabled
        public Integer daysGap {get;set;}
        @AuraEnabled
        Public String contractOptionId{get;set;}
        @AuraEnabled
        public String continuationResponsibilityType{get;set;}
        @AuraEnabled
        public String insuranceContinuationType{get;set;}
        @AuraEnabled
        public Boolean nonMedicalPolicyBoolean {get;set;}
        @AuraEnabled
        public Boolean highlightedPolicy {get;set;}
        @AuraEnabled
        public String transactionId {get;set;}
        @AuraEnabled
        public String concatAddress {get;set;}
        // US1741780 
        @AuraEnabled
        public String policyId {get;set;} 
        @AuraEnabled public String addressLine1 {get;set;}
        @AuraEnabled public String city {get;set;}
        @AuraEnabled public String state {get;set;}
        @AuraEnabled public String zip {get;set;}
        
        //US2974242
        @AuraEnabled public string strGraceMessageByState {get;set;} {strGraceMessageByState = '';}
        @AuraEnabled public string strGracePaidThrough {get;set;} {strGracePaidThrough = '';}
        @AuraEnabled public string strGracePeriodMonth {get;set;} {strGracePeriodMonth = '';}
        // Financial Benefits - Sanka Dharmasena
        // US1730904
        @AuraEnabled
        public FinancialsWrapper financialWrapper{get;set;}
        
        @AuraEnabled public EligibilityDates eligibilityDates;

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
    //US2611720 _vishnu
        	public class FinanciDeOutalFlags {
    			@AuraEnabled public Boolean deductibleInfoFlg{get;set;}
    			@AuraEnabled public Boolean deindividualFlg{get;set;}
    			@AuraEnabled public Boolean deIndInnFlg{get;set;}
    			@AuraEnabled public Boolean deIndOonFlg{get;set;}
    			@AuraEnabled public Boolean deIndTier1Flg{get;set;}
    			@AuraEnabled public Boolean deFamilyFlg{get;set;}
    			@AuraEnabled public Boolean deFlmInnFlg{get;set;}
    			@AuraEnabled public Boolean deFlmOonFlg{get;set;}
    			@AuraEnabled public Boolean deFlmTier1Flg{get;set;}
    			@AuraEnabled public Boolean outofpocketInfoFlg{get;set;}
    			@AuraEnabled public Boolean outindividualFlg{get;set;}
    			@AuraEnabled public Boolean outIndInnFlg{get;set;}
    			@AuraEnabled public Boolean outIndOonFlg{get;set;}
    			@AuraEnabled public Boolean outIndTier1Flg{get;set;}
    			@AuraEnabled public Boolean outFamilyFlg{get;set;}
    			@AuraEnabled public Boolean outFlmInnFlg{get;set;}
    			@AuraEnabled public Boolean outFlmOonFlg{get;set;}
    			@AuraEnabled public Boolean outFlmTier1Flg{get;set;}
    			}

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
        public Date Startdt {get;set;}
        @AuraEnabled
        public Date Enddt {get;set;}
        @AuraEnabled
        public Date LastUpdate {get;set;}
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
    
    // US1730904 - Financials PHS
    // Sanka Dharmasena - 20-06-2019
    public class Financials
    {
        // Deductibles - Individual
        @AuraEnabled
        public Boolean dedFound{get;set;}
        @AuraEnabled
        public Decimal deductible{get;set;}
        @AuraEnabled
        public Decimal dedAmountRem{get;set;}
        @AuraEnabled
        public Decimal dedSatisfied{get;set;}
        @AuraEnabled
        public Decimal dedPrecentage{get;set;}
        
        // Deductibles - Family
        @AuraEnabled
        public Boolean dedFoundFam{get;set;}
        @AuraEnabled
        public Decimal deductibleFam{get;set;}
        @AuraEnabled
        public Decimal dedAmountRemFam{get;set;}
        @AuraEnabled
        public Decimal dedSatisfiedFam{get;set;}
        @AuraEnabled
        public Decimal dedFamPrecentage{get;set;}
        
        // OOP - Individual
        @AuraEnabled
        public Boolean outOPFound{get;set;}
        @AuraEnabled
        public Decimal outOP{get;set;}
        @AuraEnabled
        public Decimal outOPRemAmount{get;set;}
        @AuraEnabled
        public Decimal outOPSatisfied{get;set;}
        @AuraEnabled
        public Decimal oopPrecentage{get;set;}
        
        // OOP - Family
        @AuraEnabled
        public Boolean outOPFoundFam{get;set;}
        @AuraEnabled
        public Decimal outOPFam{get;set;}
        @AuraEnabled
        public Decimal outOPRemAmountFam{get;set;}
        @AuraEnabled
        public Decimal outOPSatisfiedFam{get;set;}
        @AuraEnabled
        public Decimal oopFamPrecentage{get;set;}
        
        //OutOfPocketMax - Individual
        @AuraEnabled
        public Boolean OOP_Limit_2_Found{get;set;}
        @AuraEnabled
        public Decimal OOP_Limit_2{get;set;}
        @AuraEnabled
        public Decimal OOP_Limit_2_Satisfied{get;set;}
        @AuraEnabled
        public Decimal OOP_Limit_2_Rem{get;set;}
        @AuraEnabled
        public Decimal OOP_Limit_2_Precentage{get;set;}
        
        //OutOfPocketMax - Family
        @AuraEnabled
        public Boolean OOP_Limit_2_Found_Family{get;set;}
        @AuraEnabled
        public Decimal OOP_Limit_2_Family{get;set;}
        @AuraEnabled
        public Decimal OOP_Limit_2_Satisfied_Family{get;set;}
        @AuraEnabled
        public Decimal OOP_Limit_2_Rem_Family{get;set;}
        @AuraEnabled
        public Decimal OOP_Limit_2_Precentage_Family{get;set;}
        
        //CopayMax - Individual
        @AuraEnabled
        public Boolean CopayMax_Found{get;set;}
        @AuraEnabled
        public Decimal CopayMax{get;set;}
        @AuraEnabled
        public Decimal CopayMax_Satisfied{get;set;}
        @AuraEnabled
        public Decimal CopayMax_Remaining{get;set;}
        @AuraEnabled
        public Decimal CopayMax_Precentage{get;set;}
        
        //CopayMax - Family
        @AuraEnabled
        public Boolean CopayMax_Found_Family{get;set;}
        @AuraEnabled
        public Double CopayMax_Family{get;set;}
        @AuraEnabled
        public Decimal CopayMax_Satisfied_Family{get;set;}
        @AuraEnabled
        public Decimal CopayMax_Remaining_Family{get;set;}
        @AuraEnabled
        public Decimal CopayMax_Precentage_Family{get;set;}
        
        // Medical Life Maximum - Add in the future
        //Individual
        // Family
        
        //---------------------//
        // Table values
        @AuraEnabled
        public Double DedCarryOverAmt{get;set;}
        @AuraEnabled
        public Double ComDED{get;set;}
        @AuraEnabled
        public Double ComOOP{get;set;}
        @AuraEnabled
        public Double CrossApplyOOP{get;set;}
        @AuraEnabled
        public Double OOP2Remaining{get;set;}
        @AuraEnabled
        public Double CrossApplyOOP2{get;set;}
        @AuraEnabled
        public Double CopayMaxSatisfied{get;set;}
        @AuraEnabled
        public Double CopayMaxRemaining{get;set;}
        @AuraEnabled
        public Double CrossApplyCopayMax{get;set;}
        @AuraEnabled
        public Double DedCarryOverAmt_Family{get;set;}
        @AuraEnabled
        public Double ComDED_Family{get;set;}
        @AuraEnabled
        public Double ComOOP_Family{get;set;}
        @AuraEnabled
        public Double CrossApplyOOP_Family{get;set;}
        @AuraEnabled
        public Double OOP2Remaining_Family{get;set;}
        @AuraEnabled
        public Double CrossApplyOOP2_Family{get;set;}
        @AuraEnabled
        public Double CopayMaxSatisfied_Family{get;set;}
        @AuraEnabled
        public Double CopayMaxRemaining_Family{get;set;}
        @AuraEnabled
        public Double CrossApplyCopayMax_Family{get;set;}
    }
    
    public class EligibilityDates {
        @AuraEnabled public String startDate;
        @AuraEnabled public String endDate;
    }

    public class FinancialsWrapper
    {
        @AuraEnabled
        public String yearType{get;set;}
        @AuraEnabled
        public String displayYear{get;set;}
        @AuraEnabled
        public Financials inNetwork {get;set;}
        @AuraEnabled
        public Financials onNetwork {get;set;}
        @AuraEnabled
        public Financials tierOne {get;set;}
        //US1901028 - Member CDHP Integration - Sarma - 29/08/2019
        @AuraEnabled
        public Boolean isHra {get;set;}
        @AuraEnabled
        public Double hraVal {get;set;}
    }
}