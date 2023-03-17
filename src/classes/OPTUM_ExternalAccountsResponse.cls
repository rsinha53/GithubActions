public class OPTUM_ExternalAccountsResponse{
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
		public cls_externalAccountsList[] externalAccountsList;
	}
	class Cls_externalAccountsList {
	    @AuraEnabled
		public String syntheticId;
		@AuraEnabled
		public String nickname;	
		@AuraEnabled
		public String bankName;	
		@AuraEnabled
		public String bankRoutingNumber;
		@AuraEnabled
		public String bankAccountNumber;
		@AuraEnabled
		public String bankAccountType;
		@AuraEnabled
		public String bankAccountStatus;
        @AuraEnabled
		public String dateAdded;
		@AuraEnabled
		public String dateVerified;
        @AuraEnabled
		public String cmpdateAdded;
		@AuraEnabled
		public String cmpdateVerified;
		@AuraEnabled
		public boolean hasScheduledTransactions;
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
	public static OPTUM_ExternalAccountsResponse parse(String json){
		return (OPTUM_ExternalAccountsResponse) System.JSON.deserialize(json, OPTUM_ExternalAccountsResponse.class);
	}

	
}