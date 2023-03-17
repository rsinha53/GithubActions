/* Class Name:ACETDesignationUpdResponse
 * Author:Chandan
 * Created Date: 07/05/2020
 * Description: JSON2APEX Class for response from ACETEHubUpdateAPI
**/
public class ACETDesignationUpdResponse {
    
    public class Status {
		public List<Messages> messages;
	}

	public class Messages {
		public String code;
		public String name;
		public String severity;
		public String description;
	}

	public Status status;

	
	public static ACETDesignationUpdResponse parse(String json) {
		return (ACETDesignationUpdResponse) System.JSON.deserialize(json, ACETDesignationUpdResponse.class);
	}

}