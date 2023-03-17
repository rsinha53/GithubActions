public class ACET_ORSRequest {

	public class CarbonCopies {
		public String associateId;
		public String officeId;
	}
	
	public class Issue {
		public String assignedPssId; 
		public String businessSegmentName; 
		public String callAttemptDetailText; 
		public String callExceedsExpectationIndicator; 
		public String callHistoryFlag; 
		public String callMeetsExpectationIndicator; 
		public String callProgramName; 
		public String callbackPromisedDate; 
		public String campaignCode; 
		public String campaignReportText; 
		public List<CarbonCopies> carbonCopies; 
		public String caseNumber; 
		public String checkNumber; 
		public Claim claim; 
		public List<String> comments; 
		public String complaintCategoryText; 
		public String contactElapseTime; 
		public String contactId; 
		public String contactMethodCode; 
		public String createdByApplicationIndicator; 
		public String deleteRequestIndicator; 
		public String directionCode; 
		public String disposition; 
		public String dispositionNotificationDate; 
		public EmployerInfo employerInfo; 
		public FollowUp followUp; 
		public String followupDate; 
		public String grievanceCategoryText; 
		public String grievanceDispositionText; 
		public String grievanceReasonCode; 
		public String grievanceReasonText; 
		public String grievanceReceiptDate; 
		public String hipaaIndicator; 
		public String issueElapseTime; 
		public String issueId; 
		public String launchCategoryText; 
		public String launchReasonText; 
		public List<LogoLookups> logoLookups; 
		public String manualRouteIndicator; 
		public Member member; 
		public String modifiedByApplicationIndicator; 
		public String originalApplicationFileDate; 
		public Originator originator; 
		public String originatorTypeCode; 
		public Other other; 
		public String overrideIndicator; 
		public String payer; 
		public String pharmacyClaimNumber; 
		public String pharmacyClassText; 
		public String pharmacyId; 
		public String pharmacyName; 
		public String priority; 
		public Provider provider; 
		public String pssActionTaken; 
		public String raplNoblxIndicator; 
		public String reasonCategory; 
		public String reasonCode; 
		public String reasonHcnasType; 
		public String reasonType; 
		public String repeatIndicator; 
		public Creator resolvedBy; 
		public String routeConditionCode; 
		public Creator routedTo; 
		public String seriesDesignator; 
		public ServiceRequest serviceRequest; 
		public String status; 
		public String subReasonText; 
		public String surveyCode; 
		public String updateDate; 
		public String updateTime; 
		public String updateType; 
	}
	
	public PostInput postInput; 
	
	public class WorkPhone {
		public String areaCode; 
		public String number_Z; // in json: number
		public String extension; 
	}
	
	public class CellPhone {
		public String areaCode; 
		public String number_Z; // in json: number
	}
	
	public class Creator {
		public String associateId; 
		public String departmentCode; 
		public String officeId; 
		public String teamCode; 
	}
	
	public class CallerAddress {
		public String city; 
		public String countryCode; 
		public String description; 
		public String state; 
		public String street1; 
		public String street2; 
		public String street3; 
		public String zip; 
		public String zip4; 
		public String country; 
		public String county; 
	}
	
	public class ServiceRequest {
		public String addressUpdateRequiredIndicator; 
		public String bulkCheckIndicator; 
		public String checkPayeeName; 
		public String checkStockNumber; 
		public String claimAdjustmentRequiredIndicator; 
		public String clientId; 
		public String countyCode; 
		public String countyName; 
		public String diamondProviderLocationId; 
		public String diamondProviderLocationName; 
		public String documentControlNumber; 
		public String originatorLocationId; 
		public String policyNumber; 
		public String productId; 
		public String resolutionCode; 
		public String srProductType; 
		public String srSubType; 
		public String srType; 
		public String subCodeId; 
		public String wbxUpdateRequiredIndicator; 
	}
	
	public class Drafts {
		public String draftNumber; 
		public String inventoryControlNumber; 
	}
	
	public class Provider {
		public String commonProviderID; 
		public String contractNumber; 
		public String countyName; 
		public String degreeName; 
		public String emailIndicator; 
		public String ipa; 
		public String languageCode; 
		public String marketSegmentName; 
		public List<String> npis; 
		public String originalEffectiveDate; 
		public String otherIpa; 
		public String panelNumber; 
		public Pcp pcp; 
		public String pcpValidatedFlag; 
		public String phoneAreaCode; 
		public String phoneNumber; 
		public String productCode; 
		public String programSearchCode; 
		public Pcp provider; 
		public String providerSourceSystem; 
		public String providerValidatedFlag; 
		public String serviceMarket; 
		public String serviceZip; 
		public String specialtyText; 
		public String stateIssuedID; 
		public String statusCode; 
		public String tpsmIndicator; 
	}
	
	public class EmployerInfo {
		public String employerName; 
		public String employerNumber; 
		public String employerState; 
	}
	
	public class DependentName {
		public String firstName; 
		public String lastName; 
	}
	
	public class LogoLookups {
		public String bodyFontName; 
		public String bodyFontNumber; 
		public String bodyFontSizeNumber; 
		public String constituentText; 
		public String duncanImageNumber; 
		public String rtnFontName; 
		public String rtnFontNumber; 
		public String rtnFontSizeNumber; 
	}
	
	public class Atg {
		public List<Drafts> drafts;
		public String sourceId; 

		public Atg()
		{
			this.drafts = new List<Drafts>{new Drafts()};
			this.sourceId = 'ACET';
		}
	}
	
	public class Originator {
		public String autoId; 
		public CallerAddress callerAddress;
		public DependentName callerName;
		public WorkPhone dayPhone;
		public String dayPhoneExtension2; 
		public String dialedId; 
		public WorkPhone eveningPhone;
		public String icrCallLocationDay; 
		public String icrCallLocationId; 
		public String originatorMpin; 
		public String originatorTin; 
		public String originatorTinSuffix; 
		public String providerId; 

		public Originator()
		{
			this.callerAddress = new CallerAddress();
			this.callerName = new DependentName();
			this.dayPhone = new WorkPhone();
			this.eveningPhone = new WorkPhone();
		}
	}
	
	public class PostInput {
		public OrsSystemParameter orsSystemParameter; 
		public Issue issue; 
	}
	
	public class OrsSystemParameter {
		public String logonId; 
		public String logonOffice; 
	}
	
	public class FollowUp {
		public CellPhone cellPhone;
		public String contactDate; 
		public Creator creator ;
		public String email; 
		public String estimatedCompletionDate; 
		public CellPhone fax ;
		public CellPhone homePhone ;
		public String nextAction; 
		public String nextActionDueDate; 
		public CellPhone otherPhone;
		public String preferredContactTime; 
		public String primaryContact; 
		public String purposeCode; 
		public String resolvedDate; 
		public String status; 
		public String voiceMailIndicator; 
		public WorkPhone workPhone;

		public FollowUp()
		{
			this.cellPhone = new CellPhone();
			this.creator = new Creator();
			this.fax = new CellPhone();
			this.homePhone = new CellPhone();
			this.otherPhone = new CellPhone();
			this.workPhone = new WorkPhone();
		}
	}
	
	public class Pcp {
		public String city; 
		public String firstInitial; 
		public String firstName; 
		public String lastName; 
		public String mpin; 
		public String mpinSequenceNumber; 
		public String providerID; 
		public String state; 
		public String street1; 
		public String street2; 
		public String taxId; 
		public String taxPrefix; 
		public String taxSuffix; 
		public String zip; 
	}
	
	public class Member {
		public String age; 
		public String alternateId; 
		public String alternativeAndHolisticMedicineServiceQuoted; 
		public String ambulanceIndicator; 
		public String assignedCsrName; 
		public String benefitPackageCode; 
		public String bloodServiceQuoted; 
		public String brandDrugsServiceQuoted; 
		public String careManagementProgramServiceQuoted; 
		public String cataractSurgeryBenefitsQuoted; 
		public String chiropracticServiceQuoted; 
		public String city; 
		public String clientCode; 
		public String copayEffectiveDate; 
		public String cosmeticServiceQuoted; 
		public String countryCode; 
		public String coverageIndicator; 
		public String csrProgramServiceQuoted; 
		public String custodialCareServiceQuoted; 
		public String customerNumber; 
		public String dateOfBirth; 
		public String dateOfDeath; 
		public String deductibleServiceQuoted; 
		public String dentalServiceQuoted; 
		public DependentName dependentName; 
		public String dependentNumber; 
		public String diabeticEducationServiceQuoted; 
		public String diabeticMonitorAndSuppliesServiceQuoted; 
		public String diagnosticAndRadiologyServiceQuoted; 
		public String diagnosticLaboratoryServiceQuoted; 
		public String division; 
		public String dlEligIndicator; 
		public String durableMedicalEquipmentServiceQuoted; 
		public String eligibilitySourceSystem; 
		public String eligibilityValidatedFlag; 
		public String email; 
		public String emailIndicator; 
		public String emergencyAndUrgentCareServiceQuoted; 
		public String enrollmentSourceCode; 
		public String facetPlanCode; 
		public String familyPlanningServiceQuoted; 
		public String faxNumber; 
		public String fontIndicator; 
		public String genderCode; 
		public String genericDrugsServiceQuoted; 
		public String groupName; 
		public String groupNumber; 
		public String gymMembershipServiceQuoted; 
		public String healthyLivingProgramsServiceQuoted; 
		public String hearingExamServiceQuoted; 
		public String hearingServiceQuoted; 
		public String hippaEligibleFlag; 
		public String homeHealthServiceQuoted; 
		public String immunizationsServiceQuoted; 
		public String inpatientHospitalAndMedicalServiceQuoted; 
		public String inpatientMentalHealthServiceQuoted; 
		public String ipaCode; 
		public String languageTranslationId; 
		public String leadPlanCode; 
		public String legalEntity; 
		public String lisPctCode; 
		public String logoIndicator; 
		public String logonId; 
		public String mailOrderServiceQuoted; 
		public String market; 
		public String masterGroupNumber; 
		public String maxLimitationsServiceQuoted; 
		public String maxOutOfPocketQuoted; 
		public String medicaidId; 
		public String medicareCoveredDentalServiceQuoted; 
		public String medicareId; 
		public String medicareStatusCode; 
		public String meetingDate; 
		public String meetingTypeName; 
		public String memberMeetingsServiceQuoted; 
		public DependentName memberName; 
		public String memberNumber; 
		public String memberVerifiedIndicator; 
		public String middleInitial; 
		public String militaryTreatmentFacilityLocation; 
		public String neonIndicator; 
		public String networkPrefixCode; 
		public String nonRadiologyAndTherapeuticServiceQuoted; 
		public String obligorId; 
		public String oonBenefitServiceQuoted; 
		public String optOutIndicator; 
		public String originalEffectiveDate; 
		public String orthoticsAndProstheticsServiceQuoted; 
		public String otcSuppliesServiceQuoted; 
		public String otherGroupNumber; 
		public String otherProduct; 
		public String otherSubscriberId; 
		public String outpatientMentalHealthServiceQuoted; 
		public String outpatientRehabilitationServiceQuoted; 
		public String outpatientSurgeryAndObservationServiceQuoted; 
		public String panelCode; 
		public String parentGroupName; 
		public String partBDrugsServiceQuoted; 
		public String passportIndicator; 
		public String pcpOfficeVisitServiceQuoted; 
		public String pcpOverrideIndicator; 
		public String personalIdentificationNumber; 
		public String pharmacyLocatorServiceQuoted; 
		public String phoneAreaCode; 
		public String phoneNumber; 
		public String planCode; 
		public String planEffectiveDate; 
		public String planEndDate; 
		public String planVariationCode; 
		public String podiatryBenefitsServiceQuoted; 
		public String policy; 
		public String preferredFormularyServiceQuoted; 
		public String premiumWithholdCode; 
		public String preventiveScreeningServiceQuoted; 
		public String primaryPolicyNumber; 
		public String primeIndicator; 
		public String product; 
		public String raceEthnicityCode; 
		public String rank; 
		public String regionCode; 
		public String relationshipCode; 
		public String relationshipSequenceNumber; 
		public String renalDialysisServiceQuoted; 
		public String reportingCode; 
		public String riderBenefitsServiceQuoted; 
		public String riderCodeIndicator; 
		public List<String> riderCodes; 
		public String secondaryDrugInsuranceIndicator; 
		public String sharedArrangementId; 
		public String site; 
		public String skilledNursingServiceQuoted; 
		public String specialistOfficeVisitServiceQuoted; 
		public String ssaPaymentCode; 
		public String stateCode; 
		public String statusCode; 
		public String street1; 
		public String street2; 
		public String subsidyOverrideIndicator; 
		public String totalNonCoverageCount; 
		public String transplantServiceQuoted; 
		public String transportationServiceQuoted; 
		public String trueOopServiceQuoted; 
		public String unfundedProgramsServiceQuoted; 
		public String valueAddedServiceServiceQuoted; 
		public String verbalLanguageName; 
		public String visionBenefitServiceQuoted; 
		public String walkinTime; 
		public String writtenLanguageName; 
		public String zipCode; 
		public String iPlanIndicator; 

		public Member()
		{
			this.dependentName = new DependentName();
			this.memberName = new DependentName();
			this.riderCodes = new List<String>{''};
		}
	}
	
	public class Claim {
		public String adjustedClaimIndicator; 
		public Atg atg;
		public String atgIndicator; 
		public String authorization; 
		public String claimApp; 
		public String claimAppSsn; 
		public String claimNumber; 
		public String claimOffice; 
		public String engineCode; 
		public String filmNumber; 
		public String filmOffice; 
		public String filmSystem; 
		public String fundingArrangement; 
		public String invoiceNumber; 
		public String payLocationNumber; 
		public String serviceDate; 
		public String substituteIndicator; 
		public String totalAmount; 

		public Claim()
		{
			this.atg = new Atg();
		}
	}
	
	public class Other {
		public String agencyName; 
		public String agencyTaxId; 
		public String agencyUniqueId; 
		public String company; 
		public String complState; 
		public String incompleteFlag; 
		public String insuranceCompany; 
		public String lineType; 
		public String qaCategory; 
		public String qaCodeType; 
		public String qaSource; 
		public String qitType; 
	}
}