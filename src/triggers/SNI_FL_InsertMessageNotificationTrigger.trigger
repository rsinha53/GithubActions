/*
Trigger Name    : SNI_FL_InsertMessageNotificationTrigger
Description     : Trigger created to insert data into MessageNotification__c object on data insertion to FeedComment
Created By      : Pavithra Fernando
Created Date    : 12/10/2020

Modification Log: 
Developer                   Date                   Description
Muthukumar					02/12/2021			User should not able to delete any FeedComment
*/
trigger SNI_FL_InsertMessageNotificationTrigger on FeedComment (after insert,before delete) {
    
    if(Trigger.isAfter && Trigger.isInsert){   
        
        SNI_FLDirectMessageObjectQuery.insertMessageNotification(trigger.new);
    }
    
    /*US3262144 - Ability to NOT delete the post and comments in Chatter*/
    if(Trigger.isBefore && Trigger.isDelete){        
        ACET_FAST_CaseController.handleFeedCommentDelete(Trigger.old);        
    }
      /*US3262144 - Ability to NOT delete the post and comments in Chatter - End*/
}