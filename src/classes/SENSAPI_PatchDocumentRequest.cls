public class SENSAPI_PatchDocumentRequest {
    
    public String documentId; 
    public String title;
    
    public static SENSAPI_patchDocumentRequest parse(String json){
        return (SENSAPI_patchDocumentRequest) System.JSON.deserialize(json, SENSAPI_patchDocumentRequest.class);
    }
}