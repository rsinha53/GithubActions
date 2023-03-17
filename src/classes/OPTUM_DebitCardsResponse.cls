public with sharing class OPTUM_DebitCardsResponse{
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
		public cls_debitCards[] debitCards;
	}
	class Cls_debitCards {
        @AuraEnabled
		public String syntheticId;	
        @AuraEnabled
		public String syntheticIdAccount;	
        @AuraEnabled
		public Integer accountCode;	
        @AuraEnabled
		public String accountAlias;	
        @AuraEnabled
		public String employerId;	
        @AuraEnabled
		public String accountId;	
        @AuraEnabled
		public String accountType;	
        @AuraEnabled
		public String depFaroId;
        @AuraEnabled
		public String cardDigits;	
        @AuraEnabled
		public String embossedName;	
        @AuraEnabled
		public String requestDate;
        @AuraEnabled
		public String orderDate;// added by srikanya
        @AuraEnabled
		public String expirationDate;	
        @AuraEnabled
		public String status;	
        @AuraEnabled
		public String statusCode;
        @AuraEnabled
		public String cardProxy;
        @AuraEnabled
		public String cardType;	
        @AuraEnabled
		public String cardholderFirstName;	
        @AuraEnabled
		public String cardholderLastName;	
        @AuraEnabled
		public String cardholderMiddleName;
        @AuraEnabled
		public String vip;
        @AuraEnabled
		public String lastUpdatedDate;	
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
		public String description;	//Successfully Processed
	}
	
	public static OPTUM_DebitCardsResponse parse(String json){
        system.debug('@@json' + json);
		return (OPTUM_DebitCardsResponse) System.JSON.deserialize(json, OPTUM_DebitCardsResponse.class);
	}
	
}