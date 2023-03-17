/*
 * @Desc: US2426570 - Deserialize Select Associate Response
 * @Date: 3/16/2021
 * @Dev: Ketki
*/
public class SelectAssociateJson2Apex {

	public class AssociateName {
		public String firstName;
		public String lastName;
	}

	public class ResponseHeader {
		public String serviceCallStatus;
		public String externalId;
		public String serviceName;
		public String serviceVersion;
		public String logLevel;
		public String upmEnvironment;
		public InternalUse internalUse;
	}

	public ResponseHeader responseHeader;
	public List<Associates> associates;
	public PagingState pagingState;

	public class Associates {
		public String activeIndicator;
		public String associateId;
		public AssociateName associateName;
		public String departmentCode;
		public String officeId;
		public String teamCode;
	}

	public class InternalUse {
		public String uid;
		public String serviceName;
		public String serviceVersion;
		public String originalConsumer;
		public String originalServiceName;
		public String originalServiceVersion;
		public Integer logSequence;
		public String uidGeneratedBy;
	}

	public class PagingState {
		public Boolean moreData;
		public String nextKey;
	}

	
	public static SelectAssociateJson2Apex parse(String json) {
		return (SelectAssociateJson2Apex) System.JSON.deserialize(json, SelectAssociateJson2Apex.class);
	}
}