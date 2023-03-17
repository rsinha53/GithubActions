/*------------------------------------------------------------
Author:        Harshini Thotakura
Description:   Response Wrapper for the service request "Get Care Advisor Details"              
Test Class:    Covered in SENSAPI_GetCareAdvisorReqProcessorTest
History
Date             Author                    Comments
-------------------------------------------------------------
21-10-2022       Harshini Thotakura        Created
------------------------------------------------------------*/
public class SENSAPI_getCareAdvisorResponse implements IRestResponseWrapper{

    
    public list<careAdvisorDetails> careAdvisor;
    public API_Status status;
    
            
    public class careAdvisorDetails{ 
        public string sensId;
        public  string  firstName;
        public  string  lastName;
        public  string  phone;
        public  string  extension;
        public  string  bio;
        public  string  status;
        public Date assignedDate;
    }
        
    public SENSAPI_getCareAdvisorResponse(){
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