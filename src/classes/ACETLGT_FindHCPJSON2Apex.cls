public class ACETLGT_FindHCPJSON2Apex {
    public findMedicalHealthcareProfessionalsResponse findMedicalHealthcareProfessionalsResponse {get;set;}
     public class findMedicalHealthcareProfessionalsResponse {
        public List<medicalHealthcareProfessionals> medicalHealthcareProfessionals {get;set;}
        public ACETOILPagination pagination {get;set;}
        public ACETOILError[] errors { get; set; }
    }
     public class medicalHealthcareProfessionals {
        public hcp hcp {get;set;}
        public List<role> role {get;set;}
        public providerTIN providerTIN {get;set;}
        public List<tpsm> tpsm {get;set;}
        public contract[] contract {get;set;}
        public List<specialty> specialty {get;set;}
        public address address {get;set;}
        public List<phone> phone {get;set;}
        public List<electronicCommunication> electronicCommunication {get;set;}
        public List<premiumDesignation> premiumDesignation {get;set;}
         public list<providerLocationAffiliations> providerLocationAffiliations;
         public List<qualityTier> qualityTiers{get;set;}
    }
  
    
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
    
        public String providerId {get;set;}   
        public String providerLastName {get;set;} 
        public String providerMiddleName {get;set;}
        public String providerNameSuffix {get;set;}
        public String providerFirstName {get;set;}    
        public String providerGenderCode {get;set;}   
    }
     public class role {    
        public String code {get;set;} 
        public String statusCode  {get;set;} 

    }
     public class providerTIN {    
        public String id {get;set;}   
        public String typeCode {get;set;} 
    }
     public class tpsm {  
     
        public String code {get;set;} 
        public String descr {get;set;} //Replaced desc with descr
    }

      public class contract {
        public String businessSegmentCode {get;set;}  
        public String contractStatusCode {get;set;}
        public List<String> networkIds{get;set;}
        public List<String> contractClaimTypes{get;set;}     
    } 
     public class specialty { 
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
        public String countyDescription {get;set;}
        public List<String> benefitServiceAreas{get;set;}     
        public String statusCode {get;set;}   
        public String typeCode {get;set;} 
        public String addressId {get;set;}    
        public String distance {get;set;}
    }
     public class phone { 
        public String primaryPhoneIndicator {get;set;}    
        public String phoneTypeCode {get;set;}    
        public String areaCode {get;set;} 
        public String phoneNumber {get;set;}  
    }
     public class electronicCommunication {
        public String message {get;set;}  
        public String communicationTypeCode {get;set;}    
    }
  
     public class premiumDesignation {
          public String qualityTypeCode {get;set;}  
          public String qualityTypeDescription {get;set;}  
          public String efficiencyTypeCode {get;set;}      
          public String efficiencyTypeDescription {get;set;}    
    }
    public static ACETLGT_FindHCPJSON2Apex parse(String json){
        return (ACETLGT_FindHCPJSON2Apex) System.JSON.deserialize(json, ACETLGT_FindHCPJSON2Apex.class);
    }
     }