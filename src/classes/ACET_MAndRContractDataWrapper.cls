// US2186401 - Thanish - 6th Jan 2019
// used to store and send M and R data to the front end
public class ACET_MAndRContractDataWrapper {

    // response status variables    
    @auraEnabled public boolean Success {get; set;}
    @auraEnabled public string Message {get; set;}
    @auraEnabled public ApexPages.Severity Severity {get; set;}
    @auraEnabled public integer StatusCode {get; set;}
    // contract data variables
    @auraEnabled public string mnrId {get; set;}
    @auraEnabled public boolean isLinkDisabled {get; set;}
    @auraEnabled public ACET_MAndRContractSummary contractSummary {get; set;}
    @auraEnabled public ACET_MAndRContractDetails contractDetails {get; set;}
    
    public ACET_MAndRContractDataWrapper() {
        this.Success = true; this.Message = 'Success'; this.Severity = ApexPages.Severity.CONFIRM; this.StatusCode = 200; this.mnrId = ''; this.isLinkDisabled = false;
        this.contractSummary = new ACET_MAndRContractSummary(); this.contractDetails = new ACET_MAndRContractDetails();
    }
    
    public class ACET_MAndRContractSummary {
        @auraEnabled public boolean autodoc {get; set;}
        @auraEnabled public boolean status {get; set;}
        @auraEnabled public string contractId {get; set;}
        @auraEnabled public string org {get; set;}
        @auraEnabled public string div {get; set;}
        @auraEnabled public string panel {get; set;}
        @auraEnabled public string panelDescription {get; set;}
        @auraEnabled public string effectiveAndCancel {get; set;}
        @auraEnabled public string contractType {get; set;}
        @auraEnabled public string specialtyType {get; set;}
        @auraEnabled public string newPatients {get; set;}
        @auraEnabled public boolean resolved {get; set;}

        public ACET_MAndRContractSummary() {
            this.autodoc = false; this.status = true; this.contractId = ''; this.org = ''; this.div = ''; this.panel = ''; this.panelDescription = '';
            this.effectiveAndCancel = ''; this.contractType = ''; this.specialtyType = ''; this.newPatients = ''; this.resolved = false;
        }
    }

    public class ACET_MAndRContractDetails {
        // Contract Details
        @auraEnabled public string epsDate {get; set;}
        @auraEnabled public string epsType {get; set;}
        @auraEnabled public string uhnPti {get; set;}
        @auraEnabled public string additionalPti {get; set;}
        @auraEnabled public string capitation {get; set;}
        @auraEnabled public string feeSchedule {get; set;}
        @auraEnabled public string networkType {get; set;}
        @auraEnabled public string auditIndicator {get; set;}
        @auraEnabled public string preCertReduction {get; set;}
        @auraEnabled public string reductionPercentage {get; set;}
        @auraEnabled public string claimType {get; set;}
        // Timely Filing
        @auraEnabled public string initialClaim {get; set;}
        @auraEnabled public string appeal {get; set;}
        @auraEnabled public string reconsideration {get; set;}
        @auraEnabled public string additionalInformation {get; set;}
        @auraEnabled public string cirrectedClaim {get; set;}
        
        public ACET_MAndRContractDetails() {
            this.epsDate = '';this.epsType = '';this.uhnPti = '';this.additionalPti = ''; this.capitation = ''; this.feeSchedule = '';
            this.networkType = ''; this.auditIndicator = ''; this.preCertReduction = ''; this.reductionPercentage = '';
            this.claimType = ''; this.initialClaim = ''; this.appeal = ''; this.reconsideration = ''; this.additionalInformation = ''; this.cirrectedClaim = '';
        }
    }
}