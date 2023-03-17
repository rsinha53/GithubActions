public class ACETFindDocJson2Apex {

    public class FindDocumentsResponseType {
        public DocumentList documentList;
        public Pagination pagination;
    }

    public class FindDocumentsResponse {
        public FindDocumentsResponseType findDocumentsResponseType;
    }

    public class DocumentList {
        public List<Document> document;
    }

    public class Pagination {
        public String maxRecords;
        public String pageNumber;
        public String pageSize;
        public String recordCount;
        public String moreRecords;
    }

    public class DocumentKey {
        public String name;
        public String value;
        public String dataTypeIndicator;
    }

    public class DocumentKeys {
        public List<DocumentKey> documentKey;
    }

    public class Document {
        public String repositoryId;
        public String repositoryName;
        public String documentId;
        public String documentClass;
        public DocumentKeys documentKeys;
    }

        public FindDocumentsResponse findDocumentsResponse{get;set;}
}