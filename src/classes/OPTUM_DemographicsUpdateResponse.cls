/*
Name : OPTUM_DemographicsUpdateResponse
Created By : Sanjay Pandey
Created Date : Dec 23rd, 2020
Description : US3141824: Response class for Demographics Update
*/
public class OPTUM_DemographicsUpdateResponse {
    @AuraEnabled
    public String responseCode;
    @AuraEnabled
    public String responseMsg;
    public class Status {
        @AuraEnabled
        public List < Messages > messages;
    }
    public class Meta {}
    public class Messages {
        @AuraEnabled
        public String code;
        @AuraEnabled
        public String name;
        @AuraEnabled
        public String severity;
        @AuraEnabled
        public String description;
    }
    public class Data {
        @AuraEnabled
        public Boolean emailAddrDispFlag;
        @AuraEnabled
        public String emailAddress;
        @AuraEnabled
        public Boolean emailAddrUpdFlag;
        @AuraEnabled
        public Boolean mailAddrDispFlag;
        @AuraEnabled
        public String addressLine1;
        @AuraEnabled
        public String addressLine2;
        @AuraEnabled
        public String city;
        @AuraEnabled
        public String state;
        @AuraEnabled
        public String zip;
        @AuraEnabled
        public String zipPlus4;
        @AuraEnabled
        public Boolean mailAddrUpdFlag;
        @AuraEnabled
        public Boolean phoneHomeDispFlag;
        @AuraEnabled
        public String homePhone;
        @AuraEnabled
        public Boolean phoneHomeUpdFlag;
        @AuraEnabled
        public Boolean phoneWorkDispFlag;
        @AuraEnabled
        public String workPhone;
        @AuraEnabled
        public Boolean phoneWorkUpdFlag;
        @AuraEnabled
        public Boolean phoneMobileDispFlag;
        @AuraEnabled
        public String mobilePhone;
        @AuraEnabled
        public Boolean phoneMobileUpdFlag;
        @AuraEnabled
        public String capUpdate;
        @AuraEnabled
        public String fiservUpdate;
        @AuraEnabled
        public String camsUpdate;
        @AuraEnabled
        public String wexUpdate;
        @AuraEnabled
        public String fisUpdate;
		@AuraEnabled
        public String preferredPhoneType;
    }
    @AuraEnabled
    public Meta meta;
    @AuraEnabled
    public Result result;
    @AuraEnabled
    public Status status;
    public class Result {
        @AuraEnabled
        public Meta resultMeta;
        @AuraEnabled
        public Data data;
    }
    public static OPTUM_DemographicsUpdateResponse parse(String json) {
        return (OPTUM_DemographicsUpdateResponse) System.JSON.deserialize(json, OPTUM_DemographicsUpdateResponse.class);
    }
}