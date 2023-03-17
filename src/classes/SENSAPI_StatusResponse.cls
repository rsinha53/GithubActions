public class SENSAPI_StatusResponse {
    public Boolean isSuccess;
    public Integer responseCode;
    public List<String> errorMessage;
    
    public SENSAPI_StatusResponse(){
        
    }
    public SENSAPI_StatusResponse(Boolean isSuccess, Integer responseCode, String errorMessage){
        this.isSuccess = isSuccess;
        this.responseCode = responseCode;
        this.errorMessage = new List<String>{errorMessage};
            }
    
    public SENSAPI_StatusResponse(Boolean isSuccess, Integer responseCode, List<String> errorMessages){
        this.isSuccess = isSuccess;
        this.responseCode = responseCode;
        this.errorMessage = errorMessages;
            }
    
    public SENSAPI_StatusResponse(Boolean isSuccess, Integer responseCode){
        this.isSuccess = isSuccess;
        this.responseCode = responseCode;
    }
}