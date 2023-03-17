/*****************************************************************************************************
ACET_FAST_CaseDocumentLinkTriggerHandler
Test Class Name: ACET_FAST_CaseDocumentTriggerHandlerTest
Author: Santhosh Kukunarapu
Date: 10/20/2020
Description:  
Initial: Santhosh Kukunarapu
*****************************************************************************************************/

public with sharing class ACET_FAST_CaseDocumentLinkTriggerHandler {
    
    public static Boolean isFirstTime = true;
    
    public static void caseDocumentLinkValidation(List<ContentDocumentLink> contentDocLinkList)
    {
        ACET_FAST_Utility.LoggedInUserWrapper logInUser = new ACET_FAST_Utility.LoggedInUserWrapper();
        String userRoleName = ACET_FAST_Utility.getLoggedInUserRole();
        String  getErrorMessage = ACET_FAST_Constants.notaValiFastRoleError;
        Set<String> listOfRoles = ACET_FAST_Constants.validRoles;
        Set<String> excludeProfiles = new Set<String>{'Integration Only','PIR Support Cases Profile','Integration'};

        ID fastRecordTypeId = ACET_Fast_ProviderContactCtrl.getRecordTypeIdbyDevName('CASE','Reactive_Resolution'); 
        ID pipRecordTypeId = ACET_Fast_ProviderContactCtrl.getRecordTypeIdbyDevName('CASE','Proactive_Action');  
         Set<id> caseIds = new Set<id>();
        Map<id,id> caseOwnerIdMap = new Map<id,id>();
        
        for(ContentDocumentLink conLink : contentDocLinkList)
        {
            ID parentId = conLink.LinkedEntityId;
            String parId = String.valueOf(parentId);
            if(parId.startsWith('500'))
            {
                caseIds.add(ParentId);
            }
        }
        
        for(case c : [select id, ownerid from case where id IN :caseIds and RecordTypeId IN (:fastRecordTypeId,:pipRecordTypeId)]){
            caseOwnerIdMap.put(c.id, c.OwnerId);
        }
         Map<id,set<id>> caseTeamMemberMap = ACET_FAST_Utility.getCaseTeamMemberMap(caseIds);
        for(ContentDocumentLink conLink : contentDocLinkList)
        {
            Id parentId = conLink.LinkedEntityId;
            String parIdStr =  String.valueOf(parentId);
            system.debug('parentId -->'+ parentId);
            system.debug('parIdStr -->'+ parIdStr);
           if(parIdStr.startsWith('500') && caseOwnerIdMap.containsKey(parentId) && !excludeProfiles.contains(logInUser.loggedInUserProfile) && (!listOfRoles.contains(userRoleName) &&  !(logInUser.isValidUser || logInUser.loggedInUserId == caseOwnerIdMap.get(parentId) || (caseTeamMemberMap.containsKey(ParentId) && caseTeamMemberMap.get(ParentId).contains(logInUser.loggedInUserId))))){        
                        system.debug('Inside error');
                        conLink.addError(getErrorMessage);
            }
        }
    }

      
}