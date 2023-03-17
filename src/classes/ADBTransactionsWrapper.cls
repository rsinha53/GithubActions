public without sharing class ADBTransactionsWrapper {

    @AuraEnabled public TransactionData[] transData{get;set;}
    
    public class TransactionData {
        
        @AuraEnabled public String ssn{get;set;}
        @AuraEnabled public String firstName{get;set;}
        @AuraEnabled public String lastName{get;set;}
        @AuraEnabled public String spendingCardType{get;set;}
        @AuraEnabled public String coordinatedPayment{get;set;}
        @AuraEnabled public String preFunded{get;set;}
        @AuraEnabled public String allowCoordPayOver{get;set;}
        @AuraEnabled public String disableOverrideFromPortal{get;set;}
        @AuraEnabled public String carryoverIndicator{get;set;}
        @AuraEnabled public String acctPlanYearGracePeriodExpirationDate{get;set;}
        @AuraEnabled public String accountCode{get;set;}
        @AuraEnabled public String accountNumber{get;set;}
        @AuraEnabled public String accountType{get;set;}
        @AuraEnabled public String investedBalance{get;set;}
        @AuraEnabled public String accountError{get;set;}
        @AuraEnabled public TransactionList[] transList{get;set;}
        
    }
    
    public class TransactionList {
        
        @AuraEnabled public String amount{get;set;}
        @AuraEnabled public String description{get;set;}
        @AuraEnabled public String processedDate{get;set;}
        @AuraEnabled public String status{get;set;}
        @AuraEnabled public String type_Z {get;set;}
    }
    
}