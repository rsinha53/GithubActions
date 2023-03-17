/****************************************************************************** 
Class Name     : SNI_FL_DirectMessageObjectQuery.apxc
Description    : 
Created By     : Nanthavarman Lingeswaran - ACDC
Created Date   : 12/07/2020
******************************************************************************/

public without sharing class  SNI_FL_DirectMessageObjectQuery {
    
    public static final String USERID = UserInfo.getUserId();
    public static final String TEAMNAME = 'ACDC Exception ';
    public static final String LINENUMBER = 'LineNumber ';
    
    //Author:Nanthu - ACDC
    //US3079165 - Retrieve DirectMessages & ProviderMessages related to loggedin user(Advisor)
    // Retrieve FamilyLevel Messages and Provider level messages based on selected family and provider
    public static List<SNI_FL_DirectMessageObjectQuery.SNI_FLDirectMessageWrapper> retrieveDirectMessageList(Boolean isFamilyLevel, ID familyID,String loggedInAgentID,Integer pageNumber,Integer pageSize, Boolean isFlagged, Boolean isBackupAgent, Boolean isProviderMsgLevel, String selectedId, Boolean isUnread, Boolean isProvider){
        List<ID> lstOfDirectMessageIDs = new List<ID>();
        Set<ID> directMessageFeedIds = new Set<ID>();
        Map<Id,SNI_FL_Message__c> feedIdswithFlmessage = new Map<Id,SNI_FL_Message__c>();
        List<SNI_FL_DirectMessageObjectQuery.SNI_FLDirectMessageWrapper> lstofDirectMessages = new List<SNI_FLDirectMessageWrapper>();
        List<SNI_FL_Message__c> lstOfMessages = new List<SNI_FL_Message__c>();
        lstOfMessages.clear();
        feedIdswithFlmessage.clear(); 
        lstofDirectMessages.clear();
        String agentID;
        try{
            if(isProviderMsgLevel){
                if(Test.isRunningTest()){
                    Contact con = [SELECT Id FROM Contact WHERE AccountId =:familyID];
                    User us = [SELECT Id, Name FROM User WHERE ContactId = :con.Id];
                    agentID = us.Id;
                } else {
                    agentID = loggedInAgentID;
                }
            } else if(isFamilyLevel){
                agentID = [SELECT OwnerId FROM Account WHERE Id=:familyID].OwnerId;
            } else {
                agentID = loggedInAgentID;
            }
            lstOfDirectMessageIDs = getDirectMessagesId(isFamilyLevel,familyID,agentID,isFlagged,isProviderMsgLevel,isBackupAgent,selectedId,isUnread);
            
            if(!lstOfDirectMessageIDs.isEmpty()){
                Map<ID,List<SNI_FL_DirectMessageObjectQuery.SNI_FLUserDetails>> directMessageWithMembers = getMapOfDirectMessageIDswithMembers(lstOfDirectMessageIDs);
                
                if(directMessageWithMembers != NULL){
                    
                    Integer pSize = (Integer)pageSize;
                    Integer pNumber = (Integer)pageNumber;
                    Integer offset = (pNumber - 1) * pSize;
                    Integer recordStart = offset + 1;
                    
                    List<DirectMessageFeed> allDirectMessages = [SELECT Id,Parent.Id, Parent.Subject,Body,LastModifiedDate,CreatedDate,CreatedById, ParentId FROM DirectMessageFeed WHERE ParentId IN :directMessageWithMembers.keySet()  ORDER BY LastModifiedDate DESC];
                    
                    for(DirectMessageFeed feed:allDirectMessages){
                        directMessageFeedIds.add(feed.Id);
                    }
                    
                    if(isProviderMsgLevel){
                        lstOfMessages = [SELECT Id,Marked__c,(SELECT id,IsRead__c FROM SNI_FL_Message_Statuses__r WHERE Agent__c=:USERID),Feed_Id__c,Family_ID__c,Family_ID__r.Name,Program__c,Program__r.Name,Member_Id__c,Member_Id__r.Name FROM SNI_FL_Message__c WHERE Feed_Id__c IN :directMessageFeedIds];
                    } else if(isProvider){
                        lstOfMessages = [SELECT Id,Marked__c,(SELECT id,IsRead__c FROM SNI_FL_Message_Statuses__r WHERE Agent__c=:agentID),Feed_Id__c,Family_ID__c,Family_ID__r.Name,Program__c,Program__r.Name,Member_Id__c,Member_Id__r.Name FROM SNI_FL_Message__c WHERE Program__c != null AND Feed_Id__c IN :directMessageFeedIds];
                    } else {
                        lstOfMessages = [SELECT Id,Marked__c,(SELECT id,IsRead__c FROM SNI_FL_Message_Statuses__r WHERE Agent__c=:agentID),Feed_Id__c,Family_ID__c,Family_ID__r.Name,Program__c,Program__r.Name,Member_Id__c,Member_Id__r.Name,Family_ID__r.Member_Id__c FROM SNI_FL_Message__c WHERE Feed_Id__c IN :directMessageFeedIds];
                    }
                    
                    if(lstOfMessages.size()>0){
                        
                        for(SNI_FL_Message__c flMessage:lstOfMessages){
                            feedIdswithFlmessage.put(flMessage.Feed_Id__c,flMessage); 
                        }
                        
                        List<DirectMessageFeed> unreadMsgList = getSortedDirstMsgList(agentID,allDirectMessages,feedIdswithFlmessage,isProviderMsgLevel,isBackupAgent);
                        
                        Integer totalRecords = !unreadMsgList.isEmpty()?unreadMsgList.size():0;
                        Integer recordEnd = pSize * pNumber;
                        
                        Integer lastRecord;
                        if(totalRecords<=recordEnd){
                            lastRecord = totalRecords;
                        } else {
                            lastRecord = recordEnd;
                        }
                        List<DirectMessageFeed> totalDirectMessages = new List<DirectMessageFeed>();
                        for(Integer i = 1; i<=lastRecord; i++){
                            if(i >= recordStart && unreadMsgList.size() > 0){
                                totalDirectMessages.add(unreadMsgList[i-1]);
                                
                            }
                        }
                        
                        //Map<ID,User> lstOfUser = getUserdetails(totalDirectMessages);
                        /*Commented line 92 as thread initiator details will be now fetched based on the createdbyId of the first feed comment attached to the feed
Changed the map type to Map<ID,FeedComment> */
                        Map<ID,FeedComment> lstOfUser = getUserdetails(totalDirectMessages); //Added by Pratikshya 
                        lstofDirectMessages  = wrapDirectMessagesThroughIteration(pSize,pNumber,recordEnd,recordStart,totalRecords,lstOfUser,totalDirectMessages,directMessageWithMembers,feedIdswithFlmessage);
                        return lstofDirectMessages;
                        
                    }else{
                        return null;
                    }
                }else{
                    return null;
                }
            } else {
                return null;
            }
            
        } catch(Exception ex){
            
            System.debug(TEAMNAME+ex.getMessage()+LINENUMBER+ex.getLineNumber());
            return null;
            
        }
    }
    
    public static List<ID> getDirectMessagesId(Boolean isFamilyLevel,String familyID,String agentID,Boolean isFlagged, Boolean isProviderMsgLevel, Boolean isBackupAgent, String selectedId, Boolean isUnread){
        List<SNI_FL_Message__c> lstOfMessages = new List<SNI_FL_Message__c>();
        List<ID> dirMsgIds = new List<ID>();
        List<ID> lstOfDirectMessageIDs = new List<ID>();
        lstOfDirectMessageIDs.clear();
        lstOfMessages.clear();
        dirMsgIds.clear();
        
        User us = [SELECT Profile.Name, AccountId FROM USER WHERE Id =:agentID];
        
        try{
            if(isFamilyLevel){
                lstOfMessages = getlstOfMessagesForFamilyAccount(familyID,agentID,isFlagged);
                dirMsgIds = getDirectMessageIdFromFeed(lstOfMessages);
                return dirMsgIds;
            } else if(isProviderMsgLevel){
                lstOfMessages = getlstOfMessagesForFamilyMember(familyID,agentID,isFlagged,isProviderMsgLevel,isBackupAgent);
                dirMsgIds = getDirectMessageIdFromFeed(lstOfMessages);
                return dirMsgIds;
            } else if(selectedId != 'empty'){
                List<Id> selectedIds = new List<Id>();
                selectedIds.add(selectedId);
                lstOfMessages = getlstOfMessagesForRelatedToMember(agentID,selectedIds,isUnread,familyID,false);
                dirMsgIds = getDirectMessageIdFromFeed(lstOfMessages);
                
                return dirMsgIds;
            } else if(us.Profile.Name == 'Center for Health Navigation' || us.Profile.Name == 'System Administrator'){
                dirMsgIds = getDirectMessageIdForAgents(agentID,isFlagged);
                
                return dirMsgIds;
            } else {
                for(DirectMessageMember member : [SELECT DirectMessageId FROM DirectMessageMember WHERE MemberId = :agentID]){
                    lstOfDirectMessageIDs.add(member.DirectMessageId);
                }
                
                dirMsgIds = getDirectMessageIdForFamilyLink(lstOfDirectMessageIDs,isUnread,agentID,familyID,us);
                
                return dirMsgIds;
            }
        } catch(Exception ex){
            System.debug(TEAMNAME+ex.getMessage()+LINENUMBER+ex.getLineNumber());
            return null;
        }  
    }
    
    public static List<SNI_FL_Message__c> getlstOfMessagesForFamilyAccount(Id familyID,Id agentID, Boolean isFlagged){
        try{
            if(isFlagged == true){
                return [SELECT Id, (SELECT id,IsRead__c FROM SNI_FL_Message_Statuses__r WHERE Agent__c=:agentID),Feed_Id__c, Family_ID__c,Family_ID__r.Name,Marked__c,Family_ID__r.Member_Id__c FROM SNI_FL_Message__c WHERE Family_ID__c =:familyID AND Marked__c =true];
            }else{
                return [SELECT Id, (SELECT id,IsRead__c FROM SNI_FL_Message_Statuses__r WHERE Agent__c=:agentID),Feed_Id__c, Family_ID__c,Family_ID__r.Name,Marked__c,Family_ID__r.Member_Id__c FROM SNI_FL_Message__c WHERE Family_ID__c =:familyID];
            }
        }catch(Exception ex){
            System.debug(TEAMNAME+ex.getMessage()+LINENUMBER+ex.getLineNumber());
            return null;
        }
    }
    
    public static List<ID> getDirectMessageIdFromFeed(List<SNI_FL_Message__c> lstOfMessages){
        try{
            List<ID> feedIds = new List<ID>();
            if(!lstOfMessages.isEmpty()){
                for(SNI_FL_Message__c flMessage : lstOfMessages){
                    feedIds.add(flMessage.Feed_Id__c);
                }
            }
            
            List<DirectMessageFeed> directMessageFeeds = [SELECT ParentId FROM DirectMessageFeed WHERE Id IN :feedIds];
            List<ID> dirMsgIds = new List<ID>();
            if(!directMessageFeeds.isEmpty()){
                for(DirectMessageFeed directMessageFeed : directMessageFeeds){
                    dirMsgIds.add(directMessageFeed.ParentId);
                }
            }
            return dirMsgIds;
        }catch(Exception ex){
            System.debug(TEAMNAME+ex.getMessage()+LINENUMBER+ex.getLineNumber());
            return null;
        }
    }
    
    public static List<SNI_FL_Message__c> getlstOfMessagesForFamilyMember(Id providerAccountId, Id agentID, Boolean isFlagged, Boolean isProviderMsgLevel, Boolean isBackupAgent){
        List<PermissionSetAssignment> flPermission = [SELECT Id FROM PermissionSetAssignment  WHERE AssigneeId = :Userinfo.getUserId() AND PermissionSet.label =:system.label.SNI_FL_ManageProviderGroup limit 1];
        if(!flPermission.isEmpty()){
            return getSuperAdminMessagesForFamilyMember(providerAccountId, agentID, isFlagged, isProviderMsgLevel, isBackupAgent);
        } else {
            return getMessagesForFamilyMember(providerAccountId, agentID, isFlagged, isProviderMsgLevel, isBackupAgent);
        }
    }
    
    public static List<SNI_FL_Message__c> getSuperAdminMessagesForFamilyMember(Id providerAccountId, Id agentID, Boolean isFlagged, Boolean isProviderMsgLevel, Boolean isBackupAgent){
        try{ 
            if(isFlagged == true) {
                return [SELECT Id, (SELECT id,IsRead__c FROM SNI_FL_Message_Statuses__r WHERE Agent__c=:agentID),Feed_Id__c,Marked__c,Program__c,Member_Id__c FROM SNI_FL_Message__c WHERE Member_Id__c = :providerAccountId AND Marked__c =true ];
            }else{
                return [SELECT Id, (SELECT id,IsRead__c FROM SNI_FL_Message_Statuses__r WHERE Agent__c=:agentID),Feed_Id__c,Marked__c,Program__c,Member_Id__c FROM SNI_FL_Message__c WHERE Member_Id__c = :providerAccountId ];
            }
        }catch(Exception ex){
            System.debug(TEAMNAME+ex.getMessage()+LINENUMBER+ex.getLineNumber());
            return null;
        }
    }
    
    public static List<SNI_FL_Message__c> getMessagesForFamilyMember(Id providerAccountId, Id agentID, Boolean isFlagged, Boolean isProviderMsgLevel, Boolean isBackupAgent){
        try{ 
            List<ID> commonAffliationIds= advisorAndMemberRelatedAffliation(agentID,providerAccountId,isProviderMsgLevel,isBackupAgent);
            if(commonAffliationIds.size()>0){
                if(isFlagged == true) {
                    return [SELECT Id, (SELECT id,IsRead__c FROM SNI_FL_Message_Statuses__r WHERE Agent__c=:agentID),Feed_Id__c,Marked__c,Program__c,Member_Id__c FROM SNI_FL_Message__c WHERE Program__c IN :commonAffliationIds AND Member_Id__c = :providerAccountId AND Marked__c =true ];
                }else{
                    return [SELECT Id, (SELECT id,IsRead__c FROM SNI_FL_Message_Statuses__r WHERE Agent__c=:agentID),Feed_Id__c,Marked__c,Program__c,Member_Id__c FROM SNI_FL_Message__c WHERE Program__c IN :commonAffliationIds AND Member_Id__c = :providerAccountId];
                }
            } else{
                return null;
            }
            
        }catch(Exception ex){
            System.debug(TEAMNAME+ex.getMessage()+LINENUMBER+ex.getLineNumber());
            return null;
        }
    }
    
    public static List<SNI_FL_Message__c> getlstOfMessagesForRelatedToMember(Id agentID, List<Id> selectedIds, Boolean isUnread, String familyID, Boolean isRecentActivity){
        
        try{
            List<SNI_FL_Message__c> flMsgList = new List<SNI_FL_Message__c>();
            List<SNI_FL_Message__c> finalList = new List<SNI_FL_Message__c>();
            
            if(isUnread){
                flMsgList = [SELECT Id, (SELECT id FROM SNI_FL_Message_Statuses__r WHERE Agent__c=:agentID AND IsRead__c = false),Feed_Id__c,Member_Id__c FROM SNI_FL_Message__c WHERE Program__c = :familyID AND Member_Id__c = :selectedIds[0] ];
            } else if(isRecentActivity){
                system.debug('agent,program,member***'+ userinfo.getUserId() + familyID + selectedIds);
                flMsgList = [SELECT Id, (SELECT id FROM SNI_FL_Message_Statuses__r WHERE Agent__c=:agentID),Feed_Id__c,Member_Id__c FROM SNI_FL_Message__c WHERE Program__c = :familyID AND Member_Id__c IN :selectedIds ];
            } else {
                flMsgList = [SELECT Id, (SELECT id FROM SNI_FL_Message_Statuses__r WHERE Agent__c=:agentID),Feed_Id__c,Member_Id__c FROM SNI_FL_Message__c WHERE Program__c = :familyID AND Member_Id__c = :selectedIds[0] ];
            }
            
            for(SNI_FL_Message__c fl : flMsgList){
                List<SNI_FL_Message_Status__c> messageStatus = fl.SNI_FL_Message_Statuses__r;
                if(messageStatus.size()>0){
                    finalList.add(fl);
                }
            }
            return finalList;
        }catch(Exception ex){
            System.debug(TEAMNAME+ex.getMessage()+LINENUMBER+ex.getLineNumber());
            return null;
        }
    }
    
    public static List<ID> getDirectMessageIdForAgents(String agentID, Boolean isFlagged){
        List<ID> dirMsgIds = new List<ID>();
        List<ID> lstOfDirectMessageIDs = new List<ID>();
        List<ID> finalDirectMessageIDs = new List<ID>();
        List<SNI_FL_Message__c> flMessages = new List<SNI_FL_Message__c>();
        List<Id> flMessageIds = new List<Id>();
        dirMsgIds.clear();
        lstOfDirectMessageIDs.clear();
        flMessages.clear();
        flMessageIds.clear();
        finalDirectMessageIDs.clear();
        
        for(DirectMessageMember member : [SELECT DirectMessageId FROM DirectMessageMember WHERE MemberId = :agentID]){
            lstOfDirectMessageIDs.add(member.DirectMessageId);
        }
        
        Map<ID,DirectMessageFeed> feedsMap = new Map<ID,DirectMessageFeed>([SELECT Id, ParentId FROM DirectMessageFeed WHERE ParentId IN :lstOfDirectMessageIDs]);
        
        if(isFlagged == true){
            flMessages = [SELECT Feed_Id__c FROM SNI_FL_Message__c WHERE Family_ID__r.OwnerId =:agentID AND Marked__c = true];
            for(SNI_FL_Message__c flMessage : [SELECT Id, Feed_Id__c FROM SNI_FL_Message__c WHERE Feed_Id__c IN :feedsMap.keySet() AND Marked__c = true]){
                DirectMessageFeed getFeed = feedsMap.get(flMessage.Feed_Id__c);
                finalDirectMessageIDs.add(getFeed.ParentId);
            }
        } else {
            flMessages = [SELECT Feed_Id__c FROM SNI_FL_Message__c WHERE Family_ID__r.OwnerId =:agentID];
            finalDirectMessageIDs.addAll(lstOfDirectMessageIDs);
        }
        
        for(SNI_FL_Message__c fl: flMessages){
            flMessageIds.add(fl.Feed_Id__c);
        }
        
        for(DirectMessageFeed feed: [SELECT ParentId FROM DirectMessageFeed WHERE Id IN :flMessageIds]){
            finalDirectMessageIDs.add(feed.ParentId);
        }
        
        Set<Id> myset = new Set<Id>();
        myset.addAll(finalDirectMessageIDs);
        
        dirMsgIds.addAll(myset);
        
        return dirMsgIds;        
    }
    
    public static List<ID> getDirectMessageIdForFamilyLink(List<ID> lstOfDirectMessageIDs, Boolean isUnread, String agentID, String familyID, User us){
        
        List<ID> dirMsgIds = new List<ID>();
        dirMsgIds.clear();
        List<SNI_FL_Message_Status__c> flMessageStatuses = new List<SNI_FL_Message_Status__c>();
        flMessageStatuses.clear();
        
        Map<ID,DirectMessageFeed> feedsMap = new Map<ID,DirectMessageFeed>([SELECT Id, ParentId FROM DirectMessageFeed WHERE ParentId IN :lstOfDirectMessageIDs]);
        
        if(isUnread == true){
            flMessageStatuses = [SELECT SNI_FL_Message__r.Feed_Id__c FROM SNI_FL_Message_Status__c WHERE Agent__c=:agentID AND SNI_FL_Message__r.Program__c = :familyID AND SNI_FL_Message__r.Feed_Id__c IN :feedsMap.keySet() AND IsRead__c = false];
         } else if(us.Profile.Name == 'Care Advisor Connect Community User'){
            if(familyID == null || familyID == ''){
                Id  conId = [Select id,AccountId  from contact where AccountId=:us.AccountId].Id;
                List<String> accountIdList = new List<String>();                                  
                for(Account a : [SELECT Id,Member_Id__c,(SELECT Id,AccountId,ContactId FROM AccountContactRelations WHERE ContactId=:conId) FROM Account WHERE Id IN(SELECT AccountId FROM AccountContactRelation WHERE ContactId=:conId) AND Member_Id__c != Null]){
                    if(a.AccountContactRelations.size()>0){
                        accountIdList.add(a.Id);
                    }                                   
                }
                // below if condition is used for the non policy care team members - DE432384 - Nanthu(AC/DC)
                if(accountIdList.size() == 0){
                    List<SNI_FL_Care_Team_Member__c> careTeamLst = [SELECT SNI_FL_Family__c FROM SNI_FL_Care_Team_Member__c WHERE SNI_FL_Member__c = :us.AccountId AND SNI_FL_Status__c = 'Registered'];
                    accountIdList.add(careTeamLst[0].SNI_FL_Family__c);
                }    
                // end of DE432384 - Nanthu(AC/DC)
                flMessageStatuses = [SELECT SNI_FL_Message__r.Feed_Id__c FROM SNI_FL_Message_Status__c WHERE Agent__c=:agentID AND SNI_FL_Message__r.Family_ID__c = :accountIdList[0] AND SNI_FL_Message__r.Feed_Id__c IN :feedsMap.keySet()];
                
            } else {
                flMessageStatuses = [SELECT SNI_FL_Message__r.Feed_Id__c FROM SNI_FL_Message_Status__c WHERE Agent__c=:agentID AND SNI_FL_Message__r.Family_ID__c = :familyID AND SNI_FL_Message__r.Feed_Id__c IN :feedsMap.keySet()];
            }
        } else {
            flMessageStatuses = [SELECT SNI_FL_Message__r.Feed_Id__c FROM SNI_FL_Message_Status__c WHERE Agent__c=:agentID AND SNI_FL_Message__r.Program__c = :familyID AND SNI_FL_Message__r.Feed_Id__c IN :feedsMap.keySet()];
        }
        for(SNI_FL_Message_Status__c msgStatus : flMessageStatuses){
            DirectMessageFeed getFeed = feedsMap.get(msgStatus.SNI_FL_Message__r.Feed_Id__c);
            dirMsgIds.add(getFeed.ParentId);
        }
        
        return dirMsgIds;
    }
    
    public static Map<ID,List<SNI_FLUserDetails>> getMapOfDirectMessageIDswithMembers(List<ID> lstOfDirectMessages){
        
        try{
            
            Map<ID,List<SNI_FL_DirectMessageObjectQuery.SNI_FLUserDetails>> allDirecMessageMembers = new Map<ID,List<SNI_FL_DirectMessageObjectQuery.SNI_FLUserDetails>>(); 
            List<DirectMessageMember> lsOfDirectMessageMembers = [SELECT Id,DirectMessageId,MemberId FROM DirectMessageMember WHERE DirectMessageId IN :lstOfDirectMessages];
            
            List<Id> memberIds = new List<Id>();
            
            if(!lsOfDirectMessageMembers.isEmpty()){
                
                for(DirectMessageMember memId : lsOfDirectMessageMembers){
                    memberIds.add(memId.MemberId);
                }
                Set<ID> ids = new Set<ID>(memberIds);
                
                Map<ID,User> memberDetails = new Map<ID,User>([SELECT ID,FirstName,LastName,Profile.Name FROM User WHERE ID IN :ids]);
                
                for(DirectMessageMember directMsgMember:lsOfDirectMessageMembers){
                    User individualDetail = memberDetails.get(directMsgMember.MemberId);
                    
                    SNI_FL_DirectMessageObjectQuery.SNI_FLUserDetails memberInfo = new SNI_FL_DirectMessageObjectQuery.SNI_FLUserDetails(individualDetail.FirstName,individualDetail.LastName,directMsgMember.MemberId,individualDetail.Profile.Name);
                    
                    if(allDirecMessageMembers.containsKey(directMsgMember.DirectMessageId)){
                        
                        List<SNI_FL_DirectMessageObjectQuery.SNI_FLUserDetails> lstOfMemberDetails = allDirecMessageMembers.get(directMsgMember.DirectMessageId);
                        lstOfMemberDetails.add(memberInfo);
                        allDirecMessageMembers.put(directMsgMember.DirectMessageId,lstOfMemberDetails);
                        
                    }else{
                        
                        List<SNI_FL_DirectMessageObjectQuery.SNI_FLUserDetails> memDetail = new List<SNI_FL_DirectMessageObjectQuery.SNI_FLUserDetails>();
                        memDetail.add(memberInfo);
                        allDirecMessageMembers.put(directMsgMember.DirectMessageId,memDetail);
                    }
                }
                return allDirecMessageMembers;
                
            }else{
                return null;
            }
            
        }catch(Exception ex){
            System.debug(TEAMNAME+ex.getMessage()+LINENUMBER+ex.getLineNumber());
            return null;
        }  
    }
    
    //Sort the retrived all direct messages based on read and unread status
    public static List<DirectMessageFeed> getSortedDirstMsgList(String agentID,List<DirectMessageFeed> allDirectMessages,Map<ID,SNI_FL_Message__c> lstOffeedIDsforFamilyID,Boolean isProviderMsgLevel,Boolean isBackupAgent){
        List<DirectMessageFeed> unreadMsgList = new List<DirectMessageFeed>();
        unreadMsgList.clear();
        List<DirectMessageFeed> readMsgList = new List<DirectMessageFeed>();
        readMsgList.clear();
        List<DirectMessageFeed> totalDirectMessages = new List<DirectMessageFeed>();
        totalDirectMessages.clear();
        List<PermissionSetAssignment> flPermission = [SELECT Id FROM PermissionSetAssignment  WHERE AssigneeId = :Userinfo.getUserId() AND PermissionSet.label =:system.label.SNI_FL_ManageProviderGroup limit 1];
        try{
            List<ID> providerAffList = new List<ID>();
            List<ID> agentsCommonAffList = new List<ID>();
            providerAffList.clear();
            agentsCommonAffList.clear();
            
            if(!isBackupAgent){
                agentsCommonAffList = advisorAndMemberRelatedAffliation(agentID, null, isProviderMsgLevel, isBackupAgent);
            } else if(!isProviderMsgLevel){
                providerAffList = advisorAffliationList();
            }
            
            String profileName = [Select Profile.Name from User where Id=:agentID].Profile.Name;
            
            for(DirectMessageFeed directMsgFeed: allDirectMessages){
                
                SNI_FL_Message__c flMessage = lstOffeedIDsforFamilyID.get(directMsgFeed.id);
                
                List<SNI_FL_Message_Status__c> messageStatus = new List<SNI_FL_Message_Status__c>();
                
                messageStatus = flMessage?.SNI_FL_Message_Statuses__r;
                
                if(isProviderMsgLevel && !flPermission.isEmpty() && messageStatus.size() == 0){
                    readMsgList.add(directMsgFeed);
                } else if(messageStatus != null && messageStatus.size()>0){
                    if(!String.isBlank(flmessage.Program__c) && !isBackupAgent && agentsCommonAffList.contains(flMessage.Program__c)){
                        if(messageStatus[0].isRead__c == false) {
                            unreadMsgList.add(directMsgFeed);
                        } else {
                            readMsgList.add(directMsgFeed);
                        }   
                    } else if(!String.isBlank(flmessage.Program__c) && isBackupAgent && !isProviderMsgLevel &&  profileName != 'Family Link Provider User' && providerAffList.contains(flMessage.Program__c)){
                        
                        if(messageStatus[0].isRead__c == false) {
                            unreadMsgList.add(directMsgFeed);
                        } else {
                            readMsgList.add(directMsgFeed);
                        } 
                    } else if(String.isBlank(flmessage.Program__c) || isProviderMsgLevel || profileName =='Family Link Provider User'){
                        
                        if(messageStatus[0].isRead__c == false) {
                            unreadMsgList.add(directMsgFeed);
                        } else {
                            readMsgList.add(directMsgFeed);
                        } 
                    }
                }
                
            }
            
            return sortReadMsgListAndReturn(readMsgList,unreadMsgList);
            
        }catch(Exception ex){
            System.debug(TEAMNAME+ex.getMessage()+LINENUMBER+ex.getLineNumber());
            return null;
        } 
    }
    
    public static List<DirectMessageFeed> sortReadMsgListAndReturn(List<DirectMessageFeed> readMsgList,List<DirectMessageFeed> unreadMsgList){
        
        for(DirectMessageFeed readList: readMsgList){
            unreadMsgList.add(readList);
        }
        
        return unreadMsgList;
    }
    
    public static Map<ID,FeedComment> getUserdetails(List<DirectMessageFeed> totalDirectMessages){
        // List<Id> memberIds = new List<Id>(); //commented by Pratikshya. Thread initiatior details will be fecthed based on creator of 1st feed comment attached to the feed
        List<Id> feedItemIds = new List<Id>();
        map<Id,feedcomment> feedComMap = new map<Id,feedcomment>();
        /*for(DirectMessageFeed feed : totalDirectMessages){
memberIds.add(feed.CreatedById); //Commented By Pratikshya
}*/
        for(DirectMessageFeed feed : totalDirectMessages){
            feedItemIds.add(feed.Id); // Get the feed id of all directmessage feeds. Added By Pratikshya
        }
        // Get the first feedcomment associated with the feed. Added by Pratikshya
        for (DirectMessageFeed dm : [SELECT id,(SELECT id,createdbyid,FeedItemId from FeedComments ORDER BY CreatedDate ASC LIMIT 1)
                                     FROM DirectMessageFeed WHERE Id in: feedItemIds]){
                                         feedComMap.put(dm.id,dm.feedcomments); 
                                     }
        //Commented by Pratikshya
        /*Set<ID> ids = new Set<ID>(memberIds);
Map<ID,User> memberDetails = new Map<ID,User>([SELECT ID,FirstName,LastName,Profile.Name FROM User WHERE ID IN :ids]);
return memberDetails;*/
        return feedComMap;
    }
    
    public static List<SNI_FL_DirectMessageObjectQuery.SNI_FLDirectMessageWrapper> wrapDirectMessagesThroughIteration(Integer pSize,Integer pNumber,Integer recordEnd,Integer recordStart,Integer totalRecords,Map<ID,FeedComment> lstOfUser,List<DirectMessageFeed> totalDirectMessages,Map<ID,List<SNI_FL_DirectMessageObjectQuery.SNI_FLUserDetails>> directMessageWithMembers,Map<ID,SNI_FL_Message__c> feedIdswithFlmessage){
        List<SNI_FL_DirectMessageObjectQuery.SNI_FLDirectMessageWrapper> lstofDirectMessages = new List<SNI_FL_DirectMessageObjectQuery.SNI_FLDirectMessageWrapper>();
        lstofDirectMessages.clear();
        map<Id,Id> feedMap = new map<Id,Id>();
        map<Id,User> userMap = new map<Id,User>();
        for(feedcomment fd : lstOfUser.values()){
            feedMap.put(fd.feeditemid,fd.createdById);
        }
        List<User> users = [select id,firstname,lastname,profile.name from user where id =: feedMap.values()];
        for(User u : users){
            userMap.put(u.id,u);
        }
        
        for(DirectMessageFeed directMsgFeed:totalDirectMessages){
            
            List<SNI_FL_DirectMessageObjectQuery.SNI_FLUserDetails> lstOfInvolvedMembers = directMessageWithMembers.get(directMsgFeed.Parent.Id);
            // User feedCreatedUser = lstOfUser.get(directMsgFeed.CreatedById); // Commented By Pratikshya
            User feedCreatedUser = userMap.get(feedMap.get(directMsgFeed.Id)); //Added By Pratikshya
            SNI_FL_DirectMessageObjectQuery.SNI_FLUserDetails feedInitatedUser;
            
            feedInitatedUser = new SNI_FL_DirectMessageObjectQuery.SNI_FLUserDetails(feedCreatedUser.FirstName,feedCreatedUser.LastName,feedCreatedUser.id,feedCreatedUser.profile.name);
            SNI_FL_DirectMessageObjectQuery.SNI_FLDirectMessageFeed directMessageFeedObj = new SNI_FL_DirectMessageObjectQuery.SNI_FLDirectMessageFeed(directMsgFeed.CreatedDate,directMsgFeed.LastModifiedDate,directMsgFeed.Body,directMsgFeed.id,feedInitatedUser);
            SNI_FL_DirectMessageObjectQuery.SNI_FLMessage flmessage = createFLMessageWrapper(feedIdswithFlmessage,directMsgFeed);
            
            lstofDirectMessages.add(new SNI_FL_DirectMessageObjectQuery.SNI_FLDirectMessageWrapper(lstOfInvolvedMembers, directMsgFeed.Parent.Subject, directMessageFeedObj, flmessage, pSize, pNumber, totalRecords, recordStart, recordEnd));
            
        }
        return lstofDirectMessages;
    }
    
    public static SNI_FL_DirectMessageObjectQuery.SNI_FLMessage createFLMessageWrapper(Map<ID,SNI_FL_Message__c> feedIdswithFlmessage,DirectMessageFeed directMsgFeed){
        
        SNI_FL_Message__c flMessageRecord = feedIdswithFlmessage.get(directMsgFeed.Id);
        List<SNI_FL_Message_Status__c> messageStatus = flMessageRecord.SNI_FL_Message_Statuses__r;
        
        if(!String.isBlank(flMessageRecord.Program__c)){
            return getProviderFLMessagesRecord(directMsgFeed,flMessageRecord,messageStatus);
        } else {
            return getAgentFLMessagesRecord(directMsgFeed,flMessageRecord,messageStatus);
        }
    }
    
    ////US3304375 - 2021/24/2(sameera) Passing memberid
    ////US3245125 - 2021/02/26(pavithra) Passing Member's Family Id
    public static SNI_FL_DirectMessageObjectQuery.SNI_FLMessage getProviderFLMessagesRecord(DirectMessageFeed directMsgFeed,SNI_FL_Message__c flMessageRecord,List<SNI_FL_Message_Status__c> messageStatus){        
        String memberId;
        Map<Id,String> lstMemberId = getMemberIdOfProvider(flMessageRecord.Member_Id__c); 
        if(lstMemberId != NULL){
            for(Id memberIdRecord:lstMemberId.keySet()){                               
                memberId = lstMemberId.get(memberIdRecord);                
            }
        }
        return new SNI_FL_DirectMessageObjectQuery.SNI_FLMessage(directMsgFeed.id, flMessageRecord.Marked__c != null?flMessageRecord.Marked__c:null, messageStatus.size()>0?messageStatus[0].IsRead__c:true, flMessageRecord.Member_Id__c != null?flMessageRecord.Member_Id__r.Name:null,flMessageRecord.Program__c != null?flMessageRecord.Program__r.Name:null,true,memberId != null?memberId:null);
    }
    
    public static SNI_FL_DirectMessageObjectQuery.SNI_FLMessage getAgentFLMessagesRecord(DirectMessageFeed directMsgFeed,SNI_FL_Message__c flMessageRecord,List<SNI_FL_Message_Status__c> messageStatus){
        return new SNI_FL_DirectMessageObjectQuery.SNI_FLMessage(flMessageRecord != null?flMessageRecord.Family_ID__c:null,directMsgFeed.id,flMessageRecord != null?flMessageRecord.Family_ID__r.Name:null,flMessageRecord != null?flMessageRecord.Marked__c:null,messageStatus.size()>0?messageStatus[0].IsRead__c:false,false,flMessageRecord != null?flMessageRecord.Family_ID__r.Member_Id__c:null);
    }
    
    //To check loggedin user(advisor) affliated to a Provider Affiliation 
    public static List<ID> advisorAffliationList(){
        ID providerAffliationRecordType = Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName().get('Provider_Affiliation').getRecordTypeId();
        List<AccountTeamMember> agentRelatedAffiliations = [SELECT Id,AccountId FROM AccountTeamMember WHERE Account.RecordTypeId=:providerAffliationRecordType AND UserId=:USERID];
        List<ID> lstAgentAffiliations = new List<ID>();
        for(AccountTeamMember accTeam : agentRelatedAffiliations){
            lstAgentAffiliations.add(accTeam.AccountId);
        }
        
        return lstAgentAffiliations;
    } 
    
    //To check loggedin user(advisor) affliated to a Provider Affiliation 
    public static List<ID> advisorAndMemberRelatedAffliation(Id agentID,String providerId,Boolean isProviderMsgLevel,Boolean isBackupAgent){
        
        ID providerAffliationRecordType = Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName().get('Provider_Affiliation').getRecordTypeId();
        
        List<AccountTeamMember> agentRelatedAffiliations = [SELECT AccountId FROM AccountTeamMember WHERE Account.RecordTypeId=:providerAffliationRecordType AND UserId =: USERID];
        List<ID> lstAgentAffiliations = new List<ID>();
        for(AccountTeamMember accTeam : agentRelatedAffiliations){
            lstAgentAffiliations.add(accTeam.AccountId);
        }
        
        List<Member_Affiliation__c> providerRelatedAffiliations = new List<Member_Affiliation__c>();
        List<AccountTeamMember> backupAgentRelatedAffiliations = new List<AccountTeamMember>();
        List<ID> lstProviderOrBackupAgentAffiliations = new List<ID>();
        
        if(isProviderMsgLevel){
            providerRelatedAffiliations = [SELECT Provider_Affiliation__c FROM Member_Affiliation__c WHERE Member__c = :providerId];
            for(Member_Affiliation__c memAff : providerRelatedAffiliations){
                lstProviderOrBackupAgentAffiliations.add(memAff.Provider_Affiliation__c);
            }
        } else if(!isBackupAgent){
            backupAgentRelatedAffiliations = [SELECT AccountId FROM AccountTeamMember WHERE Account.RecordTypeId=:providerAffliationRecordType AND UserId = :agentID];
            for(AccountTeamMember accTeam : backupAgentRelatedAffiliations){
                lstProviderOrBackupAgentAffiliations.add(accTeam.AccountId);
            }
        }
        
        List<ID> finalList = new List<ID>();
        for(ID agentAffiliationID : lstAgentAffiliations){
            for(ID providerOrBackupAgentAffiliationID : lstProviderOrBackupAgentAffiliations){
                if(providerOrBackupAgentAffiliationID == agentAffiliationID){
                    finalList.add(agentAffiliationID);
                }
            }
        }
        return finalList;
    }
    
    // Store the direct messages
    public class SNI_FLDirectMessageWrapper { 
        
        @AuraEnabled public List<SNI_FLUserDetails> lstDirectMessageUsers{get;set;}
        @AuraEnabled public String directMssageSubject{get;set;}
        @AuraEnabled public SNI_FLDirectMessageFeed directMessageFeed{get;set;}
        @AuraEnabled public SNI_FLMessage flMessage{get;set;}
        @AuraEnabled public Integer pageSize{get;set;}
        @AuraEnabled public Integer pageNumber{get;set;}
        @AuraEnabled public Integer totalRecords{get;set;}
        @AuraEnabled public Integer recordStart{get;set;}
        @AuraEnabled public Integer recordEnd{get;set;}
        
        public SNI_FLDirectMessageWrapper(List<SNI_FLUserDetails> lstDirectMessageUsers,String directMssageSubject,SNI_FLDirectMessageFeed lstdirectMessageFeed,SNI_FLMessage flMessage,Integer pageSize,Integer pageNumber,Integer totalRecords, Integer recordStart, Integer recordEnd){
            
            this.lstDirectMessageUsers = lstDirectMessageUsers;
            this.directMessageFeed = lstdirectMessageFeed;
            this.directMssageSubject = directMssageSubject;
            this.flMessage = flMessage;
            this.pageSize = pageSize;
            this.pageNumber = pageNumber;
            this.totalRecords = totalRecords;
            this.recordStart = recordStart;
            this.recordEnd = recordEnd;
        }
    }
    
    // Store Message Feed Related Data
    public class SNI_FLDirectMessageFeed{
        
        @AuraEnabled public DateTime directMessageFeedCreatedDateTime{get;set;}
        @AuraEnabled public DateTime lastUpdatedDateTime{get;set;}
        @AuraEnabled public SNI_FLUserDetails initiatedUser{get;set;}
        @AuraEnabled public String directMessageFeedBody{get;set;}
        @AuraEnabled public String directMessageFeedID{get;set;}
        
        public SNI_FLDirectMessageFeed(DateTime feedCreatedDateTime,DateTime lastUpdatedTime,String feedBody,String feedID,SNI_FLUserDetails user){
            
            this.lastUpdatedDateTime = lastUpdatedTime;
            this.directMessageFeedCreatedDateTime = feedCreatedDateTime;
            this.directMessageFeedBody = feedBody;
            this.directMessageFeedID = feedID;
            this.initiatedUser = user;
        }
    }
    
    // Store User Related Data
    public class SNI_FLUserDetails{
        
        @AuraEnabled public String userID{get;set;}
        @AuraEnabled public String userFirstName{get;set;}
        @AuraEnabled public String userLastName{get;set;}
        @AuraEnabled public String profileName{get;set;}
        
        public SNI_FLUserDetails(String firstName,String lastName,String userID, string profName){
            
            this.userID = userID;
            this.userFirstName = firstName;
            this.userLastName = lastName;
            this.profileName = profName;
        }
    }
    
    // Store data to uniquely identify initiated message with the account
    public class SNI_FLMessage{
        
        @AuraEnabled public String feedId{get;set;}
        @AuraEnabled public String familyAccountName{get;set;}
        @AuraEnabled public ID familyAccountID{get;set;}
        @AuraEnabled public Boolean marked{get;set;}
        @AuraEnabled public Boolean isRead{get;set;}
        @AuraEnabled public String member{get;set;}
        @AuraEnabled public String program{get;set;}
        @AuraEnabled public Boolean isProviderMessage{get;set;}
        @AuraEnabled public String memberId{get;set;}
        
        //US3304375 - 2021/24/2(sameera) setting memberid
        public SNI_FLMessage(String feedID,Boolean marked,Boolean isRead,String member, String program, Boolean isProviderMessage, String memberId){
            this.feedId = feedID;
            this.marked =marked;
            this.isRead = isRead;
            this.member = member;
            this.program = program;
            this.isProviderMessage = isProviderMessage;
            this.memberId = memberId;
        }
        
        public SNI_FLMessage(ID familyAccountID,String feedID,String familyAccountName,Boolean marked,Boolean isRead,Boolean isProviderMessage, String memberId){
            this.familyAccountID = familyAccountID;
            this.feedId = feedID;
            this.familyAccountName = familyAccountName;
            this.marked =marked;
            this.isRead = isRead;
            this.isProviderMessage = isProviderMessage;
            this.memberId = memberId;
        }
    }
    
    //Author:Nanthu - ACDC
    //US3131860 - Family Link: Provider Message Page Search Bar (web/mobile)
    //Retrieve search input keyword related members
    public static List <SNI_FL_DirectMessageObjectQuery.RecordsData> getAllRelatedToMembers(String searchKeyWord){
        
        List<SNI_FL_DirectMessageObjectQuery.RecordsData> recordsDataList = new List<RecordsData>();
        String recordType = 'Individual';
        String query = 'Find {'+searchKeyWord+'} IN Name Fields RETURNING Account (Id, Name  Where RecordType.Name  = \'Individual\')';             
        List<List <sObject>> searchList = search.query(query);                
        Account[] aclist = ((Account[])searchList[0]);                
        for (Account a : aclist) {                    
            recordsDataList.add(new SNI_FL_DirectMessageObjectQuery.RecordsData(a.Name, a.Id));                    
        }  
        return recordsDataList;
    }
    
    public class RecordsData {
        @AuraEnabled public String label{get;set;}
        @AuraEnabled public String value{get;set;}
        
        public RecordsData(String label, String value) {
            this.label = label;
            this.value = value;
        }
    }
    
    //Author:Nanthu - ACDC
    //US3121164 - Family Link: Provider Message Mark as unread (web/mobile)
    //Retrieve boolean value
    @AuraEnabled
    public static Boolean markAsUnread(String feedId){
        try { 
            List <SNI_FL_Message_Status__c> lstflMsg = [SELECT Id, IsRead__c FROM SNI_FL_Message_Status__c WHERE SNI_FL_Message__r.Feed_Id__c = :feedId AND Agent__c =:UserInfo.getUserId()];
            
            if(lstflMsg.size()>0){
                lstflMsg[0].IsRead__c = false; 
                
                update lstflMsg; 
                return true; 
            }
            return false;
            
        } catch(exception ex) {
            System.debug(TEAMNAME+ex.getMessage()+LINENUMBER+ex.getLineNumber());
            return false; 
        } 
    } 
    
    /**
* US3245125 - 2021/02/26
* @param personAccountId 
* @author Pavithra
* @returns `Map<Id,String>`
* @description retrieve Member Ids from PersonId
*/    
    private static Map<Id,String> getMemberIdOfProvider(String personAccountId){
        
        try{
            Map<Id,String> memberIdAffliations = new Map<Id,String>();
            
            if(personAccountId != NULL){
                List<Member_Affiliation__c> maf = [SELECT Member__c, Member_Id__c FROM Member_Affiliation__c WHERE Member__c=:personAccountId AND Member_Id__c != NULL];
                if(maf != NULL){
                    for(Member_Affiliation__c affliation: maf){
                        memberIdAffliations.put(affliation.Member__c,affliation.Member_Id__c);
                    }
                    return memberIdAffliations;
                }
                return memberIdAffliations;
            }else{
                return null;
            }
        }catch(Exception ex){
            System.debug(ex.getStackTraceString());
            System.debug(ex.getMessage());
            System.debug(ex.getLineNumber());
            return null;
        }
        
        
    }
}