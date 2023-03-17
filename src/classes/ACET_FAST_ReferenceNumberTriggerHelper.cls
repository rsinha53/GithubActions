public with sharing class ACET_FAST_ReferenceNumberTriggerHelper {
    
    public static void handleAfterInsert(List<PIR_Resolution_Partners_Reference__c> triggerNew)
    {
        Map<ID, PIR_Resolution_Partner__c> parentRecs = new Map<ID, PIR_Resolution_Partner__c>(); //Making it a map instead of list for easier lookup
        Set<Id> listIds = new Set<Id>();
        
        for (PIR_Resolution_Partners_Reference__c rNum : triggerNew) {
            if(rNum.Completed__c != null || rNum.SLA_Routed_Date__c != null){
                listIds.add(rNum.PIR_Resolution_Partner__c);
            }
            
        }
        
        parentRecs = new Map<Id, PIR_Resolution_Partner__c>([SELECT id,(SELECT ID,PIR_Resolution_Partner__c, SLA_Routed_Date__c FROM PIR_Resolution_Partners_References__r where Completed__c != true and SLA_Routed_Date__c != null order by SLA_Routed_Date__c ASC limit 1) FROM PIR_Resolution_Partner__c WHERE ID IN :listIds]);
        if(!parentRecs.isEmpty())
        {
            for (PIR_Resolution_Partners_Reference__c ref: parentRecs.values().PIR_Resolution_Partners_References__r){
                PIR_Resolution_Partner__c perentRec = parentRecs.get(ref.PIR_Resolution_Partner__c);
                perentRec.SLA_Routed_Date__c = ref.SLA_Routed_Date__c;
            }
            update parentRecs.values();
        }
        
    }
    public static void updateRPSlaRoutedDate(List<PIR_Resolution_Partners_Reference__c> triggerNew, map<id,PIR_Resolution_Partners_Reference__c> triggerOldMap)
    {
        Map<ID, PIR_Resolution_Partner__c> parentRecs = new Map<ID, PIR_Resolution_Partner__c>(); //Making it a map instead of list for easier lookup
        Set<Id> listIds = new Set<Id>();
        
        for (PIR_Resolution_Partners_Reference__c rNum : triggerNew) {
            System.debug('in the loop'+triggerOldMap.get(rNum.id).Completed__c);
            if(rNum.Completed__c != triggerOldMap.get(rNum.id).Completed__c || rNum.SLA_Routed_Date__c != triggerOldMap.get(rNum.id).SLA_Routed_Date__c){
                listIds.add(rNum.PIR_Resolution_Partner__c);
            }
            
        }
        
        parentRecs = new Map<Id, PIR_Resolution_Partner__c>([SELECT id,(SELECT ID,PIR_Resolution_Partner__c, SLA_Routed_Date__c FROM PIR_Resolution_Partners_References__r where Completed__c != true and SLA_Routed_Date__c != null order by SLA_Routed_Date__c ASC limit 1) FROM PIR_Resolution_Partner__c WHERE ID IN :listIds]);
        if(!parentRecs.isEmpty())
        {
            for (PIR_Resolution_Partners_Reference__c ref: parentRecs.values().PIR_Resolution_Partners_References__r){
                PIR_Resolution_Partner__c perentRec = parentRecs.get(ref.PIR_Resolution_Partner__c);
                perentRec.SLA_Routed_Date__c = ref.SLA_Routed_Date__c;
            }
            update parentRecs.values();
        }
        
    }
	
	public static void handleAfterDelete(List<PIR_Resolution_Partners_Reference__c> triggerOld)
    {
        Map<ID, PIR_Resolution_Partner__c> parentRecs = new Map<ID, PIR_Resolution_Partner__c>(); //Making it a map instead of list for easier lookup
        Set<Id> listIds = new Set<Id>();
        
        for (PIR_Resolution_Partners_Reference__c rNum : triggerOld) {            
                listIds.add(rNum.PIR_Resolution_Partner__c);                      
        }
        
        parentRecs = new Map<Id, PIR_Resolution_Partner__c>([SELECT id,(SELECT ID,PIR_Resolution_Partner__c, SLA_Routed_Date__c FROM PIR_Resolution_Partners_References__r where Completed__c != true and SLA_Routed_Date__c != null order by SLA_Routed_Date__c ASC limit 1) FROM PIR_Resolution_Partner__c WHERE ID IN :listIds]);
        if(!parentRecs.isEmpty())
        {
            for (PIR_Resolution_Partners_Reference__c ref: parentRecs.values().PIR_Resolution_Partners_References__r){
                PIR_Resolution_Partner__c perentRec = parentRecs.get(ref.PIR_Resolution_Partner__c);
                perentRec.SLA_Routed_Date__c = ref.SLA_Routed_Date__c;
            }
            update parentRecs.values();
        }
        
    }
    
}