public without sharing  class ETSBE_CaseCommentRelatedListController {
	 @AuraEnabled
    Public static string getCaserecordtype(string caseId){
        string recordtypeName='';
        Case newCase=[select id,recordtype.name from case where id=: caseid];
        recordtypeName = newCase.recordtype.name;
        return recordtypeName;
    }
	@AuraEnabled
    public static List<CaseComment> getCaseComments(String caseId) {
      
        List<CaseComment> caseComments = 
            [SELECT Id, ParentId, IsPublished, CommentBody, CreatedDate, CreatedBy.Name, CreatedBy.userName ,LastModifiedDate, LastModifiedById FROM CaseComment 
             where parentId=:caseId order by CreatedDate desc limit 6];
        return caseComments;  
        } 
    
    @AuraEnabled
    public static List<Case> getCaseComments1(String caseId) {
        List<Case> caseList = 
            [Select Owner.Username,owner.name, (Select Id, ParentId, IsPublished, CommentBody, CreatedById, CreatedDate, SystemModstamp, LastModifiedDate, LastModifiedById, IsDeleted From CaseComments) From Case];
        
        return caseList;        
    }
    @AuraEnabled
    public static List<CaseComment> getRelatedList(string caseId) {
        
        List<CaseComment> caseCommentList=new List<CaseComment>();
        for(CaseComment  relatedList :  [SELECT Id, ParentId, IsPublished, CommentBody, CreatedDate, CreatedBy.Name, LastModifiedDate, LastModifiedById FROM CaseComment 
                                         where parentId=:caseId  ]){
                                             caseCommentList.add(relatedList);
                                         }
        return caseCommentList;
    }
    
    @AuraEnabled
    public static CaseComment addCaseComment(String caseId, String commentBody,boolean Published) {
        try{
           /* integer x;
            x=100/0;*/
        CaseComment caseComment = new CaseComment(ParentId=caseId, CommentBody=commentBody,IsPublished=Published);
        insert caseComment;
        return caseComment; 
        }catch(DmlException ex){
               throw new AuraHandledException (
           ex.getMessage());    
        
}
              
    }    
    @AuraEnabled
    public static List<CaseComment> deleteComment(String Cid){
        System.debug('In controller delteAccountById method..');
        CaseComment del=[Select Id from CaseComment where id=:Cid];
        delete del;
        return [SELECT Id, ParentId, IsPublished, CommentBody, CreatedDate, CreatedBy.Name, LastModifiedDate, LastModifiedById FROM CaseComment 
                where parentId=:Cid order by CreatedDate desc];
        
    }
}