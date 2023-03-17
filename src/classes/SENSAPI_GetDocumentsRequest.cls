/*------------------------------------------------------------
Author:        Pratikshya Satapathy
Description:   Request Wrapper for the service "Get Documents"               
Test Class:   
History
Date             Author                    Comments
-------------------------------------------------------------
17-08-2022      Pratikshya Satapathy        Created
------------------------------------------------------------*/
public class SENSAPI_GetDocumentsRequest {
    public String subscriberId;
    public String memberSensId;

    public String latest;
    public String oldest;
    public integer count;
    public integer offset;

    public static SENSAPI_GetDocumentsRequest parse(String json){
        return (SENSAPI_GetDocumentsRequest) System.JSON.deserialize(json, SENSAPI_GetDocumentsRequest.class);
    }
}