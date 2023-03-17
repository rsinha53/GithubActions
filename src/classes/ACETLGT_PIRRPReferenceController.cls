/**
ACETLGT_PIRRPReferenceController
Test Class Name:  ACETLGT_PIRRPReferenceControllerTest
Author: Ganesh Medisetti
Description: This class is used for to add PIR Resolution References dynamically. 
10/27/2020 - Ganesh Medisetti - Initial
*/
public with sharing class ACETLGT_PIRRPReferenceController {
	@AuraEnabled
    public static void savePIRRPReference(List<PIR_Resolution_Partners_Reference__c> lstPIRRPRefs){
        try{
            if(lstPIRRPRefs.size()>0)
        	Insert lstPIRRPRefs;
        }catch(Exception e){
            system.debug('Exception in savePIRRPReference method in ACETLGT_PIRRPReferenceController controller '+e);
        }
        
    }
    
    @AuraEnabled    
    public static List < PIR_Resolution_Partners_Reference__c > fetchPIRRPReferences(String pirRPId) {  
        return [ SELECT Id, Reference__c, Completed__c,PIR_Resolution_Partner__c FROM PIR_Resolution_Partners_Reference__c Where PIR_Resolution_Partner__c=:pirRPId LIMIT 1000 ];
    }    
      
    @AuraEnabled    
    public static boolean updatePIRRPReferences( List < PIR_Resolution_Partners_Reference__c > updatedPIRRPRefs ) { 
        try {  
            update updatedPIRRPRefs;  
            return true;  
        } catch(Exception e) {  
            return false;  
        }  
            
    }
    @AuraEnabled    
    public static boolean deletePIRRPRef(String pirRPRefId) {  
        try {  
            PIR_Resolution_Partners_Reference__c rec = new PIR_Resolution_Partners_Reference__c();
            rec.ID = pirRPRefId;
            delete rec;
            return true;  
        } catch(Exception e) {  
            return false;  
        }  
    }

    @AuraEnabled
    public static PIR_Resolution_Partner__c clonePIRRPWithReference(String pirRPId){
        try{
            PIR_Resolution_Partner__c pirRP = [Select Id, name,Case__c,Case__r.Status,Case_Resolution_Partner_Number__c,Comments__c,Days_Past_SLA__c,Escalation_Notes__c, Partner_Reference_Number__c, RecordTypeId,Resolution_Partner_Outcome__c,Provider_Matrix_Reactive__c,SLA_Completion_Date__c,SLA_Due_Date__c,SLA_Indicator__c,SLA_Routed_Date__c, (Select Id, Reference__c, Completed__c, PIR_Resolution_Partner__c from PIR_Resolution_Partners_References__r) from PIR_Resolution_Partner__c where id=:pirRPId];
            return pirRP;
        }catch(Exception e){
            system.debug('Exception in clonePIRRPWithReference method in ACETLGT_PIRRPReferenceController controller '+e);
            return null;
        }
        
    }
}