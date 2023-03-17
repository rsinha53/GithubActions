/********************************************************************************* 
Class Name     : SNI_FL_CaseCreateUpdateNotification.cls
Description    : This class called by SNI notification
                 process builder when case created or 
                 status filed updated with criteria
                 (ECM record type,case type='SENS case' 
                  and Family link visiable)
Created By     : Balakrishnan
Created Date   : 10/08/2020

Modification Log
---------------------------------------------------------------------------------- 
Developer                   Date                   Description
1.Balakrishnan          	110/13/2020		       Created class for SMS/Email notification feature 
													(used in SNI_Case_Notification process builder)	
----------------------------------------------------------------------------------            

*********************************************************************************/
public class SNI_FL_CaseCreateUpdateNotification {
    
    @InvocableMethod
    public static void CallNotification(List<ID> CaseIds)
    {
        //Calling Case to ROI helper to send Email/SMS notifications to case owner and member ROIs
        SNI_FL_CaseToROIHelper.handleNotificationsForCaseComment(CaseIds);
    }
}