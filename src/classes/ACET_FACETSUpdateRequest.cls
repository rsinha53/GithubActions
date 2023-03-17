public class ACET_FACETSUpdateRequest {
    
     public class Tasks {
        public String seqNo {get;set;} {seqNo = '0';}
        public String noteText {get;set;} {noteText = '';}
        public String lastUpdateUserId  {get;set;} { lastUpdateUserId  = '';}
        
    }
    
    public CustomerServiceRecord customerServiceRecord {get;set;} {customerServiceRecord = new CustomerServiceRecord();}
    
    public class CustomerServiceRecord {
        public String inquiryId {get;set;} {inquiryId = '';}
        public List<Tasks> tasks {get;set;} {tasks = new List<Tasks>();}
    }
    
   
    
    public ACET_FACETSUpdateRequest(CustomerServiceRecord objCustomerServiceRecord) {
        this.customerServiceRecord = objCustomerServiceRecord;
    }

}