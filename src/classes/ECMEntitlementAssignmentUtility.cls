public with sharing class ECMEntitlementAssignmentUtility{

    //Method to Validate  if Queue Name in the Routing Configuration Table matches with the existing Case QUeues
    public static void validateData(List<EntitlementAssignment__c> entitlementAssignmentRecords){
        List<EntitlementAssignment__c> EntAsgnList = new List<EntitlementAssignment__c>();
        EntAsgnList = updateTTSValue(entitlementAssignmentRecords);
        Set<String> setOfTriggerProfiles = new Set<String>();
        Set<String> setOfTriggerRoles = new Set<String>(); 
        Set<String> setOfTTSProfiles = new Set<String>();
        Set<String> setOfTTSRoles = new Set<String>();
        Set<String> setOfExistingProfiles= new Set<String>();
        Set<String> setOfExistingDepartments= new Set<String>();
        Set<String> setOfExistingRoles= new Set<String>();
        Set<Id> setOfIds = new Set<Id>();    
        Boolean ValidationSwitch;
        List<String> listOfRouteProfiles;
        if(Label.ValidationSwitch == 'True')
            ValidationSwitch = True;
        else
            ValidationSwitch =  False;   
        Map<id,TTS_Access__c> ttsMap = new Map<id,TTS_Access__c>();
        // populate the sets with values from incoming trigger
        system.debug('------'+EntAsgnList);
        if(EntAsgnList!= null && !EntAsgnList.isEmpty()){
            for(EntitlementAssignment__c entAssign : EntAsgnList){        
           
               if(entAssign.ProfileName__c != Null){
                     setOfTriggerProfiles= getUniqueValues(entAssign.ProfileName__c);
               }  
               if(entAssign.RoleName__c != Null){
                      setOfTriggerRoles = getUniqueValues(entAssign.RoleName__c);
               }
               setOfIds.add(entAssign.TTS_Access__c);               
                                          
            }
            
            for(TTS_Access__c tts : [SELECT id,Limit_To_Profiles__c,Limit_To_Roles__c,topic__c,type__c,subtype__c FROM TTS_Access__c WHERE id IN :setOfIds]){
                //system.debug('----entAssign.TTS_Access__r.Limit_To_Profiles__c-->'+entAssign.TTS_Access__r.Limit_To_Profiles__c+'------>'+entAssign );
                if(TTS.Limit_To_Profiles__c != Null){
                      //system.debug('----setOfTTSProfiles-->'+setOfTTSProfiles+'------>'+prof);
                      setOfTTSProfiles = getUniqueValues(TTS.Limit_To_Profiles__c);
                }
                if(TTS.Limit_To_Roles__c != Null){
                      setOfTTSRoles = getUniqueValues(TTS.Limit_To_Roles__c);
                }
                ttsMap.put(tts.id, tts); 
            }
            
                   
        }      

        //get list of all the Profile and Roles from org and form a unique value set   
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
       
       // Compare values in Entitlement Assignment Record with values in the set and display error if match is not found                         
      if(EntAsgnList!= null && !EntAsgnList.isEmpty()){
            for(EntitlementAssignment__c entAssign : EntAsgnList){            
               String errorMsg ='Enter a valid value';
               if(ttsMap != null && ttsMap.get(entAssign.TTS_Access__c) != null){
                   if(entAssign.Topic1__c != ttsMap.get(entAssign.TTS_Access__c).Topic__c){
                        entAssign.ProfileName__c.addError('Topic value mismatching with Parent TTS record Topic');
                        break;        
                    }else if(entAssign.Type__c != ttsMap.get(entAssign.TTS_Access__c).Type__c){
                        entAssign.Type__c.addError('Type value mismatching with Parent TTS record Type');
                        break;            
                    }else if(entAssign.SubType__c != ttsMap.get(entAssign.TTS_Access__c).SubType__c){
                        entAssign.subtype__c.addError('SubType value mismatching with Parent TTS record Subtype');
                        break;       
                    }
                }   
               if(entAssign.ProfileName__c != Null ){ 
                   for(String prof : setOfTriggerProfiles){
                        system.debug('----setOfTTSProfiles-->'+setOfTTSProfiles+'------>'+prof);
                        if(!setOfExistingProfiles.contains(prof) && ValidationSwitch){
                            entAssign.ProfileName__c.addError(errorMsg );
                            break;
                        }Else if(!setOfTTSProfiles.contains(prof) && ValidationSwitch){                            
                            entAssign.ProfileName__c.addError('Profile is not present in the List of Profiles in the Master TTS record');
                            break;
                        }            
                   }         
                }    
                 
                if(entAssign.RoleName__c != Null ){ 
                   for(String role : setOfTriggerRoles){
                        system.debug('----setOfExistingRoles-->'+setOfExistingRoles+'------>'+role);
                        if(!setOfExistingRoles.contains(role) && ValidationSwitch){
                            entAssign.RoleName__c.addError(errorMsg);
                            break;
                        }Else if(!setOfTTSRoles.contains(role) && ValidationSwitch){
                            entAssign.RoleName__c.addError('Role is not present in the List of Roles in the Master TTS record');
                            break;
                        }              
                   }         
                }
                                                       
            }       
        }
        
    }
    
    public static List<EntitlementAssignment__c> updateTTSValue(List<EntitlementAssignment__c> entitlementAssignmentRecords){
        Set<String> ttsIdSet = new Set<String>();
        for(EntitlementAssignment__c ea: entitlementAssignmentRecords){
            ttsIdSet.add(ea.TTS_ExternalID__c);
        }
        List<TTS_Access__c> ttsList = [SELECT id,TTSAccessExternalID__c,Limit_To_Profiles__c,Limit_To_Roles__c,topic__c,type__c,subtype__c FROM TTS_Access__c where TTSAccessExternalID__c IN:ttsIdSet ];
        List<EntitlementAssignment__c> EntAList = new List<EntitlementAssignment__c>();
        Map<String, id> idMap = new Map<String, id>();
        for(TTS_Access__c tts : ttsList ){
            idMap.put(tts.TTSAccessExternalID__c, tts.id);
        }
        for(EntitlementAssignment__c ea: entitlementAssignmentRecords){
            if(ea.TTS_ExternalID__c != null){
                ea.TTS_Access__c = idMap.get(ea.TTS_ExternalID__c);
                EntAList.add(ea);
            }
        }
        
        return EntAList;
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