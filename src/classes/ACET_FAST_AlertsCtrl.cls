public with sharing class ACET_FAST_AlertsCtrl {
    
        @AuraEnabled
    public static case getCaseRecord(string caseRecId){
        case caseRec = new case();
        if(caseRecId!='' && caseRecId!=null){
            caseRec=[SELECT id,RecordType.Name,PC_Provider_TIN__c, CaseNumber,status,Case_Type__c,FAST_PIP_Markets__c,Original_Received_Date__c FROM Case WHERE id=:caseRecId];
        }
        return caseRec;
    }

}