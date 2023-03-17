public class ACETFeeScheduleWrapper {
    public string diagCodes {get;set;}
    public integer rowIndex {get; set;}
    public string DOSFromToday {get;set;}
    public string DOSThruToday {get;set;}
    public string dateOfServiceFrom {get;set;}
    public string dateOfServicethru {get;set;}
    public string procedureCode {get;set;}
    public string placeOfServiceCode {get;set;}
    public string serviceUnits {get;set;}
    public string rxNationalDrugCode {get;set;}
    public string CPT {get;set;}
    public string MOdifiers {get;set;}
    public list<string> MOdifiersList {get;set;}
    public String modifierCode1{get;set;}
     public String modifierCode2{get;set;} 
     public String modifierCode3{get;set;} 
     public String modifierCode4{get;set;} 
    public string POS {get;set;}
    public string drugCode {get;set;}
    public string daysOfUNits {get;set;}
    public string dollarCharges {get;set;}
    public string editCodeText {get;set;}
    public string pricedAmount {get;set;}
    public string pricingSetId {get;set;}
    public string pricingScheduleId {get;set;}
    public string billedAmount {get;set;}
    public string poscode {get;set;}
    public string diagnosisCode1 {get;set;}
    public string diagnosisCode2 {get;set;}
    public string diagnosisCode3 {get;set;}
    public string diagnosisCode4 {get;set;}
    public string diagnosisCode5 {get;set;}
    public string diagnosisCode6 {get;set;}
    public string diagnosisCode7 {get;set;}
    public string diagnosisCode8 {get;set;}
    public string diagnosisCode9 {get;set;}
    public string diagnosisCode10 {get;set;}
    public string diagnosisCode11{get;set;}
    public string diagnosisCode12{get;set;}
    public string revCode{get;set;}
    public list<string> revCodesList {get;set;}
  
    public ACETFeeScheduleWrapper(){
        
    }
  /*  public ACETFeeScheduleWrapper(String dateOfServiceFrom ,String dateOfServiceThru,string MOdifiers,string CPT,string drugCode,string daysOfUNits,string dollarCharges,string editCodeText,string pricedAmount,string billedAmount,string posCode,string placeOfServiceCode,string pricingSetId,string pricingScheduleId,string diagCodes){
    
        this.dateOfServiceFrom = dateOfServiceFrom ;
        this.dateOfServiceThru= dateOfServiceThru;
        this.MOdifiers = MOdifiers;
        this.posCode = posCode;
        this.drugCode = drugCode;
        this.daysOfUNits = daysOfUNits;
        this.CPT = CPT;
        this.placeOfServiceCode = placeOfServiceCode;
        this.dollarCharges = dollarCharges;
        this.billedAmount = billedAmount;
        this.pricedAmount = pricedAmount;
        this.poscode = poscode;
        this.pricingScheduleId = pricingScheduleId;
        this.pricingSetId = pricingSetId;
        this.diagCodes = diagCodes;
    }*/
}