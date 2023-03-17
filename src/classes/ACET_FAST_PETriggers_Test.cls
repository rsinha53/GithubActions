/*
ACET_FAST_PETriggers_Test
Testing Class Name:  ACET_FAST_PETriggers
Author: Ratna Kumar M
Date: 06/11/2021
Description: This is test class and used to get test coverage for ACET_FAST_PETriggers. 
Initial: Ratna Kumar
*/
 @isTest
public class ACET_FAST_PETriggers_Test {
    @isTest static void platformEvent_Test() {
case  cas=ACET_Fast_TestDataFactory.getCaseRecord('Reactive_Resolution', 'New');
         insert cas;
     case updateCase=[select id,Status,CPU_Processing_Status__c,Interaction__c from Case where id=:cas.id];
          updateCase.CPU_Processing_Status__c='Case Items Partially Enriched';
          updateCase.origin ='Impact System';
          update updateCase;
    
    Spire_to_MuleSoft__e sPME=new Spire_to_MuleSoft__e(CaseId__c=updateCase.id,
                                                                   Status__c=updateCase.status,
                                                                   CPU_Processing_Status__c=updateCase.CPU_Processing_Status__c,
                                                                   InteractionID__c=updateCase.Interaction__c
                                                                 );
        Test.startTest();
        EventBus.publish(sPME);
        Test.stopTest();
    }

    @isTest static void platformEvent_Test1() {
        case  cas=ACET_Fast_TestDataFactory.getCaseRecord('Reactive_Resolution', 'New');
                 insert cas;
             case updateCase=[select id,Status,CPU_Processing_Status__c,Interaction__c from Case where id=:cas.id];
                  updateCase.CPU_Processing_Status__c='Case Items Partially Enriched';
                  updateCase.origin ='Impact System';
                  update updateCase;
            
            MuleSoft_To_Spire__e sPME=new MuleSoft_To_Spire__e(CaseId__c=updateCase.id );
                Test.startTest();
                EventBus.publish(sPME);
                Test.stopTest();
            }
}