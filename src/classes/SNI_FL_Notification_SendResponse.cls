/********************************************************************************* 
Class Name     : SNI_FL_Notification_SendResponse.cls
Description    : 
Created By     : Bastine Sebastyan
Created Date   : 

Modification Log
---------------------------------------------------------------------------------- 
Developer                   Date                   Description

1.Bastine Sebastyan			9/28/2020				Wrapper class of notification center API reponse
----------------------------------------------------------------------------------            

*********************************************************************************/
public class SNI_FL_Notification_SendResponse {
    public String responseStatusMessage;
    public String notificationStatus;
    public Integer notificationEntityId;
    
    
    public static SNI_FL_Notification_SendResponse parse(String json) {
        return (SNI_FL_Notification_SendResponse) System.JSON.deserialize(json, SNI_FL_Notification_SendResponse.class);
    }
    
}