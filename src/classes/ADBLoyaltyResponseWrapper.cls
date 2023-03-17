public without sharing class ADBLoyaltyResponseWrapper {
	public ReadResult readResult;
    public Eligibilities eligibilities;
    public class ReadResult {
        public ReadOutput readOutput;  
    }
    public class ReadOutput {
        public List<Eligibilities> eligibilities;
    }
    public class Eligibilities{
        public SubscriberDetail subscriberDetail;
        public List<Vendors> vendors {get;set;}
		public String regionCode;
    }
    public class SubscriberDetail{
        public Eligibility eligibility;
    }
    public class Eligibility{
        public Demographics demographics;
        //  Sanka - US2750324
        public String networkKey;
        public List<Pcps> pcps {get;set;}
		//COB Details
        public list<cobs> cobs;
        public previousCobPrimarySecondary previousCobPrimarySecondary;
    }
	public class cobs{
        public String otherInsuranceIndicator;
        public String coverageType;
        public String otherInsuranceVerifyDate;
        public List<cobPrimacies> cobPrimacies;
    }
    public class cobPrimacies{
        public String otherInsurancePrimacy;
        public effectiveDates effectiveDates;
    }
    public class previousCobPrimarySecondary{
        public effectiveDates effectiveDates;
        public String typeCode;
        public String verifyDate;
    }
    public class effectiveDates{
        public String start;
        //end is a reserved word
        public String end_x;
    }
    public class Demographics{
        public String topsOrigCoverageEffectiveDate {get;set;}
        public string retirementDate{get;set;}
        public String cesCustomerName;
		 //COB
        public String dependentNumber;
    }
    public class VendorEffectiveDates {
		public String start {get;set;}
		public String end_Z {get;set;} // in json: end
	}
	public class Pcps {
		public String coverageType {get;set;}
		public String mpin {get;set;}
		public VendorEffectiveDates pcpEffectiveDates {get;set;}
		public String addressSequenceNumber {get;set;}
		public String productCode {get;set;}
		public String marketType {get;set;}
		public String marketSite {get;set;}
		public String ipa {get;set;}
	}

    public class Vendors {
		public String coverageType {get;set;}
		public String legacyPolicyNumber {get;set;}
		public String legacyPlanVariation {get;set;}
		public String legacyReportingCode {get;set;}
		public VendorEffectiveDates vendorEffectiveDates {get;set;}
		public String vendorBenefitOptionTypeCode {get;set;}
		public String healthServiceProductCode  {get;set;}
	}
	    public static ADBLoyaltyResponseWrapper parse(String json) {
        return (ADBLoyaltyResponseWrapper) System.JSON.deserialize(json, ADBLoyaltyResponseWrapper.class);
    } 
}