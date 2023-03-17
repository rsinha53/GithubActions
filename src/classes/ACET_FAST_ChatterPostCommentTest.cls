/*****************************************************************************************************
ACET_FAST_ChatterPostCommentTest
Testing Trigger Name:  silk_ChatterFeedPost
Author: Karimulla Shaik
Date: 02/11/2021
Description: This is test class and used to get test coverage for silk_ChatterFeedPost. 
******************************************************************************************************/
@isTest
public class ACET_FAST_ChatterPostCommentTest {
    
    public static testmethod void delPost(){
        case caseRec = ACET_Fast_TestDataFactory.getCaseRecord('Reactive_Resolution','Open');
        insert caseRec;
        
        FeedItem post =  new FeedItem();
        post.ParentId = caseRec.Id;
        post.Body = 'Post message';
        
        insert post;   
        try
        {   
            delete post;
        }        
        //Validate error is thrown
        catch(Exception e)
        {
            System.Assert(e.getMessage().contains('You are not allowed to delete any feed posts.'));
        }        
    }
    
    public static testmethod void delComment(){
        case caseRec = ACET_Fast_TestDataFactory.getCaseRecord('Reactive_Resolution','Open');
        insert caseRec;
        
        FeedItem post =  new FeedItem();
        post.ParentId = caseRec.Id;
        post.Body = 'Post message';
        
        insert post;
        FeedComment comment = new FeedComment();
        comment.FeedItemId = post.Id;
        comment.CommentBody = 'Comment Message';
        
        Insert comment;
        
        try
        {   
            delete comment;
        }        
        //Validate error is thrown
        catch(Exception e)
        {
            System.Assert(e.getMessage().contains('You are not allowed to delete any feed comments.'));
        }                
    }    
}