/**
* Author: Hasara Disanayaka
* Description : Used by Health Spend Card
* AuraEnabled : 
* Date Created: 07/07/2020
*/
public without sharing class ADBMemberDetailWrapper {
    
    @AuraEnabled 
    public String memberId;
    @AuraEnabled 
    public String carrierId;
    @AuraEnabled 
    public String accountId;
    @AuraEnabled 
    public String groupId;          
    @AuraEnabled 
    public String instanceId;
    @AuraEnabled 
    public String fromDate;
    @AuraEnabled 
    public String thruDate;
    @AuraEnabled 
    public String pbm;
    
    @AuraEnabled 
    public String fillDate;
    @AuraEnabled 
    public String productNameAbbreviation;
    @AuraEnabled 
    public String pharmacyName;
    @AuraEnabled 
    public String daysSupply;
    @AuraEnabled 
    public String claimStatus;
}