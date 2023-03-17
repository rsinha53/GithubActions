/****************************************************************************** 
Class Name     : SNI_FL_CaseManagementController.apxc
Description    : 
Created By     : Sameera De Silva - ACDC
Created Date   : 11/10/2020
******************************************************************************/

public without sharing class SNI_FL_CaseManagementROIController {

    //Retrives ROI records for matching careteam record based on personAccountID and familyID
    //Author:Sameera De Silva ACDC
    public static List<SNI_FL_Members_ROI__c> getActiveROIRecords(User userRecord,String familyID){
        
        try{
            return (List<SNI_FL_Members_ROI__c>)SNI_FL_CaseManagementController.enforceApexSecurity([SELECT Id,SNI_FL_Account__r.Name,SNI_FL_Account__c,SNI_FL_Account__r.PersonContactId FROM SNI_FL_Members_ROI__c WHERE SNI_FL_ROI_Signed_With__r.SNI_FL_Family__c =:familyID AND SNI_FL_ROI_Signed_With__r.SNI_FL_Member__c=:userRecord.AccountId AND SNI_FL_ROI_Signed_With__r.SNI_FL_Status__c='Registered' AND SNI_FL_Status__c ='Active' ],'READABLE');
        }catch(Exception ex){
            System.debug('ACDC Error '+ex.getMessage()+' Line Number '+ex.getLineNumber()+' MethodName:getActiveROIRecords');
            return null;
        }
               
    }
}