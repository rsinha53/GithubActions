/*
* @Desc: US3068301	Validation Error Messages API Implementation
* @Date: 18-01-2021
* @Dev: S.T.Sarma
*/
public class ACET_ValidationApiResponceJSON2Apex {

    
	public InvocationContext invocationContext;
	public Metadata metadata;
	public String responseCode;
	public List<ErrorResponse> errorResponse;

	public class Metadata {
		public String clientGroup;
		public String clientBusiness;
		public String clientLocation;
		public String clientNPI;
		public String caseSubmissionTransactionID;
	}

	public class InvocationContext {
		public String clientID;
		public String locationID;
		public String userID;
		public String userIDType;
		public String clientCorrelationID;
		public String serviceCorrelationID;
	}

	public class ErrorResponse {
		public String errorCode;
		public String errorField;
		public String errorText;
	}

	
	public static ACET_ValidationApiResponceJSON2Apex parse(String json) {
		return (ACET_ValidationApiResponceJSON2Apex) System.JSON.deserialize(json, ACET_ValidationApiResponceJSON2Apex.class);
	}
}