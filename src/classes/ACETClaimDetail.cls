public with sharing class ACETClaimDetail {
    public String GroupNumber {get;set;}
    public String ReceivedDate {get;set;}
    public String TimelyFilingLimit {get;set;}
    public String PatientAccountNumber {get;set;}
    //public String ReferralNumber {get;set;}//?
    public String BillType {get;set;}
    public String AdmitDate {get;set;}
    public String AdmitTime {get;set;}
    public String ClaimSplitIndicator {get;set;}
    public String ReferenceClaimID {get;set;}
    public String ClaimEventType {get;set;}
    public String ClaimEventSequenceNumber {get;set;}
    public String ClaimProcessed {get;set;}
    public String PatientName {get;set;}
    public String PatientDOB {get;set;}
    public String SubmissionType {get;set;}
    public String DCN {get;set;}
     public String  InstiTotalMemberReimbursementReductionAmount {get;set;}
    public String InstiTotalProviderReimbursementReductionAmount {get;set;}
    public String ProfTotalMemberReimbursementReductionAmount {get;set;}
    public String ProfTotalProviderReimbursementReductionAmount {get;set;}
    public String InstiTotalMemberPenaltyAmount {get;set;}
    public String InstiTotaProviderPenaltyAmount {get;set;}
    public String ProfTotalMemberPenaltyAmount {get;set;}
    public String profTotaProviderPenaltyAmount {get;set;}
    
    
    public List<TotalUHC> TotalUHCs {get;set;}  
    public List<MemberResponsibility> MemberResponsibility {get;set;} 
    public List<ProviderResponsibility> ProviderResponsibility {get;set;} 
    public List<TotalCOB> TotalCOB {get;set;}
    public List<ClaimCode> ClaimCode {get;set;}
    public List<ServiceLine> ServiceLines {get;set;}
    public List<ClaimDiagnosis> ClaimDiagnosis {get;set;} 
    public List<ClaimEdit> ClaimEdits {get;set;}
    public PatientInformation PatientInformation {get;set;}
    public List<SurgicalProcedureCode> SurgicalProcedureCodes {get;set;}
    public List<OccurrenceCode> OccurrenceCodes {get;set;}
    public List<OccurrenceSpanCode> OccurrenceSpanCodes {get;set;}
    public List<CauseCode> CauseCode {get;set;}
    public List<ClaimEvent> ClaimEvents {get;set;}
    public String relatedIcns {get;set;}
    public List<ClaimNote> claimNotesUser {get;set;}
    public List<ClaimNote> claimNotesSystem {get;set;}
    public List<Payment> Payments {get;set;}    
    
    
    public class ClaimEvent implements Comparable{
        public String claimEventAdjudicationDateTime {get;set;}
        public String EventSequenceNumber {get;set;}
        public String EventType {get;set;}
        public String EventID {get;set;}
        
        public Integer compareTo(Object compareTo){
            ClaimEvent compareToCE = (ClaimEvent)compareTo;
            if(integer.valueof(EventSequenceNumber) == integer.valueof(compareToCE.EventSequenceNumber)){
                return 0;
            } 
            if(integer.valueof(EventSequenceNumber) > integer.valueof(compareToCE.EventSequenceNumber)){
                return 1;
            }
            return -1;
        }
    }
    
    public class ClaimNote implements Comparable {
        public String noteTypeCode {get;set;} 
        public String noteTypeText {get;set;} 
        public String notesCreatedBy {get;set;} 
        public String notesCreatedDate {get;set;}  
        
        public Integer compareTo(Object compareTo){
            ClaimNote compareToNote = (ClaimNote)compareTo;
            if(notesCreatedDate == compareToNote.notesCreatedDate)return 0;
            if(notesCreatedDate < compareToNote.notesCreatedDate)return 1;
            return -1;
        }       
    }
    
    public class TotalUHC {
        public String Status {get;set;}
        public String Charged {get;set;}
        public String ReimbursementReduction {get;set;}
        public String Allowed {get;set;}
        public String Penalty {get;set;}
        public String InterestPaid {get;set;}
        public String NYSurchargePaid {get;set;}
        public String HealthPlanPaid {get;set;}
    }
    
    public class MemberResponsibility {
        public String Deductible {get;set;}
        public String Copay {get;set;}
        public String Coinsurance {get;set;}
        public String ReimbursementReduction {get;set;}
        public String Penalty {get;set;}
        public String TotalMemberResponsibility {get;set;} 
            
    }
    
    public class ProviderResponsibility{
        public String ReimbursementReduction {get;set;}
        public String Penalty {get;set;}
        public String TotalWriteOff {get;set;}  
        public String TotalProviderResponsibility {get;set;} 
    }
    
    public class TotalCOB{
        public String Status {get;set;}
        public String OtherInsuranceType {get;set;}
        public String Charged {get;set;}
        public String Allowed {get;set;}        
        public String NotCovered {get;set;}     
        public String Paid {get;set;}
        public String MemberResponsibility {get;set;}
        public String COBMethod {get;set;}
    }
    
    public class ClaimCode {
        public String serviceLineID {get;set;}
        public String RevenueCode {get;set;}
        public String RevenueDescription {get;set;}
        public String RevenueCodeEncoderProDescription {get;set;}
        public String RemarkCodeMemberDescription {get;set;}
        public String RemarkCodeProviderDescription {get;set;}
        public String ProcedureCode {get;set;}
        public String ProcedureDescription {get;set;}
        public String ProcedureCodeEncoderProDescription {get;set;}       
        public String BenefitCode {get;set;}        
        public String BenefitDescription {get;set;}
        public String RemarkCode {get;set;}
        public String RemarkDescription {get;set;}  
        public String CARCCode {get;set;}
        public String CARCDescription {get;set;}
        public String RARCCode {get;set;}       
        public String RARCDescription {get;set;}
     
                            
    }
    public class ServiceLine {
        public String ServiceLineCode {get;set;}
        public String Status{get;set;}
        public String BenefitLevel {get;set;}
        public String PlaceofService {get;set;}
        public String Revenue {get;set;}
        public String RevenueEncoderProDescription {get;set;}
        public String Procedure {get;set;}
        public String ProcedureEncoderProDescription {get;set;}      
        public String Modifier {get;set;}       
        public String BenefitDescription {get;set;}
        public String Benefit {get;set;}
        public String Remark {get;set;} 
        public String CARC {get;set;}
        public String RARC {get;set;}
        public String DxPointer {get;set;}
        public String Units {get;set;} 
        public String Charged{get;set;}
        public String Copay{get;set;}
        public String Coinsurance{get;set;}
        public String StartDate {get;set;}  
        public String EndDate {get;set;}    
        public String Allowed {get;set;}    
        public String Deductible {get;set;} 
        public String ReimbursementReduction {get;set;} 
        public String Penalty {get;set;}    
        public String Paid {get;set;}   
        public String Adjustment {get;set;} 
        public String Percent {get;set;}            
        public String Authorization {get;set;}
        public String ReferralNumber {get;set;}
        public String alphaParentLineNum{get;set;}
        public String qualityTierValue{get;set;}
                            
    }
    
    public class ClaimDiagnosis{
        public String DiagnosisCode {get;set;}  
        public String DiagnosisDescription {get;set;}
        public String DiagnosisCodeEncoderProDescription {get;set;}           
        public String POA {get;set;}
        public String SequenceNumber {get;set;}        
    }
    
    public class ClaimEdit{
        public String ServiceLine {get; set;}
        public String EditType {get;set;}   
        public String EditAction {get;set;}         
        public String EditDescription {get;set;}            
    }
    
    public class PatientInformation{
        public String SurgeryDate {get;set;}    
        public String SemiPrivateRoom {get;set;}            
        public String DRGNumber {get;set;}
        public String Discharge {get;set;}  
    }
    
    public class SurgicalProcedureCode{
        public String ProcedureCode {get;set;}  
        public String ProcedureDescription {get;set;}           
    }
    
    public class CauseCode {
        public String CauseCode {get;set;}  
        public String CauseDescription {get;set;}   
    }
    
    public class OccurrenceCode{
        public String OccurrenceCode {get;set;} 
        public String OccurrenceDescription {get;set;}  
        public String OccurrenceDate {get;set;} 
    }
    
    public class OccurrenceSpanCode{
        public String OccurrenceSpanCode {get;set;} 
        public String OccurrenceSpanDescription {get;set;}  
        public String OccurrenceSpanStartDate {get;set;}
        public String OccurrenceSpanEndDate {get;set;}  
    }
        
    public class Payment {
        public String PaymentTotal {get;set;}
        public String PaymentType {get;set;}
        public String SeriesDesignator {get;set;}
        public String CheckEFTNumber {get;set;} 
        public String OverPaymentWithheld {get;set;}
        public String BulkPayment {get;set;}
        public String CheckStatus {get;set;}    
        public String Sent {get;set;}
        public String Cashed {get;set;}
        public String VoidStop {get;set;}
        public String Returned {get;set;}
        public String Reemailed {get;set;}  
        public String PayeeName {get;set;}
        public String PayeeAddress {get;set;}
        public String PayeeCity {get;set;}
        public String PayeeState {get;set;}
        public String PayeeZip {get;set;}
        //Sampath Added the paymentIssueDate
        public String PaymentIssueDate {get;set;}
    }          
}