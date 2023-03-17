/**
* Author: Team Eagles
* Description: An apex page controller that exposes the change password functionality
* Date Modified: 08/12/2020
*/
public class SNI_FL_ChangePasswordController {
    
    public String newPassword {get; set;}
    public String verifyNewPassword {get; set;} 
    public Boolean errorMessage {get;set;}
    public Boolean errorMessage1 {get;set;}
    public String msg {get;set;}
    public Boolean displayMemberIdBlock{get;set;}
    public String msg1 {get;set;}
    public String memberID{get;set;}
    static Pattern textPattern = Pattern.compile('^(?=.*\\W)(?=.*[a-zA-Z])(?=.*\\d)(?=.*\\d).+$');              
    Static  Matcher matcher_newPassword= null;
    Static  Matcher matcher_verifyNewPassword= null;
    public String pageTitle {get;set;}
    public boolean checkID=false;
    public boolean checkIDMember=false;
    public boolean errorOccured {get;set;}
        
    
    
    public PageReference doAction() {
        errorOccured = false;
        if (displayMemberIdBlock == false || (displayMemberIdBlock == true && memberID != null)) {
            try{
                msg1='';
                
                User u = [select Id , AccountId, profile.name from User where Id = :UserInfo.getUserId()];
                
                //if(u.profile.name == System.Label.TEXT_CareAdvisorConnectProviderUser || (u.profile.name == System.Label.TEXT_CareAdvisorConnect && memberID != null)){
                
                Account acc = [Select ID, PersonContactID    from Account where ID= :u.AccountId];
                
                List<AccountContactRelation> lsacr = [ SELECT Member_ID__c, account.alternate_id__c  FROM AccountContactRelation WHERE  ContactID  = :acc.PersonContactID];
                
                Set<String> memIDs = new Set<String>();
                
                if (!lsacr.isEmpty() && lsacr.size() > 0) {
                    for(AccountContactRelation acr : lsacr) {
                        if (acr.Member_ID__c != null) {
                            // add member id into set
                            memIDs.add(removePrecedingZeros(acr.Member_ID__c));
                        }                  
                        if (acr.Account.Alternate_id__c != null) {
                            // add alternative id into set
                            memIDs.add(removePrecedingZeros(acr.Account.Alternate_id__c));
                        }
                    }
                }
                Boolean flag = false;
                if (!memIDs.isEmpty()) {
                    for (String omemberid : memIDs) {                    
                        if(omemberid == removePrecedingZeros(memberID)){
                            flag = true;
                            break;
                        }
                    }
                    
                    if(flag == false){
                        errorMessage1 = true; 
                        msg1='The Member ID that was entered is incorrect, please enter a valid Member ID. If you are having trouble, please contact your Care Advisor by calling the number on the back of your insurance card.';
                    }
                    else{
                        checkID=true;
                    }
                    
                }
                /*
* Author: Aarti Garg
* US: US2689183
* Description: Following code perform logical operations to check if entered password and confirm password values follow the given rules or not
* Date: 08/07/2020
*/
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
                    //ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,'Please confirm the passwords match and try again.'));  
                }
                else if ((matcher_newPassword.find()==false) || newPassword.length()<8 )  //|| ((matcher_verifyNewPassword.find()==false) && verifyNewPassword.length()<8 ) )               
                {
                    errorMessage = true;  
                    msg='Passwords must be at least eight characters with a minimum of one number, one letter, and one special character.';
                    
                }
                else
                {
                    errorMessage = false;
                    
                    if(checkID || !checkIDMember )
                    {
                        return Site.changePassword(newPassword, verifyNewPassword , null); 
                    }
                }
                
                
                
            } catch(Exception ex){
                AcetUtility.CreateAndRedirectToError('FamilyLink','SNI_FL_ChangePasswordController',ex);
                errorOccured = true;
            }
            
        }
        else{
            errorMessage1 = true; 
            msg1='The Member ID that was entered is incorrect, please enter a valid Member ID. If you are having trouble, please contact your Care Advisor by calling the number on the back of your insurance card.';
        }
        
        return null;
                      
    }  
    
    public SNI_FL_ChangePasswordController() {
        displayMemberIdBlock= false;
        checkIDMember= false;           
        errorMessage = false;
        errorMessage1 = false;
        errorOccured = false;
        User u = [select Id, accountId from User where Id = :UserInfo.getUserId()];
        Account person = [select Id, PersonContactID,recordtypeid,FamilyLink_Registration_Date__c from Account where Id = :u.accountId];
        //Account person = [select Id, PersonContactID,recordtypeid,FamilyLink_Registration_Date__c from Account where Id =:  '0017600000E9wrXAAR'];
        List<AccountContactRelation> lsacr = [ SELECT Member_ID__c  FROM AccountContactRelation WHERE  ContactID  = :person.PersonContactID];
        RecordType recPerUs = [select Id, Name from RecordType where sObjectType='Account' and id =: person.recordtypeid Limit 1];
        // System.debug('person>> Member>>RecordName' + recPerUs.Name);
        Id providerUserRecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Provider User').getRecordTypeId();
        if ( !lsacr.isEmpty() && lsacr.size() > 0 && providerUserRecordTypeId != recPerUs.Id) {
            displayMemberIdBlock=true;
            checkIDMember=true;
        }
        if (person.FamilyLink_Registration_Date__c != null && String.valueOf(person.FamilyLink_Registration_Date__c) != '') {
            pageTitle = 'Change Your Password';
        }
        else { 
            pageTitle = 'Create Your Password';
        }
        
    }
    
    public static string removePrecedingZeros(string input){
        
        if(input!= null){
            //system.debug('****after Replacing Zeros'+memberID.replaceFirst('^0+', ''));
            //system.debug('****after Replacing Zeros'+memberID.replaceFirst('^0+(?!$)', ''));
            return input.replaceFirst('^0+', '');
        }
        return input;
        
    }
    
}