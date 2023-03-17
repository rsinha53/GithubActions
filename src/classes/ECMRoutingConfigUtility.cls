public without sharing class ECMRoutingConfigUtility{

    /* Method to Validate  if data in Routing Configuration Table matches with the 
    existing profile names, user deptatment, role name and  Case Queues   */ 
    public static void validateData(List<Routing_Configuration__c> routinConfigRecords){
        List<Routing_Configuration__c> updatedroutinConfigRecords =  new List<Routing_Configuration__c>();
        updatedroutinConfigRecords = updateTTSValue(routinConfigRecords);   
        Set<String> setOfTriggerProfiles = new Set<String>();
        Set<String> setOfTriggerRoles = new Set<String>(); 
        Set<String> setOfTriggerQueues = new Set<String>();
        Set<String> setOfExistingProfiles = new Set<String>();
        Set<String> setOfExistingRoles = new Set<String>();
        Set<String> setOfExistingQueues = new Set<String>();
        Set<String> setOfTTSProfiles = new Set<String>();
        Set<String> setOfTTSRoles = new Set<String>();
        Set<Id> setOfIds = new Set<Id>();
        Boolean ValidationSwitch;
        List<String> listOfRouteProfiles;
        if(Label.ValidationSwitch == 'True')
            ValidationSwitch = True;
        else
            ValidationSwitch =  False;
        
        Map<id,TTS_Access__c> ttsMap = new Map<id,TTS_Access__c>();       
        // populate the sets with values from incoming trigger
        system.debug('-----updatedroutinConfigRecords-->'+updatedroutinConfigRecords);
        if(updatedroutinConfigRecords != null && !updatedroutinConfigRecords.isEmpty()){           

            for(Routing_Configuration__c rConfig : updatedroutinConfigRecords){      
                
              if(rConfig.ProfileName__c != Null){                                 
                   setOfTriggerProfiles= getUniqueValues(rConfig.ProfileName__c);
               }                
               if(rConfig.RoleName__c != Null ){
                   setOfTriggerRoles= getUniqueValues(rConfig.RoleName__c);
               }
               if(rConfig.Queue_Name__c!= Null &&  !setOfTriggerQueues.contains(rConfig.Queue_Name__c)){
                   setOfTriggerQueues.add(rConfig.Queue_Name__c);
               }        
               if(rConfig.CurrentQueue__c!= Null &&  !setOfTriggerQueues.contains(rConfig.CurrentQueue__c)){
                   setOfTriggerQueues.add(rConfig.CurrentQueue__c);
               } 
               system.debug('-----rConfig.TTS_Access__c-->'+rConfig);
               setOfIds.add(rConfig.TTS_Access__c);                               
            }
            system.debug('-----setOfIds-->'+setOfIds);
            for(TTS_Access__c tts: [SELECT id,Limit_To_Profiles__c,Limit_To_Roles__c,topic__c,type__c,subtype__c FROM TTS_Access__c WHERE id IN :setOfIds]){
                system.debug('-----tts-->'+tts+'------TTS.Limit_To_Profiles__c-->'+TTS.Limit_To_Profiles__c+'------TTS.Limit_To_Roles__c-->'+TTS.Limit_To_Roles__c);
                if(TTS.Limit_To_Profiles__c != Null){
                      setOfTTSProfiles = getUniqueValues(TTS.Limit_To_Profiles__c);
                }
                if(TTS.Limit_To_Roles__c != Null){
                      setOfTTSRoles = getUniqueValues(TTS.Limit_To_Roles__c);
                }
                ttsMap.put(tts.id, tts); 
            }       
        }         
       

        //get list of all the Profile, ROles from org and form a unique value set    
        if(setOfTriggerProfiles != null && setOfTriggerProfiles.size() > 0){
            for(Profile prof : [Select Name From Profile Where Name In :(setOfTriggerProfiles)]){         
                if(!setOfExistingProfiles.contains(prof.Name)){
                       setOfExistingProfiles.add(prof.Name); 
                   }
            }
        }      
                
                    
                
        if(setOfTriggerRoles != null && setOfTriggerRoles.size() > 0){
            for(UserRole role : [Select Name From UserRole Where Name In :(setOfTriggerRoles)]){           
               if(!setOfExistingRoles.contains(role.Name)){
                   setOfExistingRoles.add(role.Name);
               } 
           }  
        } 
             
       
       if(setOfTriggerQueues != null && setOfTriggerQueues.size() > 0){
            for(QueueSobject caseQ: [Select Id, SobjectType, Queue.Name from QueueSobject where SobjectType = 'Case' AND Queue.Name In :(setOfTriggerQueues)]){           
               if(!setOfExistingQueues.contains(caseQ.Queue.Name)){
                   setOfExistingQueues.add(caseQ.Queue.Name);
               } 
           }    
        } 
             
       
       
      // Compare values in Entitlement Assignment Record with values in the set and display error if match is not found                         
      if(updatedroutinConfigRecords!= null && !updatedroutinConfigRecords.isEmpty()){
            for(Routing_Configuration__c rConfig: updatedroutinConfigRecords){            
                String errorMsg ='Enter a valid value';
                if(ttsMap != null && ttsMap.get(rConfig.TTS_Access__c) != null ){
                if(rConfig.Topic1__c != ttsMap.get(rConfig.TTS_Access__c).Topic__c){
                    rConfig.ProfileName__c.addError('Topic value mismatching with Parent TTS record Topic');
                    break;        
                }else if(rConfig.Type__c != ttsMap.get(rConfig.TTS_Access__c).Type__c){
                    rConfig.Type__c.addError('Type value mismatching with Parent TTS record Type');
                    break;            
                }else if(rConfig.SubType__c != ttsMap.get(rConfig.TTS_Access__c).SubType__c){
                    rConfig.subtype__c.addError('SubType value mismatching with Parent TTS record Subtype');
                    break;       
                }
                }
                if(rConfig.ProfileName__c != Null ){ 
                   for(String prof : setOfTriggerProfiles){
                        system.debug('----setOfTTSProfiles-->'+setOfTTSProfiles+'----setOfExistingProfiles-->'+setOfExistingProfiles+'------>'+prof);                        
                        if(!setOfExistingProfiles.contains(prof) && ValidationSwitch ){
                            rConfig.ProfileName__c.addError(errorMsg);
                            break;
                        }Else if(!setOfTTSProfiles.contains(prof) && ValidationSwitch ){
                            rConfig.ProfileName__c.addError('Profile is not present in the List of Profiles in the Master TTS record');
                            break;
                        }
                                      
                   }         
                }    
                 
                if(rConfig.RoleName__c != Null ){ 
                   for(String role : setOfTriggerRoles){
                        system.debug('----setOfExistingRoles-->'+setOfExistingRoles+'------>'+role+'----setOfTTSRoles->'+setOfTTSRoles+'----->'+setOfTTSRoles.contains(role));
                        if(!setOfExistingRoles.contains(role) && ValidationSwitch){
                            rConfig.RoleName__c.addError(errorMsg);
                            break;
                        }Else if(!setOfTTSRoles.contains(role) && ValidationSwitch){
                            rConfig.RoleName__c.addError('Role is not present in the List of Roles in the Master TTS record');
                            break;
                        }               
                   }         
                }               
                if(rConfig.Queue_Name__c!= Null && !setOfExistingQueues.contains(rConfig.Queue_Name__c) && ValidationSwitch ){
                   rConfig.Queue_Name__c.addError(errorMsg ); 
                }  
                if(rConfig.CurrentQueue__c!= Null && !setOfExistingQueues.contains(rConfig.CurrentQueue__c) && ValidationSwitch){
                   rConfig.CurrentQueue__c.addError(errorMsg ); 
                }                                                                          
            }       
        }
        
        
    }
    public static List<Routing_Configuration__c> updateTTSValue(List<Routing_Configuration__c> routinConfigRecords){
        Set<String> ttsIdSet = new Set<String>();
        for(Routing_Configuration__c rc: routinConfigRecords){
            ttsIdSet.add(rc.TTS_ExternalID__c);
            system.debug('-----ttsIdSet-->'+ttsIdSet);
        }
        List<TTS_Access__c> ttsList = [SELECT id,TTSAccessExternalID__c,Limit_To_Profiles__c,Limit_To_Roles__c,topic__c,type__c,subtype__c FROM TTS_Access__c where TTSAccessExternalID__c IN:ttsIdSet ];
        Map<String, id> idMap = new Map<String, id>();
        for(TTS_Access__c tts : ttsList ){
            idMap.put(tts.TTSAccessExternalID__c, tts.id);
            system.debug('-----idMap-->'+idMap);
        }
        List<Routing_Configuration__c> rconlist =  new List<Routing_Configuration__c>();
        for(Routing_Configuration__c rc: routinConfigRecords){
            if(rc.TTS_ExternalID__c != null){
                rc.TTS_Access__c = idMap.get(rc.TTS_ExternalID__c);
                system.debug('-----rc.TTS_Access__c-->'+rc.TTS_Access__c);
                rconlist.add(rc);
            }
        }
        system.debug('-----rconlist-->'+rconlist);
        return rconlist;
    }
    
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