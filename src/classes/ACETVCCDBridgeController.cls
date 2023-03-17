public with sharing class ACETVCCDBridgeController {
    
    Public class resultwrap{
        @AuraEnabled
        Public VCCD_Response__c vccdObject{set;get;}
        @AuraEnabled
        Public string SubjectDOBstring{set;get;}
        @AuraEnabled
        Public String Dobstring{set;get;}
        @AuraEnabled
        Public string userptofilename{set;get;}
    }
    
    @AuraEnabled
    Public static resultwrap getVCCDData() {
        resultwrap rw = new resultwrap();
        User objUser = [Select id, FederationIdentifier,Profile.Name from User where Id = : UserInfo.getUserId()];
        List<VCCD_Response__c> lstVCCDResponse = new List<VCCD_Response__c>();
        lstVCCDResponse = [SELECT Id,Ani__c, Caller_Type__c, ClaimsDOSMD__c, ClaimId__c,DOB__c, MSID__c, MemberId__c, NPI__c, ProductType__c, QuestionTypeCode__c, SubjectDOB__c, QuestionType__c, TFN__c, TaxId__c, Ucid__c, isActive__c, eligibilityTypeCode__c, HIPPAFlag__c, producerID__c, groupID__c, legacyProviderId__c, AcctManagerPhone__c, claimsDOS__c, VisionClaimID__c, dentalClaimID__c, rcKeyCallId__c, dnis__c FROM VCCD_Response__c WHERE (MSID__c= :objUser.FederationIdentifier AND isActive__c = true) ORDER BY createddate desc];
        if(!lstVCCDResponse.isEmpty()){
         rw.vccdObject = lstVCCDResponse[0];
            if(lstVCCDResponse[0].SubjectDOB__c != null){
            rw.SubjectDOBstring = formatdate(lstVCCDResponse[0].SubjectDOB__c);
            }
            if(lstVCCDResponse[0].DOB__c != null){
                     rw.Dobstring = formatdate(lstVCCDResponse[0].DOB__c);
    
            }
         rw.userptofilename = objUser.Profile.Name;
        }
        return rw;
    }
    
    Public static string formatdate(date datevalue){
      Date d = datevalue; 
      return d.month()+'/'+d.day()+'/'+d.year();
    }
    
    @AuraEnabled
    Public static String updateCurrentRecordToInactive(string vccdrecordstring){
        Id vccdrecordid = Id.valueOf(vccdrecordstring);
         VCCD_Response__c recordtoupdate  = [Select id,isActive__c from VCCD_Response__c where id =: vccdrecordid limit 1];  
          recordtoupdate.isActive__c = false;
          update recordtoupdate;
        return vccdrecordstring;
    }
    
    @AuraEnabled
    public static User getUserDetails(){
        return [Select id, Name, Profile.Name ,FirstName, LastName from User Where id =: UserInfo.getUserId()];
    }
    
}