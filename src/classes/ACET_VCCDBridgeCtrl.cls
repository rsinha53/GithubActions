/* 
   Description : This class is used to continously Poll incoming details VCCD Response Object 
   Author : Jitendra Anagani
   Date : 04/06/2020
*/

public class ACET_VCCDBridgeCtrl {

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

        lstVCCDResponse = [SELECT Id,Ani__c, ClaimId__c, ClaimsDOSMD__c, MemberId__c, MSID__c, NPI__c, ProductType__c, QuestionType__c, QuestionTypeTopic__c, SubjectDOB__c,
                                  TaxId__c, TFN__c, Ucid__c,isActive__c FROM VCCD_Response__c WHERE (MSID__c= :objUser.FederationIdentifier AND isActive__c = true AND isSpire__c = true) ORDER BY createddate desc];

        if(lstVCCDResponse.isEmpty() == false) {
            /*strQuestionType = '%' + lstVCCDResponse[0].QuestionType__c + '%';
            lstCallTopicTypes = [select id, Name,Detail_Page__c from Call_Topic_Access__c Where Name Like :strQuestionType AND Detail_Page__c IN ('Member Detail','Provider Detail','Group Not Found')];
            objReturnResponse = new clsVccdResponse(lstVCCDResponse[0], (lstCallTopicTypes.isEmpty() == true ? '--' : (lstCallTopicTypes[0].Name != null ? lstCallTopicTypes[0].Name : '--')));*/
            objReturnResponse = new clsVccdResponse(lstVCCDResponse[0], lstVCCDResponse[0].QuestionTypeTopic__c);
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
        return [Select id, Name, Profile.Name, User_Type__c, FirstName, LastName, FederationIdentifier from User Where id =: UserInfo.getUserId()];
    }

    /**
     * Wrapper Class to Return the VccdResponse Object and Related Question Type
    */
    public class clsVccdResponse {
        @AuraEnabled public VCCD_Response__c objVccdResponse {get;set;} {objVccdResponse = new VCCD_Response__c();}
        @AuraEnabled public String strCallTopicType { get;set; } {strCallTopicType = '';}

        public clsVccdResponse(VCCD_Response__c objResponse, String strQuestion) {
            this.objVccdResponse = objResponse;
            this.strCallTopicType = strQuestion;
        }

        public clsVccdResponse() {

        }
    }

}