/*****************************************************************************************************
ACET_FAST_CaseCommentsTriggerHandler
Test Class Name: ACET_FAST_CaseCommentsTriggerHandlerTest
Author: Santhosh Kukunarapu
Date: 10/20/2020
Description:  
Initial: Santhosh Kukunarapu
*****************************************************************************************************/
public with sharing class ACET_FAST_CaseCommentsTriggerHandler {
    public static void caseCommentsValidation(List<CaseComment> caseCommentList)
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
        for(CaseComment cmt : caseCommentList)
        {
            caseIds.add(cmt.ParentId);
        }
        for(case c : [select id, ownerid from case where id IN :caseIds and RecordTypeId IN (:fastRecordTypeId,:pipRecordTypeId)]){
            caseOwnerIdMap.put(c.id, c.OwnerId);
        }
        Map<id,set<id>> caseTeamMemberMap = ACET_FAST_Utility.getCaseTeamMemberMap(caseIds);
        for(CaseComment comment : caseCommentList)
        {
            if(caseOwnerIdMap.containsKey(comment.ParentId)){

                System.debug('check in comment condition');
                if(!listOfRoles.contains(userRoleName) && !excludeProfiles.contains(logInUser.loggedInUserProfile) && !(logInUser.isValidUser || logInUser.loggedInUserId == caseOwnerIdMap.get(comment.ParentId) || (caseTeamMemberMap.containsKey(comment.ParentId) && caseTeamMemberMap.get(comment.ParentId).contains(logInUser.loggedInUserId))))
                {
                    comment.addError(getErrorMessage);
                }
            }
        }
        }   
}