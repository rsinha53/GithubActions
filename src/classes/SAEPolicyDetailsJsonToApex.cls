public class SAEPolicyDetailsJsonToApex {

	public class PostalAddress {
		public String city;
		public String country;
		public String state;
		public String street1;
		public String street2;
		public String zip;
		public String zip4;
	}

	public class AdditionalCoverage {
	}

	public Integer returnCode;
	public String errorMessage;
	public Object faultCode;
	public Attributes attributes;
	public Boolean partial;

	public class MemberInfo {
		public String relationship;
		public String firstName;
		public String lastName;
		public String dob;
		public String memberID;
		public List<Members> members;
		public String dos;
	}

	public class Attributes {
		public String platform;
		public String cosmosDivision;
		public String stateOfIssueCode;
		public String reportingCode;
		public String groupPanelNumber;
		public String tciTableNumber;
		public String subscriberID;
		public String relationshipCode;
		public String xrefId;
		public String xrefIdPartitionNumber;
		public String dependentSequenceNumber;
		public String policyNumber;
		public String sourceID;
		public String state;
		public String groupNumber;
		public String benefitPackageLogNumber;
		public String coverageStartDate;
		public String coverageEndDate;
		public PcpDetails pcpDetails;
		public Object serviceBenefitDescription;
		public Object serviceBenefitNotes;
		public String productID;
		public String cesGroupNumber;
		public String governmentProgramCode;
		public String alternateId;
		public String lineOfBusiness;
		public String benefitPlanId;
		public String sourceCode;
		public String legacyPanelNumber;
		public String marketType;
		public Object individualRelationshipCode;
		public String obligorID;
		public String productCode;
		public String productType;
		public String sharedArrangement;
		public String claimSourceSystemCode;
		public String birthDate;
		public String genderCode;
		public PostalAddress postalAddress;
		public String planVariation;
		public String marketSite;
		public Object planFeatureCode;
		public String eligibilitySourceSystemCode;
		public Object nhpIndicator;
		public Object pcid;
		public String fundingType;
		public CobUpdateInformation cobUpdateInformation;
		public String hsa;
		public String cdhp;
		public String primaryPayer;
		public MemberInfo memberInfo;
		public Object payerInfo;
		public String umDelegationFlag;
		public String virtualVisits;
		public List<Members> additionalCoverage;
		public String insuranceTypeCode;
		public String mbi;
	}

	public class ProviderAddress {
		public String addressLine1;
		public String addressLine2;
		public String city;
		public String state;
		public String zip;
	}

	public class PcpDetails {
		public String pcpMessage;
		public String pcpFirstName;
		public String pcpMiddleName;
		public String pcpLastName;
		public String affiliateHospitalName;
		public String pcpSpeciality;
		public String pcpStartDate;
		public String pcpEndDate;
		public String acoNetworkDescription;
		public String acoNetworkId;
		public String pcpPhoneNumber;
		public String taxId;
		public String providerNpi;
		public String providerGroupName;
		public ProviderAddress providerAddress;
		public Boolean pcpFound;
	}

	public class CobUpdateInformation {
		public String cobUpdateMessage;
		public Object cobLastUpdate;
	}

	public class Members {
		public String relationship;
		public String firstName;
		public String lastName;
		public String dob;
		public String memberID;
	}

	
	public static SAEPolicyDetailsJsonToApex parse(String json) {
        system.debug('json::::'+json);
        //system.debug('System.JSON.deserialize(json, SAEPolicyDetailsJsonToApex.class):::'+System.JSON.deserialize(json, SAEPolicyDetailsJsonToApex.class));
		return (SAEPolicyDetailsJsonToApex) System.JSON.deserialize(json, SAEPolicyDetailsJsonToApex.class);
	}
}