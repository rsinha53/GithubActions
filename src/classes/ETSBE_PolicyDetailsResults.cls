public with sharing class ETSBE_PolicyDetailsResults {
        @AuraEnabled public policyResults policyRes {get;set;}

    public class policyResults {

        @AuraEnabled public String sourceCode {get;set;}
        @AuraEnabled public String timelyFilling {get;set;} //GAP
        @AuraEnabled public String MaintenanceDate {get;set;} //GAP
        @AuraEnabled public String payerId {get;set;} //GAP
        @AuraEnabled public String claimsMailingAddress {get;set;}
        @AuraEnabled public String fundingArrangement {get;set;}
        @AuraEnabled public String sharedSavings {get;set;} //GAP
        @AuraEnabled public String regionCode {get;set;} //GAP
        @AuraEnabled public String groupName {get;set;}
        @AuraEnabled public String marketType {get;set;}
        @AuraEnabled public String fundingType {get;set;}
        @AuraEnabled public String groupNumber {get;set;}
        @AuraEnabled public String productType {get;set;}
        @AuraEnabled public String stateOfIssueCode {get;set;} //AKA HealthPlan
        @AuraEnabled public String HealthPlanSite {get;set;} //GAP
        @AuraEnabled public String productId {get;set;} //AKA NetworkType
        @AuraEnabled public String cosmosDivision {get;set;} //AKA DIV
        @AuraEnabled public String groupPanelNumber {get;set;} //AKA Panel
		@AuraEnabled public String homeTelephoneNumber {get;set;}
        @AuraEnabled public Boolean isPHSPlan {get;set;}
        @AuraEnabled public Boolean isMedicarePlan {get;set;}
        @AuraEnabled public Boolean isMedicaidPlan {get;set;}
        @AuraEnabled public Boolean isComPlan {get;set;}
        @AuraEnabled public Boolean claimAddress {get;set;}

        //US1827051 - Show only core fields - Sanka - 06/06/2019
        @AuraEnabled public Boolean showAllFields {get;set;}

        //US1901028	- Member CDHP Integration - Sarma - 29/08/2019
        @AuraEnabled public Boolean isCdhp {get;set;}
        @AuraEnabled public Boolean isHsa {get;set;}

        //US2154799
        @AuraEnabled public String xrefId {get;set;}

    }

    public class Members {

    }

    //US1974546 - Coverage Level Integration
    //Sanka Dharmasena - 28/08/2019
    public class ProviderCoverageLevel
    {
        @AuraEnabled public String CoverageLevel{get;set;}
        @AuraEnabled public Boolean Success{get;set;}
        @AuraEnabled public Integer StatusCode{get;set;}
        @auraEnabled public String Message{get;set;}
        //USS2221006
        @AuraEnabled public String GroupNumber{get;set;}
    }
}