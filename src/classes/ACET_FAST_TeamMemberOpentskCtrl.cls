public with sharing class ACET_FAST_TeamMemberOpentskCtrl {
     @AuraEnabled
    public static ACET_FAST_TeamMemberOpentskCtrl.DisplayWrapper getRPRecords(){
        
        ACET_FAST_Utility.LoggedInUserWrapper logInUser = new ACET_FAST_Utility.LoggedInUserWrapper();
        ACET_FAST_TeamMemberOpentskCtrl.DisplayWrapper dispWrap = new ACET_FAST_TeamMemberOpentskCtrl.DisplayWrapper();
        dispWrap.loggedInUserRole = logInUser.loggedInUserRole;
        System.debug('check role'+logInUser.loggedInUserRole);
        System.debug('check role'+logInUser.loggedInUserId);
        if(logInUser.loggedInUserRole=='PIR - Reactive/Proactive Supervisor')
        {
            dispWrap.isValidUser= true;
            set<Id> reporteeUserIDSet = new set<Id>();
            set<ID> caseIdSet = new set<Id>();
            List<ACET_FAST_TeamMemberOpentskCtrl.ListViewWrapper> rpListWrapper = new List<ACET_FAST_TeamMemberOpentskCtrl.ListViewWrapper>();
            for(User reportee:[SELECT id, ManagerId from user where ManagerId=:logInUser.loggedInUserId]){
                reporteeUserIDSet.add(reportee.id);
            }
            if(reporteeUserIDSet.size()>0){
                system.debug('inside reporteeUserIDSet==>'+reporteeUserIDSet);
                for(Case caseRec: [SELECT id, ownerId FROM Case WHERE ownerID IN: reporteeUserIDSet AND  (RecordType.Name='Proactive Action' OR RecordType.Name='Reactive Resolution') ]){
                    caseIdSet.add(caseRec.id);
                }
            }
            if(caseIdSet.size()>0){
                for(Case c: [SELECT Id,CaseNumber, LastModifiedDate, Status, Topic__c, PIR_Event_Age__c,PC_Provider_TIN__c, Subtype__c,Owner.Name,Subject,Type FROM Case WHERE Id IN : caseIdSet ORDER BY Type LIMIT 2000])
                {
                    rpListWrapper.add(new ACET_FAST_TeamMemberOpentskCtrl.ListViewWrapper(c.Id,c.CaseNumber,c.PC_Provider_TIN__c, 
                                                                                          c.Subject , 
                                                                                          c.Owner.Name,
                                                                                          c.Status, 
                                                                                          c.Topic__c,
                                                                                          c.Subtype__c,
                                                                                          c.Type,
                                                                                          c.LastModifiedDate,
                                                                                          c.PIR_Event_Age__c)); 
                
            }
            }
            if(rpListWrapper.size()>0){
                system.debug('inside rpListWrapper==>'+rpListWrapper);
                dispWrap.recordListExists=true;
                dispWrap.rpListView.addAll(rpListWrapper);
                dispWrap.message='Records Retrived Succesfully';
            }
        }
        return dispWrap;
    }
    public class ListViewWrapper{
        @AuraEnabled
        public Id caseId{set;get;}
        @AuraEnabled
        public String caseNumber{set;get;}
        @AuraEnabled
        public String providerTIN{set;get;}
        @AuraEnabled
        public String ownername{set;get;}
        @AuraEnabled
        public String status{set;get;}
        @AuraEnabled
        public String subject{set;get;}
        @AuraEnabled
        public String topic{set;get;}
        @AuraEnabled
        public String type{set;get;}
         @AuraEnabled
        public String subType{set;get;}
        @AuraEnabled
        public DateTime lastModifiedDate{set;get;} 
         @AuraEnabled
        public Decimal eventAge{set;get;}
        
      
    public ListViewWrapper(Id caseId,String caseNumber,String providerTIN,String subject,String ownername, String status, String topic, String type, String subType, DateTime lastModifiedDate,Decimal eventAge){
            this.caseId=caseId;
            this.caseNumber = caseNumber;
            this.providerTIN = providerTIN;
            this.ownername= ownername;
            this.subject = subject;
            this.status = status;
            this.topic = topic;
            this.subType = subType;
            this.type = type;
            this.lastModifiedDate = lastModifiedDate;
            this.eventAge = eventAge;
           
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
        public List<ACET_FAST_TeamMemberOpentskCtrl.ListViewWrapper> rpListView{set;get;}
        public DisplayWrapper(){
            recordListExists=false;
            isValidUser=false;
            message='No Record To Display';
            rpListView = new List<ACET_FAST_TeamMemberOpentskCtrl.ListViewWrapper>();
        }
    }

}