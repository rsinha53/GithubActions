public class ACETGetHCOJSON2Apex{
    public getMedicalHealthcareOrganizationResponse getMedicalHealthcareOrganizationResponse {get;set;}
    
     public class getMedicalHealthcareOrganizationResponse {
        public medicalHealthcareOrganization medicalHealthcareOrganization {get;set;}
    }
  /*  public class getMedicalHealthcareOrganizationResponseType {
        public medicalHealthcareOrganization medicalHealthcareOrganization {get;set;}
     //   public pagination pagination {get;set;}
    } */
    public class medicalHealthcareOrganization {
        
        public hco hco {get;set;}
        public providerTIN providerTIN {get;set;}
        public List<tpsm> tpsm {get;set;}
        public List<npi> npi {get;set;}
   //     public List<contract> contract {get;set;}
        public List<specialty> specialty {get;set;}
   //   public List<PremiumDesignation> premiumDesignation {get;set;} 
        public address address {get;set;}
        public List<PatientAgeLimit> patientAgeLimit {get;set;}  
         
    }
/*    public class key {
        public List<nameValue> nameValue {get;set;}
    }
    public class nameValue {
        public String name {get;set;} 
        public String value {get;set;}    
    }    */
    public class hco {
   //    public String providerStatusCode {get;set;}   
   //     public String providerStatusEffectiveDate {get;set;}  
   //     public String providerStatusCancelDate {get;set;} 
        public String providerId {get;set;}   
        public String providerName {get;set;} 
        public String hcoTypeCode {get;set;}  
    }
    public class providerTIN {
     //   public String statusCode {get;set;}   
    //    public String effectiveDate {get;set;}    
    //    public String cancelDate {get;set;}   
        public String id {get;set;} 
        public String owner {get;set;}  
   //    public String typeCode {get;set;} 
   //     public String paymentTypeCode {get;set;}
    }
    public class tpsm {
        public String statusCode {get;set;}   
        public String code {get;set;} 
        public String statusEffectiveDate {get;set;}  
        public String statusCancelDate {get;set;} 
    } 
    public class npi {
     //   public String npiStatusCode {get;set;}    
   //     public String effectiveDate {get;set;}    
   //     public String cancelDate {get;set;}   
        public String hcoNPI {get;set;}   
   //     public String validationDate {get;set;}   
    }
    public class specialty {
          public String statusCode {get;set;}   
     //   public String effectiveDate {get;set;}    
     ///   public String cancelDate {get;set;}   
        public String primarySpecialtyIndicator {get;set;}    
        public String typeCode {get;set;} 
        public String typeDescription {get;set;}  
    }
    
    
 /*    public class PremiumDesignation {
        //    public String statusCode {get;set;} 
        public String effectiveDate {get;set;} 
        public String cancelDate {get;set;} 
        public String diseaseGroupTypeCode {get;set;} 
        //     public String conditionFocusTypeCode {get;set;} 
        public String qualityTypeCode {get;set;} 
        public String qualityTypeDescription {get;set;} 
        //   public String efficiencyTypeCode {get;set;} 
        public String efficiencyTypeDescription {get;set;} 
        //     public String qualityEfficiencyPriority {get;set;} 
        //    public String level {get;set;} 
        
    }    */
    
   public class address {
        public String facilityType {get;set;} 
    }
  /*  public class contract {
        public String contractStatusCode {get;set;}   
        public String businessSegmentCode {get;set;} 
    }    
    public class phone {
        public String statusCode {get;set;}   
        public String primaryPhoneIndicator {get;set;}   
        public String phoneTypeCode {get;set;}    
        public String phoneCountryCode {get;set;} 
        public String areaCode {get;set;} 
        public String phoneNumber {get;set;}  
        public String phoneExtensionNumber {get;set;} 
    }
    public class electronicCommunication {
        public String statusCode {get;set;}   
        public String message {get;set;} 
        public String communicationTypeCode {get;set;}   
    }
    public class medicare {
        public String statusCode {get;set;}   
        public String medicareIdEffectiveDate {get;set;}  
        public String medicareIdCancelDate {get;set;} 
        public String medicareId {get;set;}   
    }
    public class medicaid {
        public String statusCode {get;set;}  
        public String medicaidIdEffectiveDate {get;set;}  
        public String medicaidIdCancelDate {get;set;} 
        public String medicaidId {get;set;}   
        public String medicaidIssuingStateProvinceCode {get;set;} 
    }
    public class language {
        public String languageSpokenByCode {get;set;} 
        public String languageSpokenByDescription {get;set;}  
        public String languageWrittenByCode {get;set;}    
        public String languageWrittenByDescription {get;set;} 
        public String languageStatusCode {get;set;}   
        public String languageCode {get;set;} 
        public String language {get;set;} 
    }
    public class hoursOfOperation {
        public String weekCode {get;set;} 
        public String startTime1 {get;set;}  
        public String endTime1 {get;set;}
    }
    public class pagination {
        public String pageNumber {get;set;}   
        public String pageSize {get;set;} 
        public String recordCount {get;set;}  
        public String totalCount {get;set;}   
        public String totalPages {get;set;}   
    }    */
    public class PatientAgeLimit {
        public String beginAgeNumber {get;set;} 
        public String endAgeNumber {get;set;} 
        
    }
}