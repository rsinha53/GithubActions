/*************************************************************************************************************
* @name			ACET_FAST_PIRDetail_TriggerHandler
* @author			mrajen15 <muthukumarr@optum.com>
* @created			24 / 12 / 2020
* @description		Handler class for PIR Detail Trigger
*
* Changes (version)
* -----------------------------------------------------------------------------------------------------------
* 				No.		Date			Author					Description
* 				----	------------	--------------------	----------------------------------------------
* @version		1.0		2020-12-21		mrajen15				Initial
*
**************************************************************************************************************/
public with sharing class ACET_FAST_PIRDetail_TriggerHandler {
    public static void handleBeforeInsertOrUpdate(List<PIR_Detail__c> pirDetailList) {        
        
        //Get Logged In User Details
        ACET_FAST_Utility.LoggedInUserWrapper logInUser = new ACET_FAST_Utility.LoggedInUserWrapper();
        ID fastRecordTypeId = ACET_Fast_ProviderContactCtrl.getRecordTypeIdbyDevName('CASE','Reactive_Resolution'); 
        ID pipRecordTypeId = ACET_Fast_ProviderContactCtrl.getRecordTypeIdbyDevName('CASE','Proactive_Action');
        Set<String> excludeProfiles = new Set<String>{'Integration Only','PIR Support Cases Profile','Integration'};
        
        Set<id> caseIds = new Set<id>();
        Map<id,id> caseOwnerIdMap = new Map<id,id>();
        
        for(PIR_Detail__c pirDetailRec : pirDetailList){
            caseIds.add(pirDetailRec.case__c);
        }
        
        for(case c : [select id, ownerid from case where id IN :caseIds and RecordTypeId IN (:fastRecordTypeId,:pipRecordTypeId)]){
            caseOwnerIdMap.put(c.id, c.OwnerId);
        }
        
        Map<id,set<id>> caseTeamMemberMap = ACET_FAST_Utility.getCaseTeamMemberMap(caseIds);
        
        for(PIR_Detail__c pirDetailRec : pirDetailList){
            //Case__r.RecordTypeId
            if(caseOwnerIdMap.containsKey(pirDetailRec.Case__c) &&  !excludeProfiles.contains(logInUser.loggedInUserProfile) && !(logInUser.isValidUser || logInUser.loggedInUserId == caseOwnerIdMap.get(pirDetailRec.Case__c) || (caseTeamMemberMap.containsKey(pirDetailRec.Case__c) && caseTeamMemberMap.get(pirDetailRec.Case__c).contains(logInUser.loggedInUserId))) ){                
                pirDetailRec.addError(ACET_FAST_Constants.notaValiFastRoleError);                
            }    
        }
    }
    
    public static void handleAfterInsert(List<PIR_Detail__c> triggerNew,map<id,PIR_Detail__c> triggerOldMap){
        Map<String,String> pirFields = ACET_FAST_PIRDetail_TriggerHandler.getPIRDetailFieldSets();
        
        List<FeedItem> feedLst = new List<FeedItem>();
        for (PIR_Detail__c pirRec : triggerNew) {
            String postBody;            
            FeedItem post = new FeedItem();
            post.ParentId = pirRec.Case__c;
            postBody = 'PIR Detail Updated' ;
            for(String field : pirFields.keySet()){
                if(pirRec.get(field) != triggerOldMap.get(pirRec.id).get(field)){                    
                    if( triggerOldMap.get(pirRec.id).get(field) == null ||  triggerOldMap.get(pirRec.id).get(field) == ''){
                        postBody += '\n' + pirFields.get(field) +': A blank value to ' + pirRec.get(field);
                    } else{
                         postBody += '\n' + pirFields.get(field) +': ' + pirRec.get(field);  
                    }
                }
            }
            post.Body = postBody;
            feedLst.add(post);            
        }
        system.debug('Feed List-->'+ feedLst);
        Database.insert(feedLst,false);
        
    }
    
    public static Map<String,String> getPIRDetailFieldSets(){
        Map<String,String> fields = new Map<String,String>();
        FieldSet fieldsToChatter = SObjectType.PIR_Detail__c.fieldSets.ACET_FAST_ChatterPIRDetail;
        for (FieldSetMember field : fieldsToChatter.getFields()) {
            fields.put(field.getFieldPath(),field.getLabel());
        }
        return fields;
    }
    
}