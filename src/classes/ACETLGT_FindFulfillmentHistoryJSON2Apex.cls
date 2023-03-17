public class ACETLGT_FindFulfillmentHistoryJSON2Apex {
  
    public class ResponseRequestHistory {
        public String processorName;
        public String eventTypeBusName;
        public String receivedDate;
        public String dispatchedDate;
        public String recipientId;
        public String deliveryMethodCd;
        public String statusCode;
        public String successCount;
        public String exceptionCount;
        public String documentID;
        public String documentType;
        public String repositoryName;
        public List<exceptionDetail> exceptionDetail;
    }
    public class exceptionDetail {
        public String errorCode;
        public String message;
    }
    public class RequestTrailer {
        public Integer requestItemCount;
    }

    public FindFulfillmentHistoryResult findFulfillmentHistoryResult{get;set;}
    

    public class ResponseRecipient {
        public String recipientId;
        public String identifierQualifierCodeDescr;
        public String deliveryMethod1;
        public String constituentTypeDescr;
        public Person person;
        public MailToAddress MailToAddress;
        public MailToAddress ReturnToAddress;
        public String faxNumber;
        public String emailAddress;
        public organization organization;
        public Boolean carbonCopyInd;
    }
    public class organization{
        public String name1;
        public string name2;
        
    }

    public class ResponseTemplate {
        public String templateID;
        public String templateName;
    }

    public class MailToAddress {
        public String Address1;
        public String Address2;
        public String Address3;
        public String City;
        public String State;
        public String Zip;
    }

    public class ResponseRequestDetail {
        public ResponseTransactionalRequestDetail responseTransactionalRequestDetail;
    }

    public class ResponseCurrentEventLog {
        public String processorName;
        public String eventTypeBusName;
        public String receivedDate;
        public String dispatchedDate;
        public String statusCode;
    }

    public class FindFulfillmentHistoryResult {
        public FindFulfillmentHistoryResponse findFulfillmentHistoryResponse;
    }

    public class SearchResultSet {
        public ResponseRequestHeader responseRequestHeader;
        public ResponseCurrentEventLog responseCurrentEventLog;
        public ResponseRequestDetail responseRequestDetail;
        public List<ResponseRequestHistory> responseRequestHistory;
    }

    public class FindFulfillmentHistoryResponse {
        public SearchParameter searchParameter;
        public List<SearchResultSet> searchResultSet;
    }

    public class ResponseRequestHeader {
        public String requestID;
        public String sourceIDName;
        public String destinationIDName;
        public String requestDate;
        public String businessSegmentName;
        public String marketSegmentName;
        public String fulfillmentTypeBusName;
        public String requestCategory;
        public String dataFormat;
        public String requestorRefNo;
        public String supplierRefNo;
        public RequestTrailer requestTrailer;
    }

    public class SearchParameter {
        public String searchSourceID;
        public String documentID;
    }

    public class Person {
        public String prefix;
        public String firstName;
        public String middleName;
        public String lastName;
        public String suffix;
    }

    public class ResponseTransactionalRequestDetail {
        public List<ResponseRecipient> responseRecipient;
        public ResponseTemplate responseTemplate;
    }

}