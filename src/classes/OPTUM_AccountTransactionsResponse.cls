public class OPTUM_AccountTransactionsResponse {
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
        @AuraEnabled
		public cls_pagination pagination;
	}
	class Cls_pagination {
        @AuraEnabled
		public Integer start;	
        @AuraEnabled
		public Integer count;	
        @AuraEnabled
		public Integer totalResults;	
	}
	class Cls_data {
        @AuraEnabled
		public cls_transactions[] transactions;
	}
	class Cls_transactions {
        @AuraEnabled
		public String syntheticId;	//NHw5MDQwMzczMzN8bnVsbHxPUFR8SFNBfG51bGx8bnVsbA==
        @AuraEnabled
		public String type;	//PROCESSED
        @AuraEnabled
		public String debitOrCreditType;	
        @AuraEnabled
		public String convertAmount;//PROCESSED
        @AuraEnabled
		public String transactionDate;
        @AuraEnabled
		public String tranDate;	//2020-07-31
        @AuraEnabled
		public String description;	
        @AuraEnabled
		public Double amount;	//-10
        @AuraEnabled
		public Integer transactionCode;	
        @AuraEnabled
		public String transactionId;	
        @AuraEnabled
		public String traceNumber;	
        @AuraEnabled
		public String documentNumber;
        @AuraEnabled
		public String hash;	
        @AuraEnabled
		public String externalAcctId;	
        @AuraEnabled
		public String payeeId;	
        @AuraEnabled
		public String payeeName;	
        @AuraEnabled
		public String reimbursementInd;	
        @AuraEnabled
		public String memo;
        @AuraEnabled
		public String descriptionMemo;		
        @AuraEnabled
		public String nsfCount;	
        @AuraEnabled
		public String scheduledType;	
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
     public static OPTUM_AccountTransactionsResponse parse(String json){
        system.debug('json' + json);
        return (OPTUM_AccountTransactionsResponse) System.JSON.deserialize(json, OPTUM_AccountTransactionsResponse.class);
        
    }
}