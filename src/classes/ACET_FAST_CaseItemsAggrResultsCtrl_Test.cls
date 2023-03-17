/*
ACET_FAST_CaseItemsAggrResultsCtrl_Test
Testing Class Name:  ACET_FAST_CaseItemsAggrResults
Author: Ratna Kumar M
Date: 06/11/2021
Description: This is test class and used to get test coverage for ACET_FAST_CaseItemsAggrResultsCtrl. 
Initial: Ratna Kumar
*/
 @isTest
public class ACET_FAST_CaseItemsAggrResultsCtrl_Test {
    
     @isTest static void getAggregateInfo_Test() {
       case  cas=ACET_Fast_TestDataFactory.getCaseRecord('Reactive_Resolution', 'New');
        insert cas;
         Case_Item__c cItemRec = new Case_Item__c(Case__c=cas.id);
         insert cItemRec;
         Case_Item__c cItemRec2 = new Case_Item__c(Case__c=cas.id,Enrichment_Status__c='Error');
         insert cItemRec2;
     ACET_FAST_CaseItemsAggrResultsCtrl.getAggregateInfo(cas.id);
    }

}