public without sharing class ECMTypeSubTypeUtil{

    
    //Whenver case is inserted populating Case's type and subtype on case Item
    //Whenver case is updated and type and subtype values are changed, updating values on Unresolved case items
    public static void updateTypeAndSubTypeOnCaseItem(list<case> triggerNew, map<id, case> oldMap){
        try{
            set<id> caseIds = new set<id>();
             
            for(Case newCase: triggerNew){
                Case oldCase = oldMap.get(newCase.id);
                if(!string.isBlank(newCase.Type__c) || !string.isBlank(newCase.Subtype__c)){
                    if(newCase.Type__c != oldCase.Type__c || newCase.Subtype__c != oldCase.Subtype__c){
                        caseIds.add(newCase.id);
                    }
                }
            }
            
            
            if(!caseIds.isEmpty()){
                map<id,list<Case_Item__c>> mapOfCaseIdListOfCaseItems = new map<id,list<Case_Item__c>>();//Map of caseID and list of Case_Item__c
                list<Case_Item__c> caseItemsToUpdate = new list<Case_Item__c>();
                caseItemsToUpdate = [select id,Resolved__c,Case__c from Case_Item__c where Case__c in:caseIds and Resolved__c = false];
                system.debug(caseItemsToUpdate);
                for(Case_Item__c ci : caseItemsToUpdate){
                    if(mapOfCaseIdListOfCaseItems.get(ci.Case__c) != null){
                        mapOfCaseIdListOfCaseItems.get(ci.Case__c).add(ci);
                    }else{
                        mapOfCaseIdListOfCaseItems.put(ci.Case__c,new list<Case_Item__c>{ci});
                    }
                }
                caseItemsToUpdate.clear();
                if(!mapOfCaseIdListOfCaseItems.isEmpty()){
                    for(Case newCase : triggerNew){
                        if(mapOfCaseIdListOfCaseItems.get(newCase.id) != null){
                            for(Case_Item__c ci : mapOfCaseIdListOfCaseItems.get(newCase.id)){
                                ci.Type__c = newCase.Type__c;
                                ci.Subtype__c = newCase.Subtype__c;
                                caseItemsToUpdate.add(ci);
                            }
                        }
                    }
                }
                if(!caseItemsToUpdate.isEmpty()){
                    update caseItemsToUpdate;
                }
                
            }
        }catch(exception ex){
            system.debug('Exception while updating caseItems type and subtype  -- '+ex.getMessage());
        }
    }

}