/*------------------------------------------------------------
Author:        Harshini Thotakura 
Description:   Request Processor for the service  "POST Mark Thread As Read"                
Test Class:    Covered in SENSAPI_PostMarkThreadAsReadReqProcTest
History
Date             Author                    Comments
-------------------------------------------------------------
03-11-2022       Harshini Thotakura        Created
------------------------------------------------------------*/
public class SENSAPI_PostMarkThreadAsReadReqProcessor implements IRestRequestProcessor{
    
    public SENSAPI_PostMarkThreadAsReadRequest request;
    public SENSAPI_PostMarkThreadAsReadResponse responseDetails;
    
    public IRestResponseWrapper process(String requestStructure){
        responseDetails = new SENSAPI_PostMarkThreadAsReadResponse();
        try{
            initProcessor(requestStructure);
            String sensId = request.sensUserId;
            String threadId = request.threadId;
            Boolean isRead = request.isRead;
            //All the fields are required
            if(String.isNotBlank(sensId) && String.isNotBlank(threadId) && isRead!=null){
                //Checking if the user exists
                List<User> userList = [SELECT Id,Name FROM User WHERE Id=:sensId AND isActive = true];
                if(userList.size()==0){ 
                    responseDetails.status = new SENSAPI_StatusResponse(false, 400, SENSAPI_Constant.USER_INACTIVE);
                }else{
                    List<SNI_FL_Message__c> messageId = [SELECT Id FROM SNI_FL_Message__c WHERE Feed_Id__c =:threadId LIMIT 1];
                    if(messageId.size()>0){
                        //checking the read status of thread and updating the thread as read
                        List<SNI_FL_Message_Status__c> status =[SELECT IsRead__c FROM SNI_FL_Message_Status__c WHERE SNI_FL_Message__c =:messageId[0].id AND Agent__c=:sensId];
                        if(status.size()>0){
                            status[0].IsRead__c = isRead;
                            update status;
                            responseDetails.status = new SENSAPI_StatusResponse(true, 200);
                        }else{
                            responseDetails.status = new SENSAPI_StatusResponse(false, 400, SENSAPI_Constant.NO_STATUS_RECORD);
                        }
                    }else{
                        responseDetails.status = new SENSAPI_StatusResponse(false, 400, SENSAPI_Constant.INVALID_THREADID);
                    }                   
                }
            }else{
                responseDetails.status = new SENSAPI_StatusResponse(false, 400, SENSAPI_Constant.REQUIREDFIELD_MISSING);
            }            
        }catch(exception ex){
            responseDetails.status = new SENSAPI_StatusResponse(false, 500, ex.getMessage() + ex.getStackTraceString());
        }
        RestContext.response.statusCode = responseDetails.status.responseCode;
        return responseDetails;
    }
    
    private void initProcessor(String requestStructure) {
        try{
            request = SENSAPI_PostMarkThreadAsReadRequest.parse(requestStructure);
        }catch(Exception e){
            throw new SENSAPI_Exception('Error while parsing wrapper JSON : ' + e.getMessage());
        }        
    }
}