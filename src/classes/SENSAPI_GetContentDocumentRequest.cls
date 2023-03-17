public class SENSAPI_GetContentDocumentRequest {
    public List<String> documentIds;
    
    
    public static SENSAPI_GetContentDocumentRequest parse(String json){
        return (SENSAPI_GetContentDocumentRequest) System.JSON.deserialize(json, SENSAPI_GetContentDocumentRequest.class);
    }
    
}