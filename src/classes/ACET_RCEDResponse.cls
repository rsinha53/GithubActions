public class ACET_RCEDResponse{
	public readResult readResult;
	public class readResult {
		public readOutput readOutput;
	}
	public class readOutput {
		public eligibilities[] eligibilities;
	}
	public class eligibilities {
		public String subscriberId;	//00152544111
		public String alternateId;	//978101001
		public String uhpDesignation;	//
		public String phiIndicator;	//
		public String claimSystem;	//F
		public String regionCode;	//FOXX
		public offices[] offices;
		public subscriberDetail subscriberDetail;
		public List<subscriberDetail> dependents;
	}
	public class offices {
		public String officeNumber;	//443
		public String officeName;	//
		public officeAddress officeAddress;
		public String officePhone;	//8662705333
		public String officeTollFree;	//8778423210
	}
	public class officeAddress {
		public String street1;	//MARYLAND-BUFF SERVICE CENTER
		public String street2;	//PO BOX 740800
		public String street3;	//
		public String city;	//ATLANTA
		public String state;	//GA
		public String zip;	//303740800
		public String zip4;	//
		public String countryCode;	//
	}
	public class subscriberDetail {
		public eligibility eligibility;
	}
	public class eligibility {
		public consumerKeys consumerKeys;
		public demographics demographics;
		public healthCoverages[] healthCoverages;
		public cobs[] cobs;
		public medicares[] medicares;
		public currentCobPrimarySecondary currentCobPrimarySecondary;
		public previousCobPrimarySecondary previousCobPrimarySecondary;
		public currentMedicarePrimarySecondary currentMedicarePrimarySecondary;
		public previousMedicarePrimarySecondary previousMedicarePrimarySecondary;
		public String networkKey;	//M
		public String phiIndicator;	//
		public String blbsMemberEligibilityIndicator;	//N
	}
	public class consumerKeys {
		public String sourceCode;	//CS
		public String familyId;	//0317373859
		public String familyIdPartitionNumber;	//00259
		public String xrefId;	//0544858223
		public String xrefIdPartitionNumber;	//00023
		public String legacySourceId;	//09055090015254411101001
	}
	public class demographics {
		public personName personName;
		public String topsName;	//BRAN
		public String ger;	//M
		public String age;	//71
		public String dependentNumber;	//001
		public String topsLatestCancelDate;	//
		public String systemDivision;	//
		public String tobaccoUsageIndicator;	//
		public String memberId;	//
		public String survivingSpouseId;	//
		public String hicNumber;	//4WX6X68DT51
		public String medicaidRecipientNumber;	//
		public String memberAltId;	//
		public String socialSecurityNumber;	//267152222
		public String legacyPolicyNumber;	//0905509
		public String claimEngineCode;	//F
		public String legacyCustomerNumber;	//0905509
		public String cesCustomerName;	//LIBERTY MUTUAL
		public String differentFamilyMemberAddressIndicator;	//Y
		public String alternateIdAssignTypeCode;	//S
		public String marketSegment;	//USS
		public String integratedCardTypeCode;	//H
		public String employeeStartDate;	//0001-01-01
		public String workHours;	//00000
		public String salaryTypeCode;	//
		public String salaryAmount;	//0.00
		public String retirementDate;	//9999-12-31
		public String deceasedDate;	//9999-12-31
		public String lateEnrollCode;	//
		public String exSpouseTypeCode;	//
		public String exSpouseSubscriberId;	//
		public String healthCoverageTransferIndicator;	//
		public effectiveDates healthCoverageTransferEffectiveDates;
		public String atOccupationTypeCode;	//
		public String rrDepentProofOfEligibilityDate;	//9999-12-31
		public String cobraIndicator;	//
		public String cobIndicator;	//N
		public String cobVerifyDate;	//2017-09-15
		public effectiveDates cobEffectiveDates;
		public String medicareExistsIndicator;	//Y
		public String medicareTypeCode;	//C
		public String medicareIneligibleNotEnrolledCode;	//
		public String medicareEntitlementTypeCode;	//A
		public medicareEnrolls[] medicareEnrolls;
		public String custodyCode;	//
		public String familyLastUpdateTimestamp;	//
		public String migrationLegacySourceId;	//
		public String migrationLegacyPolicyNumber;	//
		public String camsLegacySourceId;	//
		public String camsLegacyPolicyNumber;	//
		public String consumerProvidedTaxIdNumber;	//
		public String consumerProvidedTaxIdNumberStatusTypeCd;	//
		public String eobSuppressionIndicator;	//
		public String healthStatementSuppressionIndicator;	//
		public String administrativeLetterSuppressionIndicator;	//
		public String proofOfHealthCoverageSuppressionIndicator;	//
		public String preferenceCodeDescription;	//No preference selected
		public String memberLoyaltyYearsOfService;	//
		public String memberLoyaltyAcknowledgementDate;	//
		public String reportSegment;	//USS
		public String healthProgramCode;	//
		public String healthPlanCode;	//
		public String familyId;	//0317373859
		public String familyIdPartitionNumber;	//00259
		public String sourceCode;	//CS
		public String priorMemberId;	//PMI
		public String dateOfBirth;	//1950-02-05
		public String cdbRelationshipCode;	//001
		public String legacySourceRelationshipCode;	//01
		public String individualRelationshipCode;	//SP
		public String topsSequenceNumber;	//02
		public String topsOrigCoverageEffectiveDate;	//2016-01-01
		public String primeDepentCode;	//
		public String maritalStatus;	//U
		public String employeeStatus;	//R
		public String specialHandlerCode;	//0
		public String phiIndicator;	//
		public String qmscoIndicator;	//
		public String primaryPhoneNumber;	//8133448660
		public String alternatePhoneNumber;	//8135622222
		public String mobilePhoneNumber;	//
		public String organizationTypeCode;	//
		public permanentAddress permanentAddress;
		public mailingAddress mailingAddress;
	}
	public class personName {
		public String firstName;	//BRAN
		public String middleInitial;	//
		public String middleName;	//
		public String lastName;	//DENNIS
		public String nameSuffix;	//
	}
	public class medicareEnrolls {
		public String medicarePart;	//A
		public effectiveDates medicareEnrollEffectiveDates;
	}
	public class permanentAddress {
		public postalAddress postalAddress;
		public String marketNumber;	//0009452
		public String countrySubCode;	//
	}
	public class postalAddress {
		public String street1;	//3334 CAIRY ST APT D
		public String street2;	//
		public String street3;	//
		public String city;	//TAMPA
		public String state;	//FL
		public String zip;	//33614
		public String zip4;	//
		public String countryCode;	//US
	}
	public class mailingAddress {
		public postalAddress postalAddress;
		public String marketNumber;	//0009452
		public String countrySubCode;	//
	}
	public class healthCoverages {
		public String policyNumber;	//0905509
		public String coverageType;	//M
		public effectiveDates healthCoverageEffectiveDates;
		public String cesGroupNumber;	//0905509
		public String planVariationCode;	//0383
		public String reportingCode;	//0383
		public String productType;	//POS
		public String productCode;	//Q
		public String marketType;	//50
		public String marketNumber;	//0009452
		public String productServiceCode;	//8
		public String coverageLevel;	//3
		public String sharedArrangementCode;	//03
		public String obligorId;	//01
		public String allianceCode;	//
		public String passportGroupNumber;	//
		public String systemDivision;	//
		public String eligibilitySystemTypeCode;	//01
		public String claimSystemTypeCode;	//01
		public String eligibilityStatusTypeCode;	//R
		public String governmentProgramTypeCode;	//
		public String medicaTravelBenefitIndicator;	//N
		public String cancelReasonTypeCode;	//CO
		public String coveragePaidThruDate;	//9999-12-31
		public String coveragePaidThruReasonCode;	//
		public String listBillTypeCode;	//N
		public String billingSuffixCode;	//JB
		public String billingSubGroupNumber;	//31383
		public String topsCoverageLevel;	//51
		public String cosmosPanelNumber;	//000
		public String rrBenefitGroupNumber;	//
		public String rrBenefitGroupChoiceCode;	//
		public String rrBranchCode;	//
		public String rrUnionCode;	//
		public String rrOptOutPlanIndicator;	//
		public String fundingArrangement;	//A
		public String stateOfIssue;	//MA
		public String legacyProductId;	//PS1M07O9999
		public String legacyBenefitPlanId;	//ACIS031
		public effectiveDates benefitSetEffectiveDates;
		public salaries[] salaries;
		public String depentCoverageAllowedIndicator;	//Y
		public String capitationType;	//N
		public String claimAccountCode;	//000231
		public String optumIndicator;	//W
		public String sharedSavingsIndicator;	//N
		public String legalEntity1;	//20020
		public String legalEntity2;	//
		public String productTermCode;	//
		public String urnCode;	//Y
		public String ubhCode;	//Y
		public String healthAlliesDiscount;	//
		public String nhaTypeCode;	//
		public String globalSolutionsIndicator;	//N
		public String displayIndicator;	//C
		public String topsSubscriberId;	//S152546666
		public String topsPolicyNumber;	//905509
		public String topsPlanVariationCode;	//0383
		public String topsReportingCode;	//0383
		public String coverageLastUpdateDate;	//2018-08-07
		public String emergentWrapIndicator;	//N
		public String eligibilityGracePeriodThruDate;	//9999-12-31
		public String lastPremiumPaidDate;	//0001-01-01
		public String migrationLegacyPolicyNumber;	//
		public topsCoverageSet topsCoverageSet;
		public String tier1Indicator;	//
		public String xrefIdPntr;	//02
		public String sharedSavingPackageIndicator;	//N
		public String proofOfHealthCoverage;	//C
		public String designatedVirtualClinicNetwork;	//Y
		public String consumerLegalEntity;	//
		public String individualGroupTypeCode;	//
		public String billIndicatorTypeCode;	//
		public String outlierCostManagementIndicator;	//N
		public String memberAdvocacyIndicator;	//N
		public String nhpNetworkFlexIndicator;	//
		public String hdhpIndicator;	//03
		public String policyType;	//36
		public String benefitPeriodStartDate;	//2018-01-01
		public String benefitPeriodDate;	//2018-12-31
		public String productclassifier;	//00004
		public String certificationOfCoverageYear;	//2007
		public String brandingType;	//Name-50
		public String brandingName;	//
		public String siteOfCareCoreMed;	//A
		public String siteOfCareRadiology;	//E
		public String siteOfCareCardiology;	//E
		public String siteOfCareChemo;	//E
		public String siteOfCareGeneticTest;	//E
		public String siteOfCareServiceOne;	//E
		public String siteOfCareServiceTwo;	//E
		public String packageBenefitPlanCode;	//
		public String hContractId;	//
		public String segmentId;	//
	}
	public class salaries {
		public String year;	//0000
		public String inNetworkDeductible;	//0.00
		public String inNetworkOop;	//0.00
		public String outOfNetworkDeductible;	//0.00
		public String outOfNetworkOop;	//0.00
	}
	public class topsCoverageSet {
		public String topsCoverageSetId;	//E
		public String baseMme;	//0
		public String cme;	//31
		public String medicare;	//5
		public String rpcSuffix;	//JB
		public String rpcAccount;	//000231
	}
	public class cobs {
		public String coverageType;	//M
		public effectiveDates otherInsuranceDates;
		public String otherInsuranceVerifyDate;	//2017-09-15
		public String otherInsuranceIndicator;	//N
		public String custodyCode;	//
		public cobPrimacies[] cobPrimacies;
	}
	public class cobPrimacies {
        public String otherInsuranceType;
        public String otherInsurancePrimacy;
        public effectiveDates effectiveDates;
	}
	public class medicares {
		public String medicareExistsIndicator;	//Y
		public String medicareTypeCode;	//C
		public String medicareIneligibleNotEnrolledCode;	//
		public medicareEntitlements[] medicareEntitlements;
		public medicareEligibilities[] medicareEligibilities;
	}
	public class medicareEntitlements {
		public String entitlementTypeCode;	//A
		public effectiveDates medicareEntitlementEffectiveDates;
	}
	public class medicareEligibilities {
		public String medicarePart;	//A
		public String eligibilityIndicator;	//Y
		public effectiveDates medicareEligibilityEffectiveDates;
		public medicareEnrollments[] medicareEnrollments;
		public medicarePrimacies[] medicarePrimacies;
	}
	public class medicareEnrollments {
		public effectiveDates medicareEnrollmentEffectiveDates;
	}
	public class medicarePrimacies {
		public effectiveDates medicarePrimacyEffectiveDates;
		public String medicarePrimacy;	//P
		public String uhgOrderOfBenefits;	//2
		public String medicareCrossOverIndicator;	//Y
	}
	public class currentCobPrimarySecondary {
		public String typeCode;	//N
		public effectiveDates effectiveDates;
		public String verifyDate;	//2017-09-15
	}
	public class effectiveDates {
		public String start;	//2018-08-02
		public String end_x;	//2019-06-30
	}
	public class previousCobPrimarySecondary {
		public String typeCode;	//
		public effectiveDates effectiveDates;
		public String verifyDate;	//
	}
	public class currentMedicarePrimarySecondary {
		public String typeCode;	//Y
		public effectiveDates effectiveDates;
	}
	public class previousMedicarePrimarySecondary {
		public String typeCode;	//1
		public effectiveDates effectiveDates;
        public String verifyDate;	//
	}
	public class depents {
		public eligibility eligibility;
	}
}