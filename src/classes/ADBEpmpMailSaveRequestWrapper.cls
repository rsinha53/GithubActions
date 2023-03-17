/**
* Author: Sai Kolluru
* Description : Wrapper class to hold request for EPMP Save for Mail address
*               
* AuraEnabled : True
* Created Date : 11/18/2020
*/
public without sharing class ADBEpmpMailSaveRequestWrapper {
    @AuraEnabled public String lst_nm;
    @AuraEnabled public String first_nm;
    @AuraEnabled public String policy_nbr;
    @AuraEnabled public String subscriber_id;
    @AuraEnabled public String dob;
    @AuraEnabled public String email;
    @AuraEnabled public String emailTypeCode;
    @AuraEnabled public String emailTypeDesc;
    @AuraEnabled public String calling_app_name;
    @AuraEnabled public String user_id;
    @AuraEnabled public String user_type;
    @AuraEnabled public SaveStatus status;
    public class SaveStatus {
        @AuraEnabled public StatusMessages messages;
    }
    public class StatusMessages {
        @AuraEnabled public StatusMessageArray[] message;
    }
    public class StatusMessageArray {
        @AuraEnabled public String code;	//200
        @AuraEnabled public String severity;	//INFO
        @AuraEnabled public String description;//Individual information successfully updated
    }
    public static ADBEpmpMailSaveRequestWrapper parse(String json) {
        return (ADBEpmpMailSaveRequestWrapper) System.JSON.deserialize(json, ADBEpmpMailSaveRequestWrapper.class);
    } 
}