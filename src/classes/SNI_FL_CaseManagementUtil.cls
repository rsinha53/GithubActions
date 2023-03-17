/****************************************************************************** 
Class Name     : SNI_FL_CaseManagementController.apxc
Description    : 
Created By     : Sameera De Silva - ACDC
Created Date   : 11/5/2020
******************************************************************************/

//Rout case related functionalities coming from UI to SNI_FL_CaseManagementController
//Author:Sameera ACDC
public with sharing class SNI_FL_CaseManagementUtil {

    @AuraEnabled(cacheable=true)
    public static List<SNI_FL_CaseManagementController.CaseObjectWrapper> getListOfCases(String familyLinkUserID,String familyAccountID){
        
        System.debug('*****Family info---'+familyLinkUserID +'-----'+familyAccountID);
        return SNI_FL_CaseManagementController.getCasesWithROISignedCases(familyLinkUserID,familyAccountID);
    }

}