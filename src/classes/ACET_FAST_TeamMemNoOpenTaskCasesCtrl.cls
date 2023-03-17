/*****************************************************************************************************
ACET_FAST_TeamMemNoOpenTaskCasesCtrl
Test Class Name:  ACET_FAST_TeamMemNoOpenTaskCasesCtrlTest
Author: Shaik Mohammad Yaseen
Description: This class is used an controller for ACET_FAST_TeamMemNoOpenTaskCases Component. 
Reference US3162395 - Supervisor Home Page Layout - RP records and Open cases with no open activites
01/15/2021 - Shaik Mohammad Yaseen - Initial 
******************************************************************************************************/
public with sharing class ACET_FAST_TeamMemNoOpenTaskCasesCtrl {
    @AuraEnabled
    public static ACET_FAST_TeamMemNoOpenTaskCasesCtrl.DisplayWrapper getOpenTaskCases(String selRecType){ 
        ACET_FAST_TeamMemNoOpenTaskCasesCtrl.DisplayWrapper dispWrap = new ACET_FAST_TeamMemNoOpenTaskCasesCtrl.DisplayWrapper();
        ACET_FAST_Utility.LoggedInUserWrapper logInUser = new ACET_FAST_Utility.LoggedInUserWrapper();
        dispWrap.loggedInUserRole = logInUser.loggedInUserRole;
        if(logInUser.loggedInUserRole=='PIR - Reactive/Proactive Supervisor'){
            dispWrap.isValidUser= true;
            set<Id> reporteeUserIDSet = new set<Id>();
            for(User reportee:[SELECT id, ManagerId from user where ManagerId=: logInUser.loggedInUserId]){
                reporteeUserIDSet.add(reportee.id);
            }
            if(reporteeUserIDSet.size()>0){
                for(Case caseRec: [SELECT id, Status, Owner.Name, ownerId,CaseNumber, (SELECT id FROM tasks WHERE Status='In Progress' OR Status='Not Started') FROM Case WHERE ownerID IN: reporteeUserIDSet AND  RecordType.Name=:selRecType  LIMIT 2000]){
                    if(caseRec.tasks.size()<=0){
                        dispWrap.recordListExists=true;
                        dispWrap.message='Records Retrived Succesfully';
                        dispWrap.caseList.add(caseRec);
                    }
                }
            }
        }
        return dispWrap;
    }
    public class DisplayWrapper{
        @AuraEnabled
        public string loggedInUserRole{set;get;}
        @AuraEnabled
        public boolean recordListExists{set;get;}
        @AuraEnabled
        public boolean isValidUser{set;get;}
        @AuraEnabled
        public string message{set;get;}
        @AuraEnabled 
        public List<Case> caseList{set;get;}
        public DisplayWrapper(){
            recordListExists=false;
            isValidUser=false;
            message='No Record To Display';
            caseList = new List<Case>();
        }
    }
}