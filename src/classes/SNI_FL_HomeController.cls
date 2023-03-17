public without sharing class SNI_FL_HomeController {
    @AuraEnabled
    public static user getUserData(){
        list<user> usrList = [SELECT id,FirstName,LastName,FullPhotoUrl,Name from User WHERE Id =: UserInfo.getUserId() limit 1];
        if(usrList != null && !usrList.isEmpty()){
            return usrList[0];
        }
        return null;
    }
    @AuraEnabled
    public static Account getAdvisory(){
        List<Account> accList = [select id FROM Account];
        if(accList != null && !accList.isEmpty()){
            return accList[0];
        }
        return null;
    }
    
    //Team AC/DC Mark With New Icon when a New Message is Received
    @AuraEnabled
    public static Boolean markNewMessageIcon(String userIdValue){
        try { 
            Boolean isAvailableNewMessages;               
            List <SNI_FL_Message_Notification__c> lstUsers = [SELECT Id,Name, FeedId__c, MessageDate__c,RecipientId__c,SenderId__c FROM SNI_FL_Message_Notification__c WHERE RecipientId__c =: userIdValue AND IsViewed__c = false AND SenderId__c !=: userIdValue ]; //
            if(lstUsers != null && !lstUsers.isEmpty()){
                isAvailableNewMessages = true;
            }else{
                isAvailableNewMessages = false;
            }
            return isAvailableNewMessages;
        } catch(exception ex) {
            System.debug('ACDC Exception markNewMessageIcon '+ex.getMessage()+'Line '+ex.getLineNumber());
            return null; 
        } 
    }
    
    //Team AC/DC Delete Read Messages from SNI_FL_Message_Notification__c
    @AuraEnabled
    public static void deleteReadMessages(String userIdValue){
        try { 
            List<SNI_FL_Message_Notification__c> lstUsers = [SELECT Id,Name, FeedId__c, MessageDate__c,RecipientId__c,SenderId__c FROM SNI_FL_Message_Notification__c WHERE RecipientId__c =: userIdValue AND IsViewed__c = false]; 
            if(lstUsers != null && !lstUsers.isEmpty()){
                delete lstUsers; 
            }            
        } catch(exception ex) {
            System.debug('ACDC Exception deleteReadMessages '+ex.getMessage()+'Line '+ex.getLineNumber());
            
        } 
    }
    
    //Team AC/DC Mark With New Icon when a New Case is Created or Updated
    @AuraEnabled
    public static Boolean markNewCaseNotification(String userIdValue, String familyId){
        try { 
            Boolean isAvailableNewCase;
            String userId = userIdValue; 
            String famId = familyId; 
            String contactId = [SELECT ContactId FROM User Where Id =:userId].ContactId;
            String accountId = [SELECT AccountId FROM User Where Id =:userId].AccountId;
            List <SNI_FL_Case_Notification__c> lstDirectUser = [Select Id, Name From SNI_FL_Case_Notification__c Where Contact_Name__c =:contactId AND Is_Viewed__c = false ];             
            if(lstDirectUser != null && !lstDirectUser.isEmpty()){
                isAvailableNewCase = true;  
            }               
            else{
                String careTeamId= [SELECT Id,  SNI_FL_Family__c, SNI_FL_Member__c  FROM SNI_FL_Care_Team_Member__c Where SNI_FL_Member__c =:accountId  AND SNI_FL_Family__c =:famId].Id; 
                List <SNI_FL_Case_Notification__c> lstAuthorizedUser = [Select Id, Name From SNI_FL_Case_Notification__c Where ROI_Member_Id__c =:careTeamId AND Is_Viewed_Authorized_Member__c = false ]; 
                if(lstAuthorizedUser != null && !lstAuthorizedUser.isEmpty()){
                    isAvailableNewCase = true;
                }
                else{
                    isAvailableNewCase = false;
                }
            }
            
            return isAvailableNewCase;
            
        } catch(exception ex) {
            System.debug('ACDC Exception markNewCaseIcon '+ex.getMessage()+'Line '+ex.getLineNumber());
            return null; 
        } 
    }
    
   //Team AC/DC Delete Read Cases from SNI_FL_Case_Notification__c
    @AuraEnabled
    public static void deleteReadCases(String userIdValue, String familyId){
        try { 
            String userId = userIdValue;             
            String famId = familyId; 
            String contactId = [SELECT ContactId FROM User Where Id =:userId].contactId;
            String accountId = [Select AccountId, Name from Contact where Id =:contactId].AccountId;
           
            String careTeamId= [SELECT Id,  SNI_FL_Family__c, SNI_FL_Member__c  FROM SNI_FL_Care_Team_Member__c Where SNI_FL_Member__c =:accountId  AND SNI_FL_Family__c =:famId].Id;            
            List <SNI_FL_Case_Notification__c> lstDirectUser = [Select Id, Name,Contact_Name__c,ROI_Member_Id__c,Is_Viewed__c,Is_Viewed_Authorized_Member__c From SNI_FL_Case_Notification__c Where Contact_Name__c =:contactId OR ROI_Member_Id__c =:careTeamId  ];                        

            if(lstDirectUser != null && !lstDirectUser.isEmpty()){
                for(SNI_FL_Case_Notification__c sc:lstDirectUser){
                    if(sc.Contact_Name__c == contactId){
                        sc.Is_Viewed__c = true;
                    }else if(sc.ROI_Member_Id__c == careTeamId){                
                        sc.Is_Viewed_Authorized_Member__c = true;
                    } 
                }                  
                Upsert lstDirectUser;
                Boolean isDelete;
                if(lstDirectUser != null && !lstDirectUser.isEmpty()){
                    for(SNI_FL_Case_Notification__c sc:lstDirectUser){
                        if(sc.ROI_Member_Id__c != null || sc.ROI_Member_Id__c != '')
                        {
                            if(sc.Is_Viewed__c == true && sc.Is_Viewed_Authorized_Member__c == true){              
                                isDelete = true;
                            }
                        }
                        else{
                             isDelete = true;
                        }
                    }
                    if(isDelete == true){
                        Delete lstDirectUser; 
                    }
                }
                
            }                        
        } catch(exception ex) {
            System.debug('ACDC Exception deleteReadCases '+ex.getMessage()+'Line '+ex.getLineNumber());
            
        } 
    }
}