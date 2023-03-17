public class SENSAPI_MessagingUtility {
    
    //Get directMessageFeed Details through directmessagefeedId
    public static list<directMessageFeed> getDirectMsgFeed(String dfeedId){
        list<DirectMessageFeed> feedlist = [SELECT Id,CreatedDate,CreatedById,Parent.Subject,Body,LastModifiedDate,
                                            (SELECT Id FROM FeedComments ORDER BY CreatedDate DESC LIMIT 1)
                                            FROM DirectMessageFeed WHERE id=:dfeedId];
        return feedlist;
    }
    
    //Get message status through directmessagefeedId
    public static list<SNI_FL_Message_Status__c> getMessageStatus(String dfeedId,String fromUserId){
        list<SNI_FL_Message_Status__c> flMessageStatus = [select id,IsRead__c,agent__c,agent__r.name from SNI_FL_Message_Status__c where
                                                          SNI_FL_Message__r.Feed_Id__c=:dfeedId];
        list<SNI_FL_Message_Status__c> integrationUserMsgList = new list<SNI_FL_Message_Status__c>();
        list<SNI_FL_Message_Status__c> toUsersMsgList = new list<SNI_FL_Message_Status__c>();
        for(SNI_FL_Message_Status__c msg : flMessageStatus){
            if(msg.agent__c == UserInfo.getUserId()){
                integrationUserMsgList.add(msg);
            }
            else{
                toUsersMsgList.add(msg);
            }
        }
        delete integrationUserMsgList;
        return toUsersMsgList;
    }
    
    // Post Direct Message Feed with file and link Feed to the message tab
    public static String postThreadwithfile(String messageBody,String subject,List<Id> listOfUserIds,String uploadedFiledID,ID familyAccount,Map<String,Object> messageRequest,String fromUserId){
        List<string> notifyUserIds = new list<string>();
        notifyUserIds = listOfUserIds.clone();
        if(String.isNotBlank(fromUserId)){
            listOfUserIds.add(fromUserId);
            system.debug('listOfUserIds is'+listOfUserIds);
        }
        // Define the FeedItemInput object to pass to postFeedElement
        ConnectApi.FeedItemInput feedItemInput = new ConnectApi.FeedItemInput();
        ConnectApi.TextSegmentInput textSegmentInput = new ConnectApi.TextSegmentInput();
        if(messageBody != null){
            textSegmentInput.text = messageBody;
        }
        
        // The MessageBodyInput object holds the text in the post
        ConnectApi.MessageBodyInput messageBodyInput = new ConnectApi.MessageBodyInput();
        messageBodyInput.messageSegments = new List < ConnectApi.MessageSegmentInput > ();
        messageBodyInput.messageSegments.add(textSegmentInput);
        feedItemInput.body = messageBodyInput;  
        
        //Direct Message Capability
        ConnectApi.DirectMessageCapabilityInput dmInput = new ConnectApi.DirectMessageCapabilityInput();
        if(subject != null){
            dmInput.subject = subject;
        }
        dmInput.membersToAdd = listOfUserIds;
        
        //File Input Capability // Commented part uncommented
        ConnectApi.FileIdInput fileIdInput = new ConnectApi.FileIdInput();
        if(uploadedFiledID != null){
            fileIdInput.id = uploadedFiledID;
        }
        ConnectApi.FilesCapabilityInput fileInput = new ConnectApi.FilesCapabilityInput();
        fileInput.items = new List <ConnectApi.FileIdInput> ();
        List <ConnectApi.FileIdInput> lstFileId = new List <ConnectApi.FileIdInput> ();
        lstFileId.add(fileIdInput);
        fileInput.items = lstFileId;
        
        // The FeedElementCapabilitiesInput object holds the capabilities of the feed item.
        ConnectApi.FeedElementCapabilitiesInput feedElementCapabilitiesInput = new ConnectApi.FeedElementCapabilitiesInput();
        feedElementCapabilitiesInput.directMessage = dmInput;
        if(uploadedFiledID != null){
            feedElementCapabilitiesInput.files = fileInput;
        }
        feedItemInput.capabilities = feedElementCapabilitiesInput;
        
        // Post the feed item. 
        ConnectApi.FeedElement feedElement = ConnectApi.ChatterFeeds.postFeedElement( SNI_FLDirectMessageConnectAPI.getCommunityId(), feedItemInput);
        
        if (String.isNotEmpty(feedElement.id)) {    
            system.debug('feed element is'+feedElement.id);
            SENSAPI_MessagingUtility.postCommentByUser(feedElement.id,messageBody,uploadedFiledID,fromUserId);
            SNI_FLDirectMessageConnectAPI.addToFLMessagetbl(feedElement.id,familyAccount,listOfUserIds,null,messageRequest);
            if(notifyUserIds!=null && notifyUserIds.size()>0){
                sendCustomNotificationInFuture(messageBody,subject,notifyUserIds,uploadedFiledID);
            }
        }
        return feedElement.id;
    }
    
   
    public static void sendCustomNotificationInFuture(String messageBody, String subject, List<String> notifyUserIds, String uploadedFiledID)
    {  
         System.enqueueJob(new SENSAPI_CustomNotificationQueueable(messageBody,subject,notifyUserIds,uploadedFiledID));
    }

    public static void postCommentByUser(String feedID,String commentMessage,String uploadedFiledID,String fromUserId){
        List<contentVersion> cversion = [SELECT id from contentVersion where contentdocumentid =: uploadedFiledID];
            feedcomment feedComm =  new feedcomment();
            feedComm.feedItemId = feedId;
            feedComm.CreatedById = fromUserId;
            feedComm.commentBody= commentMessage;
            if(cversion.size()>0){
                feedComm.RelatedRecordId = cversion[0].id;
            }
            insert feedComm;
    }
}