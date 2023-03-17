public with sharing class ACETSNIITE_caseHistory {
   
    @AuraEnabled
    public static List<Case> getCaseHistoryResults(String accId){
        
       List<Case> relatedCases = new List<Case>(); 
       /*  
            relatedCases = [SELECT CaseNumber,Case_Name__c,Case_Owner__c,Subject_Name__c,Topic__c,Case_Type__c,
                        Subject_Type__c,Status,Priority,ORS_Macess__c FROM Case WHERE AccountId =: accId order BY CreatedDate desc ];
            return relatedCases;
		*/
        string memId ;
        string polId ;
        List<Id>  listIds1 = new List<Id>();
        for(AccountContactRelation curAccConRel : [Select accountId,contactid,contact.accountId,account.member_Id__c,account.policy_Id__c from AccountContactRelation where accountId =: accId]){  // and account.member_Id__c != null and account.policy_Id__c != null
            listIds1.add(curAccConRel.contact.accountId);
            memId = curAccConRel.account.member_Id__c;
            polId =  curAccConRel.account.policy_Id__c;
        }
        for(Case c : [SELECT CaseNumber,Case_Name__c,Case_Owner__c,Subject_Name__c,Topic__c,toLabel(Case_Type__c),
                      Subject_Type__c,Status,Priority,ORS_Macess__c,CreatedDate,ID__c,Subject_Group_ID__c FROM Case WHERE AccountId IN :listIds1 and RecordType.name= 'ECM' and Case_Type__c='Opportunity' and ID__c != null and Subject_Group_ID__c != null order BY CreatedDate desc ]){
                          if(c.ID__c == memId && polId == c.Subject_Group_ID__c)   {
                              relatedCases.add(c);
                          }        
        
        }
       return relatedCases;
    
    }
    /*
    @AuraEnabled
    public static List<CaseComment> getCaseComments(ID caseId){
                  List<CaseComment> cc = new List<CaseComment>(); 
        cc = [SELECT Id, ParentId, CreatedBy.Name, CommentBody, CreatedDate FROM CaseComment WHERE ParentId =: caseId order BY CreatedDate desc];
        return cc;
    }
    
    @AuraEnabled(cacheable=true) 
    public static List<Case_Item__c> getExternalId(ID caseId){
                             List<Case_Item__c> ci = new List<Case_Item__c>(); 
        ci = [SELECT ExternalID__c,Resolved__c FROM Case_Item__c WHERE Case__c =: caseId ];
       return ci;
    }
   
    
    @AuraEnabled(cacheable=true) 
    public static List<CaseComment> getCommentResults(String idNum){
        
        List<CaseComment> commentList = new List<CaseComment>(); 
        commentList = [Select Id, ParentId, IsPublished, CommentBody, CreatedById, CreatedDate, LastModifiedDate, LastModifiedById, IsDeleted From CaseComment where ParentId =:idNum];
       
        return commentList;
        
    }
    */
    
}