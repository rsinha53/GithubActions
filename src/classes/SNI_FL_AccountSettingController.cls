public without sharing  class SNI_FL_AccountSettingController {
    static Pattern textPattern = Pattern.compile('^(?=.*\\W)(?=.*[a-zA-Z])(?=.*\\d)(?=.*\\d).+$');				
    Static  Matcher matcher_newPassword= null;
    Static  Matcher matcher_verifyNewPassword= null;
    
    @auraEnabled
    Public Static Accountwrapper getUserDetail(){
        Accountwrapper wrap =new Accountwrapper();
        try{
        list<user> lstUser = [select id,FirstName, LastName,MobilePhone,Email,contact.accountid,Profile.Name from user where id =:UserInfo.getUserId()];
        if(lstUser !=null && lstUser.size()>0){
          String mobph = String.valueOf(lstUser[0].MobilePhone);
            if(String.isBlank(mobph)){
                lstUser[0].MobilePhone='';
            }
            wrap.userobj=lstUser[0];            id personAccountId = lstUser[0].contact!=null?lstUser[0].contact.accountId:'';
            if(String.isnotblank(personAccountId)){
                list<Account> lstAcc = [select id,Email_Notification__c, Text_Message_SMS_Notification__c from account where id =: personAccountId ];
                if(lstAcc !=null && lstAcc.size()>0){
                    wrap.accobj=lstAcc[0];
                }
            }
        }
        }Catch(Exception e){
            AcetUtility.CreateAndRedirectToError('FamilyLink','SNI_FL_AccountSettingController',e); 
        }
        return wrap;
    }
    
    @auraEnabled
    //Public Static void UpdateAccdetails(Account accdetails,boolean emailCheckVal, boolean phoneCheckVal, string password, string prevMobileNumber){
      Public Static void UpdateAccdetails(Account accdetails,boolean emailCheckVal, boolean phoneCheckVal, string prevMobileNumber){  
        Account acc = new Account();
        acc = accdetails;
        acc.Email_Notification__c = emailCheckVal;
        acc.Text_Message_SMS_Notification__c = phoneCheckVal;
        update acc;
        smsSubscription(acc.Id,acc.Text_Message_SMS_Notification__c);      
         try{
            if(phoneCheckVal){
                //authenticatePassword(password);
                set<Id>  listOfUserIds = new set<Id>();
               List<User> userList = [SELECT Id, AccountId, MobilePhone FROM User WHERE AccountId =:acc.id];
                for (User u : userList) {
                    if(string.isNotBlank(u.MobilePhone) && prevMobileNumber != string.valueOf(u.MobilePhone) || (prevMobileNumber == null && string.isNotBlank(u.MobilePhone))){
                        listOfUserIds.add(u.Id);
                    }
                }
                if (!listOfUserIds.isEmpty()) {
                    SNI_FL_WelcomeMsg_Notification.sendSMSNotifications(listOfUserIds); 
                }
            }
        }catch (Exception ex) {
            System.debug(ex.getMessage());
            Throw new AuraHandledException(ex.getMessage());
        }
    }
    
    @auraEnabled
    Public Static string getchangePassword(String newPassword, string verifyNewPassword, string oldPassword){
        Boolean errorMessage;
        string msg;
        matcher_newPassword= textPattern.matcher(newPassword);
        matcher_verifyNewPassword= textPattern.matcher(verifyNewPassword);     
        if((newPassword ==NULL || newPassword=='')  && (verifyNewPassword ==NULL || verifyNewPassword==''))
        {
            errorMessage = true; 
            msg='Please enter a value in the Password fields.';
            
        }
        else if(newPassword!=verifyNewPassword)
        {
            errorMessage = true;  
            msg= 'Please confirm the passwords match and try again.';           
        }
        else if ((matcher_newPassword.find()==false) || newPassword.length()<8 )  
        {
            errorMessage = true;  
            msg='Passwords must be at least eight characters with a minimum of one number, one letter, and one special character.';
            
        }
        try{
            if(errorMessage != true){
                errorMessage = false;
                PageReference pr = Site.changePassword(newPassword, verifyNewPassword, oldpassword);
                msg='SUCCESS';
            }
            
        } catch (Exception ex) {
            System.debug(ex.getMessage());
            Throw new AuraHandledException(ex.getMessage());
        }
        return msg;
    }
    
    @auraEnabled
    //Public Static Accountwrapper saveUserDetails(User userDetails, String currentPassword){
    Public Static Accountwrapper saveUserDetails(User userDetails){
        Accountwrapper wrap =new Accountwrapper();
        wrap.usermsg ='';
        wrap.authmsg = '';
        //boolean passwordVerified;
        try{
            list<user> lstUser = [select id,FirstName,LastName,MobilePhone,Email ,Username from user where id =: userDetails.Id ];
            if(lstUser !=null && lstUser.size() >0){
                if(userDetails.Email != lstUser[0].Email || userDetails.MobilePhone != lstUser[0].MobilePhone ) {
                    //authenticatePassword(currentPassword);
                    //system.debug('in verification3'+passwordVerified);
                    lstUser[0].email =userDetails.Email;
                    lstUser[0].Username = userDetails.Email;
                    lstUser[0].MobilePhone = userDetails.MobilePhone;
                    
                }
                update lstUser;
                wrap.userobj = lstUser[0];
                wrap.usermsg = 'success';
            }
        }catch (Exception ex) {
            system.debug('debugex'+ex.getMessage());
            if(ex.getMessage().contains('DUPLICATE_USERNAME')){
                wrap.usermsg = 'Duplicate UserName';
            }
            /*else if(ex.getMessage().contains('password')){
                wrap.authmsg = 'authError';
                wrap.usermsg = ex.getMessage();
            }*/
			else{
                AcetUtility.CreateAndRedirectToError('FamilyLink','SNI_FL_AccountSettingController',ex);
                wrap.usermsg = ex.getMessage();
            }
        }
        return wrap;  
    }
    /*@auraEnabled
    Public Static void authenticatePassword(String password){
        System.debug('password='+password);
        site.login(UserInfo.getUserName(), password,'');
    }*/
    public class Accountwrapper {
        @AuraEnabled public User userobj;
        @AuraEnabled public string usermsg;
        @AuraEnabled public string authmsg;
        @AuraEnabled public Account accobj;
    }
    
    public static void smsSubscription(Id accId, boolean getSmsNotifications){
        system.debug('inside smsSubscription***');
        User userRec = [SELECT Id,MobilePhone FROM User WHERE Contact.Account.Id =: accId LIMIT 1];
        if(userRec.MobilePhone != null ){
        String phoneNo = userRec.MobilePhone.replace(' ','').replace('-','').replace('(','').replace(')','');
        if(getSmsNotifications){
            SNI_FL_NotificationCenter2.subscribePhoneIDUI(phoneNo);
        }else{
            SNI_FL_NotificationCenter2.UnsubscribePhoneID(phoneNo);
        }
        }
    }
   /* new HSID URL redirection for Policy holders with Feature flag implementation (Ravikumar M) 
			Start	*/
    @AuraEnabled
    public static Boolean HSIDmemUrls() {
            User u = [select Id , AccountId, profile.name from User where Id = :UserInfo.getUserId()];             
            Account acc = [Select ID, PersonContactID    from Account where ID= :u.AccountId];            
            List<AccountContactRelation> lsacr = [ SELECT Member_ID__c, account.alternate_id__c  FROM AccountContactRelation WHERE  ContactID  = :acc.PersonContactID];			
			Boolean isMember = false;
			if (!lsacr.isEmpty() && lsacr.size() > 0) {
                for(AccountContactRelation acr : lsacr) {
                    if (acr.Member_ID__c != null) {
                        isMember = true;
                    }                
                   
                }
            }
        	system.debug(isMember);
			return isMember;
    }
    @AuraEnabled
    public static Boolean getCustMetaData(){
        FeatureFlagConfig__mdt fetConf = [select Id,MasterLabel,isEnabled__c from FeatureFlagConfig__mdt where MasterLabel = 'OpenHSIDurls'];
        return fetConf.isEnabled__c;
    }
    /* END */
}