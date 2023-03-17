/****************************************************************************** 
Class Name     : SNI_FLDirectMessageUtil.apxc
Description    : Route ConnectAPI and Object Query tasks
Created By     : Sameera De Silva
Created Date   : 8/25/2020

Modification Log
---------------------------------------------------------------------------------- 
Developer                   Date                   Description

1.Sameera De Silva          8/25/2020               Created class without body
2.Sameera De Silva          8/25/2020               Adding method methods without method defintions
3.Sumeet Patel              10/2/2020               Adding methods related to Email/SMS notifications
4.Manmeet Kaur				11/24/2022				Added code to call League on 
													new message from advisor
----------------------------------------------------------------------------------            

*********************************************************************************/

public without sharing class SNI_FLDirectMessageUtil  {
    public static boolean updateCaseNotificationRecursiveCheck = false;
    public static boolean insertCaseNotificationRecursiveCheck = false;
    public static boolean insertCaseCommentNotificationRecursiveCheck = false;
    
    
    public class HistoricalReturnWrapper{
        @AuraEnabled
        public boolean HistoricalMessage {get; set;}
        @AuraEnabled
        public String requestType {get; set;}
    }

    //Retrieved direct messages based on family level 
    @AuraEnabled
    public static List<SNI_FL_DirectMessageObjectQuery.SNI_FLDirectMessageWrapper> getDirectMessageList(Boolean isFamilyLevel,String agentID,ID familiyAccountID,Integer pageNumber,Integer pageSize, Boolean isFlagged, Boolean isBackupAgent,Boolean isProviderMsgLevel,String selectedId,Boolean isUnread, Boolean isProvider){
        
        return SNI_FL_DirectMessageObjectQuery.retrieveDirectMessageList(isFamilyLevel,familiyAccountID,agentID,pageNumber,pageSize,isFlagged, isBackupAgent, isProviderMsgLevel, selectedId, isUnread, isProvider);
    }
    
    /*Retrieve specifict directMessageWrapper object for feedID */
    @AuraEnabled 
    public static SNI_FLDirectMessageWrapper getDirectMessageWrapperForFeedID(String feedID,String userID,Boolean isProviderMessage){
        return SNI_FLDirectMessageObjectQuery.getDirectMessageWrapper(feedID,userID,isProviderMessage);
    }
    
    @AuraEnabled
    public static Boolean feedToggleMarked(boolean flflag, ID feedID){
        return SNI_FLDirectMessageObjectQuery.feedToggleMarked(flflag, feedID);
    }
    
    @AuraEnabled
    public static Boolean changeReadStatus(boolean isRead, Id feedID){
        return SNI_FLDirectMessageObjectQuery.changeReadStatus(isRead, feedID);
    }
    
    @AuraEnabled  
    public static List <SNI_FL_BackupAdvisor__c> saveBackUpAdvisors(string strBackUpAdvisor, List<string> selectedPills){
        SNI_FLDirectMessageObjectQuery.saveBkUpAdvisors(strBackUpAdvisor,selectedPills); 
        return  SNI_FLDirectMessageObjectQuery.getBackUpAdvisors();  
    }
    
    @AuraEnabled
    public static List <SNI_FL_BackupAdvisor__c> getBackUpAdvisors(){
        
        return SNI_FLDirectMessageObjectQuery.getBackUpAdvisors();  
    }
    
    @AuraEnabled
    public static SNI_FLDirectMessageWrapper.wrapperAccPermission getAccountNameByID1(String accountID){
        return SNI_FLDirectMessageObjectQuery.getAccountNameByID1(accountID);
    }
    
    @AuraEnabled
    public static Map<String,String> getAccountNameByID(String accountID){
        return SNI_FLDirectMessageObjectQuery.getAccountNameByID(accountID);
    }
    
    @AuraEnabled
    public static String getAccountNameByUser(){
        return SNI_FLDirectMessageObjectQuery.getAccountNameByUser();
    }
    
    @AuraEnabled
    public static Boolean checkProfileValidity(){ 
        return SNI_FLDirectMessageObjectQuery.checkProfileValidityForUserId();
    }

    @AuraEnabled
    public static SNI_FLDirectMessageWrapper.UserPermissionSet  getUserProfilePermissionSet(){
        return SNI_FLDirectMessageObjectQuery.getUserProfilePermissionSet();
    }

    @AuraEnabled
    public static List <sObject> fetchLookUpValues(String searchKeyWord, String objectName, List<sObject> excludeitemsList,String profileName) {
        return SNI_FLDirectMessageObjectQuery.fetchLookUpValuesForBackupAdvisors(searchKeyWord,objectName,excludeitemsList,profileName);
    }
    
    @AuraEnabled
    public static String getProfileName(){
        return SNI_FLDirectMessageObjectQuery.getProfileNameForLoggedUser();
    }
    
    //Retrieving feedcomments for lazy loading
    @AuraEnabled 
    public static List<SNI_FLDirectMessageWrapper.SNI_FL_DirectMessageFeedComments> getPaginatedFeedComments(String feedID,Integer pageNumber,Integer pageSize){
        return SNI_FLDirectMessageObjectQuery.getFeedCommentsForLazyLoading(feedID,pageNumber,pageSize);
    }
    
    @AuraEnabled  
    public static void saveNewMessage(String familyAccount, List<Id> lstOfMessageToUsers, String subject, String messageBody, String uploadedFiledID, Boolean isBackupAgentView,Boolean isFamlyLink,Object selectedPartnerQueue){
        Boolean isFamilyPartner = false;
        Id userId = UserInfo.getUserId();
        Boolean hasPermissionset = hasAssignedPermissionSet(userId);
        Boolean hasFamilyPartnerRec = hasFamilyPatnerRec(userId);
        if(hasFamilyPartnerRec && hasPermissionset){
            isFamilyPartner = true;
        }
        //US3376756 - sameera(start)
        Map<String,Object> messageRequest = new Map<String,Object>();
        messageRequest.put('selectedQueue',selectedPartnerQueue);
        messageRequest.put('MessageContent',messageBody);
        messageRequest.put('MessageSubject',subject);
        messageRequest.put('ToUsers',lstOfMessageToUsers);
        system.debug('@121::'+lstOfMessageToUsers);
        messageRequest.put('FamilyAccountID',familyAccount); 
         
        //US3376756 - sameera(end)
        
        //Make a call to Notification center for sending SMS/Email about this new message [SMS/Email Notification feature]
        if (!lstOfMessageToUsers.isEmpty()) {
            List<Id> listOfUserIds = new List<Id>();
            List<User> lstOfToUsers = [SELECT Id, AccountId FROM User WHERE AccountId IN :lstOfMessageToUsers]; 
            for (User u : lstOfToUsers) {
                listOfUserIds.add(u.Id);
            }
            if (!listOfUserIds.isEmpty()) {
               
                sendEmailOrSMSNotifications(listOfUserIds);
            }
        }
        
        if(!isBackupAgentView){
            //US3376756 - sameera(added messageRequest argument)
            
            SNI_FLDirectMessageConnectAPI.backupAgentNewMessage(familyAccount, lstOfMessageToUsers, subject, messageBody, uploadedFiledID, isBackupAgentView,messageRequest);  
        }else if(isFamlyLink){
           
            SNI_FLDirectMessageConnectAPI.familyLinkeNewMessage(familyAccount, lstOfMessageToUsers, subject, messageBody, uploadedFiledID);
        } else {
            
            //US3376756 - sameera(added messageRequest argument)
           
            if(isFamilyPartner){
                
                SNI_FLDirectMessageConnectAPI.familyPartnerNewMessage(familyAccount, lstOfMessageToUsers, subject, messageBody, uploadedFiledID,messageRequest);  
            }else{
                 
                SNI_FLDirectMessageConnectAPI.agentNewMessage(familyAccount, lstOfMessageToUsers, subject, messageBody, uploadedFiledID,messageRequest);  
             }
        }
        //Added by Manmeet
        // SENSAPI_SendDataToLeagueProcessor.sendDataToLeague('messages',json.serialize(messageRequest),''); 
    }
    
    @AuraEnabled  
    public static void deleteAttachment(String uploadedFileId){
        SNI_FLDirectMessageConnectAPI.deleteFiles(uploadedFileId); 
    }
    
    // validatepostNewCommentAttachment 
    @AuraEnabled
    public static SNI_FLDirectMessageWrapper.DirectMessageComments validatepostNewCommentAttachment(String feedElementId, String msgText, String fileId) {
        sendEmailOrSMSNotificationsForPostAComment(feedElementId);
        SNI_FL_ProviderCustomNotification.sendReplyCustomNotification(msgText,feedElementId,fileId);//Sameera -Sameera ACDC US3131863
        return SNI_FLDirectMessageConnectAPI.validatepostNewCommentAttachment(feedElementId, msgText, fileId);
    }
    
    // Post new comment without any attachments
    @AuraEnabled
    public static SNI_FLDirectMessageWrapper.DirectMessageComments postNewComment(String feedElementId, String msgText) {
        return SNI_FLDirectMessageConnectAPI.postNewComment(feedElementId, msgText);
    }
    
    @AuraEnabled
    public static SNI_FLDirectMessageWrapper.DirectMessageComments postNewCommentWithAttachement(String feedElementId, String msgText, String documentID) {
        return SNI_FLDirectMessageConnectAPI.postNewCommentWithAttachement(feedElementId, msgText, documentID); 
    }
    
    @AuraEnabled
    public static List<DirectMessageFeed> getFamilLinkUserMsg() {
        List<DirectMessageFeed> allDirectMessages = [SELECT Id,Parent.Id, Parent.Subject,Body,LastModifiedDate,CreatedDate,CreatedById, ParentId FROM DirectMessageFeed];
        return allDirectMessages;       
    }
    
    //Make a call to Notification center for sending SMS/Email about this new post/comment [SMS/Email Notification feature]
    public static void sendEmailOrSMSNotificationsForPostAComment(String feedID) {
        try {
            if (String.isNotEmpty(feedID)) {
                List<Id> memberIds = new List<Id>();
                Id userID = UserInfo.getUserId();
                List<DirectMessageFeed> lstDirectMessageFeed = [SELECT Id, Parent.Id, ParentId FROM DirectMessageFeed WHERE Id =:feedID];
                if (!lstDirectMessageFeed.isEmpty()) {
                    List<DirectMessageMember> lstDirectMessageMember = [SELECT Id,DirectMessageId,MemberId FROM DirectMessageMember WHERE DirectMessageId=:lstDirectMessageFeed[0].ParentId];
                    for(DirectMessageMember member:lstDirectMessageMember){
                        if(member.MemberId != userID){
                            memberIds.add(member.MemberId);
                        }
                    }
                    if (!memberIds.isEmpty()) {
                        sendEmailOrSMSNotifications(memberIds);
                    }
                }
            }
        } catch (Exception e) {
            //Handling exception gracefully because this shouldn't throw an exception on front-end/UI and shouldn't block other events
            System.debug(LoggingLevel.WARN, 'Blinker Exception - Something went wrong while sending Email or SMS Notification for a post: ' + e.getMessage());
        }
    }
    
    //Make a call to Notification center for sending SMS/Email about this new message [SMS/Email Notification feature]
    public static void sendEmailOrSMSNotifications(List<Id> entityIds) { 
        try {
            if (!entityIds.isEmpty()) { 
                List<User> userRec = [select id,MobilePhone,Email,Contact.Account.Id,Contact.Account.Email_Notification__c,Contact.Account.Text_Message_SMS_Notification__c,
                            Contact.Account.Last_Notification_Timestamp__c,FirstName,LastName,Profile.Name
                            from User where Id =: entityIds and Contact.Account.Id !=''];
                if (!userRec.isEmpty()) {
                  for (User usr : userRec) {
                      SNI_FL_Notification_Center.SendNotification(usr.id);
                  }
                }

            }
        } catch (Exception e) {
            //Handling exception gracefully because this shouldn't throw an exception on front-end/UI and shouldn't block other events
            System.debug(LoggingLevel.WARN, 'Blinker Exception - Something went wrong while sending Email or SMS Notification: ' + e.getMessage());
        }
    }
    
    //Check the status of regitered and unregistere members
    @AuraEnabled
    public static Boolean CheckUnregisteredMember(String AccountId ){ 
        return SNI_FLDirectMessageObjectQuery.checkUnregisteredMemberByUserId(AccountId);
    } 
    
    //Check UHG Restricted members and Unauthorized Agents
    @AuraEnabled
    public static Boolean checkUHGRestriction(String AccountId){ 
        return SNI_FLDirectMessageObjectQuery.checkUHGRestrictionForUserId(AccountId);
    }
     @AuraEnabled
    public static Boolean checkManageProviderGroupUserId(){ 
        return SNI_FLDirectMessageObjectQuery.checkManageProviderGroupUserId();
    }

    //Check UHG Restricted members and Unauthorized Agents
    @AuraEnabled
    public static Boolean checkUHGRestrictionForProviderMessaging(String accountId){ 
        return SNI_FLDirectMessageObjectQuery.checkUHGRestrictionForMemberId(accountId);
    }

    @AuraEnabled
    public static String checkProviderAffiliationForProviderMessaging(String accountId){ 
        return SNI_FLDirectMessageObjectQuery.checkForProviderAffiliationRecord(accountId);
    }

    //Changes the message status when replying to an existing messaging thread.Replying 
    //user's status will be set to "True" and other user's statuses will be "false"
    //Author:Sameera De Silva(ACDC)
    @AuraEnabled
    public static Boolean changeMessageStatusWhenReplying(String DirectMessageFeedID){
        return SNI_FLDirectMessageObjectQuery.changeStatusForReply(directMessageFeedId);
    }   
    
    /**
     * @functionality: Checks whether advisor belongs to atleast one provider afliation
     *                 iftrue:provider UI will display,else:informational message display
     * @Author:Sameera De Silva US3070642
     * @Team:ACDC
    **/
    @AuraEnabled(cacheable=true)
    public static Boolean checkProviderAfliationsForAdvisor(String advisorId){
        Boolean value = SNI_FLDirectMessageObjectQuery.isAdvisorAfliatedToProviderAffliation(advisorId);
        return value;
    }
    
    //Author:Nanthu - ACDC
    //US3131860 - Family Link: Provider Message Page Search Bar (web/mobile)
    //Retrieve search input keyword related members
    @AuraEnabled
    public static List <SNI_FL_DirectMessageObjectQuery.RecordsData> getAllRelatedToMembers(String searchKeyWord){
        return SNI_FL_DirectMessageObjectQuery.getAllRelatedToMembers(searchKeyWord);
    }   

    //Author:Nanthu - ACDC
    //US3121164 - Family Link: Provider Message Mark as unread (web/mobile)
    //Retrieve boolean value
    @AuraEnabled
    public static Boolean markAsUnread(String feedId){
        return SNI_FL_DirectMessageObjectQuery.markAsUnread(feedId);
    }  

    //DE409699
    @AuraEnabled
    public static string getAffliationName(String affliationID){
        try {
            Account affliationRecord = [SELECT Program__r.Program__c,Population__c FROM Account WHERE ID=:affliationID];
            return affliationRecord.Program__r.Program__c+' - '+affliationRecord.Population__c;
        } catch (Exception e) {
            System.debug(e.getMessage());
            return null;
        }
    }

    //Author:Nanthu - AC/DC
    //US3315143 - SENS: Display Leave message button
    //Retrieve boolean value
    @AuraEnabled
    public static Boolean getCurrentUserPermissionSet(String userId){
        List<PermissionSetAssignment> flPermission = [SELECT Id FROM PermissionSetAssignment WHERE AssigneeId = :userId AND (PermissionSet.label =:system.label.SNI_FL_3WayCommunication OR PermissionSet.label =:system.label.SNI_FL_FamilyLinkPermission) limit 1];
        system.debug('flPermission : ' +flPermission);
        if(!flPermission.isEmpty()){
            return true;
        } else {
            return false;
        }
    }

    //Author:Nanthu - AC/DC
    //US3330525 - SENS: Partner queue backend setup
    //Retrieve list of PartnerQueue sObject
    @AuraEnabled
    public static List<PartnerQueue> getPartnerQueues(){
        List<PartnerQueue> lstPartnerQueue = new List<PartnerQueue>();
        Set <String> queueNames = new set<String>{
            					'Wellness and Community Coach',
								'Nurse Advisor', 
                                'Women\'s Health Nurse Advisor'
         };
        for(QueueSobject qu : [SELECT Id, QueueId, Queue.Name FROM QueueSobject WHERE SobjectType='Message_Request_Queue__c' AND Queue.Name IN:queueNames ]){
            lstPartnerQueue.add(new PartnerQueue(qu.Queue.Name, qu.QueueId));
        }

        return lstPartnerQueue;
    }

    public class PartnerQueue {
        @AuraEnabled public String label{get;set;}
        @AuraEnabled public String value{get;set;}

        public PartnerQueue(String label, String value) {
            this.label = label;
            this.value = value;
        }
    }
    // End of US3315143 - Nanthu (AC/DC)
    
    //Author:Pavithra - ACDC
    //US3213590 - Display MemberId in SENS
    //Retrieve string value
    @AuraEnabled
    public static String getMemberIdByAccountId(String accountID){
        return SNI_FLDirectMessageObjectQuery.getMemberIdByAccountId(accountID);
    }

    @AuraEnabled
    public static String getHistoryEnabled(){
        user u = [select contact.accountId,contact.account.Historical_Message__c from user where Id=:userinfo.getUserId()];
        String result = String.valueof(u.contact.accountId)+'-'+String.valueof(u.contact.account.Historical_Message__c);
        return result;
    } 
    @AuraEnabled
    public static Boolean getProviderHistoryEnabled(String providerAff){
        List<Account> acc = [select Id, Name, Historical_Message__c from Account where Id =:providerAff];
        if(acc.size() > 0){
            return acc[0].Historical_Message__c;
        }
        return false;
    }
    @AuraEnabled
    public static String getMemAffHistEnabled(String providerAff, String personId){
        List<Member_Affiliation__c> mem_Aff = [select Id, Name, Historical_Message__c from Member_Affiliation__c where Provider_Affiliation__c =:providerAff
                            and Member__c=:personId];
        if(mem_Aff.size() > 0){
            return String.valueof(mem_Aff[0].Id)+'-'+String.valueof(mem_Aff[0].Historical_Message__c);
        }
        return null;
    }

    @AuraEnabled
    public static Boolean getMemAffHistSwitch(String memberAff){
        List<Member_Affiliation__c> mem_Aff = [select Id, Name, Historical_Message__c from Member_Affiliation__c where Id =:memberAff];
        if(mem_Aff.size() > 0){
            return mem_Aff[0].Historical_Message__c;
        }
        return null;
    }
    //US3241339 - Ashley Winden
    //US3244597 - Charnkiat Sukpanichnant
    @AuraEnabled
    public static HistoricalReturnWrapper getFamilyHistoricalMessagesFlag(String familyId){
        boolean historicalMessagesFlag = false;
        HistoricalReturnWrapper historia = new HistoricalReturnWrapper();
        String requestType = null;
        list<AccountContactRelation> acrList =[SELECT AccountId, ContactId FROM AccountContactRelation WHERE AccountId =: familyId];
        if(acrList.Size() > 0){
            set<Id> accIdSet =  new set<Id>();
            for(AccountContactRelation acr: acrList){
                accIdSet.add(acr.ContactId);
            }
            list<Account> memberList = [SELECT Id,Historical_Message__c from Account where PersonContactId IN:accIdSet];
            for(Account member : memberList){
                if(member.Historical_Message__c){
                    historicalMessagesFlag = true;
                    requestType = 'family';
                }
            }
        }
        historia.HistoricalMessage = historicalMessagesFlag;
        historia.requestType =requestType;
        return historia;
    }
    @AuraEnabled
    public static HistoricalReturnWrapper getProviderHistoricalMessageFlag(String familyId){
        boolean historicalMessagesFlag = false;
        HistoricalReturnWrapper historia = new HistoricalReturnWrapper();
        String requestType = null;
        list<Member_Affiliation__c> memberList = [SELECT Id, Name,Provider_Affiliation__r.Name, Enrollment_Date__c,Member__r.Name,Historical_Message__c from Member_Affiliation__c where Member__c =: familyId and Historical_Message__c = true];
        if(memberList.size() > 0){
            historicalMessagesFlag = true;
            requestType = 'provider';
        }
        historia.HistoricalMessage = historicalMessagesFlag;
        historia.requestType =requestType;
        return historia;
    }
    //US3244597 - Charnkiat Sukpanichnant
    @AuraEnabled
    public static integer getMemberAffiliationCount(String accountID){
        List<Member_Affiliation__c> memberAfflst = new List<Member_Affiliation__c>();
            if(accountID != null && !String.isEmpty(accountID)){
                memberAfflst = [Select Id, Name,Provider_Affiliation__r.Name, Enrollment_Date__c,Member__r.Name from Member_Affiliation__c where Member__c =: accountID and Historical_Message__c = true];
            }
        return memberAfflst.size();
    }
    //US3244597 - Charnkiat Sukpanichnant
    @AuraEnabled
    public static String getMAID(String accountID){
        List<Member_Affiliation__c> memberAfflst = new List<Member_Affiliation__c>();
            if(accountID != null && !String.isEmpty(accountID)){
                memberAfflst = [Select Id, Name,Provider_Affiliation__r.Name, Enrollment_Date__c,Member__r.Name from Member_Affiliation__c where Member__c =: accountID and Historical_Message__c = true];
                if(memberAfflst.size() ==1){
                    return memberAfflst[0].Id;
                }
            }
        return '';
    }
    //US3241339 - Ashley Winden

    //Author:Bobby Culbertson - Eagles
    //US3278095 & US3278491
    //Retrieve the Designation value from the Family Overview record related to the Family Account Id
    @AuraEnabled
    public static string getFamilyOverviewDesignation(String familyAccountId){
        Family_Overview__c fOverview = new Family_Overview__c();     
        if(familyAccountId == null){
            Id userId =UserInfo.getUserId();
            User u = [select id, contactId,contact.accountId from User where id = : userId];
            //Need to get user's contact ID, to query the AccountContactRelationship object
            //For the family accounts this contact is related too.
            Id getPersonContactId = u.contactId;
            //get related accounts order by createddate, status
            AccountContactRelation acr = new AccountContactRelation();
            try{
                acr = [Select Id, AccountId From AccountContactRelation Where contactId = :getPersonContactId AND isActive = true ORDER BY CreatedDate ASC LIMIT 1];
            } catch (Exception e){
                 System.debug('No Account Contact Relation Record for Familiy ID: '+e.getMessage());
            }
            
            if(acr != null){
                familyAccountId = acr.AccountId;
            }
        } 
        if(familyAccountId != null){
            try {
                fOverview = [Select Id, Designation__c FROM Family_Overview__c WHERE Account__c = :familyAccountId LIMIT 1];
            } catch (Exception e) {
                System.debug('No Family Overview Record for Familiy ID: '+e.getMessage());
            }
            if(fOverview != null && !String.isBlank(fOverview.Designation__c)){
                return fOverview.Designation__c;
            }
        }
        return 'No Designation';
    }
    //Check 3way communication Permission set assignment
    public static boolean hasAssignedPermissionSet(string userId){
        List<AggregateResult> result =[SELECT count(Id) FROM PermissionSetAssignment WHERE AssigneeId = :userId AND PermissionSet.label =:system.label.SNI_FL_3WayCommunication];
        return result.size() > 0;
    }
    //Check FamilyPartner object Permission 
    public static boolean hasFamilyPatnerRec(string userId){
        
        List<Family_Partner__c> result=[select Id,Partner__c from Family_Partner__c where Partner__c=:userId limit 1];
        return result.size() > 0;
    }
    //get object keyprefix 
    public static string getObjKeyprefix(string ObjName){
        Map<String, Schema.SObjectType> m  = Schema.getGlobalDescribe() ;
        Schema.SObjectType s = m.get(ObjName);
        Schema.DescribeSObjectResult r = s.getDescribe() ;
        String keyPrefix = r.getKeyPrefix();
        return keyPrefix;
    }
    @AuraEnabled
    public static boolean checkPartnerforFamily(string familyId){
        list<family_partner__c> lstFp = [select id from family_partner__c  where family__c =: familyId and Partner__c=: UserInfo.getUserId()];
        system.debug('lstFp-----'+lstFp.size());
        if( lstFp != null && ! lstFp.isEmpty()){
            return true;
        }
        else{
            return false;
        }
    }
}