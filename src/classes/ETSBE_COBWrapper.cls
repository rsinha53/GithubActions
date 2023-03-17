public class ETSBE_COBWrapper {
    @AuraEnabled public Cob cob {get;set;}
    //US1954477	Targeted COB Details - Integration - 30/09/2019 - Sarma
    @AuraEnabled public List<additionalCoverage> additionalCoverageList {get;set;}
   
      public class Cob{
        @AuraEnabled public String cobLastUpdate {get;set;}
        @AuraEnabled public String cobUpdateMessage {get;set;}
        @AuraEnabled public String cobType {get;set;}
        @AuraEnabled public String medicareIndicator {get;set;} //new
        @AuraEnabled public String otherPrimaryInsurance {get;set;}
        @AuraEnabled public String coverageStartDate {get;set;}
        @AuraEnabled public String coverageEndDate {get;set;}
        // US2122648 Targeted COB Details - Medicare Entitlement Reason Integration - 25/10/2019 - Sarma
        @AuraEnabled public String medicareEntitlementReason {get;set;}
        
          
        public Cob(){}
    }

    //US1954477	Targeted COB Details - Integration - 30/09/2019 - Sarma
    public class additionalCoverage{
        @AuraEnabled public String primaryGroupIndicator {get;set;}
        @AuraEnabled public String policyEffectiveDates {get;set;}
        @AuraEnabled public String payerName {get;set;}
        @AuraEnabled public String coverageType {get;set;}
        // US2138007	Update Logic for Targeted COB - 25/10/2019 - Sarma
        @AuraEnabled public String policyEffectiveStartDate {get;set;}  
        public additionalCoverage(){}
    }
}