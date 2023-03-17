/*
ACET_FAST_CaseItemsAggrResults
Testing Class Name:  ACET_FAST_CaseItemsAggrResults
Author: Ratna Kumar M
Date: 06/11/2021
Description: This class will provide the business logic for the ACET_FAST_CaseItemsAggrResults lightning component. 
Initial: Ratna Kumar
*/

public with sharing class ACET_FAST_CaseItemsAggrResultsCtrl {

    @AuraEnabled
    public static ACET_FAST_CaseItemsAggrResultsCtrl.Resultwrapper getAggregateInfo(string caseId) {
      ACET_FAST_CaseItemsAggrResultsCtrl.Resultwrapper wrapperResults = new ACET_FAST_CaseItemsAggrResultsCtrl.Resultwrapper();
  
      Map < String, Integer > caseItemsbyEnError = new Map < String, Integer > ();
      Map < String, Integer > caseItemsbyPlatform = new Map < String, Integer > ();
      Map < String, Integer > caseItemsbyLob = new Map < String, Integer > ();
      integer count = 0;
      for (Case_Item__c st: [select id, Platform__c, Line_of_Business__c, Enrichment_Status__c from Case_Item__c where case__c =: caseId]) {
        if (st.Platform__c == null)
          st.Platform__c = 'Null';
        if (caseItemsbyPlatform.ContainsKey(st.Platform__c)) {
          Integer pCount = caseItemsbyPlatform.get(st.Platform__c) + 1;
          caseItemsbyPlatform.put(st.Platform__c, pCount);
  
        } else
          caseItemsbyPlatform.put(st.Platform__c, 1);
        if (st.Line_of_Business__c == null)
          st.Line_of_Business__c = 'Null';
        if (caseItemsbyLob.ContainsKey(st.Line_of_Business__c)) {
          Integer lCount = caseItemsbyLob.get(st.Line_of_Business__c) + 1;
          caseItemsbyLob.put(st.Line_of_Business__c, lCount);
  
        } else
          caseItemsbyLob.put(st.Line_of_Business__c, 1);
  
        if (st.Enrichment_Status__c == 'Error')
          count++;
  
      }
      caseItemsbyEnError.put('Error', count);
      wrapperResults.caseItemsbyLob = caseItemsbyLob;
      wrapperResults.caseItemsbyPlatform = caseItemsbyPlatform;
      wrapperResults.caseItemsbyEnError = caseItemsbyEnError;
      return wrapperResults;
    }
  
    Public class Resultwrapper {
  
      @AuraEnabled
      Public Map < String, Integer > caseItemsbyEnError {
        get;
        set;
      }
      @AuraEnabled
      Public Map < String, Integer > caseItemsbyPlatform {
        get;
        set;
      }
      @AuraEnabled
      Public Map < String, Integer > caseItemsbyLob {
        get;
        set;
      }
      public Resultwrapper() {
        caseItemsbyEnError = new Map < String, Integer > ();
        caseItemsbyPlatform = new Map < String, Integer > ();
        caseItemsbyLob = new Map < String, Integer > ();
  
      }
    }
  
  }