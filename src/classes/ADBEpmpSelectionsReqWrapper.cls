/**
* Author: Sai Kolluru
* Description : Wrapper class to hold request for EPMP Save for Phone (GAN)
*               
* Created Date : 12/21/2020
*/
public without sharing class ADBEpmpSelectionsReqWrapper {
    
    public String lst_nm;
    public String first_nm;
    public String policy_nbr;
    public String subscriber_id;
    public String dob;
    public PreferenceCategory[] preferences;
    public String calling_app_name;
    public String user_id;
    public String user_type;
    
    public class PreferenceCategory{
        public String category;
        public String name;
        public String value;
    }
    public SaveStatus status;
    public class SaveStatus {
        public StatusMessages messages;
    }
    public class StatusMessages {
        public StatusMessageArray[] message;
    }
    public class StatusMessageArray {
        public String code;	//200
        public String name;
        public String severity;	//INFO
        public String description;	//Individual information successfully updated
    }
    public static ADBEpmpSelectionsReqWrapper parse(String json) {
        return (ADBEpmpSelectionsReqWrapper) System.JSON.deserialize(json, ADBEpmpSelectionsReqWrapper.class);
    }
}