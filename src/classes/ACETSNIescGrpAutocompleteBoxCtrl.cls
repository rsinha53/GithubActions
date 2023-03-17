public without sharing class ACETSNIescGrpAutocompleteBoxCtrl {
    @AuraEnabled
    public static List <String> fetchEscGroups(String searchKeyWord,  List<string> ExcludeitemsList) {     
        
       system.debug('searchKeyWord-----'+searchKeyWord);
        system.debug('ExcludeitemsList-----'+ExcludeitemsList);
        List<String> pickListValuesList = new List<String>();
        Schema.DescribeFieldResult fieldResult = case.Escalated_Group__c.getDescribe();
        List<Schema.PicklistEntry> ple = fieldResult.getPicklistValues();
        for( Schema.PicklistEntry pickListVal : ple){
            pickListValuesList.add(pickListVal.getLabel());
           // System.debug('Values in pickListValuesList are: '+pickListValuesList);
        }     
        list<string> lstFilterVals = new list<string>();
        if(searchKeyWord != null){
            searchKeyWord = searchKeyWord.toLowerCase();
        }
        for(string str : pickListValuesList){
            if(str.toLowerCase().startsWith(searchKeyWord)){
                if(ExcludeitemsList == null || ! ExcludeitemsList.contains(str)){
                    lstFilterVals.add(str);     
                }
            }
        }  
        System.debug('Values in lstFilterVals size is: '+lstFilterVals.size());
        return lstFilterVals;
    }
    @AuraEnabled
    public static void saveEscalationGrps(String caseId,  List<string> selEscGrps) {        
        system.debug('saveEscalationGrps-----'+selEscGrps);
        string escGrp ;
        if(selEscGrps != null){
            for(string str : selEscGrps){
                if(escGrp == null)
                    escGrp = str;
                else
                    escGrp = escGrp+';'+str;
            }
        }
        if(caseId != null){
            case objCase = new case();
            objCase.id = caseId;
            objCase.Escalated_Group__c = escGrp;
            update objCase;
        }
    }
    @AuraEnabled
    public static List <String> fetchExistingEscGroups(string caseId) { 
       list<case> lstaCase = [select id,Escalated_Group__c from case where id =: caseId ];
        list<string> retEscGrp = new list<string>();
        if(lstaCase != null && lstaCase.size()>0){
            string escGrp = lstaCase[0].Escalated_Group__c;
            if(escGrp != null){
                if(escGrp.contains(';')){
                    retEscGrp.addAll(escGrp.split(';'));
                }
                else{
                    retEscGrp.add(escGrp);
                }
            }
        }
        return retEscGrp;
    }
   @AuraEnabled
    public static boolean checkUserEditPermission(){
        Id profileId=userinfo.getProfileId();
        String profileName=[Select Id,Name from Profile where Id=:profileId].Name;
        if(profileName == 'Family Engagement Center - Read Only')
            return false;    
        else
            return true;
    }
}