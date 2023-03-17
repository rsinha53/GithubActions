// US1958736 - Thanish - 11th Feb 2020
public class ACET_ProviderDetailResponse {

	public class Dea {
		public String deaNumber;
	}

	public class OfficeLimitations {
		public String patientBeginAge;
		public String patientEndAge;
	}
    
   	 public class MedicareId{
       		 public string medicareId;
    	 }

	public class Address {
		public Active active;
		public String primaryAddressIndicator;
		public Active addressType;
		public String addressId;
		public String epdAddressSequenceId;
		public String addressLine1;
		public String addressLine2;
		public String city;
		public String county;
		public String state;
		public String zip;
		public String zip4;
		public String distance;
		public String billingAddressId;
		public String claimsRunoutDate;
		public String correspondenceAddressIndicator;
		public String correspondenceType;
		public String handicapAccessible;
		public String inCareOfName;
		public String latitude;
		public String longitude;
		public List<Phone> phone;
		public String topsTinPrefix;
		public String topsTinSuffix;
		public String extAddressLine1;
		public String extAddressLine2;
		public String vanityCity;
		public List<AddressContractOrg> addressContractOrg;
		public String effectiveDate;
		public String cancelDate;
		public ExternalDisplayAddress externalDisplayAddress;
	}

	public class Npi {
		public String cancelDate;
		public String dataSourceTypeCode;
		public String effectiveDate;
		public String npi;
		public NpiLevel npiLevel;
		public String npiTaxonomyCode;
	}

	public class Metadata {
		public Integer offset;
		public Integer psize;
		public Integer total;
		public String elapsedTime;
		public String elasticTime;
		public String wildCardResp;
		public String elapsedPODMTime;
		public String versionNumber;
		public String releaseType;
		public String releaseDate;
		public String supportContact;
	}

	public class PhysicianFacilityInformation {
		public Address address;
		public String atypicalProviderInd;
		public String cosmosContractStatusInd;
		public String cosmosContractOffSet;
		public String cosmosContractPSize;
		public String cosmosContractTotal;
		public List<CosmosContract> cosmosContract;
		public List<CosmosDemo> cosmosDemo;
		public String cspContractStatusInd;
		public String cspContractOffSet;
		public String cspContractPSize;
		public String cspContractTotal;
		public List<CspContract> cspContract;
		public List<Npi> npi;
		public String firstName;
		public String lastName;
		public String middleName;
		public String suffix;
		public String providerId;
		public String facilityName;
		public TaxId taxId;
		public String unetContractOffSet;
		public String unetContractPSize;
		public String unetContractTotal;
		public List<UnetContract> unetContract;
		public String unetContractStatusInd;
		public List<Specialty> specialty;
		public List<Dea> dea;
		public List<OfficeLimitations> officeLimitations;
        	public List<MedicareId> medicareId;
	}

	public class AddressContractOrg {
		public String contractOrgCode;
		public String primaryCode;
		public String contrOrgEffDate;
		public String contrOrgCancDate;
	}

	public class SvcResponse {
		public PhysicianFacilityInformation physicianFacilityInformation;
	}

	public class CspContract {
	}

	public class TaxId {
		public String taxId;
		public String taxIdType;
	}

	public class MedicalNecessityAgreement {
		public String documentId;
		public String documentIdTypeCode;
		public String medicalNecessityIndicator;
		public String effectiveDate;
		public String cancelDate;
	}

	public class Specialty {
		public Active specialty;
		public Active boardCertification;
	}

	public class Active {
		public String name;
		public String value;
	}

	public class CosmosContract {
		public String division;
		public String newPatientIndicator;
		public String panelNumber;
		public String pcpNumber;
		public String pcpType;
		public String providerNumber;
		public String providerType;
		public String role;
		public String panelEffectiveDate;
		public String panelCancelDate;
	}

	public class Phone {
		public Active active;
		public String areaCode;
		public String phoneNumber;
		public String phoneExtension;
		public String primaryPhoneIndicator;
		public Active useType;
	}

	public class UnetContract {
		public String acceptingNewPatientsCode;
		public String acceptingNewPatientsDescription;
		public String businessSegmentCode;
		public String businessSegmentDescription;
		public String contractArrangementCode;
		public String contractArrangementDescription;
		public String contractBillTypeCode;
		public String contractCancelDate;
		public String contractDescription;
		public String contractEffectiveDate;
		public String contractId;
		public String contractOrganizationCode;
		public String contractOrganizationDescription;
		public String contractOwnerId;
		public String contractPaperTypeCode;
		public String contractPaperTypeDescription;
		public String contractSiteCode;
		public String contractTemplateId;
		public String contractTemplateName;
		public String contractTypeCode;
		public String dicartaDocId;
		public String emergentWrapOptOut;
		public String facilityContractTypeCode;
		public String facilityContractTypeDescription;
		public String ipaDescription;
		public String ipaNumber;
		public String labAffiliationCode;
		public String marketName;
		public String marketNumber;
		public String marketTypeCode;
		public String marketTypeDescription;
		public List<MedicalNecessityAgreement> medicalNecessityAgreement;
		public String medicareCoinsurancePercentage;
		public String medicareDeductiblePercent;
		public String medicareExtendedAbsentIndicator;
		public String outpatientRateId;
		public String payMethodCode;
		public String pcpDescription;
		public String pcpIndicator;
		public String penaltyIndicator;
		public String penaltyNotifyId;
		public String hcfaProcInd;
		public String productCategoryCode;
		public String productGroupCode;
		public String productGroupDescription;
		public String productOfferDescription;
		public String productOfferId;
	}

	public class NpiLevel {
		public String codeDesc;
		public String codeValue;
	}

	public class ExternalDisplayAddress {
		public String addressLine1;
		public String addressLine2;
		public String city;
		public String county;
		public String state;
		public String zip;
		public String zip4;
	}

	public Metadata metadata;
	public SvcResponse svcResponse;
	public CspContract serviceFault;

	public class CosmosDemo {
		public String division;
		public String demoCancelDate;
		public String demoEffectiveDate;
		public String providerNumber;
		public String providerType;
	}

	
	public static ACET_ProviderDetailResponse parse(String json) {
		return (ACET_ProviderDetailResponse) System.JSON.deserialize(json, ACET_ProviderDetailResponse.class);
	}
}