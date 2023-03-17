/*------------------------------------------------------------
Author:        Geeta Koli
Description:   Controller class for Aura Component Send Sms Invitation  
History
Date           Author               Comments
-------------------------------------------------------------
28-11-2022     Geeta Koli   Created 
------------------------------------------------------------*/
public without sharing class SendSmsInvitationController {
    
    public static SNI_FL_Notification_Center_API_Settings__mdt settings;

    @AuraEnabled
    public static Account getAccountDetails(String accId) {
        Account acct;
        if(accId != null){
            acct = [SELECT Id,RecordType.Name,Family__c,PersonMobilePhone,Policy_Id__c,Member_ID__c FROM Account WHERE Id=:accId];
        }
        if(acct != null){
            validateClient(acct);
            validateRegisteredMember(acct);
            validatePhoneNumber(acct);
        }
        return acct;
    }
    
    public static void validateClient(Account acct){
        boolean validPolicyId = false;
        Map<String,String> mapOfValidClients = new Map<String,String>();
        List<Policies_Credential__mdt> validPolicyCreds = [Select Id, Policy_ID__c,Name__c from Policies_Credential__mdt where Name__c = 'BestBuy'];
        for(Policies_Credential__mdt policyCred : validPolicyCreds){
            mapOfValidClients.put(policyCred.Policy_ID__c, policyCred.Name__c);
        }
        
        if(acct != null){
            List<AccountContactRelation> acrList = [SELECT ID,AccountId,Policy_Id__c, contact.accountId,contactId from AccountContactRelation where contact.accountId = :acct.Id];
            if(acrList.size() == 0){
                throw new AuraHandledException(Label.Non_Approved_SMS_Clients_Error);
            }else if(acrList.size() > 0){
                for(AccountContactRelation acr : acrList){
                    if(mapOfValidClients.containsKey(acr.Policy_ID__c)){
                        validPolicyId = true;
                    }
                     }
                if(validPolicyId == false){
                    throw new AuraHandledException(Label.Non_Approved_SMS_Clients_Error);
                } 
            }
        }
    }
    
    public static void validateRegisteredMember(Account acct){
        List<SNI_FL_Care_Team_Member__c> cteamList = [SELECT ID, Name, SNI_FL_Status__c FROM SNI_FL_Care_Team_Member__c WHERE SNI_FL_Member__c =: acct.Id];
        if(cteamList.size() > 0){
            for(SNI_FL_Care_Team_Member__c cteam : cteamList){
                if(cteam.SNI_FL_Status__c == 'Registered'){
                    throw new AuraHandledException(Label.Member_Already_Registered_Error);
                }
            }
        }
    }
    
    public static void validatePhoneNumber(Account acct){
        List<User> usr = [select id,MobilePhone from User where Contact.AccountId =: acct.Id];
        if(usr.size() == 0){
            throw new AuraHandledException(Label.No_User_Exist_Error);
        }else if(usr[0].MobilePhone == null || usr[0].MobilePhone == ''){
            throw new AuraHandledException(Label.Blank_Phone_Number_Error);
        }
    }
    
    @AuraEnabled
    public static String sendSMSNotification(Id accId) {
        Account acct;
        String returnValue;
        List<User> usr;
        if(accId != null){
            acct = [SELECT Id,Name,RecordType.Name,Family__c,PersonMobilePhone,Policy_Id__c,Member_ID__c,Owner.Name FROM Account WHERE Id=:accId];
            usr = [select id,MobilePhone from User where Contact.AccountId =: accId];
        }
        
        if(acct != NULL && usr.size() > 0){
            //referred SNI_FL_Notification_Center.SetMetaData();
            string label = 'Welcome_Portal_SMS';
            settings = [select SMS_Notification_Text__c,Email_Notification_Email__c
                        from SNI_FL_Notification_Center_API_Settings__mdt WHERE MasterLabel =: label LIMIT 1];
            String SMSText = settings.Email_Notification_Email__c;
            if(acct.Name != null){
                SMSText = SMSText.replace('{Name}',acct.Name); 
            }
            if(UserInfo.getName() != null){
                SMSText = SMSText.replace('{CA}',UserInfo.getName()); 
            } 
            if((usr[0].MobilePhone != null || usr[0].MobilePhone != '') && !Test.isRunningTest()){
                usr[0].MobilePhone = (usr[0].MobilePhone).replace(' ','').replace('-','').replace('(','').replace(')','');
            }
            if(!Test.isRunningTest()){
                returnValue = SNI_FL_NotificationCenter2.sendSMS(usr[0].MobilePhone, SMSText);
            }
        }
        return returnValue;
    }
}