public without sharing class ACETSNIProgramAssociationsCtrl {
    @AuraEnabled
    public static List <String> fetchProgAssociations(String searchKeyWord,  List<string> ExcludeitemsList) {     
        List<String> pickListValuesList = new List<String>();
        Schema.DescribeFieldResult fieldResult = Member_Information__c.Program_Associations__c.getDescribe();
        List<Schema.PicklistEntry> ple = fieldResult.getPicklistValues();
        for( Schema.PicklistEntry pickListVal : ple){
            pickListValuesList.add(pickListVal.getLabel());
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
        return lstFilterVals;
    }
    @AuraEnabled
    public static void saveProgAssociations(String membId,  List<string> selectedPrgAssc) {        
        string prgAssc ;
        if(selectedPrgAssc != null){
            for(string str : selectedPrgAssc){
                if(prgAssc == null)
                    prgAssc = str;
                else
                    prgAssc = prgAssc+';'+str;
            }
        }
        if(membId != null){
            Member_Information__c memInfo = new Member_Information__c();
            memInfo.Id = membId;
            memInfo.Program_Associations__c = prgAssc;
            update memInfo;
        }
    }
    @AuraEnabled
    public static List <String> fetchExistProgAssociations(string membId) { 
       list<Member_Information__c> lstmembInfo = [select Id,Program_Associations__c from Member_Information__c where Id =: membId ];
        list<string> retPrgAssc = new list<string>();
        if(lstmembInfo != null && lstmembInfo.size()>0){
            string prgAssc = lstmembInfo[0].Program_Associations__c;
            if(prgAssc != null){
                if(prgAssc.contains(';')){
                    retPrgAssc.addAll(prgAssc.split(';'));
                }
                else{
                    retPrgAssc.add(prgAssc);
                }
            }
        }
        return retPrgAssc;
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