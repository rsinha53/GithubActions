public class ACETLGT_ProviderLookupResult {
           @Auraenabled public string fullName {  get; set; }
           @Auraenabled public string networkSchedule { get; set; }
           @Auraenabled public string languageSchedule { get; set; }
           @Auraenabled public string providerId { get; set; }
           @Auraenabled public string providerType { get; set; }
           @Auraenabled public string status { get; set; }
           @Auraenabled public string taxId { get; set; }
           @Auraenabled public string ssn { get; set; }
           @Auraenabled public string address { get; set; }
           @Auraenabled public string SelSpecialityCodes { get; set; }
           @Auraenabled public string NPI { get; set; }  
           @Auraenabled public string street { get; set; }
           @Auraenabled public string city { get; set; }
           @Auraenabled public string state { get; set; }
           @Auraenabled public string zipCode { get; set; }
           @Auraenabled public string providerTypeCode { get; set; }   
           @Auraenabled public string phoneNumber { get; set; }
           @Auraenabled public string speciality { get; set; }
           @Auraenabled public string PCPRole { get; set; }
           @Auraenabled public string gender { get; set; }
           @Auraenabled public string network { get; set; }
           @Auraenabled public string affiliation { get; set; }
           @Auraenabled public string uphd { get; set; }
           @Auraenabled public string radious { get; set; }
           @Auraenabled public string acceptNewPatient { get; set; }
           @Auraenabled public string Platinum { get; set; }
           @Auraenabled public string radius { get; set; }
           @Auraenabled public string ProviderName { get; set; }
           @Auraenabled public string typeDescription { get; set; }
           @Auraenabled public string phone { get; set; }
           @Auraenabled public string Code { get; set; }
           @Auraenabled public String providerTINTypeCode { get; set; }
           @Auraenabled public String providerTINStatusCode { get; set; }  
           @Auraenabled public String addressId { get; set; }
           @Auraenabled public String addressTypeCode { get; set; } 
           @Auraenabled public String benefitPlanId { get; set; }
           @Auraenabled public String County { get; set; } 
           @Auraenabled public String Fax { get; set; }
           @Auraenabled public String Email { get; set; }
           @Auraenabled public String OperationHours { get; set; }
           @Auraenabled public String PatientAgeRange { get; set; }
           @Auraenabled public String owner { get; set; }  
           @Auraenabled public String hcoTypeCode { get; set; }
           @Auraenabled public String addressLine1 { get; set; }
           @Auraenabled public String addressLine2 { get; set; }
           @Auraenabled public String firstName { get; set; }
           @Auraenabled public String lastName { get; set; }
           @Auraenabled public String middleName { get; set; }
           @Auraenabled public String suffix { get; set; }
           @Auraenabled public string networkId {get;set;}
           @Auraenabled public string cliamType {get;set;}
           @Auraenabled public string pcpObgnID {get;set;}
           @Auraenabled public String providerLocationAffiliationsStatusCode {get;set;}
           @Auraenabled  public String addressStatusCode { get; set; }
           @Auraenabled public String postalPrefixCode { get; set; }
           @Auraenabled public String postalSuffixCode { get; set; }
           @Auraenabled public String addressCountyDesc { get; set; }
           @Auraenabled public String qualityBenefitTier { get; set; }
		   @Auraenabled public String labTypeCode { get; set; }
    		@Auraenabled public String labTypeDesc { get; set; }
    		@Auraenabled public String tierValue { get; set; }
			@Auraenabled public List<labType> labTypes{get;set;}											  
		   public ACETLGT_ProviderLookupResult(ACETLGT_ProviderLookupResult providerLookupResult) {
            this.fullName = providerLookupResult.fullName;
            this.providerId = providerLookupResult.providerId;
            this.providerType = providerLookupResult.providerType;
            this.taxId = providerLookupResult.taxId;
            this.address = providerLookupResult.address;     
            this.providerTypeCode = providerLookupResult.providerTypeCode;  
            this.phoneNumber= providerLookupResult.phoneNumber;
            this.speciality = providerLookupResult.speciality;
            this.PCPRole = providerLookupResult.PCPRole;
            this.gender = providerLookupResult.gender;   
            this.uphd = providerLookupResult.uphd;
            this.radious = providerLookupResult.radious;
            this.acceptNewPatient = providerLookupResult.acceptNewPatient;
            this.Platinum = providerLookupResult.Platinum;
            this.providerTINTypeCode = providerLookupResult.providerTINTypeCode;
            this.addressId = providerLookupResult.addressId;
            this.addressTypeCode = providerLookupResult.addressTypeCode;
            this.pcpObgnID = providerLookupResult.pcpObgnID;
            this.providerLocationAffiliationsStatusCode = providerLookupResult.providerLocationAffiliationsStatusCode;
            this.qualityBenefitTier = qualityBenefitTier;
        }
        public ACETLGT_ProviderLookupResult() {
        
    }
	public class labType {
        @Auraenabled public String code {get;set;}
        @Auraenabled public String description {get;set;}
    }				  
}