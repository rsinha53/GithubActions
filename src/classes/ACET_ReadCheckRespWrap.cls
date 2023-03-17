Public class ACET_ReadCheckRespWrap{
	@AuraEnabled public Meta meta {get;set;}
	@AuraEnabled public Data data {get;set;}
	class Meta {
		@AuraEnabled public Warnings[] warnings {get;set;}
	}
	class Warnings {
	}
	class Data {
		@AuraEnabled public String status {get;set;}
		@AuraEnabled public String statusDescription {get;set;}
		@AuraEnabled public String checkTotal {get;set;}
		@AuraEnabled public String cashedDate {get;set;}
		@AuraEnabled public String issuedDate {get;set;}
		@AuraEnabled public String account {get;set;}
		@AuraEnabled public String bankId {get;set;}
		@AuraEnabled public String docId {get;set;}
		@AuraEnabled public String voidDate {get;set;}
		@AuraEnabled public String returnedDate {get;set;}
		@AuraEnabled public String remailedDate {get;set;}
		@AuraEnabled public String platform {get;set;}
		@AuraEnabled public String division {get;set;}
		@AuraEnabled public String itemId {get;set;}
	}
}