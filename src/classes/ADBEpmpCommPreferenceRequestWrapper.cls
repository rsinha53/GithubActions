/**
* Author: Sai Kolluru
* Description : Wrapper class to hold request for EPMP Save for Communication PReference
*               
* Created Date : 11/20/2020
*/
public without sharing class ADBEpmpCommPreferenceRequestWrapper {

	public String lst_nm;
    public String first_nm;
    public String policy_nbr;
	public String subscriber_id;
	public String dob;
    public String paperless;
	public String electronicConsentID;
	public String mpConsentID;
	public String calling_app_name;
	public String user_id;
	public String user_type;
	
    public SaveStatus status;
	public class SaveStatus {
		public StatusMessages messages;
	}
	public class StatusMessages {
		public StatusMessageArray[] message;
	}
	public class StatusMessageArray {
		public String code;	//200
		public String severity;	//INFO
		public String description;	//Individual information successfully updated
	}
        public static ADBEpmpCommPreferenceRequestWrapper parse(String json) {
        return (ADBEpmpCommPreferenceRequestWrapper) System.JSON.deserialize(json, ADBEpmpCommPreferenceRequestWrapper.class);
    }
}