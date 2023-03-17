public without sharing class ADBMedicalClaimRequestWrapper {
    @AuraEnabled public String userId{ get; set; }
    @AuraEnabled public String memberId{ get; set; }
    @AuraEnabled public String policy{ get; set; }
    @AuraEnabled public String firstName{ get; set; }
    @AuraEnabled public String relationship{ get; set; }
    @AuraEnabled public String consumerApplication{ get; set; }
}