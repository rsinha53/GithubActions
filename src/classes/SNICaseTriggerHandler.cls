/**
 * Author: Chandan
 * Description: Case Trigger Handler for SNI -Separate handler class so that we can switch on/off complete feature
 * Date: 02/01/2020
 **/

public with sharing class SNICaseTriggerHandler {

  /**
 	* Method : handleCaseInsert
 	* Author : Chandan
 	* Description: To handle Case Insert
 	* Date: 02/01/2020
 	**/
   public static void handleCaseInsert(list<case> triggerNew){
       Id recordTypeID = Schema.SObjectType.Case.getRecordTypeInfosByName().get('ECM').getRecordTypeId();
       map<Id,Case> newCaseMap =new map<Id,Case>();
        for(case cse : triggerNew){
          if(cse.RecordTypeId == recordTypeID && cse.Case_Type__c == 'Opportunity'){
           newCaseMap.put(cse.id,cse);
          }
        }
       if(newCaseMap!=null && newCaseMap.size()>0)
         SNICaseTriggerHelper.calculateActiveCount(newCaseMap,true,false);

   }

   /**
 	* Method : handleCaseUpdate
 	* Author : Chandan
 	* Description: To handle Case Update
 	* Date: 02/01/2020
 	**/
   public static void handleCaseUpdate(Map<Id, Case> newCaseMap, Map<Id, Case> oldCaseMap){
       Map<Id, Case> updatedCaseMap =new Map<Id, Case>();
       Id recordTypeID = Schema.SObjectType.Case.getRecordTypeInfosByName().get('ECM').getRecordTypeId();
       for(Case cse: newCaseMap.values()){
           if(cse.RecordTypeId == recordTypeID && cse.Case_Type__c == 'Opportunity' && newCaseMap.get(cse.id).Status!=oldCaseMap.get(cse.id).Status){
               updatedCaseMap.put(cse.id,cse);
           }
       }
       if(updatedCaseMap!=null && updatedCaseMap.size()>0)
       		SNICaseTriggerHelper.calculateActiveCount(updatedCaseMap,false,false);
   }

   /**
 	* Method : handleCaseDelete
 	* Author : Chandan
 	* Description: To handle Case Delete
 	* Date: 02/01/2020
 	**/
   public static void handleCaseDelete(Map<Id, Case> oldCaseMap){
       SNICaseTriggerHelper.calculateActiveCount(oldCaseMap,false,true);
   }  
  
    /*
    Method Name:  prePopulateFieldValues
    Description :US2256503 - Auto Populate field values for ECM case type
    Modification History :
    */
    Public static void prePopulateFieldValues(list<case> triggerNew) {
       SNICaseTriggerHelper.prePopulateFieldValues(trigger.new);
    } 
     /*
    Method Name:  copyCaseTeamtoOpportunity
    Description :US2260867 - Copy case team from case overview to opportunity
    Modification History :
    */
    public static void copyCaseTeamtoOpportunity(list<case> triggerNew){
	   SNICaseTriggerHelper.copyCaseTeamtoOpportunity(trigger.new);
    }

     /*
    Method Name:  closeCaseValidation
    Description :US2304365 - Resolve all open Support Requests before Closing a Case
    Modification History :
    */
	public static void closeCaseValidation(List<Case> triggerNew){
        Id recordTypeID = Schema.SObjectType.Case.getRecordTypeInfosByName().get('ECM').getRecordTypeId();
        List<Id> cseIds = new List<Id>();
        for(Case cs: TriggerNew){
            if(cs.RecordTypeId == recordTypeID && cs.Case_Type__c == 'Opportunity'){
                cseIds.add(cs.Id);
            }
        }
        system.debug('cseIds:::'+cseIds);
        if(cseIds.size()>0){
        Map<Id,Case> supportCaseMap = new Map<Id,Case>();
        Map<Id,Task> activityMap = new Map<Id,Task>();
        for(Case cs: [SELECT Id,Support_Request__c FROM CASE where Support_Request__c in :cseIds AND Status != 'Closed']){
            supportCaseMap.put(cs.Support_Request__c,cs);    
        }
        for(Task tsk: [SELECT Id,whatId FROM Task where whatId in :cseIds AND Status != 'Completed' AND IsRecurrence != True]){
            activityMap.put(tsk.whatId,tsk);    
        }
        for(Case cs: TriggerNew){
            if(cs.Status == 'Closed' && supportCaseMap.containskey(cs.id) && activityMap.containskey(cs.id)){
                cs.addError('Resolve all open Support Requests before closing this case. <br/> Resolve all open Activities before closing this case');
            }
            else if(cs.Status == 'Closed' && supportCaseMap.containskey(cs.id)){
                cs.addError('Resolve all open Support Requests before closing this case');
            }
            else if(cs.Status == 'Closed' && activityMap.containskey(cs.id)){
                cs.addError('Resolve all open Activities before closing this case');
            }
            
        }  
        }

    }
      /*
    Method Name:  supportCaseOwnerChangeValidation
    Description : US2556096: SNI Core Support Request - Comments required before route 
    Modification History :
    */
    public static void supportCaseOwnerChangeValidation(List<Case> triggerNew,Map<Id,Case> oldCaseMap){
        Id recordTypeID = Schema.SObjectType.Case.getRecordTypeInfosByName().get('Support Request').getRecordTypeId();
        List<Id> cseIds = new List<Id>();
        for(Case cs: TriggerNew){
            if(cs.RecordTypeId == recordTypeID && oldCaseMap.get(cs.Id) !=null && (oldCaseMap.get(cs.Id).OwnerId != cs.OwnerId )){
                cseIds.add(cs.Id); 
            }
        }
        if(cseIds.size()>0){
            List<CaseComment> supportCasecommentList = [SELECT Id,parentId FROM CaseComment where parentId in :cseIds];
            Map<Id,List<String>> caseCommentSize = new Map<Id,List<String>>();
            for(CaseComment cc :supportCasecommentList){
                if(caseCommentSize.containsKey(cc.parentId)){
                    List<String> commentLst = caseCommentSize.get(cc.parentId);
                    commentLst.add(cc.Id);
                    caseCommentSize.put(cc.parentId, commentLst);
                } else {
                    caseCommentSize.put(cc.parentId,new List<String>{cc.Id});
                }
            }
            for(Case cs: TriggerNew){
                System.debug('caseid=='+cs.Account_Owner_Change_Indicator__c +'case id'+cs.Id);
                if(cs.RecordTypeId == recordTypeID && oldCaseMap.get(cs.Id) !=null && (oldCaseMap.get(cs.Id).OwnerId != cs.OwnerId ) && (!cs.Account_Owner_Change_Indicator__c)){ //added indicator to bypass this validation when account owner changes the case owner
                    system.debug('=='+caseCommentSize.get(cs.Id));
                    if(caseCommentSize.get(cs.Id) == null){
                        cs.addError('Comments are required before routing a Support Request');
                    }
                }
               
            }
        }
    }
}