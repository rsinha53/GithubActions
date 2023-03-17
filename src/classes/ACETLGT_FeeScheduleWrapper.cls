public class ACETLGT_FeeScheduleWrapper {
    @AuraEnabled public string diagCodes {get;set;}
    @AuraEnabled public integer rowIndex {get; set;}
    @AuraEnabled public string dateOfServiceFrom {get;set;}
    @AuraEnabled public string dateOfServicethru {get;set;}
    @AuraEnabled public string procedureCode {get;set;}
    @AuraEnabled public string placeOfServiceCode {get;set;}
    @AuraEnabled public string serviceUnits {get;set;}
    @AuraEnabled public string rxNationalDrugCode {get;set;}
    @AuraEnabled public String modifierCode1{get;set;}
    @AuraEnabled public String modifierCode2{get;set;} 
    @AuraEnabled public String modifierCode3{get;set;} 
    @AuraEnabled public String modifierCode4{get;set;} 
    @AuraEnabled public string drugCode {get;set;}
    @AuraEnabled public string pricedAmount {get;set;}
    @AuraEnabled public string pricingSetId {get;set;}
    @AuraEnabled public string pricingScheduleId {get;set;}
    @AuraEnabled public string billedAmount {get;set;}
    @AuraEnabled public list<string> MOdifiersList {get;set;}
    @AuraEnabled public string diagnosisCode1 {get;set;}
    @AuraEnabled public string diagnosisCode2 {get;set;}
    @AuraEnabled public string diagnosisCode3 {get;set;}
    @AuraEnabled public string diagnosisCode4 {get;set;}
    @AuraEnabled public string diagnosisCode5 {get;set;}
    @AuraEnabled public string diagnosisCode6 {get;set;}
    @AuraEnabled public string diagnosisCode7 {get;set;}
    @AuraEnabled public string diagnosisCode8 {get;set;}
    @AuraEnabled public string diagnosisCode9 {get;set;}
    @AuraEnabled public string diagnosisCode10 {get;set;}
    @AuraEnabled public string diagnosisCode11{get;set;}
    @AuraEnabled public string diagnosisCode12{get;set;}
    @AuraEnabled public string revCode{get;set;}
    @AuraEnabled public list<string> revCodesList {get;set;}
  
    public ACETLGT_FeeScheduleWrapper(){
        this.diagnosisCode1 = '';
    }
    
    
   // return new ACETLGT_Fee
}