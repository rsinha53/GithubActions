/*****************************************************************************************************
ACET_FAST_ItoSCreateInteraction 
Test Class Name:  ACET_FAST_ItoSCreateInteractionTest
Author: Shaik Mohammad Yaseen
Description: This class is used as an handler for case trigger to create interaction record for 
impact to spire routed case. 
Reference:US3637678 - CPU: Interaction ID Creation
30/06/2021 - Shaik Mohammad Yaseen - Initial
******************************************************************************************************/
public without sharing class ACET_FAST_ItoSCreateInteraction {
    public static Boolean isFirstTime = true;
    public static Id rrRecordTypeId = Schema.SObjectType.Case.getRecordTypeInfosByDeveloperName().get('Reactive_Resolution').getRecordTypeId();
    public static final String IMPACT_SYSTEM = 'Impact System';
    
    public static void insertInteraction(List<Case> triggerNew){
        List<Case> casesToUpdate = getImpactCases(triggerNew);
        if(casesToUpdate.size()>0){
            List<Interaction__c> interactionList = getInterActionListToInsert(casesToUpdate.size());
            InteractionDmlResult intWrapper = insertInteractions(interactionList);
            updateCaseRecs(casesToUpdate, intWrapper, triggerNew);
        }
    }
    public static List<Case> getImpactCases(List<Case> triggerNew){
        List<Case> caseListToUpdate = new List<Case>();
        for(Case cNew: triggerNew){
            if(cNew.Interaction__c == null && cNew.RecordTypeId == rrRecordTypeId && cNew.Origin==IMPACT_SYSTEM){
                caseListToUpdate.add(cNew);
            }
        }
        return caseListToUpdate;
    }
    public static List<Interaction__c> getInterActionListToInsert(integer caseListSize){
        List<Interaction__c> caseListToInsert = new List<Interaction__c>();
        for(integer i=0; i<caseListSize;i++){
            caseListToInsert.add(assignInteraction());
        }
        return caseListToInsert;
    }
    public static Interaction__c assignInteraction(){
        Interaction__c interRec = new Interaction__c();
        interRec.Interaction_Type__c = 'Email';
        return interRec;
    }
    public static InteractionDmlResult insertInteractions(List<Interaction__c> interList){
        InteractionDmlResult intResult = new InteractionDmlResult();
        try{
            insert interList;
            intResult.intList = interList;
        }
        catch(exception ex){
            system.debug('error is '+ex.getMessage());
            intResult.isSuccess=false;
            intResult.message = ex.getMessage();
        }
        return intResult;
    }
    public static void updateCaseRecs(List<Case> caseList, InteractionDmlResult intWrapper, List<Case> triggerNew){
       if(intWrapper.isSuccess){
            map<id,id> caseIdInteractionIdMap = getCaseInteractionMap(caseList, intWrapper.intList);
            assignInteractionId(caseIdInteractionIdMap,triggerNew);
        }
        else
            throwError(triggerNew, intWrapper.message);
    }
    public static void throwError(List<Case> triggerNew, string errMessage){
        for(case c: triggerNew){
            string femsg = 'There was error while creating interaction record';
            String sBreak = '</br>';
            femsg = femsg+sBreak+errMessage;
            c.addError(femsg);
        }
    }
    public static void assignInteractionId(map<id,id> caseIdInteractionIdMap, List<Case> triggerNew){
        for(Case cNew: triggerNew){
            if(caseIdInteractionIdMap.containsKey(cNew.id)){
                cNew.Interaction__c=caseIdInteractionIdMap.get(cNew.id);
            }
        }
    }
    public static map<id,id> getCaseInteractionMap(List<Case> caseList, List<Interaction__c> inerList){
        map<id,id> cIdInterIdMap = new map<id,id>();
        if(caseList.size()==inerList.size()){
            for(integer j=0; j<caseList.size();j++){
                cIdInterIdMap.put(caseList[j].Id, inerList[j].Id);
            }
        }
        return cIdInterIdMap;
    }
    public class InteractionDmlResult{
        public boolean isSuccess;
        public string message;
        public List<Interaction__c> intList;
        public InteractionDmlResult(){
            this.isSuccess = true;
            this.message = 'SUCCESS';
            this.intList = new List<Interaction__c>();
        }
    }
}