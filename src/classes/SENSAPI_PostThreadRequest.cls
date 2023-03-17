public class SENSAPI_PostThreadRequest {

    public String fromUserSensId; 
    public List<String> toUserSensId;
    public String subject;
    public String messageText;
    public String documentId; // This is an optional parameter. Keep it blank if no document is attached to the thread
    public String familySensId;
    
    public static SENSAPI_PostThreadRequest parse(String json){
        return (SENSAPI_PostThreadRequest) System.JSON.deserialize(json, SENSAPI_PostThreadRequest.class);
    }
}