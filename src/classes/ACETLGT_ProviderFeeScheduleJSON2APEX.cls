public class ACETLGT_ProviderFeeScheduleJSON2APEX{
	@AuraEnabled public feeScheduleDetailResponse feeScheduleDetailResponse{get; set;}
	public class feeScheduleDetailResponse {
	    @AuraEnabled public claimHeaders[] claimHeaders{get; set;}
         @AuraEnabled public List<ACETOILError> errors{get; set;}
	}
	public class claimHeaders {
		@AuraEnabled public String claimClassID{get; set;}	//PROF
		@AuraEnabled public String manualReviewIndicator{get; set;}	//false
		@AuraEnabled public String pricingSetID{get; set;}	//MSPSNEWNG92142
		@AuraEnabled public String pricingScheduleID{get; set;}	//000330192142C
		@AuraEnabled public String pricingScheduleVersionID{get; set;}	//2839484
        @AuraEnabled public string diagnosisRelatedGroupCode {get;set;}
		@AuraEnabled public claimLines[] claimLines{get; set;}
        
	}
    public class messages{
         @AuraEnabled public string id{get; set;}
         @AuraEnabled public string description{get; set;}
    }
    
	public class claimLines{
         @AuraEnabled public String claimClassIDParent{get; set;}	//PROF
		 @AuraEnabled public String manualReviewIndicatorParent{get; set;}	//false
		 @AuraEnabled public String pricingSetIDParent{get; set;}	//MSPSNEWNG92142
		 @AuraEnabled public String pricingScheduleIDParent{get; set;}	//000330192142C
		 @AuraEnabled public String pricingScheduleVersionIDParent{get; set;}	//2839484
         @AuraEnabled public String revenueCode {get;set;}
         @AuraEnabled public String drgCode {get;set;}
		 @AuraEnabled public String billedAmount{get; set;}	//250
		 @AuraEnabled public String claimLineNumber{get; set;}	//1
		 @AuraEnabled public String dateOfServiceFrom{get; set;}	//2018-07-09
		 @AuraEnabled public String dateOfServiceThru{get; set;}	//2018-07-09
		 @AuraEnabled public String placeOfServiceCode{get; set;}	//11
		 @AuraEnabled public String serviceUnits{get; set;}	//1
		 @AuraEnabled public String aggregateAllowAmount{get; set;}	//0
		 @AuraEnabled public String aggregateAllowIncrease{get; set;}	//0
		 @AuraEnabled public String apcAmount{get; set;}	//0
		 @AuraEnabled public String aapAmount{get; set;}	//0
		 @AuraEnabled public String apAmount{get; set;}	//0
		 @AuraEnabled public String basePrice{get; set;}	//108.12
		 @AuraEnabled public String basepricePercent{get; set;}	//0
		 @AuraEnabled public String billedAjustAmount{get; set;}	//0
		 @AuraEnabled public String ccPercentReductionAmount{get; set;}	//0
		 @AuraEnabled public String ccPricedAmount{get; set;}	//0
		 @AuraEnabled public componentDetailTierList[] componentDetailTierList{get; set;}
         @AuraEnabled public modifierPricedList[] modifierPricedList{get; set;}
		 @AuraEnabled public String componentType{get; set;}	//PFS
		 @AuraEnabled public String finalPricedAmount{get; set;}	//108.12
		 @AuraEnabled public String gtbReductionAmount{get; set;}	//0
		 @AuraEnabled public String netModifierReduction{get; set;}	//0
		 @AuraEnabled public String notToExceedReduction{get; set;}	//0
		 @AuraEnabled public String outlierGTBReduction{get; set;}	//0
		 @AuraEnabled public String outlierPricedAmount{get; set;}	//108.12
		 @AuraEnabled public String parentLineNumber{get; set;}	//0
		 @AuraEnabled public String priced{get; set;}	//108.12
		 @AuraEnabled public String pricedPercentReductionAmount{get; set;}	//0
		 @AuraEnabled public String pricedPercent{get; set;}	//100
		 @AuraEnabled public String pricingScheduleOrderID{get; set;}	//2869484
		 @AuraEnabled public String procedureCodeType{get; set;}	//2
		 @AuraEnabled public String procedureCode{get; set;}	//99214
		 @AuraEnabled public String processedAmount{get; set;}	//108.12
		 @AuraEnabled public String reviewIndicator{get; set;}	//false
		 @AuraEnabled public String transferPriceReductionAmount{get; set;}	//0
         @AuraEnabled public messages[] messages{get; set;}
         @AuraEnabled public decimal totalPricedAmount {get;set;} // added for calculating priced amount
        
	}
     
   
	public class componentDetailTierList {
		 @AuraEnabled public String calculationType{get; set;}	//FDPU
		 @AuraEnabled public String pricingComponentDetailID{get; set;}	//244087442
		 @AuraEnabled public String pricingComponentType{get; set;}	//PFS
	}
    
    public class modifierPricedList{
         @AuraEnabled public string modifierCode{get; set;}
    }
	
}