public without sharing class ADBCallerProfilePopupDetailsWrapper {
    
    @AuraEnabled public String transactionId{ get; set; } 
    @AuraEnabled public String coverageType{ get; set; } 
    @AuraEnabled public String groupNumber{ get; set; } 
    @AuraEnabled public String planName{ get; set; } 
    @AuraEnabled public String insuranceType{ get; set; }     
    @AuraEnabled public String effectiveDate{ get; set; }
    @AuraEnabled public String endDate{ get; set; } 
    @AuraEnabled public String memberId{ get; set; } 
    @AuraEnabled public String gender{ get; set; } 
    @AuraEnabled public String physicianFirstName{ get; set; } 
    @AuraEnabled public String physicianLastName{ get; set; } 
    @AuraEnabled public String memberFirstName{ get; set; } 
    @AuraEnabled public String memberLastName{ get; set; } 
    @AuraEnabled public String MemberDOB{ get; set; } 
    @AuraEnabled public String policyStatus{ get; set; }
    @AuraEnabled public String inMetYtdAmount{ get; set; }
    @AuraEnabled public String outMetYtdAmount{ get; set; }
    @AuraEnabled public String preMetYtdAmount{ get; set; }
    @AuraEnabled public Boolean found{ get; set; }
    @AuraEnabled public String city{ get; set; }
    @AuraEnabled public String zip{ get; set; }
    @AuraEnabled public String state{ get; set; }  
    @AuraEnabled public String addressLine1{ get; set; }  
    @AuraEnabled public String addressLine2{ get; set; } 
    @AuraEnabled public String errorMessage{ get; set; } 
    @AuraEnabled public String payerName{ get; set; }
}