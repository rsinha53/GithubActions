public with sharing class SAETTSCaseWrapper {
    //US1970508 - Ravindra - start
    //provider flow info
    @AuraEnabled public Boolean providerNotFound {get;set;}
    @AuraEnabled public Boolean noProviderToSearch {get;set;}
    @AuraEnabled public Boolean isOtherSearch {get;set;}
    @AuraEnabled public Boolean noMemberToSearch {get;set;}
    @AuraEnabled public String mnf {get;set;}
    @AuraEnabled public String memberContactId {get;set;}
    @AuraEnabled public String providerContactId {get;set;}
    //US1970508 - Ravindra - end
    // Case
    @AuraEnabled public String Status {get;set;}
    @AuraEnabled public String Interaction {get;set;}

    //US2587781 - Avish
    @AuraEnabled public String contactNumber {get;set;}
    @AuraEnabled public String contactExt {get;set;}
    //US2587781 - Avish - Ends

    // US2412544 -> Case - 'SLA' - Populate the Field
    @AuraEnabled public decimal slaDay {get;set;}

    // Originator
    //US1970508 - Ravindra - start
    @AuraEnabled public String ContactId {get;set;}
    @AuraEnabled public String providerId {get;set;}
    //US1970508 - Ravindra - end
    @AuraEnabled public String OriginatorName {get;set;}
    @AuraEnabled public String OriginatorRelationship {get;set;}
    @AuraEnabled public String OriginatorType{get;set;}
    @AuraEnabled public String OriginatorPhone {get;set;}
    @AuraEnabled public String OriginatorEmail {get;set;}
    @AuraEnabled public String OriginatorContactName {get;set;}
    //US2740876 - Sravan - Start
    @AuraEnabled public String OriginatorFirstName {get;set;}
    @AuraEnabled public String OriginatorLastName {get;set;}
    //US2740876 - Sravan - End

    // Subject
    @AuraEnabled public String SubjectName {get;set;}
    @AuraEnabled public String SubjectType {get;set;}
    @AuraEnabled public String SubjectDOB {get;set;}
    @AuraEnabled public String SubjectId {get;set;}
    @AuraEnabled public String SubjectGroupId {get;set;}
	@AuraEnabled public String SubjectAge {get;set;} // US2098661 - Thanish
	@AuraEnabled public String SubjectMemberSSN {get;set;}
	@AuraEnabled public STring SubjectSitus {get;set;}
	@AuraEnabled public String Relationship {get;set;} //vinay
    @AuraEnabled public String Comments {get;set;}//vinay
    @AuraEnabled public String manualEnteredComments {get;set;}//vinay
    @AuraEnabled public String concatinatedComments {get;set;}//vinay
    @AuraEnabled public String departmentAPI {get;set;}//vinay
    @AuraEnabled public String officeAPI{get;set;}//vinay
    @AuraEnabled public String teamAPI {get;set;}//vinay
    @AuraEnabled public String associateId{get;set;}//vinay
    @AuraEnabled public String freeFormCommentsVal {get;set;}
    @AuraEnabled public String RelationshipCode {get;set;}//Vinay

    @AuraEnabled public String EEID {get;set;}//US3248222 - Praveen

    //US2098644-Member Not Found - Cases Created in ACET Feed to ORS-Sravan-Start
    @AuraEnabled public String stateCode {get;set;}
    @AuraEnabled public String subjectPhoneNumber {get;set;}
    @AuraEnabled public String subjectFirstName {get;set;}
    @AuraEnabled public String subjectLastName {get;set;}
    //US2098644-Member Not Found - Cases Created in ACET Feed to ORS-Sravan-End

    // Addtional Info
    @AuraEnabled public String MisdirectReason {get;set;}
    @AuraEnabled public String misdirectComments {get;set;}
    @AuraEnabled public String AddInfoTopic {get;set;}
    @AuraEnabled public String AddInfoOrginType {get;set;}
    @AuraEnabled public String AddInfoOrginSubType {get;set;}

    // Case Comments
    @AuraEnabled public String CommentPublic {get;set;}
    @AuraEnabled public String CommentDesc {get;set;}

    // US1753077 - Pilot Enhancement - Save Case - Validations and Additional Functionality: Kavinda
    // Validation & Addiotional Information relvent to Case
    @AuraEnabled public Integer PolicyCount {get;set;}
    @AuraEnabled public String CaseCreationFrom {get;set;}

    // US2091974 - Sanka - Case Creation
    @AuraEnabled public String TaxId{get;set;}
    @AuraEnabled public String ttsType{get;set;}
    @AuraEnabled public String ttsSubType{get;set;}

    // US2435572 - Sanka - ORS Case Creation
    @AuraEnabled public String providerNPI{get;set;}
    @AuraEnabled public String degree{get;set;}
    @AuraEnabled public String policyNumber{get;set;}
    @AuraEnabled public String alternateId{get;set;}
    @AuraEnabled public String benefitPackage{get;set;}

    //US - Autodoc
    @AuraEnabled public String AutoDoc{get;set;}
    @AuraEnabled public String AutoDocCaseItems{get;set;}

    // US2098661 - Thanish - Provider Lookup Details for ORS Case Creation
    @AuraEnabled public String plFirstName{get;set;}
    @AuraEnabled public String plLastName{get;set;}
    @AuraEnabled public String plFirstInitial{get;set;}
    @AuraEnabled public String plMpin{get;set;}
    @AuraEnabled public String plProviderID{get;set;}
    @AuraEnabled public String plState{get;set;}
    @AuraEnabled public String plStreet1{get;set;}
    @AuraEnabled public String plStreet2{get;set;}
    @AuraEnabled public String plZip{get;set;}
    @AuraEnabled public String plTaxId{get;set;}
    @AuraEnabled public String plTaxPrefix{get;set;}
    @AuraEnabled public String plTaxSuffix{get;set;}

    // US2098661 - Thanish - condition attribute for ORS Case Creation
    @AuraEnabled public Boolean createORSCase{get;set;}

    //DE315146 - Sanka
    @AuraEnabled public String mnfExternalId{get;set;}
    //DE315205
    @AuraEnabled public String pnfExternalId{get;set;}

    // US2099074 - Sanka - ORS PCP Info
    @AuraEnabled public String pcpFirstName{get;set;}
    @AuraEnabled public String pcpLastName{get;set;}
    @AuraEnabled public String pcpFirstInitial{get;set;}
    @AuraEnabled public String pcpMpin{get;set;}
    @AuraEnabled public String pcpProviderID{get;set;}
    @AuraEnabled public String pcpState{get;set;}
    @AuraEnabled public String pcpStreet1{get;set;}
    @AuraEnabled public String pcpStreet2{get;set;}
    @AuraEnabled public String pcpZip{get;set;}
    @AuraEnabled public String pcpTaxId{get;set;}
    @AuraEnabled public String pcpTaxPrefix{get;set;}
    @AuraEnabled public String pcpTaxSuffix{get;set;}

    // US2099074
    @AuraEnabled public Boolean isFromAuth{get;set;}
    @AuraEnabled public String memStreet1{get;set;}
    @AuraEnabled public String memStreet2{get;set;}
    @AuraEnabled public String memZip{get;set;}
    @AuraEnabled public String providerTpsm{get;set;}
    @AuraEnabled public String providerMpin{get;set;}


    public SAETTSCaseWrapper(){
        this.createORSCase = true;
    }
     // Added by ETSBE Team
     	@AuraEnabled public String specialInstructions{get;set;}
	@AuraEnabled public String specialInstructionsBusinessUnit{get;set;}
	@AuraEnabled public String issueCategoryDesc{get;set;}
	@AuraEnabled public String taskCategoryTypeDesc{get;set;}
	@AuraEnabled public String taskCategorySubtypeDesc{get;set;}
	@AuraEnabled public String specialInstructionsSubject{get;set;}
	@AuraEnabled public String specialInstructionsDescription{get;set;}
	@AuraEnabled public String specialInstructionsReferenceID{get;set;}
	@AuraEnabled public String specialInstructionsDateOfService{get;set;}
    @AuraEnabled public String specialInstructionsQueue{get;set;}
    @AuraEnabled public String uhgRestriction{get;set;}
    @AuraEnabled public String onShoreRestriction{get;set;} // US2678265

    @AuraEnabled public String brokerName{get;set;}
    @AuraEnabled public String brokerId{get;set;}

    @AuraEnabled public String updateCaseId{get;set;}

    // US2265872 -> Group Data Elements to be saved to a Case - Yogitha
    @AuraEnabled public String groupName {get;set;}
    @AuraEnabled public String groupId {get;set;}
    @AuraEnabled public String groupPolicyYear {get;set;}
    @AuraEnabled public String groupSitusState {get;set;}
    @AuraEnabled public String groupFundingType {get;set;}
    @AuraEnabled public String groupPlatform {get;set;}
    @AuraEnabled public String platformType {get;set;}
    @AuraEnabled public String groupLineOfBusiness {get;set;}
    @AuraEnabled public String groupRegion {get;set;}
    @AuraEnabled public String groupSalesOffice {get;set;}
    @AuraEnabled public String groupHelathPlanMajor {get;set;}
    @AuraEnabled public String groupHelathPlanMinor {get;set;}
    @AuraEnabled public String groupPolicyRenewalYear {get;set;}
    @AuraEnabled public String groupPolicy {get;set;}
    @AuraEnabled public String groupSolarisId {get;set;}
    @AuraEnabled public String groupSourceCode {get;set;} //jangi

    // US2439068 -> Case - Change Email to 'Email/URL' & Populate - Yogitha
    @AuraEnabled public String emailURL {get;set;}

    // US2422958 -> Case - Originator Section - Populate the Fields for 'Other Admin'- Yogitha
    @AuraEnabled public String otherAdminType {get;set;}

    // US2439464 -> TECH: Entitlement and Milestones Analysis - Yogitha
    @AuraEnabled public String entitlementId {get;set;}

    //US2474077 -> TECH: Claims Complex and Dedicated Eligibility Child Case - Yogitha
    @AuraEnabled public String parentCaseId {get;set;}
    @AuraEnabled public String dosVal {get;set;}

    // US2488115 -> Member Relationship Saved to the Case - Yogitha
    @AuraEnabled public String memberRelationship {get;set;}

    // US2534146 -> Case - 'Clone Case' - Button and Functionality - Yogitha
    @AuraEnabled public Boolean isCloned {get;set;}

    // US2498549 -> Supervisor Escalation Response - Yogitha
    @AuraEnabled public String WhoOwnsIssue {get;set;}
    @AuraEnabled public String WhereWasIssueRouted {get;set;}
    @AuraEnabled public String IsSpecRepWorking {get;set;}
    @AuraEnabled public String RequestNumber {get;set;}
    @AuraEnabled public String MemberInfo {get;set;}
    @AuraEnabled public String EscalationDesc {get;set;}
    //US2498549 -> Supervisor Escalation Response
	@AuraEnabled public String department {get;set;}
    //FACETS - Create FACETS Case
    @AuraEnabled public Boolean createFacetsCase {get;set;} {createFacetsCase = false;}
    @AuraEnabled public string strMemberId {get;set;} {strMemberId = '';}
    @AuraEnabled public string strAddressID {get;set;} {strAddressID = '';}

    //US2510172 - ORS Cases - Populate Category and Reason Based on TTS of Case- Sravan
    @AuraEnabled public String issueId {get;set;}
    //US2099066 - Provider Not Found - Cases Created in ACET to Feed ORS - Sravan
    @AuraEnabled public String phoneNumber {get;set;}
    @AuraEnabled public String payerId {get;set;} //US2784325 - TECH: Case Details - Caller ANI/Provider Add'l Elements Mapped to ORS - Durga
    @AuraEnabled public String middleInitial {get;set;} //US2784325 - TECH: Case Details - Caller ANI/Provider Add'l Elements Mapped to ORS - Durga
    @AuraEnabled public String providerInfoCity {get;set;} //US2784325 - TECH: Case Details - Caller ANI/Provider Add'l Elements Mapped to ORS - Durga
    @AuraEnabled public String dependentNumber {get;set;} //US2784325 - TECH: Case Details - Caller ANI/Provider Add'l Elements Mapped to ORS - Durga
    @AuraEnabled public string OtherOrginatorType {get;set;} //US2784325 - TECH: Case Details - Caller ANI/Provider Add'l Elements Mapped to ORS - Durga

    // US2808554 - Thanish - 24th Aug 2020
    @AuraEnabled public String savedAutodoc {get;set;}
    @AuraEnabled public List<ACETCaseItem> caseItems {get;set;}
    // US2765742
    @AuraEnabled public string strFacetsRoutingComments {get; set;}
    @AuraEnabled public string strSourceCode {get; set;}
    @AuraEnabled public Boolean isFacetsCaseResolved {get; set;}
    //US3071655 - Sravan - 18th Nov 2020
    @AuraEnabled public Boolean allowOpenCaseCreation {get; set;}
    @AuraEnabled public Boolean allowCloseCaseCreation {get; set;}
    //US3040794 - View Member Eligibility - Default AP Policy - Autodoc - FACETS - Sravan
    @AuraEnabled public Boolean isFacets {get;set;}
    //US3083246 - Manikanta - 01/21/2021
    @AuraEnabled public String claimNumber {get;set;}
    @AuraEnabled public String serviceDate {get;set;}
    //US3149404 - Sravan
    @AuraEnabled public String relatedCaseItems {get;set;}
    //US3259671 - Sravan
    @AuraEnabled public HoursOfOperation hoursOfOperation {get;set;}
    //US3182829 - Sravan
    @AuraEnabled public Integer tatValue {get;set;}
    @AuraEnabled public String additionalRequestComments {get;set;}
    @AuraEnabled public String facetsReasonCategory {get;set;}
    @AuraEnabled public String requestResource {get;set;}
    @AuraEnabled public String processingCOB {get;set;}
    @AuraEnabled public String voiceMail {get;set;}
    @AuraEnabled public String nameofInsurance {get;set;}
    @AuraEnabled public String numofOtherInsurance {get;set;}
    @AuraEnabled public String placeHolderName {get;set;}
    @AuraEnabled public String placeHolderSSN {get;set;}
    @AuraEnabled public String placeHolderDOB {get;set;}
    @AuraEnabled public String otherInsPhone {get;set;}
    @AuraEnabled public String OthEffDate1 {get;set;}
    @AuraEnabled public String OthEffDate2 {get;set;}
    @AuraEnabled public String providerFilterType {get;set;}
    @AuraEnabled public Map<string,SRSourceCodeInfo> SRClaimMap {get;set;}
    @AuraEnabled public Map<String,ACETCaseItem> relatedCaseItemsMap {get;set;}//US3644559 - Sravan
    @AuraEnabled public Map<String,Map<String,ACETCaseItem>> allrelatedCaseItemMap {get;set;}


    // claim related case comments -Ketki
    @AuraEnabled public List<String> claimComments {get;set;}
    @AuraEnabled public String claimCaseStatus {get;set;}
    @AuraEnabled public string CSPProviderId {get;set;}
	// claim related case comments -Ketki
    // case items
    public class ACETCaseItem
    {
        @AuraEnabled public String uniqueKey;
        @AuraEnabled public boolean isResolved;
        @AuraEnabled public String topic; //US3071655 - Sravan
        @AuraEnabled public String orsReturnId;
        @AuraEnabled public String relatedGroupNumber;
    }

    //US3259671 - Sravan
    public class HoursOfOperation {
        @AuraEnabled public String startTime;
        @AuraEnabled public String startTimeType;
        @AuraEnabled public String endTime;
        @AuraEnabled public String endTimeType;
        @AuraEnabled public String timeZone;
    }

    public class SRSourceCodeInfo {
         @AuraEnabled public String email;
         @AuraEnabled public Date BeginDOS;
         @AuraEnabled public Date EndDOS;
         @AuraEnabled public List<String> ClaimsInfo;
         @AuraEnabled public string comment;
    }
}