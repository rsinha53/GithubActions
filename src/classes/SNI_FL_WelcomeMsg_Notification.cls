/********************************************************************************* 
Class Name     : SNI_FL_WelcomeMsg_Notification.cls
Description    : 
Created By     : Karthik 
Created Date   : 

Modification Log
---------------------------------------------------------------------------------- 
Developer                   Date                   Description

1.Karthik K			      10/22/2020		      Created class to Send Welcome SMS API Call outs
----------------------------------------------------------------------------------            

*********************************************************************************/
public class SNI_FL_WelcomeMsg_Notification {
   
    @future (callout = true)
    public static void sendSMSNotifications(set<Id> listOfUserIds) { 
        try {
            if (!listOfUserIds.isEmpty()) { 
                for (User u : [Select Id, MobilePhone, FirstName From User where Id IN: listOfUserIds]) {
                    new SNI_FL_Notification_Center().sendSMSNotification(u.MobilePhone, u.FirstName);
                }
            }
        } catch (Exception e) {            
            System.debug(LoggingLevel.WARN, 'Something went wrong while sending SMS Notification: ' + e.getMessage());
        }
    } 
    
}