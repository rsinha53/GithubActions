/**
* Author: Hasara Disanayaka
* Date Created: 30/06/2020
* Purpose: Function to call MemberSearchV2 service 
**/
public without sharing class ADBMemberSearchResponseWrapper {
    
    public Response response;
    
    public class Response {
        public List<MemberSearchItems> memberSearchItems;
    }
    
    public class MemberSearchItems {
        public String memberId;
        public String carrierId;
        public String accountId;
        public String groupId;          
        public String instanceId; 
        public MemberEffectiveDate memberEffectiveDate;
    }
    
    public class MemberEffectiveDate {
        public String fromDate;
        public String thruDate;
    }
    
}