/*
* @Desc: US1741780 - JSON2APEX Class for CopayAdditionalCoInsurance web service  
* @Date: 18-03-2020
* @Dev: Sarma
*/

public class ACET_CopayCoInsuranceResponceJSON2Apex {

	public class InNetworkTier1PreferredLab {
		public Boolean found;
		public Boolean tiersOnly;
		public Boolean referralObtained;
		public Boolean customerNetworkTier1;
		public String tieredNetworkStatus;
		public String text;
		public List<Services_Z> services;
	}

	public String patientKey;
	public CopayCoInsuranceDetails CopayCoInsuranceDetails;
	public VendorCoverageDetails vendorCoverageDetails;

	public class Messages {
		public Boolean found;
		public Notes notes;
		public CoPay coPay;
		public CoPay coInsurance;
		public Notes deductibles;
		public CoPay benefitsAllowed;
		public CoPay benefitsRemaining;
	}

	public class VendorCoverageDetails {
		public String message;
		public Boolean found;
		public List<ErrorCodes> vendorServices;
	}

	public class Messages_Z {
		public Boolean found;
		public Notes notes;
		public Notes coPay;
		public Notes coInsurance;
		public Notes deductibles;
		public Notes benefitsAllowed;
		public Notes benefitsRemaining;
	}

	public class Services {
		public Boolean found;
		public Boolean vendorOnly;
		public String service;
		public String serviceCode;
		public String text;
		public String status;
		public String coPayAmount;
		public String coPayFrequency;
		public String coInsurancePercent;
		public String planAmount;
		public String remainingAmount;
		public String metYearToDateAmount;
		public Boolean isReferralObtainedCopay;
		public Boolean isReferralObtainedCoInsurance;
		public String referralCopayAmount;
		public String referralCoInsurancePercent;
		public List<BenefitsAllowedFrequency> benefitsAllowedFrequency;
		public List<BenefitsAllowedFrequency> benefitsRemainingFrequency;
		public Messages messages;
	}

	public class ErrorCodes {
	}

	public class Individual {
		public Boolean found;
		public InNetwork inNetwork;
		public InNetwork outOfNetwork;
		public InNetwork inNetworkTier1;
		public InNetwork inNetworkTier1PreferredLab;
		public InNetwork inNetworkTier2;
	}

	public class CopayCoInsuranceDetails {
		public List<ErrorCodes> errorCodes;
		public Boolean found;
		public String message;
		public Individual individual;
		public Family family;
	}

	public class InNetwork {
		public Boolean found;
		public Boolean tiersOnly;
		public Boolean referralObtained;
		public Boolean customerNetworkTier1;
		public String tieredNetworkStatus;
		public String text;
		public List<Services> services;
	}

	public class Family {
		public Boolean found;
		public InNetworkTier1PreferredLab inNetwork;
		public InNetworkTier1PreferredLab outOfNetwork;
		public InNetworkTier1PreferredLab inNetworkTier1;
		public InNetworkTier1PreferredLab inNetworkTier1PreferredLab;
		public InNetworkTier1PreferredLab inNetworkTier2;
	}

	public class BenefitsAllowedFrequency {
		public String frequency;
		public List<String> messages;
        public Boolean combined;
		public Integer visits;
	}

	public class Services_Z {
		public Boolean found;
		public Boolean vendorOnly;
		public String service;
		public String serviceCode;
		public String text;
		public String status;
		public String coPayAmount;
		public String coPayFrequency;
		public String coInsurancePercent;
		public String planAmount;
		public String remainingAmount;
		public String metYearToDateAmount;
		public Boolean isReferralObtainedCopay;
		public Boolean isReferralObtainedCoInsurance;
		public String referralCopayAmount;
		public String referralCoInsurancePercent;
		// comment out - not used/JSON error
		// public List<ErrorCodes> benefitsAllowedFrequency;
		// public List<ErrorCodes> benefitsRemainingFrequency;
		public Messages_Z messages;
	}

	public class Notes {
		public Boolean found;
		public Boolean singleMessageDetails;
		public Boolean viewDetails;
		// comment out - not used/JSON error
		// public List<ErrorCodes> message;
		public String text;
	}

	public class CoPay {
		public Boolean found;
		public Boolean singleMessageDetails;
		public Boolean viewDetails;
		public List<String> message;
		public String text;
	}

	
	public static ACET_CopayCoInsuranceResponceJSON2Apex parse(String json) {
		return (ACET_CopayCoInsuranceResponceJSON2Apex) System.JSON.deserialize(json, ACET_CopayCoInsuranceResponceJSON2Apex.class);
	}
}