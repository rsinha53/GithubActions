public class ACETLGT_ReferralSearchResult{
     @AuraEnabled public String resultMembername {get;set;}
     @AuraEnabled public String resultReferralnumber {get;set;}
     @AuraEnabled public String resultReferralstatus{get;set;}
     @AuraEnabled public String resultStartdate {get;set;}
     @AuraEnabled public String resultEnddate{get;set;}
     @AuraEnabled public String resultReferaltype {get;set;}
     @AuraEnabled public String resultRequestingtin {get;set;}
     @AuraEnabled public String resultPrimarytin {get;set;}
     @AuraEnabled public String resultRequestingprovider {get;set;}
     @AuraEnabled public String resultPrimaryprovider {get;set;}
     @AuraEnabled public String resultServicingtin {get;set;}
     @AuraEnabled public String resultServicingprovider {get;set;}
     @AuraEnabled public String resultDxcode {get;set;}
     @AuraEnabled public String resultDXDescription {get;set;}
     @AuraEnabled public Boolean selected {get; set;}
     @AuraEnabled public String resultreferralExternalID {get;set;}
     @AuraEnabled public String resultCreatedDate{get;set;}
     @AuraEnabled public String numberofvisit{get;set;}
     @AuraEnabled public String numberOfVisitUsed{get;set;}       // US935410
     @AuraEnabled public String numberOfVisitRemaining{get;set;}  // US935410
     @AuraEnabled public String noteText{get;set;}
    
     @AuraEnabled public list<Provider> providerlst{get;set;}
     @AuraEnabled public list<Service> servicelst{get;set;}
     @AuraEnabled public list<Diagnosis> diagnosisList{get;set;}
    public class Provider {
         @AuraEnabled public string resultProviderRole{get;set;}
         @AuraEnabled public string resultMPIN{get;set;}
         @AuraEnabled public string resultName{get;set;}
         @AuraEnabled public string resultNetworkStatus{get;set;}
         @AuraEnabled public string resultTIN{get;set;}
         @AuraEnabled public string resultAddress{get;set;}
         @AuraEnabled public string resultCity{get;set;}
         @AuraEnabled public string resultState{get;set;}
         @AuraEnabled public string resultZip{get;set;}
         @AuraEnabled public string speciality{get;set;}
    }
    public class Service {
         @AuraEnabled public string resultProcedureType{get;set;}
         @AuraEnabled public String resultProcedureCode{get;set;}
         @AuraEnabled public String resultDescription{get;set;}
    }
    public class Diagnosis{
         @AuraEnabled public string resultdiagCode{get;set;}
         @AuraEnabled public String resultdiadDesc{get;set;}
   }
   
   public ACETLGT_ReferralSearchResult(){
        selected=false;
    }
}