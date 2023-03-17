public class ACETWSCalloutResult
{	
    @AuraEnabled public Boolean Success { get; set; }
    @AuraEnabled public String Message { get; set; }
    @AuraEnabled public Object Response { get; set; }
    @AuraEnabled public ApexPages.Severity MessageSeverity { get; set; }
    @AuraEnabled public String responseBody {get;set;}
    @AuraEnabled public String pageNumber {get;set;}
    @AuraEnabled public String pageSize {get;set;}
    @AuraEnabled public String recordCount {get;set;}
    @AuraEnabled public String totalCount {get;set;}
    @AuraEnabled public String totalPages {get;set;}
    @AuraEnabled public Boolean hasNextPage {get;set;}
    @AuraEnabled public Integer statusCode {get;set;}
    @AuraEnabled public Boolean showToastMessage { get; set; }
    @AuraEnabled public String providerId {get; set;}
    @AuraEnabled public Attachment Attach{get;set;}
    
	public ACETWSCalloutResult()
    {
        pageNumber = '0';
        pageSize = '50';
        recordCount = '0';
        totalCount = '0';
        totalPages = '0';
    }
        
}