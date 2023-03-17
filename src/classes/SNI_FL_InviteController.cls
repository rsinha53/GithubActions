public without sharing class SNI_FL_InviteController {
	
	@auraEnabled
    public Static void updateEmailonCT(String careTeamId,String emailId){
        try{ //// Update email on careteam Record
            
            SNI_FL_Care_Team_Member__c ctm = new SNI_FL_Care_Team_Member__c();
            ctm.Id=careTeamId;
            ctm.Email__c=emailId;  
            system.debug('#9::'+ ctm.Email__c);
            update ctm;
        }catch(Exception ex){
            system.debug('------exception-------'+ex);
            AcetUtility.CreateAndRedirectToError('FamilyLink','SNI_FL_InviteController',ex);
        }
    }
	
    @auraEnabled
    public Static string checkDuplicateUserName(string emailId){
        string msg;
        try{
            if(String.isNotBlank(emailId)){
                List<User> extuser =[select Id from user where Username=:emailId];
				List<SNI_FL_Care_Team_Member__c> lstCt =[select Id from SNI_FL_Care_Team_Member__c where Email__c=:emailId];
                if(extuser!=null && extuser.size()>0){
                    msg='This email is already in use, please enter another email to proceed';
                }else{
                    msg='SUCCESS';
                }
            }
        }catch(Exception ex){
            AcetUtility.CreateAndRedirectToError('FamilyLink','SNI_FL_InviteController',ex);
        }
        return msg;
    }
    
    @auraEnabled
    Public Static User getuserDetail(String persnAccId){
        try{
            if(String.isnotblank(persnAccId)){
               Account acc = [select Id,PersonContactId from Account where id=:persnAccId];
			   Id contId = acc.PersonContactId!=null?acc.PersonContactId:''; 
                if(String.isnotblank(contId)){
                    List<User> lstuser = [select Id, email,Username,ContactId,IsActive,IsPortalEnabled from User where ContactId =:contId]; 
                    if(lstuser !=null && lstuser.size()>0){
                        return lstuser.get(0);
                    }
                }
            }
        }Catch(Exception ex){
            AcetUtility.CreateAndRedirectToError('FamilyLink','SNI_FL_InviteController',ex);
        }
      return null;
    }
    

    @auraEnabled
    public Static String resendInvite(string careTeamId,string emailId,User userdetail){
        system.debug('-Inv-cls-resendInvite--userdetail--'+userdetail);
        EmailTemplate emtemp = [select Id,Name,DeveloperName from EmailTemplate where DeveloperName='Family_Link_Resend_Invite_Email_HTML' LIMIT 1];
        String username;
        String msg;
        try{
            
            if(userdetail!=null){
                username = userdetail.Username;
                if(String.isNotBlank(emailId) && String.isNotBlank(username)){
                    if(username.equalsIgnoreCase(emailId)){
                        if (Site.isValidUsername(userdetail.Username)) {
                            system.resetPasswordWithEmailTemplate(userdetail.Id, true, emtemp.DeveloperName);
                            msg='SUCCESS';
                        }
                    }else{
                        userdetail.Email = emailId;
                        userdetail.Username = emailId;
                        update userdetail;
                        if (Site.isValidUsername(userdetail.Username)) {
                            system.resetPasswordWithEmailTemplate(userdetail.Id, true, emtemp.DeveloperName);
                            msg='SUCCESS';
                        }
                    }
                }
               /* if(careTeamId!=null){ // Update email on careteam Record
                    SNI_FL_Care_Team_Member__c ctm = new SNI_FL_Care_Team_Member__c();
                    ctm.Id=careTeamId;
                    ctm.Email__c=emailId;
                    ctm.SNI_FL_Status__c='Invited';
                    ctm.SNI_FL_Invited_Date__c = system.today();
                    update ctm;
                }*/
                SNI_FL_ROIUtility.careTeamUpdateOperation(careTeamId,emailId);
            }
            else{
                SNI_FL_ROIUtility.createCommunityUserinResend(careTeamId,emailId);
            }
            
        }catch(Exception ex){
            system.debug('---------exception----forgot----'+ex);
            AcetUtility.CreateAndRedirectToError('FamilyLink','SNI_FL_InviteController',ex);
        }
        return msg;
    }    
}