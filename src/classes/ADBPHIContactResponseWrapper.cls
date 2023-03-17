/**
* Author: Hasara Disanayaka
* Date Created: 10/06/2020
* Purpose: PHI Contact Integration
**/
public without sharing class ADBPHIContactResponseWrapper {

	public MemberContactsResponse memberContactsResponse;
	public class MemberContactsResponse {
		public List<MemberContacts> memberContacts;
        	public MemberContacts singleMemberContact;
	}
	public class MemberContacts {
		public String firstName;
		public String lastName;
	}
    public static ADBPHIContactResponseWrapper parse(String json) {
      return (ADBPHIContactResponseWrapper) System.JSON.deserialize(json, ADBPHIContactResponseWrapper.class);
    }
}