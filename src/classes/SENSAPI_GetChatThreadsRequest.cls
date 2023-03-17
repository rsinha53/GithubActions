/*------------------------------------------------------------
Author:        Tushar Kaore
Description:   Request Wrapper for the service "Get All Chat Threads"               
History
Date           		Author                    	Comments
-------------------------------------------------------------
11-07-2022      	Tushar Kaore				Created
------------------------------------------------------------*/
public class SENSAPI_GetChatThreadsRequest {
    public String userSensId; //required
    
    //pagination parameters
    public Integer count;
    public integer offset;
    
    public static SENSAPI_GetChatThreadsRequest parse(String json){
        return (SENSAPI_GetChatThreadsRequest) System.JSON.deserialize(json, SENSAPI_GetChatThreadsRequest.class);
    }
    
}