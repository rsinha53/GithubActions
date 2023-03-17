public class ACETGetProducerResponseDetail {
	public class Response {
		public ServiceAttributes serviceAttributes;
		public GetProducerResponse getProducerResponse;
	}

	public class ProducerIndividualName {
		public String firstName;
		public String middleInitial;
		public String lastName;
	}

	public Response response;

	public class ServiceAttributes {
		public String applicationIdentifier;
		public String requestIdentifier;
		public String producerGroupAssociation;
		public String pageNumber;
		public String recordsPerPage;
		public String requestedEffectiveDate;
		public String totalNumberOfRecords;
		public String responseCode;
		public String responseDescription;
	}

	public class ProducerAddress {
		public String addressTypeCode;
		public String producerStreetLine1;
		public String producerStreetLine2;
		public String producerCity;
		public String producerState;
		public String producerZipCode;
		public String producerZipCodeSuffix;
		public String producerPhoneNumber;
	}

	public class GetProducerResponse {
		public String producerID;
		public String producerCompanyName;
		public ProducerIndividualName producerIndividualName;
		public String producerSSN;
		public String producerTIN;
		public String producerType;
		public String producerContact;
		public String producerEffectiveStartDate;
		public String producerEffectiveEndDate;
		public ProducerAddress producerAddress;
        public List<MemberGroupDetails> memberGroupDetails;
		public String producerStatus;
        public String producerState;
        public String legacyBrokerCode;
        public String etype;
		public List<LegacyProducers> legacyProducers;
		public List<CustomerDetails> customerDetails;
	}

	public class LegacyProducers {
		public String legacyProducerSystem;
		public String legacyProducerID;
	}
    
	public class CustomerDetails {
        public String customerNumber;
		public String customerName;
		public String adminSystem;
    }
    
    public class MemberGroupDetails {
        public String groupNumber{get; set;}  //9800108
        public String groupName{get; set;}    //Customer_Ar_8 
    }

	
	public static ACETGetProducerResponseDetail parse(String json) {
		return (ACETGetProducerResponseDetail) System.JSON.deserialize(json, ACETGetProducerResponseDetail.class);
	}
}