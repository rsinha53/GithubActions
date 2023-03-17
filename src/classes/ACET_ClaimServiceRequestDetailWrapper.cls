/**
 * @description       : Forming Return response for claim service request detail page
 * @author            : Nikhil Kanth
 * @group             : 
 * @last modified on  : 05-04-2021
 * @last modified by  : Nikhil Kanth
 * Modifications Log 
 * Ver   Date         Author         Modification
 * 1.0   05-04-2021   Nikhil Kanth   Initial Version
**/
public class ACET_ClaimServiceRequestDetailWrapper {
    
    @AuraEnabled public ExternalIdDetails externalIdDetails;
    @AuraEnabled public List<History> historyList;
    @AuraEnabled public List<Attachment> attachmentList;


    public ACET_ClaimServiceRequestDetailWrapper() {
        this.externalIdDetails = new ExternalIdDetails();
        this.historyList = new List<History>();
        this.attachmentList = new List<Attachment>();
    }

    public class ExternalIdDetails {
        
        @AuraEnabled public string status;
        @AuraEnabled public String adjustment;
        @AuraEnabled public String memberName;
        @AuraEnabled public String memberId;
        @AuraEnabled public String claimNumber;
        @AuraEnabled public String claimServiceDate;
        @AuraEnabled public String billedAmount;
        @AuraEnabled public String amountRequested;
        @AuraEnabled public String platform;
        @AuraEnabled public String contactName;
        @AuraEnabled public String phnNumber;
        @AuraEnabled public String emailAddress;
        @AuraEnabled public String billingProvider;
        @AuraEnabled public String servicingProvider;

        public ExternalIdDetails() {
            this.status = '--'; 
            this.adjustment = '--'; 
            this.memberName = '--';
            this.memberId = '--';
            this.claimNumber = '--'; 
            this.claimServiceDate = '--';
            this.billedAmount = '--';
            this.amountRequested = '--'; 
            this.platform = '--'; 
            this.contactName = '--'; 
            this.phnNumber = '--'; 
            this.emailAddress = '--';
            this.billingProvider = '--'; 
            this.servicingProvider = '--';
        }
    }
    
    public class History {
        
        @AuraEnabled public String dateAndTime;
        @AuraEnabled public String addedBy;
        @AuraEnabled public String comments;
        
        public History() {
            this.dateAndTime = '--'; 
            this.addedBy = '--'; 
            this.comments = '--'; 
        }
    }
    
    public class Attachment {
        
        @AuraEnabled public String dateAndTime;
        @AuraEnabled public String addedBy;
        @AuraEnabled public String type;
        @AuraEnabled public String fileName;
        @AuraEnabled public String fileId;
        
        public Attachment() {
            this.dateAndTime = '--'; 
            this.addedBy = '--'; 
            this.type = '--'; 
            this.fileName = '--';
            this.fileId = '--';
        }
    }
}