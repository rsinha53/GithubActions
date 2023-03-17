/********************************************************************************* 
Class Name     : SNI_FLDirectMessageWrapper.apxc
Description    : Common wrapper class for ConnectAPI and Object query
Created By     : Sameera De Silva
Created Date   : 8/25/2020 

Modification Log
---------------------------------------------------------------------------------- 
Developer                   Date                   Description

1.Sameera De Silva			8/25/2020				Created class without body
2.Sameera De Silva			8/26/2020				Created Inner classes
3.Sameera De Silva          9/8/2020                Added SNI_FL_DirectMessageFeedComments inner class

----------------------------------------------------------------------------------            

*********************************************************************************/

public without sharing class SNI_FLDirectMessageWrapper { 
    
    @AuraEnabled public List<SNI_FLUserDetails> lstDirectMessageUsers;
    @AuraEnabled public List<SNI_FL_DirectMessageFeedComments> lstDirectMessageComments;
    @AuraEnabled public String directMssageSubject;
    @AuraEnabled public SNI_FLDirectMessageFeed directMessageFeed;
    @AuraEnabled public SNI_FLMessage flMessage;
    @AuraEnabled public Integer pageSize;
    @AuraEnabled public Integer pageNumber;
    @AuraEnabled public Integer totalRecords;
    @AuraEnabled public Integer recordStart;
    @AuraEnabled public Integer recordEnd;
    @AuraEnabled public Boolean isProviderMessage;
    
    public SNI_FLDirectMessageWrapper(List<SNI_FLUserDetails> lstDirectMessageUsers, List<SNI_FL_DirectMessageFeedComments> lstDirectMessageComments, String directMssageSubject, SNI_FLDirectMessageFeed lstdirectMessageFeed,SNI_FLMessage flMessage,Integer pageSize, Integer pageNumber,Integer totalRecords, Integer recordStart, Integer recordEnd){
                                          
        this.lstDirectMessageUsers = lstDirectMessageUsers;
        this.lstDirectMessageComments = lstDirectMessageComments;
        this.directMessageFeed = lstdirectMessageFeed;
        this.directMssageSubject = directMssageSubject;
        this.flMessage = flMessage;
        this.pageSize = pageSize;
        this.pageNumber = pageNumber;
        this.totalRecords = totalRecords;
        this.recordStart = recordStart;
        this.recordEnd = recordEnd;
    }

    public SNI_FLDirectMessageWrapper(List<SNI_FLUserDetails> lstDirectMessageUsers, SNI_FLDirectMessageFeed lstdirectMessageFeed,SNI_FLMessage flMessage,Integer pageSize, Integer pageNumber,Integer totalRecords, Integer recordStart, Integer recordEnd, Boolean isProviderMessage){
        this.lstDirectMessageUsers = lstDirectMessageUsers;
        this.directMessageFeed = lstdirectMessageFeed;
        this.flMessage = flMessage;
        this.pageSize = pageSize;
        this.pageNumber = pageNumber;
        this.totalRecords = totalRecords;
        this.recordStart = recordStart;
        this.recordEnd = recordEnd;
        this.isProviderMessage = isProviderMessage;
    }
    
    // Store Message Feed Related Data
    public class SNI_FLDirectMessageFeed{
        
        @AuraEnabled public DateTime directMessageFeedCreatedDateTime;
        @AuraEnabled public DateTime lastUpdatedDateTime;
        @AuraEnabled public SNI_FLUserDetails initiatedUser;
        @AuraEnabled public String directMessageFeedBody;
        @AuraEnabled public String directMessageFeedID;
        
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
        
        @AuraEnabled public String userID;
        @AuraEnabled public String userFirstName;
        @AuraEnabled public String userLastName;
        @AuraEnabled public String profileName;
        @AuraEnabled public String userRole;
        public SNI_FLUserDetails(String firstName,String lastName,String userID, string profName, string userRole){
            
            this.userID = userID;
            this.userFirstName = firstName;
            this.userLastName = lastName;
            this.profileName = profName;
            this.userRole = userRole;
        }

    }
     
    // Store data to uniquely identify initiated message with the account
    public class SNI_FLMessage{
        
        @AuraEnabled public String feedId;
        @AuraEnabled public String familyAccountName;
        @AuraEnabled public ID familyAccountID;
        @AuraEnabled public Boolean marked;
        @AuraEnabled public Boolean isRead;
        @AuraEnabled public Boolean isReadFamilyLink;
        @AuraEnabled public SNI_FL_PersonAccount member;
        @AuraEnabled public List<SNI_FL_ProviderTeam> providerTeam;
       
        public SNI_FLMessage(ID familyAccountID,String feedID,String familyAccountName,Boolean marked,Boolean isRead){
            this.familyAccountID = familyAccountID;
            this.feedId = feedID;
            this.familyAccountName = familyAccountName;
            this.marked =marked;
            this.isRead = isRead;
        }

        public SNI_FLMessage(String feedID,Boolean marked,Boolean isRead,SNI_FL_PersonAccount member, List<SNI_FL_ProviderTeam> providerTeam){
            this.feedId = feedID;
            this.marked =marked;
            this.isRead = isRead;
            this.member = member;
            this.providerTeam = providerTeam;
        }
    }

    public class SNI_FL_ProviderTeam{
        @AuraEnabled public String teamName{get;set;}
        @AuraEnabled public String teamId{get;set;}
        @AuraEnabled public List<SNI_FL_PersonAccount> members;

        public SNI_FL_ProviderTeam(String teamId, String teamName, List<SNI_FL_PersonAccount> members){
            this.teamName = teamName;
            this.members = members;
            this.teamId = teamId;
        }
    }

    public class SNI_FL_PersonAccount{
        @AuraEnabled public String firstName{get;set;}
        @AuraEnabled public String lastName{get;set;}
        @AuraEnabled public String id{get;set;}
        @AuraEnabled public String title{get;set;}

        public SNI_FL_PersonAccount(String firstName,String lastName,String id,String title){
            this.firstName = firstName;
            this.lastName = lastName;
            this.id = id;
            this.title = title;
        }
    }
    
    // Stores information related feeed comments
    public class SNI_FL_DirectMessageFeedComments{
        
        @AuraEnabled public String commentBody;
        @AuraEnabled public SNI_FLUserDetails commentedUser;
        @AuraEnabled public DateTime commentedDateTime;
        @AuraEnabled public Boolean isAttachmentAvailable;
        @AuraEnabled public String documentID;
        @AuraEnabled public String documentFileextension;
        @AuraEnabled public String documentTitle;
        @AuraEnabled public String contentDownloadURL;

        public SNI_FL_DirectMessageFeedComments(String cmtBody,SNI_FLUserDetails cmtUser,DateTime cmtDateTime,String documentID, String fileExtension,String title,Boolean isAttachmentAvailable,String contentDownloadURL) {
            
            this.commentBody = cmtBody;
            this.commentedUser = cmtUser;
            this.commentedDateTime = cmtDateTime;
            this.documentID = documentID;
            this.documentFileextension = fileExtension;
            this.documentTitle = title;
            this.isAttachmentAvailable = isAttachmentAvailable;
            this.contentDownloadURL = contentDownloadURL;
        }
        
    }
    
    // Store Message Feed Related Data
	public class DirectMessageFeed {
        @AuraEnabled public DateTime directMessageFeedCreatedDateTime;
        @AuraEnabled public SNI_FLUserDetails initatedUser;
        @AuraEnabled public String directMessageFeedBody;
        @AuraEnabled public String directMessageFeedID;
        @AuraEnabled public String currentPageToken;
        @AuraEnabled public String previousPageToken;
        @AuraEnabled public String nextPageToken;

        public DirectMessageFeed(DateTime feedCreatedDateTime, String feedBody, String feedID, SNI_FLUserDetails user) {
            this.directMessageFeedCreatedDateTime = feedCreatedDateTime;
            this.directMessageFeedBody = feedBody;
            this.directMessageFeedID = feedID;
            this.initatedUser = user;
        }

	}
    
    // Stores Comment data 
    public class DirectMessageComments {
        
        @AuraEnabled public DateTime commentCreatedDateTime;
        @AuraEnabled public Id commentID;
        @AuraEnabled public String commentBody;
        @AuraEnabled public String commentedUserFirstName;
        @AuraEnabled public String commentedUserLastName;
        @AuraEnabled public String commentedUserID;
        @AuraEnabled public String hovercomments;

		public DirectMessageComments(DateTime cmtCreatedDateTIme, String cmtBody, SNI_FLUserDetails user, Id commentID) {
			this.commentCreatedDateTime = cmtCreatedDateTIme;
			this.hovercomments = cmtBody.replaceAll('', '');
			this.commentBody = cmtBody;
			this.commentedUserFirstName = user.userFirstName;
			this.commentedUserLastName = user.userLastName;
			this.commentID = commentID;
			this.commentedUserID = user.userId;
		}
        
        public DirectMessageComments(Id commentedUserID, DateTime cmtCreatedDateTime, String cmtBody, SNI_FLUserDetails user){
            this.commentCreatedDateTime = cmtCreatedDateTime;
            this.commentBody = cmtBody;
            this.commentedUserFirstName = user.userFirstName;
            this.commentedUserLastName = user.userLastName;
            this.commentedUserID = commentedUserID;
        }

    }
    
    // stores information related to BackupAdvisor
    public class SNI_FL_BackupAdvisorWrap{
        
        @AuraEnabled public String Id;
        @AuraEnabled public String Advisor;
        @AuraEnabled public string ExistingId;

    }
     
    public class wrapperAccPermission{
        @AuraEnabled public string strName;
        @AuraEnabled Public List<string> setPermissionSet;
    }
    
    public class UserPermissionSet{
        @AuraEnabled public User userObj;
        @AuraEnabled Public List<PermissionSetAssignment> PermissionSet;
    }
    
    
}