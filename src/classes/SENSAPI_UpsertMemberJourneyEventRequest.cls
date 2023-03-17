/*------------------------------------------------------------
Author:        Geeta Koli
Description:   Request Wrapper for the service request "Upsert Member Journey Event"   

Test Class:    XXX
History
Date            Author              Comments
-------------------------------------------------------------
11-15-2022      Geeta Koli      	Created
------------------------------------------------------------*/
public class SENSAPI_UpsertMemberJourneyEventRequest {

    public String id;
    public String version;
	public String type;
	public Data data;

	public class Data {
        public String id;
        public String version;
        public String activityTitle;
		public String subscriberId;
		public String memberSensId;
		public String carePlanId;
        public String careAdvisorId;
        public DateTime createdAt;
        
        public String taskId;
        public String status;
        public DateTime lastModifiedAt;
	}
    
    public static SENSAPI_UpsertMemberJourneyEventRequest parse(String json){
        return (SENSAPI_UpsertMemberJourneyEventRequest) System.JSON.deserialize(json, SENSAPI_UpsertMemberJourneyEventRequest.class);
    }
}