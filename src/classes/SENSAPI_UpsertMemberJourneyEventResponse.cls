/*------------------------------------------------------------
Author:        Geeta Koli
Description:   Response Wrapper for the service request "Upsert Member Journey Event"   

Test Class:    XXX
History
Date            Author              Comments
-------------------------------------------------------------
11-15-2022      Geeta Koli      	Created
------------------------------------------------------------*/
public class SENSAPI_UpsertMemberJourneyEventResponse implements IRestResponseWrapper {
    public SENSAPI_StatusResponse status;

	public SENSAPI_UpsertMemberJourneyEventResponse(){
        status = new SENSAPI_StatusResponse();
    }
    
    //public String sensActivityId;
    
    public ActivityDetail activityDetail;
    
    public class ActivityDetail {
        public String sensActivityId;
        public ActivityDetail(String sensActivityId){
            this.sensActivityId = sensActivityId;
        }
    }

}