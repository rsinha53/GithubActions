// US2041480 - Thanish - 26th Mar 2020
public class ACET_ServiceRequestDetailWrapper {
    
    @AuraEnabled public String strDate;
    @AuraEnabled public Boolean isFacets;
    @AuraEnabled public ExternalIdDetails externalIdDetails;
    @AuraEnabled public List<History> historyList;
    
    // US2667560 - ORS ReadIssue Error Handling - Sanka
    @AuraEnabled public String errorMessage;
    @AuraEnabled public boolean success;
    @AuraEnabled public String userTimeZone;
    @AuraEnabled public String extORSFacetsTimeZone;


    public ACET_ServiceRequestDetailWrapper() {
        this.externalIdDetails = new ExternalIdDetails();
        this.historyList = new List<History>();
        this.strDate = '';
        this.isFacets = false;
    }

    public class ExternalIdDetails {
        
        @AuraEnabled public string IDType;
        @AuraEnabled public String status;
        @AuraEnabled public String method;
        @AuraEnabled public String origType;
        @AuraEnabled public String claimNumber;
        @AuraEnabled public String claimServiceDate;
        @AuraEnabled public String origMPIN;
        @AuraEnabled public String origTaxId;
        @AuraEnabled public String origName;
        @AuraEnabled public String reason;
        @AuraEnabled public String surveyCode;
        @AuraEnabled public Map<string,Object> additionalInfo;// US2615858

        public ExternalIdDetails() {
            this.status = '--'; this.method = '--'; this.origType = '--'; this.claimNumber = '--'; this.claimServiceDate = '--';this.additionalInfo = new Map<string,Object>();
            this.origMPIN = '--'; this.origTaxId = '--'; this.origName = '--'; this.reason = '--'; this.IDType = 'ORS';
        }
    }
    
    public class History {
        
        @AuraEnabled public String dateAndTime;
        @AuraEnabled public String addedBy;
        @AuraEnabled public String owner;
        @AuraEnabled public String comments;
        
        public History() {
            this.dateAndTime = '--'; this.addedBy = '--'; this.owner = '--'; this.comments = '--'; 
        }
    }
}