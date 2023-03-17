/*****************************************************************************************************
ACET_Fast_CaseTaskOwnerTrgHandler
Test Class Name:  ACET_Fast_CaseTaskOwnerTrgHandlerTest
Author: Shaik Mohammad Yaseen
Description: This class is used asn handler for task trigger to handle the fast access roles on case. 
10/21/2020 - Shaik Mohammad Yaseen - Initial
******************************************************************************************************/
public without sharing class ACET_Fast_CaseTaskOwnerTrgHandler {
    public static Boolean isFirstTime = true;
    public static ACET_FAST_Utility.LoggedInUserWrapper logInUser = new ACET_FAST_Utility.LoggedInUserWrapper();

    public static void handleBeforeInsertOrUpdate(List<Task> triggerNew, map<Id,Task> triggerOldMap, string event){
        Id fastE2ETaskId = Schema.SObjectType.Task.getRecordTypeInfosByDeveloperName().get('Reactive_Resolution_Proactive_Action').getRecordTypeId();
       
        List<Task> fastRecTypeTask = new List<Task> ();
        
        for(Task tskVar: triggerNew){            
            if(tskVar.recordtypeid == fastE2ETaskId && ACET_FAST_CasePrmsnFldVldtnHelper.isFirstTime){
                fastRecTypeTask.add(tskVar);
            }            
        }
        
        if(fastRecTypeTask.size()>0)
        {
            ACET_Fast_CaseTaskOwnerTrgHandler.TaskWrapper taskWrp = ACET_Fast_CaseTaskOwnerTrgHandler.getTaskWrapper(triggerNew,logInUser.loggedInUserId);
           
           Map<id,set<id>> caseTeamMemberMap = ACET_FAST_Utility.getCaseTeamMemberMap(taskWrp.caseIdSet);
            //checking for tasklist size is greater 0
            system.debug('Case Team Map-->'+caseTeamMemberMap);
            if(taskWrp.taskList.size()>0){
                
                //iterating the trigger.new records
                for(Task tskVar: triggerNew){
                    //checking if the task record belong to case
                    if(taskWrp.caseTaskIdSet.contains(tskVar.id)){
                        validateTaskRec(tskVar,event,triggerOldMap,taskWrp,caseTeamMemberMap);
                    }
                }
            }
        }
    } 

    public static void validateTaskRec(Task tskVar,string event,map<Id,Task> triggerOldMap,ACET_Fast_CaseTaskOwnerTrgHandler.TaskWrapper taskWrp, Map<id,set<id>> caseTeamMemberMap){
                                //checking if the logged in user is a valid user with valid roles or he is owner of case
                        //if(logInUser.isValidUser || taskWrp.userCanAccessCaseIdSet.contains(tskVar.whatId)){
                            if(logInUser.isValidUser || taskWrp.userCanAccessCaseIdSet.contains(tskVar.whatId) || (caseTeamMemberMap.containsKey(tskVar.whatId) && caseTeamMemberMap.get(tskVar.whatId).contains(logInUser.loggedInUserId))){
                                //checking if the case record`s status is closed
                                if(taskWrp.taskCaseIdCaseMap.containsKey(tskVar.whatId) && taskWrp.taskCaseIdCaseMap.get(tskVar.whatId).status=='Closed'){
                                    //throwing error if the task is closed
                                    tskVar.addError(ACET_FAST_Constants.cannotAddTaskToClosedCases);
                                }
                                else{
                                    if(tskVar.Priority=='' || tskVar.Priority==null || tskVar.Status=='' || tskVar.Status==null || tskVar.ActivityDate==null){
                                        //throwing error for mandatory fields
                                        tskVar.addError(ACET_FAST_Constants.taskFieldsMandatoryError);
                                    }
                                    else{
                                        validateTaskDueDate(tskVar,event,triggerOldMap);
                                    }
                                }
                            }
                            else{
                                //throwing error user not a valid user
                                tskVar.addError(ACET_FAST_Constants.notaValiFastRoleError);
                            }
    }

    public static void validateTaskDueDate(Task tskVar, String event,map<Id,Task> triggerOldMap){
                            //throw error if due date is a past date on insert event
                            if(event=='Insert' && tskVar.ActivityDate < system.today()){
                                tskVar.addError(ACET_FAST_Constants.taskDueDatepastDateError);
                        }
                        if(event=='Update' && tskVar.ActivityDate != triggerOldMap.get(tskVar.id).ActivityDate){
                                //throwing error for due date field change
                                tskVar.addError(ACET_FAST_Constants.taskDueDateChangeError);   
                        }
    }

    public static ACET_Fast_CaseTaskOwnerTrgHandler.TaskWrapper getTaskWrapper(List<Task> triggerNewList, id logInUserId){
        ACET_Fast_CaseTaskOwnerTrgHandler.TaskWrapper wrapVar = new ACET_Fast_CaseTaskOwnerTrgHandler.TaskWrapper();
        ID fastRecordTypeId = ACET_Fast_ProviderContactCtrl.getRecordTypeIdbyDevName('CASE','Reactive_Resolution'); 
        ID fastClosedRecordTypeId = ACET_Fast_ProviderContactCtrl.getRecordTypeIdbyDevName('CASE','Reactive_Resolution_Closed'); 
        ID pipRecordTypeId = ACET_Fast_ProviderContactCtrl.getRecordTypeIdbyDevName('CASE','Proactive_Action');
        ID pipClosedRecordTypeId = ACET_Fast_ProviderContactCtrl.getRecordTypeIdbyDevName('CASE','Proactive_Action_Closed');

        map<id,List<Task>> caseIDTaskList = new map<id,List<Task>>();
        map<id,set<Id>> caseIDTaskIdSetMap = new map<id,set<id>>();
        //iterating all the records from trigger.New
        for(Task tsk:triggerNewList){
            //check if the what id or Related To ID is null to check if the id belongs to case
            if(tsk.whatId!=null && ACET_FAST_Utility.getObjectName(tsk.whatId)=='Case'){
                //now to checking if the what id is belonging to case record
                    if(!caseIDTaskList.containsKey(tsk.whatId)){
                        caseIDTaskList.put(tsk.whatId, new List<Task>());
                        caseIDTaskIdSetMap.put(tsk.whatId, new set<Id>());
                    }
                    caseIDTaskList.get(tsk.whatId).add(tsk); 
                    caseIDTaskIdSetMap.get(tsk.whatId).add(tsk.Id);
            }
        }
        if(caseIDTaskList.size()>0){
            for(Case caseVar: [SELECT id, ownerId, Status, RecordType.Name FROM Case WHERE Id IN: caseIDTaskList.keySet() and RecordTypeId IN (:fastRecordTypeId,:pipRecordTypeId,:fastClosedRecordTypeId,:pipClosedRecordTypeId)]){
                    //collecting the task record belonging to case
                    wrapVar.taskList.addAll(caseIDTaskList.get(caseVar.Id));
                    //collecting the task record belonging to case
                    wrapVar.caseTaskIdSet.addAll(caseIDTaskIdSetMap.get(caseVar.Id));
                    //collecting the task id`s belonging to case
                    wrapVar.caseIdSet.add(caseVar.Id);
                    wrapVar.taskCaseIdCaseMap.put(caseVar.id,caseVar);
                    if(caseVar.ownerId == logInUserId){
                        wrapVar.userCanAccessCaseIdSet.add(caseVar.Id);
                    }
            }   
        }
        return wrapVar;
    }
    public class TaskWrapper{
        //case related tasks will be stored in list
        public List<Task> taskList;
        //collect task ids which belong to care record
        public set<Id> caseTaskIdSet;
        //case record Id`s to be store whicn belong to the case
        public set<Id> caseIdSet;
        //will store the case id`s if the logged in user is case owner
        set<Id> userCanAccessCaseIdSet;
        //task record`s case map 
        public map<Id,case> taskCaseIdCaseMap;
        public TaskWrapper(){
            taskList = new List<Task>();
            caseTaskIdSet = new set<Id>();
            caseIdSet = new Set<id>();
            taskCaseIdCaseMap = new map<Id,Case>();
            userCanAccessCaseIdSet= new set<Id>();
        }
    }
}