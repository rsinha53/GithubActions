@isTest
public class ETSBE_CaseCommentRelatedList_Test {
    
    static testMethod  void createTestData(){
        test.startTest();
        Case   tCase = new Case();        
        tCase.Status = 'Open';
        tCase.Description = 'Test Description';
        tCase.Origin = 'Annuity External';
        tCase.Type = 'Feature Request';
        tCase.Priority = 'Low';
        INSERT tCase;
        
        CaseComment   tComment = new CaseComment();
        tComment.ParentId = tCase.Id;
        tComment.CommentBody = 'Some Comment';
        tComment.IsPublished = TRUE;
        INSERT tComment;
        
        CaseComment   tComment1 = new CaseComment();
        tComment1.ParentId = tCase.Id;
        tComment1.CommentBody = 'Some Comment';
        tComment1.IsPublished = false;
        INSERT tComment1;
        
        ETSBE_CaseCommentRelatedListController.getCaseComments(tCase.Id);
        ETSBE_CaseCommentRelatedListController.getRelatedList(tCase.Id);
        ETSBE_CaseCommentRelatedListController.addCaseComment(tCase.Id, 'test', false);
        ETSBE_CaseCommentRelatedListController.getCaseComments1(tCase.Id);
        ETSBE_CaseCommentRelatedListController.deleteComment(tComment1.Id);
        test.stopTest();
    }
    
    
}