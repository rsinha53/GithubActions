trigger ACETcaseTrigger on Case (before update,before insert, after update, after insert, before delete, after delete) {
    
    /*US2941823 - FAST Case Permissions and Fields Validations*/
    if(trigger.isBefore && trigger.isUpdate && ACET_FAST_CasePrmsnFldVldtnHelper.isFirstTime){
        ACET_FAST_CasePrmsnFldVldtnHelper.isFirstTime=false;
        ACET_FAST_CasePrmsnFldVldtnHelper.handleCaseUpdate(trigger.new, trigger.OldMap);
        // #US2853357 Added by Santhosh K
        //ACET_FAST_CasePrmsnFldVldtnHelper.changeCaseRecordType(trigger.new,Trigger.oldMap);
    }
    if(Trigger.isAfter && Trigger.isUpdate && ACET_FAST_CaseController.isFirstTime){
        ACET_FAST_CaseController.isFirstTime = false;
        ACET_FAST_CasePrmsnFldVldtnHelper.handleAfterInsert(Trigger.new,Trigger.OldMap);
        // ACET_FAST_PlatformEventsHandler.preparePFEvents(Trigger.new,Trigger.OldMap);  
    } 
    
    /*US2941823 - FAST Case Permissions and Fields Validations*/
    
    /*US2880937: Case automation IMPACT to Spire*/
    if(trigger.isBefore && trigger.isInsert && ACET_FAST_Utility.isFirstTime){
        ACET_FAST_Utility.isFirstTime=false;
        ACET_FAST_CasePrmsnFldVldtnHelper.changeCaseOwner(trigger.new);
        ACET_FAST_CasePrmsnFldVldtnHelper.accountNameUpdate(trigger.new);
    }
    /*US2880937: Case automation IMPACT to Spire*/
    
    /*US3637678 - CPU: Interaction ID Creation*/
    if(trigger.isBefore && trigger.isInsert && ACET_FAST_ItoSCreateInteraction.isFirstTime){
        ACET_FAST_ItoSCreateInteraction.isFirstTime=false;
        ACET_FAST_ItoSCreateInteraction.insertInteraction(trigger.new);
    }
    /*US3637678 - CPU: Interaction ID Creation*/
    
    /*US3659697 - CPU: Interaction Automated Platform Event*/
    /* 
if(trigger.isAfter && trigger.isInsert && ACET_FAST_sendIntIdToMSoft.isFirstTime){
ACET_FAST_sendIntIdToMSoft.isFirstTime=false;
ACET_FAST_sendIntIdToMSoft.sendCaseToImpact(trigger.new);
}*/
    /*US3659697 - CPU: Interaction Automated Platform Event*/
    
    // US2720791- by pass for the SNI data migration - Inshar - 08/07/2020
    Boolean byPassOn = Boolean.valueOf(Label.SNI_ByPassOn); 
    Boolean migration_User = Label.SNI_DataMigration_Users.split(',').contains(UserInfo.getUserId().subString(0,15));
    Boolean sniByPass = !(byPassOn && migration_User);
    
    //Public Static Boolean sniProfileCheck;
    if(RecursiveTriggerHandler.allowSNICase){
        RecursiveTriggerHandler.sniProfileCheck=true;
    }
    else if(test.isRunningTest()){
        RecursiveTriggerHandler.sniProfileCheck=false;
    }
    else{
        // Added below if condition to skip the query exception for SF Connection user
        String loggeduser = Userinfo.getFirstName()+' '+Userinfo.getLastName();
        if(loggeduser!=null && loggeduser!='Connection User' && RecursiveTriggerHandler.sniProfileCheck==null){
            RecursiveTriggerHandler.sniProfileCheck=ACETUtility.fetchUser();
        }else if (loggeduser!=null && loggeduser=='Connection User')
        {
            RecursiveTriggerHandler.sniProfileCheck=false;
        }
    }
    
    if(trigger.isBefore){                
        
        if(trigger.isInsert){           
            
            // US2720791- by pass for the SNI data migration - Inshar - 08/07/2020
            if(sniByPass)
                ECMCaseTriggerHandler.handleBeforeInsert(trigger.new);
            
            // Below method populates the onshore restriction based on TTS from Routing Config details
            // US2720791- by pass for the SNI data migration - Inshar - 08/07/2020
            if(sniByPass)
                PC_CPMCaseTriggerHandler.populateOnshoreRestriction(Trigger.new, null);
            
            //US2256503 - Auto Populate field values for ECM case type
            if(RecursiveTriggerHandler.sniProfileCheck){
                SNICaseTriggerHandler.prePopulateFieldValues(Trigger.New);
            }
            
        }        
        
        if(trigger.isUpdate ){                      
            //calculating initial target date 
            // US2720791- by pass for the SNI data migration - Inshar - 08/07/2020
            if(sniByPass)
                ECMCaseTriggerHandler.calcInitialTargetDate(trigger.new, trigger.oldMap);
            
            if(RecursiveTriggerHandler.isFirstTime || test.isRunningTest()){ 
                
                //  method to call route on update- priority routing
                // US2720791- by pass for the SNI data migration - Inshar - 08/07/2020
                if(sniByPass)
                    ECMCaseTriggerHandler.pushCasetoUrgentQ(trigger.new, trigger.oldMap);  
                ECMCaseTriggerHandler.recordMilestonePerformance(trigger.new, trigger.oldMap);
                ECMCaseTriggerHandler.preventChangeOwnerToResearchUser(Trigger.New,trigger.oldMap);
                ECMCaseTriggerHandler.handleOwnerChnageRestriction(Trigger.new, Trigger.oldMap);
                
            }
            
            // US2720791- by pass for the SNI data migration - Inshar - 08/07/2020
            if(sniByPass) 
                ECMCaseTriggerHandler.preventChangeOwnerToResearchUser(Trigger.New,trigger.oldMap);
            ECMCaseTriggerHandler.handleOwnerChnageRestriction(Trigger.new, Trigger.oldMap);
            
            // Below method validates if case is closable for CPM compatibility.
            // US2720791- by pass for the SNI data migration - Inshar - 08/07/2020
            if(sniByPass)
                PC_CPMCaseTriggerHandler.validateCaseClosure(Trigger.new, Trigger.old);
            // Below method populates the onshore restriction based on TTS from Routing Config details
            // US2720791- by pass for the SNI data migration - Inshar - 08/07/2020
            if(sniByPass)
                PC_CPMCaseTriggerHandler.populateOnshoreRestriction(Trigger.new, Trigger.old);
            
            // Below method handles before update event for RESCU case
            // US2720791- by pass for the SNI data migration - Inshar - 08/07/2020
            //US3471281 - Removing as part of Decomissioning RESCU - Lahiru - 5/13
            /*
if(sniByPass)
PC_RESCUCaseTriggerHandler.handleBeforeUpdate(Trigger.newMap, Trigger.oldMap);
*/
            
            if(RecursiveTriggerHandler.sniProfileCheck){
                SNICaseTriggerHandler.closeCaseValidation(Trigger.new);
                SNICaseTriggerHandler.supportCaseOwnerChangeValidation(Trigger.new,trigger.oldMap);
            }
            
            // US3194807: TECH (Incl TESTING) : Validation on Parent Case Closure
            if(sniByPass)
                ECMCaseTriggerHelper.preventClosedParentCase(trigger.new, trigger.oldMap);
        }             
    }
    
    if(trigger.isAfter){
        if(trigger.isUpdate){    
            if(RecursiveTriggerHandler.isFirstTime || test.isRunningTest()){ 
                RecursiveTriggerHandler.isFirstTime= false;    
                
                //Added to autoclose case Milestones if case is closed.  
                // US2720791- by pass for the SNI data migration - Inshar - 08/07/2020
                if(sniByPass)
                    ECMCaseTriggerHandler.autocloseMilestones(trigger.new,  trigger.oldMap);
                
                // Create milestone performance creation on Change of owner
                // US2720791- by pass for the SNI data migration - Inshar - 08/07/2020
                if(sniByPass)
                    ECMCaseTriggerHandler.handleOWnerShipChangesForMp(trigger.new,  trigger.oldMap);
                
                //Send closed BEO cases to Solaris
                // US2720791- by pass for the SNI data migration - Inshar - 08/07/2020
                if(sniByPass)
                    ECMCaseTriggerHandler.sendSolarisClosedCases(trigger.new,  trigger.oldMap);
                
                //Whenver case is inserted populating Case's type and subtype on case Item 
                //Whenver case is updated and type and subtype values are changed, updating values on Unresolved case items
                // US2720791- by pass for the SNI data migration - Inshar - 08/07/2020
                if(sniByPass)
                    ECMCaseTriggerHelper.updateTypeAndSubTypeOnCaseItem(trigger.new, trigger.oldMap);
                
                //Change owner of Open Activities
                // US2720791- by pass for the SNI data migration - Inshar - 08/07/2020
                if(sniByPass)
                    ECMCaseTriggerHelper.prepareOwnerChangedCaseIds(trigger.newMap, trigger.oldMap);
                
                
                if(RecursiveTriggerHandler.sniProfileCheck){
                    SNICaseTriggerHandler.handleCaseUpdate(trigger.newMap, trigger.oldMap);
                }
                
                // US3076382 - Auto Complete Milestones
                if(sniByPass)   
                    ECMCaseTriggerHandler.autoCompleteMilestone(trigger.newMap,  trigger.oldMap);
            }         
            if(RecursiveTriggerHandler.isFirstCaseHistory){
                RecursiveTriggerHandler.isFirstCaseHistory = false;
                //Add case history in the SNI_FL_Activity__c Object
                SNI_FL_ActivitiesCaseTriggerHandler.handleAfterUpdate(trigger.new, trigger.oldMap);
            }
            // US2720791- by pass for the SNI data migration - Inshar - 08/07/2020
            //US3471281 - Removing as part of Decomissioning RESCU - Lahiru - 5/13
            /*
if(sniByPass)
PC_RESCUCaseTriggerHandler.recordRESCUCaseStatusPerformance(trigger.new, trigger.oldMap);
*/
            
            // US3043818 - Auto Close a Parent Case
            if(sniByPass)	
                ECMCaseTriggerHelper.autoClosedParentCase(trigger.newMap, trigger.oldMap);
            
        }
        //US2260867 - Copy case team from case overview to opportunity
        if(trigger.isInsert){
            if(RecursiveTriggerHandler.sniProfileCheck){
                SNICaseTriggerHandler.copyCaseTeamtoOpportunity(trigger.New);
                SNICaseTriggerHandler.handleCaseInsert(trigger.new);
            }
            //Add case history in the SNI_FL_Activity__c Object
            SNI_FL_ActivitiesCaseTriggerHandler.handleAfterInsert(trigger.new);
        }  
    }
    
    if(trigger.isbefore){
        if(trigger.isDelete){ 
            ECMCaseTriggerHandler.deleteFilesOnCaseDeletion(trigger.oldMap);
            if(RecursiveTriggerHandler.sniProfileCheck){
                SNICaseTriggerHandler.handleCaseDelete(trigger.oldMap);
            }
        }      
    }
    
    //Added by AC/DC Team to insert data into a custom object in the trigger execution
    //Author:Pavithra
    if(trigger.isAfter){
        if(trigger.isInsert || trigger.isUpdate){
            Id ecmRecordTypeID = Schema.SObjectType.Case.getRecordTypeInfosByName().get('ECM').getRecordTypeId();
            /*   Set<Id> conIds = new Set<Id>();
for (Case c: trigger.new) {
conIds.add(c.ContactId);
}
Map<Id, Contact> conMap = new Map<Id, Contact>([SELECT Id, Email FROM Contact WHERE Id In :conIds]); */
            system.debug('in #222'+Trigger.new.size());
            
            for(Case record : Trigger.new) {
                
                // Contact relatedCaseContact = conMap.get(record.ContactId);
                if(record.RecordTypeId == ecmRecordTypeID) {
                    if(Trigger.isInsert){
                        if(!SNI_FLDirectMessageUtil.insertCaseNotificationRecursiveCheck){
                            if(System.Limits.getLimitQueries() - System.Limits.getQueries() >= 3 ){
                                SNI_FLDirectMessageObjectQuery.insertCaseNotification(trigger.new);
                            }
                            SNI_FLDirectMessageUtil.insertCaseNotificationRecursiveCheck = true;
                        }
                    } else if(Trigger.isUpdate){
                        
                        if(!SNI_FLDirectMessageUtil.updateCaseNotificationRecursiveCheck){
                            if(System.Limits.getLimitQueries() - System.Limits.getQueries() >= 3 ){
                                SNI_FLDirectMessageObjectQuery.insertCaseNotification(trigger.new);
                            }
                            SNI_FLDirectMessageUtil.updateCaseNotificationRecursiveCheck = true;
                        }
                    }
                }
                system.debug('#236');
                system.debug('#246'+  (trigger.isupdate && record.Status != trigger.oldMap.get(record.Id).status));
                
                if(trigger.isInsert || (trigger.isupdate && record.Status != trigger.oldMap.get(record.Id).status)){
                    system.debug('in #249');
                    If(System.IsBatch() == false && System.isFuture() == false){
                        system.debug('in #247');
                        //SNI_FL_Notification_Center.SendNotification(record.AccountId);
                    }
                }
            }
            
        }
    }
}