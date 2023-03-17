public without sharing class ACET_FAST_ExplorePageCtrl {
    
    @AuraEnabled
	public static List < State__mdt > getStateValues() {
		List < State__mdt > stateList = [SELECT Id, DeveloperName, MasterLabel FROM State__mdt ORDER BY DeveloperName ASC];
		return stateList;
	}

	public class FlowDetails {
		@AuraEnabled public String interactionType {get;set;}
		@AuraEnabled public String contactName {get;set;}
		@AuraEnabled public String contactNumber {get;set;}
		@AuraEnabled public String contactExt {get;set;}
        @AuraEnabled public Object IVRInfo {get;set;}//US2903847
        @AuraEnabled public Boolean isGenesys {get;set;}//US2903847
        @AuraEnabled public string GeneysysQuestionType {get;set;}//US2903847
	}

    @AuraEnabled
    public static string getQuestionTypeValueforIVR(string questionTypeCode){
        String strQuestionType = '--';
        if(string.isNotBlank(questionTypeCode)){
        List<ACET_VCCD_Topic_Mappings__mdt> lstofVCCDMappings = [SELECT MappingValue__c FROM ACET_VCCD_Topic_Mappings__mdt where Label=:QuestionTypeCode.trim()];
        if(!lstofVCCDMappings.isEmpty()){
            strQuestionType = lstofVCCDMappings[0].MappingValue__c;
        }
        }
        return strQuestionType;
	}
    
        @AuraEnabled
    public static User getUserDetails(){
	        user usr = [SELECT Id, UserRoleId, ProfileId,profile.name, UserRole.Name FROM User Where Id =:UserInfo.getUserId()];
        return usr;
	}

}