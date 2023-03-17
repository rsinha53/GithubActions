public class ACETFindProducerRequestDetail {

	public class FindProducerRequest {
		public String producerID ='';
		public String producerSSN ='';
		public String producerTIN ='';
		public String producerFirstName='';
		public String producerMiddleInitial='';
		public String producerLastName='';
		public String producerCompanyName='';
		public String producerState='';
		public String producerStatus='';
		public String legacyProducerSystem='';
		public String legacyProducerID='';
		public String customerNumber='';
		public String customerName='';
		public String adminSystem='';
        public String memberGroupNumber = '';
	}

	public Request request;

	public class ServiceAttributes {
		public String applicationIdentifier='';
		public String requestIdentifier='';
		public String requestedDate='';
		public String producerGroupAssociation='';
		public String producerAndGroupFlag='';
		public String pageNumber='';
		public String recordsPerPage='';
       }

	public class Request {
		public ServiceAttributes serviceAttributes;
		public FindProducerRequest findProducerRequest;
	}

	
	public static ACETFindProducerRequestDetail parse(String json) {
		return (ACETFindProducerRequestDetail) System.JSON.deserialize(json, ACETFindProducerRequestDetail.class);
	}
    
    
    public String addSearchInput(ACETFindProducerRequestDetail.ServiceAttributes service,ACETFindProducerRequestDetail.FindProducerRequest findProducer) {
        request = new Request();
        request.serviceAttributes=service;
        request.findProducerRequest=findProducer;
        return JSON.serialize(this);
    }
}