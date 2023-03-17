public with sharing class ACET_HomePage_CasesCtrl {
    
    @AuraEnabled
    public static list<Case> CaseRecordsData(){
        
        set<Id> caseTaskIdList = new set<Id>();
        List<Case> csList = [SELECT Id, (SELECT Id FROM Tasks) FROM Case Where OwnerId =: userinfo.getuserId()];//OpenActivities
        for (Case cs : csList){
            if(cs.Tasks.size() == 0){ caseTaskIdList.add(cs.Id); }
        }
        system.debug('caseTaskIdList---'+caseTaskIdList);
        
        set<Id> PRIdList = new set<Id>();
        List<Case> PRList = [SELECT Id, (SELECT Case__c from PIR_Resolution_Partners__r) FROM Case 
                             Where OwnerId =: userinfo.getuserId()];
        
        for (Case pr : PRList){
            if(pr.PIR_Resolution_Partners__r.size() == 0){ PRIdList.add(pr.Id); }
        }
        system.debug('PRIdList---'+PRIdList);
        
        List<Case> caseList = [select Id,CaseNumber,Status,CreatedDate from case 
                               where status NOT IN ('Closed')
                               AND ( (Id IN: PRIdList) OR (Id IN: caseTaskIdList) )
                               AND OwnerId =: userinfo.getuserId() ORDER BY CreatedDate DESC];
        
        return caseList;
    }
}