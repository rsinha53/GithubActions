public class ACETGetProducerRequestDetail {
	public class GetProducerRequest {
		public String producerID;
		public String customerNumber;
		public String adminSystem;
        public String producerEffectiveAsofdate;
        public String legacyBrokerCode;
        public String memberGroupNumber;
	}

	public Request request;

	public class ServiceAttributes {
		public String applicationIdentifier;
		public String requestIdentifier;
		public String requestedDate;
		public String producerGroupAssociation;
		public Integer pageNumber;
		public Integer recordsPerPage;
       }

	public class Request {
		public ServiceAttributes serviceAttributes;
		public GetProducerRequest getProducerRequest;
	}

	
	public static ACETGetProducerRequestDetail parse(String json) {
		return (ACETGetProducerRequestDetail) System.JSON.deserialize(json, ACETGetProducerRequestDetail.class);
	}
    
    
    public String addSearchInput(ACETGetProducerRequestDetail.ServiceAttributes service,ACETGetProducerRequestDetail.GetProducerRequest getProducer) {
        request = new Request();
        request.serviceAttributes=service;
        request.getProducerRequest=getProducer;
        return JSON.serialize(this);
    }
}