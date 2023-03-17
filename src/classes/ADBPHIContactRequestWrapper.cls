/**
* Author: Hasara Disanayaka
* Date Created: 10/06/2020
* Purpose: PHI Contact Integration
**/
public without sharing class ADBPHIContactRequestWrapper {

	public MemberDetailRequest memberDetailRequest{ get; set; }
    public class MemberDetailRequest {
		public RequestHeader requestHeader{ get; set; }
		public IcueUserCDxRefIdentifierType icueUserCDxRefIdentifierType{ get; set; }
	} 
	public class IcueUserCDxRefIdentifierType {
		public String cdxRefId{ get; set; }
	} 
	public class RequestHeader {
		public String applicationName{ get; set; }
		public String userID{ get; set; }
	} 
    @AuraEnabled  public List<Member> member{ get; set; } 
        public class Member {
        @AuraEnabled public String memFirstName{ get; set; } 
        @AuraEnabled public String memLastName{ get; set; }
        }
}