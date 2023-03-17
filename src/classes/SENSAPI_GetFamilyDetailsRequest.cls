/*------------------------------------------------------------
Author:        Prajnith Karra
Description:   request warpper is used in following APIs                  
Test Class:   
History
Date            Author              Comments
-------------------------------------------------------------
24-07-2022      Prajnith Karra        Created
------------------------------------------------------------*/
public class SENSAPI_GetFamilyDetailsRequest {
    public String subscriberId;     
    public Date dateOfBirth;
    public String email;
    public String origin;

    public static SENSAPI_GetFamilyDetailsRequest parse(String json){
        return (SENSAPI_GetFamilyDetailsRequest) System.JSON.deserialize(json, SENSAPI_GetFamilyDetailsRequest.class);
    }

}