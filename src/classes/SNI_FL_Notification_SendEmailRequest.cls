/********************************************************************************* 
Class Name     : SNI_FL_Notification_SendEmailRequest.cls
Description    : 
Created By     : Bastine Sebastyan
Created Date   : 

Modification Log
---------------------------------------------------------------------------------- 
Developer                   Date                   Description

1.Bastine Sebastyan			9/28/2020				Wrapper class for Email notification Request
----------------------------------------------------------------------------------            

*********************************************************************************/

public class SNI_FL_Notification_SendEmailRequest {

	public String optInStatus;
	public String emailSubject;
	public List<EmailTemplateInfos> emailTemplateInfos;
	public String memberEmail;
	public String emailTemplateId;
	public String triggerType;
    public string applicationName;
    public string emailFromAddress;
    
    public SNI_FL_Notification_SendEmailRequest()
    {
        emailTemplateInfos = new List<EmailTemplateInfos>();
        applicationName = 'FamilyLink';
    }
    
    public void AddEmailTemplateInfos(string name, string value)
    {
        EmailTemplateInfos info = new EmailTemplateInfos();
        info.name = name;
        info.value = value;
        this.emailTemplateInfos.add(info);
    }

	public class EmailTemplateInfos {
		public String name;
		public String value;
	}

}