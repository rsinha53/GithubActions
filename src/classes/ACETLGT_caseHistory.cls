public class ACETLGT_caseHistory {
    
    @AuraEnabled
    public static List<Case> getCaseHistoryResults(String memSRK){

        system.debug('>>>casehistory1'+memSRK);
        list<string> tmpVar1 = new list<String>();
        if(memSRK.contains(','))
            tmpVar1 = memSRK.split(',');
        else
            tmpVar1.add(memSRK);
        
        List<Case> relatedCases = new List<Case>(); 
        if(!tmpVar1.isEmpty()){
        relatedCases = [SELECT Parent.Id,Caller__c,Parent.CaseNumber,CaseNumber, Contact.Name, CreatedBy.Name, CreatedDate, Topic__c, Status, Original_Type__c,Original_Subtype__c,
                                      Originator_Type__c,  Interaction_Type__c, Interaction__r.Name,Interaction__c,Subject_Name__c, Rollup_Fulfillment__c, Owner.Name,
                                      (SELECT Id, Name FROM Create_Letters__r),CreatedById,Created_By_name__c FROM Case WHERE Surrogate_Key__c in :tmpVar1 order BY CreatedDate desc];
        }
       
        return relatedCases;
        
    }
    @AuraEnabled
    public static List<CaseComment> getCaseComments(ID caseId){
        List<CaseComment> cc = new List<CaseComment>(); 
        cc = [SELECT Id, ParentId, CreatedBy.Name, CommentBody, CreatedDate FROM CaseComment WHERE ParentId =: caseId order BY CreatedDate desc];
        return cc;
    }
    
   @AuraEnabled
    public static List<Case_Item__c> getExternalId(ID caseId){
        List<Case_Item__c> ci = new List<Case_Item__c>(); 
        ci = [SELECT ExternalID__c,Resolved__c FROM Case_Item__c WHERE Case__c =: caseId ];
       return ci;
    }
    /*@AuraEnabled(cacheable=true) 
    public static List<Case> getSearchResults(String memSRK,String originatorType, Integer minRecs){
        List<Case> relatedCases = new List<Case>(); 
        if(minRecs != null && minRecs != 0)
            relatedCases = [SELECT Id,CaseNumber,Topic__c,CreatedById,Created_By_name__c,CreatedDate FROM Case WHERE Surrogate_Key__c =: memSRK order BY CreatedDate desc limit :minRecs];
        else 
            relatedCases = [SELECT Id,CaseNumber,Topic__c,CreatedById,Created_By_name__c,CreatedDate FROM Case WHERE Surrogate_Key__c =: memSRK order BY CreatedDate desc];
        System.debug('>>relatedCases'+relatedCases);
        return relatedCases;
        
    }*/
    
    @AuraEnabled
    public static List<CaseComment> getCommentResults(String idNum){
        
        List<CaseComment> commentList = new List<CaseComment>(); 
        commentList = [Select Id, ParentId, IsPublished, CommentBody, CreatedById, CreatedDate, LastModifiedDate, LastModifiedById, IsDeleted From CaseComment where ParentId =:idNum];
       
        return commentList;
        
    }
}