public class ACETSNIWrapper {
    
     @AuraEnabled public String sniEligibility {get;set;}
     @AuraEnabled public String advisorFullName {get;set;}
     @AuraEnabled public String assignedTo {get;set;}
     @AuraEnabled public String lob {get;set;} //Code added By Chandan -US2776388
     @AuraEnabled public String productTypes {get;set;} //Code added By Chandan -US2776388
     @AuraEnabled public String serviceGroup {get;set;} //Code added By Chandan -US2776388
   
}