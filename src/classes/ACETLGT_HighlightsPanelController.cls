public class ACETLGT_HighlightsPanelController {
    
    public ACETLGT_HighlightsPanelController(){}
    
    public List<Alert__c> getNoAlert(String type, String memProId, String groupNo, string bundleId){
        String groupType = type + ' Group';
        List<Alert__c> tempListAlert = new List<Alert__c>();
        String query = '';
        User currentUser = [SELECT Profile.Name FROM USER WHERE Id =:UserInfo.getUserId()];
        List<Alert_Business_Segment__mdt> alertBusinessSegment = [
            SELECT 
            Business_Segment__c 
            FROM Alert_Business_Segment__mdt 
            WHERE MasterLabel =:currentUser.Profile.Name
        ];
        List<List <sObject>> searchList = new List<List<SObject>>();
        if(String.isBlank(groupNo) && String.isBlank(memProId)){
            return tempListAlert;
        }
		if(bundleId != null && bundleId != ''){
			query = 'FIND  \'' + bundleId + '\' IN ALL Fields Returning Alert__c';
          	query += ' (Id,SharePoint_ID__c,Type__c,Group_Number__c,ID_Number__c,Benefit_Bundle_Option_ID__c,Alert_Title__c,Effective_Date__c,Alert_Comments__c,End_Date__c WHERE Effective_Date__c <= TODAY AND End_Date__c >= TODAY '+(alertBusinessSegment!=null && alertBusinessSegment.size()>0?'AND Business_Segment__c=\''+alertBusinessSegment[0].Business_Segment__c+'\'':'')+' ORDER BY Type__c,Effective_Date__c DESC)';
          	searchList = search.query(query);
          	tempListAlert.addAll(((List<Alert__c>)searchList[0]));
		}
        if(String.isNotBlank(memProId) && memProId.length() > 1){
            query = 'FIND  \'' + memProId + '\' IN ALL Fields Returning Alert__c';
                query += ' (Id,SharePoint_ID__c,Type__c,Group_Number__c,ID_Number__c,Benefit_Bundle_Option_ID__c,Alert_Title__c,Effective_Date__c,Alert_Comments__c,End_Date__c WHERE Effective_Date__c <= TODAY AND End_Date__c >= TODAY '+(alertBusinessSegment!=null && alertBusinessSegment.size()>0?'AND Business_Segment__c=\''+alertBusinessSegment[0].Business_Segment__c+'\'':'')+' AND Type__c = \''+ type +'\'  ORDER BY Type__c,Effective_Date__c DESC)';
            searchList = search.query(query);
            tempListAlert.addAll(((List<Alert__c>)searchList[0]));
        }
        
        if(String.isNotBlank(groupNo) && groupNo.length() > 1){
            if(type==null){  
              query = 'FIND  \'' + groupNo + '\' IN ALL Fields Returning Alert__c';
              query += ' (Id,SharePoint_ID__c,Type__c,Group_Number__c,ID_Number__c,Benefit_Bundle_Option_ID__c,Alert_Title__c,Effective_Date__c,Alert_Comments__c,End_Date__c WHERE Effective_Date__c <= TODAY AND End_Date__c >= TODAY ORDER BY Type__c,Effective_Date__c DESC)';
            }else{
                type += ' Group';
                query = 'FIND  \'' + groupNo + '\' IN ALL Fields Returning Alert__c';
                    query += ' (Id,SharePoint_ID__c,Type__c,Group_Number__c,ID_Number__c,Benefit_Bundle_Option_ID__c,Alert_Title__c,Effective_Date__c,Alert_Comments__c,End_Date__c WHERE Effective_Date__c <= TODAY AND End_Date__c >= TODAY '+(alertBusinessSegment!=null && alertBusinessSegment.size()>0?'AND Business_Segment__c=\''+alertBusinessSegment[0].Business_Segment__c+'\'':'')+'AND Type__c = \''+ type +'\' ORDER BY Type__c,Effective_Date__c DESC)';
            }
            searchList = search.query(query);
            tempListAlert.addAll(((List<Alert__c>)searchList[0]));
        }
        
        
        return tempListAlert;  
    }

}