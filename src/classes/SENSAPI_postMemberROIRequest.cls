public class SENSAPI_postMemberROIRequest {
    
    public String subscriberId; // family account member id
    public string sensId; // member who will give/revoke authorization
    public list<string> authorizedFor;// list of members to whom authorization will be given
    public list<string> revokedFor; // list of members for whom authorization will be revoked
    
    public static SENSAPI_postMemberROIRequest parse(String json){
        return (SENSAPI_postMemberROIRequest) System.JSON.deserialize(json, SENSAPI_postMemberROIRequest.class);
    }
}