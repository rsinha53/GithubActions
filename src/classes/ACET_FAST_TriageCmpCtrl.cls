public with sharing class ACET_FAST_TriageCmpCtrl {
    
  @AuraEnabled
  public static case getCaseRecord(string caseRecId){
        case caseRec = new case();
        if(caseRecId!='' && caseRecId!=null){
            caseRec=[SELECT id,RecordType.Name,CPU_Processing_Status__c,Interaction__c, CaseNumber,status,Case_Type__c,FAST_PIP_Markets__c,Original_Received_Date__c FROM Case WHERE id=:caseRecId];
        }
        return caseRec;
    }
    
  @AuraEnabled
  public static String publishPFEvent(case casRec){
      if(casRec.CPU_Processing_Status__c =='Case Items Partially Enriched'){
              ACET_FAST_PlatformEventsHandler.firePlatformEvent(new List<case>{casRec});
      }

    return string.valueOf([select id,ReplayId__c from PublishResult__c where EventUid__c=:casRec.id  order by ReplayId__c desc limit 1].ReplayId__c);
 }
}