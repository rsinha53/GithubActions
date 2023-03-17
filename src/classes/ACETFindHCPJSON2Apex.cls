public class ACETFindHCPJSON2Apex{
    public findMedicalHealthcareProfessionalsResponse findMedicalHealthcareProfessionalsResponse {get;set;}
     public class findMedicalHealthcareProfessionalsResponse {
        public List<medicalHealthcareProfessionals> medicalHealthcareProfessionals {get;set;}
        public ACETOILPagination pagination {get;set;}
        public ACETOILError[] errors { get; set; }
    }
     public class medicalHealthcareProfessionals {
      //  public key key {get;set;}
        public hcp hcp {get;set;}
        public List<role> role {get;set;}
        public providerTIN providerTIN {get;set;}
        public List<tpsm> tpsm {get;set;}
    //    public List<npi> npi {get;set;}
          public contract[] contract {get;set;}
        public List<specialty> specialty {get;set;}
        public address address {get;set;}
        public List<phone> phone {get;set;}
        public List<electronicCommunication> electronicCommunication {get;set;}
    //    public List<medicare> medicare {get;set;}
    //    public List<medicaid> medicaid {get;set;}
        public List<premiumDesignation> premiumDesignation {get;set;}
         public list<providerLocationAffiliations> providerLocationAffiliations;
         public List<qualityTier> qualityTiers{get;set;}
     //   public List<degree> degree {get;set;}
    }
   /* public class key {
        public List<nameValue> nameValue {get;set;}
    } 
     public class nameValue {
        public String name {get;set;} 
        public String value {get;set;}    
    } */
    
    public class providerLocationAffiliations{
        public string id;
        public String statusCode;
    }
    public class qualityTier{
        public string networkId{get;set;} 
        public string ruleId{get;set;} 
        public string level{get;set;} 
        public string reasonCode{get;set;} 
        public string directoryDisplayIndicator{get;set;} 
    }
     public class hcp {
     //   public String providerStatusCode {get;set;}   
     //   public String providerStatusEffectiveDate {get;set;}  
     //   public String providerStatusCancelDate {get;set;} 
        public String providerId {get;set;}   
        public String providerLastName {get;set;} 
        public String providerMiddleName {get;set;}
        public String providerNameSuffix {get;set;}
        public String providerFirstName {get;set;}    
        public String providerGenderCode {get;set;}   
    }
     public class role {
         public String statusCode {get;set;}   
      //  public String effectiveDate {get;set;}    
      //  public String cancelDate {get;set;}   
        public String code {get;set;} 
   //     public String description {get;set;}  
    }
     public class providerTIN {
      //  public String statusCode {get;set;}   
      //  public String effectiveDate {get;set;}    
      //  public String cancelDate {get;set;}   
        public String id {get;set;}   
        public String typeCode {get;set;} 
     //   public String owner {get;set;} 
    }
     public class tpsm {
      //  public String statusCode {get;set;}   
      //   public String statusEffectiveDate {get;set;}  
      //  public String statusCancelDate {get;set;} 
        public String code {get;set;} 
        public String descr {get;set;} //Replaced desc with descr
    }
/*     public class npi {
      //  public String statusCode {get;set;}   
      //  public String effectiveDate {get;set;}    
      //  public String cancelDate {get;set;}   
        public String id {get;set;}   
      //  public String validationDate {get;set;}   
    }   */
      public class contract {
        public String businessSegmentCode {get;set;}  
        public String contractStatusCode {get;set;}
        public List<String> networkIds{get;set;}
        public List<String> contractClaimTypes{get;set;}     
    } 
     public class specialty {
     //   public String statusCode {get;set;}   
     //   public String effectiveDate {get;set;}    
     //   public String cancelDate {get;set;}   
        public String primarySpecialtyIndicator {get;set;}   
        public String typeCode {get;set;} 
        public String typeDescription {get;set;}  
    }
     public class address {
        public String addressLine1 {get;set;} 
        public String addressLine2 {get;set;} 
        public String city {get;set;} 
        public String stateCode {get;set;}    
        public String postalPrefixCode {get;set;} 
    //  public String postalSuffixCode {get;set;} 
     // public String countyCode {get;set;}   
        public String countyDescription {get;set;}
        public List<String> benefitServiceAreas{get;set;}    
    /*   public String countryCode {get;set;} 
         public String countryDescription {get;set;}   
         public String latitude {get;set;} 
         public String longitude {get;set;} */   
         public String statusCode {get;set;}   
   /*    public String effectiveDate {get;set;}    
         public String cancelDate {get;set;}   */
         public String typeCode {get;set;} 
         public String addressId {get;set;}    
      //   public String primaryIndicator {get;set;} 
         public String distance {get;set;}
    //    public String handicapAccessibleIndicator {get;set;}  
    }
     public class phone {
    //    public String statusCode {get;set;}   
        public String primaryPhoneIndicator {get;set;}    
        public String phoneTypeCode {get;set;}    
    //    public String phoneCountryCode {get;set;} 
        public String areaCode {get;set;} 
        public String phoneNumber {get;set;}  
      //  public String phoneExtensionNumber {get;set;} 
    }
     public class electronicCommunication {
     //   public String statusCode {get;set;}   
        public String message {get;set;}  
        public String communicationTypeCode {get;set;}    
    }
  /*   public class medicare {
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
        public String issuingStateProvinceCode {get;set;} 
    } */
     public class premiumDesignation {
      /*  public String statusCode {get;set;}   
          public String conditionFocusTypeCode {get;set;}   
          public String qualityEfficiencyPriority {get;set;}    
          public String diseaseGroupTypeCode {get;set;} */
          public String qualityTypeCode {get;set;}  
          public String qualityTypeDescription {get;set;}   
       // public String effectiveDate {get;set;}    
       // public String cancelDate {get;set;}   
          public String efficiencyTypeCode {get;set;}   
          public String efficiencyTypeDescription {get;set;}    
    }
 /*    public class degree {
        public String statusCode {get;set;}   
        public String primaryIndicator {get;set;} 
        public String code {get;set;} 
        public String schoolName {get;set;}   
        public String completionDate {get;set;}   
    } */
    
    public static ACETFindHCPJSON2Apex parse(String json){
        return (ACETFindHCPJSON2Apex) System.JSON.deserialize(json, ACETFindHCPJSON2Apex.class);
    }
}