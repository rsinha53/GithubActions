public class ACETLGT_FindMedicalProviderJSON2Apex {

    public findMedicalProvidersResponse findMedicalProvidersResponse {get;set;}
	public class qualityTier{
        public string networkId{get;set;} 
        public string ruleId{get;set;} 
        public string level{get;set;} 
        public string reasonCode{get;set;} 
        public string directoryDisplayIndicator{get;set;} 
    }
    public class Address {
        public String addressLine1 {get;set;}
        public String addressLine2 {get;set;}
        public String city {get;set;}
        public String postalPrefixCode {get;set;}
        public String postalSuffixCode {get;set;}
        public String countryCode {get;set;}
        public String countryDescription {get;set;}
        public List<String> benefitServiceAreas{get;set;}
        public String countyCode {get;set;}
        public String countyDescription {get;set;}
        public String stateCode {get;set;}
        public String addressId {get;set;}
        public String typeCode {get;set;}
        public String effectiveDate {get;set;}
        public String cancelDate {get;set;}
        public String statusCode {get;set;}
        public String primaryIndicator {get;set;}
        public String distance {get;set;}
      public String handicapAccessibleIndicator {get;set;}
    }

    
    public class Npi {
        public String id {get;set;}
    
    }

    public class MedicalProviders {
        public Key key {get;set;}
        public HealthcareProvider healthcareProvider {get;set;}
        public ProviderTIN providerTIN {get;set;}
        public List<Tpsm> tpsm {get;set;}
        public List<Npi> npi {get;set;}
        public Contract[] contract {get;set;}
        public List<Specialty> specialty {get;set;}
        public Address address {get;set;}
        public List<role> role {get;set;}
        public List<Phone> phone {get;set;}
        public List<ElectronicCommunication> electronicCommunication {get;set;}
        public List<premiumDesignation> premiumDesignation {get;set;}
        public List<providerLocationAffiliations> providerLocationAffiliations;
        public List<qualityTier> qualityTiers{get;set;}
		public List<labType> labTypes{get;set;}
    }

    public class Specialty {
        public String primarySpecialtyIndicator {get;set;}
        public String typeCode {get;set;}
        public String typeDescription {get;set;}
    }
    public class role {
        public String code {get;set;}
        public String description {get;set;}
        Public string statusCode {get;set;}
    }

    public class Tpsm {
        public String code {get;set;}
        public String description {get;set;}
    }

    public class ProviderTIN {
        public String statusCode {get;set;}
        public String id {get;set;}
        public String typeCode {get;set;}
    }

    public class Phone {
        public String phoneTypeCode {get;set;}
        public String phoneCountryCode {get;set;}
        public String areaCode {get;set;}
        public String phoneNumber {get;set;}
        public String phoneExtensionNumber {get;set;}
        public String primaryPhoneIndicator {get;set;}
        public String statusCode {get;set;}
    }

    public class HealthcareProvider {
     public String name {get;set;}
     public String providerFirstName {get;set;}
     public String providerMiddleName {get;set;}
     public String providerNameSuffix {get;set;}
     public String providerGenderCode {get;set;}
     public String providerTypeCode {get;set;}
     public String providerBirthDate{get;set;}
    }

    public class Contract {
        public String businessSegmentCode {get;set;}
        public String contractStatusCode {get;set;}
        public List<String> networkIds{get;set;}
        public List<String> contractClaimTypes{get;set;}
    } 
   
    public class premiumDesignation {
        public String qualityTypeCode {get;set;}
        public String efficiencyTypeCode {get;set;} 
        public String qualityTypeDescription {get;set;} 
        public String efficiencyTypeDescription {get;set;}
       
    } 
    
   public class Key {
        public String providerId {get;set;}
    } 
 public class providerLocationAffiliations{
        public string id;
        public String statusCode;
    }
    public class ElectronicCommunication {
        public String communicationTypeCode {get;set;}
        public String message {get;set;}
    }
   
    public class findMedicalProvidersResponse {
        public List<MedicalProviders> medicalProviders {get;set;}
        public ACETOILPagination pagination {get;set;}
        public ACETOILError[] errors {get;set;}
    }
	
	public class labType {
        public String code {get;set;}
        public String description {get;set;}
        public String effectiveDate {get;set;}
        public String cancelDate {get;set;}
        public String statusCode {get;set;}
    }
}