/**
* Author: Sai Kolluru
* Description : Wrapper class to hold request for EPMP Save for Phone (GAN)
*               
* Created Date : 12/21/2020
*/
public without sharing class ADBEpmpSavePhoneNumberGAN {
    
    public String lst_nm;
    public String first_nm;
    public String policy_nbr;
    public String subscriber_id;
    public String dob;
    public String phoneNumber;
    public String c360Identifier;
    public String activationCode;
    public String timeZone;
    public String role;
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
        public String name;
        public String severity;//INFO
        public String description;//Individual information successfully updated
    }
    public static ADBEpmpSavePhoneNumberGAN parse(String json) {
        return (ADBEpmpSavePhoneNumberGAN) System.JSON.deserialize(json, ADBEpmpSavePhoneNumberGAN.class);
    }
}