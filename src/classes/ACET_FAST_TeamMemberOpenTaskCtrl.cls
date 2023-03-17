public with sharing class ACET_FAST_TeamMemberOpenTaskCtrl {
    
    @AuraEnabled
    public static ACET_FAST_TeamMemberOpenTaskCtrl.DisplayWrapper getOpenTasks(){
        
        ACET_FAST_Utility.LoggedInUserWrapper logInUser = new ACET_FAST_Utility.LoggedInUserWrapper();
        ACET_FAST_TeamMemberOpenTaskCtrl.DisplayWrapper dispWrap = new ACET_FAST_TeamMemberOpenTaskCtrl.DisplayWrapper();
        dispWrap.loggedInUserRole = logInUser.loggedInUserRole;
        
            dispWrap.isValidUser= true;
            set<Id> reporteeUserIDSet = new set<Id>();
            set<ID> taskIdSet = new set<Id>();
            List<ACET_FAST_TeamMemberOpenTaskCtrl.ListViewWrapper> rpListWrapper = new List<ACET_FAST_TeamMemberOpenTaskCtrl.ListViewWrapper>();
            for(User reportee:[SELECT id, ManagerId from user where ManagerId=:logInUser.loggedInUserId]){
                reporteeUserIDSet.add(reportee.id);
            }
            for(Task tsk : [SELECT id, status FROM Task WHERE ownerID IN: reporteeUserIDSet and status!='Completed']){
                taskIdSet.add(tsk.id);
            }
            Map<Id,User> ownerMap;
            Map<Id,Case> caseMap;
            Set<Id> taskOwnerIds = new Set<Id>();
            Set<Id> whatIds = new Set<Id>();
            List<Task> taskList = [SELECT Id,OwnerId,Owner.Name, ActivityDate, WhatId, Status FROM Task WHERE Id IN : taskIdSet ORDER BY Type LIMIT 2000];
            for(Task t : taskList)
            {
                taskOwnerIds.add(t.OwnerId);
                System.debug('whatId'+t.WhatId);
                if(t.WhatId != null)
                {
                    System.debug('whatId In'+t.WhatId);
                    Schema.sObjectType sObjType = t.WhatId.getSObjectType();
                    Schema.DescribeSObjectResult sObjDescribeResult = sObjType.getDescribe();
                    if(sObjDescribeResult.name == 'Case')
                    {
                        whatIds.add(t.WhatId);
                    }
                }
            }
            ownerMap = new Map<Id,User>([SELECT Id, Name FROM User WHERE Id IN :taskOwnerIds]);
            caseMap = new Map<Id,Case>([SELECT Id, CaseNumber FROM Case WHERE Id IN :whatIds]);
            if(taskIdSet.size()>0){
                for(Task tsk: taskList)
                {
                    rpListWrapper.add(new ACET_FAST_TeamMemberOpenTaskCtrl.ListViewWrapper(tsk.OwnerId,ownerMap.get(tsk.OwnerId).Name,
                                                                                           tsk.ActivityDate,
                                                                                           tsk.WhatId,caseMap.Containskey(tsk.whatID) ? caseMap.get(tsk.whatID).CaseNumber:'',tsk.Status)); 
                    
                    
                }
            }
            if(rpListWrapper.size()>0){
                system.debug('inside rpListWrapper==>'+rpListWrapper);
                dispWrap.recordListExists=true;
                dispWrap.rpListView.addAll(rpListWrapper);
                dispWrap.message='Records Retrived Succesfully';
            }
        
        return dispWrap;
    }
    public class ListViewWrapper{
        
        @AuraEnabled
        public Id assingedTo{set;get;}
        @AuraEnabled
        public String assingedName{set;get;}
        @AuraEnabled
        public Date dueDate{set;get;}
        @AuraEnabled
        public Id relatedTo{set;get;}
        @AuraEnabled
        public String relatedToName{set;get;}
        @AuraEnabled
        public String status{set;get;}
        
        //Assinged To, Due Date, Related To, Status
        public ListViewWrapper(Id assingedTo,String assingedName,Date dueDate,String relatedTo,String relatedToName,String status){
            this.assingedTo=assingedTo;
            this.assingedName = assingedName;
            this.dueDate = dueDate;
            this.relatedTo = relatedTo;
            this.relatedToName = relatedToName;
            this.status= status;
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
        public List<ACET_FAST_TeamMemberOpenTaskCtrl.ListViewWrapper> rpListView{set;get;}
        public DisplayWrapper(){
            recordListExists=false;
            isValidUser=false;
            message='No Record To Display';
            rpListView = new List<ACET_FAST_TeamMemberOpenTaskCtrl.ListViewWrapper>();
        }
    }
    
}