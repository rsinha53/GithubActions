/*------------------------------------------------------------
Author:        Tushar Kaore
Description:   Response Wrapper for the service request "Update Member"   

Test Class:    XXX
History
Date            Author              Comments
-------------------------------------------------------------
10-25-2022      Tushar Kaore      	Created
------------------------------------------------------------*/
public class SENSAPI_UpdateMemberResponse implements IRestResponseWrapper {
    public SENSAPI_StatusResponse status;

	public SENSAPI_UpdateMemberResponse(){
        status = new SENSAPI_StatusResponse();
    }
   
}