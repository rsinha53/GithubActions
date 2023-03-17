public with sharing class  ACET_FAST_PlatformEventsHandler {  
    
    public static void preparePFEvents(List<Sobject> sObjects,Map<id,Sobject> oldSObjects){
        system.debug('==Publish Events Method'+sObjects);  
        // Added by Santhosh
        List<String> cpuProcessingStatus = new List<String>{'Case Pending','Case Items Created','Case Items Enriched'};
       
        set<Case> caseList=new set<Case>(); 
        for(Sobject sObj: sObjects){ 
            if(sObj.Id.getSObjectType().getDescribe().getName()=='Case'){
                case cas=(case)sObj;
                string recordTypeName=Schema.getGlobalDescribe().get('case').getDescribe().getRecordTypeInfosById().get(cas.recordtypeid).getName();
               
              if(ACET_FAST_Constants.reactiveResolution==recordTypeName && cas.origin =='Impact System' && cpuProcessingStatus.contains(cas.CPU_Processing_Status__c)
                && cas.CPU_Processing_Status__c!=((case)oldSObjects.get(cas.id)).CPU_Processing_Status__c){
                  //added by santhosh
                  caseList.add(cas);
                 }
        }
      }
            // Publish the events
            if(caseList.size()>0)
               firePlatformEvent(new List<Case>(caseList));
    }
    
   Public static void firePlatformEvent(list<case> caseList){ 
       List<Spire_to_MuleSoft__e> spireToMuleEvents=new  List<Spire_to_MuleSoft__e>();
       for(case cas:caseList){
                Spire_to_MuleSoft__e sPME=new Spire_to_MuleSoft__e(CaseId__c=cas.id,
                                                                   Status__c=cas.status,
                                                                   CPU_Processing_Status__c=cas.CPU_Processing_Status__c,
                                                                   InteractionID__c=cas.Interaction__c
                                                                 );
                spireToMuleEvents.add(sPME); 
            }
            
   
        // Call method to publish events
        if(spireToMuleEvents.size()>0){ 
            List<Database.SaveResult> results = EventBus.publish(spireToMuleEvents);
            
            // Inspect publishing result for each event
            for (Database.SaveResult sr : results) {
                if (sr.isSuccess()) {
                    System.debug('==Successfully published event.');
                } else {
                    for(Database.Error err : sr.getErrors()) {
                        System.debug('Error returned: ' + err.getStatusCode() + ' - ' + err.getMessage());
                    }
                } 
            }
        }
            
   }
    
 Public static void eventSubscription(list<Spire_to_MuleSoft__e> eventsList){
         system.debug('==eventSubscription==');
        list < PublishResult__c > lstEvents = new list < PublishResult__c > ();
        for (Spire_to_MuleSoft__e event: eventsList) {
       
            lstEvents.add(new PublishResult__c(ReplayId__c = Integer.valueOf(event.ReplayId), Status__c = event.Status__c,
                                               EventUid__c = event.CaseId__c, Topic__c = event.Status__c,
                                               CPU_Processing_Status__c = event.CPU_Processing_Status__c,
                                               InteractionId__c = event.InteractionId__c));                                               
        }
        if (lstEvents.size() > 0)
            Insert lstEvents;
    } 
    
    Public static void eventSubscriptionMtoS(list<MuleSoft_To_Spire__e> eventsList){
        set<Id> caseIds=new set<id>(); 
        list < PublishResult__c > lstEvents = new list < PublishResult__c > ();
        for (MuleSoft_To_Spire__e event: eventsList) {
       
            lstEvents.add(new PublishResult__c(ReplayId__c = Integer.valueOf(event.ReplayId), 
                                               EventUid__c = event.CaseId__c));
            caseIds.add(event.CaseId__c);
          
        }
        if (lstEvents.size() > 0){
            Insert lstEvents;
        }
           
       if (caseIds.size() > 0){
        invokeRouting(new list<id>(caseIds)); 
       } 
           
    }

   Public static void invokeRouting(list<id> casIds){
        system.debug('==invokeRouting=='+casIds); 
       for(case cas:[select id,Type__c,Subtype__c,Priority from case where id=:casIds]){
          
          ECMAutoRouteCaseController.invokeRoute(cas.id,cas.Type__c,cas.Subtype__c, cas.priority); 
          
       }
    }

}