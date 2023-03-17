trigger SNI_FL_InsertCaseCommentTrigger on CaseComment (after insert) {                                
    if(!SNI_FLDirectMessageUtil.insertCaseCommentNotificationRecursiveCheck){
        if(System.Limits.getLimitQueries() - System.Limits.getQueries() >= 4 ){
            SNI_FLDirectMessageObjectQuery.insertCaseCommentNotification(trigger.new);
        }
        SNI_FLDirectMessageUtil.insertCaseCommentNotificationRecursiveCheck= true;
    }                                                       
    
}