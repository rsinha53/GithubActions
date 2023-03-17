@isTest
public class CaseCommentCloneTriggerHandlerTest {
    @isTest static void ACETORSReadWSMethod1() 
    {
        Case cas = TestDataFactory.createCases(1)[0];
        cas.ORS_Macess__c = 'testIssueId123';
        //cas.Type__c = 'Claims';  
        insert cas;
        Test.startTest();
        Case_Comment_Clone__c newComment = new Case_Comment_Clone__c();
        newComment.CommentBody__c = 'This comment is the test comment';
        newComment.ParentId__c = cas.Id ;
        newComment.OwnerId = UserInfo.getUserId();
        Insert newComment;
        System.assertNotEquals(null, newComment.Id);
        Test.stopTest();
    }
     @isTest static void ACETORSReadWSMethod2() 
    {
        Case cas = TestDataFactory.createCases(1)[0];
        cas.ORS_Macess__c = 'testIssueId123';
        //cas.Type__c = 'Claims';  
        insert cas;
        Test.startTest();
        Case_Comment_Clone__c newComment = new Case_Comment_Clone__c();
        String comments ='This comment is the test comment.';
        for(Integer i = 0, j = 0; i < 100; i++){
          newComment.CommentBody__c =newComment.CommentBody__c+comments;
        }
        newComment.ParentId__c = cas.Id ;
        newComment.OwnerId = UserInfo.getUserId();
        Insert newComment;
        System.assertNotEquals(null, newComment.Id);
        Test.stopTest();
    }
}