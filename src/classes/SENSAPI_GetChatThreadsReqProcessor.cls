/*------------------------------------------------------------
Author:       	Tushar Kaore
Description:  	Processor class for "GET Chat Threads" API
User Story: 	US4940911

Test Class:    SENSAPI_GetChatThreadsReqProcessorTest
History
Date            Author              Comments
-------------------------------------------------------------
11-07-2022      Tushar Kaore      	Created
------------------------------------------------------------*/
public without sharing class SENSAPI_GetChatThreadsReqProcessor implements IRestRequestProcessor {
    SENSAPI_GetChatThreadsRequest request;
    SENSAPI_GetChatThreadsResponse responseDetails;
    
    
    //instance variables 
    List<Id> dirMsgIds = new List<Id>();
    Map<Id,DirectMessageFeed> dirMsgFeedMap = new Map<Id,DirectMessageFeed>();
    Map<Id,DirectMessageFeed> dirMsgFeedMapWithFirstComment = new Map<Id,DirectMessageFeed>();
    Map<Id,SNI_FL_Message__c> flMessagesMap =new map<id,SNI_FL_Message__c>();
    Map<Id,List<SNI_FL_Message_Status__c>> feedIdAndFlMsgStatusesMap = new map<id,List<SNI_FL_Message_Status__c>>();
    Map<Id,SNI_FL_Message__c> feedIdAndFlMsgMap = new Map<Id,SNI_FL_Message__c>();
    Integer totalUnreadThreads = 0;
    
    //process request and return response
    public IRestResponseWrapper process(String jsonRequest){

        try{   
            responseDetails = new SENSAPI_GetChatThreadsResponse();
            initProcessor(jsonRequest);
            if(validateRequest()){ //validate request  
                String userId = request.userSensId;
                Boolean noUserThreads = false;
                
                List<User> user = [SELECT Id,AccountId,ContactId,IsActive FROM User WHERE Id =:userId LIMIT 1];
                if(user.size() > 0  && user[0].IsActive == true){
                    
                    List<DirectMessageMember> dirMsgMembers = [SELECT Id,DirectMessageId,MemberId FROM DirectMessageMember WHERE MemberId=:userId];
                    if(dirMsgMembers.size()>0){
                        for(DirectMessageMember dirMsgMember : dirMsgMembers){
                            dirMsgIds.add(dirMsgMember.DirectMessageId);
                        }
                        /*
                         * LastModifiedDate field on the DirectMessageFeed stores the CreatedDate of the last message of the given thread.
                         * Thus it is used to fetch the threads with activity in Last 6 months and order based on latest message 
                         */ 
                        List<DirectMessageFeed> dirMsgFeeds = [SELECT Id,Title,CreatedBy.Name,CreatedDate,CreatedById,Parent.Subject,
                                                               ParentId,Body,LastModifiedDate,InsertedById, 
                                                               (SELECT Id, CreatedById, CreatedBy.Name, CreatedDate, CommentBody FROM FeedComments ORDER BY CreatedDate DESC LIMIT 1)
                                                               FROM DirectMessageFeed WHERE ParentId IN: dirMsgIds
                                                              	AND LastModifiedDate = LAST_N_DAYS:180 ORDER BY LastModifiedDate DESC];
                        for(DirectMessageFeed dirMsgFeed : dirMsgFeeds){
                            dirMsgFeedMap.put(dirMsgFeed.Id,dirMsgFeed);
                        }
                        // Getting the FL_Message records for the feeds where user is part of
                        List<SNI_FL_Message__c> flMessages = [SELECT Id,Feed_Id__c,Family_ID__c,Family_ID__r.Name FROM SNI_FL_Message__c WHERE 
                                                      		  Feed_Id__c IN:dirMsgFeedMap.keyset()];
                        if(flMessages.size()>0){
                            
                            for(SNI_FL_Message__c flMsg :flMessages ){
                                if(flMsg.Family_ID__c != null){
                                    flMessagesMap.put(flMsg.Id,flMsg);
                                    if(flMsg.Feed_Id__c != null){
                                        feedIdAndFlMsgMap.put(flMsg.Feed_Id__c, flMsg);
                                    } 
                                }
                            }
                            //getting FL_Message_Status records for the feeds where user is part of. 
                            //This includes the FL_Message_Status records of other participants as well
                            List<SNI_FL_Message_Status__c> flMessageStatuses =
                                [SELECT Id,SNI_FL_Message__c,SNI_FL_Message__r.Feed_Id__c, IsRead__c,Agent__c,Agent__r.Name FROM SNI_FL_Message_Status__c WHERE
                                                                  SNI_FL_Message__c IN: flMessagesMap.keyset()];
                                 
                            //iterating over FL_Message_Status records and grouping them by Feed Id
                            for(SNI_FL_Message_Status__c flMsgStatus : flMessageStatuses){
                                String feedId = flMsgStatus.SNI_FL_Message__r.Feed_Id__c;
                                if(feedId != null){
                                    if(!feedIdAndFlMsgStatusesMap.containsKey(feedId)){
                                        feedIdAndFlMsgStatusesMap.put(feedId, new List<SNI_FL_Message_Status__c>());
                                    }
                                    feedIdAndFlMsgStatusesMap.get(feedId).add(flMsgStatus);
                                   	if(flMsgStatus.Agent__c == userId && !flMsgStatus.IsRead__c){
                                        totalUnreadThreads++;
                                    }
                                }
                            }
                            
                            //quering the DirectMessageFeed AGAIN to get the first comment which is needed to populate from user details
                            List<DirectMessageFeed> dirMsgFeedsWithFirstComment = [SELECT Id,
                                                               (SELECT Id, CreatedById, CreatedBy.Name, CreatedDate, CommentBody FROM FeedComments ORDER BY CreatedDate ASC LIMIT 1)
                                                               FROM DirectMessageFeed WHERE Id IN: feedIdAndFlMsgStatusesMap.keySet()];
                            
                            for(DirectMessageFeed dirMsgFeedWithFirstComment : dirMsgFeedsWithFirstComment){
                                dirMsgFeedMapWithFirstComment.put(dirMsgFeedWithFirstComment.Id,dirMsgFeedWithFirstComment);
                            }
                            
                           	List<SENSAPI_GetChatThreadsResponse.Threads> threadList = populateThreadDetails(dirMsgFeeds);
                            responseDetails.status = new SENSAPI_GetChatThreadsResponse.API_Status(200, true);
                            //pagination information 
                            responseDetails.status.totalRecords = feedIdAndFlMsgStatusesMap.size();
                            responseDetails.status.totalUnreadThreads = totalUnreadThreads;
                            responseDetails.threads = getPaginatedDetails(threadList);
                        }else{
                            noUserThreads = true;
                        }
                    }else{
                        noUserThreads = true;
                    }
                    
                    //if user has no threads
                    if(noUserThreads == true){
                        responseWithNoThreads();
                    }
                    
                }else{
                    responseDetails.status = new SENSAPI_GetChatThreadsResponse.API_Status(400, false, SENSAPI_Constant.USER_INACTIVE);
                }
            }
        }
        catch(Exception ex) {
            responseDetails.status = new SENSAPI_GetChatThreadsResponse.API_Status(500,false,ex.getMessage() +  ' : ' + ex.getStackTraceString());
        }
        RestContext.response.statusCode = responseDetails.status.responseCode;
        return responseDetails;
    }
	
    //Validating the request parameters
    private Boolean validateRequest(){
        Boolean isValid = true;
        List<String> errorMessages = new List<String>(); 
            
        if(String.isBlank(request.userSensId)){
            isValid = false;
            errorMessages.add(SENSAPI_Constant.REQUIREDFIELD_MISSING);
        }
        
        if((request.count != null  || request.offset != null) && (request.count == null  || request.offset == null) ){
            isValid = false;
            errorMessages.add(SENSAPI_Constant.PAGINATION_OFFSET_COUNT_TOGETHER);
        }
        
        if(request.count != null && request.count <=0){
            isValid = false;
            errorMessages.add(SENSAPI_Constant.PAGINATION_COUNT_ERROR);
        }
        
        if(request.offset != null && request.offset < 0){
            isValid = false;
            errorMessages.add(SENSAPI_Constant.PAGINATION_OFFSET_ERROR);
        }
       	
        if(!isValid){
            responseDetails.status = new SENSAPI_GetChatThreadsResponse.API_STATUS(400,false,errorMessages);
        }
		return isValid;
    }
    
    
    private void initProcessor(String requestStructure) {
        try{
            request = SENSAPI_GetChatThreadsRequest.parse(requestStructure);
        }catch(Exception e){
            throw new SENSAPI_Exception( SENSAPI_Constant.JSON_PARSER_ERROR + e.getMessage());
        }  
    }
        
    /**
     * Populating thread list as per the queried details 
     */ 
    private List<SENSAPI_GetChatThreadsResponse.Threads> populateThreadDetails(List<DirectMessageFeed> dirMsgFeeds){
        List<SENSAPI_GetChatThreadsResponse.Threads> threadList = new List<SENSAPI_GetChatThreadsResponse.Threads>();
        for(DirectMessageFeed dirMsgFeed : dirMsgFeeds){
            
            //feed is considered only if there is a corresponding FL_Message_Status record for it 
            if(feedIdAndFlMsgStatusesMap.containsKey(dirMsgFeed.Id)){
                SENSAPI_GetChatThreadsResponse.Threads thread = new SENSAPI_GetChatThreadsResponse.Threads();
                thread.title = dirMsgFeed.Parent.Subject;
                thread.threadId = dirMsgFeed.Id;
                thread.createdDate = dirMsgFeed.CreatedDate; 
                
                
                //populating family details
                if(feedIdAndFlMsgMap.containsKey(dirMsgFeed.Id)){
                    SNI_FL_Message__c flMsg = feedIdAndFlMsgMap.get(dirMsgFeed.Id);
                    thread.familyName = flMsg.Family_ID__r.Name;
                }
                
                
                //populating latest comment details. The FeedComments inner query is ordered by CreatedDate DESC
                if(dirMsgFeed.FeedComments != null && dirMsgFeed.FeedComments.size() > 0){
                    FeedComment latestComment = dirMsgFeed.FeedComments[0];
                    thread.threadBody = latestComment.CommentBody; 
                    thread.latestMessageDate = latestComment.CreatedDate;
                    thread.latestMessageId 	 = latestComment.Id;
                    thread.latestMessageUserId = latestComment.CreatedById;
                }
                
                //getting the first comment of the thread to get the from user.
                //The workaround is applied as the thread is created by integration user
                if(dirMsgFeedMapWithFirstComment.containsKey(dirMsgFeed.Id)){
                    DirectMessageFeed dirMsgFeedWithFirstComment = dirMsgFeedMapWithFirstComment.get(dirMsgFeed.Id);
                    if(dirMsgFeedWithFirstComment.FeedComments != null && dirMsgFeedWithFirstComment.FeedComments.size() > 0){
                        FeedComment firstComment = dirMsgFeedWithFirstComment.FeedComments[0];
                        SENSAPI_GetChatThreadsResponse.FromUser fromUser = new SENSAPI_GetChatThreadsResponse.FromUser();
                        fromUser.isRead = true; // user creating the thread will always have isRead = true
                        fromUser.sensId = firstComment.CreatedById;
                        fromUser.name = firstComment.CreatedBy.Name;
                        thread.fromUser = fromUser;
                    }
                }
                
                List<SNI_FL_Message_Status__c> flMsgStatuses = feedIdAndFlMsgStatusesMap.get(dirMsgFeed.Id); 
                if(flMsgStatuses != null && flMsgStatuses.size() > 0){
                    List<SENSAPI_GetChatThreadsResponse.ToUser> toUsers = new List<SENSAPI_GetChatThreadsResponse.ToUser>();
                    for(SNI_FL_Message_Status__c flMsgStatus: flMsgStatuses){
                        if(flMsgStatus.Agent__c != null && flMsgStatus.Agent__c != thread?.fromUser?.sensId){ //ignoring the creator of the thread 
                            SENSAPI_GetChatThreadsResponse.ToUser toUser = new SENSAPI_GetChatThreadsResponse.ToUser();
                            toUser.isRead = flMsgStatus.IsRead__c;
                            toUser.sensId = flMsgStatus.Agent__c;
                            toUser.name = flMsgStatus.Agent__r.Name;
                            toUsers.add(toUser);
                        }
                    }
                    thread.toUser = toUsers;
                }
                threadList.add(thread);
            }
        }
        return threadList;
    }
    
    /**
     * Runs the pagination logic based on the parameters sent in the request 
     * As the data is collected fisrt from multiple object, the pagination logic is applied at the end
     * The method expects a sorted list of data as the input parameter
     */ 
    @testVisible private List<SENSAPI_GetChatThreadsResponse.Threads> getPaginatedDetails(List<SENSAPI_GetChatThreadsResponse.Threads> threadList){
        List<SENSAPI_GetChatThreadsResponse.Threads> paginatedList = new List<SENSAPI_GetChatThreadsResponse.Threads>();
        Integer pageSize = request?.count;
        Integer offset = request?.offset; 
        
        if(threadList != null && !threadList.isEmpty() && pageSize != null && offset != null){
            Integer recordStart = offset + 1;
            Integer totalRecords = threadList.size();
            Integer recordEnd = offset + pageSize;
            
            Integer lastRecord;
            if(totalRecords<=recordEnd){
                lastRecord = totalRecords;
            } else {
                lastRecord = recordEnd;
            }
            
            for(Integer index = recordStart; index<=lastRecord; index++){
                paginatedList.add(threadList[index-1]);
            }
            
        }else{
            return threadList;
        }
        return paginatedList;
    }
    
    //Method to populate response details if the user is not part of any thread
    private void responseWithNoThreads(){
        responseDetails.status = new SENSAPI_GetChatThreadsResponse.API_Status(200, true);
        //pagination information 
        responseDetails.status.totalRecords = 0;
        responseDetails.status.totalUnreadThreads = 0;
        responseDetails.threads = new List<SENSAPI_GetChatThreadsResponse.Threads>();
    }

}