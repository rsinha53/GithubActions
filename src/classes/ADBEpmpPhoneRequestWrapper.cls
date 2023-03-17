/**
* Author: Sai Kolluru
* Description : Wrapper class to hold request for EPMP Save for Phone NUmber
* Created Date : 11/22/2020
*/
public without sharing class ADBEpmpPhoneRequestWrapper {
    public String lst_nm;
    public String first_nm;
    public String policy_nbr;
    public String subscriber_id;
    public String dob;
    public String phoneTypeCode;
    public String phoneTypeCodeDesc;
    public String telephoneNumber;
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
        public String description;//Individual information successfully updated
    }
    public static ADBEpmpPhoneRequestWrapper parse(String json) {
        return (ADBEpmpPhoneRequestWrapper) System.JSON.deserialize(json, ADBEpmpPhoneRequestWrapper.class);
    } 
}