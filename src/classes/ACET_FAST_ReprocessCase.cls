/*****************************************************************************************************
ACET_FAST_ReprocessCase 
Test Class Name:  ACET_FAST_ReprocessCaseTest
Author: Shaik Mohammad Yaseen
Description: This class is used to call the ACET_FAST_PlatformEventsHandler as the Reprocess button 
is clicked
Reference: US3660544 - CPU: Case Reprocess Button Action
04/07/2021 - Shaik Mohammad Yaseen - Initial
******************************************************************************************************/
public with sharing class ACET_FAST_ReprocessCase {
    @AuraEnabled
    public static void reProcessCase(string caseId){
        List<Case> caseListToSend = new List<Case>();
        caseListToSend = [SELECT id, status, CPU_Processing_Status__c, Interaction__c FROM Case WHERE id=:caseId];
        if(caseListToSend[0].CPU_Processing_Status__c=='Case Pending'){
            ACET_FAST_PlatformEventsHandler.firePlatformEvent(caseListToSend);  
        }else{
            caseListToSend[0].CPU_Processing_Status__c='Case Pending';
            update caseListToSend;
        }
    }
}