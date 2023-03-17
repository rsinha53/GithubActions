public with sharing class ACET_FAST_InteractionCtrl {
    
    @AuraEnabled
    public static InteractionWrapper getInteractionWrapper(string personAccId,string interactRecordId, string caseRecordType){
        ACET_FAST_InteractionCtrl.InteractionWrapper interWrapper = new ACET_FAST_InteractionCtrl.InteractionWrapper();
        interWrapper.personAccount= [SELECT id, Name,Par_Provider__c, Provider_Contact__c, Provider_Contact_Email__c, 
                                     Provider_Contact_Phone__c, Provider_Contact_Preference__c, Tax_Id__c, EID__c FROM Account 
                                     WHERE id=:personAccId];
        interWrapper.selectedRecordTypeName=caseRecordType;
        interWrapper.caseRec.Interaction__c = interactRecordId;
        string caseRectypeDevName = ACET_FAST_Constants.caseRcTypNameRcTypDevNameMap.get(caseRecordType);
        interWrapper.caseRec.RecordTypeId = ACET_FAST_InteractionCtrl.getRecordTypeIdbyDevName('Case',caseRectypeDevName);
        interWrapper.caseRec.PC_Provider_TIN__c=interWrapper.personAccount.Tax_Id__c;
        interWrapper.availableMarketList.addAll(ACET_FAST_Utility.getPiklistValues('Case','FAST_PIP_Markets__c'));
        interWrapper.availableProductList.addAll(ACET_FAST_Utility.getPiklistValues('PIR_Detail__c','Products__c'));
        system.debug('Available products-->'+ interWrapper.availableProductList);
        if(caseRecordType=='Reactive Resolution'){
            interWrapper.caseRec.AccountId=interWrapper.personAccount.id;
            interWrapper.caseRec.Case_Type__c = 'Reactive Resolution';
            interWrapper.caseRec.PC_Is_There_Active_PRs__c = interWrapper.personAccount.Par_Provider__c;
            interWrapper.caseRec.Provider_Contact_Preference__c = interWrapper.personAccount.Provider_Contact_Preference__c;
            interWrapper.caseRec.PC_External_Contact_Name__c = interWrapper.personAccount.Provider_Contact__c;
            interWrapper.caseRec.PC_External_Contact_Email__c = interWrapper.personAccount.Provider_Contact_Email__c;
             interWrapper.caseRec.PC_External_Contact_Phone__c = interWrapper.personAccount.Provider_Contact_Phone__c;
            interWrapper.caseOriginList = ACET_FAST_Constants.caseOriginList;
            interWrapper.topicList = ACET_FAST_Constants.caseTopicList;
            interWrapper.sumissionDelayReasonList.addAll(ACET_FAST_Utility.getPiklistValues('PIR_Detail__c','Reason_for_Submission_Delay__c'));
            interWrapper.pirDetailRecord.RecordTypeID = ACET_FAST_InteractionCtrl.getRecordTypeIdbyDevName('PIR_Detail__c','Reactive_Resolution_Partners');
            interWrapper.pirDetailRecord.No_Reference_Facilitated_Referral__c=true;
            interWrapper.pirDetailRecord.Exact_Count_Unknown_Multiple_Claims__c=true;
            interWrapper.pirDetailRecord.Provider_Contact__c = interWrapper.personAccount.Provider_Contact__c;
            interWrapper.pirDetailRecord.Provider_Contact_Preference__c = interWrapper.personAccount.Provider_Contact_Preference__c;
            interWrapper.pirDetailRecord.Provider_Contact_Phone__c = interWrapper.personAccount.Provider_Contact_Phone__c;
            interWrapper.pirDetailRecord.PC_External_Contact_Email__c = interWrapper.personAccount.Provider_Contact_Email__c;
            interWrapper.pirDetailRecord.Par_Provider__c = interWrapper.personAccount.Par_Provider__c;
        }else{
            interWrapper.caseRec.Case_Type__c = 'Proactive Action';
            interWrapper.spTeamList = ACET_FAST_Constants.caseSpecialtyList;
            interWrapper.topicList = ACET_FAST_Constants.caseTopicList;
            interWrapper.pirDetailRecord.RecordTypeID = ACET_FAST_InteractionCtrl.getRecordTypeIdbyDevName('PIR_Detail__c','Proactive_Action_Partner');
        }
        return interWrapper;
    }
    @AuraEnabled
    public static ACET_FAST_InteractionCtrl.CaseResultWrapper finalSubmit(string wrapperJSON){
        InteractionWrapper intWrapVar = (InteractionWrapper)JSON.deserialize(wrapperJSON, InteractionWrapper.class);
        System.debug(intWrapVar);
        intWrapVar.caseRec.FAST_PIP_Markets__c=ACET_FAST_InteractionCtrl.convertMultipickList(intWrapVar.selectedMarketList);
        intWrapVar.pirDetailRecord.Products__c=ACET_FAST_InteractionCtrl.convertMultipickList(intWrapVar.selectedProductList);
        ACET_FAST_InteractionCtrl.CaseResultWrapper finalResult = new  ACET_FAST_InteractionCtrl.CaseResultWrapper();
        try{
            insert intWrapVar.caseRec;
            intWrapVar.pirDetailRecord.Case__c=intWrapVar.caseRec.id;
            insert intWrapVar.pirDetailRecord;
            case insertedCaseRec = new case();
            insertedCaseRec = [SELECT id, CaseNumber FROM Case Where id=:intWrapVar.caseRec.id];
            finalResult.caseRecordId = insertedCaseRec.id;
            finalResult.result = 'SUCCESS';
            finalResult.errorMessage='Case '+insertedCaseRec.CaseNumber+' Created Successfully';
        }
        catch(exception ex){
            system.debug('exception'+ex.getMessage());
            finalResult.caseRecordId = '';
            finalResult.result = 'ERROR';
            finalResult.errorMessage=ex.getMessage();
        }
        return finalResult;
    }
    private static string convertMultipickList(List<String> strList){
        system.debug('strList==>'+strList);
        string str='';
        for(string s:strList){
            if(str==''){
                str= s; 
            }else{
                str=str+';'+s;
            }
        }
        system.debug('str==>'+str);
        return str;
    }
    public static Id getRecordTypeIdbyDevName(String objectName, String strRecordTypeDevName){
        return  Schema.getGlobalDescribe().get(objectName).getDescribe().getRecordTypeInfosByDeveloperName().get(strRecordTypeDevName).getRecordTypeId();
    }
    public class InteractionWrapper{
        @AuraEnabled
        public Account personAccount{get;set;}
        @AuraEnabled
        public Case caseRec{get;set;}
        @AuraEnabled
        public PIR_Detail__c pirDetailRecord{get;set;}
        @AuraEnabled
        public String selectedRecordTypeName{get;set;}
        @AuraEnabled
        public List<string> availableMarketList{get;set;}
        @AuraEnabled
        public List<string> selectedMarketList{get;set;}
		@AuraEnabled
        public List<string> availableProductList{get;set;}
        @AuraEnabled
        public List<string> selectedProductList{get;set;}
        @AuraEnabled
        public List<string> caseOriginList{get;set;}
        @AuraEnabled
        public List<string> topicList{get;set;}
        @AuraEnabled
        public List<String> typeList{get;set;}
        @AuraEnabled
        public List<String> subTypeList{get;set;}
        @AuraEnabled
        public List<String> spTeamList{get;set;}
        @AuraEnabled
        public List<String> sumissionDelayReasonList{get;set;}
        public InteractionWrapper(){
            personAccount = new Account();
            caseRec = new case();
            pirDetailRecord = new PIR_Detail__c();
            selectedRecordTypeName='';
            availableMarketList= new List<string>();
            selectedMarketList= new List<string>();
            availableProductList = new List<string>();
            selectedProductList = new List<string>();
            caseOriginList = new List<string>();
            topicList = new List<string>();
            typeList = new List<String>();
            subTypeList = new List<String>();
            sumissionDelayReasonList = new List<String>();
            spTeamList = new List<String>();
        }
    }
    public class CaseResultWrapper{
        @AuraEnabled
        public string caseRecordId{get;set;}
        @AuraEnabled
        public string result{get;set;}
        @AuraEnabled
        public string errorMessage{get;set;}
    }
}