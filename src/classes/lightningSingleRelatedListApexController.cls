public class lightningSingleRelatedListApexController {
    @AuraEnabled
    public static List<Case> getCaseFromId(Id accountId) {
        List<Case> caseList = new List<Case>();
        caseList = [select id, Care_Plan_Name__c,Caller__c,Contact.FirstName,Contact.LastName  from case where AccountId =:accountId and RecordType.Name = 'Case Overview'];
        return caseList;
    }
    
}