public class ACET_ORSRequestWrapper{

    public Meta meta;
    public Data data;
    
    public class Meta {
        public ControlModifiers controlModifiers;
    }
    public class ControlModifiers {
        public OrsSourceSystemParameters orsSourceSystemParameters;
    }
    public class OrsSourceSystemParameters {
        public String logonId;  
        public String logonOffice;  
    }
    public class Data {
        public String createdByApplicationIndicator;
        public Issue issue;
    }
    public class Issue {
        public String assignedPssId;    
        public String businessSegmentName;  
        public String callAttemptDetailText;    
        public String callbackPromisedDate; 
        public String callExceedsExpectationIndicator;  
        public String callHistoryFlag;  
        public String callMeetsExpectationIndicator;    
        public String callProgramName;   
        public String campaignCode;  
        public String campaignReportText;    
        public String caseNumber;    
        public String checkNumber;   
        public Claim claim;
        public List<String> comments;
        public String complaintCategoryText;     
        public Integer contactElapseTime;    
        public String contactId;     
        public String contactMethodCode;     
        public String deleteRequestIndicator;    
        public String directionCode;     
        public String disposition;   
        public String dispositionNotificationDate;   
        public Employer employer;
        public FollowUp followUp;
        public Grievance grievance;
        public String hipaaIndicator;    
        public Integer issueElapseTime;  
        public IssueHandling issueHandling;
        public String launchCategoryText;    
        public String launchReasonText;  
        public List<logoLookups> logoLookups;
        public String manualRouteIndicator;  
        public Member member;
        public String originalApplicationFileDate;   
        public Originator originator;
        public OtherInfo otherInfo;
        public String overrideIndicator;     
        public String payer;     
        public String pharmacyClaimNumber;   
        public String pharmacyClassText;     
        public String pharmacyId;    
        public String pharmacyName;  
        public String priority;  
        public ProviderInfo providerInfo;
        public String pssActionTaken;    
        public String raplNoblxIndicator;    
        public String reasonCategory;    
        public String reasonCode;    
        public String reasonHcnasType;   
        public String reasonType;    
        public String repeatIndicator;   
        public String routeConditionCode;    
        public String seriesDesignator;  
        public ServiceRequest serviceRequest;
        public String status;    
        public String subReasonText;     
        public String surveyCode;    
        public String updateDate;    
        public String updateTime;    
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
    }
    public class Atg {
        public String sourceId;  
        public List<Drafts> drafts;
    }
    public class Drafts {
        public String draftNumber;   
        public String inventoryControlNumber;    
    }
    public class Employer {
        public String employerName;  
        public String employerNumber;    
        public String employerState;     
    }
    public class FollowUp {
        public CellPhone cellPhone;
        public String contactDate;   
        public Creator creator;
        public String email;     
        public String estimatedCompletionDate;   
        public Fax fax;
        public String followUpDate;  
        public HomePhone homePhone;
        public String nextAction;    
        public String nextActionDueDate;     
        public OtherPhone otherPhone;
        public String preferredContactTime;
        public String primaryContact;    
        public String purposeCode;   
        public String resolvedDate;  
        public String statusCode;    
        public String voiceMailIndicator;    
        public WorkPhone workPhone;
    }
    public class CellPhone {
        public String areaCode;  
        public String number_Z;    
        public String extension;     
        public String extension2;    
    }
    public class Creator {
        public String associateId;   
        public String departmentCode;    
        public String officeId; 
        public String teamCode;  
    }
    public class Fax {
        public String areaCode;  
        public String number_Z;    
        public String extension;     
        public String extension2;    
    }
    public class HomePhone {
        public String areaCode;  
        public String number_Z;    
        public String extension;     
        public String extension2;    
    }
    public class OtherPhone {
        public String areaCode;  
        public String number_Z;    
        public String extension;     
        public String extension2;    
    }
    public class WorkPhone {
        public String areaCode;  
        public String number_Z;    
        public String extension;     
        public String extension2;    
    }
    public class Grievance {
        public String categoryText;  
        public String dispositionText;   
        public String reasonCode;    
        public String reasonText;    
        public String receiptDate;   
    }
    public class IssueHandling {
        public List<CarbonCopies> carbonCopies;
        public ResolvedBy resolvedBy;
        public RoutedTo routedTo;
    }
    public class CarbonCopies {
        public String associateId;   
        public String departmentCode;    
        public String officeId;  
        public String teamCode;  
    }
    public class ResolvedBy {
        public String associateId;   
        public String departmentCode;    
        public String officeId;  
        public String teamCode;  
    }
    public class RoutedTo {
        public String associateId;   
        public String departmentCode;   
        public String officeId;  
        public String teamCode;  
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
    public class Member {
        public Address address;
        public Integer age;  
        public String alternateId;   
        public String ambulanceIndicator;    
        public String assignedCsrName;   
        public String benefitPackageCode;    
        public String clientCode;    
        public String copayEffectiveDate;    
        public String coverageIndicator;     
        public String customerNumber;    
        public String dateOfBirth;   
        public String dateOfDeath;   
        public DependentName dependentName;
        public String dependentNumber;   
        public String division;  
        public String dlEligIndicator;   
        public String eligibilitySourceSystem;   
        public String eligibilityValidatedFlag;  
        public String email;     
        public String emailIndicator;    
        public String enrollmentSourceCode;  
        public String facetPlanCode;     
        public FaxNumber faxNumber;
        public String fontIndicator;     
        public String genderCode;    
        public String groupName;     
        public String groupNumber;   
        public String hippaEligibleFlag;     
        public String ipaCode;   
        public String iPlanIndicator;    
        public String languageTranslationId;     
        public String leadPlanCode;  
        public String legalEntity;   
        public String lisPctCode;    
        public String logoIndicator;     
        public String logonId;   
        public String market;    
        public String masterGroupNumber;     
        public String medicaidId;    
        public String medicareId;    
        public String medicareStatusCode;    
        public String meetingDate;   
        public String meetingTypeName;   
        public MemberName memberName;
        public String memberNumber;  
        public String memberVerifiedIndicator;   
        public String militaryTreatmentFacilityLocation;     
        public String neonIndicator;     
        public String networkPrefixCode;     
        public String obligorId;     
        public String optOutIndicator;   
        public String originalEffectiveDate;    
        public String otherGroupNumber;  
        public String otherProduct;  
        public String otherSubscriberId;     
        public String panelCode;     
        public String parentGroupName;   
        public String passportIndicator;    
        public String pcpOverrideIndicator;  
        public String personalIdentificationNumber;  
        public Phone phone;
        public String planCode;  
        public String planEffectiveDate;     
        public String planEndDate;   
        public String planVariationCode;     
        public String policy;    
        public String premiumWithholdCode;   
        public String primaryPolicyNumber;   
        public String primeIndicator;    
        public String product;   
        public String raceEthnicityCode;     
        public String rank;  
        public String regionCode;    
        public String relationshipCode;  
        public String relationshipSequenceNumber;    
        public String reportingCode;     
        public String riderCodeIndicator;    
        public List<String> riderCodes;
        public String secondaryDrugInsuranceIndicator;   
        public ServicesQuoted servicesQuoted;
        public String sharedArrangementId;   
        public String site;  
        public String ssaPaymentCode;    
        public String statusCode;    
        public String subsidyOverrideIndicator;  
        public Integer totalNonCoverageCount;    
        public String verbalLanguageName;    
        public String walkinTime;    
        public String writtenLanguageName;   
    }
    public class Address {
        public String city;  
        public String countryCode;   
        public String countryName;   
        public String countyCode;    
        public String countyName;    
        public String state;     
        public String street1;   
        public String street2;   
        public String zip;   
        public String zip4;  
    }
    public class DependentName {
        public String firstInitial;  
        public String firstName;     
        public String lastName;  
        public String middleInitial;     
    }
    public class FaxNumber {
        public String areaCode;  
        public String number_Z;    
        public String extension;     
        public String extension2;    
    }
    public class MemberName {
        public String firstInitial;  
        public String firstName;     
        public String lastName;  
        public String middleInitial;     
    }
    public class Phone {
        public String areaCode;  
        public String number_Z;    
        public String extension;     
        public String extension2;    
    }
    public class ServicesQuoted {
        public String alternativeAndHolisticMedicineServiceQuoted;  
        public String bloodServiceQuoted;    
        public String brandDrugsServiceQuoted;   
        public String careManagementProgramServiceQuoted;    
        public String cataractSurgeryBenefitsQuoted;     
        public String chiropracticServiceQuoted;     
        public String cosmeticServiceQuoted;     
        public String csrProgramServiceQuoted;   
        public String custodialCareServiceQuoted;    
        public String deductibleServiceQuoted;   
        public String dentalServiceQuoted;   
        public String diabeticEducationServiceQuoted;    
        public String diabeticMonitorAndSuppliesServiceQuoted;   
        public String diagnosticAndRadiologyServiceQuoted;   
        public String diagnosticLaboratoryServiceQuoted;     
        public String durableMedicalEquipmentServiceQuoted;  
        public String emergencyAndUrgentCareServiceQuoted;   
        public String familyPlanningServiceQuoted;   
        public String genericDrugsServiceQuoted;     
        public String gymMembershipServiceQuoted;    
        public String healthyLivingProgramsServiceQuoted;    
        public String hearingExamServiceQuoted;  
        public String hearingServiceQuoted;  
        public String homeHealthServiceQuoted;   
        public String immunizationsServiceQuoted;    
        public String inpatientHospitalAndMedicalServiceQuoted;  
        public String inpatientMentalHealthServiceQuoted;    
        public String mailOrderServiceQuoted;    
        public String maxLimitationsServiceQuoted;   
        public String maxOutOfPocketQuoted;  
        public String medicareCoveredDentalServiceQuoted;    
        public String memberMeetingsServiceQuoted;   
        public String nonRadiologyAndTherapeuticServiceQuoted;   
        public String oonBenefitServiceQuoted;   
        public String orthoticsAndProstheticsServiceQuoted;  
        public String otcSuppliesServiceQuoted;  
        public String outpatientMentalHealthServiceQuoted;   
        public String outpatientRehabilitationServiceQuoted;    
        public String outpatientSurgeryAndObservationServiceQuoted;  
        public String partBDrugsServiceQuoted;  
        public String pcpOfficeVisitServiceQuoted;   
        public String pharmacyLocatorServiceQuoted;  
        public String podiatryBenefitsServiceQuoted;     
        public String preferredFormularyServiceQuoted;   
        public String preventiveScreeningServiceQuoted;  
        public String renalDialysisServiceQuoted;    
        public String riderBenefitsServiceQuoted;    
        public String skilledNursingServiceQuoted;   
        public String specialistOfficeVisitServiceQuoted;    
        public String transplantServiceQuoted;   
        public String transportationServiceQuoted;   
        public String trueOopServiceQuoted;  
        public String unfundedProgramsServiceQuoted;     
        public String valueAddedServiceServiceQuoted;    
        public String visionBenefitServiceQuoted;    
    }
    public class Originator {
        public CallerAddress callerAddress;
        public CallerName callerName;
        public Cti cti;
        public DayPhone dayPhone;
        public EveningPhone eveningPhone;
        public String originatorMpin;    
        public String originatorTin;     
        public String originatorTinSuffix;   
        public String originatorTypeCode;    
        public String providerId;    
    }
    public class CallerAddress {
        public String city;  
        public String countryCode;   
        public String countryName;   
        public String countyCode;    
        public String countyName;    
        public String state;     
        public String street1;   
        public String street2;   
        public String zip;  
        public String zip4;  
    }
    public class CallerName {
        public String firstInitial;  
        public String firstName;     
        public String lastName;  
        public String middleInitial;     
    }
    public class Cti {
        public String autoId;    
        public String dialedId;  
        public String icrCallLocationDay;    
        public String icrCallLocationId;     
    }
    public class DayPhone {
        public String areaCode;  
        public String number_Z;    
        public String extension;     
        public String extension2;    
    }
    public class EveningPhone {
        public String areaCode;  
        public String number_Z;    
        public String extension;     
        public String extension2;    
    }
    public class OtherInfo {
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
    public class ProviderInfo {
        public String commonProviderID;  
        public String contractNumber;    
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
        public String productCode;   
        public String programSearchCode;     
        public Provider provider;
        public String providerSourceSystem;  
        public String providerValidatedFlag;     
        public String serviceMarket;     
        public String serviceZip;    
        public String specialtyText;     
        public String stateIssuedID;     
        public String statusCode;    
        public String tpsmIndicator;     
    }
    
    public class Pcp {
        public Address address;
        public String mpin;  
        public String mpinSequenceNumber;    
        public Phone phone;
        public String providerId;    
        public ProviderName providerName;
        public String taxId;     
        public String taxPrefix;     
        public String taxSuffix;     
    }
    public class ProviderName {
        public String firstInitial;  
        public String firstName;     
        public String lastName;  
        public String middleInitial;     
    }
    public class Provider {
        public Address address;
        public String mpin;  
        public String mpinSequenceNumber;    
        public Phone phone;
        public String providerId;    
        public ProviderName providerName;
        public String taxId;     
        public String taxPrefix;     
        public String taxSuffix;     
    }
    public class ServiceRequest {
        public String addressUpdateRequiredIndicator;    
        public String bulkCheckIndicator;    
        public String checkPayee;    
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
    
}