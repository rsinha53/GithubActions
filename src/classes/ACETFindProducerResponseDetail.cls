public class ACETFindProducerResponseDetail {

	public class Response {
		public ServiceAttributes serviceAttributes;
		public List<FindProducerResponse> findProducerResponse;
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
		public String requestedDate;
		public String producerGroupAssociation;
		public String producerAndGroupFlag;
		public String pageNumber;
		public String recordsPerPage;
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

	public class FindProducerResponse {
		public String producerCustomerValidated;
		public String producerID;
		public String producerSSN;
		public String producerTIN;
		public String producerType;
		public String producerContact;
		public String producerCompanyName;
		public String producerStatus;
        public String producerState;
		public String producerEffectiveStartDate ='';
		public String producerEffectiveEndDate= '';
		public List<LegacyProducers> legacyProducers;
		public List<CustomerDetails> customerDetails;
		public String coverageType;
		public String producerRoleType;
		public String producerRole;
		public String producerServiceRightsOnly;
		public String producerCRID;
		public String producerSplitPercent;
		public ProducerIndividualName producerIndividualName;
		public ProducerAddress producerAddress;
        public List<MemberGroupDetails> memberGroupDetails;
	}
     public class MemberGroupDetails {
        public String groupNumber;
        public String groupName;
        public String producerMemberGrpStartDate;
        public String producerMemberGrpEndDate;
    }

	public class LegacyProducers {
		public String legacyProducerSystem;
		public String legacyProducerID;
	}
	public class CustomerDetails {
        public String customerNumber;
		public String customerName;
		public String adminSystem;
		public String producerCustomerStartDate;
		public String producerCustomerEndDate;
    }

	
	public static ACETFindProducerResponseDetail parse(String json) {
		return (ACETFindProducerResponseDetail) System.JSON.deserialize(json, ACETFindProducerResponseDetail.class);
	}
}