/**
 * @description       : Ancillary Plans Response Wrapper - US3727594
 * @author            : Raviteja
 * @group             : Styx
 * @last modified on  : 08-06-2021
 * @last modified by  : Raviteja
**/
public class ACETAncillaryPlansResponse {

    public SearchResult searchResult;
    public class SearchResult {
		public SearchOutput searchOutput;
	}

    public class SearchOutput {
		public List<BenefitBundle> benefitBundle;
	}
	
    public class GroupContractOptionDate{
        public string groupContractOptionStartDate;
        public string groupContractOptionTerminationDate;
    }
    public class BenefitBundle {
		public String benefitBundleId;
		public String benefitBundleOptionId;
		public List<MembershipDate> membershipDate;
		public String serviceArea;
		public String designatedVirtualClinicNetwork;
		public String pcpRequiredIndicator;
		public List<Plan> plan;
        public list<GroupContractOptionDate> groupContractOptionDate;
	}

    public class MembershipDate {
		public String membershipEffectiveDate;
		public String membershipTerminationDate;
		public String subscriberIdentifier;
		public String subscriberIdentifierTypeCode;
	}

    public class Plan {
		public String planId;
		public String planName;
		public String planCategory;
		public String planType;
		public String serviceCategory;
		public String umDetermination;
		public String carrierId;
		public String carrierName;
		public List<CarrierExternalIdentifiers> carrierExternalIdentifiers;
		public List<Incentives> incentives;
		public String lineOfBusinessId;
		public String lineOfBusinessName;
		public List<Entities> entities;
		public List<ServiceFunction> serviceFunction;
		public String planLanguage;
		public String clinicalProgramVendor;
	}

    public class CarrierExternalIdentifiers {
		public String carrierExternalId;
		public String carrierExternalType;
	}

    public class ServiceFunction {
		public String functionCode;
		public String functionDescription;
		public String effectiveDate;
		public String expirationDate;
	}

	public class Incentives {
		public String rewardMethod;
		public String dailyMaxRewardAmount;
		public String annualMaxRewardAmount;
		public String calculationBasis;
		public String effectiveDate;
		public String expirationDate;
	}

	public class Entities {
		public String entityId;
		public String entityTypeDescription;
		public String externalPlanId;
	}
}