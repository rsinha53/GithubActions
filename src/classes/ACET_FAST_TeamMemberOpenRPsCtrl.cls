/*****************************************************************************************************
ACET_FAST_TeamMemberOpenRPsCtrl
Test Class Name:  ACET_FAST_TeamMemberOpenRPsCtrlTest
Author: Shaik Mohammad Yaseen
Description: This class is used an controller for ACET_FAST_TeamMemNoOpenTaskCases Component. 
Reference US3162395 - Supervisor Home Page Layout - RP records and Open cases with no open activites
01/13/2021 - Shaik Mohammad Yaseen - Initial 
******************************************************************************************************/
public with sharing class ACET_FAST_TeamMemberOpenRPsCtrl {
    @AuraEnabled
    public static ACET_FAST_TeamMemberOpenRPsCtrl.DisplayWrapper getRPRecords(String selRecType){
        ACET_FAST_Utility.LoggedInUserWrapper logInUser = new ACET_FAST_Utility.LoggedInUserWrapper();
        ACET_FAST_TeamMemberOpenRPsCtrl.DisplayWrapper dispWrap = new ACET_FAST_TeamMemberOpenRPsCtrl.DisplayWrapper();
        dispWrap.loggedInUserRole = logInUser.loggedInUserRole;
            dispWrap.isValidUser= true;
            set<Id> reporteeUserIDSet = new set<Id>();
            set<ID> caseIdSet = new set<Id>();
            List<ACET_FAST_TeamMemberOpenRPsCtrl.ListViewWrapper> rpListWrapper = new List<ACET_FAST_TeamMemberOpenRPsCtrl.ListViewWrapper>();
            for(User reportee:[SELECT id, ManagerId from user where ManagerId=: logInUser.loggedInUserId]){
                reporteeUserIDSet.add(reportee.id);
            }
            if(reporteeUserIDSet.size()>0){
                for(Case caseRec: [SELECT id, ownerId FROM Case WHERE ownerID IN: reporteeUserIDSet AND  RecordType.Name=:selRecType AND status!='Closed']){
                    caseIdSet.add(caseRec.id);
                }
            }
            if(caseIdSet.size()>0){
                if(selRecType=='Proactive Action'){
                    for(PIR_Resolution_Partner__c rpRec: [SELECT Id, Name, Case__c, Case__r.CaseNumber, CreatedDate, 
                                                          SLA_Due_Date__c, Provider_Matrix_Proactive__c, 
                                                          Provider_Matrix_Proactive__r.Name
                                                          FROM PIR_Resolution_Partner__c 
                                                          WHERE Case__c IN : caseIdSet
                                                          ORDER BY Case__r.CaseNumber LIMIT 2000])
                    {
                        rpListWrapper.add(new ACET_FAST_TeamMemberOpenRPsCtrl.ListViewWrapper(rpRec.Case__c, rpRec.Case__r.CaseNumber, rpRec.Provider_Matrix_Proactive__r.Name, rpRec.CreatedDate, rpRec.SLA_Due_Date__c));    
                    }
                } else {
                    for(PIR_Resolution_Partner__c rpRec: [SELECT Id, Name, Case__c, Case__r.CaseNumber, CreatedDate, 
                                                          SLA_Due_Date__c, Provider_Matrix_Reactive__c,
                                                          Provider_Matrix_Reactive__r.Name
                                                          FROM PIR_Resolution_Partner__c 
                                                          WHERE Case__c IN : caseIdSet and Resolution_Partner_Outcome__c != 'Resolved'
                                                          ORDER BY Case__r.CaseNumber LIMIT 20])
                    {
                        rpListWrapper.add(new ACET_FAST_TeamMemberOpenRPsCtrl.ListViewWrapper(rpRec.Case__c, rpRec.Case__r.CaseNumber, rpRec.Provider_Matrix_Reactive__r.Name, rpRec.CreatedDate, rpRec.SLA_Due_Date__c));    
                    }
                }
                
            }
            if(rpListWrapper.size()>0){
                dispWrap.recordListExists=true;
                dispWrap.rpListView.addAll(rpListWrapper);
                dispWrap.message='Records Retrived Succesfully';
            }
        return dispWrap;
    }
    public class ListViewWrapper{
        @AuraEnabled
        public Id caseId{set;get;}
        @AuraEnabled
        public String caseNumber{set;get;}
        @AuraEnabled
        public String rpName{set;get;}
        @AuraEnabled
        public Datetime dateCreated{set;get;}
        @AuraEnabled
        public Date sladueDate{set;get;} 
        public ListViewWrapper(Id caseId, String caseNumber, String rpName, Datetime dateCreated, Date sladueDate){
            this.caseId = caseId;
            this.caseNumber= caseNumber;
            this.rpName = rpName;
            this.dateCreated = dateCreated;
            this.sladueDate = sladueDate;
        }
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
        public List<ACET_FAST_TeamMemberOpenRPsCtrl.ListViewWrapper> rpListView{set;get;}
        public DisplayWrapper(){
            recordListExists=false;
            isValidUser=false;
            message='No Record To Display';
            rpListView = new List<ACET_FAST_TeamMemberOpenRPsCtrl.ListViewWrapper>();
        }
    }
}