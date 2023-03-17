public class ACETFindProducersAdaptJSON2Apex {
    public Response response;
    public ACETFindProducersAdaptJSON2Apex(){}
    
    public class Response {
        public ServiceAttributes serviceAttributes;
        public List<FindProducerResponse> findProducerResponse;
    }
  
    public class MemberGroupDetails {
        public String groupNumber;
        public String groupName;
        public String producerMemberGrpStartDate;
        public String producerMemberGrpEndDate;
    }

    public class ServiceAttributes {
        public String applicationIdentifier;
        public String requestIdentifier;
        public String totalNumberOfRecords;
        public String pageNumber;
        public String recordsPerPage;
        public String responseCode;
        public String responseDescription;
    }

    public class ProducerName {
        public String firstName;
        public String middleInitial;
        public String lastName;
    }

    public class FindProducerResponse {
        public String producerGroupValidated;
        public String producerStatus;
        public String producerEffectiveAsOfDate;
        public String producerId;
        public String producerCompanyName;
        public String producerType;
        public String legacyBrokerCode;
        public String producerSSN;
        public String producerTIN;
        public String producerState;
        public String producerContact;
        public String producerCity;
        public String producerPhoneNumber;
        public ProducerName producerName;
        public List<MemberGroupDetails> memberGroupDetails;
        public string coverageType;
        public string producerRoleType;
        public string producerRole;
        public string producerServiceRightsOnly;
        public string producerCRID;
        public string producerSplitPercent;
        public string producerStreetLine1;
        public string producerStreetLine2;
        public string producerZipCode;
        public string producerZipCodeSuffix;

    }

}