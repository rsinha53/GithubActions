public class SENSAPI_ResponseParser{
    
    public Response response;
    
    public class Response {
        public Object data;
    }
    
    public SENSAPI_ResponseParser(){
        this.response = new Response();
    }
    
    public class StatusResponse{
        SENSAPI_StatusResponse status;
        public StatusResponse(SENSAPI_StatusResponse status){
            this.status = status;
        }   
    }
}