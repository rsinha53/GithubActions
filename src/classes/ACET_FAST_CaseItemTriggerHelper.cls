/*****************************************************************************************************
ACET_FAST_CaseItemTriggerHelper
Test Class Name:  ACET_FAST_CaseItemTriggerHelperTest
Author: Shaik Mohammad Yaseen
Description: This class is used an helper for ACET_FAST_CaseItemTrigger Trigger. 
US3504044 - Root Cause fields - Case Items Related list - Part 2
09/05/2021 - Shaik Mohammad Yaseen - Initial
******************************************************************************************************/
public with sharing class ACET_FAST_CaseItemTriggerHelper {
    
    public static Id fastRecordTypeId = Schema.SObjectType.Case.getRecordTypeInfosByDeveloperName().get('Reactive_Resolution').getRecordTypeId();
    
    public static void handleCaseItemStatusChange(List<Case_Item__c> triggerNew, Map<id,Case_Item__c> triggerOldMap){
        
        Id recordTypeId =Schema.SObjectType.Case_Item__c.getRecordTypeInfosByDeveloperName().get('PIR_Case_Items').getRecordTypeId();
        
        set<id> caseItemIdSet = new set<Id>();
        map<id, PIR_Root_Cause_Case_Item__c> cItemIdRcCaseItemMap = new map<id, PIR_Root_Cause_Case_Item__c>();
        
        set<id> fastRecordTypeCaseIdSet = getCaseRecordTypes(triggerNew);
        
        for(Case_Item__c cItemNew: triggerNew){
            if(cItemNew.RecordTypeId == recordTypeId && fastRecordTypeCaseIdSet.contains(cItemNew.Case__c) && cItemNew.Status__c != triggerOldMap.get(cItemNew.id).Status__c && cItemNew.Status__c=='Resolved'){
                caseItemIdSet.add(cItemNew.Id);
            }
        }
        if(caseItemIdSet.size()>0){
            List<PIR_Root_Cause_Case_Item__c> rcCItemList = new List<PIR_Root_Cause_Case_Item__c>();
            rcCItemList = [SELECT id, Root_Cause_1__c,Name, Case_Item__c, Root_Cause_1_Key_Code__c, Root_Cause_2__c, 
                           Root_Cause_2_Key_Code__c, Root_Cause_3__c, Root_Cause_3_Key_Code__c, Root_Cause_4__c, 
                           Root_Cause_4_Key_Code__c, Root_Cause_5__c, Root_Cause_5_Key_Code__c
                           FROM PIR_Root_Cause_Case_Item__c
                           WHERE Case_Item__c IN:caseItemIdSet];
            if(rcCItemList.size()>0){
                for(PIR_Root_Cause_Case_Item__c rcCItem: rcCItemList){
                    cItemIdRcCaseItemMap.put(rcCItem.Case_Item__c, rcCItem);
                }  
            } 
        }
        
        rootcauseError(triggerNew,triggerOldMap,cItemIdRcCaseItemMap, fastRecordTypeCaseIdSet);
    }
    
    public static void rootCauseError(List<Case_Item__c> triggerNew, Map<id,Case_Item__c> triggerOldMap,map<id, PIR_Root_Cause_Case_Item__c> cItemIdRcCaseItemMap, set<id> fastRecordTypeCaseIdSet){
        Id recordTypeId =Schema.SObjectType.Case_Item__c.getRecordTypeInfosByDeveloperName().get('PIR_Case_Items').getRecordTypeId();
        string errorMessage = 'Please Provide all Root Causes before changing the Case Item status to "Resolved"';
        
        for(Case_Item__c cItemNew: triggerNew){
            if(cItemNew.RecordTypeId == recordTypeId && fastRecordTypeCaseIdSet.contains(cItemNew.Case__c) && cItemNew.Status__c != triggerOldMap.get(cItemNew.id).Status__c && cItemNew.Status__c=='Resolved'){
                if(cItemIdRcCaseItemMap.containsKey(cItemNew.Id)){
                    PIR_Root_Cause_Case_Item__c rcItem =  cItemIdRcCaseItemMap.get(cItemNew.Id);
                    if(rcItem.Root_Cause_1__c ==null || rcItem.Root_Cause_1__c =='' || 
                       rcItem.Root_Cause_1_Key_Code__c == null || rcItem.Root_Cause_1_Key_Code__c =='' ||
                       rcItem.Root_Cause_2__c ==null || rcItem.Root_Cause_2__c =='' || 
                       rcItem.Root_Cause_2_Key_Code__c == null || rcItem.Root_Cause_2_Key_Code__c =='' ||
                       rcItem.Root_Cause_3__c ==null || rcItem.Root_Cause_3__c =='' || 
                       rcItem.Root_Cause_3_Key_Code__c == null || rcItem.Root_Cause_3_Key_Code__c =='' ||
                       rcItem.Root_Cause_4__c ==null || rcItem.Root_Cause_4__c =='' || 
                       rcItem.Root_Cause_4_Key_Code__c == null || rcItem.Root_Cause_4_Key_Code__c =='' ||
                       rcItem.Root_Cause_5__c ==null || rcItem.Root_Cause_5__c =='' || 
                       rcItem.Root_Cause_5_Key_Code__c == null || rcItem.Root_Cause_5_Key_Code__c ==''){
                          cItemNew.addError(errorMessage); 
                    }
                }else{
                    cItemNew.addError(errorMessage);
                }
            }
        }
    }
    public static set<id> getCaseRecordTypes(List<Case_Item__c> triggerNew){
        set<id> fastRecordTypeCaseIdSet = new set<id>();
        set<id> caseIdSet = new set<id>();
        for(Case_Item__c cItem: triggerNew){
            caseIdSet.add(cItem.Case__c);
        }
        for(Case c:[SELECT id, RecordTypeId FROM case WHERE id IN:caseIdSet AND RecordTypeId=:fastRecordTypeId]){
            fastRecordTypeCaseIdSet.add(c.id);
        }
        return fastRecordTypeCaseIdSet;
    }
    public static void handleAfterUpdate(List<Case_Item__c> triggerNew, map<id,Case_Item__c> triggerOldMap){
        
        List<FeedItem> feedLst = new List<FeedItem>();
        
        for(Case_Item__c caseItemRec : triggerNew){
            
                if(caseItemRec.Advocate_Comments__c != triggerOldMap.get(caseItemRec.id).Advocate_Comments__c ){ 
                    String postBody;            
                    FeedItem post = new FeedItem();
                    post.ParentId = caseItemRec.id;
                    postBody = 'Case Item Updated' ;              
                    postBody += '\n' +'Comments : ' + caseItemRec.Advocate_Comments__c; 
                    post.Body = postBody;
                    feedLst.add(post);  
                }           
            
            
        }
        system.debug('Feed List-->'+ feedLst);
        if(feedLst.size()>0){
            Database.insert(feedLst,false);
        }
        
    }
}