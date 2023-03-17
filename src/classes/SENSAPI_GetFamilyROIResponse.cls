/*------------------------------------------------------------
Author:        Tushar Kaore
Description:   Response Wrapper for the service request "GET Family ROI"   

Test Class:    SENSAPI_GetFamilyROIReqProcessorTest
History
Date            Author              Comments
-------------------------------------------------------------
16 Nov,2022      Tushar Kaore      	Created
------------------------------------------------------------*/
public class SENSAPI_GetFamilyROIResponse implements IRestResponseWrapper {
    public SENSAPI_StatusResponse status;
    
    
    public SENSAPI_GetFamilyROIResponse(){
        status = new SENSAPI_StatusResponse();
    }
    
    
    public String subscriberId;
    public List<Member> members;
    
    public class ROIDetails {
        public String sensId;
        public Date submittedDate;
        public Date expiryDate;
        public String firstName;
        public String lastName;
        public String status;
    }
    
    public class Member {
        public String sensId;
        public String firstName;
        public String lastName;
        public List<ROIDetails> canBeViewedBy;
        public List<ROIDetails> canView;
        
        public Member(String sensId, String firstName, String lastName){
            this.sensId = sensId;
            this.firstName = firstName;
            this.lastName = lastName;
            this.canBeViewedBy = new List<ROIDetails>();
         	this.canView = new List<ROIDetails>();
        }
    }
    
    
    
}