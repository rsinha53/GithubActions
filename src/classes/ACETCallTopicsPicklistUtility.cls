public with sharing class ACETCallTopicsPicklistUtility {   
    
    public static String getTTSFilter(String callTopic){
        return JSON.serialize(getTTSFilterMap(callTopic)).replace('\'', '&#x27;');      
    }
    
    //get the limited type and subtype list based on profile and role
    public static Map<String, String> getTTSFilterMap(String callTopic){
        Map<String, string> accMap = new Map<String, String>();
        
        
        map<id, userRole> userRoleMap = getuserRoleMap();
        
        
        String userProfileName = ACETUtility.GetUserProfileName();
        List<TTS_Access__c> acceses = (List<TTS_Access__c>)ACETQueryUtil.query(null,'TTS_Access__c', 'Topic__c = \'' + callTopic + '\'', null);
        system.debug('acceses  ------>1'+acceses);
        for(TTS_Access__c acc : acceses){
            Boolean hasAccess = false;
            System.debug('acc.Limit_To_Roles__c:::::'+acc.Limit_To_Roles__c); // Added by Divya 
            //do not have role filter and excetp to profile filter for now
              
            //check if LimitToProfiles and LimitToRoles gives permission and then check if ExceptToRoles takes away permission                     
            if(acc.Limit_To_Profiles__c != null && acc.Limit_To_Profiles__c.split(';').contains(userProfileName)){
              hasAccess = true;   
           
            }
            //added 8/25/2017 -  US744460: Roles - Enable filtering on TTS Access by Role  
            if(acc.Limit_To_Roles__c != null && isMatchedWithCurrentOrParentOrGrandParentRoleSplit(acc.Limit_To_Roles__c, userRoleMap)){
                hasAccess = true;   
            }            
            if(!String.isEmpty(acc.Except_To_Roles__c) && isMatchedWithCurrentOrParentOrGrandParentRoleSplit(acc.Except_To_Roles__c, userRoleMap) ){
                hasAccess = false;    
            }
            
  
            
            if(!String.isEmpty(acc.Type__c) && hasAccess){          
                if(accMap.get(acc.Type__c) == null){
                    accMap.put(acc.Type__c, (acc.Subtype__c == null? 'None' : acc.Subtype__c));
                    //accMap.put(acc.Type__c, (acc.Subtype__c == null? '*' : acc.Subtype__c));
                }else{
                    //if 2 configuration with sampe type are found, one with sub type empty and one with sub type populated
                    //the first configuration overwrites the second one as first one means type level access is sepcified                   
                    if(accMap.get(acc.Type__c) == '*' || String.isEmpty(acc.Subtype__c)){
                        //access control on type level
                        accMap.put(acc.Type__c, '*');   
                    }else{
                        //access control on sub type level
                         if(!String.isEmpty(acc.Subtype__c)){
                            accMap.put(acc.Type__c, accMap.get(acc.Type__c) + ';' + acc.Subtype__c); 
                        }       
                    }                                       
                }   
            }           
        }
                        
        return accMap;
    }
    
    
    public static boolean isMatchedWithCurrentOrParentOrGrandParentRoleSplit(string role,map<id, userRole> userRoleMap ){
        if(role != null){
            for(userRole ur: userRoleMap.values()){
                if(role.split(';').contains(ur.Name)){                 
                    return true;
                }
            }     
        }
        return false;
    }
     public static boolean isMatchedWithCurrentOrParentOrGrandParentRole(string role,map<id, userRole> userRoleMap ){
        if(role != null){
            for(userRole ur: userRoleMap.values()){
                if(role.contains(ur.Name)){                 
                    return true;
                }
            }     
        }
        return false;
    }
    //Added by Krishna for HSA Topic Access
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
     //Added by Krishna for HSA Topic Access
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
    //  US2263098 - Member HSA Summary Page - Topic
     public static List<Call_Topic_Access__c> getCallTopics(String detailPageName, String originatorType, List<Id> lstExcludeitems, String searchKey){
        //List<Call_Topic_Access__c> accesses = (List<Call_Topic_Access__c>)ACETQueryUtil.query(null,'Call_Topic_Access__c', 'Detail_Page__c INCLUDES(' + '\'' + detailPageName + '\')', 'Name');
        // Create a Dynamic SOQL Query For Fetch Record List with LIMIT 5 and exclude already selected records  
        String sQuery =  'SELECT Id, Name, Limit_to_Public__c, Limit_To_Roles__c, Except_To_Roles__c, Originator_Type__c FROM Call_Topic_Access__c WHERE Name LIKE: searchKey'; 
       //Added by Prasad:US2967182 -Added one more OR condition(Optum Financial Detail) for Optum bank project related topics 
		if(detailpagename == 'Member Detail' || detailpagename == 'Member Not Found' || detailpagename =='Optum Financial Detail' || detailpagename == 'Motion Member Detail')
            sQuery = sQuery +' AND Id NOT IN : lstExcludeitems AND Detail_Page__c INCLUDES(:detailpagename) ORDER BY Name ASC';//AND Originator_Type__c INCLUDES (:originatortype)
        List <Call_Topic_Access__c> accesses = Database.query(sQuery);
        system.debug('acceses  ------>3'+accesses);
        map<id, userRole> userRoleMap = getuserRoleMap();
        Set<String> userPublicgrps =new Set<String>();
        if(accesses!=Null && accesses.size()>0){
          userPublicgrps = getUserPublicGrps(accesses);
        }
        List<Call_Topic_Access__c> result = new List<Call_Topic_Access__c>();
        for(Call_Topic_Access__c acc : accesses){
            if(!String.isEmpty(acc.Limit_To_Roles__c) &&  !(isMatchedWithCurrentOrParentOrGrandParentRole(acc.Limit_To_Roles__c, userRoleMap)) && (!String.isEmpty(acc.Limit_to_Public__c) && !(isMatchedWithCurrentPublicGrps(acc.Limit_to_Public__c,userPublicgrps)))){
                continue;   
            }
            if(!String.isEmpty(acc.Except_To_Roles__c) && isMatchedWithCurrentOrParentOrGrandParentRole(acc.Except_To_Roles__c, userRoleMap) && (!String.isEmpty(acc.Limit_to_Public__c) && !(isMatchedWithCurrentPublicGrps(acc.Limit_to_Public__c,userPublicgrps)))){
                continue;   
            }
            if((!String.isEmpty(acc.Limit_to_Public__c) && !(isMatchedWithCurrentPublicGrps(acc.Limit_to_Public__c,userPublicgrps))) && (String.isEmpty(acc.Limit_To_Roles__c)) && (String.isEmpty(acc.Except_To_Roles__c))){
               continue;
            }
            if(!String.isEmpty(acc.Originator_Type__c) && (originatorType == null || !acc.Originator_Type__c.contains(originatorType))){
                continue;   
            }
            result.add(acc);          
        }
        return result;  
    }
    
    public static List<String> getCallTopics(String detailPageName, String originatorType){
        List<Call_Topic_Access__c> accesses = (List<Call_Topic_Access__c>)ACETQueryUtil.query(null,'Call_Topic_Access__c', 'Detail_Page__c INCLUDES(' + '\'' + detailPageName + '\')', null);
        system.debug('acceses  ------>2'+accesses);
        map<id, userRole> userRoleMap = getuserRoleMap();
        Set<String> userPublicgrps =new Set<String>();
        if(accesses!=Null && accesses.size()>0){
          userPublicgrps = getUserPublicGrps(accesses);
        }
        
        List<String> result = new List<String>();
        for(Call_Topic_Access__c acc : accesses){
           if(!String.isEmpty(acc.Limit_To_Roles__c) &&  !(isMatchedWithCurrentOrParentOrGrandParentRole(acc.Limit_To_Roles__c, userRoleMap))){
                continue;   
            }
            if(!String.isEmpty(acc.Except_To_Roles__c) && isMatchedWithCurrentOrParentOrGrandParentRole(acc.Except_To_Roles__c, userRoleMap)){
                continue;   
            }
           /* if(!String.isEmpty(acc.Limit_To_Roles__c) &&  !(isMatchedWithCurrentOrParentOrGrandParentRole(acc.Limit_To_Roles__c, userRoleMap)) && (!String.isEmpty(acc.Limit_to_Public__c) && !(isMatchedWithCurrentPublicGrps(acc.Limit_to_Public__c,userPublicgrps)))){
                continue;   
            }
            if(!String.isEmpty(acc.Except_To_Roles__c) && isMatchedWithCurrentOrParentOrGrandParentRole(acc.Except_To_Roles__c, userRoleMap) && (!String.isEmpty(acc.Limit_to_Public__c) && !(isMatchedWithCurrentPublicGrps(acc.Limit_to_Public__c,userPublicgrps)))){
                continue;   
            }*/
            if((!String.isEmpty(acc.Limit_to_Public__c) && !(isMatchedWithCurrentPublicGrps(acc.Limit_to_Public__c,userPublicgrps))) && (String.isEmpty(acc.Limit_To_Roles__c)) && (String.isEmpty(acc.Except_To_Roles__c))){
               continue;
            }
            if(!String.isEmpty(acc.Originator_Type__c) && (originatorType == null || !acc.Originator_Type__c.contains(originatorType))){
                continue;   
            }
                                                        
            result.add(acc.Call_Topic__c);          
        }
        
        return result;  
    }
    
    public static List<SelectOption> getCallTopicOptions(String detailPageName, String originatorType){
        List<String> callTopics = getCallTopics(detailPageName, originatorType);
        
        callTopics.sort();
        List<SelectOption> options = new List<SelectOption>();
        
        for(String callTopic : callTopics){
                 options.add(new SelectOption(callTopic, callTopic));
        }
        system.debug('options :: '+options);
        
        
        return options; 
    }
    //Added the below method for US941813
    public static List<SelectOption> getCallTopicOptions(String detailPageName, String originatorType, string origRelationship, string thirdparty, string relationship){
        List<String> callTopics = getCallTopics(detailPageName, originatorType);     
        callTopics.sort();
        List<SelectOption> options = new List<SelectOption>();     
        system.debug('----callTopics---------'+callTopics);
        for(String callTopic : callTopics){  
                if((String.isEmpty(origRelationship)||String.isEmpty(relationship)|| relationship!='Self'|| origRelationship!='Self' || !String.isEmpty(thirdparty))&& callTopic==label.ACETCallTopicHSAAccount){        
                
                }   
                else{
                    options.add(new SelectOption(callTopic, callTopic));   
                }
                
        }
        system.debug('options :: '+options);
        return options; 
    }

    public static List<SelectOption> getCallTopicOptionsWithRestrictions(String detailPageName, String originatorType, String agentType, String onShoreRestrictionCode){
        List<String> callTopics = getCallTopics(detailPageName, originatorType);
        
        callTopics.sort();
        List<SelectOption> options = new List<SelectOption>();
        
        map<string,boolean> restricitionMapping = new map<string, boolean>();
        restricitionMapping = ACETRestrictionConfigurationUtil.getRestrictionConfigurations(agentType, onShoreRestrictionCode);
        //system.debug('restricitionMapping ::: '+restricitionMapping);
        if(callTopics != null && !callTopics.isEmpty()) {
            if(restricitionMapping.size() > 0) {
                for(String callTopic : callTopics) {
                    if(restricitionMapping.get(callTopic) != null) {
                        options.add(new SelectOption(callTopic, callTopic, restricitionMapping.get(callTopic)));
                    } else {
                        options.add(new SelectOption(callTopic, callTopic, false));
                    }   
                }
            }
            else {
                for(String callTopic : callTopics) {
                    options.add(new SelectOption(callTopic, callTopic, false));
                }
            }
        }
        //system.debug('options :: '+options);
        
        
        return options; 
    }
    
    public static List<String> getCallTopics(String detailPageName){
        List<Call_Topic_Access__c> accesses = (List<Call_Topic_Access__c>)ACETQueryUtil.query(null,'Call_Topic_Access__c', 'Detail_Page__c INCLUDES(' + '\'' + detailPageName + '\')', null);
        
        List<String> result = new List<String>();
        for(Call_Topic_Access__c acc : accesses){
            result.add(acc.Call_Topic__c);
        }
        
        return result;  
    }
    
    public static List<SelectOption> getCallTopicOptions(String detailPageName){
        List<String> callTopics = getCallTopics(detailPageName);
        
        callTopics.sort();
        List<SelectOption> options = new List<SelectOption>();
        for(String callTopic : callTopics){
            options.add(new SelectOption(callTopic, callTopic));
        }
        return options; 
    }  
    
    public static map<id, userRole> getuserRoleMap(){
        map<id, userRole> userRoleMap = new map<id, userRole> ();
        set<id> currentAndparentRoleIds = new set<id>(); 
        for(user u : [select id,userRoleId,userRole.parentRoleId from user where id=:userInfo.getuserId()]){
            if(u.userRoleId != null){
                currentAndparentRoleIds.add(u.userRoleId);
            }
            if(u.userRole.parentRoleId != null){
                currentAndparentRoleIds.add(u.userRole.parentRoleId);
            }
        }
        //getting parent, grand parent role id and Name
        set<id> roleIdsTillGrandParent = new set<id>();
        if(currentAndparentRoleIds.size() > 0){
            for(UserRole ur : [select id, Name, parentRoleId from userRole where id In:currentAndparentRoleIds]){
                roleIdsTillGrandParent.add(ur.id);
                roleIdsTillGrandParent.add(ur.parentRoleId);
            }
        }
        if(roleIdsTillGrandParent.size() > 0){
            userRoleMap = new map<id, userRole>([select id, Name, parentRoleId from userRole where id In:roleIdsTillGrandParent]);
        }
        return userRoleMap;
    }        
      
}