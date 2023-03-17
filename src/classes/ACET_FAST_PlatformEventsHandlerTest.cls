/*
ACET_FAST_CaseItemsAggrResultsCtrl_Test
Testing Class Name:  ACET_FAST_CaseItemsAggrResults
Author: Ratna Kumar M
Date: 06/11/2021
Description: This is test class and used to get test coverage for ACET_FAST_CaseItemsAggrResultsCtrl. 
Initial: Ratna Kumar
*/
 @isTest
public class ACET_FAST_PlatformEventsHandlerTest {

   @isTest static void platformEvent_Test() {
     case  cas=ACET_Fast_TestDataFactory.getCaseRecord('Reactive_Resolution', 'New');
         insert cas;
     case updateCase=[select id,CPU_Processing_Status__c from Case where id=:cas.id];
          updateCase.CPU_Processing_Status__c='Case Items Partially Enriched';
          updateCase.origin ='Impact System';
          update updateCase;
       
       ACET_FAST_PlatformEventsHandler.firePlatformEvent(new list<case>{cas});
    }
}