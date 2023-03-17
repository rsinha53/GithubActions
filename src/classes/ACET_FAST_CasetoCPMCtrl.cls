/*****************************************************************************************************
ACET_FAST_ACET_FAST_CasetoCPMCtrl
Test Class Name:  ACET_FAST_ACET_FAST_CasetoCPMCtrlTest
Author: Karimulla Shaik
Description: This class is used to get case record and update the Record type value and Case Owner name. 
Reference US2853274 - FAST & E2E - Creating a case for CPM
01/05/2021 - Karimulla Shaik - Initial
******************************************************************************************************/

public with sharing class ACET_FAST_CasetoCPMCtrl {
   
    @AuraEnabled
    public static ACET_FAST_CasetoCPMCtrl.CpmWrapper initializeCaseWrapper(string caseId){
        ACET_FAST_CasetoCPMCtrl.CpmWrapper wrap = new ACET_FAST_CasetoCPMCtrl.CpmWrapper();
        wrap.caseRec = [SELECT id, CaseNumber,Status, PC_Referral_Number__c,  Retro_Reason_Code__c, Submitting_Department__c,
                        CreatedDate, PC_Submitter_First_name__c, PC_Intake_Queue_Assignment_Date__c, PC_Submitter_Last_Name__c,
                        PC_Intake_Coordinator_Name__c, Topic__c, Type__c, Subtype__c, PC_Contact_Type__c, PC_Internal_Contact_Name__c, 
                        PC_External_Contact_Name__c, PC_Internal_Contact_Phone__c, PC_External_Contact_Phone__c, PC_Internal_Contact_Email__c,
                        PC_External_Contact_Email__c, Priority, ContactId, Description, Origin, SuppliedEmail, Subject, PC_Project_Description__c,
                        Provider_Type__c, PC_Provider_Name__c, PC_Provider_ID__c, PC_Provider_TIN__c, PC_Provider_State__c, C_S_TX_Product__c
                        FROM Case WHERe id=:caseId ];
        wrap.caseRec.Topic__c='';
        wrap.topicList.addAll(new List<String>{ 'Proactive', 'Provider Driven'});
        wrap.projectSubRec.case__c = wrap.caseRec.id;
        return wrap;
    }
	@AuraEnabled
    public static ACET_FAST_CasetoCPMCtrl.CaseResultWrapper sendToCPM(string wrapperJSON){
        system.debug('inside');
        //type case the json
        ACET_FAST_CasetoCPMCtrl.CpmWrapper cpmCaseWrapper = (ACET_FAST_CasetoCPMCtrl.CpmWrapper) JSON.deserialize(wrapperJSON, ACET_FAST_CasetoCPMCtrl.CpmWrapper.class);
        system.debug('cpmCaseWrapper==>'+cpmCaseWrapper);
		//initialize the reqult wrapper
        ACET_FAST_CasetoCPMCtrl.CaseResultWrapper resultWrap = new ACET_FAST_CasetoCPMCtrl.CaseResultWrapper();
        
        resultWrap.caseRecordId = cpmCaseWrapper.caseRec.id;
        resultWrap.isSuccess=true;
        try{
            system.debug('inside try');
            cpmCaseWrapper.caseRec.RecordTypeID = Schema.SObjectType.Case.getRecordTypeInfosByDeveloperName().get('Claim_Project_Management').getRecordTypeId();
            update cpmCaseWrapper.caseRec;
            system.debug('after update case');
            insert cpmCaseWrapper.projectSubRec;
            system.debug('after projectSubRec insert');
            resultWrap.message = 'Records Updated Successfully';
            
        }
        catch(exception ex){
            system.debug('inside exception');
            resultWrap.isSuccess=false;
            resultWrap.message = ex.getMessage();
            system.debug('exception message==>'+ex.getMessage());
        }
        return resultWrap;
    }
    Public class CpmWrapper{
        @AuraEnabled
        public Case caseRec{get;set;}
        @AuraEnabled
        public Project_Submission_Detail__c projectSubRec{get;set;}
        @AuraEnabled
        public List<String> topicList{get;set;}
        @AuraEnabled
        public List<String> typeList{get;set;}
        @AuraEnabled
        public List<String> subTypeList{get;set;}
        @AuraEnabled
        public boolean isFirstScreen{get;set;}
        
        public CpmWrapper(){
            caseRec = new case();
            projectSubRec = new  Project_Submission_Detail__c(); 
            topicList = new List<String>();
            typeList = new List<String>();
            subTypeList = new List<String>();
            isFirstScreen= true;
        }
    }
    public class CaseResultWrapper{
        @AuraEnabled
        public string caseRecordId{get;set;}
        @AuraEnabled
        public boolean isSuccess{get;set;}
        @AuraEnabled
        public string message{get;set;}
    }
}