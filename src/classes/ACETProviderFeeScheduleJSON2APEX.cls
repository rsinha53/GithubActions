public class ACETProviderFeeScheduleJSON2APEX{
	public feeScheduleDetailResponse feeScheduleDetailResponse{get; set;}
	public class feeScheduleDetailResponse {
		public claimHeaders[] claimHeaders{get; set;}
         public List<ACETOILError> errors{get; set;}
	}
	public class claimHeaders {
		public String claimClassID{get; set;}	//PROF
		public String manualReviewIndicator{get; set;}	//false
		public String pricingSetID{get; set;}	//MSPSNEWNG92142
		public String pricingScheduleID{get; set;}	//000330192142C
		public String pricingScheduleVersionID{get; set;}	//2839484
        public string diagnosisRelatedGroupCode {get;set;}
		public claimLines[] claimLines{get; set;}
        
	}
    public class messages{
        public string id{get; set;}
        public string description{get; set;}
    }
    
	public class claimLines{
        public String claimClassIDParent{get; set;}	//PROF
		public String manualReviewIndicatorParent{get; set;}	//false
		public String pricingSetIDParent{get; set;}	//MSPSNEWNG92142
		public String pricingScheduleIDParent{get; set;}	//000330192142C
		public String pricingScheduleVersionIDParent{get; set;}	//2839484
        public String revenueCode {get;set;}
        public String drgCode {get;set;}
		public String billedAmount{get; set;}	//250
		public String claimLineNumber{get; set;}	//1
		public String dateOfServiceFrom{get; set;}	//2018-07-09
		public String dateOfServiceThru{get; set;}	//2018-07-09
		public String placeOfServiceCode{get; set;}	//11
		public String serviceUnits{get; set;}	//1
		public String aggregateAllowAmount{get; set;}	//0
		public String aggregateAllowIncrease{get; set;}	//0
		public String apcAmount{get; set;}	//0
		public String aapAmount{get; set;}	//0
		public String apAmount{get; set;}	//0
		public String basePrice{get; set;}	//108.12
		public String basepricePercent{get; set;}	//0
		public String billedAjustAmount{get; set;}	//0
		public String ccPercentReductionAmount{get; set;}	//0
		public String ccPricedAmount{get; set;}	//0
		public componentDetailTierList[] componentDetailTierList{get; set;}
        public modifierPricedList[] modifierPricedList{get; set;}
		public String componentType{get; set;}	//PFS
		public String finalPricedAmount{get; set;}	//108.12
		public String gtbReductionAmount{get; set;}	//0
		public String netModifierReduction{get; set;}	//0
		public String notToExceedReduction{get; set;}	//0
		public String outlierGTBReduction{get; set;}	//0
		public String outlierPricedAmount{get; set;}	//108.12
		public String parentLineNumber{get; set;}	//0
		public String priced{get; set;}	//108.12
		public String pricedPercentReductionAmount{get; set;}	//0
		public String pricedPercent{get; set;}	//100
		public String pricingScheduleOrderID{get; set;}	//2869484
		public String procedureCodeType{get; set;}	//2
		public String procedureCode{get; set;}	//99214
		public String processedAmount{get; set;}	//108.12
		public String reviewIndicator{get; set;}	//false
		public String transferPriceReductionAmount{get; set;}	//0
        public messages[] messages{get; set;}
        public decimal totalPricedAmount {get;set;} // added for calculating priced amount
        
	}
     
   
	public class componentDetailTierList {
		public String calculationType{get; set;}	//FDPU
		public String pricingComponentDetailID{get; set;}	//244087442
		public String pricingComponentType{get; set;}	//PFS
	}
    
    public class modifierPricedList{
        public string modifierCode{get; set;}
    }
	
}