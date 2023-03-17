public with sharing class OPTUM_VCCDBridgeController {

    /**
     * Used to Insert Incoming VCCD Details to VCCD Response Object.
     * Return Type : VCCD_Response__c for the Logged In User
     */
    @AuraEnabled
    public static clsVccdResponse getVCCDData() {
        clsVccdResponse objReturnResponse = null;
        User objUser = [Select id, FederationIdentifier from User where Id = : UserInfo.getUserId()];
        List<VCCD_Response__c> lstVCCDResponse = new List<VCCD_Response__c>();
  
        lstVCCDResponse = [SELECT Id,Name,MSID__c,DOB__c,Skill__c,TFN__c,firstName__c,lastName__c, 
                           FaroId__c,SSN__c,CallerId__c,Employer__c,Payer__c,AccountNumber__c,CallReason__c FROM VCCD_Response__c WHERE (MSID__c= :objUser.FederationIdentifier  AND IsOptum__c = true) ORDER BY createddate desc];
         system.debug('lstVCCDResponse'+lstVCCDResponse);
        if(lstVCCDResponse.isEmpty() == false) {
            objReturnResponse = new clsVccdResponse(lstVCCDResponse[0]);
        }

        return objReturnResponse;
    }

    /**
     * Used to update current VCCDResponse Record
     * Return Type : No Return Type
     */
    @AuraEnabled
    public static void updateCurrentRecordToInactive(VCCD_Response__c objVccdResponse){
        if(objVccdResponse != null) {
            objVccdResponse.ownerId = UserInfo.getUserId();
            objVccdResponse.isActive__c = false;
            update objVccdResponse;
        }
    }

    /**
     * Used to return Current User Record
     * Return Type : User Object Instance
     */
    @AuraEnabled
    public static User getUserDetails(){
        return [Select id, Name, Profile.Name ,FirstName, LastName from User Where id =: UserInfo.getUserId()];
    }
	
	 @AuraEnabled
     public static Account addPersonAccount(String firstName,String lastName,String dob,String eid,String participantEmployeeExternalId,String participantEmployerCode,String participantAdminAlias) {
        Account OptumAcc = OPTUM_MemberAccountController.addPersonAccount( firstName, lastName, dob, eid, participantEmployeeExternalId, participantEmployerCode, participantAdminAlias);
        return OptumAcc;
    } 
	
    // Added memberDetails parameter as part of US3329760 by Venkat
    @AuraEnabled
    public static Interaction__c createInteraction(String InteractionType, String OriginatorType,Account con, String Question,Object memberDetails){
        Interaction__c interaction = OPTUM_MemberAccountController.createInteraction(InteractionType,OriginatorType,con,Question,memberDetails);
        return interaction;
    }

    /**
     * Wrapper Class to Return the VccdResponse Object and Related Question Type
    */
    public class clsVccdResponse {
        @AuraEnabled public VCCD_Response__c objVccdResponse {get;set;} {objVccdResponse = new VCCD_Response__c();}
        @AuraEnabled public String strCallTopicType { get;set; } {strCallTopicType = '';}
        public clsVccdResponse(VCCD_Response__c objResponse) {
            this.objVccdResponse = objResponse;
        }


    }
    /*
      Get Member details based on Faro ID to navigate to Details page
     */
    @AuraEnabled
    public static OPTUM_MemberSearchReponse getMemberDetails(String faroId) {
        OPTUM_MemberSearchReponse responseWrapper = new OPTUM_MemberSearchReponse();
        HttpResponse response;
        ACET_WebserviceCalloutFramework wsCallOutFW = new ACET_WebserviceCalloutFramework('OptumVCCDMemberSearch', '',null);
	    wsCallOutFW.certificateName = OPTUM_MemberSearchService.certName;
        wsCallOutFW.faroID = faroId;
        response = wsCallOutFW.getResponse();
        system.debug('response'+response);
        if(response.getStatusCode() == 200) {
            responseWrapper = OPTUM_MemberSearchReponse.parse(response.getBody());
        } else {
            responseWrapper.responseCode = String.valueOf(response.getStatusCode());
            responseWrapper.responseMsg = response.getStatus();
        }
        return responseWrapper; 
        
    }
public class MemberSearchException extends Exception {}
}