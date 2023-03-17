/*************************************************************************************************************
 * @name			ACET_FAST_PIRRP_TriggerHandler
 * @author			mrajen15 <muthukumarr@optum.com>
 * @created			24 / 10 / 2020
 * @description		Handler class for PIR Resolution Partner Trigger
 *
 * Changes (version)
 * -----------------------------------------------------------------------------------------------------------
 * 				No.		Date			Author					Description
 * 				----	------------	--------------------	----------------------------------------------
 * @version		1.0		2020-10-24		mrajen15				Initial
 *
**************************************************************************************************************/
public with sharing class ACET_FAST_PIRRP_TriggerHandler {

    public static void handleBeforeInsertOrUpdate(List<PIR_Resolution_Partner__c> pirList) {        
		
        //Get Logged In User Details
        ACET_FAST_Utility.LoggedInUserWrapper logInUser = new ACET_FAST_Utility.LoggedInUserWrapper();
        ID fastRecordTypeId = ACET_Fast_ProviderContactCtrl.getRecordTypeIdbyDevName('CASE','Reactive_Resolution'); 
        ID pipRecordTypeId = ACET_Fast_ProviderContactCtrl.getRecordTypeIdbyDevName('CASE','Proactive_Action');

        Set<id> caseIds = new Set<id>();
        Map<id,id> caseOwnerIdMap = new Map<id,id>();
        
        for(PIR_Resolution_Partner__c RPRec : pirList){
            caseIds.add(RPRec.case__c);
        }
        
        for(case c : [select id, ownerid from case where id IN :caseIds and RecordTypeId IN (:fastRecordTypeId,:pipRecordTypeId)]){
            caseOwnerIdMap.put(c.id, c.OwnerId);
        }
         Map<id,set<id>> caseTeamMemberMap = ACET_FAST_Utility.getCaseTeamMemberMap(caseIds);
        for(PIR_Resolution_Partner__c RPRec : pirList){
                 if(caseOwnerIdMap.containsKey(RPRec.Case__c) && !(logInUser.isValidUser || logInUser.loggedInUserId == caseOwnerIdMap.get(RPRec.Case__c)||(caseTeamMemberMap.containsKey(RPRec.Case__c) && caseTeamMemberMap.get(RPRec.Case__c).contains(logInUser.loggedInUserId))) ){
                    RPRec.addError(ACET_FAST_Constants.notaValiFastRoleError);
            }    
        }
    }
}