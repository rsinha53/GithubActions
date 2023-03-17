/*------------------------------------------------------------
Author:        Manmeet Kaur
Description:   Request Wrapper for the service "Post Send Invite"                
Test Class:    SENSAPI_PostSendInviteReqProcessorTest
History
Date             Author                    Comments
-------------------------------------------------------------
27-09-2022       Manmeet Kaur              Created
------------------------------------------------------------*/
public class SENSAPI_PostSendInviteRequest {
    public String subscriberId;
    public String sensId;
    public String email;
    
    public static SENSAPI_PostSendInviteRequest parse(String json){
        return (SENSAPI_PostSendInviteRequest) System.JSON.deserialize(json, SENSAPI_PostSendInviteRequest.class);
    }
}