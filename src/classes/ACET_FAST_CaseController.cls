/*************************************************************************************************************
* @name			ACET_FAST_CaseController
* @author			mrajen15 <muthukumarr@optum.com>
* @created			08 / 11 / 2020
* @description		This class is used to manage FAST Case Records
*
* Changes (version)
* -----------------------------------------------------------------------------------------------------------
* 				No.		Date			Author					Description
* 				----	------------	--------------------	----------------------------------------------
* @version		1.0		2020-11-08		mrajen15				Changes desription
*
**************************************************************************************************************/
public with sharing class ACET_FAST_CaseController {
    public static final String POST_ERROR = 'You are not allowed to delete any feed posts.';
    public static final String COMMENT_ERROR = 'You are not allowed to delete any feed comments.';
    public static Boolean isFirstTime = true;
    
    @AuraEnabled
    public static case getAccountRecord(Id recordId){        
        return [SELECT Id, Account.Provider_Contact__c,Account.Provider_Contact_Email__c, Account.Provider_Contact_Phone__c,Account.Provider_Contact_Preference__c FROM Case WHERE Id =: recordId LIMIT 1];
    }
    
    public static void handleFeedPostDelete (List<FeedItem> triggerOld){
        for (FeedItem post : triggerOld){
            post.addError(POST_ERROR);
        }
    }
    
    public static void handleFeedCommentDelete (List<FeedComment> triggerOld){
        for (FeedComment comment : triggerOld){
            comment.addError(COMMENT_ERROR);
        }
    }
}