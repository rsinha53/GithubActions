/*****************************************************************************************************
ACET_FAST_sendIntIdToMSoft 
Test Class Name:  ACET_FAST_sendIntIdToMSoftTest
Author: Shaik Mohammad Yaseen
Description: This class is used as an handler for case trigger to send interaction record id to 
Mulesoft through platform eent
Reference: US3659697 - CPU: Interaction Automated Platform Event
30/06/2021 - Shaik Mohammad Yaseen - Initial
******************************************************************************************************/
public with sharing class ACET_FAST_sendIntIdToMSoft {
    public static Boolean isFirstTime = true;
    public static Id rrRecordTypeId = Schema.SObjectType.Case.getRecordTypeInfosByDeveloperName().get('Reactive_Resolution').getRecordTypeId();
    public static final String IMPACT_SYSTEM = 'Impact System';
    public static void sendCaseToImpact(List<Case> triggerNew){
        List<Case> caseListToSend = getImpactCases(triggerNew);
        if(caseListToSend.size()>0){
            ACET_FAST_PlatformEventsHandler.firePlatformEvent(caseListToSend);
        }
    }
    public static List<Case> getImpactCases(List<Case> triggerNew){
        List<Case> caseListToUpdate = new List<Case>();
        for(Case cNew: triggerNew){
            if(cNew.Interaction__c != null && cNew.RecordTypeId == rrRecordTypeId && cNew.Origin==IMPACT_SYSTEM && cNew.CPU_Processing_Status__c != 'Case Triaged' ){
                caseListToUpdate.add(cNew);
            }
        }
        return caseListToUpdate;
    }
}