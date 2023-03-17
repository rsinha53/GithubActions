/***************************************************************************
 * @@Author: Pavan Kumar Annaldas
 * @@Description: Creates Success and Failure "Route_Log__c" records
 * **************************************************************************/

public class ECMRouteLogJob implements Queueable {

    public Map<id,Routing_Configuration__c> routeLogMapforSuccess; // Key should be case id, this map indicates case records, which are routed successfully 
    public list<case> caseList; //List case records, which are failed to Route
    
    public ECMRouteLogJob(Map<id,Routing_Configuration__c> routeLogMapforSuccess,list<case> caseList){
        this.routeLogMapforSuccess = routeLogMapforSuccess;
        this.caseList = caseList;
    }
    
    public void execute(QueueableContext context) {
        try{
            list<Route_Log__c> routeLogsToInsert = new list<Route_Log__c>();
            routeLogsToInsert.addAll(prepareSuccessRouteLogs()); 
            routeLogsToInsert.addAll(prepareFailuerRouteLogs());
            if(!routeLogsToInsert.isEmpty()){
              insert routeLogsToInsert;
            }
        }catch(exception ex){
            system.debug(LoggingLevel.Error,'Exception occured while inserting Routing Logs  '+ex.getMessage());
        }
    }
    
    /*Process success records, which are routed 
      and return list<Route_Log__c> records*/
    public list<Route_Log__c> prepareSuccessRouteLogs(){
        list<Route_Log__c> routeLogsToInsert = new list<Route_Log__c>();
        if(routeLogMapforSuccess != null && !routeLogMapforSuccess.isEmpty()){
            set<id> routingConfigurationIds = new set<id>();
            for(Routing_Configuration__c config : routeLogMapforSuccess.values()){
                routingConfigurationIds.add(config.id);
            }
            map<id,Routing_Configuration__c> configMap = new map<id, Routing_Configuration__c>([Select Id, CurrentQueue__c, Priority__c,Queue_Name__c,
                                                                                                ProfileName__c, RoleName__c, Subtype__c, Type__c,  Priority_Routing__c, 
                                                                                                Status__c, Topic1__c , SortOrder__c,  ServiceLevel__c From Routing_Configuration__c where id in:routingConfigurationIds]);
            for(id caseID : routeLogMapforSuccess.keySet()){
                if(routeLogMapforSuccess.get(caseID) != null && configMap.get(routeLogMapforSuccess.get(caseID).id) != null){
                    Routing_Configuration__c routingConfig = configMap.get(routeLogMapforSuccess.get(caseID).id);
                    //create route log
                    Route_Log__c newLog = new Route_Log__c(Case__c = caseID);
                    
                    //updaing route log
                    newLog.QueueName__c = routingConfig.Queue_Name__c;
                    newLog.RoutingConfiguration__c= routingConfig.Id;
                    newLog.CurrentQueue__c = routingConfig.CurrentQueue__c;              
                    newLog.Priority__c = routingConfig.Priority__c;
                    newLog.ProfileName__c = routingConfig.ProfileName__c;
                    newLog.RoleName__c = routingConfig.RoleName__c;
                    newLog.Subtype__c = routingConfig.Subtype__c;
                    newLog.Type__c = routingConfig.Type__c;
                    newLog.RoutingPriority__c = routingConfig.Priority_Routing__c ;
                    newLog.Status__c = routingConfig.Status__c;
                    newLog.Topic1__c = routingConfig.Topic1__c;
                    newLog.SortOrder__c = routingConfig.SortOrder__c;
                    newLog.ServiceLevel__c = routingConfig.ServiceLevel__c;
                    routeLogsToInsert.add(newLog);
                }
            }
        }
        return routeLogsToInsert;
    }
    
    /*Process failure records, which are failed to route 
      and return list<Route_Log__c> records*/
    public list<Route_Log__c> prepareFailuerRouteLogs(){
        list<Route_Log__c> routeLogsToInsert = new list<Route_Log__c>();
        if(caseList != null && !caseList.isEmpty()){
            set<id> queueIds = new set<id>();
            set<id> userIds = new set<id>();
            map<id, QueueSobject> queueMap = new map<id, QueueSobject>();
            map<id, user> userMap = new map<id, user>();
            for(case cs : caseList){
                string ownerId = cs.ownerId;
                if(ownerId.startsWith('005')){
                    userIds.add(ownerId);
                }else{
                    queueIds.add(ownerID); 
                } 
            }
            if(queueIds.size() > 0)
                queueMap = new map<id, QueueSobject>([Select Id, Queue.Name From QueueSobject where SobjectType = 'Case' and QueueId in:queueIds]);
            if(userIds.size() > 0)
                userMap = new map<id, user>([Select UserRole.Name,Profile.Name from User where id in:userIds ]);
            for(case cs : caseList){
                //create route log //
                Route_Log__c newLog = new Route_Log__c(Case__c = cs.id);
                
                //updaing route log
                if(queueMap.get(cs.ownerID) != null){
                    newLog.CurrentQueue__c = queueMap.get(cs.ownerID).queue.Name;
                }else if(userMap.get(cs.ownerID) != null){
                    User owner = userMap.get(cs.ownerID);    
                    newLog.ProfileName__c = owner.Profile.Name;
                    newLog.RoleName__c = owner.UserRole.Name;    
                }  

                newLog.Priority__c = cs.Priority;
                newLog.Subtype__c = cs.Subtype__c ;
                newLog.Type__c = cs.Type__c;
                newLog.RoutingPriority__c = cs.Priority_Routing__c;
                newLog.Status__c = cs.Status;
                newLog.Topic1__c = cs.Topic__c;
                newLog.ServiceLevel__c = cs.ServiceLevel__c;
                routeLogsToInsert.add(newLog);
            }
        }
        return routeLogsToInsert;
    }

  
}