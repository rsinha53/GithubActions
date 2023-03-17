/**
* Author: Hasara Disanayaka
* Description : Wrapper class to get the response back from Eligibility Extended Service
*               https://api-gateway-stage.linkhealth.com/elink-extended/api/coverageAttributes/v2.0
* AuraEnabled : False
* Created Date : 31/12/2019
*/
public without sharing class ADBEligibilityExtendedResponseWrapper {
    public String responseCode;
    public String responseMsg;
    public String responseDetailMsg;
    
    public MemberInfo memberInfo;
    public PostalAddress postalAddress;
    
    public class MemberInfo {
        public String relationship;
        public String firstName;
        public String lastName;
        public String dob;
        public List<Members> members;
    }
	public class PostalAddress {
		public String street1;
		public String street2;
		public String city;
		public String state;
		public String zip;
	}
    public class Members {
		public String relationship;
		public String firstName;
		public String lastName;
		public String dob;
	}
    public static ADBEligibilityExtendedResponseWrapper parse(String json) {
        return (ADBEligibilityExtendedResponseWrapper) System.JSON.deserialize(json, ADBEligibilityExtendedResponseWrapper.class);
    }
}