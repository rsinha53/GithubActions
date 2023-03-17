public with sharing class ECMEntitlementAssignmentHelper {
    
    public static final String ObjectName = 'EntitlementAssignment__c';

    private static List<String> assignmentFiledList;
    private static List<String> exculdeList = new List<String> {'CaseOrigin__c','TTS_Access__c','IsActive__c','ProfileName__c','EntitlementName__c',
                                                                'RoleName__c','TTS_ExternalID__c','Topic1__c','SortOrder__c'  ,'EntitlementAssignmentExternalID__c'     
                                                                };
    private static String assignmentFiled;
    static {
       //if(assignmentFiled == null){
                assignmentFiledList = new List<String>();
                assignmentFiled = ACETQueryUtil.consructCustomFieldQuery(ObjectName,exculdeList,assignmentFiledList);
            //}
        }

   
   /*
    Assign entitlement  id into case object
   */
    public static void assignEntitlementId(Case cas){
        ID entitlementId = null;
        String topic = '\''+ cas.Topic__c + '\'';
        User owner;
        //String query = assignmentFiled + ' where IsActive__c = true and Topic1__c =  '+ topic +'order by SortOrder__c asc' ;
        string TTSQueryString;
       // getting case owner ID
       try{
       List<User> owners = [Select userRole.parentRoleId,userRoleId,UserRole.Name,Profile.Name from User where id = : cas.OwnerId ];
       userRole parentRole ;
       userRole grandParentRole;
       if(owners.size() > 0){
        List<userRole> parentRolelist = [select Name,parentroleId from userRole where id =: owners[0].userRole.parentroleId LIMIT 1];
        if(parentRolelist.size() > 0){
            parentRole = parentRolelist[0];
            List<userRole> grandParentRolelist = [select Name,parentroleId from userRole where id =: parentRole.parentroleId LIMIT 1];
            grandParentRole = grandParentRolelist.size() > 0?grandParentRolelist[0]:null;
        }
       }
       if(cas.Type__c != null){
          
           if(cas.Subtype__c != null){          
               if(owners != null && owners[0].Profile != null && owners[0].Profile.Name != null && owners[0].Profile.Name != '' ){
                   TTSQueryString = 'Select id FROM TTS_Access__c WHERE Topic__c = \''+cas.Topic__c+'\' AND Type__c =\''+ cas.Type__c +'\' AND Subtype__c = \''+cas.Subtype__c+'\' AND (Limit_To_Profiles__c INCLUDES (\''+owners[0].Profile.Name+'\') OR Limit_To_Profiles__c = null OR Limit_To_Roles__c INCLUDES (\''+ owners[0].UserRole.Name+'\') OR Limit_To_Roles__c INCLUDES (\''+ parentRole.Name+'\') OR Limit_To_Roles__c INCLUDES (\''+ grandParentRole.Name+'\') )';
               }else{
                   TTSQueryString = 'Select id FROM TTS_Access__c WHERE Topic__c = \''+cas.Topic__c+'\' AND Type__c =\''+ cas.Type__c +'\' AND Subtype__c = \''+cas.Subtype__c+'\' ';
               }
           }else if(owners != null && owners[0].Profile != null && owners[0].Profile.Name != null && owners[0].Profile.Name != ''){
               TTSQueryString = 'Select id FROM TTS_Access__c WHERE Topic__c = \''+cas.Topic__c+'\' AND Type__c =\''+ cas.Type__c +'\' AND (Limit_To_Profiles__c INCLUDES (\''+owners[0].Profile.Name+'\') OR Limit_To_Profiles__c = null OR Limit_To_Roles__c INCLUDES (\''+ owners[0].UserRole.Name+'\') OR Limit_To_Roles__c INCLUDES (\''+ parentRole.Name+'\') OR Limit_To_Roles__c INCLUDES (\''+ grandParentRole.Name+'\') )';
           }else{
               TTSQueryString = 'Select id FROM TTS_Access__c WHERE Topic__c = \''+cas.Topic__c+'\' AND Type__c =\''+ cas.Type__c +'\' ';
           }
       }else{
               if(owners != null && owners.size() > 0 && owners[0].Profile != null && owners[0].Profile.Name != null && owners[0].Profile.Name != ''){
                   if(owners[0].UserRole != null && owners[0].UserRole.Name !=  null)
                       TTSQueryString = 'Select id FROM TTS_Access__c WHERE Topic__c = \''+cas.Topic__c+'\' AND (Limit_To_Profiles__c INCLUDES (\''+owners[0].Profile.Name+'\') OR Limit_To_Profiles__c = null )';
                   else{
                       TTSQueryString = 'Select id FROM TTS_Access__c WHERE Topic__c = \''+cas.Topic__c+'\' AND (Limit_To_Profiles__c INCLUDES (\''+owners[0].Profile.Name+'\') OR Limit_To_Profiles__c = null OR Limit_To_Roles__c INCLUDES (\''+ owners[0].UserRole.Name+'\') OR Limit_To_Roles__c INCLUDES (\''+ parentRole.Name+'\') OR Limit_To_Roles__c INCLUDES (\''+ grandParentRole.Name+'\'))';
                   } 
               }else{
                   TTSQueryString = 'Select id FROM TTS_Access__c WHERE Topic__c = \''+cas.Topic__c+'\'  ';
               }
        }
           
           system.debug('------TTSQueryString----->'+ TTSQueryString);
           List<TTS_Access__c> ttsList = Database.query(TTSQueryString);
           Set<Id> ttsIdset = new Set<Id>();
           system.debug('------ttsList----->'+ ttsList);
           for(TTS_Access__c tts:ttsList){
               ttsIdset.add(tts.Id);
           }
           system.debug('------ttsIdset----->'+ ttsIdset);
           String query = assignmentFiled + ' where IsActive__c = true and TTs_Access__c IN : ttsIdset order by SortOrder__c asc' ;
           map<id, userRole> userRoleMap = new map<id, userRole> ();
           if(owners != null && owners.size() > 0 ){
                set<id> currentAndparentRoleIds = new set<id>();
                for(user u : owners){
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
                system.debug(userRoleMap);
           }
            
           if(owners.size() > 0) {
            
              owner = owners[0];
           }
            
            for(EntitlementAssignment__c entitlement:Database.query(query)){
               system.debug('-----Entitlement----->'+ entitlement); 
               if(isBasicCriteriaMatch(cas,entitlement,owner,userRoleMap) && isStandrdCaseFieldMatch(cas,entitlement)){
                     system.debug('-----1----->'+ entitlement); 
                     List<String> valueCheckList = getNotNulValuesForEntitlement(entitlement);
                     system.debug('-----2----->'+ valueCheckList); 
                     Integer index = 0;
                     for(String consField:valueCheckList) {
                            system.debug('-----3----->'+ valueCheckList); 
                            if(IsFieldAvliable(cas,consField) && entitlement.get(consField) == cas.get(consField)){
                                system.debug('-----4----->'+ valueCheckList); 
                                index++;
                            }else{
                                break;
                            }
                        }
                        system.debug('-----5----->'+ valueCheckList.size() +'<----->'+ index); 
                        if(valueCheckList.size() == index) {
                            cas.EntitlementId  = entitlement.EntitlementName__c;
                            return;
                        }
                }
                
            }
        
        }
        Catch(exception e){
        
        }
        
    }

  /*
   
    To Match the case owner basic information
  */
  public static boolean isBasicCriteriaMatch(Case cas,EntitlementAssignment__c entitlement, user casOwner,map<id, userRole> userRoleMap) {
     boolean isMatched = false;
     if(casOwner != null) {    
        
            Set<String> setOfEAProfiles = new Set<String>();
            Set<String> setOfEARoles = new Set<String>();
            
            if(entitlement.ProfileName__c != null){
                setOfEAProfiles = getUniqueValues(entitlement.ProfileName__c);
            }         
            if(entitlement.RoleName__c != null){
                setOfEARoles = getUniqueValues(entitlement.RoleName__c);
            }  
            system.debug('-----11----->'+ setOfEAProfiles +'<----->'+ setOfEARoles); 
            system.debug('-----11.1----->'+ setOfEAProfiles.contains(casOwner.Profile.Name) +'<----->'+ isMatchedWithCurrentOrParentOrGrandParentRole(entitlement,setOfEARoles,casOwner,userRoleMap) );   
            if ((entitlement.ProfileName__c == null  ||  setOfEAProfiles.contains(casOwner.Profile.Name)) && 
                ( isMatchedWithCurrentOrParentOrGrandParentRole(entitlement,setOfEARoles,casOwner,userRoleMap) )){
                    system.debug('-----12----->'+ setOfEAProfiles +'<----->'+ setOfEARoles);   
                    isMatched = true;
            }else if(entitlement.ProfileName__c == null && entitlement.RoleName__c == null  ){
                system.debug('-----13----->'+ setOfEAProfiles +'<----->'+ setOfEARoles);   
                isMatched = true;
            } 
     }
      return isMatched;
  }
  
  public static boolean isMatchedWithCurrentOrParentOrGrandParentRole(EntitlementAssignment__c entitlement,Set<String> setOfRouteRoles,user caseOwner,map<id, userRole> userRoleMap ){
        if(entitlement.RoleName__c == null){
            return true;
        }else if(setOfRouteRoles != null){
            id userRoleId = caseOwner.UserRoleId;            
            system.debug('-----21----->'+ userRoleId +'<----->'+ setOfRouteRoles);   
            if(userRoleId != null && userRoleMap.get(userRoleId) != null && setOfRouteRoles.contains(userRoleMap.get(userRoleId).Name )){
                return true;
            }else if(userRoleId != null && userRoleMap.get(userRoleId) != null && userRoleMap.get(userRoleId).parentRoleId != null){
                id parentRoleId = userRoleMap.get(userRoleId).parentRoleId;
                system.debug('-----22----->'+ parentRoleId +'<----->'+ userRoleMap.get(userRoleId));   
                if(userRoleMap.get(parentRoleId) != null && setOfRouteRoles.contains(userRoleMap.get(parentRoleId).Name)){
                    return true;
                }else if(parentRoleId != null && userRoleMap.get(parentRoleId) != null){
                    id grandParentRoleId = userRoleMap.get(parentRoleId).parentRoleId;
                    system.debug('-----23----->'+ grandParentRoleId +'<----->'+ userRoleMap.get(parentRoleId));   
                    if(userRoleMap.get(grandParentRoleId) != null && setOfRouteRoles.contains(userRoleMap.get(grandParentRoleId).Name)){
                        return true;
                    }
                }
            }       
        }
        return false;
    }
  
 
 /*
  To Match the standard case field match
 */
  public static boolean isStandrdCaseFieldMatch(Case cas,EntitlementAssignment__c entitlement) {
     boolean isMatched = false;
        if ((entitlement.CaseOrigin__c == null || entitlement.CaseOrigin__c == cas.Origin)){
             isMatched = true;
     }
      return isMatched;
  }
 
 
     /*
      Find the list of field need to check in EntitlementAssignment__c
      */ 
      private static List<String> getNotNulValuesForEntitlement(EntitlementAssignment__c entitlement) {
        List<String> valueCheckList = new List<String>();
        for(String consField:assignmentFiledList) {
    
                if(entitlement.get(consField) != null){
                    valueCheckList.add(consField);
                }
            }
            return valueCheckList;
      }
    
     /*
      Make sure Case object have field is avliable
     */
    public static boolean IsFieldAvliable(SObject sobj,String consColoumn) {
        String objName = String.valueOf(sobj.getsObjectType());
        return Schema.getGlobalDescribe().get(objName).getDescribe().fields.getMap().get(consColoumn)!=null;
     }

    /*
   method to convert String of ';' separated values list of unique values
    */
   private static Set<String> getUniqueValues(String inputString){
       list<String> listOfValues = new list<String>();
       set<String> uniqueValues = new set<String>();          
                  
       if(inputString.contains(';')){           
            listOfValues= inputString.split(';');
       }
       else{
            listOfValues.add(inputString);
       }                
       if(listOfValues.size() >0){      
            for(String str :listOfValues){  
                if(!uniqueValues.contains(str.trim())){ 
                    uniqueValues.add(str.trim());
                }                                           
            }                          
       }        
        return uniqueValues;    
    } 
    
}