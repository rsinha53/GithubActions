/*------------------------------------------------------------
Author:        Tushar Kaore
Description:   Response Wrapper for the service request "GET Chat Threads"   

History
Date            Author              Comments
-------------------------------------------------------------
11-07-2022      Tushar Kaore      	Created
------------------------------------------------------------*/
public class SENSAPI_GetChatThreadsResponse implements IRestResponseWrapper {
    public API_Status status;
	public List<Threads> threads;
    
	public SENSAPI_GetChatThreadsResponse(){
        status = new API_Status();
    }
    
    
    public class Threads {
		public String title;
		public String threadId;
		public String threadBody;
		public DateTime latestMessageDate;
        public String latestMessageUserId;
        public String latestMessageId;
		public FromUser fromUser;
		public List<ToUser> toUser;
		public String familyName;
		public DateTime createdDate;
	}

	

	public class ToUser {
		public String sensId;
		public String name;
		public Boolean isRead;
	}

	public class FromUser {
		public String sensId;
		public String name;
		public Boolean isRead;
	}
    
     public class API_Status{
         public Boolean isSuccess;
         public Integer responseCode;
         public List<String> errorMessage;
         public Integer totalRecords;
         public Integer totalUnreadThreads;
         
         public API_Status(){
             
         }
         
         public API_Status(Integer responseCode, Boolean isSuccess, String errorMessage){
             this.isSuccess = isSuccess;
             this.responseCode = responseCode;
             this.errorMessage = new List<String>{errorMessage};
          }
         
         public API_Status(Integer responseCode, Boolean isSuccess, List<String> errorMessages){
             this.isSuccess = isSuccess;
             this.responseCode = responseCode;
             this.errorMessage = errorMessages;
          }
         
         public API_Status(Integer responseCode,Boolean isSuccess){
             this.isSuccess = isSuccess;
             this.responseCode = responseCode;
         }
    }
   
}