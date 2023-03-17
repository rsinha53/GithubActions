public class ACETSNIWorkOrderDetailsWrapper {
	@AuraEnabled public List<ServiceLineDetail> serviceLineDetail {get;set;}
    @AuraEnabled public List<ProviderDetail> providerDetail{get;set;}
    @AuraEnabled public FacilityDetail facilityDetail{get;set;}
    @AuraEnabled public List<DiagnosisDetail> diagnosisDetail{get;set;}
    @AuraEnabled public List<BedDayDecisionDetail> bedDayDecisionDetail{get;set;}
    @AuraEnabled public FollowUpDetail followUpDetail{get;set;}
    @AuraEnabled public List<NotesDetail> notesDetail{get;set;}
    @AuraEnabled public String patientType{get;set;}
    @AuraEnabled public String facilityProvName{get;set;}
    @AuraEnabled public boolean isfacility{get;set;}
    @AuraEnabled public String priorAuthOwner {get;set;}
    @AuraEnabled public datetime hostSysDatTime {get;set;}
    @AuraEnabled public string canceledReason {get;set;}
    
    public class ServiceLineDetail{
        @AuraEnabled public String serviceLineName {get;set;}
        @AuraEnabled public String serviceRef {get;set;}
        @AuraEnabled public String serviceDesc {get;set;}
        @AuraEnabled public String procedureCode {get;set;}
        @AuraEnabled public String procedureType {get;set;}
        @AuraEnabled public String procedure {get;set;}
        @AuraEnabled public String procedureTotCount {get;set;}
        @AuraEnabled public String procedureFreqCount {get;set;}
        @AuraEnabled public String procedUnitOfMeasure {get;set;}
        @AuraEnabled public String procedFreqCode {get;set;}    
        @AuraEnabled public String decisionOutcome {get;set;}
        @AuraEnabled public String decisionSubType {get;set;}
        @AuraEnabled public String serviceStartDate {get;set;}
        @AuraEnabled public String serviceEndDate {get;set;}
        @AuraEnabled public String renderedDate {get;set;}
        @AuraEnabled public String decisionBy {get;set;}
        @AuraEnabled public String providerNameStatus {get;set;}
        @AuraEnabled public String gapreviewoutcome {get;set;}
        @AuraEnabled public String decisionUserPosition {get;set;}
        @AuraEnabled public String derivedClaimRemarkCode {get;set;}
        @AuraEnabled public String overrideClaimRemarkCode {get;set;}
        @AuraEnabled public String advanceNotifiTime {get;set;}
        @AuraEnabled public String decisionReason {get;set;}
    }
    public class ProviderDetail{
        @AuraEnabled public String providerName {get;set;}
        @AuraEnabled public String role {get;set;}
        @AuraEnabled public String name {get;set;}
        @AuraEnabled public String status {get;set;}
        @AuraEnabled public String speciality {get;set;}
        @AuraEnabled public String tin {get;set;}
        @AuraEnabled public String phoneNumber {get;set;}
        @AuraEnabled public String address {get;set;}
        @AuraEnabled public String faxNumber {get;set;}
    }
    public class FacilityDetail{
        @AuraEnabled public String nameStatus {get;set;}
        @AuraEnabled public String placeOfService {get;set;}
        @AuraEnabled public String expectedAdmissionDischargeDate {get;set;}
        @AuraEnabled public String actualAdmissionDischargeDates {get;set;}
        @AuraEnabled public String expirationDate {get;set;}
        @AuraEnabled public String decisionOutcome {get;set;}
        @AuraEnabled public String decisionSubType {get;set;}
        @AuraEnabled public String decisionMadeBy {get;set;}
        @AuraEnabled public String rolePosition {get;set;}
        @AuraEnabled public String claimCode {get;set;}
        @AuraEnabled public String advanceNotification {get;set;}
        @AuraEnabled public String admissionNotification {get;set;}
        @AuraEnabled public String dischargeNotification {get;set;}
        @AuraEnabled public String decisionReason {get;set;}
        
    }
    public class DiagnosisDetail{
        @AuraEnabled public String diagnosisCodeName {get;set;}
        @AuraEnabled public String dxCode {get;set;}
        @AuraEnabled public String diagnosisDescription {get;set;}
        @AuraEnabled public boolean primary {get;set;}
    }
    
    public class BedDayDecisionDetail{
        @AuraEnabled public String beginEndDate {get;set;}
        @AuraEnabled public String IPMNRAllowed {get;set;}
        @AuraEnabled public String decisionUpdate {get;set;}
        @AuraEnabled public String decision {get;set;}
        @AuraEnabled public String reason {get;set;}
        @AuraEnabled public String claimComments {get;set;}
        @AuraEnabled public String decisionBy {get;set;}
        @AuraEnabled public String bedType {get;set;}
        @AuraEnabled public String overrideReason {get;set;}
        @AuraEnabled public String dischargeLocation {get;set;}
    }
    
     public class FollowUpDetail{
        @AuraEnabled public String name {get;set;}
        @AuraEnabled public String role {get;set;}
        @AuraEnabled public String department {get;set;}
        @AuraEnabled public String phone {get;set;}
        @AuraEnabled public String fax {get;set;}
    }
    
    public class NotesDetail {
		@AuraEnabled public String categoryCode {get;set;} 
		@AuraEnabled public String text {get;set;} 
		@AuraEnabled public String createdByUserId {get;set;} 
		@AuraEnabled public String createDateTime {get;set;} 
        @AuraEnabled public String department {get;set;}
	}
    public class ServiceEffDates {
		@AuraEnabled public String startDate {get;set;} 
		@AuraEnabled public String stopDate {get;set;} 
	}
}