/********************************************************************************* 
Class Name     : ProviderHomeTab.apxc
Description    : Based on selected program and loggedin "Provider User" getting a recent activity of Member Affilliation records 
Created By     : Karthik 
Created Date   : 12/21/2020 

Modification Log
---------------------------------------------------------------------------------- 
Developer                   Date                   Description

1.Karthik			        12/21/2020				Created class without body
----------------------------------------------------------------------------------            

*********************************************************************************/
public without sharing class ProviderHomeTab {
    Public static DateTime lastNDays = Date.Today().addDays(-Integer.ValueOf(14));
    
    @AuraEnabled
    public static List<membersdata> memberdata(string programname){
        Set<Id> initmemberIds = new Set<Id>();
        Set<Id> finalmemberIds = new Set<Id>();
        Set<Id> docIds = new Set<Id>();
        List<membersdata> memberData = new List<membersdata> ();
        List<Member_Affiliation__c> initList = [SELECT Member__r.Name,LastModifiedDate,CreatedDate,CreatedBy.FirstName,CreatedBy.LastName, Name, Id,Program_Offered__c FROM Member_Affiliation__c where  Provider_Affiliation__c =: programname];
        for(Member_Affiliation__c memAffiliation : initList){
            initmemberIds.add(memAffiliation.Id);
        }
        
        Map<String,MessageWrap> msgMemberMap = getMessages(programname); // Nanthu
        Set<Id> relatedToMem = new Set<Id>();
        
        List<Member_Affiliation__c> contentmemData=[SELECT Member__c,Member__r.Name,LastModifiedDate,CreatedDate,CreatedBy.FirstName,CreatedBy.LastName, Name, Id,Program_Offered__c,(SELECT Id, LinkedEntityId,ContentdocumentId,Contentdocument.Title,Contentdocument.lastmodifieddate,Contentdocument.lastmodifiedby.firstname,Contentdocument.createdby.lastname,Contentdocument.createdby.firstname,Contentdocument.CreatedDate,Contentdocument.lastmodifiedby.lastname,Contentdocument.CreatedBy.Profile_Name__c FROM ContentDocumentLinks ORDER BY Contentdocument.Createddate DESC LIMIT 1) FROM Member_Affiliation__c WHERE Id IN:initmemberIds AND Status__c = true ]; // where (Id IN :finalmemberIds OR Id IN:initmemberIds)   
        
        for(Member_Affiliation__c memAff : contentmemData){
            membersdata memData = new membersdata();
            
            
            if(memAff.ContentDocumentLinks.size()>0 && memAff.ContentDocumentLinks[0].ContentDocument.createddate >= lastNDays){
                /* Nanthu (AC/DC) */
                if(msgMemberMap.containsKey(memAff.Member__c)){
                    relatedToMem.add(memAff.Member__c);
                    MessageWrap msg = msgMemberMap.get(memAff.Member__c);
                    memData.messageBody = msg.messageBody;
                    memData.createDateTime = msg.createDateTime;
                    if(msg.createDateTime > memAff.ContentDocumentLinks[0].Contentdocument.CreateDdate){
                        memData.forsorting = msg.createDateTime;
                    } else {
                        memData.forsorting = memAff.ContentDocumentLinks[0].Contentdocument.CreateDdate;
                    }
                    memData.userFirstName = msg.userFirstName;
                    memData.userLastName = msg.userLastName;
                    memData.userProfile = msg.userProfile;
                    memData.relatedToMemberName = msg.memberName;
                    memData.relatedToMemberId = msg.memberId;
                } else {
                    memData.forsorting = memAff.ContentDocumentLinks[0].Contentdocument.CreateDdate;
                }
                /* End of Nanthu (AC/DC) */
                
                memData.membername = memAff.Member__r.Name;
                memData.memberId = memAff.Id;
                string docLastname = memAff.ContentDocumentLinks[0].Contentdocument.Createdby.lastname;
                if(memAff.ContentDocumentLinks[0].Contentdocument.Createdby.firstname != null && memAff.ContentDocumentLinks[0].Contentdocument.Createdby.Profile_Name__c == 'Center for Health Navigation'){ 
                    memData.doclastmodifiedbyname=memAff.ContentDocumentLinks[0].Contentdocument.Createdby.firstname + ' ' + docLastname.substring(0,1);
                }else if(memAff.ContentDocumentLinks[0].Contentdocument.Createdby.Profile_Name__c == 'Family Link Provider User' && memAff.ContentDocumentLinks[0].Contentdocument.Createdby.firstname != null){
                    memData.doclastmodifiedbyname = memAff.ContentDocumentLinks[0].Contentdocument.Createdby.firstname + ' ' + docLastname; 
                } else {
                    memData.doclastmodifiedbyname= docLastname;
                }
                DateTime docLastDate = memAff.ContentDocumentLinks[0].Contentdocument.CreateDdate;
                memData.doclastmodifiedbydate=docLastDate;
                memData.doctitle = memAff.ContentDocumentLinks[0].Contentdocument.Title;
                //Adding members data into list of wrapper Object
                memberData.add(memData);
            }
         }
        List<Member_Affiliation__c> memAffList = [SELECT Member__c,Id FROM Member_Affiliation__c WHERE Member__c IN :msgMemberMap.keySet() AND Provider_Affiliation__c =: programname];
        Map<String, String> memAffMap = new Map<String,String>();
        for(Member_Affiliation__c memAffiliation : memAffList){
            memAffMap.put(memAffiliation.Member__c,memAffiliation.Id);
        }
        for(String s : msgMemberMap.keySet()){
            membersdata memData = new membersdata();
            if(!relatedToMem.contains(s)){
                MessageWrap msg = msgMemberMap.get(s);
                memData.messageBody = msg.messageBody;
                memData.createDateTime = msg.createDateTime;
                memData.forsorting = msg.createDateTime;
                memData.userFirstName = msg.userFirstName;
                memData.userLastName = msg.userLastName;
                memData.userProfile = msg.userProfile;
                memData.relatedToMemberName = msg.memberName;
                memData.memberName = msg.memberName;
                memData.relatedToMemberId = msg.memberId;
                memData.memberId = memAffMap.get(msg.memberId);
                memberData.add(memData);
                
            }
        }
        
        for(Member_Affiliation__c memAff : contentmemData){
            membersdata memData = new membersdata();
            if(memAff.CreatedDate >= lastNDays){
                memData.membername = memAff.Member__r.Name;
                memData.memberId = memAff.Id;
                string createdName = memAff.CreatedBy.LastName;
                if(memAff.CreatedBy.firstname != null){
                    memData.memCreatedByName=memAff.CreatedBy.firstname + ' ' + createdName.substring(0,1);
                }else{
                    memData.memCreatedByName = createdName; 
                }
                
                memData.forsorting = memAff.CreatedDate;
                
                DateTime memCreatedDate = memAff.CreatedDate;
                memData.memCreatedDate=memCreatedDate;
               // Datetime day = (DateTime)memCreatedDate;
                //String dayOfWeek = day.format('EEEE');
                //Adding members data into list of wrapper Object
                memberData.add(memData); 
            }
            
        }
        List<Membersdata> sortedMemberData = new List<Membersdata> ();
        if(memberData.size() >0){
            Integer n = memberData.size();
            
            sortedMemberData = memberData;
            for (Integer i = 0; i < n; i++) {
                for (Integer j = 1; j < (n-i); j++) {   
                    // Sort by Descending order by ActivityDate. To sort by ascending order, change "<" to ">" in the line below.  
                    if ((Datetime)sortedMemberData[j-1].forsorting < (Datetime)sortedMemberData[j].forsorting) {   
                        Membersdata tmpValue = sortedMemberData[j-1];
                        sortedMemberData[j-1] = sortedMemberData[j];
                        sortedMemberData[j] = tmpValue;
                    }            
                }
            }
            return sortedMemberData; 
        } else{
            return null;
        }
        
    }
    
    /**
* 
* @param programname 
* @returns ` Map<Id,MessageWrap>`
* @author Nanthu - AC/DC
* @description US3272774 - retrive latest messages received in last 14 days based of select program/population
*/ 
    public static Map<String,MessageWrap> getMessages(String programname){
        
        Map<Object,Object> inputData = new Map<Object,Object>();
        inputData.put('objectName','Account');
        inputData.put('filterField','Related To');
        inputData.put('searchString','s');
        inputData.put('label','Related To');
        inputData.put('selectedProviderAffliation',programname);
        
        List<SNI_FL_ProviderMessageUtil.ProviderData> relatedMemLst = SNI_FL_ProviderMessageUtil.retrieveFamilyLinkProviderData(inputData);
        
        List<String> selectedIds= new List<String>();
        for(SNI_FL_ProviderMessageUtil.ProviderData dt : relatedMemLst){
            selectedIds.add(dt.value);
        }
        
        List<SNI_FL_Message__c> lstMessages =  SNI_FL_DirectMessageObjectQuery.getlstOfMessagesForRelatedToMember(UserInfo.getUserId(), selectedIds, false, programname, true);
        
        List<ID> dirMsgIds = SNI_FL_DirectMessageObjectQuery.getDirectMessageIdFromFeed(lstMessages);
        
        Map<String,MessageWrap> msgMemberMap = new Map<String,MessageWrap>();
        if(dirMsgIds != null){
            
            List<DirectMessageFeed> allDirectMessages = [SELECT Id,Parent.Id, Parent.Subject,Body,LastModifiedDate,CreatedDate,CreatedById, ParentId FROM DirectMessageFeed WHERE ParentId IN :dirMsgIds AND LastModifiedDate = LAST_N_DAYS:14 ORDER BY LastModifiedDate DESC];
            
            Set<ID> directMessageFeedIds = new Set<ID>();
            
            for(DirectMessageFeed feed:allDirectMessages){
                directMessageFeedIds.add(feed.Id);
            }
            
            List<SNI_FL_Message__c> lstOfMessages = [SELECT Id,Feed_Id__c,Program__c,Program__r.Name,Member_Id__c,Member_Id__r.Name FROM SNI_FL_Message__c WHERE Feed_Id__c IN :directMessageFeedIds];
            
            Map<Id,SNI_FL_Message__c> mapOfMsg = new Map<Id,SNI_FL_Message__c>();
            for(SNI_FL_Message__c fl : lstOfMessages){
                mapOfMsg.put(fl.Feed_Id__c, fl);
            }
            
            Map<Id,Id> memFeedMap = new Map<Id,Id>();
            List<Id> feedList = new List<Id>();
            
            Set<Id> sortList = new Set<Id>();
            for(DirectMessageFeed feed : allDirectMessages){
                SNI_FL_Message__c flMsg = mapOfMsg.get(feed.Id);
                if(!sortList.contains(flMsg.Member_Id__c)){
                    memFeedMap.put(flMsg.Member_Id__c,feed.Id);
                    feedList.add(feed.Id);
                    sortList.add(flMsg.Member_Id__c);
                } else {
                    continue;
                }
            }
            
            List<FeedComment> lstFeedComments = [SELECT Id, FeedItemId, CommentBody, CreatedDate, CreatedById  FROM FeedComment WHERE FeedItemId IN :feedList ORDER BY CreatedDate DESC];
            
            Map<Id,FeedComment> feedMap = new Map<Id,FeedComment>();
            Set<Id> sortFeedList = new Set<Id>();
            Set<Id> userIds = new Set<Id>();
            
            for(FeedComment cmt : lstFeedComments){
                if(!sortFeedList.contains(cmt.FeedItemId)){
                    feedMap.put(cmt.FeedItemId,cmt);
                    sortFeedList.add(cmt.FeedItemId);
                    userIds.add(cmt.CreatedById);
                } else {
                    continue;
                }
            }
            
            Map<ID,User> memberDetails = new Map<ID,User>([SELECT ID,FirstName,LastName,Profile.Name FROM User WHERE ID IN :userIds]);
            
            for(Id sortId : sortList){
                Id feedId = memFeedMap.get(sortId);
                FeedComment fdCmt = feedMap.get(feedId);
                User us = memberDetails.get(fdCmt.CreatedById);
                SNI_FL_Message__c flMsg = mapOfMsg.get(feedId);
                String lastName;
                if(us.Profile.Name == 'Center for Health Navigation' || us.Profile.Name == 'System Administrator'){
                    lastName = us.LastName.substring(0,1);
                } else {
                    lastName = us.LastName;
                }
                String str;
                String msgBody;
                
                if (!String.isBlank(fdCmt.CommentBody)) {
                    str = fdCmt.CommentBody.stripHtmlTags();
                    if(str.length() > 50){
                        msgBody = str.subString(0,50) + '...';
                    } else {
                        msgBody = str;
                    }
                } else {
                    msgBody = 'Posted a file';
                }
                
                msgMemberMap.put(flMsg.Member_Id__c, new MessageWrap(msgBody, fdCmt.CreatedDate, us.FirstName, lastName, us.Profile.Name, flMsg.Member_Id__r.Name, flMsg.Member_Id__c));
            }
        }
        
        return msgMemberMap;
    }
    
    /**
* @author Nanthu - AC/DC
* @description US3272774 - wrapping message data
*/  
    public class MessageWrap {
        @AuraEnabled public String messageBody {get;set;}
        @AuraEnabled public DateTime createDateTime {get;set;}
        @AuraEnabled public String userFirstName {get;set;}
        @AuraEnabled public String userLastName {get;set;}
        @AuraEnabled public String userProfile {get;set;}
        @AuraEnabled public String memberName {get;set;}
        @AuraEnabled public String memberId {get;set;}
        
        public MessageWrap(String messageBody,DateTime createDateTime,String userFirstName,String userLastName,String userProfile,String memberName,String memberId){
            this.messageBody = messageBody;
            this.createDateTime = createDateTime;
            this.userFirstName = userFirstName;
            this.userLastName = userLastName;
            this.userProfile = userProfile;
            this.memberName = memberName;
            this.memberId = memberId;
        }
    }
    
    public class Membersdata {
        @AuraEnabled
        public String membername {get;set;}
        @AuraEnabled
        public string doclastmodifiedbyname {get;set;}
        @AuraEnabled
        public string memCreatedByName {get;set;}
        @AuraEnabled
        public DateTime memCreatedDate {get;set;}
        @AuraEnabled
        public DateTime doclastmodifiedbydate {get;set;}
        @AuraEnabled
        public string doctitle {get;set;}
        @AuraEnabled
        public string lastmodifieddt {get;set;}
        @AuraEnabled
        public string docdayname {get;set;}
        @AuraEnabled
        public datetime forsorting {get;set;}
        @AuraEnabled
        public Id memberId {get;set;}
        /* Added by Nanthu (AC/DC) */
        @AuraEnabled public String messageBody {get;set;}
        @AuraEnabled public DateTime createDateTime {get;set;}
        @AuraEnabled public String userFirstName {get;set;}
        @AuraEnabled public String userLastName {get;set;}
        @AuraEnabled public String userProfile {get;set;}
        @AuraEnabled public String relatedToMemberName {get;set;}
        @AuraEnabled public String relatedToMemberId {get;set;}
        /* End of added by Nanthu (AC/DC) */
    }
}