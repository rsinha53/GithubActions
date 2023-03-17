/*------------------------------------------------------------
Description:   Handler for AssociatedCasesTrigger  
               
Test Class:    AssociatedCasesTriggerTest
History
Date            Author              Comments
-------------------------------------------------------------
09-02-2022      Manmeet Kaur        Created
------------------------------------------------------------*/
public class AssociatedCasesTriggerHandler {
	/*
     * Desc: To update the Related_Cases_Text__c field on the Case with the
     * 		 newly associated Case
     */
    public static void populateRelatedCases(Map<Id, Associated_Cases__c> associatedCasesNewMap, Boolean isDelete){
        Set<Id> caseIdSet = new Set<Id>();
        for(Associated_Cases__c associatedCase: associatedCasesNewMap.values()){
            caseIdSet.add(associatedCase.Case__c);
            caseIdSet.add(associatedCase.Parent_Case__c);
        }
        set<Id> currentRecordsSet = associatedCasesNewMap.keyset();
        String queryString ='SELECT'
            				 + ' Id,'
                             + ' Case__c,'
                             + ' Case__r.CaseNumber,'
                             + ' Case__r.status,'
                             + ' Parent_case__c,'
                             + ' Parent_case__r.CaseNumber,'  
                             + ' Parent_case__r.Status'      
                             + ' FROM'
                             + ' Associated_Cases__c'
                             + ' WHERE'
                             + ' (Case__c IN: caseIdSet OR '
                             + ' Parent_Case__c IN: caseIdSet)';
        
        /*if the associatedCases is being deleted
        * then remove it from the related_cases_text__c  
		*/
        if(isDelete){
            queryString = queryString + ' AND '
                                      + 'Id NOT IN: currentRecordsSet';
        }
        Map<Id,Case> updateCaseMap = new Map<Id,Case>();
        //to get existing AssociatedCases
		List<Associated_Cases__c> associatedCsLst = database.query(queryString);
        Map<Id,String> relatedCasesMap = new Map<Id,String>();
        if(associatedCsLst.size()>0){
            for(Associated_Cases__c associatedCase: associatedCsLst){
                populateHyperlinks(relatedCasesMap,associatedCase.Case__c,associatedCase.Parent_case__r.CaseNumber,associatedCase.Parent_case__c);
                populateHyperlinks(relatedCasesMap,associatedCase.Parent_case__c,associatedCase.case__r.CaseNumber,associatedCase.case__c);
            }
            for(Id csId: relatedCasesMap.keyset()){
                updateCaseMap.put(csId, new Case(Id = csId, Related_Cases_Text__c = relatedCasesMap.get(csId)));
            }
        }else{
            for(Id csId: caseIdSet){
                updateCaseMap.put(csId, new Case(Id = csId, Related_Cases_Text__c = ''));
            }
        }
        if(updateCaseMap.values().size()>0){
            update updateCaseMap.values();
        }
    }
	/*
     * Desc: To populate hyperlinks on Related_Cases_Text__c 
     * 		 field on the Associated Case Numbers
     */
    public static Map<Id, String> populateHyperlinks(Map<Id, String> relatedCasesMap, String csId , String associatedCaseNumber, String associatedCaseId){        
        if(relatedCasesMap.containsKey(csId)){
            String related_Cases = relatedCasesMap.get(csId);
            related_Cases = related_Cases==''?related_Cases:related_Cases+',';
            String hlink = '<a href=/' + associatedCaseId + '>'+ associatedCaseNumber + '</a>';
            related_Cases = related_Cases + hlink;
            relatedCasesMap.put(csId,related_Cases); 
        }else{
            String hlink = '<a href=/' + associatedCaseId + '>'+ associatedCaseNumber + '</a>';
            relatedCasesMap.put(csId,hlink);
        }            
        return relatedCasesMap;
    }
    
}