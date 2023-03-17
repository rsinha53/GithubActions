public class ACETFindHCOJSON2Apex{
    public findMedicalHealthcareOrganizationsResponse findMedicalHealthcareOrganizationsResponse {get;set;} 
    public class findMedicalHealthcareOrganizationsResponse {
        public List<medicalHealthcareOrganizations> medicalHealthcareOrganizations {get;set;} 
        public ACETOILPagination pagination {get;set;}
        public ACETOILError[] errors { get; set; } 
    }
    public class medicalHealthcareOrganizations {
    //  public key key {get;set;} 
        public hco hco {get;set;} 
        public providerTIN providerTIN {get;set;} 
        public List<tpsm> tpsm {get;set;} 
    //  public List<npi> npi {get;set;} 
        public contract[] contract {get;set;} 
        public List<specialty> specialty {get;set;} 
        public address address {get;set;} 
    //  public List<premiumDesignation> premiumDesignation {get;set;}
        public List<phone> phone {get;set;} 
        public List<electronicCommunication> electronicCommunication {get;set;} 
        //public List<medicare> medicare {get;set;} 
        //public List<medicaid> medicaid {get;set;} 
		public List<labType> labTypes {get;set;}
        public List<qualityTier> qualityTiers {get;set;}
    }
// Key Class for NAme value
/*  public class key {
        public List<nameValue> nameValue {get;set;} 
    }
    public class nameValue {
        public String name {get;set;}   //providerId
        public String value {get;set;}  //504446116833373333
    } */
    public class hco {
        public String providerId {get;set;}     //504446116833373333
        public String providerName {get;set;}   //CROCEKTT-ADCOCK P & 0
    //  public String providerStatusCode {get;set;}     //A
    //  public String providerStatusEffectiveDate {get;set;}    //1993-01-04
    //  public String providerStatusCancelDate {get;set;}   //9999-12-31
    //  public String hcoTypeCode {get;set;}    //HCF
    }
    public class providerTIN {
    //  public String statusCode {get;set;}     //A
    //  public String effectiveDate {get;set;}  //0001-01-01
    //  public String cancelDate {get;set;}     //9999-12-31
        public String id {get;set;}     //621719250
        public String typeCode {get;set;}   //TIN
    }
    public class tpsm {
    //  public String statusCode {get;set;}     //I
    //  public String statusEffectiveDate {get;set;}    //0001-01-01
    //  public String statusCancelDate {get;set;}   //0001-01-01
        public String code {get;set;}   //
    //  public String description {get;set;}    //
    }
/*  public class npi {
        public String npiStatusCode {get;set;}  //I
        public String effectiveDate {get;set;}  //0001-01-01
        public String cancelDate {get;set;}     //0001-01-01
        public String id {get;set;}     //
        public String validationDate {get;set;}     //0001-01-01
    } */
    
    public class contract {
        public String contractStatusCode {get;set;}    
        public String businessSegmentCode {get;set;} 
        public List<String> networkIds{get;set;}
        public List<String> contractClaimTypes{get;set;}  
    } 
    public class specialty {
    //  public String statusCode {get;set;}     //I
    //  public String effectiveDate {get;set;}  //0001-01-01
    //  public String cancelDate {get;set;}     //0001-01-01
        public String primarySpecialtyIndicator {get;set;}  //
        public String typeCode {get;set;}   //
        public String typeDescription {get;set;}    //
    }
    public class address {
        public String addressLine1 {get;set;}   //4450 WALKER BLVD
        public String addressLine2 {get;set;}   //
        public String city {get;set;}   //KNOXVILLE
    //  public String latitude {get;set;}   //0.0
    //  public String longitude {get;set;}  //0.0
        public String postalPrefixCode {get;set;}   //37917
    //  public String postalSuffixCode {get;set;}   //1547
    //  public String countryCode {get;set;}    //US
    //  public String countryDescription {get;set;}     //
        public List<String> benefitServiceAreas{get;set;}
    //  public String countyCode {get;set;}     //US
        public String countyDescription {get;set;}  //
        public String stateCode {get;set;}  //TN
        public String addressId {get;set;}  //1461168403984
        public String typeCode {get;set;}   //BIL
    //  public String effectiveDate {get;set;}  //1998-06-05
    //  public String cancelDate {get;set;}     //9999-12-31
        public String statusCode {get;set;}     //A
        public String primaryIndicator {get;set;}   //
        public String distance {get;set;}   //
    //  public String handicapAccessibleIndicator {get;set;}    //
    }
    
/*   public class premiumDesignation {
         public String statusCode {get;set;}   
          public String conditionFocusTypeCode {get;set;}   
          public String qualityEfficiencyPriority {get;set;}    
          public String diseaseGroupTypeCode {get;set;} 
          public String qualityTypeCode {get;set;}  
          public String qualityTypeDescription {get;set;}   
       // public String effectiveDate {get;set;}    
       // public String cancelDate {get;set;}   
       //   public String efficiencyTypeCode {get;set;}   
          public String efficiencyTypeDescription {get;set;}    
    } */
    
    public class phone {
    //  public String statusCode {get;set;}     //
        public String primaryPhoneIndicator {get;set;}  //
        public String phoneTypeCode {get;set;}  //TEL
    //  public String phoneCountryCode {get;set;}   //1
        public String areaCode {get;set;}   //865
        public String phoneNumber {get;set;}    //6882626
    //  public String phoneExtensionNumber {get;set;}   //
    }
    public class electronicCommunication {
    //  public String statusCode {get;set;}     //
        public String message {get;set;}   
        public String communicationTypeCode {get;set;}
    }
/*  public class medicare {
        public String statusCode {get;set;}     //I
        public String medicareIdEffectiveDate {get;set;}    //0001-01-01
        public String medicareIdCancelDate {get;set;}   //0001-01-01
        public String medicareId {get;set;}     //
    }
    public class medicaid {
        public String statusCode {get;set;}     //I
        public String medicaidIdEffectiveDate {get;set;}    //0001-01-01
        public String medicaidIdCancelDate {get;set;}   //0001-01-01
        public String medicaidId {get;set;}     //
        public String issuingStateProvinceCode {get;set;}   //
    } */
	
	   public class labType {
        public String code {get;set;}
        public String description {get;set;}
        public String effectiveDate {get;set;}
        public String cancelDate {get;set;}
        public String statusCode {get;set;}
    }
    
    public class qualityTier{
        public String level {get;set;}
    }
}