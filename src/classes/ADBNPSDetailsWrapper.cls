public without sharing class ADBNPSDetailsWrapper {
    
    // Request parameters for the service
    @AuraEnabled public String memberId{ get; set; }
    
    // Response parameters for the service
    @AuraEnabled public String npsResult;
    @AuraEnabled public String callTimestamp;
     public static ADBNPSDetailsWrapper parse(String json) {
      return (ADBNPSDetailsWrapper) System.JSON.deserialize(json, ADBNPSDetailsWrapper.class);
    } 
}