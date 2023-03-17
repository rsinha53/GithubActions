public with sharing class ACET_CreateAuthRequest {
    
    @AuraEnabled public InvocationContext invocationContext;
    @AuraEnabled public Metadata metadata;
    @AuraEnabled public String transactionId;
    @AuraEnabled public CaseDetails caseDetails;

    public class MemberCoverages {
        @AuraEnabled public List<MemberCoverage> memberCoverage{get; set;}
    }

    public class HscServices {
        @AuraEnabled public List<HscService> hscService{get; set;}
    }

    public class ProviderRoles {
        @AuraEnabled public List<ProviderRole> providerRole{get; set;}
    }

    public class HscContact {
        @AuraEnabled public CommunicationContactPhones communicationContactPhones{get; set;}
        @AuraEnabled public String contactName{get; set;}
        @AuraEnabled public String departmentType{get; set;}//TTAP vishnu
        @AuraEnabled public String contactRoleType{get; set;}
        @AuraEnabled public String communicationDateTime{get; set;}
        @AuraEnabled public String channelSourceType{get; set;}
        @AuraEnabled public String medicalRecordNumber{get; set;}////Added By Vishnu as new mapping
        @AuraEnabled public String emailAddress{get; set;} // US3589825
    }

    public class HscProviders {
        @AuraEnabled public List<HscProvider> hscProvider{get; set;}
    }

    public class MemberAddresses {
        @AuraEnabled public List<MemberAddress> memberAddress{get; set;}
    }

    public class HscFollowUpContact {
        @AuraEnabled public CommunicationContactPhones communicationContactPhones{get; set;}
        @AuraEnabled public String contactName{get; set;}
        @AuraEnabled public String contactRoleType{get; set;}
        @AuraEnabled public String departmentType{get; set;}//TTAP vishnu
        @AuraEnabled public String medicalRecordNumber{get; set;}//medical _Vishnu//Added By Vishnu as new mapping
        @AuraEnabled public String emailAddress{get; set;} // US3589825
    }

    public class CaseDetails {
        @AuraEnabled public HscDiagnoses hscDiagnoses{get; set;}
        @AuraEnabled public HscProviders hscProviders{get; set;}
        @AuraEnabled public Member member{get; set;}
        @AuraEnabled public HscContact hscContact{get; set;}
        @AuraEnabled public HscFollowUpContact hscFollowUpContact{get; set;}
        @AuraEnabled public HscServices hscServices{get; set;}
        @AuraEnabled public HscFacility hscFacility{get; set;}
        @AuraEnabled public String serviceSettingType{get; set;}
        @AuraEnabled public String reviewPriorityInd{get; set;}
        @AuraEnabled public Notes notes{get; set;}
    }
    public class Note {
		@AuraEnabled public Integer noteCategoryType{get; set;}
		@AuraEnabled public String noteCategoryTypeDesc{get; set;}
		@AuraEnabled public String noteText{get; set;}
        @AuraEnabled public String createUserID{get; set;}
        @AuraEnabled public String createDateTime{get; set;}
        @AuraEnabled public String createUserFirstName{get; set;} //US3557591
        @AuraEnabled public String createUserLastName{get; set;} //US3557591
    }
    public class Notes {
		@AuraEnabled public List<Note> note{get; set;}
	}

    public class MemberOtherCoverage {
        @AuraEnabled public String otherCoverageSequenceNumber{get; set;}
        @AuraEnabled public String otherCoveragePolicyNumber{get; set;}
        @AuraEnabled public String carrierName{get; set;}
        @AuraEnabled public String startDate{get; set;}
        @AuraEnabled public String endDate{get; set;}
        @AuraEnabled public String otherCoverageOrderType{get; set;}
        @AuraEnabled public String otherCoverageReasonTypeID{get; set;}
    }

    public class Metadata {
        @AuraEnabled public String clientGroup{get; set;}
        @AuraEnabled public String clientBusiness{get; set;}
        @AuraEnabled public String clientLocation{get; set;}
        @AuraEnabled public String clientNPI{get; set;}
        @AuraEnabled public String caseSubmissionTransactionID{get; set;}
    }

    public class MemberAddress {
        @AuraEnabled public String addressType{get; set;}
        @AuraEnabled public String addressTypeDesc{get; set;}
        @AuraEnabled public String address1{get; set;}
        @AuraEnabled public String address2{get; set;}
        @AuraEnabled public String city{get; set;}
        @AuraEnabled public String state{get; set;}
        @AuraEnabled public String stateDesc{get; set;}
        @AuraEnabled public String zip{get; set;}
        @AuraEnabled public String zipSuffix{get; set;}
        @AuraEnabled public String countryCode{get; set;}
        @AuraEnabled public String countryCodeDesc{get; set;}
        @AuraEnabled public String effectiveDate{get; set;}
        @AuraEnabled public String endDate{get; set;}
        @AuraEnabled public String countyFIPS{get; set;}
        @AuraEnabled public String countyName{get; set;}
    }

    public class HscServiceFacility {
        @AuraEnabled public String expectedProcedureDate{get; set;}
        @AuraEnabled public String actualProcedureDate{get; set;}//by vishnu
    }
    public class HscServiceNonFacility {// added for OP Vishnu
		@AuraEnabled public String serviceStartDate{get; set;}
		@AuraEnabled public String serviceEndDate{get; set;}
        @AuraEnabled public String dmeProcurementType{get; set;}
        @AuraEnabled public String dmeTotalCost{get; set;}
		@AuraEnabled public String placeOfServiceCode{get; set;}
		@AuraEnabled public String serviceDescriptionType{get; set;}
		@AuraEnabled public String serviceDetailType{get; set;}
		@AuraEnabled public String procedureFrequencyType{get; set;}
		@AuraEnabled public String procedureUnitCount{get; set;}
		@AuraEnabled public String procedureUnitOfMeasureType{get; set;}
		@AuraEnabled public String unitPerFrequencyCount{get; set;}
		@AuraEnabled public String advanceNotifyDateTime{get; set;}
	}

    public class ProviderIdentifier_Z {
        @AuraEnabled public String providerIDType{get; set;}
        @AuraEnabled public String providerIDText{get; set;}
        @AuraEnabled public String providerIDDesc{get; set;}
    }

    public class HscService {
        @AuraEnabled public HscServiceFacility hscServiceFacility{get; set;}
        @AuraEnabled public HscServiceNonFacility hscServiceNonFacility{get; set;}//added for OP Vishnu
        @AuraEnabled public String serviceSeqNum{get; set;}
        @AuraEnabled public String procedureCode{get; set;}
        @AuraEnabled public String procedureCodeType{get; set;}
        @AuraEnabled public String serviceProviderSeqNum{get; set;}
    }

    public class ProviderRole_Z {
        @AuraEnabled public String providerRole{get; set;}
        @AuraEnabled public String providerRoleDesc{get; set;}
    }

    public class ProviderRoles_Z {
        @AuraEnabled public List<ProviderRole_Z> providerRole{get; set;}
    }

    public class MemberIdentifier {
        @AuraEnabled public String memberIDType{get; set;}
        @AuraEnabled public String memberIDText{get; set;}
        @AuraEnabled public String memberIDDesc{get; set;}
        
    }

    public class ProviderIdentifier {
        @AuraEnabled public String providerIDType{get; set;}
        @AuraEnabled public String providerIDText{get; set;}
        @AuraEnabled public String providerIDDesc{get; set;}
    }

    public class HscDiagnoses {
        @AuraEnabled public List<HscDiagnosis> hscDiagnosis{get; set;}
    }

    public class MemberPhone {
        @AuraEnabled public String phoneType{get; set;}
        @AuraEnabled public String phone{get; set;}
        @AuraEnabled public Boolean phoneInternationalInd{get; set;}
        @AuraEnabled public Boolean preferredInd{get; set;}
    }

    public class MemberOtherCoverages {
        @AuraEnabled public List<MemberOtherCoverage> memberOtherCoverage{get; set;}
    }

    public class InvocationContext {
        @AuraEnabled public String clientID{get; set;}
        @AuraEnabled public String locationID{get; set;}
        @AuraEnabled public String userID{get; set;}
        @AuraEnabled public String userIDType{get; set;}
        @AuraEnabled public String clientCorrelationID{get; set;}
        @AuraEnabled public String serviceCorrelationID{get; set;}
    }

    public class HscDiagnosis {
        @AuraEnabled public String primaryInd = 'false';
        @AuraEnabled public String admitInd = 'false';
        @AuraEnabled public String diagnosisCodeType{get; set;}
        @AuraEnabled public String diagnosisSeqNum{get; set;}
        @AuraEnabled public String diagnosisCode{get; set;}
    }

    public class MemberPcp {
        @AuraEnabled public String ndbMpin{get; set;}
        @AuraEnabled public Boolean phoneInternationalInd{get; set;}
        @AuraEnabled public String pcpSeqNbr{get; set;}
        @AuraEnabled public String effectiveDate{get; set;}
        @AuraEnabled public String firstName{get; set;}
        @AuraEnabled public String lastName{get; set;}
        @AuraEnabled public String phone{get; set;}
        @AuraEnabled public String endDate{get; set;}
        @AuraEnabled public String acoID{get; set;}
        @AuraEnabled public String acoName{get; set;}
        @AuraEnabled public String federalTaxID{get; set;}
        @AuraEnabled public String individualProvAssociationID{get; set;}
		@AuraEnabled public String nicePcpProviderGroupNbr{get; set;}
		@AuraEnabled public String nicePcpProviderSrvcLocNbr{get; set;}
		@AuraEnabled public String nicePmgNetworkCode{get; set;}
        @AuraEnabled public String mdmProviderID{get; set;}
		@AuraEnabled public String marketNumber{get; set;}
		@AuraEnabled public String marketType{get; set;}
		@AuraEnabled public String cirrusProviderLocationAffiliationID{get; set;}

    }
    public class MemberPcps {
        @AuraEnabled public List<MemberPcp> memberPcp{get; set;}
    }
    public class Member {
        @AuraEnabled public MemberPcps memberPcps{get; set;}
        @AuraEnabled public MemberIdentifiers memberIdentifiers{get; set;}
        @AuraEnabled public MemberPhones memberPhones{get; set;}
        @AuraEnabled public String sourceMemberID{get; set;}
        @AuraEnabled public String sourceMemberIDType{get; set;}
        @AuraEnabled public String sourceMemberPartitionID{get; set;}
        @AuraEnabled public String firstName{get; set;}
        @AuraEnabled public String lastName{get; set;}
        @AuraEnabled public String middleName{get; set;}
        @AuraEnabled public String suffixName{get; set;}
        @AuraEnabled public String birthDate{get; set;}
        @AuraEnabled public String genderType{get; set;}
        @AuraEnabled public String genderTypeDesc{get; set;}
        @AuraEnabled public String relationshipCode{get; set;}
        @AuraEnabled public String spokenLanguageText{get; set;}
        @AuraEnabled public String writtenLanguageText{get; set;}
        @AuraEnabled public String detailInd{get; set;}
        @AuraEnabled public String settingOfCareText{get; set;}
        @AuraEnabled public String categoryEligibilityDesc{get; set;}
        @AuraEnabled public String race{get; set;}
        @AuraEnabled public String ethnicity{get; set;}
        @AuraEnabled public Boolean calapPreferenceInd{get; set;}
        @AuraEnabled public String hmoLicenseCode{get; set;}
        @AuraEnabled public String calapWrittenLangType{get; set;}
        @AuraEnabled public String calapSpokenLangType{get; set;}
        @AuraEnabled public String preferredSpokenLangType{get; set;}
        @AuraEnabled public String preferredWrittenLangType{get; set;}
        @AuraEnabled public String captureReasonType{get; set;}
        @AuraEnabled public String recordSourceType{get; set;}
        @AuraEnabled public Boolean memberNoContactInd{get; set;}
        @AuraEnabled public String subscriberEmploymentDate{get; set;}
        @AuraEnabled public String subscriberEmployeeStatusType{get; set;}
        @AuraEnabled public String bestDayToContact{get; set;}
        @AuraEnabled public String bestTimeToContact{get; set;}
        @AuraEnabled public String alternateRelationshipCode{get; set;}
        @AuraEnabled public Integer consumerID{get; set;}
        @AuraEnabled public Integer totalMonetizedValueAmount{get; set;}
        @AuraEnabled public Integer initialGestationalWeekCount{get; set;}
        @AuraEnabled public Boolean envDisasterPlanInd{get; set;}
        @AuraEnabled public String advanceDirectiveType{get; set;}
        @AuraEnabled public String goalOfCareType{get; set;}
        @AuraEnabled public Boolean autoMedReferralAssignmentInd{get; set;}
        @AuraEnabled public Boolean geriatricMedChkInd{get; set;}
        @AuraEnabled public String categoryEligibilityCode{get; set;}
        @AuraEnabled public String lastRsaReceivedDateTime{get; set;}
        @AuraEnabled public String lastRsaRequestedDateTime{get; set;}
        @AuraEnabled public String rsaRenewalDate{get; set;}
        @AuraEnabled public Boolean dnrIndicator{get; set;}
        @AuraEnabled public String exchangeType{get; set;}
        @AuraEnabled public String noPhoneReasonType{get; set;}
        @AuraEnabled public Integer primaryMedMemberCoverageSeqNum{get; set;}
        @AuraEnabled public String sourceMemberLastUpdateDateTime{get; set;}
        @AuraEnabled public String alternateEthncCode{get; set;}
        @AuraEnabled public String alternateRaceCode{get; set;}
        @AuraEnabled public String altPrefWriteLangTypId{get; set;}
        @AuraEnabled public String altPrefSpokenLangTypId{get; set;}
        @AuraEnabled public String primaryISLIndividualGuid{get; set;}
        @AuraEnabled public Integer customerID{get; set;}
        @AuraEnabled public Integer purchaserID{get; set;}
        @AuraEnabled public String hasLivingWillInd{get; set;}
        @AuraEnabled public String rsaPopulationType{get; set;}
        @AuraEnabled public String nextRsaDueDate{get; set;}
        @AuraEnabled public String firstPocProblemDate{get; set;}
        @AuraEnabled public Integer confidentialInd{get; set;}
        @AuraEnabled public String niceMemberMigrationStartDate{get; set;}
        @AuraEnabled public String medicareAStartDate{get; set;}
        @AuraEnabled public String medicareBStartDate{get; set;}
        @AuraEnabled public String medicareAEndDate{get; set;}
        @AuraEnabled public String medicareBEndDate{get; set;}
        @AuraEnabled public String cobInd{get; set;}
        @AuraEnabled public String otherCoverageCarrierName{get; set;}
        @AuraEnabled public String otherCoveragePolicyNumber{get; set;}
        @AuraEnabled public String otherCoverageCardHolderId{get; set;}
        @AuraEnabled public String otherCoverageCarrierTelNo{get; set;}
        @AuraEnabled public Boolean otherCovCarrierIntlInd{get; set;}
        @AuraEnabled public String otherCoveragePolicyHolderName{get; set;}
        @AuraEnabled public String cobStartDate{get; set;}
        @AuraEnabled public String cobEndDate{get; set;}
        @AuraEnabled public String otherCoverageOrderType{get; set;}
        @AuraEnabled public String otherCoverageReasonTypeID{get; set;}
        @AuraEnabled public Boolean medicarePrimaryInd{get; set;}
        @AuraEnabled public String cobVerifyDate{get; set;}
        @AuraEnabled public String populationId{get; set;}
        @AuraEnabled public String origSystemMemberIDType{get; set;}
        @AuraEnabled public String origSystemMemberID{get; set;}
        @AuraEnabled public String eligibilitySystemTypeID{get; set;}
        @AuraEnabled public String deathDate{get; set;}
        @AuraEnabled public MemberAddresses memberAddresses{get; set;}
        @AuraEnabled public MemberCoverage memberCoverage{get; set;}
        @AuraEnabled public MemberCoverages memberCoverages{get; set;}
        @AuraEnabled public MemberOtherCoverages memberOtherCoverages{get; set;}
        @AuraEnabled public MemberShareCosts memberShareCosts{get; set;}
        @AuraEnabled public MemberAdditionalPlanFeatures memberAdditionalPlanFeatures{get; set;}
        @AuraEnabled public MemberPopulations memberPopulations{get; set;}
        @AuraEnabled public String memberContacts{get; set;} // Obj Structure ??
        @AuraEnabled public String memberAlerts{get; set;} // Obj Structure ??
        @AuraEnabled public String memberCNSHealthStatuses{get; set;} // Obj Structure ??
        @AuraEnabled public String memberBenefitPlanTiers{get; set;} // Obj Structure ??
        @AuraEnabled public String subscriberFirstName{get; set;}
        @AuraEnabled public String subscriberLastName{get; set;}
        @AuraEnabled public String claimPlatformId{get; set;}
    }

    public class MemberAdditionalPlanFeatures {
		@AuraEnabled public List<MemberAdditionalPlanFeature> memberAdditionalPlanFeature{get; set;}
    }

	public class MemberAdditionalPlanFeature {
		@AuraEnabled public String planFeatureCategoryType{get; set;}
		@AuraEnabled public String planFeatureType{get; set;}
	}


    public class ProviderContractOrgs {
        @AuraEnabled public List<ProviderContractOrg> providerContractOrg{get; set;}
    }

    public class ProviderIdentifiers {
        @AuraEnabled public List<ProviderIdentifier> providerIdentifier{get; set;}
    }

    public class ProviderContractAmendment { // US3507490
        @AuraEnabled public String contractDocumentID{get; set;}
        @AuraEnabled public String startDate{get; set;}
        @AuraEnabled public String endDate{get; set;}
        @AuraEnabled public String medicalNecessityTypeID{get; set;}
        @AuraEnabled public String providerContractAmendmentType{get; set;}
    }

    public class HscFacility {
        @AuraEnabled public String placeOfServiceCode{get; set;}
        @AuraEnabled public String serviceDetailType{get; set;}
        @AuraEnabled public String serviceDescriptionType{get; set;}
        @AuraEnabled public String expectedAdmissionDate{get; set;}
        @AuraEnabled public String expectedDischargeDate{get; set;}
        @AuraEnabled public String actualAdmissionDateTime{get; set;}
        @AuraEnabled public String admissionNotifyDateTime{get; set;}
        @AuraEnabled public String actualDischargeDateTime{get; set;}
        @AuraEnabled public String dischargeDispositionType{get; set;}
    }

    public class ProviderRole {
        @AuraEnabled public String providerRole{get; set;}
        @AuraEnabled public String providerRoleDesc{get; set;}
    }

    public class MemberShareCosts {
        @AuraEnabled public List<MemberShareCost> memberShareCost {get; set;}
    }

    public class MemberPopulations {
		@AuraEnabled public List<MemberPopulation> memberPopulation {get; set;}
	}

    public class MemberPopulation {
		@AuraEnabled public String populationId{get; set;}
		@AuraEnabled public String startDate{get; set;}
		@AuraEnabled public String endDate{get; set;}
		@AuraEnabled public String populationRuleName{get; set;}
		@AuraEnabled public String memberPopAssociationDateTime{get; set;}
    }

    public class MemberShareCost {
        @AuraEnabled public Integer shareAmount{get; set;}
        @AuraEnabled public String shareAmountStartDate{get; set;}
        @AuraEnabled public String shareAmountEndDate{get; set;}
    }

    public class MemberIdentifiers {
        @AuraEnabled public List<MemberIdentifier> memberIdentifier{get; set;}
    }

    public class HscProvider {
        @AuraEnabled public ProviderRoles providerRoles{get; set;}
        @AuraEnabled public ProviderContractOrgs providerContractOrgs{get; set;}
        @AuraEnabled public ProviderIdentifiers providerIdentifiers{get; set;}
        @AuraEnabled public ProviderContractAmendments providerContractAmendments{get; set;}
        @AuraEnabled public Integer providerSeqNum{get; set;}
        @AuraEnabled public String providerCategory{get; set;}
        @AuraEnabled public String businessName{get; set;}
        @AuraEnabled public String firstName{get; set;}
        @AuraEnabled public String middleName{get; set;}
        @AuraEnabled public String lastName{get; set;}
        @AuraEnabled public String suffixName{get; set;}
        @AuraEnabled public String address1{get; set;}
        @AuraEnabled public String address2{get; set;}
        @AuraEnabled public String city{get; set;}
        @AuraEnabled public String vanityCity{get; set;}
        @AuraEnabled public String state{get; set;}
        @AuraEnabled public String stateDesc{get; set;}
        @AuraEnabled public String zip{get; set;}
        @AuraEnabled public String zipSuffix{get; set;}
        @AuraEnabled public String specialtyType{get; set;}
        @AuraEnabled public String specialtyTypeDesc{get; set;}
        @AuraEnabled public String marketNumber{get; set;}
        @AuraEnabled public String productType{get; set;}
        @AuraEnabled public String primaryPhone{get; set;}
        @AuraEnabled public Boolean primaryPhoneInternationalInd{get; set;}
        @AuraEnabled public String fax{get; set;}
        @AuraEnabled public Boolean faxInternationalInd{get; set;}
        @AuraEnabled public Boolean detailInd{get; set;}
        @AuraEnabled public String countyName{get; set;}
        @AuraEnabled public String countryCode{get; set;}
        @AuraEnabled public String productMarketType{get; set;}
        @AuraEnabled public String contractID{get; set;}
        @AuraEnabled public Boolean contractInd{get; set;}
        @AuraEnabled public String providerEffectiveDate{get; set;}
        @AuraEnabled public String providerTerminationDate{get; set;}
        @AuraEnabled public String individualProvAssociationID{get; set;}
        @AuraEnabled public String emergentWrapContractTypeID{get; set;}
        @AuraEnabled public String optOutLabVendorType{get; set;}
        @AuraEnabled public String providerOrgType{get; set;}
        @AuraEnabled public String tpsmType{get; set;}
        @AuraEnabled public String providerMedicaidLocationCode{get; set;}
        @AuraEnabled public String medicalRecordNumber{get; set;}
        @AuraEnabled public String networkSteerageReasonType{get; set;}
        @AuraEnabled public String networkTier{get; set;}
        @AuraEnabled public Boolean hscLetterOptOutCcInd{get; set;}
        @AuraEnabled public String preferredNetworkInd{get; set;}
        @AuraEnabled public String incentInd{get; set;}
        @AuraEnabled public String contractRoleCode{get; set;}
        @AuraEnabled public String uhpdTierDemotInd{get; set;}
        @AuraEnabled public String providerContract{get; set;}
        @AuraEnabled public String acoName{get; set;}
        @AuraEnabled public String acoID{get; set;}
        @AuraEnabled public String niceProviderType{get; set;}
        @AuraEnabled public String niceProviderOrganizationName{get; set;}
        @AuraEnabled public String niceProviderContractArrangType{get; set;}
        @AuraEnabled public Boolean niceProviderOoaInd{get; set;}
        @AuraEnabled public Boolean niceProviderContractTextInd{get; set;}
        @AuraEnabled public Boolean niceProviderClaimTextInd{get; set;}
        @AuraEnabled public String niceProviderMedicalRiskType{get; set;}
        @AuraEnabled public String niceProviderHospitalRiskType{get; set;}
        @AuraEnabled public String niceProviderPhsRiskType{get; set;}
        @AuraEnabled public String niceProviderUmType{get; set;}
        @AuraEnabled public String niceCompanyCodeType{get; set;}
        @AuraEnabled public String niceProviderNetworkInfoType{get; set;}
        @AuraEnabled public String assocNiceProvGroupNum{get; set;}
        @AuraEnabled public String assocNiceProvGroupName{get; set;}
        @AuraEnabled public String assocNiceProvServiceLocNum{get; set;}
        @AuraEnabled public String assocNiceProvServiceLocName{get; set;}
        @AuraEnabled public String derivedNiceProviderRiskType{get; set;}
        @AuraEnabled public String productCategoryType{get; set;}
        @AuraEnabled public String secondaryPhone{get; set;}
        @AuraEnabled public Boolean secondaryPhoneInternationalInd{get; set;}
        @AuraEnabled public String alternateFax{get; set;}
        @AuraEnabled public Boolean alternateFaxInternationalInd{get; set;}
        @AuraEnabled public Boolean alternateFaxConfirmedInd{get; set;}
        @AuraEnabled public String conditionFocusDescription{get; set;}
        @AuraEnabled public String qualityOutcomeType{get; set;}
        @AuraEnabled public String efficiencyOutcomeType{get; set;}
        @AuraEnabled public Integer correspNdbAddressSeqNum{get; set;}
        @AuraEnabled public String correspAddress1{get; set;}
        @AuraEnabled public String correspAddress2{get; set;}
        @AuraEnabled public String correspCountyName{get; set;}
        @AuraEnabled public String correspCity{get; set;}
        @AuraEnabled public String correspState{get; set;}
        @AuraEnabled public String correspZip{get; set;}
        @AuraEnabled public String correspZipSuffix{get; set;}
        @AuraEnabled public String correspCountryCode{get; set;}
        @AuraEnabled public String correspAttentionToName{get; set;}
        @AuraEnabled public Boolean autoApprovalLetterInd{get; set;}
        @AuraEnabled public String cirrusBenefitPlanID{get; set;}
        @AuraEnabled public String cirrusBenefitPlanName{get; set;}
        @AuraEnabled public String cirrusNetworkScheduleIDType{get; set;}
        @AuraEnabled public String cirrusServiceAreaIDType{get; set;}
        @AuraEnabled public String cirrusNetworkID{get; set;}
        @AuraEnabled public String cirrusNetworkIDDesc{get; set;}
        @AuraEnabled public String cirrusContractType{get; set;}
        @AuraEnabled public String cirrusContractTypeDesc{get; set;}
        @AuraEnabled public String cirrusProviderAddressServiceAreas{get; set;}
        @AuraEnabled public String specialtyTypeCirrus{get; set;}
        @AuraEnabled public String specialtyTypeCirrusDesc{get; set;}
        @AuraEnabled public String networkStatusType{get; set;}
        @AuraEnabled public String networkStatusTypeDesc{get; set;}
        @AuraEnabled public String newProviderInd{get; set;}
    }

    public class CommunicationContactPhone {
        @AuraEnabled public String phoneType{get; set;}
        @AuraEnabled public String phone{get; set;}
        @AuraEnabled public String phoneInternationalInd{get; set;}
        @AuraEnabled public String preferredInd{get; set;}
    }

    public class MemberCoverage {
        @AuraEnabled public Integer memberCoverageSeqNum{get; set;}
        @AuraEnabled public String policyNumber{get; set;}
        @AuraEnabled public String coverageType{get; set;}
        @AuraEnabled public String coverageEffectiveDate{get; set;}
        @AuraEnabled public String coverageEndDate{get; set;}
        @AuraEnabled public String marketNumber{get; set;}
        @AuraEnabled public String marketType{get; set;}
        @AuraEnabled public String divID{get; set;}
        @AuraEnabled public String productType{get; set;}
        @AuraEnabled public String productCategoryType{get; set;}
        @AuraEnabled public String lineOfBusinessType{get; set;}
        @AuraEnabled public String groupNumber{get; set;}
        @AuraEnabled public String businessSegmentID{get; set;}
        @AuraEnabled public String legalEntityID{get; set;}
        @AuraEnabled public String obligorID{get; set;}
        @AuraEnabled public String sharedArrangementID{get; set;}
        @AuraEnabled public String memberNetworkID{get; set;}
        @AuraEnabled public String panelID{get; set;}
        @AuraEnabled public String policyIssueState{get; set;}
        @AuraEnabled public String coverageSetID{get; set;}
        @AuraEnabled public String coverageSetMMECode{get; set;}
        @AuraEnabled public String coverageSetCMECode{get; set;}
        @AuraEnabled public String coverageSetMedicareCode{get; set;}
        @AuraEnabled public String fundingArrangementID{get; set;}
        @AuraEnabled public String planVariationID{get; set;}
        @AuraEnabled public String reportCode{get; set;}
        @AuraEnabled public String marketNetworkID{get; set;}
        @AuraEnabled public String marketNetworkInd{get; set;}
        @AuraEnabled public String claimPlatformID{get; set;}
        @AuraEnabled public String cdhPlanType{get; set;}
        @AuraEnabled public String policyName{get; set;}
        @AuraEnabled public String marketSegmentCode{get; set;}
        @AuraEnabled public Integer claimOfficeID{get; set;}
        @AuraEnabled public String claimOfficeName{get; set;}
        @AuraEnabled public String claimOfficeCustomerServicePhone{get; set;}
        @AuraEnabled public String claimOfficePhone{get; set;}
        @AuraEnabled public String claimOfficeAddress1{get; set;}
        @AuraEnabled public String claimOfficeAddress2{get; set;}
        @AuraEnabled public String claimOfficeCity{get; set;}
        @AuraEnabled public String claimOfficeState{get; set;}
        @AuraEnabled public String claimOfficeZip{get; set;}
        @AuraEnabled public String claimOfficeZipSuffix{get; set;}
        @AuraEnabled public String recordSourceType{get; set;}
        @AuraEnabled public String productCode{get; set;}
        @AuraEnabled public String niceCoveragePlanCode{get; set;}
        @AuraEnabled public String niceCoveragePlanDescription{get; set;}
        @AuraEnabled public String niceBenefitNetworkIndicator{get; set;}
        @AuraEnabled public String erisaIndicator{get; set;}
        @AuraEnabled public String hcfaStatusType{get; set;}
        @AuraEnabled public String hcfaPlanID{get; set;}
        @AuraEnabled public String niceCompanyCodeType{get; set;}
        @AuraEnabled public String niceCompanyRegionType{get; set;}
        @AuraEnabled public Boolean medNecessityApplInd{get; set;}
        @AuraEnabled public String productYearText{get; set;}
        @AuraEnabled public String healthServiceProductLineCode{get; set;}
        @AuraEnabled public String healthServiceProductCode{get; set;}
        @AuraEnabled public String alternatePolicyNumber{get; set;}
        @AuraEnabled public String productClassifierType{get; set;}
        @AuraEnabled public String productBrandName{get; set;}
        @AuraEnabled public String masterGroupNumber{get; set;}
        @AuraEnabled public String marketPackageNumber{get; set;}
        @AuraEnabled public String marketPackageName{get; set;}
        @AuraEnabled public String financialProductNumber{get; set;}
        @AuraEnabled public String financialProductDescription{get; set;}
        @AuraEnabled public String riskTypeCode{get; set;}
        @AuraEnabled public String subscriberPackageBenefitPlanID{get; set;}
        @AuraEnabled public String coreMedNecTypID{get; set;}
        @AuraEnabled public String policyEffectiveDate{get; set;}
        @AuraEnabled public String policyEndDate{get; set;}
        @AuraEnabled public Boolean indvContrInd{get; set;}
        @AuraEnabled public String businessSegmentName{get; set;}
        @AuraEnabled public Boolean cmsSnpInd{get; set;}
        @AuraEnabled public String cmsSnpTypeName{get; set;}
        @AuraEnabled public String cmsStateShortName{get; set;}
        @AuraEnabled public String cmsProductTypeName{get; set;}
        @AuraEnabled public String radiologyMedNecType{get; set;}
        @AuraEnabled public String cardiologyMedNecType{get; set;}
        @AuraEnabled public String contractLabVendorType{get; set;}
        @AuraEnabled public String legacyBenefitPlanID{get; set;}
        @AuraEnabled public String gracePeriodThroughDate{get; set;}
        @AuraEnabled public String paidThroughDate{get; set;}
        @AuraEnabled public String emergentWrapBeneficiaryTypeID{get; set;}
        @AuraEnabled public String cosmosUmDelegationTypeID{get; set;}
        @AuraEnabled public String oncologyMedNecType{get; set;}
        @AuraEnabled public String legacyBenPlanDesc{get; set;}
        @AuraEnabled public String delegatedEntityName{get; set;}
        @AuraEnabled public String productTypeDescription{get; set;}
        @AuraEnabled public String providerNetworkDescription{get; set;}
        @AuraEnabled public String planVariationDesc{get; set;}
        @AuraEnabled public String reciprocityNumber{get; set;}
        @AuraEnabled public String planFeatureCode{get; set;}
        @AuraEnabled public String planFeatureDescription{get; set;}
        @AuraEnabled public Boolean ltcInd{get; set;}
        @AuraEnabled public Boolean mmpInd{get; set;}
        @AuraEnabled public String uhpdInd{get; set;}
        @AuraEnabled public String topsTieredPlanSetup{get; set;}
        @AuraEnabled public String groupBenefitNumber{get; set;}
        @AuraEnabled public String genTstMedNecType{get; set;}
        @AuraEnabled public String cirrusProductID{get; set;}
        @AuraEnabled public String cirrusProductName{get; set;}
        @AuraEnabled public String cirrusBenefitBundleID{get; set;}
        @AuraEnabled public String cirrusBenefitBundleName{get; set;}
        @AuraEnabled public String cirrusBenefitBundleOptionID{get; set;}
        @AuraEnabled public String cirrusBenefitBundleOptionName{get; set;}
        @AuraEnabled public String cirrusBenefitPlanID{get; set;}
        @AuraEnabled public String cirrusBenefitPlanName{get; set;}
        @AuraEnabled public String cirrusServiceAreaIDType{get; set;}
        @AuraEnabled public String radiationMedNecType{get; set;}
        @AuraEnabled public String providerNetworkReciprocityType{get; set;}
        @AuraEnabled public String providerTierRulePackageKey{get; set;}
    }

    public class MemberPhones {
        @AuraEnabled public List<MemberPhone> memberPhone{get; set;}
    }

    public class CommunicationContactPhones {
        @AuraEnabled public List<CommunicationContactPhone> communicationContactPhone{get; set;}
    }

    public class ProviderIdentifiers_Z {
        @AuraEnabled public List<ProviderIdentifier_Z> providerIdentifier{get; set;}
    }

    public class ProviderContractAmendments {
        @AuraEnabled public List<ProviderContractAmendment> providerContractAmendment{get; set;}
    }

    public class ProviderContractOrg {
        @AuraEnabled public String providerContractOrg{get; set;}
        @AuraEnabled public String providerContractContext{get; set;}
        @AuraEnabled public String providerContractOrgPriority{get; set;}
    }
    
    public static ACET_CreateAuthRequest parse(String json) {
        return (ACET_CreateAuthRequest) System.JSON.deserialize(json, ACET_CreateAuthRequest.class);
    }
}