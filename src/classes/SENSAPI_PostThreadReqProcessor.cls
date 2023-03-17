public class SENSAPI_PostThreadReqProcessor implements IRestRequestProcessor {
    public SENSAPI_PostThreadRequest request;
    public SENSAPI_PostThreadResponse responseDetails;
    //process request and return response
    public IRestResponseWrapper process(String requestStructure){
        Savepoint sp = Database.setSavepoint();            
        try{   
            responseDetails = new SENSAPI_PostThreadResponse();
            initProcessor(requestStructure);
            Boolean validCheck = validCheckForPostThread(request);
            if(validCheck == true){
                List<String> userIdsList = new List<String>();
                Map<String,User> userMap = new Map<String,User>();
                userIdsList = request.toUserSensId.clone();
                userIdsList.add(request.fromUserSensId);
                String feedElmId;
                list<user> validUser = SENSAPI_Utility.checkValidUsers(userIdsList);
                if(validUser.size() > 0 && validUser.size() == userIdsList.size()){
                    userMap = new Map<String, User>(validUser);
                    Map<String,Object> messageRequest = new Map<String,Object>();
                    messageRequest.put('selectedQueue',null);
                    messageRequest.put('MessageContent',request.messageText);
                    messageRequest.put('MessageSubject',request.subject);
                    messageRequest.put('ToUsers',request.toUserSensId);
                    messageRequest.put('FamilyAccountID',request.familySensId);
                    List<Account>famAccount = [SELECT id,name from account where id=:request.familySensId];
                    if(famAccount.size()>0){
                        if(String.isNotBlank(request.documentId)){
                            feedElmId = SENSAPI_MessagingUtility.postThreadwithfile(request.messageText,request.subject,request.toUserSensId,request.documentId,request.familySensId,messageRequest,request.fromUserSensId); 
                        }
                        else{
                            feedElmId = SENSAPI_MessagingUtility.postThreadwithfile(request.messageText,request.subject,request.toUserSensId,null,request.familySensId,messageRequest,request.fromUserSensId);
                        }
                        if(String.isNotEmpty(feedElmId)){
                            List<DirectMessageFeed>dmFeed = SENSAPI_MessagingUtility.getDirectMsgFeed(feedElmId);
                            List<SNI_FL_Message_Status__c>mssgStatus = SENSAPI_MessagingUtility.getMessageStatus(feedElmId,request.fromUserSensId);
                            return new SENSAPI_PostThreadResponse(dmFeed,famAccount,userMap,request.toUserSensId,userMap.get(request.fromUserSensId));
                        }
                    }
                    else{
                        responseDetails.status = new SENSAPI_StatusResponse(false,400,SENSAPI_Constant.INVALID_FAMILYID);
                    }
                    
                }
                else{
                    responseDetails.status = new SENSAPI_StatusResponse(false,400,SENSAPI_Constant.USER_INACTIVE);  
                }
            }
            else{
                responseDetails.status = new SENSAPI_StatusResponse(false,400,SENSAPI_Constant.REQUIREDFIELD_MISSING);  
            }
        }
        catch(Exception ex) {
            responseDetails.status = new SENSAPI_StatusResponse(false,500,ex.getMessage() + ex.getStackTraceString());            
        }  
        RestContext.response.statusCode = responseDetails.status.responseCode;
        return responseDetails;
    }
    
    private void initProcessor(String requestStructure) {
        try{
            request = SENSAPI_PostThreadRequest.parse(requestStructure);
        }catch(Exception e){
            throw new SENSAPI_Exception( SENSAPI_Constant.JSON_PARSER_ERROR + e.getMessage());
        }        
    }
    
    //Validate Request for Post thread API
    public static boolean validCheckForPostThread(SENSAPI_PostThreadRequest request){
        
        Boolean isValid = true;
        
        if(String.isBlank(request.fromUserSensId) || request.toUserSensId.size() <= 0
           && String.isBlank(request.familySensId)){
               isValid = false;
           } 
        
        //both message and the attached document cannot be null together
        if(String.isBlank(request.documentId) && String.isBlank(request.messageText) ){
            isValid = false;
        }
        
        return isValid;
    }
}