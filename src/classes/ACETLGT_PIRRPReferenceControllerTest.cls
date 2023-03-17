/*
ACETLGT_PIRRPReferenceControllerTest
Testing Class Name:  ACETLGT_PIRRPReferenceController
Author: Ganesh Medisetti
Date: 10/27/2020
Description: This is test class and used to get test coverage for ACETLGT_PIRRPReferenceController. 
Initial: Ganesh Medisetti
*/
@isTest
public class ACETLGT_PIRRPReferenceControllerTest {
    static testMethod void testSavePIRRPReference() {
        List<PIR_Resolution_Partners_Reference__c> lstPIRRPRefs = new List<PIR_Resolution_Partners_Reference__c>();
        ACETLGT_PIRRPReferenceController.savePIRRPReference(lstPIRRPRefs);
    }
    static testMethod void testSavePIRRPReference_Negitive() {
        PIR_Resolution_Partners_Reference__c ref = new PIR_Resolution_Partners_Reference__c();
        ref.Reference__c='4242421424241242412424214214124424241241242142142424124124124124124214214124124124124124124124124214124124124124124124124124124214124124214124124124214124124214242356236362362362362363263262363263623623623623623623623623623623623623636236236236236wt23462346352352362362353';
        List<PIR_Resolution_Partners_Reference__c> lstPIRRPRefs = new List<PIR_Resolution_Partners_Reference__c>();
        lstPIRRPRefs.add(ref);
        try{
            ACETLGT_PIRRPReferenceController.savePIRRPReference(lstPIRRPRefs);
        }catch(Exception e){
            system.debug('Exception Message'+e.getMessage());
        }
        
    }
    static testMethod void testDeletePIRRPRef() {
        ACETLGT_PIRRPReferenceController.deletePIRRPRef('lstPIRRPRefs');
    }
    
    static testMethod void testFetchPIRRPReferences() {
        ACETLGT_PIRRPReferenceController.fetchPIRRPReferences('a1H050000404RYZEA2');
        PIR_Resolution_Partner__c da = ACETLGT_PIRRPReferenceController.clonePIRRPWithReference('a1H050000404RYZEA2');
        system.debug('PIR RP -->'+ da);
    }
    static testMethod void testUpdatePIRRPReferences() {
        PIR_Resolution_Partners_Reference__c ref = new PIR_Resolution_Partners_Reference__c();
        ref.Reference__c='4242421424241242412424214214124424241241242142142424124124124124124214214124124124124124124124124214124124124124124124124124124214124124214124124124214124124214242356236362362362362363263262363263623623623623623623623623623623623623636236236236236wt23462346352352362362353';
        List<PIR_Resolution_Partners_Reference__c> lstPIRRPRefs = new List<PIR_Resolution_Partners_Reference__c>();
        lstPIRRPRefs.add(ref);
        ACETLGT_PIRRPReferenceController.updatePIRRPReferences(lstPIRRPRefs);
    }
}