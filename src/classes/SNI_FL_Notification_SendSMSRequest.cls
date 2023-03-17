/********************************************************************************* 
Class Name     : SNI_FL_Notification_SendSMSRequest.cls
Description    : 
Created By     : Bastine Sebastyan
Created Date   : 

Modification Log
---------------------------------------------------------------------------------- 
Developer                   Date                   Description

1.Bastine Sebastyan			9/28/2020				Wrapper class for SMS notification Request
----------------------------------------------------------------------------------            

*********************************************************************************/
public class SNI_FL_Notification_SendSMSRequest {
    public SmsManagerDetails smsManagerDetails;
    public Integer programId;
    public Integer groupId;
    public Integer stateCode;
    public string memberPhone;
    public String optInStatus;
    public String triggerType;
    public List<String> messages;
    public String notificationSendStatus;
    public Boolean optOutComments;
    public string applicationName;
    
    public SNI_FL_Notification_SendSMSRequest()
    {
        smsManagerDetails = new smsManagerDetails();
        applicationName = 'FamilyLink';
    }
    
    public class SmsManagerDetails {
        public String clientId;
    }
    
    
}