public with sharing class ACET_FAST_TeamMemberListViewController {
    /*apex method to fetch wrapper of list view*/ 
    @AuraEnabled
    public static list<ListViewWrapper> listValues(List<string> objectInfos){
 
        list<ListViewWrapper> oListViewWrapper = new list<ListViewWrapper>();
 
        for(ListView lv : [SELECT id, Name, DeveloperName,sObjectType FROM ListView
                           WHERE sObjectType = : objectInfos and (DeveloperName='Open_Cases_for_Supervisors' OR DeveloperName='Team_Members_Tasks') ORDER By Name ASC]){ 
            ListViewWrapper oWrapper = new ListViewWrapper();
            oWrapper.label = lv.Name;
            oWrapper.developerName = lv.DeveloperName;
             oWrapper.objectName = lv.sObjectType;
            oListViewWrapper.add(oWrapper);
        }
        
        return oListViewWrapper; 
    }
 
    /*wrapper class to store listView details*/ 
    
    public class ListViewWrapper{
        @AuraEnabled public string label{get;set;} 
        @AuraEnabled public string developerName{get;set;} 
        @AuraEnabled public string objectName{get;set;}
    }
}