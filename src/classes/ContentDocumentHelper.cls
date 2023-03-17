public class ContentDocumentHelper {
    
    public static void trackDeleteRecords(Map<Id, ContentDocument> oldDocMap){
        List<SNI_FL_Activity_History__c> activityHistoryLst = new List<SNI_FL_Activity_History__c>();
        //get the contentDocumentLink with contentDocument Id 
        for(ContentDocumentLink docLink : [Select Id,LinkedEntityId,ContentDocumentId,ContentDocument.Title,Visibility from ContentDocumentLink where ContentDocumentId IN: oldDocMap.keyset()])
        {
            system.debug('deletetriggerhelper'+docLink);
            // Check for only files related to member INformation and Family Overview and also which is share with External Users 
            Schema.SObjectType sobjectType = docLink.LinkedEntityId.getSObjectType();
            string sobjectName = sobjectType.getDescribe().getName();
            if(docLink.LinkedEntityId != null && docLink.Visibility == 'AllUsers'  && (sobjectName == 'Member_Information__c' || sobjectName == 'Family_Overview__c')){
                SNI_FL_Activity_History__c actvtyHstry = new SNI_FL_Activity_History__c();
                actvtyHstry.Name = docLink.ContentDocumentId;
                actvtyHstry.New_Value__c = docLink.ContentDocument.Title;
                actvtyHstry.ParentID__c = docLink.LinkedEntityId;
                actvtyHstry.IsDeleted__c = true ;
                activityHistoryLst.add(actvtyHstry);
            }
            system.debug('deletetriggerhelper1'+activityHistoryLst);
        }
        if(activityHistoryLst.size()>0){
            Insert activityHistoryLst ;
        }
    }
    public static void handleAfterInsert(List<ContentDocument> triggerNew){
        for(ContentDocument curDocLink : triggerNew){
            // system.debug('conDocLinkRec after insert::'+curDocLink.Visibility);
            system.debug('curDocLink--after insert --ContentDocument title---'+curDocLink.title);
        }
    }
    public static void handleAfterUpdate(List<ContentDocument> triggerNew , map<id, ContentDocument> triggerNewMap, map<id, ContentDocument> triggerOldMap){
        set<string> ids = new set<string>();
        for(ContentDocument curDoc : triggerNew){
            if(curDoc.Title != triggerOldMap.get(curDoc.id).Title){
                ids.add(curDoc.id);   
            }
        }
        if(ids.size()>0){
            //set<string> docLinkids = new set<string>();
            map<string,ContentDocumentLink> linkDocIds = new map<string,ContentDocumentLink>();
            for(ContentDocumentLink curDL : [Select Id,LinkedEntityId,ContentDocumentId,ContentDocument.Title,Visibility from ContentDocumentLink where ContentDocumentId IN: ids]){
                if(curDL.LinkedEntityId != null){
                Schema.SObjectType sobjectType = curDL.LinkedEntityId.getSObjectType();
                string sobjectName = sobjectType.getDescribe().getName();
                if(curDL.LinkedEntityId != null && curDL.Visibility == 'AllUsers'  && (sobjectName == 'Member_Information__c' || sobjectName == 'Family_Overview__c')){
                   // docLinkids.add(curDL.id);
                    linkDocIds.put(curDL.id,curDL);
                }
                }
            }
            if(linkDocIds.size()>0){
                List<SNI_FL_Activity_History__c> activityHistoryLst = new List<SNI_FL_Activity_History__c>();
				map<string,SNI_FL_Activity_History__c> mapHIstory = new map<string,SNI_FL_Activity_History__c>();
				for(SNI_FL_Activity_History__c curRec : [select id,Name,New_Value__c,Old_Value__c,ParentID__c from SNI_FL_Activity_History__c where Name IN : linkDocIds.keyset() and Old_Value__c != null]){
				   mapHIstory.put(curRec.Name,curRec);
				}	
				for(string linId : linkDocIds.keyset()){
					ContentDocumentLink conDonLink = linkDocIds.get(linId);
					string docId = conDonLink.ContentDocumentId;
				    if(mapHIstory.containsKey(linId)){
						SNI_FL_Activity_History__c rec =  mapHIstory.get(linId);
						rec.New_Value__c = triggerNewMap.get(docId).Title;
                        rec.Old_Value__c = triggerOldMap.get(docId).Title;
                        activityHistoryLst.add(rec);
					}
					else{
					    SNI_FL_Activity_History__c newRec = new SNI_FL_Activity_History__c();
						newRec.New_Value__c = triggerNewMap.get(docId).Title;
						newRec.Old_Value__c = triggerOldMap.get(docId).Title;
						newRec.ParentID__c = conDonLink.LinkedEntityId;
						newRec.Name = linId;
						activityHistoryLst.add(newRec);
					}
				}
				if(activityHistoryLst.size()>0){
                    upsert activityHistoryLst;
                }
            }
        }
        
    
    }
    
}