/********************************************************************************* 
Class Name     : SNI_FLDirectMessageConnectAPI.apxc
Description    : Handling connect API related functions
Created By     : Sameera De Silva
Created Date   : 8/25/2020

Modification Log
---------------------------------------------------------------------------------- 
Developer                   Date                   Description

1.Sameera De Silva          8/25/2020               Created class without body
2.Sameera De Silva          8/25/2020               Adding method methods without method defintions
3.Nanthavarman Lingeswaran  9/21/2020               Added sending new message functionality
4.Nanthavarman Lingeswaran  11/19/2020              Adding new message notification functionality from FamilyLink
----------------------------------------------------------------------------------            

*********************************************************************************/

public without sharing class SNI_FLDirectMessageConnectAPI {
     
    public static Savepoint sp = null;

    private static final String TEAMNAME = 'ACDC Exception ';
    private static final String LINE = ' Line: ';

    //Create a new database savepoint for rollback
    //Author: Sameera De Silva (ACDC)
    public static void setSavePoint(){
        if(sp == null){
            sp = Database.setSavepoint();
            
        }  
    }
    
    //Save new message to DB
    //US3376756 - sameera(added messageRequest parameter)
    public static Boolean agentNewMessage(ID familyAccount, List<ID> lstOfMessageToUsers, String subject, String messageBody, String uploadedFiledID,Map<String,Object> messageRequest) {
        setSavePoint(); //Initiate a savepoint

        List<Id> listOfUserIds = new List<Id>();
        List<User> lstOfToUsers = new List<User>();
        List<Id> tempLstOfMessageToUsers = new List<Id>();
        if(Test.isRunningTest()){
            for(Id u : lstOfMessageToUsers){
            listOfUserIds.add(u);
        	}
        }else{
            if(!lstOfMessageToUsers.isEmpty()) {
                List<Account> familyAccList = [SELECT Id, Name, OwnerId,Owner.UserRole.Name FROM Account WHERE Id = :familyAccount];
                //Added to show messages to advisor if he is added as recipient  
                for(Id personAccId : lstOfMessageToUsers) {     
                    if(!familyAccList.isEmpty() && String.isNotBlank(familyAccList[0].OwnerId) && personAccId != familyAccList[0].OwnerId && personAccId != UserInfo.getUserId()) {
                        string objId = String.valueOf(PersonAccId).substring(0,3);
                        
                        if(objId =='005'){
                           listOfUserIds.add(PersonAccId); // Family Partners
                          }else{
                             tempLstOfMessageToUsers.add(PersonAccId); // Care Team Members
                          }   
                  }  
                }   
                  
               lstOfToUsers = [SELECT Id, AccountId FROM User WHERE AccountId IN :tempLstOfMessageToUsers]; 
               for(User u : lstOfToUsers){
                listOfUserIds.add(u.Id);

           }
          }   
        }  
        
        try {
            if (uploadedFiledID != NULL && uploadedFiledID != 'undefined') {
                //US3128709(add null argument)
                //US3376756 - sameera(passing messageRequest argument)
               return postAFeedElementWithAttachment(messageBody,subject,listOfUserIds,uploadedFiledID,familyAccount,null,messageRequest);
            }
            else {
                //US3376756 - sameera(passing messageRequest argument)
                return postAFeedElementWithoutAttachment(messageBody,subject,listOfUserIds,familyAccount,null,messageRequest);
            }
        } catch(Exception ex) {
            Database.rollback(sp);//Rollback if any  Exception
            System.debug(TEAMNAME+ex.getMessage()+LINE+ex.getLineNumber());
             
            return false;
        } 
    }
    
    //Insert a new record to SNI FL Message Object to track family and the direct message
    //US3376756 - sameera(adding messageRequest parameter)
    public static Boolean addToFLMessagetbl(String feedElementID, ID familyAccount,List<ID> listOfUserIds, Map<Object,Object> inputData,Map<String,Object> messageRequest) {
    
        try {

            SNI_FL_Message__c flMessageRecord = new SNI_FL_Message__c();

            if(inputData != null){
                Map<Object,Object> relatedTomember = inputData.get('relatedToUsers')!=''?(Map<Object,Object>)inputData.get('relatedToUsers'):null;
                String program;
                Boolean isFLPovider = (Boolean)inputData.get('isFLPovider');

                if(isFLPovider == true){
                    String selectedProgram = (String)inputData.get('providerAffliation');
                    program = selectedProgram;
                } else {
                    Map<Object,Object> selectedProgram  = (Map<Object,Object>)inputData.get('providerAffliation');
                    program = (String)selectedProgram.get('value');

                }
                        
                flMessageRecord.Feed_Id__c = feedElementID;
                flMessageRecord.Member_Id__c = relatedTomember!=null?(String)relatedTomember.get('value'):null;
                flMessageRecord.Program__c = program;

                List<Object> userList = (List<Object>)inputData.get('recipients');
                Map<String, String> lstToUsers = new Map<String, String>();
                for(Object a:userList){
                    Map<Object,Object> val = (Map<Object,Object>)a;
                    if((String)val.get('userType') == 'PU' && !lstToUsers.containsKey('toUserList')){
                        lstToUsers.put('toUserList',(String)val.get('value'));

                    } else if ((String)val.get('userType') == 'PU' && lstToUsers.containsKey('toUserList')){
                        lstToUsers.put('toUserList', lstToUsers.get('toUserList') + ';' + (String)val.get('value'));
                    
                    }
                }
                if(lstToUsers.containsKey('toUserList')){
                    flMessageRecord.ProviderUser_List__c = lstToUsers.get('toUserList');
                }

            }else{
                flMessageRecord.Feed_Id__c = feedElementID;
                flMessageRecord.Family_ID__c = familyAccount;
            }

            Database.SaveResult saveResult = Database.insert(flMessageRecord);

            if (saveResult.isSuccess()) {
                SNI_FL_ProviderNewMessageController.createMessageProviderTeam(saveResult.getId(),sp);//creates SNI_FL_Message_Provider_Team records
                SNI_FL_ThreeWayCommunicationController.createNewMessageRequest(messageRequest,saveResult.getId());//US3376756 - sameera(creating new message request record)
                return addToFLMessageStatustbl(saveResult.getId(),listOfUserIds);
            }else{
                Database.rollback(sp);//Rollback if any dml error
                return false;
            }

        } catch(Exception ex) {
            Database.rollback(sp);//Rollback if any exceptions
            System.debug(TEAMNAME+ex.getMessage()+LINE+ex.getLineNumber());
            return false;
        }
    }
    
    
    //Insert a new record to SNI FL Message Status Object
    public static Boolean addToFLMessageStatustbl(Id flMsgId,List<ID> listOfUserIds) {
        List<SNI_FL_Message_Status__c> lstMessageStatus = new List<SNI_FL_Message_Status__c>();
        lstMessageStatus.clear();
        
        try {
            SNI_FL_Message_Status__c flMessage = new SNI_FL_Message_Status__c();
            flMessage.SNI_FL_Message__c  = flMsgId;
            flMessage.Agent__c  = Userinfo.getUserId();
            flMessage.IsRead__c = True;
            lstMessageStatus.add(flMessage);

            for(Id userID:listOfUserIds){
                SNI_FL_Message_Status__c flMessageStatus = new SNI_FL_Message_Status__c();
                flMessageStatus.SNI_FL_Message__c  = flMsgId;
                flMessageStatus.Agent__c  = userID;
                flMessageStatus.IsRead__c = false;
                lstMessageStatus.add(flMessageStatus);
            }
            
            List<Database.SaveResult> saveResult = Database.insert(lstMessageStatus);
            for(Database.SaveResult sr:saveResult){
                if(!sr.isSuccess()){
                    Database.rollback(sp);
                    return false;
                }
            }
            return true;
        } catch(Exception ex) {
            Database.rollback(sp);//Rollback if any exception
            System.debug(TEAMNAME+ex.getMessage()+LINE+ex.getLineNumber());
            return false;
        }
    }

    // get Community ID
    public static String getCommunityId() {
        List < Network > customCommunity = [select Id, name from network where name = 'Care Advisor Connect' ];
        if (customCommunity != null && customCommunity.size() > 0) {
            return customCommunity[0].Id;
        }
        return null;
    }

    public static void postComment(String feedID,String commentMessage){
        
        try{
            String communityId = getCommunityId();
            ConnectApi.CommentInput input = new ConnectApi.CommentInput();

            ConnectApi.TextSegmentInput textSegment = new ConnectApi.TextSegmentInput();
            textSegment.text = commentMessage;

            ConnectApi.MessageBodyInput messageInput = new ConnectApi.MessageBodyInput();
            messageInput.messageSegments = new List < ConnectApi.MessageSegmentInput > ();
            messageInput.messageSegments.add(textSegment);
            input.body = messageInput;

            ConnectApi.ChatterFeeds.postCommentToFeedElement(communityId, feedID, input, null);
        }catch(Exception ex){
            System.debug(TEAMNAME+ex.getMessage()+LINE+ex.getLineNumber());
            Database.rollback(sp);//Rollback if any exception
        }
                             
    }
    
    public static void postCommentWithAttachement(String feedID,String commentMessage, String uploadedFiledID){
        String communityId = getCommunityId();
        ConnectApi.CommentInput input = new ConnectApi.CommentInput();

        ConnectApi.TextSegmentInput textSegment = new ConnectApi.TextSegmentInput();
        textSegment.text = commentMessage;

        ConnectApi.MessageBodyInput messageInput = new ConnectApi.MessageBodyInput();
        messageInput.messageSegments = new List < ConnectApi.MessageSegmentInput > ();
        messageInput.messageSegments.add(textSegment);
        input.body = messageInput;

        ConnectApi.CommentCapabilitiesInput commentCapabilitiesInput = new ConnectApi.CommentCapabilitiesInput();
        ConnectApi.ContentCapabilityInput contentCapabilityInput = new ConnectApi.ContentCapabilityInput();

        contentCapabilityInput.contentDocumentId = uploadedFiledID;
        commentCapabilitiesInput.content = contentCapabilityInput;
        input.capabilities = commentCapabilitiesInput;

        ConnectApi.Comment commentRep = ConnectApi.ChatterFeeds.postCommentToFeedElement(communityId, feedID, input, null);     

        if (commentRep != NULL) {
            SNI_FLDirectMessageObjectQuery.createContentDistribution(uploadedFiledID); // Create downloadable link
        }else{
            Database.rollback(sp);//Rollback if any exception
        }
        
    }
    
    public static void deleteFiles(String uploadedFileId){
        List<ContentDocument> cdlist = [SELECT Id, Title FROM ContentDocument WHERE Id = :uploadedFileId];
        if(!cdlist.isEmpty()) //Checking list has values before deleting 
        delete cdlist[0];
    }
    
    //Validating attachment when sending a reply 
    public static SNI_FLDirectMessageWrapper.DirectMessageComments validatepostNewCommentAttachment(String feedElementId, String msgText, String fileId) {
        if (!String.isBlank(fileId)) {
            return postNewCommentWithAttachement(feedElementId, msgText, fileId);
        } else {
        
            return postNewComment(feedElementId, msgText);
        }
    }
    
    public static SNI_FLDirectMessageWrapper.DirectMessageComments postNewCommentWithAttachement(String feedElementId, String msgText, String documentID) {

        String communityId = getCommunityId();
        ConnectApi.CommentInput commentInput = new ConnectApi.CommentInput();
        ConnectApi.MessageBodyInput messageBodyInput;
        ConnectApi.TextSegmentInput textSegmentInput;

        if (String.isNotEmpty(msgText)) {

            messageBodyInput = new ConnectApi.MessageBodyInput();
            textSegmentInput = new ConnectApi.TextSegmentInput();

            messageBodyInput.messageSegments = new List < ConnectApi.MessageSegmentInput > ();
            textSegmentInput.text = msgText;
            messageBodyInput.messageSegments.add(textSegmentInput);
            commentInput.body = messageBodyInput;
        }

        ConnectApi.CommentCapabilitiesInput commentCapabilitiesInput = new ConnectApi.CommentCapabilitiesInput();
        ConnectApi.ContentCapabilityInput contentCapabilityInput = new ConnectApi.ContentCapabilityInput();

        contentCapabilityInput.contentDocumentId = documentID;
        commentCapabilitiesInput.content = contentCapabilityInput;
        commentInput.capabilities = commentCapabilitiesInput;
        ConnectApi.Comment commentRep = ConnectApi.ChatterFeeds.postCommentToFeedElement(communityId, feedElementId, commentInput, null);

        if (commentRep != NULL) {
            SNI_FLDirectMessageObjectQuery.createContentDistribution(documentID); // Create downloadable link
            SNI_FLDirectMessageObjectQuery.updateMessageStatus(feedElementId);
            SNI_FLDirectMessageWrapper.DirectMessageComments cmt = getCommentsFromApi(commentRep);
            return cmt;
        } else {
            return null;
        }
    }
    
    public static SNI_FLDirectMessageWrapper.DirectMessageComments postNewComment(String feedElementId, String msgText) {
        String communityId = getCommunityId();
        ConnectApi.CommentInput input = new ConnectApi.CommentInput();
        ConnectApi.MessageBodyInput messageInput = new ConnectApi.MessageBodyInput();
        ConnectApi.TextSegmentInput textSegment = new ConnectApi.TextSegmentInput();
        messageInput.messageSegments = new List < ConnectApi.MessageSegmentInput > ();
        textSegment.text = msgText;
        messageInput.messageSegments.add(textSegment);
        input.body = messageInput;
        ConnectApi.Comment commentRep = ConnectApi.ChatterFeeds.postCommentToFeedElement(communityId, feedElementId, input, null);
        if (commentRep != NULL) {
            SNI_FLDirectMessageObjectQuery.updateMessageStatus(feedElementId);
            SNI_FLDirectMessageWrapper.DirectMessageComments cmt = getCommentsFromApi(commentRep);
            return cmt;
        } else {
            return null;
        }
    }


    public static SNI_FLDirectMessageWrapper.DirectMessageComments getCommentsFromApi(ConnectApi.Comment comment) {
        String message = getMessagebodyFromApi(comment.body.messageSegments);
        if (comment.capabilities != null && comment.capabilities.content != null) {
            message += '<a href="' + comment.capabilities.content.downloadUrl + '">' + comment.capabilities.content.title + '.' + comment.capabilities.content.fileExtension + '</a>';
        }
        return new SNI_FLDirectMessageWrapper.DirectMessageComments(comment.createdDate, message, new SNI_FLDirectMessageWrapper.SNI_FLUserDetails(comment.user.firstName, comment.user.lastName, comment.user.id,null,null), comment.id);
    }
      
    public static String getMessagebodyFromApi(List < ConnectApi.MessageSegment > messageSegments) {
        String message = '';
        for (ConnectApi.MessageSegment msgSegment: messageSegments) {
            if (msgSegment instanceof ConnectApi.HashtagSegment) {
                ConnectApi.HashtagSegment hashtagOutput = (ConnectApi.HashtagSegment) msgSegment;
                message += hashtagOutput.tag;
            } else if (msgSegment instanceof ConnectApi.InlineImageSegment) {
                ConnectApi.InlineImageSegment imageSeg = (ConnectApi.InlineImageSegment) msgSegment;
                message += '<img src="' + imageSeg.url + ' data-fileid="" alt="' + imageSeg.altText + '">';
            } else if (msgSegment instanceof ConnectApi.LinkSegment) {
                ConnectApi.LinkSegment linkOutput = (ConnectApi.LinkSegment) msgSegment;
                message += linkOutput.url;
            } else if (msgSegment instanceof ConnectApi.MarkupBeginSegment) {
                ConnectApi.MarkupBeginSegment markUpBegin = (ConnectApi.MarkupBeginSegment) msgSegment;
                message += '<' + markUpBegin.htmlTag + '>';
            } else if (msgSegment instanceof ConnectApi.MarkupEndSegment) {
                ConnectApi.MarkupEndSegment markUpEnd = (ConnectApi.MarkupEndSegment) msgSegment;
                message += '</' + markUpEnd.htmlTag + '>';
            } else if (msgSegment instanceof ConnectApi.MentionSegment) {
                ConnectApi.MentionSegment mentionOutput = (ConnectApi.MentionSegment) msgSegment;
                message += mentionOutput.record.id;
            } else if (msgSegment instanceof ConnectApi.TextSegment) {
                ConnectApi.TextSegment textOutput = (ConnectApi.TextSegment) msgSegment;
                message += textOutput.text;
            }
        }
        return message;
    }

    //Save new message to DB
    //US3376756 - sameera(added messageRequest parameter)
    public static Boolean backupAgentNewMessage(ID familyAccount, List<ID> lstOfMessageToUsers, String subject, String messageBody, String uploadedFiledID, Boolean isBackupAgentView,Map<String,Object> messageRequest) {
        setSavePoint(); //Initiate a savepoint

        List<Id> listOfUserIds = new List<Id>();
        List<User> lstOfToUsers = new List<User>();
        List<Id> tempListOfToUsers = new List<Id>();
        List<Account> family = new List<Account>();
        List<String> notifyUserIds = new List<string>();
        family = [SELECT Id, Name, OwnerId FROM Account WHERE Id = :familyAccount];
        for(Id PersonAccId : lstOfMessageToUsers){
            if(PersonAccId==family[0].OwnerId) {
                listOfUserIds.add(PersonAccId);
            } else {
                string objId = String.valueOf(PersonAccId).substring(0,3);
                if(objId=='005'){
                    listOfUserIds.add(PersonAccId); // Family Partners
                }else{
                    tempListOfToUsers.add(PersonAccId); // Care Team Members
                }
            }
        }

        lstOfToUsers = [SELECT Id, AccountId FROM User WHERE AccountId IN :tempListOfToUsers]; 
        for(User u : lstOfToUsers){
            listOfUserIds.add(u.Id);
            notifyUserIds.add(u.Id);
        }

        try {
            if (uploadedFiledID != NULL && uploadedFiledID != 'undefined') {
                //US3128709(add null argument)
                //US3376756 - sameera(passing messageRequest argument)
                if(postAFeedElementWithAttachment(messageBody,subject,listOfUserIds,uploadedFiledID,familyAccount,null,messageRequest)){
                    sendCustomNotification(messageBody,subject,notifyUserIds,uploadedFiledID);
                    return true;
            }
                    return false;
                   }else{
                //US3376756 - sameera(passing messageRequest argument)
                       if(postAFeedElementWithoutAttachment(messageBody,subject,listOfUserIds,familyAccount,null,messageRequest)){
                           sendCustomNotification(messageBody,subject,notifyUserIds,uploadedFiledID);
                           return true;
            }
                       return false;
                   }
        } catch(Exception ex) {
            Database.rollback(sp);//Rollback if any  Exception
            System.debug(TEAMNAME+ex.getMessage()+LINE+ex.getLineNumber());
             
            return false;
        } 
    }

    //Save new messages from FamilyLink
    //Author:Sameera ACDC
    public static Boolean familyLinkeNewMessage(ID familyAccount, List<ID> lstOfMessageToUsers, String subject, String messageBody, String uploadedFiledID){
    
        try{

            List<Id> listOfUserIds = new List<Id>();
            List<User> lstOfToUsers = new List<User>();
            List<Id> tempListOfToUsers = new List<Id>();
            List<Account> family = new List<Account>();
            List<string> notifyUserIds = new List<string>();
            family = [SELECT Id, Name, OwnerId FROM Account WHERE Id = :familyAccount];
            for(Id PersonAccId : lstOfMessageToUsers){
                if(PersonAccId==family[0].OwnerId) {
                    listOfUserIds.add(PersonAccId); //adding family advisor...
                    notifyUserIds.add(family[0].OwnerId);
                    
                } else {
                    string objId = String.valueOf(PersonAccId).substring(0,3);
                    if(objId=='005'){
                        listOfUserIds.add(PersonAccId); // Family Partners
        		notifyUserIds.add(PersonAccId);
                    }else{
                        tempListOfToUsers.add(PersonAccId); // Care Team Members
                    }
                }
            }

            lstOfToUsers = [SELECT Id, AccountId FROM User WHERE AccountId IN :tempListOfToUsers]; 
            for(User u : lstOfToUsers){
                listOfUserIds.add(u.Id);
            }

            if (uploadedFiledID != NULL && uploadedFiledID != 'undefined') {
                //US3128709(add null argument)
                //US3376756 - sameera(passing null argument)
                if(postAFeedElementWithAttachment(messageBody,subject,listOfUserIds,uploadedFiledID,familyAccount,null,null)){
                   sendCustomNotification(messageBody,subject,notifyUserIds,uploadedFiledID);
                   return true;
                }
                return false;
            }else{
                //US3376756 - sameera(passing null argument)
                if(postAFeedElementWithoutAttachment(messageBody,subject,listOfUserIds,familyAccount,null,null)){
                   sendCustomNotification(messageBody,subject,notifyUserIds,uploadedFiledID);
                   return true;
                }
                return false;
            }

            
        }catch(Exception ex){
            System.debug(TEAMNAME+ex.getMessage()+LINE+ex.getLineNumber());
            return false;
        }
    }
	//Family Partner logic
	public static Boolean familyPartnerNewMessage(ID familyAccount, List<ID> lstOfMessageToUsers, String subject, String messageBody, String uploadedFiledID, Map<String,Object> messageRequest) {
        setSavePoint(); //Initiate a savepoint

        List<Id> listOfUserIds = new List<Id>();
        List<User> lstOfToUsers = new List<User>();
        List<Id> tempListOfToUsers = new List<Id>();
        List<Account> family = new List<Account>();
        List<String> notifyUserIds = new List<string>();
        family = [SELECT Id, Name, OwnerId FROM Account WHERE Id = :familyAccount];
        for(Id PersonAccId : lstOfMessageToUsers){
            if(PersonAccId==family[0].OwnerId) {
                listOfUserIds.add(PersonAccId); //adding advisor
            } else {
                string objId = String.valueOf(PersonAccId).substring(0,3);
                if(objId=='005' && PersonAccId!=userinfo.getUserId()){
                    listOfUserIds.add(PersonAccId); // Family Partners
                }else{
                    tempListOfToUsers.add(PersonAccId); // Care Team Members
                }
                
            }
        }

        lstOfToUsers = [SELECT Id, AccountId FROM User WHERE AccountId IN :tempListOfToUsers]; 
        for(User u : lstOfToUsers){
            listOfUserIds.add(u.Id);
            notifyUserIds.add(u.Id);
        }

        try {
            if (uploadedFiledID != NULL && uploadedFiledID != 'undefined') {
                if (postAFeedElementWithAttachment(messageBody,subject,listOfUserIds,uploadedFiledID,familyAccount,null,messageRequest)){
                    if(notifyUserIds!=null && notifyUserIds.size()>0){
                        sendCustomNotification(messageBody,subject,notifyUserIds,uploadedFiledID);
                    }
                    return true;
                }
                    return false;
            }
            else {
                if(postAFeedElementWithoutAttachment(messageBody,subject,listOfUserIds,familyAccount,null,messageRequest)){
                    if(notifyUserIds!=null && notifyUserIds.size()>0){
                        sendCustomNotification(messageBody,subject,notifyUserIds,uploadedFiledID);
                    }
                    return true;
                }
                return false;
            }
        } catch(Exception ex) {
            Database.rollback(sp);//Rollback if any  Exception
            System.debug(TEAMNAME+ex.getMessage()+LINE+ex.getLineNumber());
             
            return false;
        } 
    }
    
    //Author:Sameera ACDC
    //US3128709(added "providerData" parameter for provider messages)
    //US3376756 - sameera(adding messageRequest parameter)
    public static Boolean postAFeedElementWithAttachment(String messageBody,String subject,List<Id> listOfUserIds,String uploadedFiledID,ID familyAccount, Map<Object,Object> providerData,Map<String,Object> messageRequest){
        setSavePoint(); //Initiate a savepoint

        try{
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
            fileIdInput.id = uploadedFiledID;

            ConnectApi.FilesCapabilityInput fileInput = new ConnectApi.FilesCapabilityInput();
            fileInput.items = new List <ConnectApi.FileIdInput> ();
            List <ConnectApi.FileIdInput> lstFileId = new List <ConnectApi.FileIdInput> ();
            lstFileId.add(fileIdInput);
            fileInput.items = lstFileId;

            // The FeedElementCapabilitiesInput object holds the capabilities of the feed item.
            ConnectApi.FeedElementCapabilitiesInput feedElementCapabilitiesInput = new ConnectApi.FeedElementCapabilitiesInput();
            feedElementCapabilitiesInput.directMessage = dmInput;
            feedElementCapabilitiesInput.files = fileInput;
            feedItemInput.capabilities = feedElementCapabilitiesInput;

            // Post the feed item. 
            ConnectApi.FeedElement feedElement = ConnectApi.ChatterFeeds.postFeedElement(getCommunityId(), feedItemInput);
            
            if (String.isNotEmpty(feedElement.id) && providerData==null) {                  
                postCommentWithAttachement(feedElement.id,messageBody,uploadedFiledID);                 
                return addToFLMessagetbl(feedElement.id, familyAccount,listOfUserIds,null,messageRequest);//US3376756 - sameera(passing messageRequest argument)

            }else if (String.isNotEmpty(feedElement.id) && providerData!=null) {  
                
                postCommentWithAttachement(feedElement.id,messageBody,uploadedFiledID);
                return addToFLMessagetbl(feedElement.id, familyAccount,listOfUserIds,providerData,null);//US3376756 - sameera(passing null argument)
            }
            else{
                Database.rollback(sp);//Rollback if any dml error
                return false;
            }

        }catch(Exception ex) {
            Database.rollback(sp);//Rollback if any  Exception
            System.debug(TEAMNAME+ex.getMessage()+LINE+ex.getLineNumber());
            return false;
        } 
    }

    //Author:Sameera ACDC
    public static Boolean postAFeedElementWithoutAttachment(String messageBody,String subject,List<Id> listOfUserIds,ID familyAccount,Map<Object,Object> providerData,Map<String,Object> messageRequest){
        setSavePoint(); //Initiate a savepoint
        try{

            // Define the FeedItemInput object to pass to postFeedElement
            ConnectApi.FeedItemInput feedItemInput = new ConnectApi.FeedItemInput();
            ConnectApi.TextSegmentInput textSegmentInput = new ConnectApi.TextSegmentInput();

            textSegmentInput.text = messageBody;
            
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
			system.debug('members::::'+ listOfUserIds);
            // The FeedElementCapabilitiesInput object holds the capabilities of the feed item.
            ConnectApi.FeedElementCapabilitiesInput feedElementCapabilitiesInput = new ConnectApi.FeedElementCapabilitiesInput();
            feedElementCapabilitiesInput.directMessage = dmInput;
            feedItemInput.capabilities = feedElementCapabilitiesInput;
            system.debug('check' + ConnectApi.Organization.getSettings().features.chatter);
            // Post the feed item. 
            ConnectApi.FeedElement feedElement = ConnectApi.ChatterFeeds.postFeedElement(getCommunityId(), feedItemInput);
            
            if (String.isNotEmpty(feedElement.id) && providerData==null) {      
                                         
                postComment(feedElement.id,messageBody);          
                return addToFLMessagetbl(feedElement.id, familyAccount,listOfUserIds,null,messageRequest);//US3376756 - sameera(passing messageRequest argument)

            }else if (String.isNotEmpty(feedElement.id) && providerData!=null) {  
                
                postComment(feedElement.id,messageBody);               
                return addToFLMessagetbl(feedElement.id, familyAccount,listOfUserIds,providerData,null);//US3376756 - sameera(passing null argument)

            } else{
                Database.rollback(sp);//Rollback if any dml error
                return false;
            }

        }catch(Exception ex) {
            Database.rollback(sp);//Rollback if any  Exception
            System.debug(TEAMNAME+ex.getMessage()+LINE+ex.getLineNumber());
            return false;
        } 

    }

    public static void sendCustomNotification(String messageBody, String subject, List<String> toUsers, String uploadedFiledID){
        
        String targetId = system.label.ACDC_DummyID ;
        try{
            Set<String> toList = new Set<String>();
            for(String str: toUsers){
               toList.add(str);
            }
            String sub = '';

            if (!String.isBlank(subject)) {
                if(subject.length() > 50){
                    sub = subject.subString(0,50) + '...';
                } else {
                    sub = subject;
                }
            } else {
                if (messageBody != 'Posted a file') {
                    sub = 'No Subject';
                } else {
                    sub = 'Attachment Sent';
                }
            }

            CustomNotificationType notificationType = [SELECT ID FROM CustomNotificationType WHERE DeveloperName ='SNI_FL_Message_Notification'];
            
            Messaging.CustomNotification notification = new Messaging.CustomNotification();
            notification.setNotificationTypeId(notificationType.ID);
            notification.setTargetId(targetId);
            notification.setTitle(Userinfo.getName() + ' sent you a message');
            notification.setBody(sub);
            //notification.send(toList);

            for (User u : [Select Id, MobilePhone, FirstName From User where Id IN: toUsers]) {
                if(u.MobilePhone != null){
                    new SNI_FL_Notification_Center().sendSMSNotification(u.MobilePhone, u.FirstName);
                }
            }
 
        }catch(Exception ex){
            System.debug(TEAMNAME +'- Method:SNI_FL_CustomNotification '+ex.getMessage()+LINE+ex.getLineNumber());
        }

    }
      
}