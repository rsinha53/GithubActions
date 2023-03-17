/**
* Author: Hasara Disanayaka
* Date Created: 07/08/2020
* Purpose: for Claim details
**/
public without sharing class ADBClaimDetailWrapper {

    @AuraEnabled 
    public List<ClaimSearchV2ServiceItem> claimSearchV2ServiceItem;
    
    public class ClaimSearchV2ServiceItem {
        @AuraEnabled 
        public String claimStatus;
        @AuraEnabled 
        public String fillDate;
        @AuraEnabled 
        public String productNameAbbreviation;
        @AuraEnabled 
        public String pharmacyName;
        @AuraEnabled 
        public String daysSupply;
    }
}