/*****************************************************************************************************
ACET_FAST_CloneCaseCtrl
Test Class Name:  ACET_FAST_CloneCaseCtrlTest
Author: Shaik Mohammad Yaseen
Description: This class is used an controller for ACET_FAST_CloneCase Components. 
Reference US3213864 - Clone a Case
01/25/2021 - Shaik Mohammad Yaseen - Initial
******************************************************************************************************/

public with sharing class ACET_FAST_CloneCaseCtrl {
    
    @AuraEnabled
    public static ACET_FAST_CloneCaseCtrl.CloneCaseWrapper getCaseRecord(id caseId){
        ACET_FAST_CloneCaseCtrl.CloneCaseWrapper wrapRec = new ACET_FAST_CloneCaseCtrl.CloneCaseWrapper();
        wrapRec.caseRecord = [SELECT id,CaseNumber, Interaction__c FROM Case WHERE id=:caseId];
        
        List<PIR_Detail__c> pirDetailList = new List<PIR_Detail__c>();
        pirDetailList = [SELECT id, Used_For_Cloning__c FROM PIR_Detail__c WHERE case__c=:caseId];
        if(pirDetailList.size()>0){
            wrapRec.pirId = pirDetailList[0].id;
            wrapRec.hasCaseClonedEarlier = pirDetailList[0].Used_For_Cloning__c;
        }
        return wrapRec;
    }
    @AuraEnabled
    public static ACET_FAST_CloneCaseCtrl.ResultWrapper cloneCaseAndRelatedRecords(string wrapperJSON){
        ACET_FAST_CloneCaseCtrl.ResultWrapper rsltWrap = new ACET_FAST_CloneCaseCtrl.ResultWrapper();
        try{
            CloneCaseWrapper cloneCaseWrap = (CloneCaseWrapper)JSON.deserialize(wrapperJSON, CloneCaseWrapper.class);	
        	//handle Interaction
            id intId = cloneCaseWrap.caseRecord.Interaction__c;
            if(intId==null){
                Interaction__c intRec = new Interaction__c(Interaction_Type__c='Email');
                insert intRec;
                intId = intRec.Id;
            }
            else if(cloneCaseWrap.cloneInteraction){
                intId=ACET_FAST_CloneCaseCtrl.cloneIntRec(intId);
            }
            //handle case Clone
            id clonedCaseRecID = ACET_FAST_CloneCaseCtrl.cloneCase(cloneCaseWrap.caseRecord.id ,intId);
            //handle PIR Detail Clone
            id pirId;
            if(clonedCaseRecID!=null){
                pirId = ACET_FAST_CloneCaseCtrl.clonePirDetailRec(clonedCaseRecID,cloneCaseWrap.caseRecord.CaseNumber, cloneCaseWrap.pirId);
            }
            if(intId != null && clonedCaseRecID != null && pirId!=null){
                rsltWrap.isSuccess = true;
                rsltWrap.caseId = clonedCaseRecID;
                rsltWrap.caseNumber= [SELECT CaseNumber FROM Case WHERE id=: clonedCaseRecID].CaseNumber;
                rsltWrap.message = 'Case '+rsltWrap.caseNumber+' Successfully Created';
            }else{
                rsltWrap.isSuccess = false;
                rsltWrap.message = 'There was a error while cloning case pls contact your administrator';
            }
        }
        catch(exception ex){
            rsltWrap.isSuccess = false;
            rsltWrap.message = ex.getMessage();
        }
        return rsltWrap;
    }
    public static id cloneIntRec(id interactionId){
        List<Interaction__c> interactionList = new List<Interaction__c>();
        interactionList = [SELECT id, Interaction_Type__c FROM Interaction__c WHERE id=:interactionId];
        id clonedINtId;
        Interaction__c clonedInteraction = new Interaction__c();
        if(interactionList.size()>0){
            clonedInteraction  = interactionList[0].clone(false, false, false, false);
            insert clonedInteraction;
            clonedINtId = clonedInteraction.id;
        }
        return clonedINtId;
    }
    public static List<String> getCaseFieldSets(){
        List<String> fields = new List<String>();
        FieldSet fieldsToClone = SObjectType.Case.fieldSets.ACET_FAST_CloneCaseFieldSet;
        for (FieldSetMember field : fieldsToClone.getFields()) {
            fields.add(field.getFieldPath());
        }
        return fields;
    }
    public static id cloneCase(id caseIdToClone, id interId){
        id clonedCaseId;
        List<String> caseFields = ACET_FAST_CloneCaseCtrl.getCaseFieldSets(); 
        String soql = 'SELECT ' + String.join(caseFields, ',') + ' FROM Case WHERE Id = \'' + String.escapeSingleQuotes(caseIdToClone) + '\'';
        List<Case> caseList = new List<Case>();
        caseList = Database.query(soql);
        Case clonedCase = new case();
        if(caseList.size()>0){
            clonedCase  =caseList[0].clone(false, false, false, false);
            clonedCase.Interaction__c= interId;
            clonedCase.Is_Cloned__c=true;
            clonedCase.status='New';            
            insert clonedCase;
            clonedCaseId=clonedCase.Id;
        }
        return clonedCaseId;
    }
    public static List<String> getPIRDetailFieldSets(){
        List<String> fields = new List<String>();
        FieldSet fieldsToClone = SObjectType.PIR_Detail__c.fieldSets.ACET_FAST_ClonePIRDetail;
        for (FieldSetMember field : fieldsToClone.getFields()) {
            fields.add(field.getFieldPath());
        }
        return fields;
    }
    public static id clonePirDetailRec(id caseID, string caseNumber, id pirID){
        id clonedPIRId;
        List<String> pirFields = ACET_FAST_CloneCaseCtrl.getPIRDetailFieldSets(); 
        String soql = 'SELECT ' + String.join(pirFields, ',') + ' FROM PIR_Detail__c WHERE Id = \'' + String.escapeSingleQuotes(pirID) + '\'';
        List<PIR_Detail__c> pirList = new List<PIR_Detail__c>();
        pirList = Database.query(soql);
        PIR_Detail__c clonedPir = new PIR_Detail__c();
        if(pirList.size()>0){
            clonedPir  =pirList[0].clone(false, false, false, false);
            clonedPir.Case__c = caseID;
            clonedPir.Status__c='Open';
            clonedPir.Cloned_From_Case_Number__c=caseNumber;
            insert clonedPir;
            clonedPIRId=clonedPir.Id;
            pirList[0].Used_For_Cloning__c=true;
            update pirList[0];
        }
        return clonedPIRId;
    }
    public class CloneCaseWrapper{
        @AuraEnabled
        public case caseRecord{set;get;}
        @AuraEnabled
        public id pirId{set;get;}
        @AuraEnabled
        public boolean hasCaseClonedEarlier{set;get;}
        @AuraEnabled
        public boolean cloneInteraction{set;get;}
        public CloneCaseWrapper(){
            caseRecord = new Case();
            hasCaseClonedEarlier= false;
            cloneInteraction=false;
        }
    }
    public class ResultWrapper{
        @AuraEnabled
        public id caseId{set;get;}
        @AuraEnabled
        public String caseNumber{set;get;}
        @AuraEnabled
        public boolean isSuccess{set;get;}
        @AuraEnabled
        public string message{set;get;}
    }
}