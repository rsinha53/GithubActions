public without sharing class SNI_FL_LoginPopUpController {
    
   
    
    @AuraEnabled
    public static user getLoginUserName(){
        string uName;
        list<user> usrList = [SELECT id,FirstName,LastName,FullPhotoUrl,Name,Profile.Name from User WHERE Id =: UserInfo.getUserId() limit 1];
        if(usrList != null && !usrList.isEmpty()){
            //US3050350
            return usrList[0];
        }
        //US3050350
        return null;
    }
    
    @auraEnabled
    public static String isMemLoginFirstTime(){
        //US3219334 - update to logic to accomodate the fact digital onboarding sets the SNI_FL_Terms_of_use__pc to true before they login for the first time
        User u = [select id, contact.accountid,Digital_Onboarding__c, createddate from User where id = : UserInfo.getUserId()];
        Date userCreatedDate = Date.newInstance(u.CreatedDate.year(), u.CreatedDate.month(), u.CreatedDate.day());
        Date todayDate = Date.today();
        if(u != null){
            id getPersonAccountId = u.contact.accountId;
            list<account> lstCon = [select id,FamilyLink_Registration_Date__c,SNI_FL_Terms_of_use__pc, CreatedDate,	Advisor_Detail_Popped_up__c from account where id =: getPersonAccountId ];
            if(!lstCon.isEmpty()){
                if (!lstCon[0].SNI_FL_Terms_of_use__pc){
                return 'true';                   
                }
                if(u.Digital_Onboarding__c == true && lstCon[0].Advisor_Detail_Popped_up__c == false){
                    lstCon[0].Advisor_Detail_Popped_up__c = true;
                    update lstCon[0];
                    return 'trueDigitalOnboarding';
                }
            }
        }
        return 'false';
    }
    @auraEnabled
    Public Static void saveUserDetails(string phn){
        try{
            list<user> lstUser = [select id,MobilePhone from user where id =: UserInfo.getUserId()];
            if(lstUser !=null && lstUser.size() >0){
                lstUser[0].MobilePhone=phn;
            }
            update lstUser;
        }catch (Exception ex) {
            AcetUtility.CreateAndRedirectToError('FamilyLink','SNI_FL_LoginPopUpController',ex);
        }
    }
    @auraEnabled
    Public Static void savePAccountDetails(boolean emailcheck, boolean phcheck, string phn){
        if(phn != null || phn != ''){
        saveUserDetails(phn);
        }
        User usr = [select id, contact.accountid from User where id = : UserInfo.getUserId()];

        if(usr != null){
            id getPersonAccountId = usr.contact.accountId;
                                 
            list<account> lstCon = [select id,FamilyLink_Registration_Date__c,SNI_FL_Terms_of_use__pc,Preferred_Method__pc,PersonMobilePhone,Email_Notification__c,Text_Message_SMS_Notification__c from account where id =: getPersonAccountId ];
            if(lstCon != null && ! lstCon.isEmpty() && ! lstCon[0].SNI_FL_Terms_of_use__pc ){
                lstCon[0].FamilyLink_Registration_Date__c = system.today();
                lstCon[0].SNI_FL_Terms_of_use__pc = true;
                lstCon[0].Email_Notification__c = emailcheck;
                lstCon[0].Text_Message_SMS_Notification__c = phcheck;
                update lstCon;
                
                if(emailcheck){
                    set<Id>  listOfUserIds = new set<Id>();
                    List<User> userList = new List<User>();
                    for (User ur : [SELECT Id, AccountId, MobilePhone FROM User WHERE AccountId =: lstCon[0].id]) {
                        if(string.isNotBlank(ur.MobilePhone)){
                            listOfUserIds.add(ur.Id);
                        }
                    }
                    system.debug('listOfUserIds---'+listOfUserIds);
                    if (!listOfUserIds.isEmpty()) {
                        SNI_FL_WelcomeMsg_Notification.sendSMSNotifications(listOfUserIds); 
                    } 
                }
                
                
            }
        }        
    }
    
        
    }