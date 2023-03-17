/*------------------------------------------------------------
Author:        Harshini Thotakura 
Description:   Request Wrapper for the service  "Get Care Advisor Details"                
Test Class:    Covered in SENSAPI_GetCareAdvisorReqProcessorTest
History
Date             Author                    Comments
-------------------------------------------------------------
21-10-2022       Harshini Thotakura        Created
------------------------------------------------------------*/
public class SENSAPI_getCareAdvisorRequest {
    public String subscriberId;
    
    public static SENSAPI_getCareAdvisorRequest parse(String json){
        return (SENSAPI_getCareAdvisorRequest) System.JSON.deserialize(json, SENSAPI_getCareAdvisorRequest.class);
    }
    
}