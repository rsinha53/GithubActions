public class ACETGetProducerAdapterJSON2Apex{
    public cls_response response {get; set;}
   public class cls_response {
        public cls_serviceAttributes serviceAttributes{get; set;}
        public cls_getProducerResponse getProducerResponse{get; set;}
    }
   public class cls_serviceAttributes {
        public String applicationIdentifier{get; set;}    //ACET
        public String requestIdentifier{get; set;}    //74a0a206-7fbb-4568-ad39-5de31abb6db3
        public String responseCode {get; set;}//200
        public String responseDescription{get; set;}  //Success:Trace of all the success calls
        public String totalNumberOfRecords{get; set;} //2
        public String pageNumber{get; set;}   //
        public String recordsPerPage{get; set;}   //
    }
   public class cls_getProducerResponse {
        public String producerID {get; set;}   //160766
        public cls_memberGroupDetails[] memberGroupDetails {get; set;}
        public String producerCompanyName{get; set;}  //ENROLLEMENT SPECIALIST P.A.
        public cls_producerName producerName{get; set;}
        public String producerTIN {get; set;}  //987160766
        public String producerSSN {get; set;}  //
        public String producerType {get; set;} //B 
        public String etype {get; set;} //BR
        public String producerContact{get; set;}  // 
        public String producerEffectiveStartDate{get; set;}   //03/09/2007
        public String producerEffectiveEndDate{get; set;} //12/31/9999
        public cls_producerAddress producerAddress{get; set;}
        public String producerStatus{get; set;}   //Active
        public String legacyBrokerCode{get; set;} //HB1335
    }
    public class cls_memberGroupDetails {
        public String groupNumber{get; set;}  //9800108
        public String groupName{get; set;}    //Customer_Ar_8 
    }
    public class cls_producerName {
        public String firstName {get; set;}    //
        public String middleInitial {get; set;}    //
        public String lastName {get; set;}//
    }
    public class cls_producerAddress {
        public String addressTypeCode{get; set;}  //M
        public String addressLine1{get; set;} //PO BOX 2449
        public String addressLine2{get; set;} //
        public String city{get; set;} //MADISON
        public String state{get; set;}    //MS
        public String zipCode{get; set;}  //39130
        public String country{get; set;}  //
        public String phoneNumber{get; set;}  //6018669933
    }
    public static ACETGetProducerAdapterJSON2Apex parse(String json){
        return (ACETGetProducerAdapterJSON2Apex) System.JSON.deserialize(json, ACETGetProducerAdapterJSON2Apex.class);
    }   
}