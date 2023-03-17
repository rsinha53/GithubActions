public class ACETFindClaimJSON2Apex {
   public FindClaimsResponse findClaimsResponse {get;set;} 
   
   public class Pagination {
        public String pageNumber {get;set;} 
        public String pageSize {get;set;} 
        public String recordCount {get;set;} 
        public String totalCount {get;set;} 
    }
    
    public class Claims {
        public String claimID {get;set;} 
                public String sourceClaimId{get;set;}

        public String claimNetworkIndicator {get;set;} 
        public ClaimStatusCode claimStatusCode {get;set;} 
        public ClaimStatusCode claimEventTypeCode {get;set;} 
        public String claimType {get;set;} 
        public String claimSourceSystemCode {get;set;} 
        public String claimFirstDateofService {get;set;} 
        public String claimLastDateofService {get;set;} 
        public String claimReceivedDate {get;set;} 
        public String claimEventAdjudicationDateTime {get;set;} 
        public List<DiagnosisCode> diagnosisCode {get;set;} 
        public String claimTotalBilledChargeAmount {get;set;} 
        public String claimTotalDeductibleAmount {get;set;} 
        public String totalCopayAmount {get;set;} 
        public String totalNotCoveredAmount {get;set;} 
        public String totalPatientResponsibilityAmount {get;set;} 
        public String claimTotalAllowedAmount {get;set;} 
        public String patientAccountNumber {get;set;} 
        public Patient patient {get;set;} 
        public Subscriber subscriber {get;set;} 
        public List<Provider> provider {get;set;} 
        public String claimTotalPaidAmount {get;set;}
        public String privacyIndicator{get;set;} 
        public String claimEventStatus{get;set;} 
        public String claimEventStatusDescription{get;set;} 
        Public String claimEncounterIndicator{get;set;}
        public String claimEventStatusDate{get;set;} 
    }
    
    public class Subscriber {
        public Name name {get;set;} 
        public List<Identifiers> identifiers {get;set;} 
    }
    
    public class FindClaimsResponse {
        public List<Claims> claims {get;set;} 
        public Pagination pagination {get;set;} 
    }
    
    public class ClaimStatusCode {
        public String code {get;set;} 
        public String description {get;set;} 
    }
    
    public class DiagnosisCode {
        public String code {get;set;} 
        public String levelType {get;set;} 
    }
    
    public class Patient {
        public Name name {get;set;} 
        public List<Identifiers> identifiers {get;set;} 
        public String birthDate {get;set;} 
    }
    
    public class Identifiers {
        public String id {get;set;} 
        public String type_Z {get;set;} // in json: type
    }
    
    public class Name {
        public String firstName {get;set;}
        public String middleName {get;set;} 
        public String lastName {get;set;} 
    }
    
    public class Provider {
        public String providerType {get;set;} 
        public String providerID {get;set;} 
        public String providerNPI {get;set;} 
        public String organizationName {get;set;} 
        public string providerTIN{get;set;}
        public Name name {get;set;} 
    }
}