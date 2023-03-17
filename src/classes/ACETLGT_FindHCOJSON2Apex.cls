public class ACETLGT_FindHCOJSON2Apex {

    public findMedicalHealthcareOrganizationsResponse findMedicalHealthcareOrganizationsResponse {get;set;} 
    public class findMedicalHealthcareOrganizationsResponse {
        public List<medicalHealthcareOrganizations> medicalHealthcareOrganizations {get;set;} 
        public ACETOILPagination pagination {get;set;}
        public ACETOILError[] errors { get; set; } 
    }
    public class medicalHealthcareOrganizations {
        public hco hco {get;set;} 
        public providerTIN providerTIN {get;set;} 
        public List<tpsm> tpsm {get;set;} 
        public contract[] contract {get;set;} 
        public List<specialty> specialty {get;set;} 
        public address address {get;set;} 
        public List<phone> phone {get;set;} 
        public List<electronicCommunication> electronicCommunication {get;set;} 
		public List<labType> labTypes {get;set;}
        public List<qualityTier> qualityTiers {get;set;}
    }
    public class hco {
        public String providerId {get;set;}     //504446116833373333
        public String providerName {get;set;}   //CROCEKTT-ADCOCK P & 0
    }
    public class providerTIN {
        public String id {get;set;}     //621719250
        public String typeCode {get;set;}   //TIN
    }
    public class tpsm {
        public String code {get;set;}   //
    } 
    public class contract {
        public String contractStatusCode {get;set;}    
        public String businessSegmentCode {get;set;} 
        public List<String> networkIds{get;set;}
        public List<String> contractClaimTypes{get;set;}  
    } 
    public class specialty {
        public String primarySpecialtyIndicator {get;set;}  //
        public String typeCode {get;set;}   //
        public String typeDescription {get;set;}    //
    }
    public class address {
        public String addressLine1 {get;set;}   //4450 WALKER BLVD
        public String addressLine2 {get;set;}   //
        public String city {get;set;}   //KNOXVILLE
        public String postalPrefixCode {get;set;}   //37917
        public List<String> benefitServiceAreas{get;set;}
        public String countyDescription {get;set;}  //
        public String stateCode {get;set;}  //TN
        public String addressId {get;set;}  //1461168403984
        public String typeCode {get;set;}   //BIL
        public String statusCode {get;set;}     //A
        public String primaryIndicator {get;set;}   //
        public String distance {get;set;}   //
    
    }
    public class phone {
        public String primaryPhoneIndicator {get;set;}  //
        public String phoneTypeCode {get;set;}  //TEL
        public String areaCode {get;set;}   //865
        public String phoneNumber {get;set;}    //6882626
    }
    public class electronicCommunication {
        public String message {get;set;}   
        public String communicationTypeCode {get;set;}
    }
	
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