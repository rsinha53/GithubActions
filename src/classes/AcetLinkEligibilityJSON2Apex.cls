/*
    Created By: Chandan Patro
    Created Date: 30th July 2019
    Description: This class is used to convert Json response from Link Eligibility Api to respective class.
*/
public class AcetLinkEligibilityJSON2Apex {
    
	public class ReferralInfo {
		public String referralIndicator;
		public Boolean rLinkEBN;
		public String cosmosDelegatedEntity;
	}

	public class SearchQuery {
		public String memberId;
		public String lastName;
		public String firstName;
		public String dateOfBirth;
		public String payerID;
		public String payerName;
		public String serviceStart;
		public String serviceEnd;
		public String middleName;
		public String gender;
		public String ssn;
		public String city;
		public String state;
		public String zip;
		public String groupNumber;
		public String serviceTypeCode;
		public String providerLastName;
		public String providerFirstName;
		public String providerNameID;
		public String corporateTaxOwnerID;
		public String corporateTaxOwnerName;
		public String organizationName;
		public String organizationID;
		public String taxIdNumber;
		public String searchOption;
		public String payerLabel;
		public String npi;
	}

	public class PlanDates {
		public String startDate;
		public String endDate;
	}

	public class RequestingProvider {
		public String providerFirstName;
		public String providerMiddleName;
		public String providerLastName;
		public String providerNameID;
		public String taxIdNumber;
		public String corporateTaxOwnerID;
		public String corporateTaxOwnerName;
		public String organizationName;
		public String organizationID;
		public String facilityName;
		public String npi;
	}

	public class PrimaryCarePhysicianInfo {
		public String pcpFound;
		public String lastName;
		public String firstName;
		public String middleName;
		public String addressLine1;
		public String addressLine2;
		public String city;
		public String state;
		public String zip;
		public String phoneNumber;
		public String networkStatusCode;
		public String affiliateHospitalName;
		public String providerGroupName;
	}

	public class PolicyInfo {
		public EligibilityDates eligibilityDates;
		public String memberId;
		public PlanDates planDates;
		public String policyStatus;
		public SearchedDates searchedDates;
		public String graceMessageByState;
		public String gracePaidThrough;
		public String gracePeriodMonth;
		public String coverageType;
		public Boolean nonMedicalPolicyBoolean;
	}

	public class DeductibleInfo {
		public Boolean found;
		public Boolean nonMainPlan;
		public Boolean inAndOutOfNetworkOnly;
		public String message;
		public Individual individual;
		public Individual family;
	}

	public class PatientInfo {
		public String addressLine1;
		public String addressLine2;
		public String city;
		public String dateOfBirth;
		public String firstName;
		public String gender;
		public String lastName;
		public String middleName;
		public String relationship;
		public String searched;
		public String state;
		public String zip;
		public String patientKey;
		public Boolean subscriberBoolean;
	}

	public List<MemberPolicies> memberPolicies;
	public RequestingProvider requestingProvider;
	public List<RequestingProviderAddresses> requestingProviderAddresses;
	public SearchQuery searchQuery;

	public class InsuranceInfo {
		public String addressLine1;
		public String addressLine2;
		public String city;
		public String countryCode;
		public String countrySubDivisionCode;
		public String found;
		public String groupNumber;
		public String insuranceType;
		public String insuranceTypeCode;
		public String memberId;
		public String payerName;
		public String payerStatus;
		public String planDescription;
		public String state;
		public String zip;
		public String hraBalance;
		public String hraMessage;
		public String hraUnavailableMessage;
		public String phoneNumber;
		public String oxfordPlatform;
	}

	public class EligibilityDates {
		public String startDate;
		public String endDate;
	}

	public class Individual {
		public Boolean found;
		public InNetwork inNetwork;
		public InNetwork outOfNetwork;
		public InNetwork inNetworkTier1;
	}

	public class InNetwork {
		public Boolean found;
		public Boolean customerNetworkTier1;
		public String planAmount;
		public String planAmountFrequency;
		public String remainingAmount;
		public String metYtdAmount;
	}

	public class MemberPolicies {
		public List<PatientInfo> patientInfo;
		public List<AdditionalCoverageInfo> additionalCoverageInfo;
		public DeductibleInfo deductibleInfo;
		public DeductibleInfo outOfPocketInfo;
		public DeductibleInfo copayMaxInfo;
		public DeductibleInfo outOfPocketMaxInfo;
		public ReferralInfo referralInfo;
		public InsuranceInfo insuranceInfo;
		public PolicyInfo policyInfo;
		public PrimaryCarePhysicianInfo primaryCarePhysicianInfo;
		public String transactionId;
	}

	public class AdditionalCoverageInfo {
		public String additionalCoverage;
		public String payerName;
		public String memberId;
		public String phone;
		public String url;
		public String insuranceType;
		public String payerStatus;
	}

	public class SearchedDates {
		public String searchStartDate;
		public String searchEndDate;
	}

	public class RequestingProviderAddresses {
		public String mpin;
		public String npi;
		public String providerType;
		public String address;
		public String zip;
		public String epdAddressSequenceId;
		public String city;
		public String state;
		public String taxIdNumber;
	}

	
	public static AcetLinkEligibilityJSON2Apex parse(String json) {
		return (AcetLinkEligibilityJSON2Apex) System.JSON.deserialize(json, AcetLinkEligibilityJSON2Apex.class);
	}
}