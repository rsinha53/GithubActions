public class SENSAPI_DeleteDocumentRequest {
    public String documentId; 
    public static SENSAPI_DeleteDocumentRequest parse(String json){
        return (SENSAPI_DeleteDocumentRequest) System.JSON.deserialize(json, SENSAPI_DeleteDocumentRequest.class);
    }
}