/********************************************************************************* 
Class Name     : SNI_FL_Notification_Center.cls
Description    : 
Created By     : Bastine Sebastyan
Created Date   : 

Modification Log
---------------------------------------------------------------------------------- 
Developer                   Date                   Description

1.Bastine Sebastyan      9/28/2020        Created class with Send email and Send SMS API Call outs
----------------------------------------------------------------------------------            

*********************************************************************************/
public class SNI_FL_Notification_Center 
{
    public static final string NOTIFICATION_TYPE_EMAIL = 'Email';
    public static final string NOTIFICATION_TYPE_SMS = 'SMS';
    public SNI_FL_Notification_Center_API_Settings__mdt settings;
    public list<Application_Error_Log__c> appLogList= new list<Application_Error_Log__c>();
    public String OrgName { get ;set; }
    
    @Future(callout=true)
    public static void SendNotificationList(List<Id> Entityid)
    {   for(Id userid: Entityid){
        SNI_FL_Notification_Center center = new SNI_FL_Notification_Center();  
        SNI_FL_Notification_Result result = center.SendNotificationMethod(userid);
    }
    }
    @Future(callout=true)
    public static void SendNotification(Id Entityid)
    {
        system.debug('in #31 case entered' + Entityid);
        SNI_FL_Notification_Center center = new SNI_FL_Notification_Center();
        SNI_FL_Notification_Result result = center.SendNotificationMethod(Entityid);
    }
    public static void SendNotificationNonFuture(Id Entityid)
    {
        SNI_FL_Notification_Center center = new SNI_FL_Notification_Center();
        SNI_FL_Notification_Result result = center.SendNotificationMethod(Entityid);
    }
    public SNI_FL_Notification_Result SendNotificationMethod(Id Entityid)
    {
        system.debug('in 42# cae entered');
        if(Test.isRunningTest() && ISL_Webservice_Config__c.getInstance('dev_SNI_FL_Notification_EmailEndPoint') == null)
        {
            return null;
        }
        SetMetaData();
        List<string> SMSText = new List<String>();
        SMSText.add(settings.SMS_Notification_Text__c);
        string EmailSubject = settings.Email_Notification_Subject__c; 
        string EmailBody = settings.Email_Notification_Email__c;
        return SendNotificationMethod(Entityid, SMSText,  EmailSubject, EmailBody);
    }
    public SNI_FL_Notification_Result SendNotificationMethod(Id Entityid, List<string> SMSText, string EmailSubject, string EmailBody)
    {
        
        SetMetaData();
        system.debug(' #58 entity id case entered'+ Entityid);
        String sObjName = entityid.getSObjectType().getDescribe().getName();
        system.debug('#60 sObjName is '+sObjName);
        boolean emailNotification = false, smsNotification = false;
        string phoneNumber, email,  memberName, accountId;
        Datetime accountTimeStamp;
        if(sObjName == 'User')
        {
            system.debug('in #66 case');
            User userRec = [select id,MobilePhone,Email,Contact.Account.Id,Contact.Account.Email_Notification__c,Contact.Account.Text_Message_SMS_Notification__c,
                            Contact.Account.Last_Notification_Timestamp__c,FirstName,LastName,Profile.Name
                            from User where Id =: entityid];
            if (userRec != null && userRec.Contact != null && userRec.Contact.Account != null)
            {
                emailNotification = userRec.Contact.Account.Email_Notification__c;
                smsNotification = userRec.Contact.Account.Text_Message_SMS_Notification__c;
                accountTimeStamp = userRec.Contact.Account.Last_Notification_Timestamp__c;
                accountId = userRec.Contact.Account.Id;
                phoneNumber = userRec.MobilePhone;
                email = userRec.Email;   
                memberName = userRec.FirstName;
                //US2987120 start
                if(userRec.Profile.Name == 'Care Advisor Connect Provider User'){
                    EmailBody = label.SNI_FL_ProviderEmailBody;
                }
                //US2987120 end
            }
            else
            {
                throw new NotificationCenterException(Label.SNI_FL_Invalid_Entity+': '+Entityid);
            }
            
        }
        else if(sObjName == 'Contact')
        {
            system.debug('in #93 case');
            Contact contact = [select id,Account.Email_Notification__c,Account.Text_Message_SMS_Notification__c,
                               Account.Id, Account.Last_Notification_Timestamp__c, FirstName,LastName
                               from Contact where Id =: entityid];
            
            if (contact != null && contact.Account != null)
            {
                emailNotification = contact.Account.Email_Notification__c;
                smsNotification = contact.Account.Text_Message_SMS_Notification__c;
                accountTimeStamp =contact.Account.Last_Notification_Timestamp__c;
                accountId = contact.Account.Id;
                User userRec = [select Email,MobilePhone,FirstName,LastName,Profile.Name from User where User.ContactId =: contact.Id];
                
                if(userRec != null)
                {
                    phoneNumber = userRec.MobilePhone;
                    email = userRec.Email;
                    memberName = userRec.FirstName;
                    //US2987120 start
                    if(userRec.Profile.Name == 'Care Advisor Connect Provider User'){
                        EmailBody = label.SNI_FL_ProviderEmailBody;
                    }
                    //US2987120 end
                }
                else
                {
                    throw new NotificationCenterException(Label.SNI_FL_Invalid_Entity+': '+Entityid);
                }
            }
            else
            {
                throw new NotificationCenterException(Label.SNI_FL_Invalid_Entity+': '+Entityid);
            }
        }
        else if(sObjName == 'Account')
        {
            system.debug('inside account if case');
            Account account = [select id,Email_Notification__c,Text_Message_SMS_Notification__c, Last_Notification_Timestamp__c  
                               from Account where Id =: entityid];
            system.debug('account record is ***' + account);
            if(account != null)
            {
                emailNotification = account.Email_Notification__c;
                smsNotification = account.Text_Message_SMS_Notification__c;
                accountTimeStamp = account.Last_Notification_Timestamp__c;
                accountId = account.Id;
                System.debug('#134'+account.Last_Notification_Timestamp__c);
                List<User> userRec = [select Email,MobilePhone,FirstName,LastName,Profile.Name from User where User.Contact.AccountId =: account.Id];
                if(userRec != null && userRec.size()>0)
                {
                    phoneNumber = userRec[0].MobilePhone;
                    memberName = userRec[0].FirstName;
                    email = userRec[0].Email; 
                    //US2987120 start
                    if(userRec[0].Profile.Name == 'Care Advisor Connect Provider User'){
                        EmailBody = label.SNI_FL_ProviderEmailBody;
                    }
                    //US2987120 end
                }
                else
                {
                    throw new NotificationCenterException(Label.SNI_FL_Invalid_Entity+': '+Entityid);
                }
            }
            else
            {
                throw new NotificationCenterException(Label.SNI_FL_Invalid_Entity+': '+Entityid);
            }
            
            
        }
        else
        {
            throw new NotificationCenterException(Label.SNI_FL_Invalid_Entity+': '+Entityid);
        }
        system.debug('#166');
        SNI_FL_Notification_Result resp = new SNI_FL_Notification_Result();
        //If the current accountTimeStamp is > 30 minutes then send email/sms notification(s)
        DateTime halfHourBack = DateTime.now().addMinutes(-30); 
        system.debug('case entered - halfhourback');
        system.debug('in 172 '+halfHourBack);
        system.debug('in #173 '+accountTimeStamp);
        system.debug('in #174 '+(accountTimeStamp < halfHourBack));
        if (accountTimeStamp == null || accountTimeStamp < halfHourBack) { 
            system.debug('caseinside account timestamp if');
            System.debug('#137'+accountTimeStamp);
            system.debug('accountTimeStamp '+accountTimeStamp);
            if(!(smsNotification == true || emailNotification == true))
            {
                System.debug('175 #not opted');
                resp.SMSSent = false;
                resp.EmailSent = false;
                resp.EmailStatusText = Label.SNI_FL_Not_Opted_Email;
                resp.SMSStatusText = Label.SNI_FL_Not_Opted_SMS;
            }
            else
            {
                if(smsNotification)
                {
                    system.debug('in 188');
                    if(phoneNumber == null)
                    {
                        resp.SMSSent = false;
                        resp.SMSStatusText = Label.SNI_FL_Mobile_Not_Found;
                    }
                    else
                    {
                        phoneNumber = phoneNumber.replace(' ','').replace('-','').replace('(','').replace(')','');
                        SNI_FL_Notification_SendResponse responseSMS = SendSMSNotification(phoneNumber, SMSText,memberName); 
                        resp.SMSSent = (responseSMS.notificationStatus == 'Sent');
                        resp.SMSStatusText = responseSMS.responseStatusMessage; 
                        
                    }
                }
                else
                {
                    resp.SMSSent = false;
                    resp.SMSStatusText = Label.SNI_FL_Not_Opted_SMS;
                }
                if(emailNotification) // email notification is true and user email is not null
                {
                    system.debug('210 emailNotification case'+emailNotification);
                    if(email == null)
                    {
                        resp.EmailSent = false;
                        resp.EmailStatusText = Label.SNI_FL_Email_Not_Found;
                    }
                    else
                    {
                        system.debug('#211 case ');
                        resp.EmailSent = true;
                        sendEmailNotifications(accountId);
                        // SNI_FL_Notification_SendResponse responseEmail =  SendEmailNotification(email,memberName, EmailSubject,  EmailBody);
                        // resp.EmailSent = (responseEmail.notificationStatus == 'Sent');
                        //  resp.EmailStatusText = responseEmail.responseStatusMessage;
                    }
                }
                else
                {
                    resp.EmailSent = false;
                    resp.EmailStatusText = Label.SNI_FL_Not_Opted_Email;
                }
            }
            
            if (resp.EmailSent == true || resp.SMSSent == true) { 
                system.debug('in 234 #');
                Account acc = new Account();
                acc.Id = accountId;
                acc.Last_Notification_Timestamp__c = DateTime.now();
                update acc;
            } 
        }
        else
        {
            resp.SMSSent = false;
            resp.EmailSent = false;
            resp.EmailStatusText = Label.SNI_FL_Notification_Time_Interval_Message;
            resp.SMSStatusText = Label.SNI_FL_Notification_Time_Interval_Message;
        }
        
        return resp;
    }
    
    public void sendEmailNotifications(id accId){
        try{
        system.debug('in #252 mail trigger case ');
        user ur = [select id, accountid,profile.name,contactid,email from user where ISactive = true and accountid=: accId];
        
        List<Messaging.SingleEmailMessage> emails = new List<Messaging.SingleEmailMessage>();
        EmailTemplate emailTemplate = [Select Id,Subject,Description,HtmlValue,DeveloperName,Body from EmailTemplate where name = 'Email to member when advisor sends a message'];
        Messaging.SingleEmailMessage newEmail = new Messaging.SingleEmailMessage();
        newEmail.setTargetObjectId(ur.contactid); 
        newEmail.setUseSignature(false); 
        newEmail.setBccSender(false); 
        newEmail.setSaveAsActivity(false); 
        newEmail.setTemplateID(emailTemplate.Id); 
        newEmail.setWhatId(ur.accountId); 
        newEmail.toAddresses = new String[] { ur.email};
		OrgWideEmailAddress[] owd = [SELECT ID from OrgWideEmailAddress where Address = 'careadvisorconnect@optum.com']; 		
		if (owd.size() > 0 ) {
			newEmail.setOrgWideEmailAddressId(owd.get(0).Id);
		}
        emails.add(newEmail); 
        
        Messaging.SendEmailResult[] results = Messaging.sendEmail(emails);
        system.debug('in 267 results is '+results);
        } catch(exception ex){
            String errorline =(ex.getLineNumber()).format();
            String errormessage =ex.getMessage();
            String errortype =ex.getTypeName();
            String errorcause=string.valueof(ex.getCause());
            createAppExceptionLog('SMSManager','SNI_FL_Notification_Center',errorcause,'',errorline,errormessage,errortype);
        }
        
    }
    
    public SNI_FL_Notification_SendResponse SendEmailNotification(string memberemail, string memberName  , string subject, string emailBody)
    {
        emailBody = emailBody.replace('{FirstName}',memberName);
        
        
        SNI_FL_Notification_SendEmailRequest emailnotificationRequest = new SNI_FL_Notification_SendEmailRequest();
        
        emailnotificationRequest.optInStatus = 'OPT_IN';
        emailnotificationRequest.emailSubject = subject;
        emailnotificationRequest.memberEmail = memberemail;
        emailnotificationRequest.triggerType = 'immediate';
        emailnotificationRequest.emailTemplateId = settings.Email_TemplateID__c;
        //familylink@uhc.com
        emailnotificationRequest.emailFromAddress = settings.Email_From_Address__c;
        emailnotificationRequest.AddEmailTemplateInfos(settings.Email_Template_Attribute_Name__c, emailBody);   //Email body will go here  
        
        SNI_FL_Notification_SendResponse resp =  SendNotification(emailnotificationRequest, ISL_Webservice_Config__c.getInstance(OrgName + '_SNI_FL_Notification_EmailEndPoint').value__c);
        return resp;
    }
    
    public SNI_FL_Notification_SendResponse SendSMSNotification(string memberPhone, List<string> sMessages, string memberName)
    {
        /*List<string> localMessagees = new list<string>();
for(string m : messages)
{
localMessagees.add(m.replace('{FirstName}',memberName));

}

SNI_FL_Notification_SendSMSRequest smsnotificationRequest = new SNI_FL_Notification_SendSMSRequest();
smsnotificationRequest.programId = integer.valueof( ISL_Webservice_Config__c.getInstance(OrgName + '_SNI_FL_Notification_ProgramID').value__c); //
smsnotificationRequest.groupId = integer.valueof(settings.SMS_GroupId__c);
smsnotificationRequest.stateCode = integer.valueof(settings.SMS_Status_Code__c);
smsnotificationRequest.memberPhone = memberPhone;
smsnotificationRequest.optInStatus = 'OPT_IN';
smsnotificationRequest.triggerType = 'immediate';
smsnotificationRequest.messages = localMessagees;
smsnotificationRequest.notificationSendStatus = 'ready';        
smsnotificationRequest.optOutComments = false;  
smsnotificationRequest.smsManagerDetails.clientId = settings.SMS_Client_ID__c; 
SNI_FL_Notification_SendResponse resp =  SendNotification(smsnotificationRequest,  ISL_Webservice_Config__c.getInstance(OrgName + '_SNI_FL_Notification_SMSEndPoint').value__c);
return resp;*/
        //String sReturnVal=SNI_FL_NotificationCenter1.sendSMS(memberPhone,smsBody);
        //String sReturnVal=SNI_FL_NotificationCenter1.sendSMS(memberPhone);
        String welcomeMsg;
        System.debug('****sMessages---'+sMessages);
        
        String prodAcc = System.Label.Access_SMS_PROD_ProgramID;
        String sprogramId = '';
        if(prodAcc != null && prodAcc == 'YES'){
            sprogramId = System.Label.PROD_SMS_ProgramID;
        }else if(prodAcc == 'NO'){
            sprogramId = System.Label.NONPROD_SMS_ProgramID;
        }  
        welcomeMsg = sMessages[0].replace('{programid}',sprogramId); 
        String sReturnVal=SNI_FL_NotificationCenter2.sendSMS(memberPhone,welcomeMsg);
        SNI_FL_Notification_SendResponse resp =new  SNI_FL_Notification_SendResponse();
        if(sReturnVal != null && sReturnVal.equalsIgnoreCase('Success'))
            resp.notificationStatus='sent';
        else resp.notificationStatus='failed to sent';
        return resp;
    } 
    
    private SNI_FL_Notification_SendResponse SendNotification(SNI_FL_Notification_SendSMSRequest smsDetails, string url)
    {
        string requestBody = JSON.serialize(smsDetails); 
        return CallNotificationAPI(NOTIFICATION_TYPE_SMS, requestBody, url);
    }
    
    private SNI_FL_Notification_SendResponse SendNotification(SNI_FL_Notification_SendEmailRequest emailDetails, string url)
    {
        string requestBody = JSON.serialize(emailDetails); 
        return CallNotificationAPI(NOTIFICATION_TYPE_EMAIL, requestBody, url);
    } 
    
    
    private SNI_FL_Notification_SendResponse CallNotificationAPI(string notificationtype, string body, string url)
    {
        ACET_WebserviceCalloutFramework wsCallOutFW = new ACET_WebserviceCalloutFramework();
        if(notificationtype == 'SMS'){
            wsCallOutFW.serviceName = 'NOTIFICATION_TYPE_SMS';
        }else if(notificationtype == 'EMAIL'){
            wsCallOutFW.serviceName = 'NOTIFICATION_TYPE_EMAIL'; 
        }
        wsCallOutFW.requestBody = body;
        wsCallOutFW.requestParamsMap = null;
        HttpResponse response = wsCallOutFW.getResponse();
        
        String reponse;
        if (response.getStatusCode() != 200) {
            
            SNI_FL_Notification_SendResponse responseAPI = new SNI_FL_Notification_SendResponse();
            responseAPI.responseStatusMessage = Label.SNI_FL_Callout_Fail;
            responseAPI.notificationStatus = 'Error';
            
            return responseAPI;
            
        } 
        else {
            
            reponse = response.getBody();
            SNI_FL_Notification_SendResponse responseObject = SNI_FL_Notification_SendResponse.parse(reponse);
            return responseObject;
        }
    } 
    
    private void SetMetaData()
    {
        if(settings == null)
        {
            system.debug('in #360');
            Map<String, ACETOrgInstanceURLToOrgNameMap__c> OrgInstance2OrgNameMap = ACETOrgInstanceURLToOrgNameMap__c.getAll();
            OrgName = Test.isRunningTest() ? 'dev' : ACETUtility.GetOrgName(OrgInstance2OrgNameMap);
            string label = 'notification_center';
            settings = [select Email_TemplateID__c,Email_Template_Attribute_Name__c,Email_Notification_Email__c,
                        Email_Notification_Subject__c,SMS_Notification_Text__c,SMS_GroupId__c,
                        SMS_Status_Code__c,SMS_Client_ID__c,Email_From_Address__c
                        from SNI_FL_Notification_Center_API_Settings__mdt WHERE MasterLabel =: label LIMIT 1];
        }
    }
    
    public class NotificationCenterException extends Exception {}
    
    public void sendSMSNotification(String phoneNumber, String memberName){
        try{
            String memberPhone = phoneNumber.replace(' ','').replace('-','').replace('(','').replace(')','');
            /*Map<String, ACETOrgInstanceURLToOrgNameMap__c> OrgInstance2OrgNameMap = ACETOrgInstanceURLToOrgNameMap__c.getAll();
String OrgName = Test.isRunningTest() ? 'dev' : ACETUtility.GetOrgName(OrgInstance2OrgNameMap);*/
            string label = 'sms_notification';
            SNI_FL_Notification_Center_API_Settings__mdt settings = [select Email_TemplateID__c,Email_Template_Attribute_Name__c,Email_Notification_Email__c,
                                                                     Email_Notification_Subject__c,SMS_Notification_Text__c,SMS_GroupId__c,
                                                                     SMS_Status_Code__c,SMS_Client_ID__c,Email_From_Address__c
                                                                     from SNI_FL_Notification_Center_API_Settings__mdt WHERE MasterLabel =: label LIMIT 1];
            
            String welcomeMsg = settings.SMS_Notification_Text__c;
            String prodAcc = System.Label.Access_SMS_PROD_ProgramID;
            String sprogramId = '';
            if(prodAcc != null && prodAcc == 'YES'){
                sprogramId = System.Label.PROD_SMS_ProgramID;
            }else if(prodAcc == 'NO'){
                sprogramId = System.Label.NONPROD_SMS_ProgramID;
            }  
            welcomeMsg = welcomeMsg.replace('{programid}',sprogramId);  
            
            /*SNI_FL_Notification_Result resp = new SNI_FL_Notification_Result();
SNI_FL_Notification_SendSMSRequest smsnotificationRequest = new SNI_FL_Notification_SendSMSRequest();
smsnotificationRequest.programId = integer.valueof( ISL_Webservice_Config__c.getInstance(OrgName + '_SNI_FL_Notification_ProgramID').value__c); 
smsnotificationRequest.groupId = integer.valueof(settings.SMS_GroupId__c);
smsnotificationRequest.stateCode = integer.valueof(settings.SMS_Status_Code__c);
smsnotificationRequest.memberPhone = memberPhone;
smsnotificationRequest.optInStatus = 'OPT_IN';
smsnotificationRequest.triggerType = 'immediate';
smsnotificationRequest.messages = new List<String> {wMsg};
smsnotificationRequest.notificationSendStatus = 'ready';        
smsnotificationRequest.optOutComments = false;  
smsnotificationRequest.smsManagerDetails.clientId = settings.SMS_Client_ID__c; */
            //system.debug('smsnotificationRequest::'+smsnotificationRequest);
            String sReturnVal=SNI_FL_NotificationCenter2.sendSMS(memberPhone,welcomeMsg);
            System.debug('***sReturnVal---'+sReturnVal);
            //SNI_FL_Notification_SendResponse respx =  SendNotification(smsnotificationRequest,  ISL_Webservice_Config__c.getInstance(OrgName + '_SNI_FL_Notification_SMSEndPoint').value__c);
        }catch (exception ex){
             String errorline =(ex.getLineNumber()).format();
            String errormessage =ex.getMessage();
            String errortype =ex.getTypeName();
             String errorcause=string.valueof(ex.getCause());
            createAppExceptionLog('SMSManager(Welcome message)','SNI_FL_Notification_Center',errorcause,'',errorline,errormessage,errortype);
        }
    }
    
    public void sendEmailorSMSNotification(String emailId,String subject,String emailCheck,String smsCheck,String phoneNumber, String replacetext, String label){
        try{
            String memberPhone = phoneNumber.replace(' ','').replace('-','').replace('(','').replace(')','');
            Map<String, ACETOrgInstanceURLToOrgNameMap__c> OrgInstance2OrgNameMap = ACETOrgInstanceURLToOrgNameMap__c.getAll();
            String OrgName = Test.isRunningTest() ? 'dev' : ACETUtility.GetOrgName(OrgInstance2OrgNameMap);
            
            SNI_FL_Notification_Center_API_Settings__mdt settings = [select Email_TemplateID__c,Email_Template_Attribute_Name__c,Email_Notification_Email__c,
                                                                     Email_Notification_Subject__c,SMS_Notification_Text__c,SMS_GroupId__c,
                                                                     SMS_Status_Code__c,SMS_Client_ID__c,Email_From_Address__c, SMS_ProgramID__c
                                                                     from SNI_FL_Notification_Center_API_Settings__mdt WHERE MasterLabel =: label LIMIT 1];
            
            if(smsCheck =='true' && phoneNumber !=''){
                String Msg = settings.SMS_Notification_Text__c;
                string bodyMsg = Msg.replace('{randomNumber}',replacetext);
                //String welcomeMsg = 'OTP : '+replacetext;
                String welcomeMsg = bodyMsg;
                String sReturnVal=SNI_FL_NotificationCenter2.sendSMS(memberPhone,welcomeMsg);
                System.debug('***sReturnVal---'+sReturnVal); 
                
                /*String Msg = settings.SMS_Notification_Text__c;
string bodyMsg = Msg.replace('{randomNumber}',replacetext);
//US3477511 - Digital Onboarding Verification Code
//Grabbing the program id from metadata or custom setting if not digital onboardning (existing logic)
Integer programID = (label == 'notification_center_verification' ? integer.valueof( ISL_Webservice_Config__c.getInstance(OrgName + '_SNI_FL_DO_Notification_ProgramID').value__c) : integer.valueof( ISL_Webservice_Config__c.getInstance(OrgName + '_SNI_FL_Notification_ProgramID').value__c));

SNI_FL_Notification_Result resp = new SNI_FL_Notification_Result();
SNI_FL_Notification_SendSMSRequest smsnotificationRequest = new SNI_FL_Notification_SendSMSRequest();
smsnotificationRequest.programId = programId;
smsnotificationRequest.groupId = integer.valueof(settings.SMS_GroupId__c);
smsnotificationRequest.stateCode = integer.valueof(settings.SMS_Status_Code__c);
smsnotificationRequest.memberPhone = memberPhone;
smsnotificationRequest.optInStatus = 'OPT_IN';
smsnotificationRequest.triggerType = 'immediate';
smsnotificationRequest.messages = new List<String> {bodyMsg};
smsnotificationRequest.notificationSendStatus = 'ready';        
smsnotificationRequest.optOutComments = false;  
smsnotificationRequest.smsManagerDetails.clientId = settings.SMS_Client_ID__c; 
SNI_FL_Notification_SendResponse respx =  SendNotification(smsnotificationRequest,  ISL_Webservice_Config__c.getInstance(OrgName + '_SNI_FL_Notification_SMSEndPoint').value__c); 
*/
            } else if(emailCheck =='true' && emailId !=''){
                //Commented by Cherry - since the API isnt working. Replacing it with Apex email.
                
                
                /*String Msg = settings.Email_Notification_Email__c;
string emailBody = Msg.replace('{randomNumber}',replacetext);

SNI_FL_Notification_SendEmailRequest emailnotificationRequest = new SNI_FL_Notification_SendEmailRequest();

emailnotificationRequest.optInStatus = 'OPT_IN';
emailnotificationRequest.emailSubject = subject;
emailnotificationRequest.memberEmail = emailId;
emailnotificationRequest.triggerType = 'immediate';
emailnotificationRequest.emailTemplateId = settings.Email_TemplateID__c;
emailnotificationRequest.emailFromAddress = settings.Email_From_Address__c;
emailnotificationRequest.AddEmailTemplateInfos(settings.Email_Template_Attribute_Name__c, emailBody);   //Email body will go here  

SNI_FL_Notification_SendResponse resp =  SendNotification(emailnotificationRequest, ISL_Webservice_Config__c.getInstance(OrgName + '_SNI_FL_Notification_EmailEndPoint').value__c);

*/  
                
                Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
                system.debug('emailId---'+emailId+'k');
                //String[] toAddresses = new String[] {emailId}; 
                String toRecipients = emailId;
                String[] toAddresses = toRecipients.split('\\;', 0);
                mail.setToAddresses(toAddresses);
                //mail.setReplyTo('familylink@uhc.com');
                //mail.setSenderDisplayName('Care Advisor Connect');
                mail.setSubject(subject);
                mail.setBccSender(false);
                mail.setUseSignature(false);
                String Msg = settings.Email_Notification_Email__c;
                string emailBody = Msg.replace('{randomNumber}',replacetext);
                mail.setPlainTextBody(emailBody);
                mail.setHtmlBody('Hello,<br><br> Your verification code is: ' + replacetext +' <br><br>Thanks, <br>Care Advisor Connect Team');
                OrgWideEmailAddress[] owea = [select Id from OrgWideEmailAddress where Address = 'careadvisorconnect@optum.com']; //careadvisorconnect@optum.com 
                
                if ( owea.size() > 0 ) {
                    mail.setOrgWideEmailAddressId(owea.get(0).Id);
                }
                system.debug('mail---'+mail);
                Messaging.sendEmail(new Messaging.SingleEmailMessage[] { mail }); 
            }
        }catch(Exception ex) {
            String errorline =(ex.getLineNumber()).format();
            String errormessage =ex.getMessage();
            String errortype =ex.getTypeName();
            String errorcause=string.valueof(ex.getCause());
            createAppExceptionLog('SMSManager(Email)','SNI_FL_Notification_Center',errorcause,'',errorline,errormessage,errortype);
        }
        
    }
    
     @future     
    public static void createAppExceptionLog(string appName, string servName, String errorcause, String StatusMessage,String errorline, String errormessage, String errortype){
        
        Application_Error_Log__c appErrorLog = ACETUtility.CreateApplicationExcepLog(appName,servName,errorcause,StatusMessage,errorline,errormessage,errortype) ;
       // appLogList.add(appErrorLog);
        Insert appErrorLog;
    }
  /*  @future     
    public static void createAppLog(string endpoint,  String request, String response, String errormessage, String statuscode,String methodName){
        list<Application_Log__c>apploglist=new list<Application_Log__c>();
      Application_Log__c applog=new Application_Log__c();
        applog.Endpoint__c=endpoint;
        applog.Request__c=request;
        applog.Response__c=response;
        applog.Error_message__c=errormessage;
        applog.Status_Code__c=statuscode;
        applog.Method__c=methodName;
        apploglist.add(applog);
        insert apploglist;
    }*/

    
    
    
}