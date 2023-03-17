/*------------------------------------------------------------
Author:        Harshini Thotakura 
Description:   Response Wrapper for the service  "POST Mark Thread As Read"                
Test Class:    Covered in SENSAPI_PostMarkThreadAsReadReqProcTest
History
Date             Author                    Comments
-------------------------------------------------------------
03-11-2022       Harshini Thotakura        Created
------------------------------------------------------------*/
public class SENSAPI_PostMarkThreadAsReadResponse implements IRestResponseWrapper {
    public SENSAPI_StatusResponse status;

	public SENSAPI_PostMarkThreadAsReadResponse(){
        status = new SENSAPI_StatusResponse();
    }

}