// US2186401 - Thanish - 6th Jan 2019
// used to store and send E and I data to the front end
public class ACET_EAndIContractDataWrapper {

    // response status variables    
    @auraEnabled public boolean Success {get; set;}
    @auraEnabled public string Message {get; set;}
    @auraEnabled public ApexPages.Severity Severity {get; set;}
    @auraEnabled public integer StatusCode {get; set;}
    // contract data variables
    @auraEnabled public string eniId {get; set;}
    @auraEnabled public boolean isLinkDisabled {get; set;}
    @auraEnabled public ACET_EAndIContractSummary contractSummary {get; set;}
    @auraEnabled public ACET_EAndIContractDetails contractDetails {get; set;}
    
    public ACET_EAndIContractDataWrapper() {
        this.Success = true; this.Message = 'Success'; this.Severity = ApexPages.Severity.CONFIRM; this.StatusCode = 200; this.eniId = ''; this.isLinkDisabled = false;
        this.contractSummary = new ACET_EAndIContractSummary(); this.contractDetails = new ACET_EAndIContractDetails();
    }
    
    public class ACET_EAndIContractSummary {
        @auraEnabled public boolean autodoc {get; set;}
        @auraEnabled public boolean status {get; set;}
        @auraEnabled public string contractId {get; set;}
        @auraEnabled public string org {get; set;}
        @auraEnabled public string product {get; set;}
        @auraEnabled public string marketType {get; set;}
        @auraEnabled public string marketNumber {get; set;}
        @auraEnabled public string ipa {get; set;}
        @auraEnabled public string effectiveAndCancel {get; set;}
        @auraEnabled public string contractType {get; set;}
        @auraEnabled public string newPatients {get; set;}
        @auraEnabled public boolean resolved {get; set;}

        public ACET_EAndIContractSummary() {
            this.autodoc = false; this.status = true; this.contractId = ''; this.org = ''; this.product = ''; this.marketType = '';
            this.marketNumber = ''; this.ipa = ''; this.effectiveAndCancel = ''; this.contractType = ''; this.newPatients = ''; this.resolved = false;
        }
    }

    public class ACET_EAndIContractDetails {
        // Contract Details
        @auraEnabled public string epsDate {get; set;}
        @auraEnabled public string epsType {get; set;}
        @auraEnabled public string uhnPti {get; set;}
        @auraEnabled public string additionalPti {get; set;}
        @auraEnabled public string payTo {get; set;}
        @auraEnabled public string contractArrangement {get; set;}
        @auraEnabled public string site {get; set;}
        @auraEnabled public string enw {get; set;}
        @auraEnabled public string capitation {get; set;}
        @auraEnabled public string feeSchedule {get; set;}
        @auraEnabled public string preCertReduction {get; set;}
        @auraEnabled public string reductionPercentage {get; set;}
        @auraEnabled public string claimType {get; set;}
        // Timely Filing
        @auraEnabled public string initialClaim {get; set;}
        @auraEnabled public string appeal {get; set;}
        @auraEnabled public string reconsideration {get; set;}
        @auraEnabled public string additionalInformation {get; set;}
        @auraEnabled public string cirrectedClaim {get; set;}
        
        public ACET_EAndIContractDetails() {
            this.epsDate = '';this.epsType = '';this.uhnPti = '';this.additionalPti = '';this.payTo = ''; this.contractArrangement = '';
            this.site = ''; this.enw = ''; this.capitation = ''; this.feeSchedule = ''; this.preCertReduction = ''; this.reductionPercentage = '';
            this.claimType = ''; this.initialClaim = ''; this.appeal = ''; this.reconsideration = ''; this.additionalInformation = ''; this.cirrectedClaim = '';
        }
    }
}