public class ACET_MemberSearchResultsWrapper {

	public class ReferralInfo {
		@Auraenabled public String referralIndicator;
		//@Auraenabled public Boolean rLinkEBN;
		//@Auraenabled public String cosmosDelegatedEntity;
	}

	public class SearchQuery {
		/*@Auraenabled public String memberId;
		@Auraenabled public String lastName;
		@Auraenabled public String firstName;
		@Auraenabled public String dateOfBirth;*/
		@Auraenabled public String payerID; //DE343974 - Payer ID fetching as per the Member drop down value, not from the real time service - Durga
		/*@Auraenabled public String payerName;
		@Auraenabled public String serviceStart;
		@Auraenabled public String serviceEnd;
		@Auraenabled public String middleName;
		@Auraenabled public String gender;
		@Auraenabled public String ssn;
		@Auraenabled public String city;
		@Auraenabled public String state;
		@Auraenabled public String zip;
		@Auraenabled public String groupNumber;
		@Auraenabled public String serviceTypeCode;
		@Auraenabled public String providerLastName;
		@Auraenabled public String providerFirstName;
		@Auraenabled public String providerNameID;
		@Auraenabled public String corporateTaxOwnerID;
		@Auraenabled public String corporateTaxOwnerName;
		@Auraenabled public String organizationName;
		@Auraenabled public String organizationID;
		@Auraenabled public String taxIdNumber;
		@Auraenabled public String searchOption;
		@Auraenabled public String payerLabel;
		@Auraenabled public String npi;*/
	}

	public class PlanDates {
		@Auraenabled public String startDate;
		@Auraenabled public String endDate;
	}

	public class RequestingProvider {
		@Auraenabled public String providerFirstName;
		@Auraenabled public String providerMiddleName;
		@Auraenabled public String providerLastName;
		@Auraenabled public String providerNameID;
		@Auraenabled public String taxIdNumber;
		//@Auraenabled public String corporateTaxOwnerID;
		//@Auraenabled public String corporateTaxOwnerName;
		@Auraenabled public String organizationName;
		//@Auraenabled public String organizationID;
		//@Auraenabled public String facilityName;
		@Auraenabled public String npi;
	}

	public class PrimaryCarePhysicianInfo {
		@Auraenabled public String pcpFound;
		@Auraenabled public String lastName;
		@Auraenabled public String firstName;
		@Auraenabled public String middleName;
		//@Auraenabled public String addressLine1;
		//@Auraenabled public String addressLine2;
		//@Auraenabled public String city;
		//@Auraenabled public String state;
		//@Auraenabled public String zip;
		//@Auraenabled public String phoneNumber;
		//@Auraenabled public String networkStatusCode;
		//@Auraenabled public String affiliateHospitalName;
		//@Auraenabled public String providerGroupName;
	}

	public class PolicyInfo {
		//@Auraenabled public EligibilityDates eligibilityDates;
		@Auraenabled public String memberId;
		@Auraenabled public PlanDates planDates;
		@Auraenabled public String policyStatus;
		//@Auraenabled public SearchedDates searchedDates;
		//@Auraenabled public String graceMessageByState;
		//@Auraenabled public String gracePaidThrough;
		//@Auraenabled public String gracePeriodMonth;
		@Auraenabled public String coverageType;
		@Auraenabled public Boolean nonMedicalPolicyBoolean;
	}

	public class DeductibleInfo {
		@Auraenabled public Boolean found;
		@Auraenabled public Boolean nonMainPlan;
		@Auraenabled public Boolean inAndOutOfNetworkOnly;
		//@Auraenabled public String message;
		@Auraenabled public Individual individual;
		@Auraenabled public Individual family;
	}

	public class PatientInfo {
		@Auraenabled public String addressLine1;
		@Auraenabled public String addressLine2;
		@Auraenabled public String city;
		@Auraenabled public String dateOfBirth;
		@Auraenabled public String firstName;
		@Auraenabled public String gender;
		@Auraenabled public String lastName;
		@Auraenabled public String middleName;
		@Auraenabled public String relationship;
		@Auraenabled public String searched;
		@Auraenabled public String state;
		@Auraenabled public String zip;
		//@Auraenabled public String patientKey;
		//@Auraenabled public Boolean subscriberBoolean;
        @Auraenabled public String SSN;
		@Auraenabled public String EEID;
	}

	@Auraenabled public List<MemberPolicies> memberPolicies;
	@Auraenabled public RequestingProvider requestingProvider;
	//@Auraenabled public List<RequestingProviderAddresses> requestingProviderAddresses;
	@Auraenabled public SearchQuery searchQuery; //DE343974 - Payer ID fetching as per the Member drop down value, not from the real time service - Durga

	public class InsuranceInfo {
		@Auraenabled public String addressLine1;
		//@Auraenabled public String addressLine2;
		@Auraenabled public String city;
		//@Auraenabled public String countryCode;
		//@Auraenabled public String countrySubDivisionCode;
		//@Auraenabled public String found;
		@Auraenabled public String groupNumber;
		@Auraenabled public String insuranceType;
		@Auraenabled public String insuranceTypeCode;
		//@Auraenabled public String memberId;
		//@Auraenabled public String payerName;
		//@Auraenabled public String payerStatus;
		@Auraenabled public String planDescription;
		@Auraenabled public String state;
		@Auraenabled public String zip;
		//@Auraenabled public String hraBalance;
		//@Auraenabled public String hraMessage;
		//@Auraenabled public String hraUnavailableMessage;
		//@Auraenabled public String phoneNumber;
		//@Auraenabled public String oxfordPlatform;
		 @Auraenabled public String payerId; //DE343974 - Payer ID fetching as per the Member drop down value, not from the real time service - Durga
	}

	/*public class EligibilityDates {
		@Auraenabled public String startDate;
		@Auraenabled public String endDate;
	}*/

	public class Individual {
		@Auraenabled public Boolean found;
		@Auraenabled public InNetwork inNetwork;
		@Auraenabled public InNetwork outOfNetwork;
		@Auraenabled public InNetwork inNetworkTier1;
	}

	public class InNetwork {
		@Auraenabled public Boolean found;
		@Auraenabled public Boolean customerNetworkTier1;
		@Auraenabled public String planAmount;
		@Auraenabled public String planAmountFrequency;
		@Auraenabled public String remainingAmount;
		@Auraenabled public String metYtdAmount;
	}

	public class MemberPolicies {
		@Auraenabled public List<PatientInfo> patientInfo;
		//@Auraenabled public List<AdditionalCoverageInfo> additionalCoverageInfo;
		@Auraenabled public DeductibleInfo deductibleInfo;
		@Auraenabled public DeductibleInfo outOfPocketInfo;
		@Auraenabled public DeductibleInfo copayMaxInfo;
		@Auraenabled public DeductibleInfo outOfPocketMaxInfo;
		@Auraenabled public ReferralInfo referralInfo;
		@Auraenabled public InsuranceInfo insuranceInfo;
		@Auraenabled public PolicyInfo policyInfo;
		@Auraenabled public PrimaryCarePhysicianInfo primaryCarePhysicianInfo;
		@Auraenabled public String transactionId;
	}

	/*public class AdditionalCoverageInfo {
		@Auraenabled public String additionalCoverage;
		@Auraenabled public String payerName;
		@Auraenabled public String memberId;
		@Auraenabled public String phone;
		@Auraenabled public String url;
		@Auraenabled public String insuranceType;
		@Auraenabled public String payerStatus;
	}*/

	/*public class SearchedDates {
		@Auraenabled public String searchStartDate;
		@Auraenabled public String searchEndDate;
	}*/

	/*public class RequestingProviderAddresses {
		@Auraenabled public String mpin;
		@Auraenabled public String npi;
		@Auraenabled public String providerType;
		@Auraenabled public String address;
		@Auraenabled public String zip;
		@Auraenabled public String epdAddressSequenceId;
		@Auraenabled public String city;
		@Auraenabled public String state;
		@Auraenabled public String taxIdNumber;
	}*/

	@Auraenabled
	public static ACET_MemberSearchResultsWrapper parse(String json) {
		return (ACET_MemberSearchResultsWrapper) System.JSON.deserialize(json, ACET_MemberSearchResultsWrapper.class);
	}
}