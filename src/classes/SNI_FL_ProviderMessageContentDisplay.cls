/********************************************************************************* 
Class Name     : SNI_FL_ProviderMessageContentDisplay.apxc
Description    : Handling Provider Messaging Message Content Display Functions US3128862
Created By     : Pavithra Fernando
Created Date   : 16/01/2021
  
Modification Log 
---------------------------------------------------------------------------------- 
Developer                   Date                   Description

----------------------------------------------------------------------------------            

*********************************************************************************/

public without sharing class SNI_FL_ProviderMessageContentDisplay {

    public static final String TEAMNAME = 'ACDC ';
    public static final String LINENUMBER = 'LineNumber ';
    public static final String FAMILYLINKPROFILE = 'Family Link Provider User';
    public static final String FAMILYENGAGEMENTPROFILE = 'Center for Health Navigation';
    

    //Retrieve directMessageWrapper object for given feedID. This will be invoked when a user clicks 
    //a message from the message list
    //Author: Pavithra (ACDC)
    public static SNI_FLDirectMessageWrapper getDirectMessageWrapper(String feedID,String userID){
        
        SNI_FLDirectMessageWrapper.SNI_FLUserDetails initiatedUser;
        SNI_FLDirectMessageWrapper.SNI_FL_PersonAccount memberInfo;
        List<String> providerTeam = new List<String>();
        List<SNI_FLDirectMessageWrapper.SNI_FLUserDetails> involvedUsers = new List<SNI_FLDirectMessageWrapper.SNI_FLUserDetails>();
        List<SNI_FLDirectMessageWrapper.SNI_FL_ProviderTeam> ptUsers = new List<SNI_FLDirectMessageWrapper.SNI_FL_ProviderTeam>();
        SNI_FLDirectMessageWrapper.SNI_FLMessage flMessage;
        SNI_FLDirectMessageWrapper.SNI_FLDirectMessageFeed directMessageFeed;
        
        Map<ID,List<FeedComment>> mapOfFeedComments;
        List<SNI_FLDirectMessageWrapper.SNI_FL_DirectMessageFeedComments> lstFeeedComment = new List<SNI_FLDirectMessageWrapper.SNI_FL_DirectMessageFeedComments>();
        String profileName;
        
        try{
            profileName = [Select Profile.Name from User where Id=:UserInfo.getUserId()].Profile.Name;
                        
            //Retrive SNI_FL_Message__c record matches with FeedID and creating SNI_FLMessage Wrapper object
            SNI_FL_Message__c flMsg = [SELECT Id, (SELECT id,IsRead__c FROM SNI_FL_Message_Statuses__r WHERE Agent__c=:UserInfo.getUserId()), Feed_Id__c, Marked__c, Member_Id__c, Member_Id__r.LastName, Member_Id__r.Salutation, Member_Id__r.FirstName, Program__c, ProviderUser_List__c FROM SNI_FL_Message__c WHERE Feed_Id__c=:feedID LIMIT 1];
            
            List<SNI_FL_Message_Status__c> msgStatus = flMsg.SNI_FL_Message_Statuses__r;
            
            memberInfo = new SNI_FLDirectMessageWrapper.SNI_FL_PersonAccount(flMsg.Member_Id__r.FirstName,flMsg.Member_Id__r.LastName,flMsg.Member_Id__c,flMsg.Member_Id__r.Salutation);

            List<SNI_FL_Message_Provider_Team__c> lstProTeam = [SELECT Provider_Team__c, Provider_Team__r.Name FROM SNI_FL_Message_Provider_Team__c WHERE SNI_FL_Message__c =: flMsg.Id ]; 

            for(SNI_FL_Message_Provider_Team__c pt: lstProTeam){
                providerTeam.add(pt.Provider_Team__c);
            }

            ID providerUserrecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName().get('Provider_User').getRecordTypeId();    

            List<AccountContactRelation> acr = [SELECT Contact.LastName, Contact.Salutation, Contact.FirstName, ContactId, Contact.AccountId, AccountId FROM AccountContactRelation WHERE AccountId IN :providerTeam AND Contact.IsPersonAccount=true AND Contact.Account.RecordTypeId=:providerUserrecordTypeId ];

            List<String> ptMembers = new List<String>();

            for(SNI_FL_Message_Provider_Team__c pt: lstProTeam){
                List<SNI_FLDirectMessageWrapper.SNI_FL_PersonAccount> lstUsers = new List<SNI_FLDirectMessageWrapper.SNI_FL_PersonAccount>();
                for(AccountContactRelation ac: acr){
                    ptMembers.add(ac.ContactId);
                    if(ac.AccountId == pt.Provider_Team__c){
                        lstUsers.add(new SNI_FLDirectMessageWrapper.SNI_FL_PersonAccount(ac.Contact.FirstName, ac.Contact.LastName, ac.ContactId, 'PT'));
                    }
                }
                ptUsers.add(new SNI_FLDirectMessageWrapper.SNI_FL_ProviderTeam(pt.Provider_Team__c, pt.Provider_Team__r.Name, lstUsers));
            }

            flMessage = new SNI_FLDirectMessageWrapper.SNI_FLMessage(flMsg.Feed_Id__c,flMsg.Marked__c,msgStatus.size()>0?msgStatus[0].IsRead__c:false,memberInfo,ptUsers);

            Set<String> toUserIds = new Set<String>();
            if(!string.isBlank(flMsg.ProviderUser_List__c)){
                toUserIds.addAll(flMsg.ProviderUser_List__c.split(';'));
            }

            Map<ID,User> toUserMap = getMapOfUserdetail(toUserIds);//Retriving map of userIDs and user records

            for(String s: toUserIds){
                User userInvolved = toUserMap.get(s);
                involvedUsers.add(new SNI_FLDirectMessageWrapper.SNI_FLUserDetails(userInvolved.FirstName,userInvolved.LastName,userInvolved.Id,userInvolved.profile.name,userInvolved.userrole.name));
            }
  
            //Retrieving drirectMessageFeed record for the feedID
            List<DirectMessageFeed> lstDirectMessageFeed =  [SELECT Id,Parent.Id, Parent.Subject,Body,LastModifiedDate,CreatedDate,CreatedById, ParentId FROM DirectMessageFeed WHERE Id =:feedID ];
			 system.debug('89 '+lstDirectMessageFeed.size());
            //Preparing initated user wrapper and involved user wrapper objects 
            List<DirectMessageMember> lstDirectMessageMember = [SELECT Id,DirectMessageId,MemberId FROM DirectMessageMember WHERE DirectMessageId=:lstDirectMessageFeed[0].ParentId ];
            system.debug('92 '+lstDirectMessageMember.size());
      
            Set<String> msgMembers = new Set<String>();
            for(DirectMessageMember mem: lstDirectMessageMember){
                msgMembers.add(mem.MemberId);
            }

            Set<String> ptUserIds = new Set<String>();
            for(User u : [SELECT Id FROM User WHERE ContactId IN :ptMembers]){
                ptUserIds.add(u.Id);
            }

            Map<ID,User> memberDetailMap = getMapOfUserdetail(msgMembers);//Retriving map of userIDs and user records
            
            for(DirectMessageMember member:lstDirectMessageMember){
                if(member.MemberId == userID) {
                    User initUser = memberDetailMap.get(userID);
                    initiatedUser = new SNI_FLDirectMessageWrapper.SNI_FLUserDetails(initUser.FirstName,initUser.LastName,initUser.Id,initUser.profile.name,initUser.userrole.name);
                }
                else if(!toUserIds.contains(member.MemberId)){
                    User userInvolved = memberDetailMap.get(member.MemberId);
                    if(userInvolved.profile.name == FAMILYENGAGEMENTPROFILE || userInvolved.profile.name == 'System Administrator'){
                        involvedUsers.add(new SNI_FLDirectMessageWrapper.SNI_FLUserDetails(userInvolved.FirstName,userInvolved.LastName,userInvolved.Id,userInvolved.profile.name,userInvolved.userrole.name));
                    } else if(userInvolved.profile.name == FAMILYLINKPROFILE &&  !toUserIds.contains(member.MemberId) && !ptUserIds.contains(member.MemberId)){
                        involvedUsers.add(new SNI_FLDirectMessageWrapper.SNI_FLUserDetails(userInvolved.FirstName,userInvolved.LastName,userInvolved.Id,userInvolved.profile.name,userInvolved.userrole.name));
                    }
                }
            }
            
            mapOfFeedComments = getCommentsForFeed(lstDirectMessageFeed, profileName);
            Map<ID,User> lstOfUser = getUserdetails();//Retriving map of userIDs and user records
           
            if(mapOfFeedComments != NULL){
                Map<ID,ContentVersion> attachments = getContentDocumentData(mapOfFeedComments.get(feedID));
                Map<ID,ContentDistribution> contentDistributions = getContentDistribution(mapOfFeedComments.get(feedID));
                for(FeedComment comment:mapOfFeedComments.get(feedID)){
                    User commentedUser = lstOfUser.get(comment.CreatedById);
                    ContentVersion version = attachments.get(comment.id);
                    ContentDistribution distribution = contentDistributions.get(comment.id);
                    
                    String userType;
                    if(commentedUser.profile.name == FAMILYENGAGEMENTPROFILE || commentedUser.profile.name == 'System Administrator'){
                        userType = 'AD';
                    } else {
                        if(commentedUser.profile.name == FAMILYLINKPROFILE && toUserIds.contains(commentedUser.Id)){
                            userType = 'PU';
                        } else if(commentedUser.profile.name == FAMILYLINKPROFILE &&  (!toUserIds.contains(commentedUser.Id) && ptUserIds.contains(commentedUser.Id))){
                            userType = 'PT';
                        } else if(commentedUser.profile.name == FAMILYLINKPROFILE &&  (!toUserIds.contains(commentedUser.Id) && !ptUserIds.contains(commentedUser.Id))){
                            userType = 'PU';
                        }
                    }

                    if(version != NULL){
                        lstFeeedComment.add(new SNI_FLDirectMessageWrapper.SNI_FL_DirectMessageFeedComments(comment.CommentBody,new SNI_FLDirectMessageWrapper.SNI_FLUserDetails(commentedUser.FirstName,commentedUser.LastName,commentedUser.Id,userType,commentedUser.userrole.name),comment.CreatedDate,
                                                                                                            version.ContentDocument.LatestPublishedVersionId,version.ContentDocument.FileExtension,version.ContentDocument.Title,true,distribution != NULL?distribution.ContentDownloadUrl:NULL));
                    }
                    else{
                        lstFeeedComment.add(new SNI_FLDirectMessageWrapper.SNI_FL_DirectMessageFeedComments(comment.CommentBody,new SNI_FLDirectMessageWrapper.SNI_FLUserDetails(commentedUser.FirstName,commentedUser.LastName,commentedUser.Id,userType,commentedUser.userrole.name),comment.CreatedDate,null,null,null,false,null));
                    }
                }
            }
            
            directMessageFeed = new SNI_FLDirectMessageWrapper.SNI_FLDirectMessageFeed(lstDirectMessageFeed[0].CreatedDate,lstDirectMessageFeed[0].LastModifiedDate,lstDirectMessageFeed[0].Body,lstDirectMessageFeed[0].Id,initiatedUser);            
            return new SNI_FLDirectMessageWrapper(involvedUsers,lstFeeedComment,lstDirectMessageFeed[0].Parent.Subject,directMessageFeed,flMessage,0,0,0,0,0);
            
        }catch(Exception ex){
            System.debug(TEAMNAME +ex.getMessage()+ LINENUMBER +ex.getLineNumber());
            return null;
        }
        
    }

    public static Map<Id,User> getMapOfUserdetail(Set<String> memList){
        try{
            Map<ID,User> lstOfUser = new Map<ID,User>([SELECT ID,FirstName,LastName,Profile.Name,UserRole.Name, ContactId FROM User WHERE Id IN :memList]);
            return lstOfUser;
        }catch(Exception ex){
            System.debug(TEAMNAME +ex.getMessage()+ LINENUMBER +ex.getLineNumber());
            return null;
        }
    }
         
    
    //Retrieve user records using a map structure. User id and each 
    //user record is retriving 
    public static Map<Id,User> getUserdetails(){
        try{
            Map<ID,User> lstOfUser = new Map<ID,User>([SELECT ID,FirstName,LastName,Profile.Name, UserRole.Name,ContactId FROM User]);
            return lstOfUser;
        }catch(Exception ex){
            System.debug(TEAMNAME +ex.getMessage()+ LINENUMBER +ex.getLineNumber());
            return null;
        }
    }
    
    //retrieves a mpa of directMessage feeds and related comments for each feed
    public static Map<ID,List<FeedComment>> getCommentsForFeed(List<DirectMessageFeed> lstDirectMsgFeeds, String profileName){
        
        Set<ID> feedIDs = new Set<ID>();
        Map<ID,List<FeedComment>> feedIdsWithComments = new Map<ID,List<FeedComment>>();
        
        try{
            for(DirectMessageFeed feed:lstDirectMsgFeeds){
                feedIDs.add(feed.id);
            }
            List<FeedComment> lstFeedComments = new List<FeedComment>();
            lstFeedComments = [SELECT Id,CreatedById,CreatedDate,RelatedRecordId,CommentBody,FeedItemId FROM FeedComment WHERE CreatedDate = LAST_N_DAYS:182 AND FeedItemId IN :feedIDs ORDER BY CreatedDate DESC LIMIT 10];
            
            
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
            System.debug(TEAMNAME +ex.getMessage()+ LINENUMBER +ex.getLineNumber());
            return null;
        }
    }
    
    //Retrieve a map of contentdocument records with comment id and contentdocument record
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
            System.debug(TEAMNAME +ex.getMessage()+ LINENUMBER +ex.getLineNumber());
            return null;
        }            
    }
    
    //Retrieve ContentDistribution records for each comment. A map data structure will be created with comment ids 
    //and each content distribution record 
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
            
            List<ContentDistribution> lstOfContentDistribution = [SELECT Id, ContentVersionId, ContentDownloadUrl FROM ContentDistribution WHERE ContentVersionId IN :relatedRecords];
            
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
            System.debug(TEAMNAME +ex.getMessage()+ LINENUMBER +ex.getLineNumber());
            return null;
        }
    }

 
}