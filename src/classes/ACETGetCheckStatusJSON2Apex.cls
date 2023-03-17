public class ACETGetCheckStatusJSON2Apex {

	public GetCheckStatusResponse getCheckStatusResponse;
	
	public class GetCheckStatusResponse {
		public String checkStatus;
		public String issuedDate;
		public String cashedDate;
		public String voidDate;
		public String returnedDate;
		public String remailedDate;
		public String itemID;
	}

	
	public static ACETGetCheckStatusJSON2Apex parse(String json) {
		return (ACETGetCheckStatusJSON2Apex) System.JSON.deserialize(json, ACETGetCheckStatusJSON2Apex.class);
	}
}