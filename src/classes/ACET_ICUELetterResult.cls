public class ACET_ICUELetterResult {
    
    @AuraEnabled public List<ResponseData> icueletterResLst {get;set;} 
    
    public class ResponseData{
        @AuraEnabled public String createdDate {get;set;}
        @AuraEnabled public String securityGroup {get;set;}
        @AuraEnabled public String caseId {get;set;}
        @AuraEnabled public String title {get;set;}
        @AuraEnabled public String docId {get;set;}
        @AuraEnabled public Integer fileSize {get;set;}
        @AuraEnabled public String deliveryMethod {get;set;}
        @AuraEnabled public String processDate {get;set;}
        @AuraEnabled public String letterId {get;set;}
        @AuraEnabled public String mailDate {get;set;}
        @AuraEnabled public String subjectDOB {get;set;}
        @AuraEnabled public String subjectFname {get;set;}
        @AuraEnabled public String subjectLname {get;set;}
        @AuraEnabled public String status {get;set;}
        @AuraEnabled public String recipientType {get;set;}
    }

}