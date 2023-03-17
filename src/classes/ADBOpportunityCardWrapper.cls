/**
* Author: Madhura Priyadarshana
* Date Created: 09/16/2019
* Date Modified:
* Purpose: UI wrapper for Opportunity card with necessary information
* 
* */

public without sharing class ADBOpportunityCardWrapper {
    
    //  Status handling
    @AuraEnabled
    public Integer statusCode { get; set; }
    @AuraEnabled
    public String statusMessage { get; set; }
    // handling response message
    @AuraEnabled
    public String responseMessage { get; set; }
    
    //  Summary information of all retrieved opportunities/offers
    @AuraEnabled
    public Integer pharmacyCount{ get; set; }
    @AuraEnabled
    public Integer financialCount{ get; set; }
    @AuraEnabled
    public Integer healthCount{ get; set; }
    @AuraEnabled
    public Integer clinicalCount{ get; set; }
    @AuraEnabled
    public Integer totalCount{ get; set; }
    @AuraEnabled
    public String Role{ get; set; }
    
    
    //  Offer information
    @AuraEnabled
    public List<ADBOpportunity> offers{ get; set; }
}