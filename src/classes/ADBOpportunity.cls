/**
* Author: Shoven Shrivatava
* Date Created: 07/15/2019
* Date Modified:
* Purpose: Create mock opportunities to be consumed by controller
* 
* */

public without sharing class ADBOpportunity {
    @AuraEnabled
    public String offerCategory;
    @AuraEnabled 
    public String event { get; set; }
    @AuraEnabled 
    public String eventHoverOver { get; set; }
    @AuraEnabled 
    public String description { get; set; }
    @AuraEnabled 
    public String descriptionHoverOver { get; set; }
    @AuraEnabled 
    public String todo { get; set; }
    @AuraEnabled 
    public String todoHoverOver { get; set; }
    
    @AuraEnabled 
    public boolean callerAccept { get; set; }
    @AuraEnabled 
    public boolean callerConsidering { get; set; }
    @AuraEnabled 
    public boolean callerNotInterested { get; set; }
    @AuraEnabled 
    public boolean removeOpportunity { get; set; }
    @AuraEnabled
    public String removeOpportunityComments { get; set; }
    
    
    // Handling SLI save request from GLP response
    @AuraEnabled
    public String memberIdType { get; set; }
    
    @AuraEnabled
    public String mdmPersonId { get; set; }
    
    @AuraEnabled
    public String policyId { get; set; }
    
    @AuraEnabled
    public String srcMemberId { get; set; }
    
    @AuraEnabled
    public String srcMemberIdType { get; set; }
    
    @AuraEnabled
    public String mbrOppId { get; set; }
    
    @AuraEnabled
    public String homMbrOppId { get; set; }
    
    @AuraEnabled
    public String sourceCd { get; set; }
    
    @AuraEnabled
    public String opportunityId { get; set; }
    
    @AuraEnabled
    public String opportunityTypeCd { get; set; }
    
    @AuraEnabled
    public String eventDesc { get; set; }
    
    
    @AuraEnabled
    public String intPoint { get; set; }
    
    @AuraEnabled
    public String statusReasonCode { get; set; }
    
    @AuraEnabled
    public String offerCode { get; set; }
    
    @AuraEnabled
    public String treatmentCode { get; set; }
    
    @AuraEnabled
    public String carrierId { get; set; }
    
    @AuraEnabled
    public String accountId { get; set; }
    
    @AuraEnabled
    public String groupId { get; set; }
    
    @AuraEnabled
    public String nbaParentId { get; set; }
    
    @AuraEnabled
    public String blacklistDays { get; set; }
    
    //  Status handling
    @AuraEnabled
    public Integer statusCode { get; set; }
    @AuraEnabled
    public String statusMessage { get; set; }
	
	@AuraEnabled
    public List<dispositions> disposition;
    
    public class dispositions{
        
        @AuraEnabled
        public String blacklistDays { get; set; }
        @AuraEnabled
        public String todoLink { get; set; }
        @AuraEnabled
        public String nbaStatusReason { get; set; }
        @AuraEnabled
        public String dispName { get; set; }
    }
    
    // Default, no-arg constructor, for client-side -> server-side
    public ADBOpportunity() {}
    
}