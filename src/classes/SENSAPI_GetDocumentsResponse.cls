/*------------------------------------------------------------
Author:        Manmeet Kaur
Description:   Response Wrapper for the service request "Get Documents"                 
Test Class:     
History
Date             Author                    Comments
-------------------------------------------------------------
26-10-2022       Manmeet Kaur             Created
------------------------------------------------------------*/

public class SENSAPI_GetDocumentsResponse implements IRestResponseWrapper {
                       
    public API_Status status;
    public List<docClass> documentList;

    public class DocClass{
        public string documentId;
        public string title;
        public datetime lastModifiedDate;
        public string ownerSensId;  
        public string downloadURL;
        public string policyMemberSensId;
        public string docType;
        public Integer contentSize; 
        public datetime createdDate;
    }

    public class contentDocClass{
        list<DocClass> documentList;
        public contentDocClass(list<DocClass> documentList){
            this.documentList = documentList;
        }
    }
	public class API_Status{
        public Boolean isSuccess;
        public Integer responseCode;
        public List<String> errorMessage;
    	public Integer totalRecords;

        public API_Status(){
            
        }
		public API_Status(Boolean isSuccess, Integer responseCode, String errorMessage){
            this.isSuccess = isSuccess;
            this.responseCode = responseCode;
            this.errorMessage = new List<String>{errorMessage};
        }
        
        public API_Status(Boolean isSuccess, Integer responseCode, Integer count){
            this.isSuccess = isSuccess;
            this.responseCode = responseCode;
            this.totalRecords = count;
        }
    }
    public SENSAPI_GetDocumentsResponse(){
        status = new API_Status();        
    }
}