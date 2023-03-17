public with sharing class ACET_CreateSRNContainerCtrl {
    @AuraEnabled(cacheable=true)
    Public Static List<Spire_Auth_Entry_Grid__mdt> getAuthGridData()
    {
        return [SELECT FIELDS(STANDARD),Admitting__c,Attending__c,Facility__c,LOB__c,Notes__c,PCP__c,Provider_Roles__c,Reference_or_Procedure__c,Requesting__c,Servicing__c,Spire_Place_of_Service__c,Spire_Service_Description__c,Spire_Service_Detail__c,Spire_Service_Setting__c FROM Spire_Auth_Entry_Grid__mdt LIMIT 200];
    }
}