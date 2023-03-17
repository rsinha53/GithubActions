public with sharing class OPTUM_NotificationsResponse{
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
		public Integer futureDoc;
        @AuraEnabled 
		public Integer privacyStatement;
        @AuraEnabled 
		public Integer statement;
        @AuraEnabled 
		public Integer taxDoc;	
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
	public static OPTUM_NotificationsResponse parse(String json){
        system.debug('@@json'+json);
		return (OPTUM_NotificationsResponse) System.JSON.deserialize(json, OPTUM_NotificationsResponse.class);
	}

}