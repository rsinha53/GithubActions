/*------------------------------------------------------------
Author:        Manmeet Kaur
Description:   Response Wrapper for the service request "Post Send Invite"   

Test Class:    SENSAPI_PostSendInviteReqProcessorTest
History
Date            Author              Comments
-------------------------------------------------------------
27-09-2022      Manmeet Kaur      	Created
------------------------------------------------------------*/
public class SENSAPI_PostSendInviteResponse implements IRestResponseWrapper {
    public API_Status status;

	public SENSAPI_PostSendInviteResponse(){
        status = new API_Status();
    }
    
    public class API_Status{
        public Boolean isSuccess;
        public Integer responseCode;
        public List<String> errorMessage;
       	
        public API_Status(){
            
        }
        public API_Status(Boolean isSuccess, Integer responseCode, String errorMessage){
            this.isSuccess = isSuccess;
            this.responseCode = responseCode;
            this.errorMessage = new List<String>{errorMessage};
        }
        
        public API_Status(Boolean isSuccess, Integer responseCode){
            this.isSuccess = isSuccess;
            this.responseCode = responseCode;
        }
    }
}