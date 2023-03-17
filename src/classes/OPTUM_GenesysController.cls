/*
 Name           : OPTUM_GenesysController
 Created By     : Prasad kammella
 Created Date   : July 13, 2021
 Description    : Controller for Genesys Screen popup */
public with sharing class OPTUM_GenesysController {
    public PageReference run() {
        System.debug('>>>>> SCREENPOP URL = [' + ApexPages.currentPage().getUrl() + ']'); 
        System.debug('>>>>> SCREENPOP Parameters = [' + ApexPages.currentPage().getParameters() + ']');
        // get Genesys attached data
        String  faroid = OPTUM_Utils.getQueryParam(OPTUM_Constants.ENT_FinAcctGUID, '');
        System.debug('>>>>> Faroid = [' + faroid + ']');
        String firstName = OPTUM_Utils.getQueryParam(OPTUM_Constants.ENT_ContactFirstNm, '');
        System.debug('>>>>> Firstname = [' + firstName + ']'); 
        String lastName = OPTUM_Utils.getQueryParam(OPTUM_Constants.ENT_ContactLastNm, '');
        System.debug('>>>>> LastName = [' + lastName + ']'); 
         String fromaddress = OPTUM_Utils.getQueryParam(OPTUM_Constants.ENT_FromAddress, '');
        System.debug('>>>>> fromaddress = [' + fromaddress + ']');
         String toaddress = OPTUM_Utils.getQueryParam(OPTUM_Constants.ENT_ToAddress, '');
        System.debug('>>>>> toaddress = [' + toaddress + ']');
        String MSID = OPTUM_Utils.getQueryParam(OPTUM_Constants.DSK_MSID, '');
        System.debug('>>>>> Msid = [' + MSID + ']'); 
        String dob = OPTUM_Utils.getQueryParam(OPTUM_Constants.ENT_ContactDOB, '');
        System.debug('>>>>> dob = [' + dob + ']');
        String dob1 = parsedDate(dob);
        System.debug('>>>>> dob1 = [' + dob1 + ']');
        String skillNumber = OPTUM_Utils.getQueryParam(OPTUM_Constants.ENT_VQ, '');
        System.debug('>>>>> skillNumber = [' + skillNumber + ']'); 
        String callType = OPTUM_Utils.getQueryParam(OPTUM_Constants.ENT_CallType, '');
        System.debug('>>>>> callType = [' + callType + ']'); 
        String accountNumber = OPTUM_Utils.getQueryParam(OPTUM_Constants.ENT_ContactConstituentID, '');
        System.debug('>>>>> accountNumber = [' + accountNumber + ']');
       String employeeId = OPTUM_Utils.getQueryParam(OPTUM_Constants.ENT_FinSvcAcctID, '');
        System.debug('>>>>> employeeId = [' + employeeId + ']');
       String ssn = OPTUM_Utils.getQueryParam(OPTUM_Constants.ENT_ContactSSNLast4, '');
        System.debug('>>>>> ssn = [' + ssn + ']');
       String repeatCaller = OPTUM_Utils.getQueryParam(OPTUM_Constants.ENT_CampaignCD, '');
        System.debug('>>>>> repeatCaller = [' + repeatCaller + ']');
       String agentId = OPTUM_Utils.getQueryParam(OPTUM_Constants.ENT_AssignedAgentID, '');
        System.debug('>>>>> agentId = [' + agentId + ']'); 
       String ucId = OPTUM_Utils.getQueryParam(OPTUM_Constants.ENT_CallUUID, '');
        System.debug('>>>>> ucId = [' + ucId + ']');
       String flag = OPTUM_Utils.getQueryParam(OPTUM_Constants.ENT_VoiceprintInterestFlag, '');
        System.debug('>>>>> flag = [' + flag + ']');
       List<Account> accountList = [SELECT id,FirstName,LastName,EID__c,EID__pc,PersonBirthdate,RecordTypeId,ParticipantAdminAlias__c,ParticipantEmployeeExternalId__c,ParticipantEmployerCode__c FROM Account WHERE EID__c =:faroid limit 1 ];
       
      OPTUM_MemberSearchReponse returnVall;
       String  participantEmployeeExternalId;
       String  participantEmployerCode;
       String  participantAdminAlias;
       if(faroid!=null&&faroid!=''){
        returnVall =  (OPTUM_MemberSearchReponse)OPTUM_VCCDBridgeController.getMemberDetails(faroid);
          if(returnVall!=null&& returnVall.result!=null && returnVall.result.data!=null ){
          participantEmployeeExternalId = returnVall.result.data.accountDetails[0].accountId;
          participantEmployerCode= returnVall.result.data.accountDetails[0].accountAlias;
          participantAdminAlias= returnVall.result.data.accountDetails[0].employerAlias;
          }
     }
       if(faroid==null ||faroid==''){
  ApexPages.addmessage(new ApexPages.message(ApexPages.severity.INFO,'Unidentified Caller. Please use Member Search.'));
  ApexPages.addmessage(new ApexPages.message(ApexPages.severity.INFO,'Please close this tab.'));
         return null;   
       } 
       if(accountList.size()>0){
        OPTUM_MemberAccountController.createInteraction('phone','call',accountList[0],'question',returnVall.result.data);
        return new PageReference('/lightning/r/Account/' + accountList[0].Id + '/view'); 
       }
      else{
         Account OptumAcc = OPTUM_MemberAccountController.addPersonAccount( firstName,lastName,dob1,faroid,participantEmployeeExternalId,participantEmployerCode,participantAdminAlias);
         OPTUM_MemberAccountController.createInteraction('phone','call',OptumAcc,'question',returnVall.result.data);
         return new PageReference('/lightning/r/Account/' + OptumAcc.Id + '/view');
       } 
    }
     public static string parsedDate (String dateString) {
         if (String.isBlank(dateString)) {
            return null;
        }
        String month;
        String year;
        String day;
        for(integer i = 0; i < dateString.length(); i++) {
            if(i<2) {
                month = dateString.substring(0,2);
            } 
            if(i>=2 && i<=4) {
                day = dateString.substring(2,4);
            } 
            if(i>=4 && i<=8) {
                year = dateString.substring(4,8);
            }  
        }
        Date mydate = Date.newInstance(integer.valueOf(year),integer.valueOf(month),integer.valueOf(day));
       String dateOutput = mydate.format();
         return dateOutput;
    }  
  
}