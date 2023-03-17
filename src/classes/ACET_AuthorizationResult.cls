public class ACET_AuthorizationResult {

    @AuraEnabled public List<InPatientSummary> InPatientSummaries {get;set;}
    @AuraEnabled public List<OutPatientSummary> OutPatientSummaries {get;set;}
    @AuraEnabled public List<OutPatientFacilitySummary> OutPatientFacilitySummaries {get;set;}
    
    public class InPatientSummary {
        @AuraEnabled public String ServiceReferenceNumber {get;set;}
        @AuraEnabled public String ActualAdmitDateTime {get;set;}
        @AuraEnabled public String ActualDischargeDateTime {get;set;}
        @AuraEnabled public String PrimaryDiagnosisCode {get;set;}
        @AuraEnabled public String PrimaryDiagnosisCodeDescription {get;set;}
        @AuraEnabled public String ProviderFirstName {get;set;}
        @AuraEnabled public String ProviderLastName {get;set;}
        @AuraEnabled public String ProviderOrganizationName {get;set;}
        @AuraEnabled public String ProviderNetworkStatusTypeCode {get;set;}
        @AuraEnabled public String ProviderNetworkStatusTypeDescription {get;set;}
        @AuraEnabled public String ServiceSettingTypeCode {get;set;}
        @AuraEnabled public String ServiceSettingTypeDescription {get;set;}
        @AuraEnabled public String AuthId {get;set;}
        @AuraEnabled public String LengthOfStay {get;set;}
        @AuraEnabled public String StatusTypeCode {get;set;} //US2291037
        @AuraEnabled public String StatusTypeDescription {get;set;} //US2291037
    }
    
    public class OutPatientSummary {
        @AuraEnabled public String ServiceReferenceNumber {get;set;}
        @AuraEnabled public String ServiceStartDate {get;set;}
        @AuraEnabled public String ServiceEndDate {get;set;}
        @AuraEnabled public String ProcedureCode {get;set;}
        @AuraEnabled public String ProcedureCodeDescription {get;set;}
        @AuraEnabled public String PrimaryDiagnosisCode {get;set;}
        @AuraEnabled public String PrimaryDiagnosisCodeDescription {get;set;}
        @AuraEnabled public String ProviderFirstName {get;set;}
        @AuraEnabled public String ProviderLastName {get;set;}
        @AuraEnabled public String ProviderStatus {get;set;}
        @AuraEnabled public String ServiceSettingTypeCode {get;set;}
        @AuraEnabled public String ServiceSettingTypeDescription {get;set;}
        @AuraEnabled public String AuthId {get;set;}
        @AuraEnabled public String StatusTypeCode {get;set;} //US2291037
        @AuraEnabled public String StatusTypeDescription {get;set;} //US2291037
        
    }

    public class OutPatientFacilitySummary {
        @AuraEnabled public String ServiceReferenceNumber {get;set;}
        @AuraEnabled public String ActualAdmitDate {get;set;}
        @AuraEnabled public String ActualDischargeDateTime {get;set;}
        @AuraEnabled public String ProcedureCode {get;set;}
        @AuraEnabled public String ProcedureCodeDescription {get;set;}
        @AuraEnabled public String PrimaryDiagnosisCode {get;set;}
        @AuraEnabled public String PrimaryDiagnosisCodeDescription {get;set;}
        @AuraEnabled public String ProviderFirstName {get;set;}
        @AuraEnabled public String ProviderLastName {get;set;}
        @AuraEnabled public String ProviderOrganizationName {get;set;}
        @AuraEnabled public String ProviderNetworkStatusTypeCode {get;set;}
        @AuraEnabled public String ProviderNetworkStatusTypeDescription {get;set;}
        @AuraEnabled public String ServiceSettingTypeCode {get;set;}
        @AuraEnabled public String ServiceSettingTypeDescription {get;set;}
        @AuraEnabled public String AuthId {get;set;}
        @AuraEnabled public String StatusTypeCode {get;set;} //US2291037
        @AuraEnabled public String StatusTypeDescription {get;set;} //US2291037

    }
    

}