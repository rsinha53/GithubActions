public without sharing class ADBContributionsUIWrapper {
	@AuraEnabled public AccountBalance accountBalance{get;set;}
    
    public class AccountBalance {
        @AuraEnabled public Account[] account{get;set;}
        @AuraEnabled public String totalCurrentYrBalance{get;set;}
       @AuraEnabled public String totalPriorYrBalance{get;set;}
       @AuraEnabled public String totalCumulativeBalance{get;set;}
    }
    
    public class Account{
        @AuraEnabled public String accountNumberId{get;set;}
        @AuraEnabled public String accountTypeCode{get;set;}
        @AuraEnabled public String accountTypeDescription{get;set;}
        @AuraEnabled public String accountSystemCode{get;set;}
       //
        @AuraEnabled public AccountPlanYear[] accountPlanYear{get;set;}
        //account wise balances
        @AuraEnabled public String priorYearBalance{get;set;}
        @AuraEnabled public String currentYearBalance{get;set;}
        @AuraEnabled public String cumulativeBalance{get;set;}
      
    }
    
    public class AccountPlanYear{
       @AuraEnabled public string yearType{get;set;}
       @AuraEnabled public String effectiveStartDate{get;set;}
       @AuraEnabled public String effectiveEndDate{get;set;}
       @AuraEnabled public String currentBalanceAmount{get;set;}//current year balance
       @AuraEnabled public String totalBalance{get;set;}
       @AuraEnabled public String employeeContributionAmountYTD{get;set;}
       @AuraEnabled public String employeeElectedAmountTotal{get;set;}
       @AuraEnabled public String employeeBalance{get;set;}
       @AuraEnabled public String employerContributionAmountYTD{get;set;}
       @AuraEnabled public String employerContributionLessIncentiveAmountTotal{get;set;}
       @AuraEnabled public String employerBalance{get;set;}
       @AuraEnabled public String employerContributionIndicator{get;set;}
    }
    
    
}