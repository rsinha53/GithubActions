/*
* @Desc: US3323348 - Wrapper class for UpdateORS API Request
* @Date: 10th of Mar 2021
* @Dev: Sarma
*/

public class ACET_UpdateORSRequest {

	public class Meta {
		public ControlModifiers controlModifiers {get;set;} 
	}
	
	public class Issue {
		public String assignedPssId {get;set;} 
		public String businessSegmentName {get;set;} 
		public String callAttemptDetailText {get;set;} 
		public String callbackPromisedDate {get;set;} 
		public String callExceedsExpectationIndicator {get;set;} 
		public String callHistoryFlag {get;set;} 
		public String callMeetsExpectationIndicator {get;set;} 
		public String callProgramName {get;set;} 
		public String campaignCode {get;set;} 
		public String campaignReportText {get;set;} 
		public String caseNumber {get;set;} 
		public String checkNumber {get;set;} 
		public Claim claim {get;set;} 
		public List<String> comments {get;set;} 
		public String complaintCategoryText {get;set;} 
		public Integer contactElapseTime {get;set;} 
		public String contactId {get;set;} 
		public String contactMethodCode {get;set;} 
		public String deleteRequestIndicator {get;set;} 
		public String directionCode {get;set;} 
		public String disposition {get;set;} 
		public String dispositionNotificationDate {get;set;} 
		public Employer employer {get;set;} 
		public FollowUp followUp {get;set;} 
		public Grievance grievance {get;set;} 
		public String hipaaIndicator {get;set;} 
		public Integer issueElapseTime {get;set;} 
		public IssueHandling issueHandling {get;set;} 
		public String launchCategoryText {get;set;} 
		public String launchReasonText {get;set;} 
		public List<LogoLookups> logoLookups {get;set;} 
		public String manualRouteIndicator {get;set;} 
		public Member member {get;set;} 
		public String originalApplicationFileDate {get;set;} 
		public Originator originator {get;set;} 
		public OtherInfo otherInfo {get;set;} 
		public String overrideIndicator {get;set;} 
		public String payer {get;set;} 
		public String pharmacyClaimNumber {get;set;} 
		public String pharmacyClassText {get;set;} 
		public String pharmacyId {get;set;} 
		public String pharmacyName {get;set;} 
		public String priority {get;set;} 
		public ProviderInfo providerInfo {get;set;} 
		public String pssActionTaken {get;set;} 
		public String raplNoblxIndicator {get;set;} 
		public String reasonCategory {get;set;} 
		public String reasonCode {get;set;} 
		public String reasonHcnasType {get;set;} 
		public String reasonType {get;set;} 
		public String repeatIndicator {get;set;} 
		public String routeConditionCode {get;set;} 
		public String seriesDesignator {get;set;} 
		public ServiceRequest serviceRequest {get;set;} 
		public String status {get;set;} 
		public String subReasonText {get;set;} 
		public String surveyCode {get;set;} 
		public String updateDate {get;set;} 
		public String updateTime {get;set;} 

	}
	
	public Meta meta {get;set;} 
	public Data data {get;set;} 

	public class Address {
		public String city {get;set;} 
		public String countryCode {get;set;} 
		public String countryName {get;set;} 
		public String countyCode {get;set;} 
		public String countyName {get;set;} 
		public String state {get;set;} 
		public String street1 {get;set;} 
		public String street2 {get;set;} 
		public String zip {get;set;} 
		public String zip4 {get;set;} 

	}
	
	public class CellPhone {
		public String areaCode {get;set;} 
		public String number_Z {get;set;} // in json: number
		public String extension {get;set;} 
		public String extension2 {get;set;} 
	}
	
	public class Creator {
		public String associateId {get;set;} 
		public String departmentCode {get;set;} 
		public String officeId {get;set;} 
		public String teamCode {get;set;} 

	}
	
	public class Grievance {
		public String categoryText {get;set;} 
		public String dispositionText {get;set;} 
		public String reasonCode {get;set;} 
		public String reasonText {get;set;} 
		public String receiptDate {get;set;} 

	}
	
	public class IssueHandling {
		public List<Creator> carbonCopies {get;set;} 
		public Creator resolvedBy {get;set;} 
		public Creator routedTo {get;set;} 

	}
	
	public class OtherInfo {
		public String agencyName {get;set;} 
		public String agencyTaxId {get;set;} 
		public String agencyUniqueId {get;set;} 
		public String company {get;set;} 
		public String complState {get;set;} 
		public String incompleteFlag {get;set;} 
		public String insuranceCompany {get;set;} 
		public String lineType {get;set;} 
		public String qaCategory {get;set;} 
		public String qaCodeType {get;set;} 
		public String qaSource {get;set;} 
		public String qitType {get;set;} 

	}
	
	public class OrsSourceSystemParameters {
		public String logonId {get;set;} 
		public String logonOffice {get;set;} 

	}
	
	public class DependentName {
		public String firstInitial {get;set;} 
		public String firstName {get;set;} 
		public String lastName {get;set;} 
		public String middleInitial {get;set;} 


	}
	
	public class ServicesQuoted {
		public String alternativeAndHolisticMedicineServiceQuoted {get;set;} 
		public String bloodServiceQuoted {get;set;} 
		public String brandDrugsServiceQuoted {get;set;} 
		public String careManagementProgramServiceQuoted {get;set;} 
		public String cataractSurgeryBenefitsQuoted {get;set;} 
		public String chiropracticServiceQuoted {get;set;} 
		public String cosmeticServiceQuoted {get;set;} 
		public String csrProgramServiceQuoted {get;set;} 
		public String custodialCareServiceQuoted {get;set;} 
		public String deductibleServiceQuoted {get;set;} 
		public String dentalServiceQuoted {get;set;} 
		public String diabeticEducationServiceQuoted {get;set;} 
		public String diabeticMonitorAndSuppliesServiceQuoted {get;set;} 
		public String diagnosticAndRadiologyServiceQuoted {get;set;} 
		public String diagnosticLaboratoryServiceQuoted {get;set;} 
		public String durableMedicalEquipmentServiceQuoted {get;set;} 
		public String emergencyAndUrgentCareServiceQuoted {get;set;} 
		public String familyPlanningServiceQuoted {get;set;} 
		public String genericDrugsServiceQuoted {get;set;} 
		public String gymMembershipServiceQuoted {get;set;} 
		public String healthyLivingProgramsServiceQuoted {get;set;} 
		public String hearingExamServiceQuoted {get;set;} 
		public String hearingServiceQuoted {get;set;} 
		public String homeHealthServiceQuoted {get;set;} 
		public String immunizationsServiceQuoted {get;set;} 
		public String inpatientHospitalAndMedicalServiceQuoted {get;set;} 
		public String inpatientMentalHealthServiceQuoted {get;set;} 
		public String mailOrderServiceQuoted {get;set;} 
		public String maxLimitationsServiceQuoted {get;set;} 
		public String maxOutOfPocketQuoted {get;set;} 
		public String medicareCoveredDentalServiceQuoted {get;set;} 
		public String memberMeetingsServiceQuoted {get;set;} 
		public String nonRadiologyAndTherapeuticServiceQuoted {get;set;} 
		public String oonBenefitServiceQuoted {get;set;} 
		public String orthoticsAndProstheticsServiceQuoted {get;set;} 
		public String otcSuppliesServiceQuoted {get;set;} 
		public String outpatientMentalHealthServiceQuoted {get;set;} 
		public String outpatientRehabilitationServiceQuoted {get;set;} 
		public String outpatientSurgeryAndObservationServiceQuoted {get;set;} 
		public String partBDrugsServiceQuoted {get;set;} 
		public String pcpOfficeVisitServiceQuoted {get;set;} 
		public String pharmacyLocatorServiceQuoted {get;set;} 
		public String podiatryBenefitsServiceQuoted {get;set;} 
		public String preferredFormularyServiceQuoted {get;set;} 
		public String preventiveScreeningServiceQuoted {get;set;} 
		public String renalDialysisServiceQuoted {get;set;} 
		public String riderBenefitsServiceQuoted {get;set;} 
		public String skilledNursingServiceQuoted {get;set;} 
		public String specialistOfficeVisitServiceQuoted {get;set;} 
		public String transplantServiceQuoted {get;set;} 
		public String transportationServiceQuoted {get;set;} 
		public String trueOopServiceQuoted {get;set;} 
		public String unfundedProgramsServiceQuoted {get;set;} 
		public String valueAddedServiceServiceQuoted {get;set;} 
		public String visionBenefitServiceQuoted {get;set;} 

	}
	
	public class LogoLookups {
		public String bodyFontName {get;set;} 
		public String bodyFontNumber {get;set;} 
		public String bodyFontSizeNumber {get;set;} 
		public String constituentText {get;set;} 
		public String duncanImageNumber {get;set;} 
		public String rtnFontName {get;set;} 
		public String rtnFontNumber {get;set;} 
		public String rtnFontSizeNumber {get;set;} 

	}
	
	public class ProviderInfo {
		public String commonProviderID {get;set;} 
		public String contractNumber {get;set;} 
		public String degreeName {get;set;} 
		public String emailIndicator {get;set;} 
		public String ipa {get;set;} 
		public String languageCode {get;set;} 
		public String marketSegmentName {get;set;} 
		public List<String> npis {get;set;} 
		public String originalEffectiveDate {get;set;} 
		public String otherIpa {get;set;} 
		public String panelNumber {get;set;} 
		public Pcp pcp {get;set;} 
		public String pcpValidatedFlag {get;set;} 
		public String productCode {get;set;} 
		public String programSearchCode {get;set;} 
		public Pcp provider {get;set;} 
		public String providerSourceSystem {get;set;} 
		public String providerValidatedFlag {get;set;} 
		public String serviceMarket {get;set;} 
		public String serviceZip {get;set;} 
		public String specialtyText {get;set;} 
		public String stateIssuedID {get;set;} 
		public String statusCode {get;set;} 
		public String tpsmIndicator {get;set;} 

	}
	
	public class Originator {
		public Address callerAddress {get;set;} 
		public DependentName callerName {get;set;} 
		public Cti cti {get;set;} 
		public CellPhone dayPhone {get;set;} 
		public CellPhone eveningPhone {get;set;} 
		public String originatorMpin {get;set;} 
		public String originatorTin {get;set;} 
		public String originatorTinSuffix {get;set;} 
		public String originatorTypeCode {get;set;} 
		public String providerId {get;set;} 

	}
	
	public class FollowUp {
		public CellPhone cellPhone {get;set;} 
		public String contactDate {get;set;} 
		public Creator creator {get;set;} 
		public String email {get;set;} 
		public String estimatedCompletionDate {get;set;} 
		public CellPhone fax {get;set;} 
		public String followUpDate {get;set;} 
		public CellPhone homePhone {get;set;} 
		public String nextAction {get;set;} 
		public String nextActionDueDate {get;set;} 
		public CellPhone otherPhone {get;set;} 
		public String preferredContactTime {get;set;} 
		public String primaryContact {get;set;} 
		public String purposeCode {get;set;} 
		public String resolvedDate {get;set;} 
		public String statusCode {get;set;} 
		public String voiceMailIndicator {get;set;} 
		public CellPhone workPhone {get;set;} 

	}
	
	public class Member {
		public Address address {get;set;} 
		public Integer age {get;set;} 
		public String alternateId {get;set;} 
		public String ambulanceIndicator {get;set;} 
		public String assignedCsrName {get;set;} 
		public String benefitPackageCode {get;set;} 
		public String clientCode {get;set;} 
		public String copayEffectiveDate {get;set;} 
		public String coverageIndicator {get;set;} 
		public String customerNumber {get;set;} 
		public String dateOfBirth {get;set;} 
		public String dateOfDeath {get;set;} 
		public DependentName dependentName {get;set;} 
		public String dependentNumber {get;set;} 
		public String division {get;set;} 
		public String dlEligIndicator {get;set;} 
		public String eligibilitySourceSystem {get;set;} 
		public String eligibilityValidatedFlag {get;set;} 
		public String email {get;set;} 
		public String emailIndicator {get;set;} 
		public String enrollmentSourceCode {get;set;} 
		public String facetPlanCode {get;set;} 
		public CellPhone faxNumber {get;set;} 
		public String fontIndicator {get;set;} 
		public String genderCode {get;set;} 
		public String groupName {get;set;} 
		public String groupNumber {get;set;} 
		public String hippaEligibleFlag {get;set;} 
		public String ipaCode {get;set;} 
		public String iPlanIndicator {get;set;} 
		public String languageTranslationId {get;set;} 
		public String leadPlanCode {get;set;} 
		public String legalEntity {get;set;} 
		public String lisPctCode {get;set;} 
		public String logoIndicator {get;set;} 
		public String logonId {get;set;} 
		public String market {get;set;} 
		public String masterGroupNumber {get;set;} 
		public String medicaidId {get;set;} 
		public String medicareId {get;set;} 
		public String medicareStatusCode {get;set;} 
		public String meetingDate {get;set;} 
		public String meetingTypeName {get;set;} 
		public DependentName memberName {get;set;} 
		public String memberNumber {get;set;} 
		public String memberVerifiedIndicator {get;set;} 
		public String militaryTreatmentFacilityLocation {get;set;} 
		public String neonIndicator {get;set;} 
		public String networkPrefixCode {get;set;} 
		public String obligorId {get;set;} 
		public String optOutIndicator {get;set;} 
		public String originalEffectiveDate {get;set;} 
		public String otherGroupNumber {get;set;} 
		public String otherProduct {get;set;} 
		public String otherSubscriberId {get;set;} 
		public String panelCode {get;set;} 
		public String parentGroupName {get;set;} 
		public String passportIndicator {get;set;} 
		public String pcpOverrideIndicator {get;set;} 
		public String personalIdentificationNumber {get;set;} 
		public CellPhone phone {get;set;} 
		public String planCode {get;set;} 
		public String planEffectiveDate {get;set;} 
		public String planEndDate {get;set;} 
		public String planVariationCode {get;set;} 
		public String policy {get;set;} 
		public String premiumWithholdCode {get;set;} 
		public String primaryPolicyNumber {get;set;} 
		public String primeIndicator {get;set;} 
		public String product {get;set;} 
		public String raceEthnicityCode {get;set;} 
		public String rank {get;set;} 
		public String regionCode {get;set;} 
		public String relationshipCode {get;set;} 
		public String relationshipSequenceNumber {get;set;} 
		public String reportingCode {get;set;} 
		public String riderCodeIndicator {get;set;} 
		public List<String> riderCodes {get;set;} 
		public String secondaryDrugInsuranceIndicator {get;set;} 
		public ServicesQuoted servicesQuoted {get;set;} 
		public String sharedArrangementId {get;set;} 
		public String site {get;set;} 
		public String ssaPaymentCode {get;set;} 
		public String statusCode {get;set;} 
		public String subsidyOverrideIndicator {get;set;} 
		public Integer totalNonCoverageCount {get;set;} 
		public String verbalLanguageName {get;set;} 
		public String walkinTime {get;set;} 
		public String writtenLanguageName {get;set;} 
	}
	
	public class ControlModifiers {
		public OrsSourceSystemParameters orsSourceSystemParameters {get;set;} 
	}
	
	public class Employer {
		public String employerName {get;set;} 
		public String employerNumber {get;set;} 
		public String employerState {get;set;} 
	}
	
	public class Data {
		public String modifiedByApplicationIndicator {get;set;} 
		public String updateType {get;set;} 
		public Issue issue {get;set;} 
	}
	
	public class ServiceRequest {
		public String addressUpdateRequiredIndicator {get;set;} 
		public String bulkCheckIndicator {get;set;} 
		public String checkPayee {get;set;} 
		public String checkStockNumber {get;set;} 
		public String claimAdjustmentRequiredIndicator {get;set;} 
		public String clientId {get;set;} 
		public String countyCode {get;set;} 
		public String countyName {get;set;} 
		public String diamondProviderLocationId {get;set;} 
		public String diamondProviderLocationName {get;set;} 
		public String documentControlNumber {get;set;} 
		public String originatorLocationId {get;set;} 
		public String policyNumber {get;set;} 
		public String productId {get;set;} 
		public String resolutionCode {get;set;} 
		public String srProductType {get;set;} 
		public String srSubType {get;set;} 
		public String srType {get;set;} 
		public String subCodeId {get;set;} 
		public String wbxUpdateRequiredIndicator {get;set;} 

	}
	
	public class Drafts {
		public String draftNumber {get;set;} 
		public String inventoryControlNumber {get;set;} 

	}
	
	public class Atg {
		public String sourceId {get;set;} 
		public List<Drafts> drafts {get;set;} 

	}
	
	public class Cti {
		public String autoId {get;set;} 
		public String dialedId {get;set;} 
		public String icrCallLocationDay {get;set;} 
		public String icrCallLocationId {get;set;} 

	}
	
	public class Pcp {
		public Address address {get;set;} 
		public String mpin {get;set;} 
		public String mpinSequenceNumber {get;set;} 
		public CellPhone phone {get;set;} 
		public String providerId {get;set;} 
		public DependentName providerName {get;set;} 
		public String taxId {get;set;} 
		public String taxPrefix {get;set;} 
		public String taxSuffix {get;set;} 

	}
	
	public class Claim {
		public String adjustedClaimIndicator {get;set;} 
		public Atg atg {get;set;} 
		public String atgIndicator {get;set;} 
		public String authorization {get;set;} 
		public String claimApp {get;set;} 
		public String claimAppSsn {get;set;} 
		public String claimNumber {get;set;} 
		public String claimOffice {get;set;} 
		public String engineCode {get;set;} 
		public String filmNumber {get;set;} 
		public String filmOffice {get;set;} 
		public String filmSystem {get;set;} 
		public String fundingArrangement {get;set;} 
		public String invoiceNumber {get;set;} 
		public String payLocationNumber {get;set;} 
		public String serviceDate {get;set;} 
		public String substituteIndicator {get;set;} 
		public String totalAmount {get;set;} 
	}
	
	
	public static ACET_UpdateORSRequest parse(String json) {
		return (ACET_UpdateORSRequest) System.JSON.deserialize(json, ACET_UpdateORSRequest.class);
	}

	public static void consumeObject(System.JSONParser parser) {
		Integer depth = 0;
		do {
			System.JSONToken curr = parser.getCurrentToken();
			if (curr == System.JSONToken.START_OBJECT || 
				curr == System.JSONToken.START_ARRAY) {
				depth++;
			} else if (curr == System.JSONToken.END_OBJECT ||
				curr == System.JSONToken.END_ARRAY) {
				depth--;
			}
		} while (depth > 0 && parser.nextToken() != null);
	}
	
}