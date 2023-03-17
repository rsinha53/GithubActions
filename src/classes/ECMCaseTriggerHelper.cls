public without sharing class ECMCaseTriggerHelper {
    
    //Whenver case is inserted populating Case's type and subtype on case Item
    //Whenver case is updated and type and subtype values are changed, updating values on Unresolved case items
    public static void updateTypeAndSubTypeOnCaseItem(list<case> triggerNew, map<id, case> oldMap){
        try{
            set<id> caseIds = new set<id>();
             
            for(Case newCase: triggerNew){
                Case oldCase = oldMap.get(newCase.id);
                if(!string.isBlank(newCase.Type__c) || !string.isBlank(newCase.Subtype__c)){
                    if(newCase.Type__c != oldCase.Type__c || newCase.Subtype__c != oldCase.Subtype__c){
                        caseIds.add(newCase.id);
                    }
                }
            }
            
            
            if(!caseIds.isEmpty()){
                map<id,list<Case_Item__c>> mapOfCaseIdListOfCaseItems = new map<id,list<Case_Item__c>>();//Map of caseID and list of Case_Item__c
                list<Case_Item__c> caseItemsToUpdate = new list<Case_Item__c>();
                caseItemsToUpdate = [select id,Resolved__c,Case__c from Case_Item__c where Case__c in:caseIds and Resolved__c = false];
                for(Case_Item__c ci : caseItemsToUpdate){
                    if(mapOfCaseIdListOfCaseItems.get(ci.Case__c) != null){
                        mapOfCaseIdListOfCaseItems.get(ci.Case__c).add(ci);
                    }else{
                        mapOfCaseIdListOfCaseItems.put(ci.Case__c,new list<Case_Item__c>{ci});
                    }
                }
                caseItemsToUpdate.clear();
                if(!mapOfCaseIdListOfCaseItems.isEmpty()){
                    for(Case newCase : triggerNew){
                        if(mapOfCaseIdListOfCaseItems.get(newCase.id) != null){
                            for(Case_Item__c ci : mapOfCaseIdListOfCaseItems.get(newCase.id)){
                                ci.Type__c = newCase.Type__c;
                                ci.Subtype__c = newCase.Subtype__c;
                                caseItemsToUpdate.add(ci);
                            }
                        }
                    }
                }
                if(!caseItemsToUpdate.isEmpty()){
                if((Schema.sObjectType.Case_Item__c.fields.Type__c.isUpdateable()) && (Schema.sObjectType.Case_Item__c.fields.Subtype__c.isUpdateable())){   // code added as per checkmarx improvement -- Srinivasa
                    update caseItemsToUpdate;
                }
                }
                
            }
        }catch(exception ex){
            system.debug('Exception while updating caseItems type and subtype  -- '+ex.getMessage());
        }
    }
    
    /*Whenever case Owner is changed , then chaging all open tasks owner with new case owner*/
    public static void prepareOwnerChangedCaseIds(map<id,case> newMap, map<id, Case> oldMap){
        set<id> caseIds = new set<id>();
        for(Case cs : newMap.values()){
            Case oldCs = oldMap.get(cs.id);
            if(cs.ownerId != oldCs.ownerId && (string.valueOf(cs.ownerId)).startsWith('005')){
                caseIds.add(cs.id);
            }
        }
        
        if(!caseIds.isEmpty()){
           changeOpenActivityOwner(caseIds,newMap);
        }
    }
    /*@@ "set<id> caseIds" will have the ids of cases, whose owner is changed
         "map<id,case> caseMap" will contain all case records in trigger context */
    public static void changeOpenActivityOwner(set<id> caseIds , map<id,case> caseMap){
        list<Task> tasks = new list<Task>();
        tasks = [select id,OwnerId,WhatId, RetainOwnership__c, HiddenOwnerID__c from Task where whatId in: caseIds and IsClosed = False];
        
        for(Task tsk : tasks){
            /*Check if Salesforce has already changed the owner of the Activity - 
                This happens when  owner of case and activity are the same , and user changes the owner  of the case. The owner is auto updated, but 
                a custom field created to track the last owner is not updated
            */            
            if(tsk.OwnerId != tsk.HiddenOwnerID__c && tsk.RetainOwnership__c && tsk.HiddenOwnerID__c != null){
                //Revert auto update if RetainOwnership is true and Previous owner was a user            
                tsk.ownerId = tsk.HiddenOwnerID__c;                        
            }
            /*
                if case  and Activity owners are not the same, and then User changes the case owner, Activity Ownership is retained by salesforce. 
            */
            else{
                //updating the task owner if RetainOnwership = false to be the same as case owner
                if(tsk.RetainOwnership__c == False  && caseMap != null && caseMap.get(tsk.WhatId) != null
                    &&(string.valueOf(caseMap.get(tsk.WhatId).ownerId)).startsWith('005')){
                    
                    tsk.ownerId = caseMap.get(tsk.WhatId).OwnerId;   
                    tsk.HiddenOwnerID__c= caseMap.get(tsk.WhatId).OwnerId;       
                }
            }
        }
        if(!tasks.isEmpty()){                  
            update tasks;     
        }
    }   
    
    public static void autoClosedParentCase(map<id,case> newMap, map<id,case> oldMap){	
        DateTime completionDate = System.now(); 
        List<Id> autoUpdateCasesMilestone = new List<Id>();
        Set<Id> parentCaseIds = new Set<Id>();
        Group queueId = [SELECT Id FROM Group WHERE Type = 'Queue' AND Name = 'Motion System'];
        Map<String, string> recordtypename = new map<String, String>();
        if(!newMap.isEmpty()){ 
            List<Case> caseList = new List<Case>(newMap.values()); 
            Map<ID,Schema.RecordTypeInfo> rt_Map = Case.sObjectType.getDescribe().getRecordTypeInfosById();
            
            for (Case c : caseList){
                recordtypename.put(c.id, rt_map.get(c.RecordTypeId).getName());
            }       
        }
        
        for(Case newObj : newMap.values()){ 
            if(recordtypename.get(newObj.id)=='Motion'){
                if(newObj.ParentId != null ){
                    if(newObj.Status == 'Closed' && newObj.Status != oldMap.get(newObj.Id).Status){
                        parentCaseIds.add(newObj.ParentId);
                    }		  
                }
                else if(newObj.ParentId == null && newObj.Status != 'Closed'){
                    parentcaseIds.add(newObj.Id);
                }
            }
        }  
        
        if(!parentCaseIds.isEmpty()){
            List<Case> parentCaseList = [SELECT Id, CaseNumber, Status, (SELECT Id, Status FROM Cases) FROM Case WHERE Id IN: parentCaseIds AND Status != 'Closed' AND OwnerId =: queueId.Id];
            
            List<Case> UpdatedParentCases = new List<Case>(); 
            Set<String> motionMilestoneName = new Set<String>{'Move to Working', 'Close Case'};		
                if(!parentCaseList.isEmpty()){
                    for(Case prnt : parentCaseList){                
                        List<Case> openChildCases = new List<case>();
                        if(prnt.Cases.size() > 0){
                            for(Case child : prnt.Cases){
                                if(child.Status != 'Closed'){
                                    openChildCases.add(child);                            
                                } 
                            }
                        }
                        
                        if(openChildCases != null && openChildCases.size() == 0 && prnt.Cases.size() > 0){
                            prnt.Status = 'Closed';
                            UpdatedParentCases.add(new Case(Id = prnt.Id, Status = prnt.Status));
                            autoUpdateCasesMilestone.add(prnt.Id);                    
                        }                                                                       
                    } 
                    
                    if(!autoUpdateCasesMilestone.isEmpty()){
                        MotionCommonUtil.completeMilestone(autoUpdateCasesMilestone, motionMilestoneName, completionDate);
                    }
                    if(!UpdatedParentCases.isEmpty()){
                        update UpdatedParentCases;
                    }                    
                }
        }
    }
    
    public static void preventClosedParentCase(List<Case> triggerNew, Map<id,case> oldMap){	
        if(MotionCommonUtil.handlerecursivecheck){
            Set<Id> prntCaseIds = new Set<Id>();       
            Map<String, String> recordTypeName = new Map<String, String>();
            if(!triggerNew.isEmpty()){ 
                List<Case> caseList = new List<Case>(triggerNew); 
                Map<ID,Schema.RecordTypeInfo> rt_Map = Case.sObjectType.getDescribe().getRecordTypeInfosById();
                
                for (Case c : caseList){
                    recordTypeName.put(c.id, rt_map.get(c.RecordTypeId).getName());
                }       
            }
            
            for(Case newObj : triggerNew){ 
                if(recordTypeName.get(newObj.id)=='Motion'){
                    if(newObj.Status == 'Closed' && newObj.Status != oldMap.get(newObj.Id).Status){
                        prntCaseIds.add(newObj.Id);
                    }		  
                }
            }            
            
            if(prntCaseIds != null && !prntCaseIds.isEmpty()){
                List<Case> prntCsList = [SELECT ParentId, CaseNumber, Status FROM Case WHERE ParentId IN: prntCaseIds AND IsClosed = false];
                map<String,list<Case>> childcasemap = new map<string,list<Case>>();
                if(prntCsList != null && !prntCsList.isEmpty()){
                    for(Case cse : prntCsList){
                        system.debug(childcasemap);
                        if(childcasemap.containsKey(cse.id)){
                            childcasemap.get(cse.ParentId).add(cse);   
                        }else{
                            childcasemap.put(cse.ParentId,new list<Case>{cse});   
                        }
                    }
                    system.debug('Map-->'+childcasemap);       
                    for(Case cs : triggerNew){
                        system.debug('childcasemap.get(cs.Id).size()'+childcasemap.get(cs.Id).size());
                        if(childcasemap.get(cs.Id).size()>0){
                            cs.addError('We\'re unable to close this Case. All child/related Cases must be closed prior to acting upon this Case.');
                        }                
                    }
                }
            }
            
            MotionCommonUtil.handlerecursivecheck = false;
        }
    }
	
}