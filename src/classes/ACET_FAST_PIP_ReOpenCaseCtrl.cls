public with sharing class ACET_FAST_PIP_ReOpenCaseCtrl {
	
    @AuraEnabled
    public static User getUserDetails(){
        user usr = [SELECT Id, UserRoleId, ProfileId,profile.name, UserRole.Name FROM User Where Id =:UserInfo.getUserId()];
        return usr;
    }
    
    @AuraEnabled
    public static boolean getValiduser(string caseRecId){
        boolean userValid = false;
        ACET_FAST_Utility.LoggedInUserWrapper logInUser = new ACET_FAST_Utility.LoggedInUserWrapper();
        case cs = [select Id,OwnerId  from case where Id=:caseRecId];
        set<id> casId = new set<id>();
        casId.add(Id.valueOf(caseRecId));

        Map<id,set<id>> caseTeamMemberMap = ACET_FAST_Utility.getCaseTeamMemberMap(casId);
        
        if( logInUser.isValidUser || logInUser.loggedInUserId==cs.OwnerId ||  (caseTeamMemberMap.containsKey(Id.valueOf(caseRecId)) && caseTeamMemberMap.get(Id.valueOf(caseRecId)).contains(logInUser.loggedInUserId)) ){
            userValid = true;
        } 
        return userValid;
    }
    
    @AuraEnabled
    public static PIR_Detail__c getPIRRecId(string caseRecId){
        PIR_Detail__c pirDetail = new PIR_Detail__c();
        if(caseRecId!='' && caseRecId!=null){
            pirDetail = [SELECT Id,Case__r.Status,RecordType.Name,Status__c,Case__r.OwnerId FROM PIR_Detail__c WHERE Case__c=:caseRecId];
        }
        return pirDetail;
    }
    
    @AuraEnabled
    public static string updateCaseRecord(Id caseRecId){
        string returnmsg;
        system.debug('caseRecId--'+caseRecId);
        case caseRec = [SELECT id, Status FROM Case WHERE id=:caseRecId];
        caseRec.Status = 'Reopen';
        try{
            ACET_FAST_PIP_ReOpenCaseCtrl.updateReOpenCustomSetting(false);
            update caseRec;
            returnmsg = 'SUCCESS';
        }catch(exception e){
            throw new AuraHandledException(e.getMessage());
        }finally{
            ACET_FAST_PIP_ReOpenCaseCtrl.updateReOpenCustomSetting(true);
        }
        return returnmsg;
    }
    
    @AuraEnabled
    public static void updatePIR(Id caseRecId){
        PIR_Detail__c pirDetail = [SELECT Id,Case__r.Status,RecordType.Name,Status__c FROM PIR_Detail__c WHERE Case__c=:caseRecId];
        pirDetail.Status__c = 'Closed';
        update pirDetail;
    }
    
    public static void updateReOpenCustomSetting(boolean valueToUpdate){
        ACET_FAST_ManageReOpenCase__c manageReOpenCase = [Select Id, Do_Not_Allow_ReOpen__c From ACET_FAST_ManageReOpenCase__c];
        manageReOpenCase.Do_Not_Allow_ReOpen__c = valueToUpdate;
        update manageReOpenCase;
    }
    
}