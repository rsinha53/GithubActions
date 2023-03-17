public with sharing class OPTUM_InvestmentsSummeryResponse{
    @AuraEnabled
    public String responseCode;
    @AuraEnabled
    public String responseMsg;  
    @AuraEnabled
	public cls_meta meta;
	@AuraEnabled
	public cls_result result;
	@AuraEnabled
	public cls_status status;
	class Cls_meta {
	}
	class Cls_result {
	    @AuraEnabled
		public cls_resultMeta resultMeta;
		@AuraEnabled
		public cls_data data;
	}
	class Cls_resultMeta {
	}
	class Cls_data {
	    @AuraEnabled
        public String syntheticId;
        @AuraEnabled
        public String investmentAccountStatus;
        @AuraEnabled
        public Integer investmentThresholdAmount;
        @AuraEnabled
        public Integer minimumTransferAmount;
        @AuraEnabled
        public Double cashBalance;
        @AuraEnabled
        public Double amountAvailableToTransfer;
        @AuraEnabled
        public boolean eConsentResubmissionRequired;
        @AuraEnabled
        public String sweepStatus;
        @AuraEnabled
        public Integer srtid;
        @AuraEnabled
        public String planName;
        @AuraEnabled
        public boolean tradeAgreementResubmissionRequired;
        @AuraEnabled
        public Double sweepAmount;
        @AuraEnabled
        public String sweepAccount; //MTL
        @AuraEnabled
        public Double investmentTotalBalance;
        @AuraEnabled
        public Integer investmentHSBAStatusCode;
        @AuraEnabled
        public String investmentHSBAStatus;
        @AuraEnabled
        public Integer investmentHSBATotalBalance;
        @AuraEnabled
        public Integer investmentHSBACashBalance;
        @AuraEnabled
        public Integer investmentHSBAFundBalance;
        @AuraEnabled
        public Integer investmentBMTStatusCode;
        @AuraEnabled
        public String investmentBMTStatus;
        @AuraEnabled
        public Integer investmentBMTTotalBalance;
        @AuraEnabled
        public boolean eConsent;
        @AuraEnabled
        public boolean tradeAgreement;
        @AuraEnabled
        public String eConsentDate;
        @AuraEnabled
        public String tradeAgreementDate;
        @AuraEnabled
        public Integer investmentAccountStatusCode;
		@AuraEnabled
		public cls_investmentPlans[] investmentPlans;
	}
	class Cls_investmentPlans {
	    @AuraEnabled
		public Integer srtid;
		@AuraEnabled
		public String planName;
		@AuraEnabled
		public Double balance;
		@AuraEnabled
		public String status;	//Inactive
        @AuraEnabled
		public cls_funds[] funds;
	}
	class Cls_funds {
	    @AuraEnabled
		public String fundName;
		@AuraEnabled
		public String tickerSymbol;
		@AuraEnabled
		public String assetClass;
        @AuraEnabled		
		public String morningStarUrl;
		@AuraEnabled
		public Integer positionNumber;
		@AuraEnabled
		public String fundTradingBlockPolicy;
		@AuraEnabled
		public Integer redemptionFees;
		@AuraEnabled
		public boolean tradingBlockFlag;
	}
	class Cls_status {
        @AuraEnabled
		public cls_messages[] messages;
	}
	class Cls_messages {
	    @AuraEnabled
		public String code;	//0000
		@AuraEnabled
		public String name;	//Success
		@AuraEnabled
		public String severity;	//INFO
		@AuraEnabled
		public String description;	//Request Successfully Processed
	}
	public static OPTUM_InvestmentsSummeryResponse parse(String json){
		return (OPTUM_InvestmentsSummeryResponse) System.JSON.deserialize(json, OPTUM_InvestmentsSummeryResponse.class);
	}
}