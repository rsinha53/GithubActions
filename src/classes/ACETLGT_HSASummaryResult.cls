public class ACETLGT_HSASummaryResult {

    @AuraEnabled public list<HSAAccountsWrapper> hsaAccounts{get;set;}
    @AuraEnabled public list<hsaBankAuthentication> accHolderList{get;set;}
    
    public class hsaBankAuthentication
    {
        @AuraEnabled public String accountHoldersName{get;set;}
        @AuraEnabled public String ssn{get;set;}
        @AuraEnabled public String address{get;set;}
        @AuraEnabled public String phone{get;set;}
        @AuraEnabled public String phoneType{get;set;}
        @AuraEnabled public String dob{get;set;}
    }
    
    public class HSAAccountsWrapper
    {
       @AuraEnabled public String hsaId{get;set;}
       @AuraEnabled public String HSAAccountNoMasked{get;set;}
       @AuraEnabled public String HSAAccountNo{get;set;}
       @AuraEnabled public String AccCode{get;set;}
       @AuraEnabled public String AccName{get;set;}
       @AuraEnabled public String cummulativeBalance{get;set;}
       @AuraEnabled public String investedBalance{get;set;}
       @AuraEnabled public String availableBalance{get;set;}
       @AuraEnabled public String administeredBy{get;set;} 
       @AuraEnabled public String groupName {get;set;} 
       @AuraEnabled public String groupId {get;set;}
    }
    
}