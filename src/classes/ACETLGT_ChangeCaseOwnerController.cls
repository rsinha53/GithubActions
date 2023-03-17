public class ACETLGT_ChangeCaseOwnerController {
    
    public String currentRecordId {get;set;}	
    
    public ACETLGT_ChangeCaseOwnerController(ApexPages.StandardController controller) {
        currentRecordId  = ApexPages.CurrentPage().getparameters().get('id');
        currentRecordId = String.isBlank(currentRecordId) ? currentRecordId : String.escapeSingleQuotes(currentRecordId); //US3636286 : Checkmarx Fix
    }

    @AuraEnabled
    public static List < sObject > fetchLookUpValues(String searchKeyWord, String ObjectName) {
     
        id currentUserProfileId 	= userinfo.getProfileId();  
        ACET_ChageCaseOwner__c cco 	= ACET_ChageCaseOwner__c.getValues(currentUserProfileId);
        
        List<String> availableProfiles 		= cco.Profile_Role_Available__c.split(', ');
        List<String> availableProfileIds	= New List<String>();
        
        If(availableProfiles.size()>0){
            for(integer i=0; i<availableProfiles.size(); i++){
                for (Profile proid : [Select Id From Profile Where Name=:availableProfiles[i]]){
                    availableProfileIds.add(proid.Id);
                }
            }
        }
        
        String searchKey = searchKeyWord + '%';
        
        List < sObject > returnList = new List < sObject > ();
        String sQuery = '';
        if(ObjectName=='User'){
            returnList = [select id, Name from user where Name LIKE: searchKey AND profileId=: availableProfileIds limit 10];
        }
        else if(ObjectName=='Queue'){
													 
             sQuery =  'select id, Name from Group Where Type = \'' +ObjectName + '\' AND Name LIKE: searchKey AND Name LIKE \''+cco.Queue_API_name_contains__c+'%\' limit 10';   //Harkunal:07/16/2021:US3705988
        }
        
        if(sQuery!=''){
            List < sObject > lstOfRecords = Database.query(sQuery);
            for (sObject obj: lstOfRecords) {
                returnList.add(obj);
            } 
        }
        
        return returnList;
    }
    
    @AuraEnabled   
    public static string updateCaseOwner(String caseId, sObject selectedrecord, String obj){
        
        string success = '';
        id currentUserProfileId 	= userinfo.getProfileId();        
        ACET_ChageCaseOwner__c cco 	= ACET_ChageCaseOwner__c.getValues(currentUserProfileId);
        
        Id newOwner = NULL;
        String newOwnerName = NULL;
        Case currentCase = [Select Id, CaseNumber, OwnerId, Status, Topic__c, Type__c, Subtype__c from Case Where Id=:caseId Limit 1];
        
        if(selectedrecord != NULL){
            newOwner = selectedrecord.Id;
            //newOwnerName = selectedrecord.Name;
        }
        
        if(obj == 'queue' && newOwner != NULL){
            Group queue = [SELECT Name FROM Group WHERE Type = 'Queue' AND Id =: newOwner];
            newOwnerName = queue.Name;
        }
        
        String caseTopic = currentCase.Topic__c;
        String caseType = currentCase.Type__c;
        String caseSubtype = currentCase.Subtype__c;
        
        if(newOwnerName == 'Motion System' && (caseTopic == null || caseType == null || caseSubtype == null)){
            success = 'TTS Validation Fail';
        }
        else{
            currentcase.OwnerId = newOwner;
            currentcase.Status = cco.Status_Update__c;
            update currentcase;
            success = 'Apex Success';
        }
        
        system.debug(success);
        return success;
    }
}