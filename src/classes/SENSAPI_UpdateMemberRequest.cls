public class SENSAPI_UpdateMemberRequest {
    
    public String subscriberId;
	public String sensId;
	public PersonalInfo personalInfo;
	public Notification notification;

	public class PersonalInfo {
		public String preferredName;
		public String email;
		public String mobile;
	}

	public class Notification {
		public Boolean email;
		public Boolean textSMS;
	}
    
    
    public static SENSAPI_UpdateMemberRequest parse(String json){
        return (SENSAPI_UpdateMemberRequest) System.JSON.deserialize(json, SENSAPI_UpdateMemberRequest.class);
    }
}