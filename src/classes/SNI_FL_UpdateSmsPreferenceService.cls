/*
**********************************************************************************
Class Name:  SNI_FL_UpdateSmsPreferenceService
Description :
Author: Balakrishnan,
Created Date : 02-17-2021
Modification History :
**********************************************************************************
*/
@RestResource(urlMapping='/SNI/PersonAccount')
global class SNI_FL_UpdateSmsPreferenceService {
@HTTPPost
    global static String updatePersonAccount() {
        
      RestRequest req = RestContext.request;
      RestResponse res = Restcontext.response;
      string jsonString=req.requestBody.tostring();
      
      try{
            responseWrapper wResp=(responseWrapper) JSON.deserialize(jsonString,responseWrapper.class); 
            String MobilePhone = '(' + wResp.phone_number.substring(2, 5) + ') ' + wResp.phone_number.substring(5, 8) + '-' + wResp.phone_number.substring(8,12);
            List<Account> accupdList = new List<Account>();
            List<user> usrrec = [select id,MobilePhone,Email,Contact.Account.Id,Contact.Account.Email_Notification__c,Contact.Account.Text_Message_SMS_Notification__c,
                            Contact.Account.Last_Notification_Timestamp__c,FirstName,LastName,Profile.Name
                            from User where Contact.Account.Text_Message_SMS_Notification__c= true and MobilePhone =: MobilePhone];
            for(user acc: usrrec){
            Account accupd = new Account();
            accupd.id = acc.Contact.Account.Id;
            accupd.Text_Message_SMS_Notification__c = false;
            accupdList.add(accupd);    
            }
            if(!accupdList.isEmpty()){
 		    update accupdList;
            return 'Successfully unchecked the Notification checkbox';
            }
            return 'Not unchecked the Notification checkbox';
         }
        Catch(Exception ex){
            system.debug('Error:'+ex);
            return 'Error: '+ex;
        }
      

    }
    
    
     global class responseWrapper{
       
       global string content;
       global string program_id;
       global string phone_number;
       global string message_id;
      
      }
    
}