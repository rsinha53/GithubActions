public class ACETProcessFulFillmentJSON2Apex {
  
  
  public ProcessFulfillmentRequestResult ProcessFulfillmentRequestResult {get;set;}
  
  public class ValidationResults {
    public Transaction_zLevelAck transaction_zLevelAck {get;set;} 
  }
   
  /*public class Header {
    //public String action {get;set;} 
    //public String msgIdentifier {get;set;} 
    //public String srcSystem {get;set;} 
    //public String msgDate {get;set;} 
    //public String msgTime {get;set;} 
    //public TransType transType {get;set;} 
    //public TransType transSubCat {get;set;} 
    //public List<String> targetSystems {get;set;} 

  }*/
  
  public class Transaction_zLevelAck {
    public List<Transaction_Z> transaction_Z {get;set;} // in json: transaction
  }
  
  public class Acknowledge {
    //public String ackReportingLevel {get;set;} 
    public ValidationResults validationResults {get;set;} 
  }
  
  /*public class TransType {
    public String code {get;set;} 
  }*/
  
  public class AcknowledgeMsg {
    //public Header header {get;set;} 
    public Acknowledge acknowledge {get;set;} 
    //public Trailer trailer {get;set;} 
  }
  
  public class ProcessFulfillmentRequestResult {
    public AcknowledgeMsg acknowledgeMsg {get;set;} 
  }
  
  public class Transaction_Z {
    public String transaction_ZStatus {get;set;} 
  }
  
  public class TotalObjectCount {
  }
  
  /*public class Trailer {
    public List<TotalObjectCount> totalObjectCount {get;set;} 
  }*/
}