public without sharing class SENSAPI_Utility {
    
    //Get the users related to the person accounts
    public static List<User> getUsersByAccountIds(Set<Id> accountIds){
        List<User> userList = [SELECT Id,AccountId,Phone,MobilePhone FROM User WHERE AccountId IN:accountIds];
        return userList; 
    }
    
    //Get the users related to the person account
    public static User getUserByAccountId(String accountId){
        List<User> userList = [SELECT Id, MobilePhone FROM User WHERE AccountId=:accountId];
        User user;
        if(!userList.isEmpty()){
            user = userList[0];
        }
        return user;
    }
    
    // Check valid and invalid members having care team or not
    public static careTeamWrap isValidMember(List<String> authMems, List<String> revokeMems, String sensId, String subsId){
        careTeamWrap cwrap = new careTeamWrap();
        cwrap.cteamMems = new map<String,SNI_FL_Care_Team_Member__c>();
        cwrap.invalidMems = new List<string>();
        cwrap.validMems = new map<string,SNI_FL_Care_Team_Member__c>();
        cwrap.validSensId = new list<SNI_FL_Care_Team_Member__c>();
        List<SNI_FL_Care_Team_Member__c> cteam = [SELECT ID,SNI_FL_Member__c FROM SNI_FL_Care_Team_Member__c WHERE SNI_FL_Family__r.Member_ID__c=: subsId];
        for(SNI_FL_Care_Team_Member__c cr : cteam){
            cwrap.cteamMems.put(cr.SNI_FL_Member__c,cr);
        }
        if(authMems != null){
            for(String auth : authMems){
                if(cwrap.cteamMems.containskey(auth)){
                    cwrap.validMems.put(auth,cwrap.cteamMems.get(auth));
                }
                else{
                    cwrap.invalidMems.add(auth); 
                }
            }
        }
        if(revokeMems != null){
            for(String rev : revokeMems){
                if(!cwrap.cteamMems.containskey(rev))
                    cwrap.invalidMems.add(rev);
                else
                    cwrap.validMems.put(rev,cwrap.cteamMems.get(rev));
            }
        }
        if(cwrap.cteamMems.containskey(sensId))
            cwrap.validSensId.add(cwrap.cteamMems.get(sensId));
        else
            cwrap.invalidMems.add(sensId);
        return cwrap;
    }
    
    public class careTeamWrap{
        public list<string> invalidMems;
        public map<string,SNI_FL_Care_Team_Member__c> validMems;
        public list<SNI_FL_Care_Team_Member__c> validSensId;
        public map<String,SNI_FL_Care_Team_Member__c>cteamMems;
        
    }
    
    public static List<ContentDocument> getContentDocuments(List<String> documentIds){
        return [SELECT Id, ContentSize, CreatedDate, FileExtension, 
                LastModifiedDate, OwnerId, Title, 
                (SELECT Id,ContentDownloadUrl FROM ContentDistributions) 
                FROM ContentDocument WHERE Id IN:documentIds];
        
    }
    
   // Check if the users exist or active in salesforce 
    public static list<user> checkValidUsers(List<String> usIdsList){ //return valid users list
        List<user> validUser = new list<user>();
        List<user> invalidUser = new list<user>();
        List<user> validUsers = [SELECT id,isactive,name from user where id in:usIdsList];
        system.debug('valid users'+validUsers);
        for(User u : validUsers){
            if(u.isactive == true){
                validUser.add(u); 
            }else{
               invalidUser.add(u);
            }
        }

        return validUser;
    }
    
    //Validate Request for Post ROI API
    public static boolean validRequestCheck(SENSAPI_postMemberROIRequest request){
        Boolean isValidRequest;
        if(request.authorizedFor != null && request.revokedFor != null){
            if((String.isNotBlank(request.subscriberId) && String.isNotBlank(request.sensId) && request.authorizedFor.size()>0
                && request.revokedFor.size()>0) || (String.isNotBlank(request.subscriberId) && String.isNotBlank(request.sensId) && request.authorizedFor.size()<=0
                                                    && request.revokedFor.size()>0) || (String.isNotBlank(request.subscriberId) && String.isNotBlank(request.sensId) && request.authorizedFor.size()>0
                                                                                        && request.revokedFor.size()<=0)){
                                                                                            isValidRequest = true;
                                                                                        } 
            else{
                isValidRequest = false;
            }
        }
        else if(request.authorizedFor == null){
            if(String.isNotBlank(request.subscriberId) && String.isNotBlank(request.sensId) && request.revokedFor.size()>0){
                isValidRequest = true;
            }
            else{
                isValidRequest = false;
            }
        }
        else if(request.revokedFor == null){
            if(String.isNotBlank(request.subscriberId) && String.isNotBlank(request.sensId) && request.authorizedFor.size()>0
              ){
                  isValidRequest = true;
              }
            else{
                isValidRequest = false;
            }
        }
        return isValidRequest;
    }
    
    //Get owner of the member who is giving/revoking authorization
    public static List<user> getROIOwner(String authorizedBySensId){
        Set<Id> userIds =  new Set<Id>();
        List<user> roiOwner;
        userIds.add(authorizedBySensId);
        if(userIds.size() > 0){
            roiOwner = SENSAPI_Utility.getUsersByAccountIds(userIds);
        }
        return roiOwner;
    }
    
    public static list<SENSAPI_getCareAdvisorResponse.careAdvisorDetails> populateCareAdvisorDetails(User careAdvisorUser, Family_Overview__c familyOverviewDetails){
        SENSAPI_getCareAdvisorResponse.careAdvisorDetails careAdvisor = new SENSAPI_getCareAdvisorResponse.careAdvisorDetails();
        list<SENSAPI_getCareAdvisorResponse.careAdvisorDetails> careAdvList =  new list<SENSAPI_getCareAdvisorResponse.careAdvisorDetails>();
        if(careAdvisorUser.Name != 'Unassigned'){
            careAdvisor.firstName   =  careAdvisorUser.FirstName;
            String[] lastInitials = careAdvisorUser.LastName.split('');
            careAdvisor.lastName        =  lastInitials[0];
            careAdvisor.sensId =  careAdvisorUser.Id;
            careAdvisor.bio     = careAdvisorUser.AboutMe;
            careAdvisor.phone = careAdvisorUser.Phone;
            careAdvisor.extension = careAdvisorUser.Extension;
            careAdvisor.status = 'Primary';
            if(familyOverviewDetails != null){
                careAdvisor.assignedDate = familyOverviewDetails.Advisor_Assigned_Date__c;
            }
            careAdvList.add(careAdvisor);
        }
        return careAdvList;
    } 
    
    public static SENSAPI_GetFamilyDetailsResponse.CareAdvisorDetails populateCareAdvisor(User careAdvisorUser){
        SENSAPI_GetFamilyDetailsResponse.CareAdvisorDetails careAdvisor = new SENSAPI_GetFamilyDetailsResponse.CareAdvisorDetails();
        careAdvisor.firstName   =  careAdvisorUser.FirstName;
        //careAdvisor.middleName  =  careAdvisorUser.MiddleName;
        careAdvisor.lastName        =  careAdvisorUser.LastName;
        careAdvisor.sensId =  careAdvisorUser.Id;
        //careAdvisor.email   = careAdvisorUser.Email;
        careAdvisor.bio     = careAdvisorUser.AboutMe;
        //careAdvisor.icon = careAdvisorUser.SmallPhotoUrl;
        //careAdvisor.suspended = !careAdvisorUser.IsActive;
        //careAdvisor.joinedSince = careAdvisorUser.CreatedDate.Date();
        //careAdvisor.username = careAdvisorUser.Username;
        //careAdvisor.phone = careAdvisorUser.Phone;
        //careAdvisor.mobilePhone = careAdvisorUser.Mobilephone;
        careAdvisor.role = careAdvisorUser.UserRole.Name;
        return careAdvisor;
    } 
    
    public static List<Account> getFamilyAccount(String subscriberId){
        Id recordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Family').getRecordTypeId();
        return [SELECT Id,Name,AccountNumber,Member_ID__c,Alternate_Id__c,OwnerId,Owner.Name,Owner.UserRole.Name,Owner.IsActive,
                Family_ID__c,Owner.FirstName,Owner.LastName,
                Owner.AboutMe,policy_Id__c,
                
                (SELECT Id,SNI_FL_Primary_Caregiver__c,SNI_FL_Non_Policy_Member__c,SNI_FL_Status__c,
                 SNI_FL_Added_Date__c,SNI_FL_Invited_Date__c, SNI_FL_Registered_Date__c,SNI_FL_Removed_Date__c,
                 SNI_FL_Member__c, SNI_FL_Member__r.EID__c,SNI_FL_Member__r.FirstName, SNI_FL_Member__r.MiddleName, SNI_FL_Member__r.LastName, 
                 SNI_FL_Member__r.PersonBirthdate, SNI_FL_Member__r.PersonEmail, SNI_FL_Member__r.Phone, SNI_FL_Member__r.PersonMobilePhone,
                 SNI_FL_Member__r.PersonMailingStreet, SNI_FL_Member__r.PersonMailingCity, SNI_FL_Member__r.PersonMailingPostalCode, SNI_FL_Member__r.PersonMailingState, 
                 SNI_FL_Member__r.PersonMailingCountry, 
                 SNI_FL_Member__r.Preferred_Name__pc, SNI_FL_Member__r.Email_Notification__c, SNI_FL_Member__r.Text_Message_SMS_Notification__c
                 FROM SNI_FL_CareTeam_Members__r),
                
                (SELECT Id,Relationship__c,ContactId,Contact.AccountId,Contact.LastName,Contact.FirstName,contact.birthdate,
                 Contact.MiddleName, Contact.Account.Email_Notification__c,Contact.Account.Text_Message_SMS_Notification__c,
                 Contact.Account.PersonEmail,Contact.Account.Phone,Contact.Account.PersonMobilePhone,Contact.Account.Preferred_Name__pc,Contact.Account.PersonMailingStreet,
                 Contact.Account.PersonMailingCity, Contact.Account.PersonMailingPostalCode, Contact.Account.PersonMailingState, 
                 Contact.Account.PersonMailingCountry, Contact.Account.EID__c,contact.Phone,contact.mobilePhone
                 FROM AccountContactRelations), 
                
                (SELECT Id,Advisor_Assigned_Date__c FROM Family_Overview__r LIMIT 1)
                
                FROM Account WHERE Member_ID__c=:subscriberId AND RecordTypeId=:recordTypeId LIMIT 1];
    }
    
    public static List<Account> getFamilyAccountWithOwner(String subscriberId){
        Id recordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Family').getRecordTypeId();
        return [SELECT Id,Name,AccountNumber,Member_ID__c,OwnerId,Owner.Name,Owner.UserRole.Name,Owner.IsActive,
                Owner.Email,Owner.Phone,Owner.Extension,
                Family_ID__c,Owner.FirstName,Owner.LastName,Owner.MiddleName,
                Owner.UserName,Owner.MobilePhone,Owner.AboutMe,Owner.SmallPhotoUrl,
                Owner.CreatedDate,Owner.Address, policy_Id__c,
                
                (SELECT Id,Advisor_Assigned_Date__c FROM Family_Overview__r LIMIT 1)
                
                FROM Account WHERE Member_ID__c=:subscriberId AND RecordTypeId=:recordTypeId LIMIT 1];
    }
    
    public static List<Account> getMemberAccounts(Set<Id> accountIds){
        return  [SELECT Id,
                 
                 (SELECT Id, SNI_FL_Member__c, SNI_FL_Member__r.SNI_FL_Member__c, 
                  SNI_FL_ROI_Signed_With__c, SNI_FL_ROI_Signed_With__r.SNI_FL_Member__c,
                  OwnerId,
                  SNI_FL_ROI_Signed_Date__c, SNI_FL_Type__c, SNI_FL_Signed_Email__c, SNI_FL_Status__c FROM Members_ROIs__r),
                 
                 (SELECT Id, Gender__c FROM Members_Information__r LIMIT 1)
                 FROM Account WHERE Id IN: accountIds];
    }
    
    public static SENSAPI_GetFamilyDetailsResponse.Address populateAddress(Account acct){
        SENSAPI_GetFamilyDetailsResponse.Address address = new SENSAPI_GetFamilyDetailsResponse.Address();
        address.address = acct.PersonMailingStreet;
        address.city = acct.PersonMailingCity;
        address.zipcode = acct.PersonMailingPostalCode;
        address.state = acct.PersonMailingState;
        address.country = acct.PersonMailingCountry;
        return address;
    }    
    //Get specific care team member based on Id
    public static list<SNI_FL_Care_Team_Member__c> getSpecificCareTeamMember(String sfId){
        list<SNI_FL_Care_Team_Member__c>careMemberList = [SELECT 
                                                          ID,
                                                          SNI_FL_Status__c,
                                                          SNI_FL_Primary_Caregiver__c,
                                                          SNI_FL_Family__c
                                                          FROM 
                                                          SNI_FL_Care_Team_Member__c 
                                                          WHERE SNI_FL_Member__c =: sfId LIMIT 1];
        return careMemberList;
    }
    
    //Get specific care team member based on Id and subscriber id
    public static list<SNI_FL_Care_Team_Member__c> getSpecificCareTeamMemberForFamily(String sfId, String subscriberId){
        list<SNI_FL_Care_Team_Member__c>careMemberList = [SELECT 
                                                          ID,
                                                          SNI_FL_Status__c,
                                                          SNI_FL_Primary_Caregiver__c,
                                                          SNI_FL_Family__c,SNI_FL_Member__c,
                                                          SNI_FL_Member__r.FirstName,
                                                          SNI_FL_Member__r.LastName,
                                                          SNI_FL_Member__r.personContactId
                                                          FROM 
                                                          SNI_FL_Care_Team_Member__c 
                                                          WHERE SNI_FL_Member__c =: sfId and SNI_FL_Family__r.Member_ID__c=:subscriberId LIMIT 1];
        return careMemberList;
    }
    
    //Get all care team members based on family Id(Not referred in any of the classes)
   /* public static list<SNI_FL_Care_Team_Member__c> getAllCareTeamMembersForFamily(String sfId){
        list<SNI_FL_Care_Team_Member__c>allCareMemberFamilyList = [SELECT 
                                                                   ID,
                                                                   SNI_FL_Status__c,
                                                                   SNI_FL_Primary_Caregiver__c,
                                                                   SNI_FL_Family__c,SNI_FL_Member__c
                                                                   FROM 
                                                                   SNI_FL_Care_Team_Member__c 
                                                                   WHERE SNI_FL_Family__c =: sfId];
        return allCareMemberFamilyList;
    }*/
    

    public static List<SNI_FL_Care_Team_Member__c> getAllCareTeamMembersForFamilyMemberId(String subscriberId){
        list<SNI_FL_Care_Team_Member__c> allCareMemberFamilyList = [SELECT 
                                                                   ID,
                                                                   SNI_FL_Status__c,
                                                                   SNI_FL_Primary_Caregiver__c,
                                                                   SNI_FL_Family__c,SNI_FL_Member__c,
                                                                   SNI_FL_Non_Policy_Member__c,
                                                                   SNI_FL_Family__r.Member_Id__c
                                                                   FROM 
                                                                   SNI_FL_Care_Team_Member__c 
                                                                   WHERE SNI_FL_Family__r.Member_Id__c =:subscriberId];
        return allCareMemberFamilyList;
    }
    
    public static void careTeamUpdateStatusList(List<SNI_FL_Care_Team_Member__c> careTeamList){
        if(careTeamList!=null && careTeamList.size()>0){   
            List<SNI_FL_Care_Team_Member__c> careTeamUpdateLst = new List<SNI_FL_Care_Team_Member__c>();
            for(SNI_FL_Care_Team_Member__c careTeam : careTeamList){
                if(careTeam.SNI_FL_Non_Policy_Member__c){
                    careTeam.SNI_FL_Not_Visible_in_Familylink__c = true;
                }
                careTeam.SNI_FL_Status__c = 'Removed';
                careTeam.SNI_FL_Removed_Date__c = system.today();
                careTeam.SNI_FL_Authorized__c=false;
                careTeamUpdateLst.add(careTeam);
            }
            if(careTeamUpdateLst.size()>0){
                update careTeamUpdateLst;
            }
        }
    }
    
    public static List<Account> getFamilyAccountForSubscriberId(String subscriberId){
        return [SELECT Id FROM Account WHERE Member_ID__c=:subscriberId AND RecordType.Name = 'Family' LIMIT 1];
    }
    
    
    //Check if To users have the integration Custom Permission (Added By Pratikshya)
    public static List<User> checkUserWithIntegrationPerm(){
        Set<Id> permissionSetIds = new Set<Id>();
    for (SetupEntityAccess access : [
        SELECT ParentId 
        FROM SetupEntityAccess 
        WHERE SetupEntityId IN (
            SELECT Id 
            FROM CustomPermission 
            WHERE DeveloperName = 'isLeagueIntegrationUser'
        )
    ]) {
        permissionSetIds.add(access.ParentId);
    }
       
         return [SELECT Id FROM User WHERE Id IN (
            SELECT AssigneeId FROM PermissionSetAssignment
            WHERE PermissionSetId IN :permissionSetIds
        )
    ];
    }
    public Static String resendInvite(SNI_FL_Care_Team_Member__c member,string careTeamId,string emailId,User userdetail){
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
                SNI_FL_ROIUtility.careTeamUpdateOperation(careTeamId,emailId);
            }
            else{
                msg = createCommunityUserinResend(member,careTeamId,emailId);
            }
            
        }catch(Exception ex){
            msg = ex.getMessage(); 
        }
        return msg;
    }  
    
    public Static String createCommunityUserinResend(SNI_FL_Care_Team_Member__c member,String careTeamId,string email){
        String msg;
        try{
            if(String.isNotBlank(careTeamId)){
                Profile flp = [Select Id from Profile where name = 'Care Advisor Connect Community User' LIMIT 1];   
                User comUser = New User();
                comUser.UserName = email;
                comUser.FirstName = member.SNI_FL_Member__r.FirstName;
                comUser.LastName = member.SNI_FL_Member__r.LastName;
                comUser.Alias = ( String.isNotBlank(member.SNI_FL_Member__r.LastName) 
                                 && member.SNI_FL_Member__r.LastName.length()>3 )?member.SNI_FL_Member__r.LastName.substring(0,3):member.SNI_FL_Member__r.firstName.substring(0,3);                         
                comUser.email = email;
                comUser.ContactId = member.SNI_FL_Member__r.PersonContactId;
                comUser.CommunityNickName = 'FLUser'+string.valueOf(math.random()).substring(0,6);
                comUser.ProfileID = flp.id;
                comUser.TimeZoneSidKey = 'America/Mexico_City';
                comUser.LocaleSidKey = 'en_US';
                comUser.EmailEncodingKey = 'UTF-8';
                comUser.LanguageLocaleKey = 'en_US';
                Database.SaveResult[] srList = Database.insert(new list<user>{comUser},false);
                System.debug('User Created='+comUser);
                for (Database.SaveResult sr : srList) {
                    if (sr.isSuccess()) {
                        SNI_FL_ROIUtility.careTeamUpdateOperation(careTeamId,email);
                        msg = 'SUCCESS';
                    }else{
                        for(Database.Error err : sr.getErrors()) {
                            msg = err.getMessage();
                        }
                    }
                }
            }
        }catch(Exception ex){
            msg = ex.getMessage();
        }
        return msg;
    }
    //Get Existing ROI records associated to authorized and revoked members
    public static ROIWrapper getExistingROIS(list<string> roiListMembers, list<string> authorizedForMemId, list<string> revokedForMemId , String sensId){
        //This will return ROIs record related to authorized as well as revoked members if any
        list<SNI_FL_Members_ROI__c>roiList = [SELECT Id,SNI_FL_ROI_Signed_With__r.SNI_FL_Member__c from SNI_FL_Members_ROI__c where 
                                              SNI_FL_ROI_Signed_With__r.SNI_FL_Member__c in: roiListMembers and SNI_FL_Account__c =: sensId];
        system.debug('roiList is'+roiList.size());
        ROIWrapper rwrap = new ROIWrapper();
        rwrap.authorizedMap = new map<String,SNI_FL_Members_ROI__c>();
        rwrap.revokedMap = new map<String,SNI_FL_Members_ROI__c>();
        rwrap.authorizedNonROIList = new list<String>();
        rwrap.revokedNonROIList = new list<String>();
        //If ROI records are returned
        if(roiList.size() > 0){
            for(SNI_FL_Members_ROI__c roi : roiList){
                if(authorizedForMemId != null){
                    if(authorizedForMemId.contains(roi.SNI_FL_ROI_Signed_With__r.SNI_FL_Member__c)){
                        //This map will have all authorized members having ROI
                        rwrap.authorizedMap.put(roi.SNI_FL_ROI_Signed_With__r.SNI_FL_Member__c,roi);
                    }
                }
                if(revokedForMemId != null){
                    if(revokedForMemId.contains(roi.SNI_FL_ROI_Signed_With__r.SNI_FL_Member__c)){
                        //This map will have all revoked members having ROI
                        rwrap.revokedMap.put(roi.SNI_FL_ROI_Signed_With__r.SNI_FL_Member__c,roi);
                    }
                }
            }
            if(authorizedForMemId != null){
                for(String nonRoiMemAuth : authorizedForMemId){
                    if(!rwrap.authorizedMap.containskey(nonRoiMemAuth))
                        //This List will have all authorized members not having ROI
                        rwrap.authorizedNonROIList.add(nonRoiMemAuth);    
                }
            }
            if(revokedForMemId != null){
                for(String nonRoiMem : revokedForMemId){
                    if(!rwrap.revokedMap.containskey(nonRoiMem))
                        //This List will have all revoked members not having ROI
                        rwrap.revokedNonROIList.add(nonRoiMem);    
                }
            }
        }
        else{
            //If no ROI records are returned. All authorized and revoked members won't have ROIs
            if(authorizedForMemId != null){
                //This List will have all authorized members not having ROI
                rwrap.authorizedNonROIList.addall(authorizedForMemId);
            }
            if(revokedForMemId != null){
                //This List will have all revoked members not having ROI
                rwrap.revokedNonROIList.addall(revokedForMemId);
            }
        }
        return rwrap;
    }
    
    public class ROIWrapper{
        public map<String,SNI_FL_Members_ROI__c> authorizedMap;
        public map<String,SNI_FL_Members_ROI__c> revokedMap;
        public list<String> authorizedNonROIList;
        public list<String> revokedNonROIList;
    }
    
    //Update Existing ROIS for authorized and revoked members
    public static list<SNI_FL_Members_ROI__c> updateExistingROIS(map<String,SNI_FL_Members_ROI__c> authorizedMap,map<String,SNI_FL_Members_ROI__c> revokedMap){
        list<SNI_FL_Members_ROI__c> roiUpdatedList = new list<SNI_FL_Members_ROI__c>();
        if(authorizedMap.values().size() > 0){
            //Update existing ROIs for authorized members
            for(SNI_FL_Members_ROI__c roi : authorizedMap.values()){
                roi.Exp_Date__c = system.today().addYears(1);
                roi.SNI_FL_Status__c = 'Active';
                roiUpdatedList.add(roi);
            }
            update roiUpdatedList;
        }
        if(revokedMap.values().size() > 0){
            //Update existing ROIs for revoked members
            for(SNI_FL_Members_ROI__c roi : revokedMap.values()){
                roi.Exp_Date__c = system.today();
                roi.SNI_FL_Status__c = 'Inactive';
                roi.Is_Revoked__c = true;
                roiUpdatedList.add(roi);
            }
            update roiUpdatedList;
        }
        return roiUpdatedList;
    }
    //Create ROIs for authorized members who don't have ROIS
    public static list<SNI_FL_Members_ROI__c> createROIS (map<String, SNI_FL_Care_Team_Member__c> cteamMap,list<SNI_FL_Care_Team_Member__c> cteams,String userId){
        List<SNI_FL_Members_ROI__c> roilist = new list<SNI_FL_Members_ROI__c>();
        for(SNI_FL_Care_Team_Member__c cteam : cteamMap.values()){
            SNI_FL_Members_ROI__c roi = new SNI_FL_Members_ROI__c();
            roi.SNI_FL_Member__c = cteams[0].id;
            roi.SNI_FL_Account__c = cteams[0].SNI_FL_Member__c;
            roi.SNI_FL_ROI_Signed_With__c = cteam.id;
            roi.SNI_FL_ROI_Signed_Date__c = system.today();
            roi.Exp_Date__c = system.today().addYears(1);
            roi.SNI_FL_Type__c = 'Electronically';
            roi.SNI_FL_Status__c = 'Active';
            roi.ownerId = userId;
            roiList.add(roi);
        }
        return roiList;
    }
    
    //Subscriber Id Check
    public static String getSubscriberId(String subscriberId){
        string subId = subscriberId;
        if(subscriberId != null){
            subId = subId.leftPad(11, '0');
        }
        return subId;
    }
    
}