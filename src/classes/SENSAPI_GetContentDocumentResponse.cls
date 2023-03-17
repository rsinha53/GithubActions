/*------------------------------------------------------------
Author:        Tushar Kaore
Description:   Response Wrapper for the service request "Update Member"   

Test Class:    XXX
History
Date            Author              Comments
-------------------------------------------------------------
10-25-2022      Tushar Kaore      	Created
------------------------------------------------------------*/
public class SENSAPI_GetContentDocumentResponse implements IRestResponseWrapper {
    public SENSAPI_StatusResponse status;
    public List<Document> document;

	public SENSAPI_GetContentDocumentResponse(){
        status = new SENSAPI_StatusResponse();
    }

	public class Document {
		public String documentId;
		public String title;
		public Integer contentSize;
		public String docType;
		public String downloadURL;
		public Datetime createdDate;
		public Datetime lastModifiedDate;
		public String ownerSensId;
	}
   
}