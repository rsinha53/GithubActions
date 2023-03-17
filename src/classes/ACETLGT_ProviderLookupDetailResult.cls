public class ACETLGT_ProviderLookupDetailResult 
    {   @AuraEnabled
        public ACETProviderGeneralInfo generalInfo { get; set; }
		@AuraEnabled
        public List<ACETProviderSpeciality> specialities { get; set; }
		@AuraEnabled
        public List<ACETProviderUnitedPremium> unitedPremiums { get; set; }
		@AuraEnabled
        public List<ACETProviderAffiliation> affiliations { get; set; }
		@AuraEnabled
        public List<Degree> degrees { get; set; }
		@AuraEnabled
        public List<HoursOfOperation> hoursOfOperations { get; set; }
		@AuraEnabled
        public List<Language> languages { get; set; }
		@AuraEnabled
        public List<NPI> npis { get; set; }
		@AuraEnabled
        public list<providerLocationAffiliation> providerLocationAffiliations {get;set;}
        public ACETLGT_ProviderLookupDetailResult()
        {
            generalInfo  =  new ACETProviderGeneralInfo();
            specialities  =  new List<ACETProviderSpeciality>();
            unitedPremiums  =  new List<ACETProviderUnitedPremium>();
            affiliations  =  new List<ACETProviderAffiliation>();    
            degrees = new List<Degree>();
            hoursOfOperations = new List<HoursOfOperation>();
            languages = new List<Language>();
            npis = new List<NPI>();
            providerLocationAffiliations = new list<providerLocationAffiliation>();
        }
    
    public class providerLocationAffiliation{
	    @AuraEnabled
        public string id {get;set;}
    }
    
    public class ACETProviderGeneralInfo
    {   @AuraEnabled
        public String lastName { get; set; }
		@AuraEnabled
        public String firstName { get; set; }
		@AuraEnabled
        public String PFS { get; set; }
		@AuraEnabled
        public String taxId { get; set; }
		@AuraEnabled
        public String npi { get; set; }
		@AuraEnabled
        public String phone { get; set; }
		@AuraEnabled
        public String providerID { get; set; }
		@AuraEnabled
        public String primaryPhysician { get; set; }
		@AuraEnabled
        public String newPatients { get; set; }
		@AuraEnabled
        public String paytoIndividual { get; set; }
		@AuraEnabled
        public String platinumProvider { get; set; }
		@AuraEnabled
        public String medicareId { get; set; }
		@AuraEnabled
        public String medicaidId { get; set; }
		@AuraEnabled
        public String providerType { get; set; }
		@AuraEnabled
        public String providerTINOwner { get; set; }
		@AuraEnabled
        public String hcoTypeCode { get; set; }
		@AuraEnabled
        public String providerTINTypeCode { get; set; }
		@AuraEnabled
        public String providerGenderCode { get; set; }
		@AuraEnabled
        public String providerBirthDate { get; set; }
		@AuraEnabled
        public String patientAgeRange { get; set; }
		@AuraEnabled
        public string pcpObgnId {get;set;}
		
        
    }
    
    public class NPI
    {   @AuraEnabled
        public String npiName { get; set; }       
    }
     
    public class ACETProviderSpeciality
    {   @AuraEnabled
        public String primarySpeciality { get; set; }
		@AuraEnabled
        public String speciality { get; set; }
		@AuraEnabled
        public String boardCert { get; set; }
		@AuraEnabled
        public String cancelDate { get; set; }
		@AuraEnabled
        public String statusCode{get;set;}
		
    }
    public class Degree 
    {   @AuraEnabled
        public String code { get; set; }
		@AuraEnabled
        public String schoolName { get; set; }
    }
    
    public class HoursOfOperation
    {   @AuraEnabled
        public String weekCode { get; set; }
		@AuraEnabled
        public String startTime1 { get; set; }
		@AuraEnabled
        public String endTime1 { get; set; }
		@AuraEnabled
        public String startTime2 { get; set; }
		@AuraEnabled
        public String endTime2 { get; set; }
    }
    
    public class Language 
    {   @AuraEnabled
        public String languageStatusCode { get; set; }
		@AuraEnabled
        public String languageCode { get; set; }
		@AuraEnabled
        public String language { get; set; }
		@AuraEnabled
        public String languageSpokenByCode { get; set; }
		@AuraEnabled
        public String languageSpokenByDesc { get; set; }
		@AuraEnabled
        public String languageWrittenByCode { get; set; }
		@AuraEnabled
        public String languageWrittenByDesc { get; set; }
    }
    public class ACETProviderUnitedPremium
    {   @AuraEnabled
        public String premiumDesignation { get; set; }
		@AuraEnabled
        public String premiumSpeciality { get; set; }
		@AuraEnabled
        public String effectiveDate { get; set; }
		@AuraEnabled
        public String premiumCancelDate { get; set; }
		@AuraEnabled
        public String efficiencyTypeDescription { get; set; }
		@AuraEnabled
        public String qualityTypeDescription { get; set; }
    }
    public class ACETProviderAffiliation
    {   @AuraEnabled
        public string affiliation { get; set; }
		@AuraEnabled
        public string providerId { get; set; }
		@AuraEnabled
        public string effective { get; set; }
		@AuraEnabled
        public String PrimarySpeciality { get; set; }                
    }
}