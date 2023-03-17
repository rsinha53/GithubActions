public class ACETGetHCPAdapterJSON2Apex {
    
    public getMedicalHealthcareProfessionalResponse getMedicalHealthcareProfessionalResponse {get;set;} 
    
    public class getMedicalHealthcareProfessionalResponse {
        public MedicalHealthcareProfessional MedicalHealthcareProfessional {get;set;} 
        
    }
    
  /*  public class getMedicalHealthcareProfessionalResponseType {
        public MedicalHealthcareProfessional medicalHealthcareProfessional {get;set;} 
        
    } */
    
    public class MedicalHealthcareProfessional {
        //     public Key key {get;set;} 
        public Hcp hcp {get;set;} 
        //    public List<Role> role {get;set;} 
        public ProviderTIN providerTIN {get;set;} 
        public List<Tpsm> tpsm {get;set;} 
        public List<Npi> npi {get;set;} 
        //   public List<Contract> contract {get;set;} 
        public List<Specialty> specialty {get;set;} 
        //   public Address address {get;set;} 
        //    public List<Phone> phone {get;set;} 
        //    public List<ElectronicCommunication> electronicCommunication {get;set;} 
        //     public List<Medicare> medicare {get;set;} 
        //     public List<Medicaid> medicaid {get;set;} 
        public List<PremiumDesignation> premiumDesignation {get;set;} 
        public List<Language> language {get;set;} 
        public List<HoursOfOperation> hoursOfOperation {get;set;} 
        //   public List<AreaOfExpertise> areaOfExpertise {get;set;} 
        //   public List<Role> recognitionProgram {get;set;} 
        public List<Degree> degree {get;set;} 
        //   public List<License> license {get;set;} 
        public List<PatientAgeLimit> patientAgeLimit {get;set;} 
        public list<providerLocationAffiliations> providerLocationAffiliations;
        
    }   
    
    public class providerLocationAffiliations{
        public string id {get;set;}
    }
    
    /*   public class Key {
public List<NameValue> nameValue {get;set;} 

}   

public class NameValue {
public String name {get;set;} 
public String value {get;set;} 

} */
    
    public class Hcp {
        // public String providerStatusCode {get;set;} 
        //   public String providerStatusEffectiveDate {get;set;} 
        //    public String providerStatusCancelDate {get;set;} 
        public String providerId {get;set;} 
        public String providerLastName {get;set;} 
        public String providerFirstName {get;set;} 
        public String providerMiddleName {get;set;} 
        public String providerNameSuffix {get;set;} 
        public String providerBirthDate {get;set;} 
        public String providerGenderCode {get;set;} 
        
    }
    /*   public class Role {
public String statusCode {get;set;} 
public String effectiveDate {get;set;} 
public String cancelDate {get;set;} 
public String code {get;set;} 
public String description {get;set;} 

} */
    
    public class ProviderTIN {
        // public String statusCode {get;set;} 
        //  public String effectiveDate {get;set;} 
        //  public String cancelDate {get;set;} 
        public String id {get;set;} 
        public String typeCode {get;set;} 
        public String owner {get;set;}
        
    }   
    
      public class Tpsm {
          public String statusCode {get;set;} 
          public String statusEffectiveDate {get;set;} 
          public String statusCancelDate {get;set;} 
          public String code {get;set;} 
          public String desc_Z {get;set;} // in json: desc

}    
    
    public class Npi {
        // public String statusCode {get;set;} 
        //  public String effectiveDate {get;set;} 
        //  public String cancelDate {get;set;} 
        public String id {get;set;} 
        //  public String validationDate {get;set;} 
        
    }   
    
    /*  public class Contract {
public String businessSegmentCode {get;set;} 
public String contractStatusCode {get;set;} 

}   */
    
    
    public class Specialty {
        public String statusCode {get;set;} 
        //   public String effectiveDate {get;set;} 
        
        public String primarySpecialtyIndicator {get;set;} 
        public String typeDescription {get;set;} 
        public String cancelDate {get;set;} 
        public String typeCode {get;set;} 
        public BoardCertification boardCertification {get;set;}              
    } 
    
    public class BoardCertification {
        public String boardCertificationCode;
        //   public String boardCertificationDesc;
        //    public String boardCertificationStatus;
        //    public String boardCertificationEffectiveDate;
        public String boardCertificationCancelDate;
        
    }  
    
    /*   public class Address {
public String addressLine1 {get;set;} 
public String addressLine2 {get;set;} 
public String city {get;set;} 
public String latitude {get;set;} 
public String longitude {get;set;} 
public String postalPrefixCode {get;set;} 
public String postalSuffixCode {get;set;} 
public String countryCode {get;set;} 
public String countryDescription {get;set;} 
public String countyCode {get;set;} 
public String countyDescription {get;set;} 
public String stateCode {get;set;} 
public String addressId {get;set;} 
public String typeCode {get;set;} 
public String effectiveDate {get;set;} 
public String cancelDate {get;set;} 
public String statusCode {get;set;} 
public String primaryIndicator {get;set;} 
public String handicapAccessibleIndicator {get;set;} 

}   */
    
    /*   public class Phone {
public String phoneTypeCode {get;set;} 
public String phoneCountryCode {get;set;} 
public String areaCode {get;set;} 
public String phoneNumber {get;set;} 
public String phoneExtensionNumber {get;set;} 
public String primaryPhoneIndicator {get;set;} 
public String statusCode {get;set;} 

} 

public class ElectronicCommunication {
public String statusCode {get;set;} 
public String message {get;set;} 
public String communicationTypeCode {get;set;} 

} */
    
    /*   public class Medicare {
public String statusCode {get;set;} 
public String medicareIdEffectiveDate {get;set;} 
public String medicareIdCancelDate {get;set;} 
public String medicareId {get;set;} 

}   

public class Medicaid {
public String statusCode {get;set;} 
public String medicaidIdEffectiveDate {get;set;} 
public String medicaidIdCancelDate {get;set;} 
public String medicaidId {get;set;} 
public String issuingStateProvinceCode {get;set;} 

} */
    
    public class PremiumDesignation {
        //    public String statusCode {get;set;} 
        public String effectiveDate {get;set;} 
        public String cancelDate {get;set;} 
        public String diseaseGroupTypeCode {get;set;} 
        //     public String conditionFocusTypeCode {get;set;} 
        public String qualityTypeCode {get;set;} 
        public String qualityTypeDescription {get;set;} 
        public String efficiencyTypeCode {get;set;} 
        public String efficiencyTypeDescription {get;set;} 
        //     public String qualityEfficiencyPriority {get;set;} 
        //    public String level {get;set;} 
        
    }   
    
    public class Language {
        //    public String languageStatusCode {get;set;} 
        public String languageCode {get;set;} 
        public String language {get;set;} 
        //  public String languageSpokenByCode {get;set;} 
           public String languageSpokenByDesc {get;set;} 
        //    public String languageWrittenByCode {get;set;} 
        //    public String languageWrittenByDesc {get;set;} 
        
    }
    
    public class HoursOfOperation {
        public String weekCode {get;set;} 
        public String startTime1 {get;set;} 
        public String endTime1 {get;set;} 
        public String startTime2 {get;set;} 
        public String endTime2 {get;set;} 
        
    }
    
    /*   public class AreaOfExpertise {
public String statusCode {get;set;} 
public String classificationTypeCode {get;set;} 
public String typeCode {get;set;} 

}  
public class License {
public String statusCode {get;set;} 
public String effectiveDate {get;set;} 
public String cancelDate {get;set;} 
public String id {get;set;} 
public String stateCode {get;set;} 
public String typeCode {get;set;} 

} */ 
    
    public class Degree {
        //   public String statusCode {get;set;} 
        //   public String primaryIndicator {get;set;} 
        public String code {get;set;} 
        public String schoolName {get;set;} 
        //   public String completionDate {get;set;} 
        
    }   
    
    public class PatientAgeLimit {
        //  public String statusCode {get;set;} 
        //  public String noteCode1 {get;set;} 
        //  public String noteCode2 {get;set;} 
        public String beginAgeNumber {get;set;} 
        public String endAgeNumber {get;set;} 
        
    }
}