public class CaseCommentCloneTriggerHandler {
    public static void handleAfterInsert(List<Case_Comment_Clone__c> triggerOldMap, map<id, Case_Comment_Clone__c> triggerNewMap){
        List<CaseComment> caseCom = new List<CaseComment>();
        List<Id> caseIds = new List<Id>();
        for(Case_Comment_Clone__c cc:triggerNewMap.values()){
            System.debug('**'+ cc.ParentId__c);
            System.debug('***'+cc.CommentBody__c);
            String updateComment =cc.CommentBody__c ;
            //truncated the string to fit into standard casecomment (it allows only 2900 due to encryption limitation)
            if(updateComment!= '' && updateComment != null && updateComment.length() > 2900){
                updateComment = updateComment.substring(0,2900);
            }
            CaseComment standardCasecomment = new CaseComment();
            standardCasecomment.CommentBody = updateComment;
            standardCasecomment.ParentId = cc.ParentId__c;
            standardCasecomment.IsPublished = cc.IsPublished__c;
            caseIds.add(cc.ParentId__c);
            caseCom.add(standardCasecomment);
        }
        try{
            insert caseCom;

            //Make a call to Notification center for sending SMS/Email about this new message [SMS/Email Notification feature]
            SNI_FL_CaseToROIHelper.handleNotificationsForCaseComment(caseIds); 
        }
        Catch(DMLException d){
            system.debug('DMLException'+d);
        }
        Catch(Exception e){
            system.debug('Exception'+e);
        }
        
    }
}