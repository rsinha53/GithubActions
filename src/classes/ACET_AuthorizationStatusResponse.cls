/*
 * @Desc:  US2154803 - View Authrizations and Notifications - Inpatient Details Integration
 * @Date: 06-01-2020
 * @Dev: Kavinda
*/
public class ACET_AuthorizationStatusResponse {

    @AuraEnabled public AuthDetailsResponse AuthDetailsResponse {get;set;}

    public class AuthDetailsResponse {
		@AuraEnabled public String authId {get;set;}
		@AuraEnabled public String coverageSequenceNumber {get;set;}
		@AuraEnabled public String createDateTime {get;set;}
		@AuraEnabled public StatusReasonCode statusReasonCode {get;set;}
		@AuraEnabled public StatusReasonCode statusCode {get;set;}
		@AuraEnabled public StatusReasonCode serviceSettingTypeCode {get;set;}
		@AuraEnabled public String globalId {get;set;}
		@AuraEnabled public StatusReasonCode reviewPriority {get;set;}
		@AuraEnabled public StatusReasonCode serviceCategoryTypeCode {get;set;}
		@AuraEnabled public Member member {get;set;}
		@AuraEnabled public AuthFollowUpContact authFollowUpContact {get;set;}
		@AuraEnabled public List<Providers> providers {get;set;}
		@AuraEnabled public List<Notes> notes {get;set;}
		@AuraEnabled public Facility facility {get;set;}
		@AuraEnabled public List<RuleDecision> ruleDecision {get;set;}
		@AuraEnabled public List<Diagnosis> diagnosis {get;set;}
		@AuraEnabled public List<RuleDecision> letterTypes {get;set;}
		@AuraEnabled public List<RuleDecision> copiedToDetail {get;set;}
		@AuraEnabled public List<RuleDecision> memberBenefitPlanTier {get;set;}
		@AuraEnabled public List<Services> services {get;set;}
		 // US2382474	Auth Details -  Work Assignment Integration
		@AuraEnabled public List<assignments> assignments {get;set;}
		// US2807198 Enhancement - View Authorizations:  New Fields Added for Authorization Details Integration
		@AuraEnabled public String createdBy {get;set;}
        @AuraEnabled public string caseOwner {get;set;}


	}

	public class RuleDecision {}

	public class Services {
		@AuraEnabled public String sequenceNumber {get;set;}
        @AuraEnabled public String procedureOtherText {get;set;}
		@AuraEnabled public String serviceReferenceNumber {get;set;}
		@AuraEnabled public String procedureFullDescription {get;set;}
		@AuraEnabled public String providerSeqNumber {get;set;}
		@AuraEnabled public ServiceDecision serviceDecision {get;set;}
		@AuraEnabled public ProcedureCode procedureCode {get;set;}
		@AuraEnabled public ServiceFacility serviceFacility {get;set;}
		@AuraEnabled public ServiceNonFacility serviceNonFacility {get;set;}
	}

	public class ServiceNonFacility {
		@AuraEnabled public String advanceNotificationTimestamp {get;set;}
		@AuraEnabled public StatusReasonCode placeOfServiceCode {get;set;}
		@AuraEnabled public StatusReasonCode procedureFrequencyCode {get;set;}
		@AuraEnabled public String procedureUnitCount {get;set;}
		@AuraEnabled public StatusReasonCode procedureUnitOfMeasureCode {get;set;}
		@AuraEnabled public StatusReasonCode serviceDescUrgencyCode {get;set;}
		@AuraEnabled public StatusReasonCode serviceDetailCategoryCode {get;set;}
		@AuraEnabled public ServiceEffDates serviceEffDates {get;set;}
		@AuraEnabled public String unitPerFrequencyCount {get;set;}
		@AuraEnabled public String dmeTotalCost {get;set;}
		@AuraEnabled public String dmeEnternalFeedingSSONutrInd {get;set;}
		@AuraEnabled public String dmeProcurementType {get;set;}  // US2304398	Enhancements, Pending work and Defects  Authorizations - Sarma
	}

	public class ServiceEffDates {
		@AuraEnabled public String startDate {get;set;}
		@AuraEnabled public String stopDate {get;set;}
	}

	public class ServiceDecision {
		@AuraEnabled public String decisionSequenceNbr {get;set;}
		@AuraEnabled public StatusReasonCode decisionSubTypeCode {get;set;}
		@AuraEnabled public StatusReasonCode decisionReasonCode {get;set;}
		@AuraEnabled public StatusReasonCode decisionOutcomeCode {get;set;}
		@AuraEnabled public String decisionMadeByUserId {get;set;}
		@AuraEnabled public StatusReasonCode derivedClaimRemarkCode {get;set;}
		@AuraEnabled public String decisionRenderedDatetime {get;set;}
		@AuraEnabled public List<FacilityDecisonSource> serviceDecisionSource {get;set;}
        @AuraEnabled public StatusReasonCode gapReviewOutcomeCode {get;set;}
		// US3222404
		@AuraEnabled public String decisionMadeByUserPosition {get;set;}
        @AuraEnabled public StatusReasonCode overrideClaimRemarkCode {get;set;}
	}

	public class ProcedureCode {
		@AuraEnabled public String code {get;set;}
		@AuraEnabled public String codeDesc {get;set;}
		@AuraEnabled public String typeCode {get;set;}
		@AuraEnabled public String typeCodeDesc {get;set;}
	}

	public class StatusReasonCode {
		@AuraEnabled public String code {get;set;}
		@AuraEnabled public String description {get;set;}
	}

	public class ServiceFacility {
		@AuraEnabled public String expectedProcedureDate {get;set;}
		@AuraEnabled public String actualProcedureDate {get;set;}
	}

	public class Address {
		@AuraEnabled public String addressLine1 {get;set;}
		@AuraEnabled public String city {get;set;}
		@AuraEnabled public StatusReasonCode state {get;set;}
		@AuraEnabled public String postalCode1 {get;set;}
		@AuraEnabled public StatusReasonCode addressType {get;set;}
		@AuraEnabled public StatusReasonCode countryCode {get;set;}
		@AuraEnabled public EffectiveDateRange effectiveDateRange {get;set;}
		@AuraEnabled public String countyFIPS {get;set;}
		@AuraEnabled public String countyName {get;set;}
	}

	public class FacilityDecision {
		@AuraEnabled public String decisionSequenceNbr {get;set;}
		@AuraEnabled public StatusReasonCode subTypeCode {get;set;}
		@AuraEnabled public StatusReasonCode decisionReasonCode {get;set;}
		@AuraEnabled public StatusReasonCode decisionOutcomeCode {get;set;}
		@AuraEnabled public String madeByUserId {get;set;}
		@AuraEnabled public StatusReasonCode derviedClaimRemarkCode {get;set;}
		@AuraEnabled public String renderedDateTime {get;set;}
		@AuraEnabled public List<FacilityDecisonSource> facilityDecisonSource {get;set;}
		@AuraEnabled public List<BedDayDecision> bedDayDecision {get;set;}
		@AuraEnabled public String sourceCommentText {get;set;}
		// US2807198 Enhancement - View Authorizations:  New Fields Added for Authorization Details Integration
		// US3222404
		@AuraEnabled public String madeByUserPosition {get;set;}
		 @AuraEnabled public StatusReasonCode gapReviewOutcomeCode {get;set;}
		 @AuraEnabled public StatusReasonCode overrideClaimRemarkCode {get;set;}
	}

	public class BedDayDecision {
		@AuraEnabled public BedDates bedDates {get;set;}
		@AuraEnabled public StatusReasonCode bedTypeCode {get;set;}
		@AuraEnabled public StatusReasonCode revenueCode {get;set;}
		@AuraEnabled public StatusReasonCode decisionReasonCode {get;set;}
		@AuraEnabled public StatusReasonCode systemClaimRemarkCode {get;set;}
		@AuraEnabled public StatusReasonCode decisionOutcomeCode {get;set;}
		@AuraEnabled public String decisionUpdateDateTime {get;set;}
        @AuraEnabled public String claimNoteText {get;set;}
	}

	public class BedDates {
		@AuraEnabled public String startDate {get;set;}
		@AuraEnabled public String stopDate {get;set;}
	}

	public class AuthFollowUpContact {
		@AuraEnabled public String contactFullName {get;set;}
		@AuraEnabled public StatusReasonCode communicationContactRoleCode {get;set;}
		@AuraEnabled public List<PhoneNumber> phoneNumber {get;set;}
		@AuraEnabled public DepartmentTypecode departmentTypecode {get;set;}
		// US2807198 Enhancement - View Authorizations:  New Fields Added for Authorization Details Integration
		@AuraEnabled public String timeZone {get;set;}
	}

	public class DiagnosisCode {
		@AuraEnabled public String code {get;set;}
		@AuraEnabled public String codeDesc {get;set;}
		@AuraEnabled public String typeCode {get;set;}
		@AuraEnabled public String typeCodeDesc {get;set;}
	}

	public class DepartmentTypecode {
		@AuraEnabled public String code {get;set;}
		@AuraEnabled public String description {get;set;}
	}

	public class NetworkId {
		@AuraEnabled public String description {get;set;}
	}

	public class Providers {
		@AuraEnabled public String seqNum {get;set;}
		@AuraEnabled public String categoryCode {get;set;}
		@AuraEnabled public String organizationName {get;set;}
		@AuraEnabled public Address_Z address {get;set;}
		@AuraEnabled public List<SpecialtyType> specialtyType {get;set;}
		@AuraEnabled public String primaryPhone {get;set;}
		@AuraEnabled public String primaryTelephoneInternationalIndicator {get;set;}
		@AuraEnabled public String faxInternationalIndicator {get;set;}
		@AuraEnabled public NetworkId networkId {get;set;}
		@AuraEnabled public StatusReasonCode networkStatusType {get;set;}
		@AuraEnabled public List<EnrolleIdentifiers> providerIdentifiers {get;set;}
		@AuraEnabled public List<Role> role {get;set;}
		//@AuraEnabled public Object providerContractOrgs {get;set;}
		@AuraEnabled public String firstName {get;set;}
		@AuraEnabled public String middleName {get;set;}
		@AuraEnabled public String lastName {get;set;}
        @AuraEnabled public String suffixCode {get;set;}
		@AuraEnabled public String faxNumber {get;set;}
		// US2807198 Enhancement - View Authorizations:  New Fields Added for Authorization Details Integration
		@AuraEnabled public String region {get;set;}
		@AuraEnabled public StatusReasonCode networkSteerageReason {get;set;}
	}

    public class EnrolleIdentifiers {
		@AuraEnabled public String id {get;set;}
		@AuraEnabled public String typeCode {get;set;}
		@AuraEnabled public String typeCodeDesc {get;set;}
    }

    public class SpecialtyType {
		@AuraEnabled public String code {get;set;}
		@AuraEnabled public String desc_x {get;set;}
	}

	public class SpecialtyType_Z {
		@AuraEnabled public String code {get;set;}
		@AuraEnabled public String desc_Z {get;set;}
	}

	public class Role {
		@AuraEnabled public String id {get;set;}
		@AuraEnabled public String desc_Z {get;set;}
	}

	public class IcueMemberID {
		@AuraEnabled public String id {get;set;}
	}

	public class FacilityDecisonSource {
		@AuraEnabled public String sourceSeqNumber {get;set;}
		@AuraEnabled public StatusReasonCode decisionSourceType {get;set;}
	}

	public class EffectiveDateRange {
		@AuraEnabled public String stopDate {get;set;}
	}

	public class PhoneNumber {
		@AuraEnabled public String telephoneNumber {get;set;}
		@AuraEnabled public String phoneTypeCode {get;set;}
		@AuraEnabled public String primaryIndicator {get;set;}
		@AuraEnabled public String phoneInterntionalIndicator {get;set;}
	}

	public class SourceMemberId {
		@AuraEnabled public String id {get;set;}
		@AuraEnabled public String type_Z {get;set;}
	}

	public class Facility {
		@AuraEnabled public String notifyLateInd {get;set;}
		@AuraEnabled public String notifyRetrospectiveInd {get;set;}
		@AuraEnabled public StatusReasonCode placeOfServiceCode {get;set;}
		@AuraEnabled public StatusReasonCode serviceDetailCategoryCode {get;set;}
		@AuraEnabled public StatusReasonCode serviceDescUrgencyCode {get;set;}
		@AuraEnabled public String expectedAdmissionDate {get;set;}
		@AuraEnabled public String expectedDischargeDate {get;set;}
		@AuraEnabled public String actualAdmissionDateTime {get;set;}
		@AuraEnabled public String actualDischargeDateTime {get;set;}
		@AuraEnabled public StatusReasonCode dischargeDispositionType {get;set;}
		@AuraEnabled public String icmAvaliableInd {get;set;}
		@AuraEnabled public String serviceReferenceNumber {get;set;}
		@AuraEnabled public String admissionNotifyDateTime {get;set;}
		@AuraEnabled public String dischargeNotifyDateTime {get;set;}
		@AuraEnabled public FacilityDecision facilityDecision {get;set;}
		// US2807198 Enhancement - View Authorizations:  New Fields Added for Authorization Details Integration
		@AuraEnabled public String expirationDate {get;set;}
		@AuraEnabled public StatusReasonCode ipcmTypeId {get;set;}
		// US3222393 View Auth: Facility Details Integration and Testing - Sarma - 12/02/2021
		@AuraEnabled public String advanceNotificationTimeStamp {get;set;}

	}

	public class Diagnosis {
		@AuraEnabled public String diagnosisSeqNum {get;set;}
		@AuraEnabled public DiagnosisCode diagnosisCode {get;set;}
		@AuraEnabled public String primaryInd {get;set;}
		@AuraEnabled public String admitInd {get;set;}
		@AuraEnabled public String diagnosisOtherText {get;set;}
	}

	public class Member {
		@AuraEnabled public SourceMemberId sourceMemberId {get;set;}
		@AuraEnabled public List<EnrolleIdentifiers> enrolleIdentifiers {get;set;}
		@AuraEnabled public String firstName {get;set;}
		@AuraEnabled public String lastName {get;set;}
		@AuraEnabled public String middleName {get;set;}
		@AuraEnabled public String birthDate {get;set;}
		@AuraEnabled public StatusReasonCode gender {get;set;}
		@AuraEnabled public String relationshipCode {get;set;}
		@AuraEnabled public List<Address> address {get;set;}
		@AuraEnabled public String spokenLanguageText {get;set;}
		@AuraEnabled public String writtenLanguageText {get;set;}
		@AuraEnabled public IcueMemberID icueMemberID {get;set;}
	}

	public class Address_Z {
		@AuraEnabled public String addressLine1 {get;set;}
		@AuraEnabled public String city {get;set;}
		@AuraEnabled public StatusReasonCode state {get;set;}
		@AuraEnabled public String postalCode1 {get;set;}
		@AuraEnabled public String postalCode2 {get;set;}
	}

	public class Notes {
		@AuraEnabled public StatusReasonCode categoryCode {get;set;}
		@AuraEnabled public String text {get;set;}
		@AuraEnabled public String createdByUserId {get;set;}
		@AuraEnabled public String createdByUserFirstName {get;set;}
		@AuraEnabled public String createdByUserLastName {get;set;}
		@AuraEnabled public String createDateTime {get;set;}
		// US2807198 Enhancement - View Authorizations:  New Fields Added for Authorization Details Integration
		@AuraEnabled public String department {get;set;}
	}

	 // US2382474	Auth Details -  Work Assignment Integration
	 public class assignments {
		@AuraEnabled public StatusReasonCode assignmentType {get;set;}
		@AuraEnabled public StatusReasonCode assignmentDescriptor {get;set;}
		@AuraEnabled public StatusReasonCode assignmentPriority {get;set;}
		@AuraEnabled public StatusReasonCode assignmentStatus {get;set;}
		@AuraEnabled public String assignedBy {get;set;}
		@AuraEnabled public String assignmentDateAndTime {get;set;}
		@AuraEnabled public String assignedTo {get;set;}
        @AuraEnabled public String assignmentDueDate {get;set;}
    }

}