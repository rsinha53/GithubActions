public class ACET_ECAALetterResult {
    
    @AuraEnabled public List<ResponseData> ecaaletterResLst {get;set;} 
    
    public class ResponseData{
        @AuraEnabled public String createdDate {get;set;}
        @AuraEnabled public String securityGroup {get;set;}
        @AuraEnabled public String caseId {get;set;}
        @AuraEnabled public String title {get;set;}
        @AuraEnabled public String docId {get;set;}
        @AuraEnabled public String fileSize {get;set;}
    }

}