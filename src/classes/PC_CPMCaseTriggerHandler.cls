/********************************************************************************
Class Name: PC_CPMCaseTriggerHandler
Purpose: This class is handling complexity of Case trigger functionality associated 
        to Claim Project Management.
Developer: Suman Kundu
Created On: 7/22/2018 
********************************************************************************/
public with sharing class PC_CPMCaseTriggerHandler {
    // Below method populates Case's Onshore Restriction field based on TTS selection. 
    public static void populateOnshoreRestriction(List<SObject> newList, List<SObject> oldList) {
        Set<String> topics = new Set<String>();
        Set<String> types = new Set<String>();
        Set<String> subtypes = new Set<String>();
        Boolean needSearch = false;
        Id cpmRecTypeId = Schema.SObjectType.Case.getRecordTypeInfosByName().get('Claim Project Management').getRecordTypeId();
        for (Integer index = 0; index < newList.size(); index++) {
            Case nCase = (Case) newList[index];
            if (nCase.RecordTypeId != cpmRecTypeId) {
                continue;
            }
            Case oCase;
            if (oldList != null) {
                oCase = (Case) oldList[index];
                if (nCase.Topic__c != null && nCase.Type__c != null && nCase.Subtype__c != null && 
                    (nCase.Type__c != oCase.Type__c) || (nCase.Subtype__c != oCase.Subtype__c)) {
                    topics.add(nCase.Topic__c);
                    types.add(nCase.Type__c);
                    subtypes.add(nCase.Subtype__c);
                    needSearch = true;
                }
            } else if (nCase.Topic__c != null && nCase.Type__c != null && nCase.Subtype__c != null) {
                topics.add(nCase.Topic__c);
                types.add(nCase.Type__c);
                subtypes.add(nCase.Subtype__c);
                needSearch = true;
            }
        }
        if (needSearch) {
            Map<String, Map<String, Map<String, String>>> topicDependencyMap = new Map<String, Map<String, Map<String, String>>>();
            for (Routing_Configuration__c rConfig : [SELECT Id, Name, Topic1__c, Type__c, Subtype__c, Onshore_Restriction__c 
                                                     FROM Routing_Configuration__c
                                                     WHERE Topic1__c IN: topics AND Type__c IN: types AND Subtype__c IN: subtypes
                                                     ORDER BY Topic1__c, Type__c, Subtype__c]) {
                if (rConfig.Topic1__c != null && !topicDependencyMap.containsKey(rConfig.Topic1__c)) {
                    topicDependencyMap.put(rConfig.Topic1__c, new Map<String, Map<String, String>>());
                }
                if (rConfig.Topic1__c != null && rConfig.Type__c != null && 
                     !topicDependencyMap.get(rConfig.Topic1__c).containsKey(rConfig.Type__c)) {
                    topicDependencyMap.get(rConfig.Topic1__c).put(rConfig.Type__c, new Map<String, String>());
                }
                if (rConfig.Topic1__c != null && rConfig.Type__c != null && rConfig.Subtype__c != null && 
                     !topicDependencyMap.get(rConfig.Topic1__c).get(rConfig.Type__c).containsKey(rConfig.Subtype__c)) {
                    topicDependencyMap.get(rConfig.Topic1__c).get(rConfig.Type__c).put(rConfig.Subtype__c, rConfig.Onshore_Restriction__c);
                }
            }
            for (Integer index = 0; index < newList.size(); index++) {
                Case nCase = (Case) newList[index];
                if (nCase.RecordTypeId != cpmRecTypeId) {
                    continue;
                }
                Case oCase;
                if (oldList != null) {
                    oCase = (Case) oldList[index];
                    if (nCase.Topic__c != null && nCase.Type__c != null && nCase.Subtype__c != null && 
                        (nCase.Type__c != oCase.Type__c) || (nCase.Subtype__c != oCase.Subtype__c) && 
                        topicDependencyMap.get(nCase.Topic__c) != null && topicDependencyMap.get(nCase.Topic__c).get(nCase.Type__c) != null &&
                        topicDependencyMap.get(nCase.Topic__c).get(nCase.Type__c).get(nCase.Subtype__c) != null) {
                        nCase.Onshore_Restriction__c = topicDependencyMap.get(nCase.Topic__c).get(nCase.Type__c).get(nCase.Subtype__c);
                    }
                } else if (nCase.Topic__c != null && nCase.Type__c != null && nCase.Subtype__c != null &&
                    topicDependencyMap.get(nCase.Topic__c) != null && topicDependencyMap.get(nCase.Topic__c).get(nCase.Type__c) != null &&
                    topicDependencyMap.get(nCase.Topic__c).get(nCase.Type__c).get(nCase.Subtype__c) != null) {
                    nCase.Onshore_Restriction__c = topicDependencyMap.get(nCase.Topic__c).get(nCase.Type__c).get(nCase.Subtype__c);
                }
            }
        }
    }
    
    // Below method validates whether required details are populated during case closure
    public static void validateCaseClosure(List<SObject> newList, List<SObject> oldList) {
        Id cpmRecTypeId = Schema.SObjectType.Case.getRecordTypeInfosByName().get('Claim Project Management').getRecordTypeId();
        Set<Id> closedCaseIds = new Set<Id>();
        for (Integer index = 0; index < newList.size(); index++) {
            Case nCase = (Case) newList[index];
            if (nCase.RecordTypeId != cpmRecTypeId) {
                continue;
            }
            Case oCase;
            if (oldList != null) {
                oCase = (Case) oldList[index];
                if (nCase.Status == 'Closed' && nCase.Status != oCase.Status) {
                    closedCaseIds.add(nCase.Id);
                }
            }
        }
        if (closedCaseIds.size() > 0) {
            Map<Id, Boolean> caseCloseableMap = new Map<Id, Boolean>();
            list<Project_Details__c> projList = new list<Project_Details__c>();
            projList = [SELECT Id, Parent_Case__c, Closure_Code__c, Root_Cause__c
                                            FROM Project_Details__c
                                            WHERE Parent_Case__c IN: closedCaseIds];
             system.debug('>>>size'+projList.size());                               
            for (Project_Details__c proj : projList) {
                    caseCloseableMap = new Map<Id, Boolean>();
                        
                    if (proj.Closure_Code__c != null && proj.Root_Cause__c != null) {
                        caseCloseableMap.put(proj.Parent_Case__c, true);
                    } else {
                        caseCloseableMap.put(proj.Parent_Case__c, false);
                        break;
                    }
                
            }
            for (SObject ins : newList) {
                if (closedCaseIds.contains(ins.Id) && (!caseCloseableMap.containsKey(ins.Id) || 
                    !caseCloseableMap.get(ins.Id))) {
                        if(caseCloseableMap.size() > 0){
                            ins.addError('Please provide Root Cause and Closure Code on CPM Project Form to close the case.');
                        }
                    
                }
            }
        }
    }
}