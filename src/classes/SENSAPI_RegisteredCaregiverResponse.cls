public class SENSAPI_RegisteredCaregiverResponse implements IRestResponseWrapper {
    public API_Status status;
   // public API_Status registeredDate;
    
    public SENSAPI_RegisteredCaregiverResponse(){
        status = new API_Status();
       // registeredDate = new API_Status();
    }
    
    public class API_Status{ 
        public Boolean isSuccess;
        public Integer responseCode;
        public List<String> errorMessage;
        
        public API_Status(){
            
        }
        
        public API_Status(Integer responseCode, Boolean isSuccess, String errorMessage){
            this.isSuccess = isSuccess;
            this.responseCode = responseCode;
            this.errorMessage = new List<String>{errorMessage};
                }
        
        public API_Status(Integer responseCode,Boolean isSuccess){
            this.isSuccess = isSuccess;
            this.responseCode = responseCode;
        }
    }
}