public with sharing class ECMCaseITemTriggerHelper {
    
    public static void handleBeforeInsert(list<Case_Item__c> triggerNew){
    	populateTypeAndSubType(triggerNew);
    }
    
    public static void populateTypeAndSubType(list<Case_Item__c> triggerNew){
    	try{
    	set<id> caseIDs = new set<id>();
    	for(Case_Item__c ci : triggerNew){
    		caseIDs.add(ci.Case__c);
    	}
    	if(!caseIds.IsEmpty()){
    		map<id, Case> caseMap = new map<id, Case>([select id, type__C, subtype__c from Case where id In:caseIds]);
    		for(Case_Item__c ci : triggerNew){
	    		if(caseMap.get(ci.Case__c) != null){
    				ci.Type__c = caseMap.get(ci.Case__c).Type__c;
    				ci.subtype__c = caseMap.get(ci.Case__c).subtype__c;
	    		}
	    	}
    	}
    	}catch(exception ex){
    		system.debug('Exception while populating caseItems type and subtype  -- '+ex.getMessage());
    	}
    }
}