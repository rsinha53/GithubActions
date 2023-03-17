public class ACET_SelectAssociateRequest {

	public class ControlModifiers {
		public String callLimit;
	}

	public String officeId;
	public String departmentCode;
	public String teamCode;
	public PagingState pagingState;
	public ControlModifiers controlModifiers;
	public RequestHeader requestHeader;

	public class ServiceOptions {
		public String key;
		public String value;
	}

	public class RequestHeader {
		public String applicationName;
		public String applicationInstanceName;
		public String logLevel;
		public List<ServiceOptions> serviceOptions;
	}

	public class PagingState {
		public Boolean moreData;
	}

	
	public static ACET_SelectAssociateRequest parse(String json) {
		return (ACET_SelectAssociateRequest) System.JSON.deserialize(json, ACET_SelectAssociateRequest.class);
	}
}