/**
* Author: Hasara Disanayaka
* Date Created: 05/03/2020
* Date Modified:
* Purpose: To Capture the request needed for the service
* 
**/
public without sharing class ADBMPERequestWrapper {
    
    public memberProductEligibilityRequest MemberProductEligibilityRequest;
    public class memberProductEligibilityRequest {
        public RequestHeader requestHeader{ get; set; }
        public ConsumerDetails consumerDetails{ get; set; }
        public FilteringAttributes filteringAttributes{ get; set; }
        public RequestDetails requestDetails{ get; set; }
    }
    public class FilteringAttributes {
        public Boolean includeExtendedAttributes{ get; set; }
        public Boolean applyFilters{ get; set; }
    }
    public class RequestHeader {
        public String applicationName{ get; set; }
        public String transactionId{ get; set; }
    }
    public class RequestDetails {
        public String requestType{ get; set; }
        public String searchType{ get; set; }
        public String eventDate{ get; set; }
    }
    public class ConsumerDetails {
        public String firstName{ get; set; }
        public String lastName{ get; set; }
        public String dateOfBirth{ get; set; }
        public String searchId{ get; set; }
        public List<String> contractNumbers{ get; set; }
    } 
}