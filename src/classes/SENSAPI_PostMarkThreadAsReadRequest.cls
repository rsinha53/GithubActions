/*------------------------------------------------------------
Author:        Harshini Thotakura 
Description:   Request Wrapper for the service  "POST Mark Thread As Read"                
Test Class:    Covered in SENSAPI_PostMarkThreadAsReadReqProcTest
History
Date             Author                    Comments
-------------------------------------------------------------
03-11-2022       Harshini Thotakura        Created
------------------------------------------------------------*/
public class SENSAPI_PostMarkThreadAsReadRequest {
    public String sensUserId;
    public String threadId;
    public Boolean isRead;
    
    public static SENSAPI_PostMarkThreadAsReadRequest parse(String json){
        return (SENSAPI_PostMarkThreadAsReadRequest) System.JSON.deserialize(json, SENSAPI_PostMarkThreadAsReadRequest.class);
    }
    
}