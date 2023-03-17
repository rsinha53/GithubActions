public with sharing class ACET_GenesysKVPCntrl {
    
    public PageReference getGenesysData() {
        
        //Object Vairables
        Map<String, Object> mapKeyValuePairs = new Map<String, Object>();
        
        //Fill Map Variables
        mapKeyValuePairs.put('Ani__c', Utils.getQueryParam(Constants.UDATA_KEY_ENT_FromAddress, ''));
        mapKeyValuePairs.put('ClaimId__c', Utils.getQueryParam(Constants.UDATA_KEY_ENT_ClaimId, ''));
        mapKeyValuePairs.put('ClaimsDOSMD__c', Utils.getQueryParam(Constants.UDATA_KEY_ENT_ICMClaimsDOS, ''));
        mapKeyValuePairs.put('MemberId__c', Utils.getQueryParam(Constants.UDATA_KEY_ENT_SubjectConstituentID, ''));
        mapKeyValuePairs.put('MSID__c', Utils.getQueryParam(Constants.UDATA_KEY_ENT_AgentID, ''));
        mapKeyValuePairs.put('NPI__c', Utils.getQueryParam(Constants.UDATA_KEY_ENT_ContactConstituentID, ''));
        mapKeyValuePairs.put('ProductType__c', Utils.getQueryParam(Constants.UDATA_KEY_ENT_ICMProductType, ''));
        mapKeyValuePairs.put('QuestionType__c', Utils.getQueryParam(Constants.UDATA_KEY_ENT_ICMQuestionType, ''));
        mapKeyValuePairs.put('TaxId__c', Utils.getQueryParam(Constants.UDATA_KEY_ENT_ContactGroupID, ''));
        mapKeyValuePairs.put('Ucid__c', Utils.getQueryParam(Constants.UDATA_KEY_Cisco_Gucid, ''));
        mapKeyValuePairs.put('SubjectDOB__c', Utils.getQueryParam(Constants.UDATA_KEY_ENT_SubjectDOB, ''));
        mapKeyValuePairs.put('TFN__c', Utils.getQueryParam(Constants.UDATA_KEY_ENT_ToAddress, ''));
        
        String strKeys = JSON.serialize(mapKeyValuePairs);
        
        System.debug('strKeys ' + mapKeyValuePairs);
        PageReference objPageReference = new PageReference('/lightning/cmp/c__ACET_GenesysKVPListenerCmp');
        objPageReference.setAnchor(strKeys);
        return objPageReference;
    }

}