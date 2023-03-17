public class SAE_ProviderResponse 
{
    public class Specialty_Z {
        public Specialty specialty;
        public String specialtySmallDesc;
        public List<AddressContractOrg> specialtyContractOrg;
    }
    
    public class Address {
        public String primaryAddressIndicator;
        public String addressId;
        public String adrCareName;
        public String addressTypeCode;
        public String addressTypeDescription;
        public String epdAddressSequenceId;
        public PostalAddress postalAddress;
        public String distance;
        public List<AddressContractOrg> addressContractOrg;
        public String extAddressLine1;
        public String extAddressLine2;
        public String vanityCity;
        public String effectiveDate;
        public String cancelDate;
        public PostalAddress externalDisplayAddress;
        public String billingAddressId;
        public String billingAddressTypeCode;
    }
    
    public class Degrees {
        //US1816853
        public String activeIndicator;
		public String degreeCode;
		public String primarySecondaryIndicator;
    }
    
    public class Npi {
        public String npi;
        public String npiLevelCode;
        public String effectiveDate;
        public String cancelDate;
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
        public String providerId;
        public String firstName;
        public String lastName;
        public String middleName;
        public String suffix;
        public String facilityName;
        public String gender;
        public String providerType;
        public String providerClassification;
        public TaxId taxId;
        public Address address;
        public List<Phone> phone;
        public List<Degrees> degrees;
        public List<Npi> npi;
        public List<ElectronicCommunication> electronicCommunication;
        public List<CredStatus> credStatus;
        public List<DelegatedEntity> delegatedEntity;
        public List<Specialty_Z> specialty;
        public String cosmosContractStatus;
        public String cspContractStatus;
        public String unetContractStatus;
        public List<MedicareId> medicareId;
        public String organizationalType;
        public String organizationalTypeDescription;
        public String providerTinPayAffiliationEffectiveDate;
        public String providerTinPayAffiliationCancelDate;
        public String providerEffectiveDate;
        public String providerCancelDate;
		
        public contractInformation contractInformation;
        // US1958733
        public QualityEfficiencyValues qualityEfficiencyValues;
        public String freeStandingFacilityIndicator;
		public String eiAcceptingPatientInd;
		public String mrAcceptingPatientInd;
		public String csAcceptingPatientInd;
    }
    
    public class contractInformation{
        public string tier;
        public string tierType;
        //US2954656	TECH - Submit the Authorization Summary & Confirmation Page: Provider Details - Integration - Sarma - 13/10/2010
        public string acoId;
        public string acoName;
        public string topsUhpdInd;
    }
    
    public class AddressContractOrg {
        public String contractOrgCode;
        public String primaryCode;
        public String contrOrgEffDate;
        public String contrOrgCancDate;
    }
    
    public class PhysicianFacilitySummary0002Response {
        public PhysicianFacilityInformation physicianFacilityInformation;
    }
    
    public class CredStatus {
        public String credStatusCode;
        public String credStatusDescription;
        public String credStatusShortDescription;
        public String credCycleDate;
    }
    
    public class DelegatedEntity {
        public String entityId;
        public String entityType;
        public String entityName;
        public String entityEffDate;
        public String entityCancDate;
    }
    
    public class TaxId {
        public String ptiIndicator;
        public String taxId;
        public String taxIdType;
        public String topsTinPrefix;
        public String topsTinSuffix;
        public String corporateOwnerFirstName;
        public String corporateOwnerMiddleName;
        public String corporateOwnerLastName;
        public String corpMPIN;
        public String payeeFirstName;
        public String payeeMiddleName;
        public String payeeLastName;
        public String payeeProviderId;
        public String provTierCode;
        public String preferredLabNetwork;
        public Tpsm tpsm;
        public String effectiveDate;
        public String cancelDate;
        public String epsTypeCode;
        public String epsTypeDescription;
        public String epsDate;
    }
    
    public class PostalAddress {
        public String addressLine1;
        public String addressLine2;
        public String city;
        public String county;
        public String state;
        public String zip;
        public String zip4;
    }
    
    public class Specialty {
        public String name;
        public String value;
    }
    
    public class Tpsm {
        public String tpsmInd;
        public String tpsmDescription;
        public String tpsmEffectiveDate;
        public String tpsmCancelDate;
    }
    
    public class Phone {
        public String active;
        public String areaCode;
        public String phoneExtension;
        public String phoneNumber;
        public String phoneUseTypeCode;
        public String phoneUseTypeDescription;
        public String primaryPhoneIndicator;
    }
    
    public Metadata metadata;
    public List<PhysicianFacilitySummary0002Response> PhysicianFacilitySummary0002Response;
    
    public class ElectronicCommunication {
        public String activeInd;
        public String communicationAddress;
        public String communicationTypeCode;
        public String electronicProviderOrAddressInd;
    }
    
    public class MedicareId {
        public String activeCode;
        public String medicareId;
        public String medicareIdLevelTypeCode;
    }
    
    // US2138174
    public class ServiceFault {
		public String faultType;
		public String faultCode;
		public String message;
	}

    // US1958733
    public class QualityEfficiencyValues {
		public String efficiencyRatingCode;
		public String efficiencyRatingDescription;
		public String qualityEfficiencyRating;
		public String qualityRatingCode;
		public String qualityRatingDescription;
	}

    public class Hospital_affiliations {
		public String actv_cd;
		public String pri_hosp_affil_cd;
		public String affil_typ_cd;
		public String affil_typ_desc;
		public String affil_prov_id;
		public String affil_lst_nm;
		public String admit_prvlg_typ_cd;
		public String admit_prvlg_desc;
	}

    public class SvcResponse {
		public String prov_id;
		public String tax_id_nbr;
		public String tax_id_type_cd;
		public List<Hospital_affiliations> hospital_affiliations;
	}

    public List<SvcResponse> svcResponse;
	public ServiceFault serviceFault;

    // End

    public static SAE_ProviderResponse parse(String json) {
        return (SAE_ProviderResponse) System.JSON.deserialize(json, SAE_ProviderResponse.class);
    }
}