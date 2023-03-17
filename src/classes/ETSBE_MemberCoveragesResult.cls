public with sharing class ETSBE_MemberCoveragesResult {
    public ETSBE_MemberCoveragesResult () {
        SurrogateKeys = new Set<String>();
        Ids = new Set<String>();    
    }
    @AuraEnabled public Set<String> SurrogateKeys {get;set;}
    @AuraEnabled public set<string> IDs {get;set;}
       
    // US1730904 - Financials PHS
    // Sanka Dharmasena - 20-06-2019     
    public class Financials
    {
      // Deductibles - Individual
      @AuraEnabled
      public Boolean dedFound{get;set;}
      @AuraEnabled
      public Double deductible{get;set;}
      @AuraEnabled
      public Double dedAmountRem{get;set;}
      @AuraEnabled
      public Double dedSatisfied{get;set;}
      @AuraEnabled
      public Double dedPrecentage{get;set;}

      // Deductibles - Family
      @AuraEnabled
      public Boolean dedFoundFam{get;set;}
      @AuraEnabled
      public Double deductibleFam{get;set;}
      @AuraEnabled
      public Double dedAmountRemFam{get;set;}
      @AuraEnabled
      public Double dedSatisfiedFam{get;set;}
      @AuraEnabled
      public Double dedFamPrecentage{get;set;}

      // OOP - Individual
      @AuraEnabled
      public Boolean outOPFound{get;set;}
      @AuraEnabled
      public Double outOP{get;set;}
      @AuraEnabled
      public Double outOPRemAmount{get;set;}
      @AuraEnabled
      public Double outOPSatisfied{get;set;}
      @AuraEnabled
      public Double oopPrecentage{get;set;}

      // OOP - Family
      @AuraEnabled
      public Boolean outOPFoundFam{get;set;}
      @AuraEnabled
      public Double outOPFam{get;set;}
      @AuraEnabled
      public Double outOPRemAmountFam{get;set;}
      @AuraEnabled
      public Double outOPSatisfiedFam{get;set;}
      @AuraEnabled
      public Double oopFamPrecentage{get;set;}

      //OutOfPocketMax - Individual
      @AuraEnabled
      public Boolean OOP_Limit_2_Found{get;set;}
      @AuraEnabled
      public double OOP_Limit_2{get;set;}
      @AuraEnabled
      public double OOP_Limit_2_Satisfied{get;set;}
      @AuraEnabled
      public double OOP_Limit_2_Rem{get;set;}
      @AuraEnabled
      public Double OOP_Limit_2_Precentage{get;set;}

      //OutOfPocketMax - Family
      @AuraEnabled
      public Boolean OOP_Limit_2_Found_Family{get;set;}
      @AuraEnabled
      public double OOP_Limit_2_Family{get;set;}
      @AuraEnabled
      public double OOP_Limit_2_Satisfied_Family{get;set;}
      @AuraEnabled
      public double OOP_Limit_2_Rem_Family{get;set;}
      @AuraEnabled
      public Double OOP_Limit_2_Precentage_Family{get;set;}

      //CopayMax - Individual
      @AuraEnabled 
      public Boolean CopayMax_Found{get;set;}
      @AuraEnabled 
      public Double CopayMax{get;set;}
      @AuraEnabled 
      public Double CopayMax_Satisfied{get;set;}
      @AuraEnabled 
      public Double CopayMax_Remaining{get;set;}
      @AuraEnabled 
      public Double CopayMax_Precentage{get;set;}

      //CopayMax - Family
      @AuraEnabled 
      public Boolean CopayMax_Found_Family{get;set;}
      @AuraEnabled 
      public Double CopayMax_Family{get;set;}
      @AuraEnabled 
      public Double CopayMax_Satisfied_Family{get;set;}
      @AuraEnabled 
      public Double CopayMax_Remaining_Family{get;set;}
      @AuraEnabled 
      public Double CopayMax_Precentage_Family{get;set;}

      // Medical Life Maximum - Add in the future
      //Individual
      // Family

      //---------------------//
      // Table values
      @AuraEnabled
      public Double DedCarryOverAmt{get;set;}
      @AuraEnabled 
      public Double ComDED{get;set;}
      @AuraEnabled 
      public Double ComOOP{get;set;}
      @AuraEnabled 
      public Double CrossApplyOOP{get;set;}
      @AuraEnabled 
      public Double OOP2Remaining{get;set;}
      @AuraEnabled 
      public Double CrossApplyOOP2{get;set;}
      @AuraEnabled 
      public Double CopayMaxSatisfied{get;set;}
      @AuraEnabled 
      public Double CopayMaxRemaining{get;set;}
      @AuraEnabled 
      public Double CrossApplyCopayMax{get;set;}
      @AuraEnabled 
      public Double DedCarryOverAmt_Family{get;set;}
      @AuraEnabled 
      public Double ComDED_Family{get;set;}
      @AuraEnabled 
      public Double ComOOP_Family{get;set;}
      @AuraEnabled 
      public Double CrossApplyOOP_Family{get;set;}
      @AuraEnabled 
      public Double OOP2Remaining_Family{get;set;}
      @AuraEnabled 
      public Double CrossApplyOOP2_Family{get;set;}
      @AuraEnabled 
      public Double CopayMaxSatisfied_Family{get;set;}
      @AuraEnabled 
      public Double CopayMaxRemaining_Family{get;set;}
      @AuraEnabled 
      public Double CrossApplyCopayMax_Family{get;set;}
    }

    public class FinancialsWrapper
    {
      @AuraEnabled 
      public String yearType{get;set;}
      @AuraEnabled 
      public String displayYear{get;set;}
      @AuraEnabled 
      public Financials inNetwork {get;set;}
      @AuraEnabled 
      public Financials onNetwork {get;set;}
      @AuraEnabled 
      public Financials tierOne {get;set;}
     //US1901028 - Member CDHP Integration - Sarma - 29/08/2019  
      @AuraEnabled 
      public Boolean isHra {get;set;}
      @AuraEnabled 
      public Double hraVal {get;set;}
    }
}