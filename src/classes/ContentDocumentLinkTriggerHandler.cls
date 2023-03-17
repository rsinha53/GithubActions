public class ContentDocumentLinkTriggerHandler {
   /* handle after update logic */
    public static void handleAfterUpdate(List<ContentDocumentLink> triggerNew , map<id, ContentDocumentLink> triggerOldMap){
        
        set<string> linkIds = new set<string>();
        for(ContentDocumentLink curDocLink : triggerNew){
            system.debug('conDocLinkRec after update::'+curDocLink.Visibility);
            Schema.SObjectType sobjectType = curDocLink.LinkedEntityId.getSObjectType();
            string sobjectName = sobjectType.getDescribe().getName();
            if(curDocLink.LinkedEntityId != null && (sobjectName == 'Member_Information__c' || sobjectName == 'Family_Overview__c')){
          //  if(curDocLink.LinkedEntityId != null && String.valueof(curDocLink.LinkedEntityId).startswith('a19') || String.valueof(curDocLink.LinkedEntityId).startswith('a14')){
                if(curDocLink.Visibility == 'AllUsers' && triggerOldMap.get(curDocLink.id).Visibility == 'InternalUsers'){
                   linkIds.add(curDocLink.id);
                }
            } 
        }
        if(linkIds.size()>0){
             List<SNI_FL_Activity_History__c> activityHistoryLst = new List<SNI_FL_Activity_History__c>();
             for(ContentDocumentLink curRec : [select id,ContentDocument.title,LinkedEntityId,Visibility from ContentDocumentLink where id In :linkIds]){
                SNI_FL_Activity_History__c actvtyHstry = new SNI_FL_Activity_History__c();
                actvtyHstry.Name = curRec.id;
                actvtyHstry.New_Value__c = curRec.ContentDocument.title;
                actvtyHstry.ParentID__c = curRec.LinkedEntityId;
               //actvtyHstry.IsDeleted__c = false ;
               activityHistoryLst.add(actvtyHstry);
             }
            if(activityHistoryLst.size()>0){
                insert activityHistoryLst;
            }
        }

    }
    
/* handle after insert logic */
     public static void handleAfterInsert(List<ContentDocumentLink> triggerNew , map<id, ContentDocumentLink> triggerNewMap){
        
        set<string> linkIds = new set<string>();
        for(ContentDocumentLink curDocLink : triggerNew){
            system.debug('conDocLinkRec after update::'+curDocLink.Visibility);
            Schema.SObjectType sobjectType = curDocLink.LinkedEntityId.getSObjectType();
            string sobjectName = sobjectType.getDescribe().getName();
            //if(curDocLink.LinkedEntityId != null && (sobjectName == 'Member_Information__c' || sobjectName == 'Family_Overview__c')){
            if(curDocLink.LinkedEntityId != null && curDocLink.Visibility == 'AllUsers' && (sobjectName == 'Member_Information__c' || sobjectName == 'Family_Overview__c' ) ){
                linkIds.add(curDocLink.id);
            } 
        }
        if(linkIds.size()>0){
             List<SNI_FL_Activity_History__c> activityHistoryLst = new List<SNI_FL_Activity_History__c>();
             for(ContentDocumentLink curRec : [select id,ContentDocument.title,LinkedEntityId,Visibility from ContentDocumentLink where id In :linkIds]){
                SNI_FL_Activity_History__c actvtyHstry = new SNI_FL_Activity_History__c();
                actvtyHstry.Name = curRec.id;
                actvtyHstry.New_Value__c = curRec.ContentDocument.title;
                actvtyHstry.ParentID__c = curRec.LinkedEntityId;
               //actvtyHstry.IsDeleted__c = false ;
               activityHistoryLst.add(actvtyHstry);
             }
            if(activityHistoryLst.size()>0){
                insert activityHistoryLst;
            }
        }

    }
    
}