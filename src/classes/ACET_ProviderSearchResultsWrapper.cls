public class ACET_ProviderSearchResultsWrapper {

	@AuraEnabled public Metadata metadata;
	@AuraEnabled public List<PhysicianFacilitySummary0002Response> PhysicianFacilitySummary0002Response;
    @AuraEnabled public ServiceFault serviceFault;

	public class Address {
		@AuraEnabled public String primaryAddressIndicator;
		@AuraEnabled public String addressId;
		@AuraEnabled public String adrCareName;
		@AuraEnabled public String addressTypeCode;
		@AuraEnabled public String addressTypeDescription;
		@AuraEnabled public String epdAddressSequenceId;
		@AuraEnabled public PostalAddress postalAddress;
		@AuraEnabled public String distance;
		@AuraEnabled public List<AddressContractOrg> addressContractOrg;
		@AuraEnabled public String extAddressLine1;
		@AuraEnabled public String extAddressLine2;
		@AuraEnabled public String vanityCity;
		@AuraEnabled public String effectiveDate;
		@AuraEnabled public String cancelDate;
		@AuraEnabled public PostalAddress externalDisplayAddress;
		@AuraEnabled public String billingAddressId;
		@AuraEnabled public String billingAddressTypeCode;
	}

	public class Degrees {
		@AuraEnabled public String activeIndicator;
		@AuraEnabled public String degreeCode;
		@AuraEnabled public String primarySecondaryIndicator;
	}

	public class ProviderLanguage {
		@AuraEnabled public String active;
		@AuraEnabled public Language language;
		@AuraEnabled public Language languageSpokenByCode;
		@AuraEnabled public Language languageWrittenByCode;
	}

	public class Npi {
		@AuraEnabled public String npi;
		@AuraEnabled public String npiLevelCode;
		@AuraEnabled public String effectiveDate;
		@AuraEnabled public String cancelDate;
	}

	public class Metadata {
		@AuraEnabled public Integer offset;
		@AuraEnabled public Integer psize;
		@AuraEnabled public Integer total;
		@AuraEnabled public String elapsedTime;
		@AuraEnabled public String elasticTime;
		@AuraEnabled public String wildCardResp;
		@AuraEnabled public String elapsedPODMTime;
		@AuraEnabled public String versionNumber;
		@AuraEnabled public String releaseType;
		@AuraEnabled public String releaseDate;
		@AuraEnabled public String supportContact;
	}

	public class ServiceFault {
		@AuraEnabled public String message;
		@AuraEnabled public String faultCode;
	}

	public class PhysicianFacilityInformation {
		@AuraEnabled public String providerId;
		@AuraEnabled public String firstName;
		@AuraEnabled public String lastName;
		@AuraEnabled public String middleName;
		@AuraEnabled public String suffix;
		@AuraEnabled public String facilityName;
		@AuraEnabled public String gender;
		@AuraEnabled public String providerType;
		@AuraEnabled public String providerClassification;
		@AuraEnabled public TaxId taxId;
		@AuraEnabled public Address address;
		@AuraEnabled public List<Phone> phone;
		@AuraEnabled public List<Degrees> degrees;
		@AuraEnabled public List<ProviderLanguage> providerLanguage;
		@AuraEnabled public List<Npi> npi;
		@AuraEnabled public List<ElectronicCommunication> electronicCommunication;
		@AuraEnabled public List<CredStatus> credStatus;
		@AuraEnabled public List<Specialty> specialty;
		@AuraEnabled public String cosmosContractStatus;
		@AuraEnabled public String cspContractStatus;
		@AuraEnabled public String unetContractStatus;
		@AuraEnabled public List<MedicareId> medicareId;
		@AuraEnabled public String organizationalType;
		@AuraEnabled public String organizationalTypeDescription;
		@AuraEnabled public String providerTinPayAffiliationEffectiveDate;
		@AuraEnabled public String providerTinPayAffiliationCancelDate;
		@AuraEnabled public String providerEffectiveDate;
		@AuraEnabled public String providerCancelDate;
		@AuraEnabled public List<DelegatedEntity> delegatedEntity;
		@AuraEnabled public QualityEfficiencyValues qualityEfficiencyValues;
		@AuraEnabled public String freeStandingFacilityIndicator;
		@AuraEnabled public String eiAcceptingPatientInd;
		@AuraEnabled public String mrAcceptingPatientInd;
		@AuraEnabled public String csAcceptingPatientInd;
	}

	public class AddressContractOrg {
		@AuraEnabled public String contractOrgCode;
		@AuraEnabled public String primaryCode;
		@AuraEnabled public String contrOrgEffDate;
		@AuraEnabled public String contrOrgCancDate;
	}

	public class CredStatus {
		@AuraEnabled public String credStatusCode;
		@AuraEnabled public String credStatusDescription;
		@AuraEnabled public String credStatusShortDescription;
		@AuraEnabled public String credCycleDate;
	}

	public class DelegatedEntity {
		@AuraEnabled public String entityId;
		@AuraEnabled public String entityType;
		@AuraEnabled public String entityName;
		@AuraEnabled public String entityEffDate;
		@AuraEnabled public String entityCancDate;
	}

	public class TaxId {
		@AuraEnabled public String ptiIndicator;
		@AuraEnabled public String taxId;
		@AuraEnabled public String taxIdType;
		@AuraEnabled public String topsTinPrefix;
		@AuraEnabled public String topsTinSuffix;
		@AuraEnabled public String corporateOwnerFirstName;
		@AuraEnabled public String corporateOwnerMiddleName;
		@AuraEnabled public String corporateOwnerLastName;
		@AuraEnabled public String corpMPIN;
		@AuraEnabled public String payeeFirstName;
		@AuraEnabled public String payeeMiddleName;
		@AuraEnabled public String payeeLastName;
		@AuraEnabled public String payeeProviderId;
		@AuraEnabled public String provTierCode;
		@AuraEnabled public String preferredLabNetwork;
		@AuraEnabled public Tpsm tpsm;
		@AuraEnabled public String effectiveDate;
		@AuraEnabled public String cancelDate;
	}

	public class PhysicianFacilitySummary0002Response {
		@AuraEnabled public PhysicianFacilityInformation physicianFacilityInformation;
	}

	public class PostalAddress {
		@AuraEnabled public String addressLine1;
		@AuraEnabled public String addressLine2;
		@AuraEnabled public String city;
		@AuraEnabled public String county;
		@AuraEnabled public String state;
		@AuraEnabled public String zip;
		@AuraEnabled public String zip4;
	}

	public class Specialty {
		@AuraEnabled public Language specialty;
		@AuraEnabled public String specialtySmallDesc;
		@AuraEnabled public List<AddressContractOrg> specialtyContractOrg;
	}

	public class Tpsm {
		@AuraEnabled public String tpsmInd;
		@AuraEnabled public String tpsmDescription;
		@AuraEnabled public String tpsmEffectiveDate;
		@AuraEnabled public String tpsmCancelDate;
	}

	public class Language {
		@AuraEnabled public String name;
		@AuraEnabled public String value;
	}

	public class Phone {
		@AuraEnabled public String active;
		@AuraEnabled public String areaCode;
		@AuraEnabled public String phoneExtension;
		@AuraEnabled public String phoneNumber;
		@AuraEnabled public String phoneUseTypeCode;
		@AuraEnabled public String phoneUseTypeDescription;
		@AuraEnabled public String primaryPhoneIndicator;
	}

	public class QualityEfficiencyValues {
		@AuraEnabled public String efficiencyRatingCode;
		@AuraEnabled public String efficiencyRatingDescription;
		@AuraEnabled public String qualityEfficiencyRating;
		@AuraEnabled public String qualityRatingCode;
		@AuraEnabled public String qualityRatingDescription;
	}

	public class ElectronicCommunication {
		@AuraEnabled public String activeInd;
		@AuraEnabled public String communicationAddress;
		@AuraEnabled public String communicationTypeCode;
		@AuraEnabled public String electronicProviderOrAddressInd;
	}

	public class MedicareId {
		@AuraEnabled public String activeCode;
		@AuraEnabled public String medicareId;
		@AuraEnabled public String medicareIdLevelTypeCode;
	}

	
	public static ACET_ProviderSearchResultsWrapper parse(String json) {
		return (ACET_ProviderSearchResultsWrapper) System.JSON.deserialize(json, ACET_ProviderSearchResultsWrapper.class);
	}
}