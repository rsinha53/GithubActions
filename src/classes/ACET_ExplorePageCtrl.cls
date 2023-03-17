public without sharing class ACET_ExplorePageCtrl {
    
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
    public static string getQuestionTypeValueforIVR(string QuestionTypeCode){
        String strQuestionType = '--';
        if(string.isNotBlank(QuestionTypeCode)){
        List<ACET_VCCD_Topic_Mappings__mdt> lstofVCCDMappings = [SELECT MappingValue__c FROM ACET_VCCD_Topic_Mappings__mdt where Label=:QuestionTypeCode.trim()];
        if(!lstofVCCDMappings.isEmpty()){
            strQuestionType = lstofVCCDMappings[0].MappingValue__c;
        }
        }
        return strQuestionType;
	}

	//US3463210 - Sravan
        @AuraEnabled
        public static string getClaimProjectManagement(String sourceCode){
            String claimProjectManagement = '';
            if(sourceCode != null && String.isNotBlank(sourceCode)){
                sourceCode = 'CPM '+ sourceCode;
                List<Tool_Tip__c> toolTipList = [Select id,Value__c,SOP_or_Document_Link__c from Tool_Tip__c where Value__c =:sourceCode];
                if(toolTipList != null && !toolTipList.isEmpty()){
                    claimProjectManagement = toolTipList[0].SOP_or_Document_Link__c;
                }
            }
            return claimProjectManagement;

        }

    @AuraEnabled
    public static String getTPSMValues(String providerId, String adTaxId) {
        String TPSMValue;
        try{

    	SAE_ProviderSnapshotWrapper.ReturnResponse pDetails =SAE_ProviderSnapshotController.getProviderDataForClaim(providerId,adTaxId,true);
                //String pti='--';
                System.debug('pDetails'+pDetails);
                if(pDetails != null ){
                    if(pDetails.AdditionalDetails != null && pDetails.isSuccess ){
                    TPSMValue=pDetails.AdditionalDetails.TPSMLevel;
                    }
    			}
            system.debug(TPSMValue);
        }Catch(Exception ex){
        	System.debug('Exceptipon '+ex.getMessage());
        }
        return TPSMValue;
		}

}