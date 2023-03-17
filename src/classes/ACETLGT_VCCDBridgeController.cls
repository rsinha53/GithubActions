public class ACETLGT_VCCDBridgeController {

    /**
     * Used to Insert Incoming VCCD Details to VCCD Response Object.
     * Return Type : VCCD_Response__c for the Logged In User
     */
    @AuraEnabled
    public static clsVccdResponse getVCCDData() {
        String strQuestionType = '';
        clsVccdResponse objReturnResponse = null;
        User objUser = [Select id, FederationIdentifier from User where Id = : UserInfo.getUserId()];
        List<VCCD_Response__c> lstVCCDResponse = new List<VCCD_Response__c>();
        List<Call_Topic_Access__c> lstCallTopicTypes = new List<Call_Topic_Access__c>();

        lstVCCDResponse = [SELECT Id,Ani__c, Caller_Type__c, ClaimsDOSMD__c, ClaimId__c, MSID__c, MemberId__c, NPI__c, ProductType__c, QuestionTypeCode__c, SubjectDOB__c, QuestionType__c, TFN__c, TaxId__c, Ucid__c, isActive__c, eligibilityTypeCode__c, HIPPAFlag__c, producerID__c, groupID__c, legacyProviderId__c, AcctManagerPhone__c, claimsDOS__c, VisionClaimID__c, dentalClaimID__c, rcKeyCallId__c, dnis__c FROM VCCD_Response__c WHERE (MSID__c= :objUser.FederationIdentifier AND isActive__c = true) ORDER BY createddate desc];
         system.debug('lstVCCDResponse'+lstVCCDResponse);
         
      List<Call_Topic_Access__c> CallTopicAccess = [SELECT Id, Name FROM Call_Topic_Access__c where Name = : lstVCCDResponse[0].QuestionType__c limit 1];

        
        if(lstVCCDResponse.isEmpty() == false) {
            String CallTopicID = String.valueOf(CallTopicAccess[0].Id);
            
            objReturnResponse = new clsVccdResponse(lstVCCDResponse[0],CallTopicID);
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

    /**
     * Wrapper Class to Return the VccdResponse Object and Related Question Type
    */
    public class clsVccdResponse {
        @AuraEnabled public VCCD_Response__c objVccdResponse {get;set;} {objVccdResponse = new VCCD_Response__c();}
        @AuraEnabled public String strCallTopicType { get;set; } {strCallTopicType = '';}
        @AuraEnabled public String CallTopicID { get;set; } {CallTopicID = '';}

        public clsVccdResponse(VCCD_Response__c objResponse,String CallTopicID) {
            this.objVccdResponse = objResponse;
            this.CallTopicID = CallTopicID;
            
        }
    }
}