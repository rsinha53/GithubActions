/********************************************************************************* 
Class Name     : SNI_FLDirectMessageObjectQuery.apxc
Description    : Handling Object query related functions
Created By     : Sameera De Silva
Created Date   : 8/25/2020 

Modification Log
---------------------------------------------------------------------------------- 
Developer                   Date                   Description

1.Sameera De Silva      8/25/2020        Created class without body 
2.Sameera De Silva      8/25/2020        Adding method methods without method defintions
3.Nanthavarman Lingeswaran  9/4/2020        Create sort order for messages list
----------------------------------------------------------------------------------            

*********************************************************************************/

public without sharing class SNI_FLDirectMessageObjectQuery {
    
    public static final String SYSADMINPROFILE = 'System Administrator';
    public static final String FECREADONLYPROFILE ='Family Engagement Center - Read Only';
    public static final String READABLE = 'READABLE';
    public static final String TEAMNAME = 'ACDC ';
    public static final String LINENUMBER = ' Line Number ';
    public static final List<String> USERROLES = new List<String>{'Registered Nurse - UHG',
        'Regional PDC - UHG',
        'Process Expert - UHG',
        'Nurse Advisor',
        'Behavioral Health Advisor',
        'Wellness and Community Coach',
        'Women\'s Health Nurse Advisor',
        'Pharmacist'};
            
    //retrieves a mpa of directMessage feeds and related comments for each feed
    //Author: Sameera De Silva (ACDC)
    public static Map<ID,List<FeedComment>> getCommentsForFeed(List<DirectMessageFeed> lstDirectMsgFeeds){
        
        Set<ID> feedIDs = new Set<ID>();
        Map<ID,List<FeedComment>> feedIdsWithComments = new Map<ID,List<FeedComment>>();
        
        try{
            for(DirectMessageFeed feed:lstDirectMsgFeeds){
                feedIDs.add(feed.id);
            }
            
            List<FeedComment> lstFeedComments = [SELECT Id,CreatedById,CreatedDate,RelatedRecordId,CommentBody,FeedItemId FROM FeedComment WHERE FeedItemId IN :feedIDs ORDER BY CreatedDate DESC LIMIT 10];
            
            if(!lstFeedComments.isEmpty()){
                for(FeedComment feeedcmt:lstFeedComments){
                    
                    if(feedIdsWithComments.containsKey(feeedcmt.FeedItemId)){
                        
                        List<FeedComment> lstValues = feedIdsWithComments.get(feeedcmt.FeedItemId);
                        lstValues.add(feeedcmt);
                        feedIdsWithComments.put(feeedcmt.FeedItemId,lstValues);
                        
                    }else{
                        
                        List<FeedComment> lstValues = new List<FeedComment>();
                        lstValues.add(feeedcmt);
                        feedIdsWithComments.put(feeedcmt.FeedItemId,lstValues);
                    }
                }
                
                return feedIdsWithComments;
            }else{
                return null;
            }
        }catch(Exception ex){
            System.debug(TEAMNAME+ex.getMessage()+LINENUMBER+ex.getLineNumber());
            return null;
        }
    }
    
    //Retrieve directMessageWrapper object for given feedID. This will be invoked when a user clicks 
    //a message from the message list
    //Author: Sameera De Silva (ACDC)
    public static SNI_FLDirectMessageWrapper getDirectMessageWrapper(String feedID,String userID, Boolean isProviderMessage){
        if(isProviderMessage == false){
            SNI_FLDirectMessageWrapper.SNI_FLUserDetails initiatedUser;
            List<SNI_FLDirectMessageWrapper.SNI_FLUserDetails> involvedUsers = new LIst<SNI_FLDirectMessageWrapper.SNI_FLUserDetails>();
            SNI_FLDirectMessageWrapper.SNI_FLMessage flMessage;
            SNI_FLDirectMessageWrapper.SNI_FLDirectMessageFeed directMessageFeed;
            
            Map<ID,List<FeedComment>> mapOfFeedComments;
            List<SNI_FLDirectMessageWrapper.SNI_FL_DirectMessageFeedComments> lstFeeedComment = new List<SNI_FLDirectMessageWrapper.SNI_FL_DirectMessageFeedComments>();
            
            try{
                
                //Retrive SNI_FL_Message__c record matches with FeedID and creating SNI_FLMessage Wrapper object
                SNI_FL_Message__c flMsg = [SELECT Id, (SELECT id,IsRead__c FROM SNI_FL_Message_Statuses__r WHERE Agent__c=:UserInfo.getUserId()),Family_ID__c,Family_ID__r.Name,Feed_Id__c,Marked__c FROM SNI_FL_Message__c WHERE Feed_Id__c=:feedID  LIMIT 1];
                List<SNI_FL_Message_Status__c> msgStatus = flMsg.SNI_FL_Message_Statuses__r;
                flMessage = new SNI_FLDirectMessageWrapper.SNI_FLMessage(flMsg.Family_ID__c,flMsg.Feed_Id__c,flMsg.Family_ID__r.Name,flMsg.Marked__c,msgStatus.size()>0?msgStatus[0].IsRead__c:false);
                
                Map<ID,User> lstOfUser =getUserdetails();//Retriving map of userIDs and user records
                
                //Retrieving drirectMessageFeed record for the feedID
                List<DirectMessageFeed> lstDirectMessageFeed =  [SELECT Id,Parent.Id, Parent.Subject,Body,LastModifiedDate,CreatedDate,CreatedById, ParentId FROM DirectMessageFeed WHERE Id =:feedID ];
                
                //Preparing initated user wrapper and involved user wrapper objects 
                List<DirectMessageMember> lstDirectMessageMember = [SELECT Id,DirectMessageId,MemberId FROM DirectMessageMember WHERE DirectMessageId=:lstDirectMessageFeed[0].ParentId ];
            
                List<User> custPermUsrs = SENSAPI_Utility.checkUserWithIntegrationPerm();//This will check for the user having league integration permission set. Added by pratikshya
                map<id,user> userMap = new map<id,user>(); //Added by Pratikshya
                for(User us : custPermUsrs){
                    userMap.put(us.id,us);
                }
                
                for(DirectMessageMember member:lstDirectMessageMember){
                    String userRole = '';
                    if(member.MemberId == userID){
                        
                        User initUser = lstOfUser.get(userID);
                        
                        if(initUser.userRole.name.contains('FEC')){userRole = system.Label.FEC;}  //$Label.c.FEC
                        if(initUser.userRole.name.contains('Registered Nurse')){userRole = System.Label.Registered_Nurse;}
                        if(initUser.userRole.name.contains('Wellness and Community Coach')){userRole = 'Wellness and Community Coach';}
                        if(initUser.userRole.name.contains('Nurse Advisor')){userRole = 'Nurse Advisor';}
                        if(initUser.userRole.name.contains('Behavioral Health Advisor')){userRole = 'Behavioral Health Advisor';}
                        if(initUser.userRole.name.contains('Pharmacist')){userRole = 'Pharmacist';}
                        if(initUser.userRole.name.contains('Clinical Manager')){userRole = 'Clinical Manager';}
                        if(initUser.userRole.name.contains('Research Advisor')){userRole = 'Research Advisor';}
                        if(initUser.userRole.name.contains('Care Advisor')){userRole = 'Care Advisor';}
                        if(initUser.userRole.name.contains('Non-Clinical Supervisor')){userRole = 'Non-Clinical Supervisor';}
                        if(initUser.userRole.name.contains('Women\'s Health Nurse Advisor')){userRole = 'Women\'s Health Nurse Advisor';}
                        initiatedUser = new SNI_FLDirectMessageWrapper.SNI_FLUserDetails(initUser.FirstName,initUser.LastName,initUser.Id,initUser.profile.name,userRole);
                        
                    }else{
                        //added vamsi
                        User userInvolved = lstOfUser.get(member.MemberId);
                        if(!userMap.containskey(userInvolved.id)){ 
                        if(userInvolved.userRole.name.contains('FEC')){userRole = system.Label.FEC;}  //$Label.c.FEC
                        if(userInvolved.userRole.name.contains('Registered Nurse')){userRole = System.Label.Registered_Nurse;}
                        if(userInvolved.userRole.name.contains('Wellness and Community Coach')){userRole = 'Wellness and Community Coach';}
                        if(userInvolved.userRole.name.contains('Nurse Advisor')){userRole = 'Nurse Advisor';}
                        if(userInvolved.userRole.name.contains('Behavioral Health Advisor')){userRole = 'Behavioral Health Advisor';}
                        if(userInvolved.userRole.name.contains('Pharmacist')) {userRole = 'Pharmacist';}
                        if(userInvolved.userRole.name.contains('Clinical Manager')) {userRole = 'Clinical Manager';}
                        if(userInvolved.userRole.name.contains('Research Advisor')) {userRole = 'Research Advisor';}
                        if(userInvolved.userRole.name.contains('Care Advisor')) {userRole = 'Care Advisor';}
                        if(userInvolved.userRole.name.contains('Non-Clinical Supervisor')) {userRole = 'Non-Clinical Supervisor';}
                        if(userInvolved.userRole.name.contains('Women\'s Health Nurse Advisor')){userRole = 'Women\'s Health Nurse Advisor';}
                        involvedUsers.add(new SNI_FLDirectMessageWrapper.SNI_FLUserDetails(userInvolved.FirstName,userInvolved.LastName,userInvolved.Id,userInvolved.profile.name,userRole));
                        }
                    }
                    
                }
                
                mapOfFeedComments = getCommentsForFeed(lstDirectMessageFeed);
                
                if(mapOfFeedComments != NULL){
                    Map<ID,ContentVersion> attachments = getContentDocumentData(mapOfFeedComments.get(feedID));
                    Map<ID,ContentDistribution> contentDistributions = getContentDistribution(mapOfFeedComments.get(feedID));
                    for(FeedComment comment:mapOfFeedComments.get(feedID)){
                        String userRole = '';
                        User commentedUser = lstOfUser.get(comment.CreatedById);
                        ContentVersion version = attachments.get(comment.id);
                        ContentDistribution distribution = contentDistributions.get(comment.id);
                        if(commentedUser.userRole.name.contains('FEC')){userRole = system.Label.FEC;}  //$Label.c.FEC
                        if(commentedUser.userRole.name.contains('Registered Nurse')){userRole = System.Label.Registered_Nurse;}
                        if(commentedUser.userRole.name.contains('Wellness and Community Coach')){userRole = 'Wellness and Community Coach';}
                        if(commentedUser.userRole.name.contains('Nurse Advisor')){userRole = 'Nurse Advisor';}
                        if(commentedUser.userRole.name.contains('Behavioral Health Advisor')){userRole = 'Behavioral Health Advisor';}
                        if(commentedUser.userRole.name.contains('Pharmacist')){userRole = 'Pharmacist';}
                        if(commentedUser.userRole.name.contains('Non-Clinical Supervisor')){userRole = 'Non-Clinical Supervisor';}
                        if(commentedUser.userRole.name.contains('Clinical Manager')) {userRole = 'Clinical Manager';}
                        if(commentedUser.userRole.name.contains('Research Advisor')) {userRole = 'Research Advisor';}
                        if(commentedUser.userRole.name.contains('Care Advisor')) {userRole = 'Care Advisor';}
                        if(commentedUser.userRole.name.contains('Women\'s Health Nurse Advisor')){userRole = 'Women\'s Health Nurse Advisor';}
                        if(version != NULL){
                            lstFeeedComment.add(new SNI_FLDirectMessageWrapper.SNI_FL_DirectMessageFeedComments(comment.CommentBody,new SNI_FLDirectMessageWrapper.SNI_FLUserDetails(commentedUser.FirstName,commentedUser.LastName,commentedUser.Id,commentedUser.profile.name,userRole),comment.CreatedDate,
                                                                                                                version.ContentDocument.LatestPublishedVersionId,version.ContentDocument.FileExtension,version.ContentDocument.Title,true,distribution != NULL?distribution.ContentDownloadUrl:NULL));
                        }
                        else{
                            lstFeeedComment.add(new SNI_FLDirectMessageWrapper.SNI_FL_DirectMessageFeedComments(comment.CommentBody,new SNI_FLDirectMessageWrapper.SNI_FLUserDetails(commentedUser.FirstName,commentedUser.LastName,commentedUser.Id,commentedUser.profile.name,userRole),comment.CreatedDate,null,null,null,false,null));
                        }
                        
                    }
                    
                }
                
                directMessageFeed = new SNI_FLDirectMessageWrapper.SNI_FLDirectMessageFeed(lstDirectMessageFeed[0].CreatedDate,lstDirectMessageFeed[0].LastModifiedDate,lstDirectMessageFeed[0].Body,lstDirectMessageFeed[0].Id,initiatedUser);
                
                return new SNI_FLDirectMessageWrapper(involvedUsers,lstFeeedComment,lstDirectMessageFeed[0].Parent.Subject,directMessageFeed,flMessage,0,0,0,0,0);
                
            }catch(Exception ex){
                
                System.debug(TEAMNAME+ex.getMessage()+LINENUMBER+ex.getLineNumber());
                return null;
            }
        }else{
            return SNI_FL_ProviderMessageContentDisplay.getDirectMessageWrapper(feedID,userID);
        }
        
        
    }
    //Mark flag and unflag status in the message 
    public static Boolean feedToggleMarked(boolean flflag, ID feedID){
        try { 
            List <SNI_FL_Message__c> lstflMsg = [SELECT Id, Marked__c, Feed_Id__c FROM SNI_FL_Message__c WHERE Feed_Id__c = :feedID ]; 
            lstflMsg[0].Marked__c = flflag; 
            update lstflMsg; 
            return flflag; 
        } catch(exception ex) {
            System.debug(TEAMNAME+ex.getMessage()+LINENUMBER+ex.getLineNumber());
            return null; 
        } 
    }
    
    //Update the read and uread status when user clicks on a message from the message list.
    //this method will fire after 3seconds from the UI
    //Author: Prasad Ruwanpathirana (ACDC)
    public static Boolean changeReadStatus(boolean isRead,Id feedID){
        try { 
            List <SNI_FL_Message_Status__c> lstflMsg = [SELECT Id, IsRead__c, SNI_FL_Message__c FROM SNI_FL_Message_Status__c WHERE SNI_FL_Message__r.Feed_Id__c = :feedID AND Agent__c =:UserInfo.getUserId() ];
            
            if(lstflMsg.size()>0){
                if(isRead){
                    lstflMsg[0].IsRead__c = isRead; 
                }
                
                update lstflMsg; 
                return true; 
            }
            return false;
            
        } catch(exception ex) {
            System.debug(TEAMNAME+ex.getMessage()+LINENUMBER+ex.getLineNumber());
            return false; 
        } 
    }
    
    //Change the message status when replying to an existing message thread
    //Author: Sameera De Silva(ACDC)
    public static Boolean changeStatusForReply(String directMessageFeedId){
        
        List<SNI_FL_Message_Status__c> lstMessageStatusRecords = new List<SNI_FL_Message_Status__c>();
        
        try{
            
            for(SNI_FL_Message_Status__c messageStatus:[SELECT Id, IsRead__c, Agent__c FROM SNI_FL_Message_Status__c WHERE SNI_FL_Message__r.Feed_Id__c = :directMessageFeedId]){
                
                if(messageStatus.Agent__c == UserInfo.getUserId()){
                    
                    if(!messageStatus.IsRead__c){
                        messageStatus.IsRead__c = true;
                        lstMessageStatusRecords.add(messageStatus);
                    }
                    
                }else if(messageStatus.IsRead__c){
                    messageStatus.IsRead__c = false;
                    lstMessageStatusRecords.add(messageStatus);
                }
            }
            
            update(lstMessageStatusRecords);
            return true;
            
        }catch(Exception ex){
            System.debug(TEAMNAME+ex.getMessage()+'Method Name (changeStatusForReply) - Line '+ex.getLineNumber()); 
            return false;
        }
    }        
    
    
    public static List <SNI_FL_BackupAdvisor__c> getBackUpAdvisors(){
        
        try{
            List <SNI_FL_BackupAdvisor__c> lstBackUpAdvisor = [select Id,Advisor__r.Name,Advisor__c,Backup_Advisor__c from SNI_FL_BackupAdvisor__c where Backup_Advisor__c =: UserInfo.getUserId() limit 10];
            return lstBackUpAdvisor;
        }catch(Exception ex){
            System.debug(TEAMNAME+ex.getMessage()+LINENUMBER+ex.getLineNumber());
            return null;
        }
    }
    
    public static void saveBkUpAdvisors(string strBackUpAdvisor, List<string> selectedPills){
        
        if(!selectedPills.IsEmpty()){ 
            try {
                SNI_FL_BackupAdvisor__c[] SNPBackAdvisior = [SELECT Id, Advisor__c FROM SNI_FL_BackupAdvisor__c WHERE Id IN:selectedPills ]; 
                delete SNPBackAdvisior;
            } catch (DmlException ex) {
                System.debug(TEAMNAME+ex.getMessage()+LINENUMBER+ex.getLineNumber());
            }
        }
        try{
            List<SNI_FLDirectMessageWrapper.SNI_FL_BackupAdvisorWrap> wrapObj = (List<SNI_FLDirectMessageWrapper.SNI_FL_BackupAdvisorWrap>) JSON.deserialize(strBackUpAdvisor, List<SNI_FLDirectMessageWrapper.SNI_FL_BackupAdvisorWrap>.class);
            List <SNI_FL_BackupAdvisor__c> lstBackupAdvisors = new List <SNI_FL_BackupAdvisor__c> ();
            SNI_FL_BackupAdvisor__c objBackUpAdvisor;
            for(SNI_FLDirectMessageWrapper.SNI_FL_BackupAdvisorWrap objusers : wrapObj){
                objBackUpAdvisor = new SNI_FL_BackupAdvisor__c();
                objBackUpAdvisor.Id = objusers.ExistingId;
                objBackUpAdvisor.Advisor__c = objusers.Advisor;
                objBackUpAdvisor.Backup_Advisor__c = UserInfo.getUserId();
                lstBackupAdvisors.add(objBackUpAdvisor);
            }
            if(!lstBackupAdvisors.IsEmpty()){
                
                upsert lstBackupAdvisors;
            }
        }catch(Exception ex){
            System.debug(TEAMNAME+ex.getMessage()+LINENUMBER+ex.getLineNumber());
            
        }
    } 
    
    public static Boolean checkManageProviderGroupUserId(){ 
        try{
            List<PermissionSetAssignment> lstcurrentUserPerSet = [SELECT Id, PermissionSet.Name,PermissionSet.label,AssigneeId
                                                                  FROM PermissionSetAssignment  WHERE AssigneeId = :Userinfo.getUserId() 
                                                                  AND PermissionSet.label =:system.label.SNI_FL_ManageProviderGroup 
                                                                  limit 1];
            if(!lstcurrentUserPerSet.isEmpty()){
                return true;
            }else{
                return false;
            }
        }catch(exception ex){
            return false;
        }
    }

    public static SNI_FLDirectMessageWrapper.UserPermissionSet getUserProfilePermissionSet(){
        SNI_FLDirectMessageWrapper.UserPermissionSet userPermision = new SNI_FLDirectMessageWrapper.UserPermissionSet();
        try{
            userPermision.PermissionSet = [SELECT Id, PermissionSet.Name,PermissionSet.label,AssigneeId FROM
                                           PermissionSetAssignment  WHERE AssigneeId = :Userinfo.getUserId() limit 200];

            userPermision.userObj = [SELECT Id, Name,ProfileId,Profile.Name,UserRoleId,UserRole.Name,Username from User WHERE Id = : Userinfo.getUserId()];
            return userPermision;
        }catch(exception ex){
            return userPermision;
        }
    }

    public static Boolean checkProfileValidityForUserId(){
        try{
            Boolean isValidProfile = false;
            Boolean isValidFLPermisionSet = false;
            Boolean isValidProviderPermisionSet = false;
            Boolean isValid3WayCommunicationPermisionSet = false;

            set<string> setPermissionsets = new set<string>();

            List<PermissionSetAssignment> flPermission = [SELECT Id, PermissionSet.Name,PermissionSet.label,AssigneeId FROM PermissionSetAssignment  WHERE AssigneeId = :Userinfo.getUserId() AND PermissionSet.label =:system.label.SNI_FL_FamilyLinkPermission limit 1];

            if(!flPermission.isEmpty()){
                isValidFLPermisionSet = true;
            }

            List<PermissionSetAssignment> providerPermission = [SELECT Id, PermissionSet.Name,PermissionSet.label,AssigneeId FROM PermissionSetAssignment  WHERE AssigneeId = :Userinfo.getUserId() AND PermissionSet.label =:system.label.SNI_FL_ProviderMessagingPermission limit 1];

            if(!providerPermission.isEmpty()){
                isValidProviderPermisionSet = true;
            }

            List<PermissionSetAssignment> threewayCommunicationPermission = [SELECT Id, PermissionSet.Name,PermissionSet.label,AssigneeId FROM PermissionSetAssignment  WHERE AssigneeId = :Userinfo.getUserId() AND PermissionSet.label =:system.label.SNI_FL_3WayCommunication limit 1];

            if(!threewayCommunicationPermission.isEmpty()){
                isValid3WayCommunicationPermisionSet = true;
            }

            User userDetail = [SELECT Profile.Name,UserRole.Name FROM User where Id= :userinfo.getUserId()];

            if(isValidFLPermisionSet){
                system.debug('check1');
                if(userDetail.Profile.Name.contains('Read Only') && userDetail.Profile.Name != FECREADONLYPROFILE){
                    isValidProfile = false;
                } else if(userDetail.UserRole.Name.contains('FEC') || userDetail.UserRole.Name.contains(SYSADMINPROFILE) || userDetail.UserRole.Name.contains('Non-Clinical Supervisor') || userDetail.UserRole.Name.contains('Clinical Manager') || userDetail.UserRole.Name.contains('Care Advisor') || userDetail.UserRole.Name.contains('Research Advisor') || userDetail.UserRole.Name.contains('Nurse Advisor') || userDetail.UserRole.Name.contains('Wellness and Community Coach') || userDetail.UserRole.Name.contains('Behavioral Health Advisor') || userDetail.UserRole.Name.contains('Pharmacist') || userDetail.UserRole.Name.contains('Women\'s Health Nurse Advisor')){
                    isValidProfile = true;
                } else {
                    isValidProfile = false;
                }
            } else if(isValidProviderPermisionSet){
                system.debug('check2');
                if(userDetail.Profile.Name.contains('Read Only') && userDetail.Profile.Name != FECREADONLYPROFILE){
                    isValidProfile = false;
                } else if(userDetail.UserRole.Name.contains('FEC') || userDetail.UserRole.Name.contains(SYSADMINPROFILE)|| userDetail.UserRole.Name.contains('Non-Clinical Supervisor') || userDetail.UserRole.Name.contains('Clinical Manager') || userDetail.UserRole.Name.contains('Care Advisor') || userDetail.UserRole.Name.contains('Research Advisor') ||  userDetail.UserRole.Name.contains('Nurse Advisor') || userDetail.UserRole.Name.contains('Wellness and Community Coach') ||  userDetail.UserRole.Name.contains('Behavioral Health Advisor') || userDetail.UserRole.Name.contains('Pharmacist') || userDetail.UserRole.Name.contains('Women\'s Health Nurse Advisor')){
                    isValidProfile = true;
                } else {
                    isValidProfile = false;
                }
            } else if(isValid3WayCommunicationPermisionSet){
                system.debug('check3');
                if(userDetail.Profile.Name.contains('Read Only') && userDetail.Profile.Name != FECREADONLYPROFILE){
                    isValidProfile = false;
                } else if(userDetail.UserRole.Name.contains('Nurse Advisor') || userDetail.UserRole.Name.contains('Non-Clinical Supervisor') || userDetail.UserRole.Name.contains('Clinical Manager') || userDetail.UserRole.Name.contains('Wellness and Community Coach') || userDetail.UserRole.Name.contains('Care Advisor') ||  userDetail.UserRole.Name.contains('Behavioral Health Advisor') || userDetail.UserRole.Name.contains('Pharmacist') || userDetail.UserRole.Name.contains('Research Advisor') || userDetail.UserRole.Name.contains('Women\'s Health Nurse Advisor')){
                    isValidProfile = true;
                } else {
                    isValidProfile = false;
                }
            } else {
                isValidProfile = false;
            }

            return isValidProfile;
        }catch(exception ex) {
            System.debug(TEAMNAME+ex.getMessage()+LINENUMBER+ex.getLineNumber());
            return false;
        }
    }
    
    public static List < sObject > fetchLookUpValuesForBackupAdvisors(String searchKeyWord, String objectName, List<sObject> excludeitemsList, String profileName) {
        
        try{
            String searchKey = '%' + searchKeyWord + '%';
            List < sObject > returnList = new List < sObject > ();
            List<String> lstExcludeitems = new List<String>();
            if(excludeitemsList != null){
                for(sObject item : excludeitemsList ){
                    if(item.getSObjectType() == SNI_FL_BackupAdvisor__c.sObjectType){
                        SNI_FL_BackupAdvisor__c backup =  (SNI_FL_BackupAdvisor__c)item; 
                        lstExcludeitems.add('\''+ backup.Name + '\'');  
                    }
                }
            }

            List<PermissionSetAssignment> flPermission = [SELECT Id FROM PermissionSetAssignment WHERE AssigneeId = :userinfo.getUserId() AND PermissionSet.label =:system.label.SNI_FL_3WayCommunication LIMIT 1];
            
            String loggedUserId = [SELECT Id FROM User where Id= :userinfo.getUserId() ].Id;
            // Create a Dynamic SOQL Query For Fetch Record List with LIMIT 5 and exclude already selected records  
            String supervisorRole = 'Non-Clinical Supervisor%';
            String advisorRole = '%Care Advisor%';
            String registeredNurse = 'Registered Nurse%';
            String pharmacist = 'Pharmacist%';
            String lifestyleCoach = 'Wellness and Community Coach%';
            String behavioralSpeacialist = 'Behavioral Health Advisor%';
            String qbNurse = 'Nurse Advisor%';
            String researchAdvisor = 'Research Advisor%';
            String womenHealthNurse = 'Women\'s Health Nurse Advisor%';
            String labell = system.label.SNI_FL_3WayCommunication;
            
            if(searchKeyWord.length() > 2)
            {
                if(profileName.contains('Non-Clinical Supervisor')){
                    String sQuery =  'select id, Name  from ' +objectName + ' where (UserRole.Name LIKE :supervisorRole OR UserRole.Name LIKE :advisorRole)  AND Name LIKE: searchKey  AND Name NOT IN : lstExcludeitems AND ID != :loggedUserId order by Name ASC ';            
                    List < sObject > lstOfRecords = Database.query(sQuery);
                    for (sObject obj: lstOfRecords) {
                        returnList.add(obj);
                    }
                }
                else if(profileName.contains('Care Advisor')){
                    String sQuery =  'select id, Name  from ' +objectName + ' where UserRole.Name LIKE :advisorRole AND Name LIKE: searchKey  AND Name NOT IN : lstExcludeitems AND ID != :loggedUserId  order by Name ASC ';
                    List < sObject > lstOfRecords = Database.query(sQuery);
                    for (sObject obj: lstOfRecords) {
                        returnList.add(obj);
                    }
                }
                else if(profileName.contains(SYSADMINPROFILE)){
                    String sQuery =  'select id, Name  from ' +objectName + ' where (UserRole.Name LIKE :supervisorRole OR UserRole.Name LIKE :advisorRole)  AND Name LIKE: searchKey  AND Name NOT IN :lstExcludeitems AND ID != :loggedUserId order by Name ASC ';    
                    List < User > lstOfRecords = Database.query(sQuery);
                    for (User obj: lstOfRecords) {
                        returnList.add(obj);
                    }
                } 
                //added else if for US3233248,US3232170 sameera
                else if(profileName.contains('Research Advisor')){

                    Set<String> users = getUsers(profileName);

                    String sQuery =  'select id, Name  from ' +objectName + ' where UserRole.Name LIKE :researchAdvisor AND Id IN :users AND Name LIKE: searchKey AND Name NOT IN :lstExcludeitems AND ID != :loggedUserId order by Name ASC ';    
                    List < User > lstOfRecords = Database.query(sQuery);
                    for (User obj: lstOfRecords) {
                        returnList.add(obj);
                    }
                }
                //added else if for US3396962 Nanthu
                else if(profileName.contains('Registered Nurse')){
                    if(!flPermission.isEmpty()){
                        String sQuery =  'select id, Name  from ' +objectName + ' where UserRole.Name LIKE :registeredNurse AND Name LIKE: searchKey AND Name NOT IN :lstExcludeitems AND ID != :loggedUserId order by Name ASC ';    
                        List < User > lstOfRecords = Database.query(sQuery);

                        List<PermissionSetAssignment> lstUserPermissionSet = [SELECT Id,AssigneeId FROM PermissionSetAssignment WHERE AssigneeId IN  :lstOfRecords AND PermissionSet.label =:system.label.SNI_FL_3WayCommunication];
                        Set<Id> userIds = new Set<Id>();
                        for(PermissionSetAssignment pr : lstUserPermissionSet){
                            userIds.add(pr.AssigneeId);
                        }

                        for (User obj: lstOfRecords) {
                            if(userIds.contains(obj.Id)){
                                returnList.add(obj);
                            }
                        }
                    } else {
                        Set<String> users = getUsers(profileName);

                        String sQuery =  'select id, Name  from ' +objectName + ' where UserRole.Name LIKE :registeredNurse AND Id IN :users AND Name LIKE: searchKey AND Name NOT IN :lstExcludeitems AND ID != :loggedUserId order by Name ASC ';    
                        List < User > lstOfRecords = Database.query(sQuery);
                        for (User obj: lstOfRecords) {
                            returnList.add(obj);
                        }
                    }
                }
                //added else if for US3396962 Nanthu
                else if(profileName.contains('Behavioral Health Advisor') || profileName.contains('Nurse Advisor') || profileName.contains('Wellness and Community Coach') || profileName.contains('Pharmacist') || profileName.contains('Women\'s Health Nurse Advisor')){
                    if(!flPermission.isEmpty()){
                        String sQuery =  'select id, Name  from ' +objectName + ' where (UserRole.Name LIKE :pharmacist OR UserRole.Name LIKE :lifestyleCoach OR UserRole.Name LIKE :behavioralSpeacialist OR UserRole.Name LIKE :qbNurse OR UserRole.Name LIKE :womenHealthNurse) AND Name LIKE: searchKey AND Name NOT IN :lstExcludeitems AND ID != :loggedUserId order by Name ASC ';    
                        List < User > lstOfRecords = Database.query(sQuery);

                        List<PermissionSetAssignment> lstUserPermissionSet = [SELECT Id,AssigneeId FROM PermissionSetAssignment WHERE AssigneeId IN  :lstOfRecords AND PermissionSet.label =:system.label.SNI_FL_3WayCommunication];
                        Set<Id> userIds = new Set<Id>();
                        for(PermissionSetAssignment pr : lstUserPermissionSet){
                            userIds.add(pr.AssigneeId);
                        }

                        for (User obj: lstOfRecords) {
                            if(userIds.contains(obj.Id)){
                                returnList.add(obj);
                            }
                        }
                    }
                }
            }
            else{
                if(profileName.contains('Non-Clinical Supervisor')){
                    String sQuery =  'select id, Name  from ' +objectName + ' where (UserRole.Name LIKE :supervisorRole OR UserRole.Name LIKE :advisorRole) AND Name NOT IN : lstExcludeitems AND ID != :loggedUserId order by Name ASC';            
                    List < sObject > lstOfRecords = Database.query(sQuery);
                    for (sObject obj: lstOfRecords) {
                        returnList.add(obj);
                    }
                }
                else if(profileName.contains('Care Advisor')){
                    String sQuery =  'select id, Name  from ' +objectName + ' where UserRole.Name LIKE :advisorRole AND Name NOT IN : lstExcludeitems AND ID != :loggedUserId  order by Name ASC';
                    List < sObject > lstOfRecords = Database.query(sQuery);
                    for (sObject obj: lstOfRecords) {
                        returnList.add(obj);
                    }
                }
                else if(profileName.contains(SYSADMINPROFILE)){
                    String sQuery =  'select id, Name  from ' +objectName + ' where (UserRole.Name LIKE :supervisorRole OR UserRole.Name LIKE :advisorRole)    AND Name NOT IN :lstExcludeitems AND ID != :loggedUserId order by Name ASC ';    
                    List < User > lstOfRecords = Database.query(sQuery);
                    for (User obj: lstOfRecords) {
                        returnList.add(obj);
                    }
                } 
                //added else if for US3233248,US3232170 sameera
                else if(profileName.contains('Research Advisor')){

                    Set<String> users = getUsers(profileName);

                    String sQuery =  'select id, Name  from ' +objectName + ' where UserRole.Name LIKE :researchAdvisor AND Id IN :users AND Name NOT IN :lstExcludeitems AND ID != :loggedUserId order by Name ASC ';    
                    List < User > lstOfRecords = Database.query(sQuery);
                    for (User obj: lstOfRecords) {
                        returnList.add(obj);
                    }
                }
                //added else if for US3396962 Nanthu
                else if(profileName.contains('Registered Nurse')){
                    if(!flPermission.isEmpty()){
                        String sQuery =  'select id, Name  from ' +objectName + ' where UserRole.Name LIKE :registeredNurse AND Name NOT IN :lstExcludeitems AND ID != :loggedUserId order by Name ASC ';    
                        List < User > lstOfRecords = Database.query(sQuery);

                        List<PermissionSetAssignment> lstUserPermissionSet = [SELECT Id,AssigneeId FROM PermissionSetAssignment WHERE AssigneeId IN  :lstOfRecords AND PermissionSet.label =:system.label.SNI_FL_3WayCommunication];
                        Set<Id> userIds = new Set<Id>();
                        for(PermissionSetAssignment pr : lstUserPermissionSet){
                            userIds.add(pr.AssigneeId);
                        }

                        for (User obj: lstOfRecords) {
                            if(userIds.contains(obj.Id)){
                                returnList.add(obj);
                            }
                        }
                    } else {
                        Set<String> users = getUsers(profileName);

                        String sQuery =  'select id, Name  from ' +objectName + ' where UserRole.Name LIKE :registeredNurse AND Id IN :users AND Name NOT IN :lstExcludeitems AND ID != :loggedUserId order by Name ASC ';    
                        List < User > lstOfRecords = Database.query(sQuery);
                        
                        for (User obj: lstOfRecords) {
                            returnList.add(obj);
                        }
                    }
                }
                //added else if for US3396962 Nanthu
                else if(profileName.contains('Behavioral Health Advisor') || profileName.contains('Nurse Advisor') || profileName.contains('Wellness and Community Coach') || profileName.contains('Pharmacist') || profileName.contains('Women\'s Health Nurse Advisor')){
                    if(!flPermission.isEmpty()){
                        String sQuery =  'select id, Name  from ' +objectName + ' where (UserRole.Name LIKE :pharmacist OR UserRole.Name LIKE :lifestyleCoach OR UserRole.Name LIKE :behavioralSpeacialist OR UserRole.Name LIKE :qbNurse OR UserRole.Name LIKE :womenHealthNurse) AND Name NOT IN :lstExcludeitems AND ID != :loggedUserId order by Name ASC ';    
                        List < User > lstOfRecords = Database.query(sQuery);

                        List<PermissionSetAssignment> lstUserPermissionSet = [SELECT Id,AssigneeId FROM PermissionSetAssignment WHERE AssigneeId IN  :lstOfRecords AND PermissionSet.label =:system.label.SNI_FL_3WayCommunication];
                        Set<Id> userIds = new Set<Id>();
                        for(PermissionSetAssignment pr : lstUserPermissionSet){
                            userIds.add(pr.AssigneeId);
                        }

                        for (User obj: lstOfRecords) {
                            if(userIds.contains(obj.Id)){
                                returnList.add(obj);
                            }
                        }
                    }
                }
            }
            return returnList;
        }catch(Exception ex){
            System.debug(TEAMNAME+ex.getMessage()+LINENUMBER+ex.getLineNumber());
            return null;
        }
        
    }

    /**
     * @description retrive Registered Nurse users or Research Advisors
     * US3233248,US3232170
     * sameera
     * @param userRole 
     * @return  `Set<String>`
     */    
    private static set<String> getUsers(String userRole){

        try{
            
            String role = userRole.contains('-')?userRole.substringBefore('-').substringBefore(' '):userRole;
            
            Id recordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName().get('Provider_Affiliation').getRecordTypeId();
            Set<String> affliations = new Set<String>();
            Set<String> users = new Set<String>();
                        
            for(AccountTeamMember accountTeam:[SELECT AccountId FROM AccountTeamMember where Account.RecordTypeId=:recordTypeId AND UserId=:UserInfo.getUserId()]){
                affliations.add(accountTeam.AccountId);
            }
            
            for(AccountTeamMember accountTeam:[SELECT UserId FROM AccountTeamMember where AccountId IN :affliations AND User.UserRole.Name like :role+'%' AND UserId !=:UserInfo.getUserId()]){
                users.add(accountTeam.UserId);
            }
            
            return users;
        }
        catch(Exception ex){
            System.debug(TEAMNAME+ex.getMessage()+LINENUMBER+ex.getLineNumber());
            return null;
        }

    }
    
    public static Map<String,String> getAccountNameByID(String accountID){
        Map<String,String> name = new Map<String,String>();
        try{
            List<Account> accountName =[select Id, Name, OwnerId from Account where Id = :accountID];
            if(accountName!=null && accountName.size()>0){
                name.put('AccName',accountName[0].Name);
                name.put('AccOwner',accountName[0].OwnerId);
            }
            return name;
        }catch(Exception ex){
            System.debug(TEAMNAME+ex.getMessage()+LINENUMBER+ex.getLineNumber());
            return null;
        }
    }
    
    public static SNI_FLDirectMessageWrapper.wrapperAccPermission getAccountNameByID1(String accountID){
        SNI_FLDirectMessageWrapper.wrapperAccPermission obj= new SNI_FLDirectMessageWrapper.wrapperAccPermission();
        try{
            List<string> lstPermission = new List<string>();
            List<PermissionSetAssignment> lstcurrentUserPerSet = [SELECT Id, PermissionSet.Name,PermissionSet.label,AssigneeId
                                                                  FROM PermissionSetAssignment  WHERE AssigneeId = :Userinfo.getUserId() 
                                                                  AND (PermissionSet.label =:system.label.SNI_FL_FamilyLinkPermission 
                                                                       OR PermissionSet.label =: system.label.SNI_FL_ProviderMessagingPermission)
                                                                  ];
            List<Account> accountName =[select Id,name from Account where Id = :accountID ];
            if(accountName!=null && accountName.size()>0){
                obj.strName = accountName[0]?.name!=null?accountName[0]?.name:'';
            }
            if(lstcurrentUserPerSet!=null && lstcurrentUserPerSet.size()>0){
                for(PermissionSetAssignment objAssignment: lstcurrentUserPerSet){
                    lstPermission.add(objAssignment.PermissionSet.label); 
                    //.add(objAssignment.PermissionSet.label); 
                }
                obj.setPermissionSet = lstPermission;
                //obj.PermissionSet = lstcurrentUserPerSet[0].PermissionSet.label;
            }
            system.debug('Testing Wrappper'+obj);
            return obj;
        }catch(Exception ex){
            System.debug(TEAMNAME+ex.getMessage()+LINENUMBER+ex.getLineNumber());
            return null;
        }
        
    }
    
    public static String getAccountNameByUser(){
        String name;
        
        try{
            List<Account> accountName =[select Id,name from Account where OwnerId = :UserInfo.getUserId() ];
            if(accountName!=null && accountName.size()>0){
                name = accountName[0].name;
            }
            return name;            
        }catch(Exception ex){
            System.debug(TEAMNAME+ex.getMessage()+LINENUMBER+ex.getLineNumber());
            return null;
        }
        
    }

    public static String getProfileNameForLoggedUser(){
        Boolean isValidProfile;
        
        try{
            String roleName=[Select UserRole.Name from User where Id= :userinfo.getUserId() ].UserRole.Name;
            
            return roleName;
        }catch(Exception ex){
            System.debug(TEAMNAME+ex.getMessage()+LINENUMBER+ex.getLineNumber());
            return null; 
        }
        
    }
    
    //Retrieving comments for each message thread when user scroll down. At a time 10 comments
    //will be retrieved including attachments
    //Author: Sameera De Silva (ACDC)
    @AuraEnabled
    public static List<SNI_FLDirectMessageWrapper.SNI_FL_DirectMessageFeedComments> getFeedCommentsForLazyLoading(String feedID,Integer pageNumber,Integer pageSize){
        
        Integer pSize = (Integer)pageSize;
        Integer pNumber = (Integer)pageNumber;
        Integer offset = (pNumber - 1) * pSize;
        
        try{
            
            DirectMessageFeed feed= [SELECT Id,Parent.Id, Parent.Subject,Body,LastModifiedDate,CreatedDate,CreatedById, ParentId FROM DirectMessageFeed WHERE Id =:feedID  LIMIT 1];
            List<FeedComment> lstFeedComments = [SELECT Id,CreatedById,RelatedRecordId,CreatedDate,CommentBody,FeedItemId FROM FeedComment WHERE  FeedItemId =:feedID  ORDER BY CreatedDate DESC LIMIT :pSize OFFSET :offset];
            Map<ID,ContentVersion> attachments = getContentDocumentData(lstFeedComments);
            Map<ID,ContentDistribution> contentDistributions = getContentDistribution(lstFeedComments);
            Map<Id,User> users = getUserdetails();
            List<SNI_FLDirectMessageWrapper.SNI_FL_DirectMessageFeedComments> lstFeeedComment = new List<SNI_FLDirectMessageWrapper.SNI_FL_DirectMessageFeedComments>();
            
            if((lstFeedComments != NULL) || (!lstFeedComments.isEmpty())){
                
                
                for(FeedComment comment:lstFeedComments){
                    String userRole = '';
                    User commentedUser = users.get(comment.CreatedById);
                    ContentVersion version = attachments.get(comment.id);
                    ContentDistribution distribution = contentDistributions.get(comment.id);
                    if(commentedUser.userRole.name.contains('FEC')){userRole = system.Label.FEC;}  //$Label.c.FEC
                    if(commentedUser.userRole.name.contains('Registered Nurse')){userRole = System.Label.Registered_Nurse;}
                    if(commentedUser.userRole.name.contains('Wellness and Community Coach')){userRole = 'Wellness and Community Coach';}
                    if(commentedUser.userRole.name.contains('Nurse Advisor')){userRole = 'Nurse Advisor';}
                    if(commentedUser.userRole.name.contains('Behavioral Health Advisor')){userRole = 'Behavioral Health Advisor';}
                    if(commentedUser.userRole.name.contains('Pharmacist')){userRole = 'Pharmacist';}
                    if(commentedUser.userRole.name.contains('Care Advisor')){userRole = 'Care Advisor';}
                    if(commentedUser.userRole.name.contains('Clinical Manager')){userRole = 'Clinical Manager';}
                    if(commentedUser.userRole.name.contains('Research Advisor')){userRole = 'Research Advisor';}
                    if(commentedUser.userRole.name.contains('Non-Clinical Supervisor')){userRole = 'Non-Clinical Supervisor';}
                    if(commentedUser.userRole.name.contains('Women\'s Health Nurse Advisor')){userRole = 'Women\'s Health Nurse Advisor';}
                    if(version !=NULL){
                        lstFeeedComment.add(new SNI_FLDirectMessageWrapper.SNI_FL_DirectMessageFeedComments(comment.CommentBody,new SNI_FLDirectMessageWrapper.SNI_FLUserDetails(commentedUser.FirstName,commentedUser.LastName,commentedUser.Id,commentedUser.Profile.Name,userRole),comment.CreatedDate,
                                                                                                            version.ContentDocument.LatestPublishedVersionId,version.ContentDocument.FileExtension,version.ContentDocument.Title,true,distribution.ContentDownloadUrl));
                    }else{
                        lstFeeedComment.add(new SNI_FLDirectMessageWrapper.SNI_FL_DirectMessageFeedComments(comment.CommentBody,new SNI_FLDirectMessageWrapper.SNI_FLUserDetails(commentedUser.FirstName,commentedUser.LastName,commentedUser.Id,commentedUser.Profile.Name,userRole),comment.CreatedDate,
                                                                                                            null,null,null,false,null));
                    }
                    
                }
                return lstFeeedComment; 
            }
            return null;
            
        }catch(Exception ex){
            System.debug(TEAMNAME+ex.getMessage()+LINENUMBER+ex.getLineNumber());
            return null;
        }
    }
    
    //Retrieve user records using a map structure. User id and each 
    //user record is retriving 
    //Author: Sameera De Silva (ACDC)
    public static Map<Id,User> getUserdetails(){
        
        try{
            
            Map<ID,User> lstOfUser = new Map<ID,User>([SELECT ID,FirstName,LastName,Profile.Name,userrole.name FROM User]);
            
            return lstOfUser;
            
            
        }catch(Exception ex){
            System.debug(TEAMNAME+ex.getMessage()+LINENUMBER+ex.getLineNumber());
            return null;
        }
    }
    
    //Retrieve a map of contentdocument records with comment id and contentdocument record
    //Author: Sameera De Silva (ACDC)
    public static Map<ID,ContentVersion> getContentDocumentData(List<FeedComment> lstOfComments){
        Map<ID,ContentVersion> commentIdsWithContent = new Map<ID,ContentVersion>();
        Set<ID> relatedRecords = new Set<ID>();
        Map<ID,ContentVersion> contentVersion = new Map<Id,ContentVersion>();
        try{
            for(FeedComment comment:lstOfComments){
                if(comment.RelatedRecordId != NULL){
                    relatedRecords.add(comment.RelatedRecordId);
                }
            }
            List<ContentVersion> lstOfContentVersions = [SELECT ID,ContentDocument.Title,ContentDocument.FileExtension,ContentDocument.LatestPublishedVersionId FROM ContentVersion WHERE Id IN :relatedRecords ];
            for(ContentVersion version:lstOfContentVersions){
                contentVersion.put(version.Id,version);
            }
            for(FeedComment comment:lstOfComments){
                if(comment.RelatedRecordId != NULL){
                    commentIdsWithContent.put(comment.Id,contentVersion.get(comment.RelatedRecordId));
                }
            }
            return commentIdsWithContent;
        }catch(Exception ex){
            System.debug(TEAMNAME+ex.getMessage()+LINENUMBER+ex.getLineNumber());
            return null;
        }            
    }
    
    //Retrieve ContentDistribution records for each comment. A map data structure will be created with comment ids 
    //and each content distribution record 
    //Author: Sameera De Silva(ACDC)
    public static Map<ID,ContentDistribution> getContentDistribution(List<FeedComment> lstOfComments){
        
        Map<ID,ContentDistribution> commentIdsWithContentDistribution = new Map<ID,ContentDistribution>();
        Set<ID> relatedRecords = new Set<ID>();
        Map<ID,ContentDistribution> contentdistribution = new Map<Id,ContentDistribution>();
        
        try{
            
            for(FeedComment comment:lstOfComments){
                if(comment.RelatedRecordId != NULL){
                    relatedRecords.add(comment.RelatedRecordId);
                }
            }
            
            List<ContentDistribution> lstOfContentDistribution = [SELECT Id, ContentVersionId, ContentDownloadUrl FROM ContentDistribution WHERE ContentVersionId IN :relatedRecords ];
            
            for(ContentDistribution distribution:lstOfContentDistribution){
                contentdistribution.put(distribution.ContentVersionId,distribution);
            }
            
            for(FeedComment comment:lstOfComments){
                if(comment.RelatedRecordId != NULL){
                    commentIdsWithContentDistribution.put(comment.Id,contentdistribution.get(comment.RelatedRecordId));
                }
            }
            
            return commentIdsWithContentDistribution;
        }catch(Exception ex){
            System.debug(TEAMNAME+ex.getMessage()+LINENUMBER+ex.getLineNumber());
            return null;
        }
    }
    
    public static Boolean checkUnregisteredMemberByUserId(String accountId ){ 
        try{
            Boolean isValidProfile = false;
            List<SNI_FL_Care_Team_Member__c> registerStatus =[SELECT SNI_FL_Status__c FROM SNI_FL_Care_Team_Member__c Where SNI_FL_Family__c =:accountId AND SNI_FL_Registered_Date__c != null AND SNI_FL_Status__c = 'Registered' ];
            if(!registerStatus.isEmpty()){                    
                isValidProfile = true;
            }else{
                isValidProfile = false;
            }         
            return isValidProfile;
        }catch(exception ex) {
            System.debug(TEAMNAME+ex.getMessage()+LINENUMBER+ex.getLineNumber());
            return false; 
        } 
    }
    
    //Update each message status record related with feedId.
    //When initiating a message loged in user status record will be set Read Status=true and other
    //list of "to" users will be set to Read Status=false
    //Author: Sameera De Silva(ACDC)
    public static void updateMessageStatus(String feedID){
        List<SNI_FL_Message_Status__c> lstMsgStatus = new List<SNI_FL_Message_Status__c>();
        lstMsgStatus.clear();
        try{
            for(SNI_FL_Message__c flMsg : [SELECT Id,(SELECT Id,IsRead__c,Agent__c FROM SNI_FL_Message_Statuses__r) FROM SNI_FL_Message__c  WHERE Feed_Id__c =:feedID]){
                for(SNI_FL_Message_Status__c msgStatus:flMsg.SNI_FL_Message_Statuses__r){
                    if(msgStatus.Agent__c == userinfo.getUserId()){
                        msgStatus.IsRead__c = true;
                    }else{
                        msgStatus.IsRead__c = false;
                    }
                    lstMsgStatus.add(msgStatus);
                }
            }
            if(lstMsgStatus.isEmpty()){ return ; }
            update lstMsgStatus;
        }catch(Exception ex){
            System.debug(TEAMNAME+ex.getMessage()+LINENUMBER+ex.getLineNumber());
            return;
        }
    }
    
    //Create ContentDistribution record to get the external sharable link
    //for community user.Before creating new ContentDistribution record checking 
    //whether record already existing too.
    //Author: Sameera De Silva (ACDC)
    @future
    public static void createContentDistribution(String documentID){
        try{
            List<ContentDistribution> distributionRecord = [SELECT ID,PreferencesPasswordRequired FROM ContentDistribution WHERE ContentDocumentId=:documentID  LIMIT 1];
            if(!distributionRecord.isEmpty() && distributionRecord[0].PreferencesPasswordRequired ==true){
                distributionRecord[0].PreferencesPasswordRequired = false;
                update distributionRecord;
            }else{
                ContentVersion versionRecord = [SELECT ID,ContentDocument.Title FROM ContentVersion WHERE ContentDocumentId =:documentID ];
                
                ContentDistribution objContentDistribution = new ContentDistribution();
                objContentDistribution.Name = versionRecord.ContentDocument.Title;
                objContentDistribution.ContentVersionId = versionRecord.ID;
                objContentDistribution.PreferencesAllowOriginalDownload  = true;
                objContentDistribution.PreferencesLinkLatestVersion = true;
                objContentDistribution.PreferencesNotifyOnVisit = false;
                objContentDistribution.PreferencesAllowViewInBrowser = true;
                
                insert objContentDistribution;
                
                ContentDistribution distribution = [SELECT PreferencesPasswordRequired FROM ContentDistribution WHERE Id =:objContentDistribution.id ];
                distribution.PreferencesPasswordRequired = false;
                
                update distribution;
            }
        }catch(Exception ex){
            System.debug(TEAMNAME+ex.getMessage()+LINENUMBER+ex.getLineNumber());
            return;
        }
    }
    
    //Author: Pavithra Fernando ACDC
    //Backend logic to insert data into the SNI_FL_Message_Notification__c when triggering the SNI_FL_InsertMessageNotificationTrigger
    public static void insertMessageNotification(List<FeedComment> lstFeeds){
        
        try{
            List<SNI_FL_Message_Notification__c> msgNotification =new List<SNI_FL_Message_Notification__c>();    
            String feedId;
            for(FeedComment fc :lstFeeds){
                feedId = fc.ParentId;
            }
            List<DirectMessageMember> dm = [SELECT Id,DirectMessageId, MemberId FROM DirectMessageMember WHERE DirectMessageId = :feedId ];
            String recipientId;
            for(DirectMessageMember dmm : dm){
                SNI_FL_Message_Notification__c mn = new SNI_FL_Message_Notification__c();
                recipientId = dmm.MemberId;
                mn.RecipientId__c = recipientId;
                
                for(FeedComment fc :lstFeeds){
                    mn.Name = fc.Id;
                    mn.FeedCommentId__c = fc.Id;
                    mn.FeedId__c = fc.ParentId;
                    mn.MessageDate__c = fc.CreatedDate;       
                    mn.SenderId__c = fc.CreatedById;
                    mn.IsViewed__c = false;
                    msgNotification.add(mn);
                }
            }
            
            insert msgNotification;
            
        }catch(Exception ex){
            System.debug(TEAMNAME+ex.getMessage()+LINENUMBER+ex.getLineNumber());
            return;
        }
        
    }
    
    //Check the validity of users with UHG Restriction and UHG Access
    //Author:Pavithra (ACDC)
    public static Boolean checkUHGRestrictionForUserId(String accountId){  
        try{
            Boolean isValidAccess;
            
            String uhgAccess = [SELECT UHG_Access__c FROM User where Id= :userinfo.getUserId() ].UHG_Access__c;
            String uhgRestriction = [SELECT UHG_Restriction__c FROM Account where Id= :accountId  limit 1].UHG_Restriction__c;
            system.debug('uhgRestriction'+uhgRestriction);
            system.debug('uhgAccess'+uhgAccess);
            if(uhgRestriction == 'Yes') 
            {
                if(uhgAccess == 'Yes'){
                    isValidAccess = true;
                }else{
                    isValidAccess = false;
                }
            }else{
                isValidAccess = true;
            }
            
            return isValidAccess;
        }catch(exception ex) {
            System.debug(TEAMNAME+ex.getMessage()+LINENUMBER+ex.getLineNumber());
            return false; 
        } 
    } 
    
    //Check the validity of users with UHG Restriction and UHG Access for Provider Messaging
    //Author:Pavithra (ACDC)
    public static Boolean checkUHGRestrictionForMemberId(String accountId){ 
        try{
            Boolean isValidAccess; 
            String uhgRestriction;
            List<AccountContactRelation> relatedFamilyList = new List<AccountContactRelation>();
            List<Id> relatedIds = new List<Id>();
            List<Account> relatedAccounts = new List<Account>();
            String uhgAccess = [SELECT UHG_Access__c FROM User where Id= :userinfo.getUserId()].UHG_Access__c;
            String contactId = [SELECT Id, Name, PersonContactId  from Account  where Id =: accountId].PersonContactId;                     
            relatedFamilyList = [SELECT AccountId FROM AccountContactRelation Where ContactId =: contactId  ];
            for(AccountContactRelation ids : relatedFamilyList){
                relatedIds.add(ids.AccountId); 
            }  
            relatedAccounts = [SELECT Id,UHG_Restriction__c FROM Account Where Id IN :relatedIds AND UHG_Restriction__c != ''  ];         
            for(Account acc: relatedAccounts){
                if(acc.UHG_Restriction__c == 'Yes'){
                    uhgRestriction = 'Yes';
                }
            }
            
            if(uhgRestriction == 'Yes')
            {
                if(uhgAccess == 'Yes'){
                    isValidAccess = true;
                }else{
                    isValidAccess = false;
                } 
            }else{
                isValidAccess = true;
            }
            
            return isValidAccess;
        }catch(exception ex) {
            System.debug(TEAMNAME+ex.getMessage()+LINENUMBER+ex.getLineNumber());
            return false; 
        } 
    }
    
    //Author: Pavithra Fernando ACDC
    //Backend logic to insert data into the SNI_FL_Case_Notification__c when triggering the SNI_FL_InsertCaseNotificationTrigger
    public static void insertCaseNotification(List<Case> lstCase){
        try{
            Id ecmRecordTypeID = Schema.SObjectType.Case.getRecordTypeInfosByDeveloperName().get('ECM').getRecordTypeId();//'01236000000yOkTAAU'- chsdev '01236000000yOkTAAU' paintQA
            String accountId;
            String caseId;
            for(Case cs :lstCase){ 
                accountId = cs.AccountId;
                caseId=cs.Id;
            }
            
            List<Case> newCaseList = [Select id,AccountId, CaseNumber, Care_Type__c, Case_Name__c, Case_Origin__c, Case_Owner__c, Case_Type__c, ClosedDate, 
                                      Comments, Comments__c, Community__c, ContactId, CreatedById, CreatedDate, Description, Member_ID__c, OwnerId, SENS_Topic__c, 
                                      Status, Subject, Type, Type__c from Case Where Id =: caseId AND RecordTypeId =:ecmRecordTypeID  AND Community__c = true  ];
            
            List<SNI_FL_Case_Notification__c> caseNotification =new List<SNI_FL_Case_Notification__c>();    
            
            List<SNI_FL_Members_ROI__c> dm = [SELECT Id,SNI_FL_Member__c,SNI_FL_ROI_Signed_With__c,SNI_FL_Account__c FROM SNI_FL_Members_ROI__c WHERE SNI_FL_Account__c = :accountId AND SNI_FL_Status__c  = 'Active'  ];                     
            if(dm != null && !dm.isEmpty())
            {
                String authorizedId;
                for(SNI_FL_Members_ROI__c dmm : dm){
                    SNI_FL_Case_Notification__c mn = new SNI_FL_Case_Notification__c();
                    authorizedId = dmm.SNI_FL_ROI_Signed_With__c;
                    mn.ROI_Member_Id__c = authorizedId;
                    for(Case fc :newCaseList){
                        mn.Name = fc.Case_Name__c;
                        mn.Case_Number__c = fc.CaseNumber;
                        mn.Case_Owner__c = fc.OwnerId;
                        mn.Case_Date__c = fc.CreatedDate;
                        mn.Is_Viewed__c = false;
                        mn.Is_Viewed_Authorized_Member__c = false;
                        mn.Contact_Name__c = fc.ContactId;
                        caseNotification.add(mn);
                    }
                }
                insert caseNotification;
            }else{
                for(Case fc :newCaseList){
                    SNI_FL_Case_Notification__c mn = new SNI_FL_Case_Notification__c();
                    mn.Name = fc.Case_Name__c;
                    mn.Case_Number__c = fc.CaseNumber;
                    mn.Case_Owner__c = fc.OwnerId;
                    mn.Case_Date__c = fc.CreatedDate;
                    mn.Is_Viewed__c = false;
                    mn.Is_Viewed_Authorized_Member__c = false;
                    mn.Contact_Name__c = fc.ContactId;
                    mn.ROI_Member_Id__c = '';
                    caseNotification.add(mn);
                }
                insert caseNotification;
            }
        }catch(exception ex) {
            System.debug(TEAMNAME+ex.getMessage()+LINENUMBER+ex.getLineNumber());
            
        } 
    }
    
    //Author: Pavithra Fernando ACDC
    //Backend logic to insert data into the SNI_FL_Case_Notification__c when triggering the SNI_FL_InsertCaseNotificationTrigger
    public static void insertCaseCommentNotification(List<CaseComment> lstCase){
        try{
            Id ecmRecordTypeID = Schema.SObjectType.Case.getRecordTypeInfosByDeveloperName().get('ECM').getRecordTypeId();//'01236000000yOkTAAU'- chsdev '01236000000yOkTAAU' paintQA
            String caseId;
            String caseCommentId;
            String accountId;
            for(CaseComment cs :lstCase){ 
                caseId=cs.ParentId;
                caseCommentId=cs.Id;
            }
            accountId = [SELECT Id, ParentId,Parent.AccountId FROM CaseComment WHERE ParentId= :caseId AND Id =:caseCommentId ].Parent.AccountId;
            
            List<Case> newCaseList = [Select id,AccountId, CaseNumber, Care_Type__c, Case_Name__c, Case_Origin__c, Case_Owner__c, Case_Type__c, ClosedDate, 
                                      Comments, Comments__c, Community__c, ContactId, CreatedById, CreatedDate, Description, Member_ID__c, OwnerId, SENS_Topic__c, 
                                      Status, Subject, Type, Type__c from Case Where Id =: caseId AND RecordTypeId =:ecmRecordTypeID  AND Community__c = true  ];
            
            List<CaseComment> caseCommentList = [SELECT Id, ParentId,Parent.AccountId, CommentBody FROM CaseComment WHERE ParentId= :caseId AND Id =:caseCommentId AND IsPublished = true  ORDER BY CreatedDate DESC];
            
            List<SNI_FL_Case_Notification__c> caseNotification =new List<SNI_FL_Case_Notification__c>();    
            
            
            List<SNI_FL_Members_ROI__c> dm = [SELECT Id,SNI_FL_Member__c,SNI_FL_ROI_Signed_With__c,SNI_FL_Account__c FROM SNI_FL_Members_ROI__c WHERE SNI_FL_Account__c = :accountId AND SNI_FL_Status__c  = 'Active' ];              
            
            if(caseCommentList != null && !caseCommentList.isEmpty())
            {
                if(dm != null && !dm.isEmpty())
                {
                    String authorizedId;
                    for(SNI_FL_Members_ROI__c dmm : dm){
                        SNI_FL_Case_Notification__c mn = new SNI_FL_Case_Notification__c();
                        authorizedId = dmm.SNI_FL_ROI_Signed_With__c;
                        mn.ROI_Member_Id__c = authorizedId;
                        for(CaseComment cc: caseCommentList){ 
                            for(Case fc :newCaseList){                        
                                mn.Name = fc.Case_Name__c;
                                mn.Case_Number__c = fc.CaseNumber;
                                mn.Case_Owner__c = fc.OwnerId;
                                mn.Case_Date__c = fc.CreatedDate;
                                mn.Is_Viewed__c = false;
                                mn.Is_Viewed_Authorized_Member__c = false;
                                mn.Contact_Name__c = fc.ContactId;                                                     
                            }
                            
                        }
                        caseNotification.add(mn);
                    }
                    insert caseNotification;
                }else{
                    for(CaseComment cc: caseCommentList){
                        SNI_FL_Case_Notification__c mn = new SNI_FL_Case_Notification__c(); 
                        for(Case fc :newCaseList){                        
                            mn.Name = fc.Case_Name__c;
                            mn.Case_Number__c = fc.CaseNumber;
                            mn.Case_Owner__c = fc.OwnerId;
                            mn.Case_Date__c = fc.CreatedDate;
                            mn.Is_Viewed__c = false;
                            mn.Is_Viewed_Authorized_Member__c = false;
                            mn.Contact_Name__c = fc.ContactId;
                            mn.ROI_Member_Id__c = '';                        
                        }
                        caseNotification.add(mn);
                    }
                    insert caseNotification;
                }
            }
            
            
        }catch(exception ex) {
            System.debug(TEAMNAME+ex.getMessage()+LINENUMBER+ex.getLineNumber());
            
        } 
    }
    
    /**
    * Query account team member object to get adivosor related provider 
    * afliation account records,iffound:return ture,else return false
    * @param userId 
    * @returns `Boolean`
    * @Author:Sameera De Silva US3070642
    * @Team:ACDC
    */    
    public static Boolean isAdvisorAfliatedToProviderAffliation(String userId){
        ID providerAffliationRecordType = Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName().get('Provider_Affiliation').getRecordTypeId();
        if(enforceApexSecurity([SELECT Id FROM AccountTeamMember WHERE Account.RecordTypeId=:providerAffliationRecordType AND UserId=:userId],READABLE).size()>0){
            return true;
        }else{
            return false;
        }
        
    } 
    
    /**
    * Check field level and object level permissions for apex becuase apex runs in system context and 
    * not considering Object and FLS.
    * @param lstrecords  
    * @param accessType 
    * @returns `List<sObject>`
    * @Author:Sameera De Silva US3070642
    * @Team:ACDC
    */    
    public static List<sObject> enforceApexSecurity(List<sObject> lstrecords,String accessType){
        try{
            
            switch on accessType{
                when 'READABLE'{
                    SObjectAccessDecision decision = Security.stripInaccessible(System.AccessType.READABLE,lstrecords,true);
                    return decision.getRecords();
                }
                when else{
                    return null;
                }
            }
            
        }catch(Exception ex){
            
            System.debug(TEAMNAME+ex.getMessage()+' '+LINENUMBER+ex.getLineNumber());
            return null;
        }
    }
    
    //US3116090 SNI: Provider Messages Button behavior
    //Added by(Blinkers)
    public static String checkForProviderAffiliationRecord(String accountId){ 
        try{
            String isValidAccess;
            String loggedinUser = UserInfo.getUserId();
            Set<Id> relateIds = new Set<Id>();
            List<AccountTeamMember> aTeams = new List<AccountTeamMember>();
            List<Member_Affiliation__c> relatedAccounts = new List<Member_Affiliation__c>();
            
            
            
            String loggedinUserRole = [Select Id ,UserRoleId,UserRole.Name from User WHERE Id =:loggedinUser].UserRole.Name;
            relatedAccounts = [SELECT Id,Name,Provider_Affiliation__c FROM Member_Affiliation__c WHERE Member__c =:accountId AND Provider_Affiliation__c !=null ];
            if(!USERROLES.contains(loggedinUserRole) && loggedinUserRole != null){
                for(Member_Affiliation__c ids : relatedAccounts){
                    relateIds.add(ids.Provider_Affiliation__c); 
                }
                Map<Id,Account> acctsToUpdate = new Map<Id,Account>([Select Id, RecordType.Name, (Select Id, AccountId, UserId From AccountTeamMembers WHERE UserId =:loggedinUser) From Account Where Id IN:relateIds]);
                for (Account a : acctsToUpdate.values()){
                    for(AccountTeamMember team : a.AccountTeamMembers){
                        aTeams.add(team);
                    }
                }           
                if(aTeams.size() > 0){
                    isValidAccess= 'Yes';   
                }
                else{
                    isValidAccess= 'No';  
                }  
            }else{
                isValidAccess= 'Restrict';
            }
            System.debug('isValidAccess '+isValidAccess);
            
            return  isValidAccess;
        }catch(exception ex) {
            System.debug('Exception '+ex.getMessage()+LINENUMBER+ex.getLineNumber());
            return 'No'; 
        } 
    }
    
    public static String getMemberIdByAccountId(String accountID){
        String memberId;        
        try{
            List<Account> member =[select Member_Id__c   from Account where Id = :accountID  ];
            if(member!=null && member.size()>0){
                memberId = member[0].Member_Id__c;
            }
            return memberId;
        }catch(Exception ex){
            System.debug(TEAMNAME+ex.getMessage()+LINENUMBER+ex.getLineNumber());
            return null;
        }
        
    }
    
}