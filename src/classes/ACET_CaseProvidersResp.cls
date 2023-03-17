public with sharing class ACET_CaseProvidersResp {

	public Metadata metadata;
	public String responseCode;
	public HscProviders hscProviders;
	public Member member;

	public class Metadata {
		public String clientGroup;
		public String clientBusiness;
		public String clientLocation;
		public String userID;
		public String userIDType;
		public List<ProviderIdentifiers> providerIdentifiers;
		public String caseSubmissionTransactionID;
	}

	public class ProviderRoles {
		public List<ProviderRole> providerRole;
	}

	public class HscProviders {
		public List<HscProvider> hscProvider;
	}

	public class ProviderIdentifier {
		public String providerIDType;
		public String providerIDText;
		public String providerIDDesc;
	}

	public class ProviderContractOrgs {
		public List<ProviderContractOrg> providerContractOrg;
	}

	public class ProviderContractAmendment {
		public String contractDocumentID;
		public Long startDate;
		public Long endDate;
		public String providerContractAmendmentType;
		public String medicalNecessityTypeID;
		public ProviderContractAmendmentClauses providerContractAmendmentClauses;
	}

	public class ProviderIdentifiers {
		public List<ProviderIdentifier> providerIdentifier;
	}

	public class ProviderContractAmendments {
		public List<ProviderContractAmendment> providerContractAmendment;
	}

	public class ProviderContractOrg {
		public String providerContractOrg;
		public String providerContractContext;
		public String providerContractOrgPriority;
	}

	

	public class ProviderRole {
		public String providerRole;
		public String providerRoleDesc;
	}

	public class HscProvider {
		public Integer providerSeqNum;
		public String providerCategory;
		public String businessName;
		public String firstName;
		public String middleName;
		public String lastName;
		public String suffixName;
		public String address1;
		public String address2;
		public String city;
		public String vanityCity;
		public String state;
		public String stateDesc;
		public String zip;
		public String zipSuffix;
		public String specialtyType;
		public String specialtyTypeDesc;
		public String marketNumber;
		public String productType;
		public String primaryPhone;
		public Boolean primaryPhoneInternationalInd;
		public String fax;
		public Boolean faxInternationalInd;
		public Boolean detailInd;
		public String countyName;
		public String countryCode;
		public String productMarketType;
		public String contractID;
		public Boolean contractInd;
		public Long providerEffectiveDate;
		public Long providerTerminationDate;
		public String individualProvAssociationID;
		public String emergentWrapContractTypeID;
		public String optOutLabVendorType;
		public String providerOrgType;
		public String tpsmType;
		public String providerMedicaidLocationCode;
		public String medicalRecordNumber;
		public String networkSteerageReasonType;
		public String networkSteerageReasonTypeDesc;
		public String networkTier;
		public Boolean hscLetterOptOutCcInd;
		public String preferredNetworkInd;
		public String incentInd;
		public String contractRoleCode;
		public String uhpdTierDemotInd;
		public String providerContract;
		public String acoName;
		public String acoID;
		public String niceProviderType;
		public String niceProviderOrganizationName;
		public String niceProviderContractArrangType;
		public Boolean niceProviderOoaInd;
		public Boolean niceProviderContractTextInd;
		public Boolean niceProviderClaimTextInd;
		public String niceProviderMedicalRiskType;
		public String niceProviderHospitalRiskType;
		public String niceProviderPhsRiskType;
		public String niceProviderUmType;
		public String niceCompanyCodeType;
		public String niceProviderNetworkInfoType;
		public String assocNiceProvGroupNum;
		public String assocNiceProvGroupName;
		public String assocNiceProvServiceLocNum;
		public String assocNiceProvServiceLocName;
		public String derivedNiceProviderRiskType;
		public String productCategoryType;
		public String secondaryPhone;
		public Boolean secondaryPhoneInternationalInd;
		public String alternateFax;
		public Boolean alternateFaxInternationalInd;
		public Boolean alternateFaxConfirmedInd;
		public String conditionFocusDescription;
		public String qualityOutcomeType;
		public String efficiencyOutcomeType;
		public Integer correspNdbAddressSeqNum;
		public String correspAddress1;
		public String correspAddress2;
		public String correspCountyName;
		public String correspCity;
		public String correspState;
		public String correspZip;
		public String correspZipSuffix;
		public String correspCountryCode;
		public String correspAttentionToName;
		public Boolean autoApprovalLetterInd;
		public ProviderRoles providerRoles;
		public ProviderContractOrgs providerContractOrgs;
		public ProviderIdentifiers providerIdentifiers;
		public String cirrusBenefitPlanID;
		public String cirrusBenefitPlanName;
		public String cirrusNetworkScheduleIDType;
		public String cirrusServiceAreaIDType;
		public String cirrusNetworkID;
		public String cirrusNetworkIDDesc;
		public String cirrusContractType;
		public String cirrusContractTypeDesc;
		public String cirrusProviderAddressServiceAreas;
		public ProviderContractAmendments providerContractAmendments;
		public String specialtyTypeCirrus;
		public String specialtyTypeCirrusDesc;
		public String servicingFacilityName;
		public String servicingFacilityNPI;
		public String servicingFacilityTIN;
		public String servicingFacilityMPIN;
		public String servicingPhysicianFirstName;
		public String servicingPhysicianLastName;
		public String servicingPhysicianNPI;
		public String servicingPhysicianTIN;
		public String servicingPhysicianMPIN;
		public String networkStatusType;
		public String networkStatusTypeDesc;
		public String region;
		public String newProviderInd;
		public Boolean manualProviderInd;
	}

	public class ProviderContractAmendmentClauses {
		public List<ProviderContractAmendmentClause> providerContractAmendmentClause;
	}
	public class ProviderContractAmendmentClause {
		public String providerContractClauseTypeID;
		public String clauseText;
		public String providerContractProvisionType;
		public String clauseStatusTypeID;
	}
 
	public class Member {
		public String sourceMemberID;
		public String sourceMemberIDType;
		public String sourceMemberPartitionID;
		public String firstName;
		public String lastName;
		public String middleName;
		public String suffixName;
		public Long birthDate;
		public String genderType;
		public String genderTypeDesc; // DD
		public String relationshipCode;
		public String spokenLanguageText;
		public String writtenLanguageText;
		public MemberIdentifiers memberIdentifiers;
		public MemberPhones memberPhones;
		public Boolean detailInd; // DD
		public String settingOfCareText; // DD
		public String categoryEligibilityDesc; // DD
		public String race; // DD
		public String ethnicity; //DD
		public Boolean calapPreferenceInd;
		public String hmoLicenseCode; // DD
		public String calapWrittenLangType; // DD
		public String calapSpokenLangType; // DD
		public String preferredSpokenLangType; // DD
		public String preferredWrittenLangType; // DD
		public String captureReasonType; // DD
		public String recordSourceType;
		public Boolean memberNoContactInd;
		public Long subscriberEmploymentDate;
		public String subscriberEmployeeStatusType;
		public String bestDayToContact; // DD
		public String bestTimeToContact; // DD
		public String alternateRelationshipCode;
		public Integer consumerID;
		public Integer totalMonetizedValueAmount;
		public Double initialGestationalWeekCount;
		public Boolean envDisasterPlanInd;
		public String advanceDirectiveType; // DD
		public String goalOfCareType; // DD
		public Boolean autoMedReferralAssignmentInd;
		public Boolean geriatricMedChkInd;
		public String categoryEligibilityCode; // DD
		public Long lastRsaReceivedDateTime; // DD
		public Long lastRsaRequestedDateTime; // DD
		public String rsaRenewalDate; // DD
		public Boolean dnrIndicator;
		public String exchangeType;
		public String noPhoneReasonType; // DD
		public Integer primaryMedMemberCoverageSeqNum;
		public Long sourceMemberLastUpdateDateTime;
		public String alternateEthncCode; // DD
		public String alternateRaceCode; // DD
		public String altPrefWriteLangTypId; // DD
		public String altPrefSpokenLangTypId; // DD
		public Integer primaryISLIndividualGuid; // DD
		public Integer customerID;
		public Integer purchaserID;
		public Boolean hasLivingWillInd;
		public String rsaPopulationType; // DD
		public Long nextRsaDueDate; // DD
		public Long firstPocProblemDate; // DD
		public Integer confidentialInd;
		public Long niceMemberMigrationStartDate; // DD
		public Long medicareAStartDate; // DD
		public Long medicareBStartDate; // DD
		public Long medicareAEndDate; // DD 
		public Long medicareBEndDate; // DD
		public Boolean cobInd;
		public String otherCoverageCarrierName; // DD
		public String otherCoveragePolicyNumber; // DD
		public String otherCoverageCardHolderId; // DD
		public String otherCoverageCarrierTelNo; // DD
		public Boolean otherCovCarrierIntlInd;
		public String otherCoveragePolicyHolderName; // DD
		public Long cobStartDate; // DD
		public Long cobEndDate; // DD 
		public String otherCoverageOrderType;  // DD
		public String otherCoverageReasonTypeID; // DD
		public Boolean medicarePrimaryInd;
		public Long cobVerifyDate; // DD
		public String populationId; // DD
		public String origSystemMemberIDType;
		public String origSystemMemberID;
		public String eligibilitySystemTypeID;
		public Long deathDate; // DD
		public Integer icueMemberID;
		public String state; // DD
		public String policyNumber; // DD
		public String lineOfBusiness; // DD
		public String memberIDType; // DD
		public String memberIDDesc; // DD
		public String memberIDText; // DD
		public MemberAddresses memberAddresses;
		public String subscriberFirstName;
		public String subscriberLastName;
		public MemberCoverage memberCoverage;
		public MemberCoverages memberCoverages;
		public MemberOtherCoverages memberOtherCoverages;
		public MemberShareCosts memberShareCosts;
		public MemberCNSHealthStatuses memberCNSHealthStatuses; // DD 
		public MemberPopulations memberPopulations;
		public MemberPcps memberPcps; // DD
		public MemberContacts memberContacts; // DD 
		public MemberAlerts memberAlerts; // DD
		public MemberAdditionalPlanFeatures memberAdditionalPlanFeatures;
		public MemberBenefitPlanTiers memberBenefitPlanTiers; // DD 
	}

	public class MemberBenefitPlanTiers {
		public List<MemberBenefitPlanTier> memberBenefitPlanTier;
	}

	public class MemberBenefitPlanTier {
		public String cirrusBenefitPlanID;
		public String cirrusBenefitPlanName;
		public String cirrusBenefitPlanTierID;
		public String cirrusBenefitPlanTierName;
		public String cirrusBenefitPlanTierServiceAreaType;
		public String cirrusBenefitPlanTierServiceAreaTypeDesc;
		public String cirrusNetworkTierID;
		public String cirrusNetworkTierName;
		public String cirrusNetworkIDType;
		public String cirrusNetworkName;
	}

	public class MemberContacts {
		public List<MemberContact> memberContact;
	}

	public class MemberContact {
		public Integer contactSequenceNumber;
		public String contactType;
		public String otherContactTypeDescription;
		public String firstName;
		public String lastName;
		public String address1;
		public String address2;
		public String city;
		public String state;
		public String zip;
		public String zipSuffix;
		public String countryCode;
		public Long effectiveDate;
		public Long endDate;
		public String commentText;
		public Boolean phiAuthorizedInd;
		public String phiAuthorizedExpireEventDesc;
		public String phiTypeOfInfoDesc;
		public String phiAuthorizedPurposeDesc;
		public String emailAddress;
		public Boolean contactTypePrimaryInd;
		public Boolean contactPermissionInd;
		public Boolean supportSystemIndicator;
		public String supportIndicatorType;
		public String contactFrequency;
		public String relationship;
		public String organizationName;
		public Long recordSourceDateTime;
		public Integer submittingProviderClinicalID;
		public String legalGuardianRelationshipType;
		public String interdisciplinaryRoleType;
		public Long lastMemberISPAttended;
		public Boolean memberLegalRepresentationInd;
		public Boolean livesWithMemberInd;
		public String relationshipContactType;
		public MemberContactIdentifiers memberContactIdentifiers;
		public MemberContactTelephones memberContactTelephones;
	}
	public class MemberContactIdentifiers {
		public List<MemberContactIdentifier> memberContactIdentifier;
	}

	public class MemberContactIdentifier {
		public String memberContactIDType;
		public String memberContactID;
	}
	public class MemberContactTelephones {
		public List<MemberContactTelephone> memberContactTelephone;
	}

	public class MemberContactTelephone {
		public Integer phoneSeqNum;
		public String phone;
		public Boolean phoneInternaltionalInd;
		public String phoneType;
		public Boolean preferredInd;
	}

	public class MemberCNSHealthStatuses {
		public List<MemberCNSHealthStatus> memberCNSHealthStatus;
	}

	public class MemberCNSHealthStatus {
		public String healthStatusSeqNum;
		public String cnsHealthStatusCode;
		public String cnsHealthStatusDesc;
		public String commentText;
		public Long startDate;
		public Long endDate;
	}

	public class MemberAdditionalPlanFeatures {
		public List<MemberAdditionalPlanFeature> memberAdditionalPlanFeature;
	}

	public class MemberAdditionalPlanFeature {
		public String planFeatureCategoryType;
		public String planFeatureType;
	}

	public class MemberShareCosts {
		public List<MemberShareCost> memberShareCost;
	}

	public class MemberAlerts {
		public List<MemberAlert> memberAlerts;
	}

	public class MemberAlert { 
		public String alertType; // DD
		public Long alertEventDate; // DD
		public Long clearDateTime; // DD
	}

	public class MemberShareCost {
		public Double shareAmount; 
		public Long shareAmountStartDate; // DD Missing
		public Long shareAmountEndDate; // DD Missing
	}

	public class MemberIdentifiers {
		public List<MemberIdentifier> memberIdentifier;
	}

	public class MemberCoverage {
		public Integer memberCoverageSeqNum;
		public String policyNumber;
		public String coverageType;
		public Long coverageEffectiveDate;
		public Long coverageEndDate;
		public String marketNumber;
		public String marketType;
		public String divID;
		public String productType;
		public String productCategoryType;
		public String lineOfBusinessType;
		public String groupNumber;
		public String businessSegmentID; // DD
		public String legalEntityID;
		public String obligorID;
		public String sharedArrangementID;
		public String memberNetworkID;
		public String panelID;
		public String policyIssueState;
		public String coverageSetID;
		public String coverageSetMMECode;
		public String coverageSetCMECode;
		public String coverageSetMedicareCode;
		public String fundingArrangementID;
		public String planVariationID;
		public String reportCode;
		public String marketNetworkID; // DD
		public Boolean marketNetworkInd;
		public String claimPlatformID;
		public String cdhPlanType;
		public String policyName;
		public String marketSegmentCode;
		public Integer claimOfficeID;
		public String claimOfficeName;
		public String claimOfficeCustomerServicePhone;
		public String claimOfficePhone;
		public String claimOfficeAddress1;
		public String claimOfficeAddress2;
		public String claimOfficeCity;
		public String claimOfficeState;
		public String claimOfficeZip;
		public String claimOfficeZipSuffix;
		public String recordSourceType;
		public String productCode;
		public String niceCoveragePlanCode; // DD
		public String niceCoveragePlanDescription; // DD
		public String niceBenefitNetworkIndicator; // DD
		public String erisaIndicator;
		public String hcfaStatusType; // DD
		public String hcfaPlanID;
		public String niceCompanyCodeType; // DD
		public String niceCompanyRegionType; // DD
		public Boolean medNecessityApplInd;
		public String productYearText;
		public String healthServiceProductLineCode; // DD
		public String healthServiceProductCode; // DD
		public String alternatePolicyNumber; // DD
		public String productClassifierType;
		public String productBrandName; 
		public String masterGroupNumber; // DD
		public String marketPackageNumber; // DD
		public String marketPackageName; // DD
		public String financialProductNumber; // DD
		public String financialProductDescription; // DD
		public String riskTypeCode; // DD
		public String subscriberPackageBenefitPlanID;
		public String coreMedNecTypID;
		public Long policyEffectiveDate; // DD
		public Long policyEndDate; // DD
		public Boolean indvContrInd;
		public String businessSegmentName; // DD
		public Boolean cmsSnpInd;
		public String cmsSnpTypeName; // DD
		public String cmsStateShortName; // DD
		public String cmsProductTypeName; // DD
		public String radiologyMedNecType;
		public String cardiologyMedNecType;
		public String contractLabVendorType;
		public String legacyBenefitPlanID;
		public Long gracePeriodThroughDate;
		public Long paidThroughDate;
		public String emergentWrapBeneficiaryTypeID;
		public String cosmosUmDelegationTypeID; // DD
		public String oncologyMedNecType;
		public String legacyBenPlanDesc; // DD
		public String delegatedEntityName; // DD
		public String productTypeDescription; // DD
		public String providerNetworkDescription; // DD
		public String planVariationDesc;
		public String reciprocityNumber;
		public String planFeatureCode;
		public String planFeatureDescription;
		public Boolean ltcInd;
		public Boolean mmpInd;
		public String uhpdInd;
		public String topsTieredPlanSetup;
		public String groupBenefitNumber; // DD
		public String genTstMedNecType;
		public String cirrusProductID; // DD
		public String cirrusProductName; // DD
		public String cirrusBenefitBundleID; // DD
		public String cirrusBenefitBundleName; // DD
		public String cirrusBenefitBundleOptionID; // DD
		public String cirrusBenefitBundleOptionName; // DD
		public String cirrusBenefitPlanID; // DD
		public String cirrusBenefitPlanName; // DD
		public String cirrusServiceAreaIDType; // DD
		public String radiationMedNecType; // DD
		public String providerNetworkReciprocityType;
		public Object cmsSegID; // DD Missing
	} 

	public class MemberPhones {
		public List<MemberPhone> memberPhone;
	}  

	public class MemberPcps {
		public List<MemberPcp> memberPcp;
	}

	public class MemberPcp {
		public String ndbMpin;
		public Integer pcpSeqNbr;
		public Long effectiveDate;
		public String firstName;
		public String lastName;
		public Boolean phoneInternationalInd;
		public String phone;
		public Long endDate;
		public String individualProvAssociationID;
		public String nicePcpProviderGroupNbr; // DD
		public String nicePcpProviderSrvcLocNbr; // DD
		public String nicePmgNetworkCode; // DD
		public String acoID;
		public String acoName;
		public String mdmProviderID; // DD
		public String federalTaxID;
		public String marketNumber;
		public String marketType; // DD
		public String cirrusProviderLocationAffiliationID; // DD
	}

	public class MemberAddresses {
		public List<MemberAddress> memberAddress;
	}

	public class MemberPopulations {
		public List<MemberPopulation> memberPopulation;
	}

	public class MemberOtherCoverage { 
		public Integer otherCoverageSequenceNumber; // DD
		public String otherCoveragePolicyNumber; // DD
		public String carrierName; // DD
		public Long startDate; // DD 
		public Long endDate; // DD
		public String otherCoverageOrderType; // DD 
		public String otherCoverageReasonTypeID; // DD
	}

	public class MemberAddress {
		public String addressType;
		public String addressTypeDesc; // DD
		public String address1;
		public String address2;
		public String city;
		public String state;
		public String stateDesc; // DD
		public String zip;
		public String zipSuffix;
		public String countryCode;
		public String countryCodeDesc; // DD
		public Long effectiveDate; // DD
		public Long endDate; // DD
		public String countyFIPS; // DD
		public String countyName; // DD
	}

	public class MemberPopulation {
		public String populationId;
		public Long startDate;
		public Long endDate;
		public String populationRuleName;
		public Long memberPopAssociationDateTime;
	}

	public class MemberIdentifier {
		public String memberIDType;
		public String memberIDText;
		public String memberIDDesc; // DD
	}
	public class MemberCoverages {
		public List<MemberCoverage> memberCoverage;
	}

	public class MemberPhone {
		public String phoneType;
		public String phone;
		public Boolean phoneInternationalInd;
		public Boolean preferredInd;
	}

	public class MemberOtherCoverages {
		public List<MemberOtherCoverage> memberOtherCoverage;
	}

	public static ACET_caseProvidersResp parse(String json) {
		return (ACET_caseProvidersResp) System.JSON.deserialize(json, ACET_caseProvidersResp.class);
	}
}