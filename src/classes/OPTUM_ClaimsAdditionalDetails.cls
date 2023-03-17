/*
Name : OPTUM_ClaimsAdditionalDetails
Created By : Sanjay Pandey
Created Date : Jan 15th, 2021
Description : US3198984: Integration: Field mapping-Claims (RMI & Admin Notes)
*/
public class OPTUM_ClaimsAdditionalDetails {
        @AuraEnabled
        public String responseCode;
        @AuraEnabled
        public String responseMsg;
		
    public class RmiNotes {
        @AuraEnabled
        public String adminAlias;
        @AuraEnabled
        public String employerAlias;
        @AuraEnabled
        public String external_id;
        @AuraEnabled
        public Integer offering_id;
        @AuraEnabled
        public Integer actionId;
        @AuraEnabled
        public Integer actionType;
        @AuraEnabled
        public Object actionAmount;
        @AuraEnabled
        public String rmiNote;
        @AuraEnabled
        public String actionTs;
        @AuraEnabled
        public String user;
        @AuraEnabled
        public String reason;
        @AuraEnabled
        public String rmiCode;
        @AuraEnabled
        public String status;
        @AuraEnabled
        public Integer expenseId;
    }

    public class Status {
        @AuraEnabled
        public List < Messages > messages;
    }

    public class Meta {}

    public class AdminNotes {
        @AuraEnabled
        public Integer noteId;
        @AuraEnabled
        public String noteTs;
        @AuraEnabled
        public String adminNote;
        @AuraEnabled
        public Integer noteType;
        @AuraEnabled
        public String user;
        @AuraEnabled
        public Integer expenseId;
    }
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
    @AuraEnabled
    public Meta meta;
    @AuraEnabled
    public Result result;
    @AuraEnabled
    public Status status;
    public class Data {
        @AuraEnabled
        public Claim claim;
    }
    public class Claim {
        @AuraEnabled
        public String id;
        @AuraEnabled
        public String claimNumber;
        @AuraEnabled
        public List < RmiNotes > rmiNotes;
        @AuraEnabled
        public List < AdminNotes > adminNotes;
    }
    public class Result {
        @AuraEnabled
        public Meta resultMeta;
        @AuraEnabled
        public Data data;
    }
    public static OPTUM_ClaimsAdditionalDetails parse(String json) {
        return (OPTUM_ClaimsAdditionalDetails) System.JSON.deserialize(json, OPTUM_ClaimsAdditionalDetails.class);
    }
}