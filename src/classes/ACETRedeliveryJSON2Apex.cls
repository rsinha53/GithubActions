public class ACETRedeliveryJSON2Apex {
    
    public RedeliveryDocumentResponse redeliveryDocumentResponse;
    
    public class RedeliveryDocumentResponse {
        public RedeliveryDocumentResponseType redeliveryDocumentResponseType {get;set;} 
    }

    public class RedeliveryDocumentResponseType {
        public AcknowledgeMsg acknowledgeMsg {get;set;} 
    }

    public class AcknowledgeMsg {
        public Header header {get;set;} 
        public Acknowledge acknowledge {get;set;} 
    }
    
    public class Header {
        //public String action {get;set;} 
        //public String msgIdentifier {get;set;} 
        //public String srcSystem {get;set;} 
        public String msgDate {get;set;} 
        public String msgTime {get;set;} 
        //public TransType transType {get;set;} 
    }
    
    public class Acknowledge {
        //public String ackReportingLevel {get;set;} 
        public ValidationResults validationResults {get;set;} 
    }
    
    public class ValidationResults {
        public Transaction_zLevelAck transaction_zLevelAck {get;set;} 
    }
    
    public class Transaction_ZLevelAck {
        public List<Transaction_z> transaction_z {get;set;} // in json: transaction
    }
    
    public class transaction_z {
        public String transaction_zStatus {get;set;} 
    }
    
    public class TransType {
        //public String code {get;set;} 
    }
    
}