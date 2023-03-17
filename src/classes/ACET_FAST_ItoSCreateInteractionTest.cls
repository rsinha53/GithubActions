/*****************************************************************************************************
ACET_FAST_ItoSCreateInteractionTest
Testing Class Name:  ACET_FAST_ItoSCreateInteraction
Author: Shaik Mohammad Yaseen
Date: 07/01/2021
Description: This is test class and used to get test coverage for ACET_FAST_ItoSCreateInteraction. 
Initial: Shaik Mohammad Yaseen
******************************************************************************************************/
@isTest(SeeAllData=false)
public class ACET_FAST_ItoSCreateInteractionTest {
    
    public static testMethod void createThirdPartyRec(){
        try{ 
            List<case> caseRec = new List<case>();
            case caseRe = ACET_Fast_TestDataFactory.getCaseRecord('Reactive_Resolution','New');        
            caseRe.PC_Provider_TIN__c ='111111111';
            caseRe.Origin ='Impact System';
            caseRec.add(caseRe);
            insert caseRec;
            
            ACET_FAST_ItoSCreateInteraction.throwError(caseRec, 'error message');
            case updatedCase = [SELECT id, Interaction__c FROM Case WHERE id=:caseRec[0].id];
            system.debug('updatedCase int id is ==>'+updatedCase.Interaction__c);
        }
        catch(exception ex){
            system.debug('error is ==>'+ex.getMessage());
        }
        
    }
}