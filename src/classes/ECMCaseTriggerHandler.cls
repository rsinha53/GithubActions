public with sharing class ECMCaseTriggerHandler {
    
    //method to assign enetilement to case using Entitlement Assignment rules
    public static void handleBeforeInsert(List<Case> caseList){
        //Added for #US3102649 to fetch SNI case overview recordtype and skip the irrelevant code execution 
        Id SNIRecTypeId = Schema.SObjectType.CASE.getRecordTypeInfosByDeveloperName().get('SNI_Care_Plan').getRecordTypeId();
        for(Case cas:caseList ) {
            if(cas.Status != 'Canceled' && cas.Status != 'Canceled' && cas.RecordTypeId != SNIRecTypeId){
                ECMEntitlementAssignmentHelper.assignEntitlementId(cas);                
            }
        }        
    }
    
   //Initial Target Date from available milestones
   public static void calcInitialTargetDate(List<Case> caseList, Map<Id, Case> oldCaseMap){
       // list<case> listofCasesForInitialTargetDate = new List<Case>();
        list<ID> listofCasesForInitialTargetDateFuture = new List<Id>();
        if(caseList != null && !caseList.isEmpty() && oldCaseMap != null && !oldCaseMap.isEmpty()){ 
            for(case cas :caseList){
                //validating change of Trigger_Initial_MP_Record__c
               
                if( oldCaseMap.get(cas.Id) != null){
                     system.debug('*** in calc initial handler'+cas.Trigger_Initial_MP_Record__c);
                    if((cas.Trigger_Initial_MP_Record__c != oldCaseMap.get(cas.id).Trigger_Initial_MP_Record__c) && cas.Trigger_Initial_MP_Record__c){
                       // listofCasesForInitialTargetDate.add(cas); 
                        listofCasesForInitialTargetDateFuture.add(cas.id);
                                               
                    }
                }
            }               
            if(listofCasesForInitialTargetDateFuture!= null && !listofCasesForInitialTargetDateFuture.isEmpty()){
               // ECMMilestonePerformance.calcInitialTargetDate(listofCasesForInitialTargetDate);
               ECMMilestonePerformance.calcInitialTargetDateFuture(listofCasesForInitialTargetDateFuture);
           }            
        }   
   }
   
    //method to createMilestone performance based on action 1) change of case owner 2) Close of Milestone
    public static void recordMilestonePerformance(List<Case> caseList, Map<Id, Case> oldCaseMap){
        
        list<case> listofCases = new List<Case>();        
        Map<id, String> mapofIdandevent = new Map<id,String>();
        set<string> oldCaseStatus = new set<string>();
        
            
                    if(caseList != null && !caseList.isEmpty() && oldCaseMap != null && !oldCaseMap.isEmpty()){                     
                        for(case cas :caseList){
                            //validating change of owner
                            if( oldCaseMap.get(cas.Id) != null){
                                
                                
                                if(cas.OwnerId != oldCaseMap.get(cas.Id).OwnerId){                              
                                  //  listofCases.add(cas);
                                    
                                    oldCaseStatus.add(cas.id+'~'+oldcaseMap.get(cas.id).status);
                                    if(!mapofIdandevent.containsKey(cas.id)){
                                        //mapofIdandevent.put(cas.id, 'Changed Owner');
                                    }
                                }
                                if(cas.Milestone_Updated__c != oldCaseMap.get(cas.id).Milestone_Updated__c){
                                    listofCases.add(cas);
                                    if(!mapofIdandevent.containsKey(cas.id)){                                       
                                        mapofIdandevent.put(cas.id, 'Completed Milestone');
                                    }
                                }
 
                            }
                        }


                        if(!mapofIdandevent.isEmpty()){
                            ECMMilestonePerformance.recordMilestoneClose( listofCases,  oldCaseMap,  mapofIdandevent, null,null);     
                        }
                        
                    } 

        
    }
	//method to send Closed BEO cases to Solaris
    public static void sendSolarisClosedCases(List<Case> caseList,  Map<Id, Case> oldCaseMap){
         Map<id, String> mapofIdandevent = new Map<id,String>();
         list<String> listofClosedCases = new List<String>();
        
        if(caseList != Null && caseList.isEmpty() == False){
            DateTime completionDate = System.now();
            List<Id> updateCases = new List<Id>();
            for (Case c : caseList ){
                System.debug('IS GROUP? '  + c.Group_Solaris_ID__c);
                if(((c.isClosed == true)||(c.Status == 'Closed')) && c.Case_Type__c == 'BEO Case' && c.Group_Solaris_ID__c != null && c.Group_Solaris_ID__c != ''){
                    System.debug('CLOSED GROUP CASE');
                    mapofIdandevent.put(c.Id, 'Closed Case');
                    listofClosedCases.add(c.Id) ;
                }
            }
            if(listofClosedCases.isEmpty() == False){ 
                ECMSolarisCloseCase.sendSolarisClosedCases( listofClosedCases);     
            }           
                  
        }
    
    }
     
    //method to evaluate the criteria for closing case and auto closing milestones
    //public static void autocloseMilestones(List<Case> caseList){}
    public static void autocloseMilestones(List<Case> caseList,  Map<Id, Case> oldCaseMap){
         Map<id, String> mapofIdandevent = new Map<id,String>();
         list<case> listofClosedCases = new List<Case>();
        
        if(caseList != Null && caseList.isEmpty() == False){
            DateTime completionDate = System.now();
            List<Id> updateCases = new List<Id>();
            for (Case c : caseList ){
                if (((c.isClosed == true)||(c.Status == 'Closed'))&&((c.SlaStartDate<= completionDate)&&(c.SlaExitDate == null))){
                    updateCases.add(c.Id);
                    //for Milestone Performance 
                    mapofIdandevent.put(c.Id, 'Closed Case');
                    listofClosedCases.add(c) ;
                }
            }
            /*  calling Method to insert Milestone performance records for open milestons before closing them . 
                Creating MP records before closing the miletone will help in easier distinction of milestones that were already closed 
            */
            if(listofClosedCases.isEmpty() == False){               
                ECMMilestonePerformance.recordMilestoneClose( listofClosedCases,  oldCaseMap,  mapofIdandevent, completionDate,null);     
            }  
            /* 
                calling method to closed all open milestones
            */
            if(updateCases.isEmpty() == False){                              
                ECMMilestoneutils.completeMilestone(updateCases, completionDate);
            }            
                  
        }
    
    }
  
  public static boolean createRouteLog = true; 
    //method to call route on update- priority routing only if the current owner of the case is a Queue
  public static void pushCasetoUrgentQ(List<Case> caseList, Map<Id, Case> oldCaseMap){  
        if(caseList!= Null && !caseList.isEmpty() && oldCaseMap != null && !oldCaseMap.isEmpty()){
            

                //getting owner types for each case 
                Map<Id,String>  mapOfCaseIDAndOwnerType = new Map<Id, String>();
                Map<Id, String> mapOfQueueIdandName = new Map<Id, String>();
                Map<id, String> mapOfCaseAndCurrentQueue = new  Map<id, String> ();
                Set<id> setofQueueIds= new Set<Id>();
                for (Case cas :caseList){                  
                     if(!mapOfCaseIDAndOwnerType.containsKey(cas.ID) &&  oldCaseMap.get(cas.ID) != null && oldCaseMap.get(cas.ID).OwnerId != null){       
                            if(String.ValueOf(oldCaseMap.get(cas.ID).OwnerId).startswith('005')){                       
                                mapOfCaseIDAndOwnerType.put(cas.ID, 'User');
                            }
                            else{
                                mapOfCaseIDAndOwnerType.put(cas.ID, 'Queue');
                                setofQueueIds.add(oldCaseMap.get(cas.ID).OwnerId);
                            }
                     }
                     
                }                                  
             
                if(setofQueueIds != Null && !setofQueueIds.isEmpty()){
                    for(Group queue :[Select Id, Name, type from Group where Type = 'Queue' and Id In   :setofQueueIds]){
                        
                        mapOfQueueIdandName.put(queue.Id, queue.Name);
                    }
                
                }
            
            //Forming a list of cases that match criteria for priority routing
            List<case> priorityCases = new List<case>(); 
          
          
          //need to add the whole block back                       
            for(Case cas : caseList){   
                                  
                if(cas.Priority_Routing__c == 'Yes'  && mapOfCaseIDAndOwnerType.get(cas.id) != 'User' &&
                   oldCaseMap.get(cas.Id) != null && oldCaseMap.get(cas.Id).Priority_Routing__c == 'No') {                     
                        
                        priorityCases.add(cas);                          
                        mapOfCaseAndCurrentQueue.put(cas.id, mapOfQueueIdandName.get(oldCaseMap.get(cas.ID).OwnerId));                              
                }
            }
                       
                        
            // Calling CAse routing class to route the priority cases
            if(priorityCases!= Null && priorityCases.isEmpty() ==false && mapOfCaseAndCurrentQueue != null){                
                
                //Map<id, string> caseIDNQueue = CaseRoutingHelper.getQueueName(priorityCases); 
                Map<id, string> caseIDNQueue = ECMCaseRoutingHelper.getQueueName(priorityCases, mapOfCaseAndCurrentQueue , Null);              
             
             
                Set<String> uniqueQueueNames = new Set<String>();        
                if(caseIDNQueue!= null ){
                    for(Id caseId : caseIDNQueue.KeySet()){
                        if(!uniqueQueueNames.contains(caseIDNQueue.get(caseId))){
                            uniqueQueueNames.add(caseIDNQueue.get(caseId));
                        }
                    }
                                        
                    //forming map of queue name and queue id
                    Map<String, Id> mapOfQNameAndQId = new Map<String, Id>();
                    List<Group> groups = [Select Id, Name, DeveloperName, Type from Group where Type = 'Queue' And Name in :uniqueQueueNames];
                    if(groups.size() >0) {
                        for(Group que :groups){
                            if(!mapOfQNameAndQId.containsKey(que.Name)){                        
                                mapOfQNameAndQId.put(que.Name, que.Id);
                            }
                        }
                       
                    }
    
                    //ITERATING THRU CASELIST to assign it with case owner
                    for(Case cas :priorityCases){
                        String  queString= null;
                        if(caseIDNQueue.get(cas.id)!= null){
                            queString = caseIDNQueue.get(cas.id);
                        }               
    
                         if(queString != null && mapOfQNameAndQId.get(queString) != null) {                         
                               cas.ownerId = mapOfQNameAndQId.get(queString);                      
                         }       
                               
                    }
                     
                 }               
            }else if(createRouteLog){
                List<Route_Log__c> routeLog = new list<Route_Log__c>();
                for (Case cs :caseList){  
                    if(oldCaseMap != null){
                        if(cs.Case_Queue__c != null && cs.OwnerId != oldCaseMap.get(cs.id).ownerId){
                            routeLog.add(new Route_Log__c(Case__c = cs.id,
                                                          QueueName__c = cs.Case_Queue__c,
                                                          Subtype__c = cs.Subtype__c,
                                                          Topic1__c = cs.Topic__c,
                                                          RoutingPriority__c = cs.Priority_Routing__c,
                                                          Status__c = cs.Status,
                                                          Priority__c = cs.Priority,
                                                          Type__c = cs.Type__C));
                        }
                    }                
                } 
                if(routeLog.size() > 0){
                    if(Route_Log__c.sObjectType.getDescribe().isCreateable()){     // code added as per checkmarx improvement -- Srinivasa
                        insert routeLog;
                    }
                }                                 
            }         
   
        }
    }  
    
    
    
    public static void handleOWnerShipChangesForMp(list<Case> triggerNew, map<id, Case> triggerOldMap){
        set<id> ownerIDChangedCaseIds = new set<id>();
        
        for(Case newCase : triggerNew){
            Case oldCase = triggerOldMap.get(newCase.id);
            
            if(newCase.ownerId != oldCase.OwnerId){
                ownerIDChangedCaseIds.add(newCase.id);
            }
        }
        if(!ownerIDChangedCaseIds.isEmpty()){
            ECMMilestonePerformance.createOwnerShipChanges( ownerIDChangedCaseIds);     
        }
    }
    // #US667421 Added by Srinivasa
    public static void preventChangeOwnerToResearchUser(List<Case> triggerNew, Map<id,Case> triggerOldMap){
        for(case cases: triggerNew){
            if(triggerOldMap.get(cases.id).Ownerid != cases.Ownerid && cases.Owner_Profile__c == 'Research User'){
                cases.addError('Cases cannot be assigned to a Research User');
            }   
        }
    }
    
    public static void handleOwnerChnageRestriction(list<case> triggerNew, map<id, Case> oldMap){
    
        set<id> ownerChangedIds = new set<id>();
		set<id> ownerChangedIdsUhg = new set<id>();
        set<string> queueNames = new set<string>();
		set<string> queueNamesUhg = new set<string>();
		Map<ID,Schema.RecordTypeInfo> mapRTs = Case.sObjectType.getDescribe().getRecordTypeInfosById();
        for(Case cs : triggerNew){
            Case oldCs = oldMap.get(cs.id);
            if(cs.Onshore_Restriction__c == 'Yes' && cs.OwnerId != oldCs.ownerId && cs.Case_Queue__c  != null){ // If Case_Queue__c is not null, that mean case owner type is Queue
                ownerChangedIds.add(cs.id);
                queueNames.add( cs.Case_Queue__c);
            }
			if(cs.UHG_Restriction__c == 'Yes' && cs.OwnerId != oldCs.ownerId && mapRTs.get(cs.recordTypeID).getName().containsIgnoreCase('Support Request') && cs.Case_Queue__c  != null){
                ownerChangedIdsUhg.add(cs.id);
                queueNamesUhg.add( cs.Case_Queue__c);
            }
        }
        system.debug('queueNames :: '+queueNames);
        if(ownerChangedIds.size() > 0 || ownerChangedIdsUhg.size()>0){
            map<string,string> queueMap = new map<string,string>();
            for(Queue_Config__mdt obj: [select id, MasterLabel,Queue_Type__c from Queue_Config__mdt where MasterLabel in:queueNames ]){
                queueMap.put(obj.MasterLabel,obj.Queue_Type__c);
            }
            system.debug('queueMap :: '+queueMap);
			map<string,boolean> queueMapUhg = new map<string,boolean>();
            for(Queue_Config__mdt obj: [select id, MasterLabel,Is_UHG__c from Queue_Config__mdt where MasterLabel in:queueNamesUhg ]){
                queueMapUhg.put(obj.MasterLabel,obj.Is_UHG__c);
            }
            for(Case cs : triggerNew){ 
                if(ownerChangedIds.contains(cs.id)){ 
                    if(queueMap.get(cs.Case_Queue__c) != null && queueMap.get(cs.Case_Queue__c) != 'Onshore'){
                        cs.addError('This is a globally restricted group. You are not able to change owner to this queue');
                    }
                }
				if(ownerChangedIdsUhg.contains(cs.id)){ 
                   if(queueMapUhg.get(cs.Case_Queue__c) != null && ! queueMapUhg.get(cs.Case_Queue__c)){
                       cs.addError('This is a UHG restricted group. You are not able to change owner to this queue.');
                    }
                }
            }
        }  
    }
    public static void deleteFilesOnCaseDeletion(Map<id, Case> oldMap){
        List<ContentDocumentLink> contentDoc = new List<ContentDocumentLink>();
        Set<Id> newSet = oldMap.keySet();
        Set<Id> contentDocId = new Set<Id>();
        List<ContentDocument> conVer = new List<ContentDocument>();
        contentDoc = [Select ContentDocumentId,LinkedEntityId from ContentDocumentLink where LinkedEntityId IN : newSet];
        for(ContentDocumentLink con :contentDoc){
            contentDocId.add(con.ContentDocumentId);
        }
        conVer = [Select id from ContentDocument where Id IN :contentDocId];
        
        delete contentDoc;
        delete conVer;
    }
    
   public static void autoCompleteMilestone(Map<Id, Case> newCaseMap,  Map<Id, Case> oldCaseMap){

        if(!newCaseMap.isEmpty()){
            List<Id> caseIdList = new List<Id>(newCaseMap.keySet());  
            List<Case> caseList = new List<Case>(newCaseMap.values()); 
            
            DateTime completionDate = System.now(); 
            List<Id> updateWorkingCases = new List<Id>();
            List<Id> updateClosedCases = new List<Id>();
            
            Set<String> motionMilestoneWorking = new Set<String>{'Move to Working'};
            Set<String> motionMilestoneClose = new Set<String>{'Close Case'};
            
            Map<ID,Schema.RecordTypeInfo> rt_Map = Case.sObjectType.getDescribe().getRecordTypeInfosById();
            for (Case c : caseList){
                string recordtypeName = rt_map.get(c.RecordTypeId).getName();             
                if(recordtypeName == 'Motion') {
                    if(oldCaseMap != null){
                        if (c.Status == 'Working' && oldCaseMap.get(c.Id).Status != 'Closed' && (c.SlaStartDate <= completionDate && c.SlaExitDate == null))
                        {
                            updateWorkingCases.add(c.Id);
                        }
                        else if (c.Status == 'Closed' && c.Status != oldCaseMap.get(c.Id).Status && (c.SlaStartDate <= completionDate && c.SlaExitDate == null))
                            updateClosedCases.add(c.Id);
                    } else {
                        if (c.Status == 'Working' && (c.SlaStartDate <= completionDate && c.SlaExitDate == null))
                        {
                            updateWorkingCases.add(c.Id);                        
                        } else if (c.Status == 'Closed' && (c.SlaStartDate <= completionDate && c.SlaExitDate == null)){
                            updateClosedCases.add(c.Id);
                        }
                    }
                }
                
            }
            if (updateWorkingCases!= null && !updateWorkingCases.isEmpty())
                MotionCommonUtil.completeMilestone(updateWorkingCases, motionMilestoneWorking, completionDate);
            else if (updateClosedCases!=null && !updateClosedCases.isEmpty())
                MotionCommonUtil.completeMilestone(updateClosedCases, motionMilestoneClose, completionDate);
        }
    }

}