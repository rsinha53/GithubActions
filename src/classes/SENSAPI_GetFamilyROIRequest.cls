/*------------------------------------------------------------
Author:        Tushar Kaore
Description:   Request Wrapper for the service request "GET Family ROI"   

Test Class:    SENSAPI_GetFamilyROIReqProcessorTest
History
Date            Author              Comments
-------------------------------------------------------------
16 Nov,2022      Tushar Kaore      	Created
------------------------------------------------------------*/

public class SENSAPI_GetFamilyROIRequest {

    public String subscriberId;
        
    public static SENSAPI_GetFamilyROIRequest parse(String json){
        return (SENSAPI_GetFamilyROIRequest) System.JSON.deserialize(json, SENSAPI_GetFamilyROIRequest.class);
    }
    
}