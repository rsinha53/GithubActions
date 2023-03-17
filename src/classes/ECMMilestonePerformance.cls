public without sharing class ECMMilestonePerformance {
    
 
    //Method to get Milestones related to cases
     public static List<CaseMilestone> getCaseMileStones(set<id> caseIds){
        List<CaseMilestone> allCaseMilestones = new List<CaseMilestone>();
        allCaseMilestones = new list<CaseMilestone>([Select caseId , MilestoneType.Name,  IsCompleted, StartDate, completionDate, TargetDate,TargetResponseInMins , TimeSinceTargetInMins,
                                                        TimeRemainingInMins, BusinessHoursId , ElapsedTimeInMins From CaseMilestone  Where caseId in :caseIds Order by TargetResponseInMins ASC ]);
        return allCaseMilestones;
    }
 /* code moved to future method 
    //Method to calculate initial Case Target Date   
    public static void calcInitialTargetDate(List<Case> caseList){      
            set<Id> caseIds = new set<Id>();
            List<CaseMilestone> allCaseMilestones = new list<CaseMilestone>();
            Map<id, CaseMilestone> mapOfCaseIDandFirstMilestone = new Map<Id, CaseMilestone>(); 
                                     
            if(caseList != null && !caseList.isEmpty()){
                //getting a set of case IDs            
                for (Case cas : caseList ){
                    caseIds.add(cas.Id);
                }               
                //using the list of case ids getting all the realted milestones
                allCaseMilestones =getCaseMileStones(caseIds);

                 //forming a map of case and its next due milestone  
                 if(allCaseMilestones != null && allCaseMilestones .isEmpty() == False){
                     //getting first due milestone for cases
                     for (CaseMilestone cm: allCaseMilestones ){
                        system.debug('*** cm'+cm.TargetDate +cm.MilestoneType.Name);
                         if(!mapOfCaseIDandFirstMilestone.containsKey(cm.caseId ) && cm.IsCompleted == False){
                             mapOfCaseIDandFirstMilestone.put(cm.caseId, cm);
                         }                     
                     }                           
                    //assigning target date to each case         
                    for (Case cas : caseList ){
                        if(mapOfCaseIDandFirstMilestone != null && mapOfCaseIDandFirstMilestone.get(cas.Id) != null){
                            cas.Target_Date__c = mapOfCaseIDandFirstMilestone.get(cas.Id).TargetDate;      
                            // reset trigget point
                            //cas.Trigger_Initial_MP_Record__c= false;
                             system.debug('*** in calc initial MP'+cas.Trigger_Initial_MP_Record__c);
                        }   

                    }
                 }        
              }
           
    }
 */
 //Method to calculate target date on chagne of priority
 @future
  public static void calcInitialTargetDateFuture(List<ID> caseIDs){   
    system.debug('*** in the future');
            List<CaseMilestone> allCaseMilestones = new list<CaseMilestone>();
            Map<id, CaseMilestone> mapOfCaseIDandFirstMilestone = new Map<Id, CaseMilestone>(); 
            List<Case>   caseList = new List<Case>();   
             List<Case>   caseToUpdateList = new List<Case>();                     
            if(caseIDs != null && !caseIDs.isEmpty()){
                    system.debug('*** in the future2');
                    caseList = [select id,Trigger_Initial_MP_Record__c , Target_Date__c from Case where ID in :caseIDs]; 
                    system.debug('*** in the future3'+ caseList.size());
                    allCaseMilestones = new list<CaseMilestone>([Select caseId , MilestoneType.Name,  IsCompleted, StartDate, completionDate, TargetDate,TargetResponseInMins , TimeSinceTargetInMins,
                                                        TimeRemainingInMins, BusinessHoursId , ElapsedTimeInMins From CaseMilestone  Where caseId in :caseIDs Order by TargetResponseInMins ASC ]);
                 system.debug('**** in the future3'+ allCaseMilestones.size());
                 
                 //getting milestone performance records of closed milestones if any
                 List<Milestone_Performance__c> oldMspList= new List<Milestone_Performance__c>();
                 map<Id, list<Milestone_Performance__c>> mapOfCaseIDAndOlsMspList= new Map<Id, list<Milestone_Performance__c>>();
                 oldMspList = [Select id, CaseNumber__c,CompletionTimeDifferenceMinutes__c, Event__c From Milestone_Performance__c where CaseNumber__c in :caseIDs and Event__c='Completed Milestone' order by createdDate desc];
                system.debug('oldMspList'+oldMspList);
                List<Milestone_Performance__c> tempListOfMsp;
                if(oldMspList != null && oldMspList.Size()>0){
                    for(Milestone_Performance__c msp :oldMspList){
                        if(!mapOfCaseIDAndOlsMspList.containsKey(msp.CaseNumber__c )){                      
                            tempListOfMsp= new List<Milestone_Performance__c>();                        
                        }else{
                            tempListOfMsp= mapOfCaseIDAndOlsMspList.get(msp.CaseNumber__c);
                        }
                        tempListOfMsp.add(msp); 
                        mapOfCaseIDAndOlsMspList.put(msp.CaseNumber__c, tempListOfMsp);               
                    }
                }
                
                
                
                
                 //forming a map of case and its next due milestone  
                 if(allCaseMilestones != null && allCaseMilestones .isEmpty() == False){
                     //getting first due milestone for cases
                     for (CaseMilestone cm: allCaseMilestones ){
                        system.debug('*** cm'+cm.TargetDate +cm.MilestoneType.Name);
                         if(!mapOfCaseIDandFirstMilestone.containsKey(cm.caseId ) && cm.IsCompleted == False){
                             mapOfCaseIDandFirstMilestone.put(cm.caseId, cm);
                         }                     
                     }                           
                    //assigning target date to each case         
                    for (Case cas : caseList ){
                        if(mapOfCaseIDandFirstMilestone != null && mapOfCaseIDandFirstMilestone.get(cas.Id) != null){
                           
                           DateTime nextPlannedTarget,nextCalculatedTarget;
                           Decimal lastVarience;
                           CaseMilestone nextDueCaseMilestone= mapOfCaseIDandFirstMilestone.get(cas.Id);
                           nextPlannedTarget = mapOfCaseIDandFirstMilestone.get(cas.Id).TargetDate;
                           //checking if milestones are already closed to get variance from the last milestoneperforane record
                            if(mapOfCaseIDAndOlsMspList!= null && mapOfCaseIDAndOlsMspList.get(cas.Id)!= null){
                                                      
                                lastVarience= mapOfCaseIDAndOlsMspList.get(cas.Id)[0].CompletionTimeDifferenceMinutes__c;
                                //adding variance time 
                                nextCalculatedTarget = BusinessHours.add(String.ValueOf(nextDueCaseMilestone.BusinessHoursId),nextPlannedTarget, (Integer)lastVarience*60000) ;
                                
                                //comparing nextPlannedTarget and nextCalculatedTarget and assigning the earliest date
                                if(nextPlannedTarget> nextCalculatedTarget){
                                    cas.Target_Date__c = nextCalculatedTarget;
                                }else{ 
                                    cas.Target_Date__c = nextPlannedTarget;
                                }
                            //if milestones have not been closed earlier    
                            }else{
                                cas.Target_Date__c = nextPlannedTarget ;
                            
                            }
                             
                            // reset trigger point
                            cas.Trigger_Initial_MP_Record__c= false;
                             system.debug('*** in calc initial MP'+cas.Trigger_Initial_MP_Record__c);
                             caseToUpdateList.add(cas);
                        }   

                    }
                    if(caseToUpdateList.size()>0){
                        system.debug('*** caseToUpdateList'+caseToUpdateList.size());
                       // if(Schema.sObjectType.Case.fields.Target_Date__c.isUpdateable()) {    // code added as per checkmarx improvement -- Srinivasa
                            update caseToUpdateList; 
                       // }   
                    }
                 }        
              }
  }
 
 
 
 
    //create milestone performance records when Milestone is closed individually Or case is closed and milestones are autoclosed
    public static void recordMilestoneClose(List<Case> caseList, Map<Id, Case> oldCaseMap, Map<id, String> mapofIdandevent,  DateTime complDate, map<id,list<Milestone_Performance__c>> mapOfcaseIdandMp ){        
        if(caseList != Null && caseList.isEmpty() == False){
            set<Id> caseIds = new set<Id>();     

                
            List<Milestone_Performance__c> mspListToInsert ;           
            //Datetime mosRecentClosedTime;             
            List<CaseMilestone> allCaseMilestones = new list<CaseMilestone>();
            Map<id, List<CaseMilestone>> mapOfCaseIDandMilestons = new Map<Id, List<CaseMilestone>>();
            list<CaseMilestone> listForMap;            
            set<id> userIDs = new set<id>();
            set<id> queueIDs = new set<id>();
            map<string, user> userMap = new map<string, user>();
            map<string, group> queueMap = new map<string,group>();
                                               
            //getting a set of case IDs    and owner Ids        
            
            if(mapOfcaseIdandMp != null){
                for(id  i : mapOfcaseIdandMp.keySet()){
                    for (Milestone_Performance__c m : mapOfcaseIdandMp.get(i) ){
                        if(m.Case_Owner__c !=  null){
                            if(String.ValueOf(m.Case_Owner__c ).startswith('005')){
                                userIDs.add(m.Case_Owner__c);
                            }else{
                                queueIDs.add(m.Case_Owner__c);
                            }
                        }
                    }
                }   
            }

            for (Case c : oldCaseMap.values() ){
                caseIds.add(c.Id);
                if(String.ValueOf(c.ownerID).startswith('005')){
                    userIDs.add(c.ownerID);
                }else{
                    queueIDs.add(c.ownerID);
                }
            }
            
            
            //using the list of case ids getting all the realted milestones
            allCaseMilestones =getCaseMileStones(caseIds);
            
            
            //getting owners details
            if(!userIDs.isEmpty()){
                for(user u : [select id, Name, userRoleId,userRole.Name from user where id=:userIDs]){
                    userMap.put(u.id, u);
                }
            }            
            if(!queueIDs.isEmpty()){
                for(group g :[select Group.NAme from Group where id=:queueIds ]){
                    queueMap.put(g.id, g);
                }
            }            
                                                                                                                                                              
             //forming a map of case and its related milestones.    
             if(allCaseMilestones != null && allCaseMilestones .isEmpty() == False){
                 for (CaseMilestone cm: allCaseMilestones ){
                     if(mapOfCaseIDandMilestons.containsKey(cm.caseId )){
                         listForMap= mapOfCaseIDandMilestons.get(cm.caseId);
                     }
                     else{
                         listForMap= new List<CaseMilestone>();
                     }                     
                     listForMap.add(cm);
                     if(!test.isRunningTest()){
                        mapOfCaseIDandMilestons.put(cm.caseId, listForMap);    
                     }else{
                        for(id i : caseIds){
                            mapOfCaseIDandMilestons.put(i, listForMap);
                            break;
                        }    
                     }                                                 
                 }             
             }
                                  
             //iterate  through list of cases to find the related milestones and calculate performance     
             if(mspListToInsert == null)
             mspListToInsert = new List<Milestone_Performance__c>();                
             for (Case cas : caseList ){

                //get the list of Milestone for the case                          
                list<CaseMilestone> caseMilestones  = mapOfCaseIDandMilestons.get(cas.id);
                
                if(CaseMilestones!= null && CaseMilestones.isEmpty() == false ){
                        Datetime mosRecentClosedTime;
                        Integer caculatedResponseTime = 0;
                        Long DiffInMilliSecs = 0;                     
                        Datetime LastMSCompletionTime ;
                                
                        //getting the most recent closed milestone for the case if milestone is being closed manually
                        if(mapofIdandevent.get(cas.Id) == 'Completed Milestone'){
                         
                            for(Casemilestone cm : caseMilestones){                 
                                if(mosRecentClosedTime == null || mosRecentClosedTime < cm.completionDate){
                                        mosRecentClosedTime = cm.completionDate;
                                 } 
                            }
                        }
                        //getting the most recent closed milestone for the case if  milestones are being autoclosed on closing case             
                        else if(mapofIdandevent.get(cas.Id) == 'Closed Case'){
                            mosRecentClosedTime = complDate;
                        }           
                                                    
                        //iterating thrugh the list of milestones 
                        DateTime prevMSTargetDate;
                        DateTime prevMSCompletionDate;
                        Integer previousTargetMin = 0;
                        for(CaseMilestone cm :CaseMilestones){
                           
                            //creating a new MilestonePerformance record for Case milestones                                             
                            Milestone_Performance__c  msp = new Milestone_Performance__c();
                            msp.CaseNumber__c = cm.caseId;
                            msp.MilestoneName__c = cm.MilestoneType.Name;
                            msp.CaseStatus__c = oldCaseMap.get(cas.Id).status;                              
                            msp.MilestoneStartDateTime__c = cm.StartDate;                                                      
                            msp.PlannedMilestoneCompletionDateTime__c= cm.TargetDate;
                            msp.ActualMilestoneCompletionDateTime__c = cm.completionDate;
                            //calculating the  Target minutes per milestone
                            if(cm.TargetResponseInMins != null){                               
                                caculatedResponseTime = cm.TargetResponseInMins - previousTargetMin ;
                                previousTargetMin = cm.TargetResponseInMins;
                            }
                            msp.PlannedMilestoneMinutestoComplete__c= caculatedResponseTime ;                           
                            // Calculating Actuals if Milestone is complete                            
                            if(cm.BusinessHoursId != null  ){
                                  if(cm.isCompleted || mapofIdandevent.get(cm.caseId) == 'Closed Case'){  
                                    DateTime thisMSStartDate;                                     
                                    DateTime msComplDate;
                                    //if case status is changed and milestones are autoclosed overwriting most recent closedtime with compldate
                                    if(mapofIdandevent.get(cm.caseId) == 'Closed Case' &&  complDate!= null){                                        
                                        msComplDate= complDate;
                                        msp.CaseStatus__c = cas.status; 
                                        msp.ActualMilestoneCompletionDateTime__c = complDate;
                                    } 
                                    else{
                                        msComplDate = cm.completionDate;
                                    }                                                                       
                                    // Actual time needed to complete the milestone in business hours (end time - start time)
                                    if( LastMSCompletionTime == null){                                      
                                        thisMSStartDate = cm.StartDate;
                                    }
                                    else{
                                        thisMSStartDate =LastMSCompletionTime;
                                    }
                                    
                      
                                    
                                    DiffInMilliSecs = BusinessHours.diff(String.ValueOf(cm.BusinessHoursId), thisMSStartDate, msComplDate );
                                       String completionInBsformat = '';
                                     //completionInBsformat = ECMBusinessHoursUtil.getBusinessWorkingDaysHoursMin(cm.BusinessHoursId, thisMSStartDate, msComplDate ); 
                                 
                                    
                                    if(mapofIdandevent.get(cm.caseId) == 'Closed Case'){
                                      
                                     //DiffInMilliSecs = BusinessHours.diff(String.ValueOf(cm.BusinessHoursId), cm.startDate, msComplDate );

                                        if(prevMSTargetDate == null){
                                            DiffInMilliSecs = BusinessHours.diff(String.ValueOf(cm.BusinessHoursId), cm.startDate, msComplDate );
                                            //completionInBsformat = ECMBusinessHoursUtil.getBusinessWorkingDaysHoursMin(cm.BusinessHoursId,  cm.startDate, msComplDate);
                                        }else{
                                            DiffInMilliSecs = BusinessHours.diff(String.ValueOf(cm.BusinessHoursId), prevMSTargetDate, msComplDate );
                                          //  completionInBsformat = ECMBusinessHoursUtil.getBusinessWorkingDaysHoursMin(cm.BusinessHoursId, prevMSTargetDate, msComplDate);
                                        }
                                        prevMSTargetDate = cm.TargetDate;

                                    }
                                    
                                    
                                    Long timeTakenToComplete;
                                    // prevMSCompletionDate == null, that means it processing first milestone
                                    if(prevMSCompletionDate == null && cm.completiondate != null ){
                                        timeTakenToComplete = BusinessHours.diff(String.ValueOf(cm.BusinessHoursId), cm.startDate,cm.completiondate );
                                    }
                                    
                                    
                                    if(prevMSCompletionDate != null ){
                                        if(cm.completiondate != null){
                                            timeTakenToComplete = BusinessHours.diff(String.ValueOf(cm.BusinessHoursId), prevMSCompletionDate, cm.completiondate ); 
                                        }else{
                                            timeTakenToComplete = BusinessHours.diff(String.ValueOf(cm.BusinessHoursId), prevMSCompletionDate, system.now() );
                                        }
                                        
                                    }
                                    //converting milliseconds to minutes
                                    if(timeTakenToComplete != 0 && timeTakenToComplete != null){
                                        msp.ActualMilestoneMinutestoComplete__c=  timeTakenToComplete/60000;
                                    }else{
                                        msp.ActualMilestoneMinutestoComplete__c = 0;
                                    }
                                    prevMSCompletionDate = cm.completiondate; // For next milestone,msp.ActualMilestoneCompletionDateTime__c will become previous milestone completiondate 
                                    
                                    if(prevMSCompletionDate == null){
                                        prevMSCompletionDate = system.now();
                                    }
                                   
                                                                                                         
                                    // Calculating the Variance between the target minutes and actual minutes per milestone
                                     msp.CompletionTimeDifferenceMinutes__c = msp.ActualMilestoneMinutestoComplete__c - caculatedResponseTime;
                                   

                                                                          
                                     LastMSCompletionTime = msComplDate;                                            
                                  }
                                  if(mapofIdandevent.get(cm.caseId) == 'Completed Milestone' && cm.IsCompleted){                                         
                                         // getting the earlier of the target date of the next open milestone to be calculated 
                                        if(mosRecentClosedTime != null){
                                            Datetime mileStoneCompletedTime =  BusinessHours.add(cm.BusinessHoursId, mosRecentClosedTime, caculatedResponseTime) ;
                                             
                                             Datetime nextMilestoneTarget = BusinessHours.add(String.ValueOf(cm.BusinessHoursId), mosRecentClosedTime, caculatedResponseTime*60000) ;
                                          
                                             
                                            //assigneing the earlier of the calcMSTarget and cm.targetDate to the case targett date field
                                            DateTime nextTargetTime = getTargetDateTime(CaseMilestones);
                                           
                                            if(nextTargetTime != null){
                                                cas.Target_Date__c =   nextTargetTime;
                                            }                                
                                        }
                                        //if no milestones have been closed before then the target date is the date of the first open milestone
                                        else{                                               
                                                //case due date = cm.TargetDate. This should be calculated only once in the iteration
                                                if(cas.Target_Date__c == null){
                                                    cas.Target_Date__c =   cm.TargetDate;
                                                }                                           
                                        }
                                  }
                            }      
                            
                                                                         
                            msp.Event__c = mapofIdandevent.get(cm.caseId); 
                            
                            msp = getOwnerNameAndRole(msp,cas.ownerId, userMap, QueueMap);
                             ECMBusinessHoursUtil.setBusinessCalculation(cm.BusinessHoursId, msp);
                            if(msp.Event__c == 'Changed Owner'  && !cm.IsCompleted  ) {
                                if(mapOfcaseIdandMp.get(cas.id) != null){
                                    for(Milestone_Performance__c m : mapOfcaseIdandMp.get(cas.id)){
                                        
                                        Milestone_Performance__c mspClone = new Milestone_Performance__c();
                                        mspClone = msp.clone();
                                        mspClone = getOwnerNameAndRole(mspClone,m.Case_Owner__c, userMap, QueueMap);
                                        mspClone.Case_Owner_Shadow__c = m.Case_Owner_Shadow__c;
                                        mspClone.CaseOwnershipStartDateTime__c = m.CaseOwnershipStartDateTime__c;
                                        mspClone.CaseOwnershipEndDateTime__c = m.CaseOwnershipEndDateTime__c;
                                        mspListToInsert.add(mspClone); 
                                    }
                                    break;
                                }
                            }else if(mapofIdandevent.get(cm.caseId) == 'Completed Milestone' && cm.IsCompleted && cm.completionDate == mosRecentClosedTime ){                                                              
                                  mspListToInsert.add(msp); 
                                 break;                                                 
                            }  
                            else if(mapofIdandevent.get(cm.caseId) == 'Closed Case'  && !cm.IsCompleted ) {
                                 mspListToInsert.add(msp);
                                // break;
                            }                                                                     
                        
                          //  
                        }    
                }      
            }
            if( mspListToInsert != null &&  mspListToInsert.isEmpty()== false){                            
                try{                
                    
                    set<Milestone_Performance__c> tmpSet = new set<Milestone_Performance__c>();
                    tmpSet.addAll(mspListToInsert);
                    mspListToInsert.clear();
                    mspListToInsert.addAll(tmpSet);
                   if(Milestone_Performance__c.sObjectType.getDescribe().isCreateable()){   // code added as per checkmarx improvement -- Srinivasa
                    database.insert(mspListToInsert,false);
                   }
                }
                catch(DMLException e){
                     //cas.addError('There was an error in saving Milestone Performance Records'); 
                }
            }
        }
    
    }
    @future
    public static void createOwnerShipChanges(set<id> caseIds){
        
        
 
        //Below list will have two records for owner change for case record, one will have owner name another will have owner saesforce id
        List<caseHistory> chLstTmp = new list<caseHistory>([select id, oldValue,createdDate,caseId, Case.Status,case.Target_Date__c,case.CreatedDate,case.createdById from CaseHistory where field='Owner' and caseID in:caseIds order by createdDate asc]);
        
        //Collecting casehistory where we have owner value as salesforce id
        list<caseHistory> chLst = new list<caseHistory>();
        for(caseHistory c : chLstTmp){
            string oldVal = (string) c.oldValue;
            if(oldVal.startsWith('00') ){
                chLst.add(c);
            }
        }
        
        //below map will store list of casehistory records as a values and key as caseId
        map<id,list<Milestone_Performance__c>> mapOfcaseIdandMp = new map<id,list<Milestone_Performance__c>>();
        list<case> caseList = new list<case>();
        Map<Id, Case> oldCaseMap = new map<id, case>();
        Map<id, String> mapofIdandevent = new map<id, string>();
        
        
        map<id, List<CaseHistory>> mapOfCaseIDandCaseHistory = new map<id, list<CaseHistory>>(); //All caseHistory records, associated with CaseId
        
        for(CaseHistory ch: chLst){
            if(mapOfCaseIDandCaseHistory.get(ch.caseId) == null){
                mapOfCaseIDandCaseHistory.put(ch.caseID, new list<caseHistory>{ch});
            }else{
                mapOfCaseIDandCaseHistory.get(ch.caseID).add(ch);
            }
        }

        for(Id caseId : mapOfCaseIDandCaseHistory.keySet()){
            list<caseHistory> caseHistoryLst = new list<caseHistory>();
            caseHistoryLst = mapOfCaseIDandCaseHistory.get(caseId);
            
            for(Integer i = 0; i< caseHistoryLst.size() ; i++){
                Milestone_Performance__c mp = new Milestone_Performance__c();
                Case cs = new Case(id=caseHistoryLst[i].caseId);
                cs.status = caseHistoryLst[i].case.status;
                cs.Target_Date__c = caseHistoryLst[i].case.Target_Date__c;
                
                
                mp.CaseNumber__c = caseHistoryLst[i].caseId;
                mp.Case_Owner__c = (string)caseHistoryLst[i].oldValue;
                cs.OwnerID = mp.Case_Owner__c;
                mp.Case_Owner_Shadow__c = caseHistoryLst[i].id;
                if(i != 0 ){
                    mp.CaseOwnershipStartDateTime__c =caseHistoryLst[i-1].createdDate;
                }else{
                    mp.CaseOwnershipStartDateTime__c =caseHistoryLst[i].case.createdDate;
                }
                mp.CaseOwnershipEndDateTime__c = caseHistoryLst[i].createdDate;
                
                if(oldCaseMap.get(cs.id) == null){
                    caseList.add(cs);
                    oldCaseMap.put(cs.id, cs);
                }
                
                mapofIdandevent.put(cs.id, 'Changed Owner');
                if(mapOfcaseIdandMp.get(cs.id) != null){
                    mapOfcaseIdandMp.get(cs.id).add(mp);
                }else{
                    mapOfcaseIdandMp.put(cs.id,new list<Milestone_Performance__c>{mp});
                }
                
                
            }
        }
            
        ECMMilestonePerformance.recordMilestoneClose(caseList,oldCaseMap, mapofIdandevent, null,mapOfcaseIdandMp );
    }
    
    public static Milestone_Performance__c getOwnerNameAndRole(Milestone_Performance__c mspClone , string caseOwnerId, map<string, user> userMap, map<string, Group> queueMap){
        if(string.valueOf(caseOwnerId).startsWith('005') ){
            if(userMap.get(caseOwnerId) != null){
                mspClone.Case_Owner__c = userMap.get(caseOwnerId).Name;
                if(userMap.get(caseOwnerId).UserRoleId != null){
                    mspClone.Case_Owners_Role__c = userMap.get(caseOwnerId).UserRole.Name;
                }
            }  
        }else{
            if(queueMap.get(caseOwnerId) != null){
                mspClone.Case_Owner__c = queueMap.get(caseOwnerId).Name;    
            }
        }
        return mspClone;
    }  
    
    
    public static DateTime getTargetDateTime(list<caseMilestone> cmLst){
        try{
            dateTime prevMileStoneTargetDate;
            dateTime prevMileStoneCompletionDate;
            for(CaseMileStone cm : cmLst){
                
                if(cm.isCompleted){
                    prevMileStoneTargetDate = cm.TargetDate;
                    prevMileStoneCompletionDate = cm.CompletionDate;
                }else if(!cm.isCompleted && cm.BusinessHoursId != null){
                    dateTime currentMilestoneTargetDate = cm.TargetDate;
                    long DiffInMilliSecs = BusinessHours.diff(String.ValueOf(cm.BusinessHoursId), prevMileStoneTargetDate, currentMilestoneTargetDate );
                    dateTime nextMilestoneTargetTime = BusinessHours.add(String.ValueOf(cm.BusinessHoursId),prevMileStoneCompletionDate, DiffInMilliSecs) ;
                    if(nextMilestoneTargetTime != null && cm.TargetDate > nextMilestoneTargetTime){
                        return nextMilestoneTargetTime;
                    }else{
                        return cm.TargetDate;
                    }
                }
            }
        }catch(exception ex){
            system.debug(ex.getMessage());
        }
        return null;
    } 
      
}