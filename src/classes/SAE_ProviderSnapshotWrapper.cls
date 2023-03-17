// Wrapper class needed for Provider Snapshot
// Sanka Dharmasena - 11.09.2019
// US1816890
public class SAE_ProviderSnapshotWrapper 
{
    public class ProviderCardWrapper
    {
        @AuraEnabled public String ProviderName{get;set;}
        @AuraEnabled public String TaxId{get;set;}
        @AuraEnabled public String NPI{get;set;}
        @AuraEnabled public String ProviderId{get;set;}
        @AuraEnabled public String MedicareProviderId{get;set;}
        @AuraEnabled public List<String> DeaDabp{get;set;}
        @AuraEnabled public List<String> MedicareId{get;set;}
        @AuraEnabled public String MedicalGroup{get;set;}
        @AuraEnabled public String Address{get;set;}
        @AuraEnabled public String PhoneNumber{get;set;}
        //US2784325 - TECH: Case Details - Caller ANI/Provider Add'l Elements Mapped to ORS - Durga
        @AuraEnabled public String EffectivePhoneNumber{get;set;}
        @AuraEnabled public string AddressCity{get;set;}
        // US1958736 - Thanish - 11th Feb 2020
        @AuraEnabled public List<String> PatientRange{get;set;}
        @AuraEnabled public String TPSMLevel{get;set;}
        //Added By Vinay
        @AuraEnabled public String pti{get;set;}
        @AuraEnabled public String EPS{get;set;}
        @AuraEnabled public String epsDate{get;set;}

        //US1816853 - Sanka
        @AuraEnabled public String PremiumDesignation{get;set;}
        @AuraEnabled public String PremiumSpeciality{get;set;}
        @AuraEnabled public String EffectiveDate{get;set;}
        @AuraEnabled public String CancelDate{get;set;}
    }
	
	public class Dea {
		public String deaNumber;
	}
    public class MedicareId {
		public String medicareId;
	}
  
    
    public class SpecialityCardWrapper
    {
        @AuraEnabled public String Speciality{get;set;}
        @AuraEnabled public String IsPrimary{get;set;}

        //US1816853 - Sanka
        @AuraEnabled public String BoardCertification{get;set;}
        @AuraEnabled public String CancelDate{get;set;}
    }

    //US1816853 - Sanka
    public class AdditionalDetailCard
    {
        @AuraEnabled public String Language{get;set;}
        @AuraEnabled public String PCPRole{get;set;}
        @AuraEnabled public String TPSMLevel{get;set;}
        @AuraEnabled public String Gender{get;set;}
         @AuraEnabled public List<String> MedicareId{get;set;}
        @AuraEnabled public List<String> DeaDabp{get;set;}

        // US2409557 - Sanka - 21.07.2020
        @AuraEnabled public String pti{get;set;}
        @AuraEnabled public String EPS{get;set;}
        @AuraEnabled public String epsDate{get;set;}
    }

    //US1816853 - Sanka
    public class CredentialCard
    {
        @AuraEnabled public String Qualification{get;set;}
        @AuraEnabled public String SchoolName{get;set;}
        @AuraEnabled public String Residency{get;set;}
    }

    public class AdditionalAddressWrapper
    {
        @AuraEnabled public String AddressType{get;set;}
        @AuraEnabled public String IsFreeStandingFacility{get;set;}
        @AuraEnabled public String Address{get;set;}
        @AuraEnabled public String Country{get;set;}
        @AuraEnabled public String PhoneNumber{get;set;}
        @AuraEnabled public String FAXNumber{get;set;}
        @AuraEnabled public String Email{get;set;}
        
        //US206884
        @AuraEnabled public String ActiveClass{get;set;}
        @AuraEnabled public String ActiveStatus{get;set;}
    }

    public class AdditionalAddressCard
    {
        @AuraEnabled public List<SAE_ProviderSnapshotWrapper.AdditionalAddressWrapper> AdditionalAdresses{get;set;}
        //Pagination
        @AuraEnabled public Integer prevOffsetBottom{get;set;}
        @AuraEnabled public Integer currOffsetBottom{get;set;}
        @AuraEnabled public Integer nextOffsetBottom{get;set;}
        @AuraEnabled public Integer totalRecordCount{get;set;}
        @AuraEnabled public Integer recordsInCurrentPage{get;set;}
    }

    public class ActiveAffWrapper
    {
        @AuraEnabled public String Name{get;set;}
        @AuraEnabled public String ProviderId{get;set;}
        @AuraEnabled public String EffectiveDate{get;set;}

        // US2138174 - Sanka
        @AuraEnabled public String AffiliationType{get;set;}
        @AuraEnabled public String AdmittingPriv{get;set;}
    }

    public class ReturnResponse
    {
        @AuraEnabled public Boolean isSuccess{get;set;}
        @AuraEnabled public Integer StatusCode{get;set;}
        @AuraEnabled public String StatusMessage{get;set;}
        @AuraEnabled public SAE_ProviderSnapshotWrapper.ProviderCardWrapper ProviderCardDetails{get;set;}
        @AuraEnabled public List<SAE_ProviderSnapshotWrapper.SpecialityCardWrapper> SpecialityRecords{get;set;}
        @AuraEnabled public List<SAE_ProviderSnapshotWrapper.AdditionalAddressWrapper> AdditionalAdresses{get;set;}
        @AuraEnabled public List<SAE_ProviderSnapshotWrapper.ActiveAffWrapper> ActiveAffs{get;set;}

        //US1816853 - Sanka
        @AuraEnabled public List<SAE_ProviderSnapshotWrapper.CredentialCard> Credentials{get;set;}
        @AuraEnabled public SAE_ProviderSnapshotWrapper.AdditionalDetailCard AdditionalDetails{get;set;}
        @AuraEnabled public SAE_ProviderSnapshotWrapper.AdditionalAddressCard AdditionalAddresses{get;set;}
    }
}