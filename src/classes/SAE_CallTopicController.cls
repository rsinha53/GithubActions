public class SAE_CallTopicController {
	@AuraEnabled
    public static List < sObject > fetchLookUpValues(String searchKeyWord, String ObjectName, List<sObject> ExcludeitemsList, string detailpagename, string originatortype) {
        system.debug('-----In Controller---->'+ searchKeyWord + '<----->'+ObjectName+'<------>'+ExcludeitemsList);
        String searchKey = '%' + searchKeyWord + '%';
        List < sObject > returnList = new List < sObject > ();

        List<string> lstExcludeitems = new List<string>();
        for(sObject item : ExcludeitemsList ){
            lstExcludeitems.add(item.id);
        }
        // Create a Dynamic SOQL Query For Fetch Record List with LIMIT 5 and exclude already selected records
        String sQuery =  'select id, Name, Limit_to_Public__c from ' +ObjectName + ' where Name LIKE: searchKey AND Detail_Page__c INCLUDES(:detailpagename) AND Originator_Type__c INCLUDES (:originatortype) order by Name ASC';
        system.debug('sQuery>>> ' + sQuery);
        //List < sObject > lstOfRecords = Database.query(sQuery);
        List < Call_Topic_Access__c > accesses = Database.query(sQuery);

        //ketki 08/28- copied over public user group code from ACETCallTopicsPicklistUtility
        Set<String> userPublicgrps =new Set<String>();
        if(accesses!=Null && accesses.size()>0){
          userPublicgrps = getUserPublicGrps(accesses);
        }
        List<Call_Topic_Access__c> result = new List<Call_Topic_Access__c>();
        system.debug('-----In 1---->'+accesses);
        for(Call_Topic_Access__c acc : accesses){

            if((!String.isEmpty(acc.Limit_to_Public__c) && !(isMatchedWithCurrentPublicGrps(acc.Limit_to_Public__c,userPublicgrps)))){
               continue;
            }

            result.add(acc);
        }
        system.debug('-----In 2---->'+result);
        return result;
    }

    //ketki  08/28- copied over public user group code from ACETCallTopicsPicklistUtility
    public static Set<String> getUserPublicGrps(List<Call_Topic_Access__c> calltopics){
        Set<String> usrPublicGrps = new Set<String>();
        Set<String> pubGrps = new Set<String>();
        Set<String> grpIds = new Set<String>();

        for(Call_Topic_Access__c calltopic: calltopics){
           if(!String.isEmpty(calltopic.Limit_to_Public__c)){
              String s= calltopic.Limit_to_Public__c;
              s=s.replaceAll(';',',');
              pubGrps.add(s);
           }
        }
        for(Group usrGrp: [SELECT Id,DeveloperName FROM Group where DeveloperName IN: pubGrps]){
          grpIds.add(usrGrp.Id);
        }
        if(grpIds!=Null && grpIds.size()>0){
        for(GroupMember member : [ SELECT Id, GroupId, UserOrGroupId,Group.Id,Group.DeveloperName,Group.Type
                                 FROM GroupMember WHERE UserOrGroupId=:userInfo.getuserId() AND Group.Type = 'Regular' AND GroupId IN (SELECT Id FROM Group)]){
             usrPublicGrps.add(member.Group.DeveloperName);
       }
      }
       return usrPublicGrps;
    }

     public static boolean isMatchedWithCurrentPublicGrps(String limitPublicGrps,Set<String> userPublicgrps){
        if(limitPublicGrps != null){
            for(String ur: userPublicgrps){
                if(limitPublicGrps.contains(ur)){
                    return true;
                }
            }
        }
        return false;
    }
}