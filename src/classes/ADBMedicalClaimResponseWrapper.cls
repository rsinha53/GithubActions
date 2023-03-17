public without sharing class ADBMedicalClaimResponseWrapper {
    
    @AuraEnabled public SearchResult searchResult;
    public class SearchResult{ 
        @AuraEnabled public SearchOutput searchOutput;
        @AuraEnabled public List<Errors> errors;
    }
    public class SearchOutput{ 
        @AuraEnabled public List<Claims> claims;
    }
    public class Claims {
        @AuraEnabled public String firstServiceDate;
        @AuraEnabled public String lastServiceDate;
        @AuraEnabled public String providerTier;
        @AuraEnabled public String providerName;
        @AuraEnabled public String providerSpecialty;  
        @AuraEnabled public String totalPatientResponsibility; 
        @AuraEnabled public String claimType;
        @AuraEnabled public String providerTaxId;
        @AuraEnabled public String providerTaxIdPrefix;
        @AuraEnabled public String providerTaxIdSuffix;
        @AuraEnabled public String auditControlNumber;
        @AuraEnabled public String auditControlNumberSuffixCode;
        @AuraEnabled public String formattedAuditControlNumber;
        @AuraEnabled public String totalCharged;
        @AuraEnabled public String processedDate;
		@AuraEnabled public String claimStatus;									   
    }
    public class Errors {
        @AuraEnabled public String code;
        @AuraEnabled public String name;
        @AuraEnabled public String description;
    }
    public static ADBMedicalClaimResponseWrapper parse(String json) {
        return (ADBMedicalClaimResponseWrapper) System.JSON.deserialize(json, ADBMedicalClaimResponseWrapper.class);
    }
}