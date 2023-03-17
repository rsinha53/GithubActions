public  with sharing  class ECMCaseRoutingHelper {


    public static final String ObjectName = 'Routing_Configuration__c'; 
    private static List<String> assignmentFiledList;
    /*
     Add execulded field in Routing configuration
    */
    private static List<String> exculdeList = new List<String> {'IsActive__c','TTS_Access__c','ProfileName__c','Queue_Name__c',
                                                                'RoleName__c','TTS_ExternalID__c','Topic1__c','Priority__c', 'Status__c' , 'SortOrder__c' , 'CurrentQueue__c','RoutingConfigurationExternalID__c','Comments__c'
                                                                }; 
    /*
     Load all the coloumn required for to match from cases and user information
    */
    private static String assignmentFiled;
    static {
            if(assignmentFiled == null){
                assignmentFiledList = new List<String>();
                assignmentFiled = ACETQueryUtil.consructCustomFieldQuery(ObjectName,exculdeList,assignmentFiledList);
            }
        }

    
 /*
  To check any standard case field values are match routing configuration valeus
 */
 public static boolean isStandrdCaseFieldMatch(Case cas,Routing_Configuration__c routingConfig , String currenQueueName) {
       boolean isMatched = false;
       
       if((routingConfig.Priority__c == null || routingConfig.Priority__c == cas.Priority) && 
          (routingConfig.Status__c == null || routingConfig.Status__c == cas.status) &&
          (routingConfig.CurrentQueue__c == null || routingConfig.CurrentQueue__c == currenQueueName)
          ) {
             isMatched = true;
        } 
    return isMatched;
  }
  
  /*
  To check case owner information match routing configuration  if case owner is other than queue then we can consider is matched 
 */
  public static boolean isBasicCriteriaMatch(Case cas,Routing_Configuration__c routingConfig , user caseOwner,map<id, userRole> userRoleMap) {
     boolean isMatched = false;
     if(caseOwner != null) {
            Set<String> setOfRouteRoles = new Set<String>();
            Set<String> setOfRouteProfiles = new Set<String>();
            
            if(routingConfig.RoleName__c != null){
                setOfRouteRoles= getUniqueValues(routingConfig.RoleName__c);
            }
            if(routingConfig.ProfileName__c != null){
                setOfRouteProfiles= getUniqueValues(routingConfig.ProfileName__c);
            }
            if( (routingConfig.ProfileName__c == null  ||  setOfRouteProfiles.contains(caseOwner.Profile.Name) ) &&
                (isMatchedWithCurrentOrParentOrGrandParentRole(routingConfig,setOfRouteRoles,caseOwner,userRoleMap) )  ) {
                    isMatched = true; 
            }
     }else if(routingConfig.ProfileName__c == null && routingConfig.RoleName__c == null ){
            isMatched = true;
     }
     return isMatched;
  }
  
  
    public static boolean isMatchedWithCurrentOrParentOrGrandParentRole(Routing_Configuration__c routingConfig,Set<String> setOfRouteRoles,user caseOwner,map<id, userRole> userRoleMap ){
        System.debug('setOfRouteRoles--->' +setOfRouteRoles);
        if(routingConfig.RoleName__c == null){
            return true;
        }else if(setOfRouteRoles != null){
            id userRoleId = caseOwner.UserRoleId;
            if(userRoleId != null && userRoleMap.get(userRoleId) != null && setOfRouteRoles.contains(userRoleMap.get(userRoleId).Name )){
                return true;
            }else if(userRoleId != null && userRoleMap.get(userRoleId) != null && userRoleMap.get(userRoleId).parentRoleId != null){
                id parentRoleId = userRoleMap.get(userRoleId).parentRoleId;
                if(userRoleMap.get(parentRoleId) != null && setOfRouteRoles.contains(userRoleMap.get(parentRoleId).Name)){
                    return true;
                }else if(parentRoleId != null && userRoleMap.get(parentRoleId) != null){
                    id grandParentRoleId = userRoleMap.get(parentRoleId).parentRoleId;
                    if(userRoleMap.get(grandParentRoleId) != null && setOfRouteRoles.contains(userRoleMap.get(grandParentRoleId).Name)){
                        return true;
                    }
                }
            }       
        }
        return false;
    }
 
 
 // Method to get Queue names for list of cases from routing configuration object
  public static map<id,String> getQueueName(List<Case> cases , Map<id, String> mapOfCaseAndCurrentQueue , Map<Id, User>MapOfCaseIdandOwner){

    //rc data  variables
    Set<String> setOfCallTopics = new Set<String>();
    Map<String, List<Routing_Configuration__c>> mapOfTopicNRoutingConfigList = new Map<String, List<Routing_Configuration__c>>();
    List<Routing_Configuration__c> rcListForMap ;
    List<Routing_Configuration__c> routingConfigsWithoutTopic = new List<Routing_Configuration__c>();    
    
    //results variable
    String queueName = null;
    Map<id,String> caseandQueueResultMap = new Map<id,String>();
    Map<id,Routing_Configuration__c> routeLogMapforSuccess = new Map<id,Routing_Configuration__c>();
    List<case> routeLogcaseListforFailue = new List<case>();
    Routing_Configuration__c matchedRouteConfig;
    boolean excludePriorityRoutingField = false;// If case owner is user and Priority_Routing__c = Yes, then not considering Priority_Routing__c for in mapping, also skips Routing log creation
    List<User> owners = [Select userRole.parentRoleId,userRoleId,UserRole.Name,Profile.Name from User where id = : cases[0].OwnerId ];
    System.debug('owners--->' +owners);
    string TTSQueryString;
    
    if(cases != null && cases.isempty() == False){
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
        //getting a set of all topics and owner Ids
        for (Case caseR :cases){
            if(!setOfCallTopics.contains(caseR.Topic__c)){         
                setOfCallTopics.add(caseR.Topic__c);
            } 
        }
        if(cases[0].Type__c != null){
           if(cases[0].Subtype__c != null){          
               if(owners != null && owners.size() > 0 && owners[0].Profile != null && owners[0].Profile.Name != null && owners[0].Profile.Name != ''){
                   TTSQueryString = 'Select id FROM TTS_Access__c WHERE Topic__c = \''+cases[0].Topic__c+'\' AND Type__c =\''+ cases[0].Type__c +'\' AND Subtype__c = \''+cases[0].Subtype__c+'\' AND (Limit_To_Profiles__c INCLUDES (\''+owners[0].Profile.Name+'\') OR Limit_To_Profiles__c = null OR Limit_To_Roles__c INCLUDES (\''+ owners[0].UserRole.Name+'\') OR Limit_To_Roles__c INCLUDES (\''+ parentRole.Name+'\') OR Limit_To_Roles__c INCLUDES (\''+ grandParentRole.Name+'\') )';
               }else{
                   TTSQueryString = 'Select id FROM TTS_Access__c WHERE Topic__c = \''+cases[0].Topic__c+'\' AND Type__c =\''+ cases[0].Type__c +'\' AND Subtype__c = \''+cases[0].Subtype__c+'\' ';
               }
           }else if(owners != null && owners.size() > 0 && owners[0].Profile != null && owners[0].Profile.Name != null && owners[0].Profile.Name != ''){
               system.debug('values --- ' + cases[0].Topic__c);
               system.debug('values --- ' +cases[0].Type__c );
               system.debug('values --- ' + owners[0].Profile.Name );
               system.debug('values --- ' +owners[0].UserRole.Name );
               system.debug('values --- ' + parentRole.Name);
               system.debug('values --- '+ grandParentRole.Name);
               owners[0].UserRole.Name = owners[0].UserRole.Name =='Women\'s Health Nurse Advisor'?'Women\\\'s Health Nurse Advisor': owners[0].UserRole.Name;

               TTSQueryString = 'Select id FROM TTS_Access__c WHERE Topic__c = \''+cases[0].Topic__c+'\' AND Type__c =\''+ cases[0].Type__c +'\' AND (Limit_To_Profiles__c INCLUDES (\''+owners[0].Profile.Name+'\') OR Limit_To_Profiles__c = null OR Limit_To_Roles__c INCLUDES (\''+ owners[0].UserRole.Name+'\')OR Limit_To_Roles__c INCLUDES (\''+ owners[0].UserRole.Name+'\') OR Limit_To_Roles__c INCLUDES (\''+ parentRole.Name+'\') OR Limit_To_Roles__c INCLUDES (\''+ grandParentRole.Name+'\'))';
           }else{
               TTSQueryString = 'Select id FROM TTS_Access__c WHERE Topic__c = \''+cases[0].Topic__c+'\' AND Type__c =\''+ cases[0].Type__c +'\' ';
           }
        }else{
               if(owners != null && owners.size() > 0 && owners[0].Profile != null && owners[0].Profile.Name != null && owners[0].Profile.Name != ''){
                   if(owners[0].UserRole != null && owners[0].UserRole.Name !=  null)
                       TTSQueryString = 'Select id FROM TTS_Access__c WHERE Topic__c = \''+cases[0].Topic__c+'\' AND (Limit_To_Profiles__c INCLUDES (\''+owners[0].Profile.Name+'\') OR Limit_To_Profiles__c = null )';
                   else{
                       TTSQueryString = 'Select id FROM TTS_Access__c WHERE Topic__c = \''+cases[0].Topic__c+'\' AND (Limit_To_Profiles__c INCLUDES (\''+owners[0].Profile.Name+'\') OR Limit_To_Profiles__c = null OR Limit_To_Roles__c INCLUDES (\''+ owners[0].UserRole.Name+'\') OR Limit_To_Roles__c INCLUDES (\''+ parentRole.Name+'\') OR Limit_To_Roles__c INCLUDES (\''+ grandParentRole.Name+'\'))';
                   } 
               }else{
                   TTSQueryString = 'Select id FROM TTS_Access__c WHERE Topic__c = \''+cases[0].Topic__c+'\'  ';
               }
        }
           
           system.debug('------TTSQueryString----->'+ TTSQueryString);
           List<TTS_Access__c> ttsList = Database.query(TTSQueryString);
           Set<Id> ttsIdset = new Set<Id>();
           system.debug('------ttsList----->'+ ttsList);
           for(TTS_Access__c tts:ttsList){
               ttsIdset.add(tts.Id);
           }
           String query = assignmentFiled + ' where IsActive__c = true and TTs_Access__c IN: ttsIdset order by SortOrder__c asc' ;
        
        //query all the routing config records that will be required to route the cases,  and form a map
        //String query = assignmentFiled +  ' where IsActive__c = true and (Topic1__c IN  :setOfCallTopics OR  Topic1__c = null )order by SortOrder__c asc' ;
        
        System.debug('@@query--'+query);
        for(Routing_Configuration__c routingConfig: database.query(query)){ 
            if(routingConfig.Topic1__c == null){
                routingConfigsWithoutTopic.add(routingConfig);    
            }else{
                if(!mapOfTopicNRoutingConfigList.containsKey(routingConfig.Topic1__c)){
                
                    rcListForMap = new List<Routing_Configuration__c>();
                }
                else{
                    rcListForMap = mapOfTopicNRoutingConfigList.get(routingConfig.Topic1__c);
                }
                rcListForMap.add(routingConfig);  
                mapOfTopicNRoutingConfigList.put(routingConfig.Topic1__c, rcListForMap) ;                
            }
        }
        
        map<id, userRole> userRoleMap = new map<id, userRole>();
        
        if(MapOfCaseIdandOwner != null ){
            set<id> currentAndparentRoleIds = new set<id>();
            for(user u : MapOfCaseIdandOwner.values()){
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
        System.debug('@@cases--'+cases);
        //iterate over cases
        for(Case cas :cases){
           
            String currentQueue = null;
            User currentOwner ;
            
            if(MapOfCaseIdandOwner!= Null && MapOfCaseIdandOwner.get(cas.Id)!= null){
            
                currentOwner = MapOfCaseIdandOwner.get(cas.Id);
            }
            
            if((mapOfCaseAndCurrentQueue!= Null && mapOfCaseAndCurrentQueue.get(cas.Id)!= null)){
                currentQueue = mapOfCaseAndCurrentQueue.get(cas.Id);
            }
            //get the RC list from Map
            List<Routing_Configuration__c> rcListForCase = new List<Routing_Configuration__c>();
            
            if(cas.Priority_Routing__c == 'Yes' && currentQueue == null){
                excludePriorityRoutingField = true;
            }
            
            
            //adding Rc records only if its a priority routing  owned by a queue
            if(cas.Priority_Routing__c == 'Yes' && currentQueue != null &&
                routingConfigsWithoutTopic != null && !routingConfigsWithoutTopic.isEmpty()){
                rcListForCase.addAll(routingConfigsWithoutTopic);
            }
            if(mapOfTopicNRoutingConfigList.get(cas.Topic__c) != null){
                rcListForCase.addAll(mapOfTopicNRoutingConfigList.get(cas.Topic__c));
            }             
            
            if(rcListForCase!= Null && rcListForCase.isEmpty() == False){
                for(Routing_Configuration__c routingConfig: rcListForCase){
               
                    if((isBasicCriteriaMatch(cas,routingConfig, currentOwner,userRoleMap) || currentQueue!=null) && isStandrdCaseFieldMatch(cas,routingConfig, currentQueue )){
                            
                        List<String> valueCheckList = getNotNulValuesForQueueName(routingConfig);
                        if(excludePriorityRoutingField && valueCheckList != null && !valueCheckList.isEmpty()){
                            for(integer i=0;i<valueCheckList.size() ; i++){
                                if(valueCheckList[i].equalsIgnorecase('priority_routing__c')){
                                    valueCheckList.remove(i);
                                }
                            }
                        }
                         Integer index = 0;
                            System.debug('@@@valueCheckList--'+valueCheckList);
                            for(String consField:valueCheckList) {
                              /*  if(consField.equalsIgnorecase('Priority_Routing__c')){
                                    if( (routingConfig.Priority_Routing__c == 'Yes' && cas.Priority_Routing__c )|| (routingConfig.Priority_Routing__c == 'No' && !cas.Priority_Routing__c) ){
                                        index++;
                                    }else{
                                        break;
                                    }
                                }else 
                                { */
                                	String fieldVal = String.ValueOf(cas.get(consField));
                                    if(cas.get(consField)!=null && fieldVal.contains('\\')){
                                        fieldVal = fieldVal.replace('\\', '');
                                    	cas.put(consField,fieldVal);                                                           
                                    }
                                    if(IsFieldAvliable(cas,consField) && routingConfig.get(consField) == cas.get(consField)){
                                        index++;
                                    }
                                    else{
                                        break;
                                    }   
                               // }                                       
                               
                            }
                        	system.debug('index::::' + index);
                            System.debug('@@@valueCheckList--'+valueCheckList);
                            if(valueCheckList.size() == index) {
                                queueName = routingConfig.Queue_Name__c;                            
                                matchedRouteConfig = routingConfig;
                               
                                break;                           
                            }   
                    }
                }
                
            }
            
             //Adding case to result
             caseandQueueResultMap.put(cas.id,queueName);
             if(excludePriorityRoutingField == false){
                 //Logging route
                if(queueName != null){
                  //logmap for success
                  routeLogMapforSuccess.put(cas.id,matchedRouteConfig);
                }
                else{
                  //list of cases that failed to route
                  routeLogcaseListforFailue.add(cas);                       
                }
             }
            
            
        
        }
    }
    //Creates Success and Failure Route_Log__c log records
    if(!routeLogMapforSuccess.isEmpty() || !routeLogcaseListforFailue.isEmpty()){
        System.enqueueJob(new ECMRouteLogJob(routeLogMapforSuccess,routeLogcaseListforFailue));
    }
    System.debug('@@@@caseandQueueResultMap----'+caseandQueueResultMap);
    return caseandQueueResultMap;
  }
 
/*
  Find the list of field need to check in Routing_Configuration__c
  */ 
  private static List<String> getNotNulValuesForQueueName(Routing_Configuration__c routingConfig) {
    List<String> valueCheckList = new List<String>();
    for(String consField:assignmentFiledList) {

            if(routingConfig.get(consField) != null){
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
      Fetch case object info
      */
    public static List<Case> fetchCase(List<ID> casIds){
      String queryString = ACETQueryUtil.getCustomFieldQuery('Case') ;
              queryString +=' where id in ('+ ACETQueryUtil.getQueryValue(casIds) + ' )';
       //List<Case> cases = 
        return  Database.query(queryString);

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