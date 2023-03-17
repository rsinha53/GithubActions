public without sharing class SNI_FL_FamilySelectionController {
    @auraEnabled
    Public Static FamilyDetailsWrapper getFamilyDetails(){
        boolean ErrorOccured = false;
        List<Id> familyIdList = new List<Id>();
        Map<Id,String> familyNameMap = new Map<Id,String>();
        Map<Id,List<String>> careTeamMap = new  Map<Id,List<String>>();
        FamilyDetailsWrapper wrapper = new FamilyDetailsWrapper();
        Map<Id,String> fLinkAccountOwner = new Map<Id,String>();
        try{
            Id userId =UserInfo.getUserId();
            User u = [select id, contactId,contact.accountId from User where id = : userId];
            Id getPersonAccountId = u.contact.accountId;
            if(getPersonAccountId != null){
                
                for(SNI_FL_Care_Team_Member__c familyAccountId : [SELECT SNI_FL_Family__c,Id,SNI_FL_Family__r.Id,SNI_FL_Family__r.Family__c From SNI_FL_Care_Team_Member__c WHERE SNI_FL_Member__c =:getPersonAccountId and SNI_FL_Not_Visible_in_Familylink__c != true and SNI_FL_Status__c = 'Registered' ]){
                    familyNameMap.put(familyAccountId.SNI_FL_Family__r.Id,familyAccountId.SNI_FL_Family__r.Family__c);
                    String firstName,lastName,name;
                    for(SNI_FL_Care_Team_Member__c personAccountId : [SELECT Id,SNI_FL_Family__c,SNI_FL_Family__r.Id,SNI_FL_Member__c,SNI_FL_Member__r.FirstName,SNI_FL_Member__r.LastName,SNI_FL_Primary_Caregiver__c From SNI_FL_Care_Team_Member__c WHERE SNI_FL_Family__c =:familyAccountId.SNI_FL_Family__c  and SNI_FL_Not_Visible_in_Familylink__c != true and SNI_FL_Status__c!='Removed' ]){
                       firstName = String.isBlank(personAccountId.SNI_FL_Member__r.FirstName) ? ' ' : personAccountId.SNI_FL_Member__r.FirstName;
                       lastName = String.isBlank(personAccountId.SNI_FL_Member__r.LastName) ? ' ' : personAccountId.SNI_FL_Member__r.LastName; 
                       name = firstName + ' ' + lastName;
                        
                       if(personAccountId.SNI_FL_Primary_Caregiver__c != true){
                       	    
                        if(careTeamMap.containsKey(personAccountId.SNI_FL_Family__r.Id)){
                            List<String> careTeamMemList = careTeamMap.get(personAccountId.SNI_FL_Family__r.Id);
                            //careTeamMemList.add(personAccountId.SNI_FL_Member__r.FirstName+' '+personAccountId.SNI_FL_Member__r.LastName);
                            careTeamMemList.add(name);
                            careTeamMap.put(personAccountId.SNI_FL_Family__r.Id,careTeamMemList);
                        }
                       	else{
                            //careTeamMap.put(personAccountId.SNI_FL_Family__r.Id,new List<String>{personAccountId.SNI_FL_Member__r.FirstName+' '+personAccountId.SNI_FL_Member__r.LastName});
                       		careTeamMap.put(personAccountId.SNI_FL_Family__r.Id,new List<String>{name});
                        }
                       }
                       if(personAccountId.SNI_FL_Primary_Caregiver__c == true){
                            //fLinkAccountOwner.put(personAccountId.SNI_FL_Family__r.Id,personAccountId.SNI_FL_Member__r.FirstName+' '+personAccountId.SNI_FL_Member__r.LastName);
                        	fLinkAccountOwner.put(personAccountId.SNI_FL_Family__r.Id,name);	
                       }
                       System.debug('careTeamMap=='+careTeamMap);
                    }
                }
                wrapper.familyNameMap = familyNameMap ;
                wrapper.careTeamMap =careTeamMap;
                wrapper.fLinkAccountOwner =fLinkAccountOwner;
            }
            system.debug('wrapper'+wrapper);
        }catch(Exception e){
            AcetUtility.CreateAndRedirectToError('FamilyLink','SNI_FL_FamilySelectionController',e);
            ErrorOccured = true;
        }
        wrapper.ErrorOccured = ErrorOccured ;
        return wrapper;
    }
    // wrapper class 
    public class FamilyDetailsWrapper{
        @AuraEnabled
        public boolean ErrorOccured {get;set;}
        @AuraEnabled
         Public Map<Id,String> familyNameMap ;
        @AuraEnabled
         Public Map<Id,List<String>> careTeamMap ;
        @AuraEnabled
         Public Map<Id,String> fLinkAccountOwner ;
    }
}